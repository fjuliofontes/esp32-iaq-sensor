/***********************************************************************************************************************
 *
 * @file    main.c
 * @brief   ESP32 BME680 IAQ SENSOR BASED
 *          DEEP SLEEP ENABLED
 *          BLE PROVISION
 * @date    27/10/2024
 * @author  Fernando Fontes
 * @note    Platform Target: ESP32-WROOM-32D
 *          Currently there is a bug on the BLE Prov implementation
 *          To make it work go to: esp32-hal-misc.c and comment the line 268:
 *              // esp_bt_controller_mem_release(ESP_BT_MODE_BTDM);
 *          WiFi networks are also not showing so it's required to insert it manually
 *
 * TAB SIZE: 4 SPACES
 *
 ***********************************************************************************************************************/

/****************************************************** Includes ******************************************************/
/* General includes. */
#include <stdint.h>
#include <Arduino.h>
#include <bsec.h>
#include <sys/time.h>

#include "WiFiProv.h"
#include "WiFi.h"
#include <HTTPClient.h>
#include "secrets.h"
#include <esp_wifi.h>

#if !defined(CONFIG_BT_ENABLED) || !defined(CONFIG_BLUEDROID_ENABLED)
#error Bluetooth is not enabled! Please run `make menuconfig` to and enable it
#endif

/****************************************************** Defines *******************************************************/
#define LOG(fmt, ...) (Serial.printf("%09llu: " fmt "\n", GetTimestamp(), ##__VA_ARGS__))
#define GENERIC_LED_IO 14
#define GENERIC_SW_IO 13
#define TIMEOUT_FOR_WAITING_WIFI_CONNECTION_MSEC (0.5 * 60 * 1000) // 30 sec
#define TIMEOUT_FOR_WAITING_PROVISION_MSEC (2 * 60 * 1000)         // 2 min

#define STR_LEN(x) (sizeof(x) - 1)
#define IS_NUMBER(x) ((x >= 48) && (x <= 57))

#define MEASURE_WEB_ENDPOINT_LEN STR_LEN(SERVER_HOST "/api/posts/measure/FFCC00112233")
#define MEASURE_WEB_ENDPOINT_PREFIX (SERVER_HOST "/api/posts/measure/%02X%02X%02X%02X%02X%02X")

/****************************************************** Typedefs ******************************************************/
typedef struct
{
    float temperature;
    float humidity;
    float pressure;
    float iaq;
    float co2e;
    float voce;
} bsec_results_t;

typedef enum
{
    WIFI_PROV_UNKNOWN = 0,
    WIFI_PROV_PROVISIONED,
    WIFI_PROV_UNPROVISIONED
} wifi_prov_status_t;

/***************************************************** Constants ******************************************************/
/* Configure the BSEC library with information about the sensor
    18v/33v = Voltage at Vdd. 1.8V or 3.3V
    3s/300s = BSEC operating mode, BSEC_SAMPLE_RATE_LP or BSEC_SAMPLE_RATE_ULP
    4d/28d = Operating age of the sensor in days
    generic_18v_3s_4d
    generic_18v_3s_28d
    generic_18v_300s_4d
    generic_18v_300s_28d
    generic_33v_3s_4d
    generic_33v_3s_28d
    generic_33v_300s_4d
    generic_33v_300s_28d
*/
const uint8_t bsec_config_iaq[] = {
#include "config/generic_33v_300s_4d/bsec_iaq.txt"
};

const char *pop = "iaq123";
const char *service_key = NULL;

const String serverName = "http://192.168.1.106:1880/update-sensor";

/***************************************************** Variables ******************************************************/
Bsec sensor;

RTC_DATA_ATTR uint8_t sensor_state[BSEC_MAX_STATE_BLOB_SIZE] = {0};
RTC_DATA_ATTR int64_t sensor_state_time = 0;
RTC_DATA_ATTR uint64_t time_us = 0;
RTC_DATA_ATTR bsec_results_t last_results = {0};
RTC_DATA_ATTR wifi_prov_status_t wifi_prov_status = WIFI_PROV_UNKNOWN;

bsec_virtual_sensor_t sensor_list[] = {
    BSEC_OUTPUT_SENSOR_HEAT_COMPENSATED_TEMPERATURE,
    BSEC_OUTPUT_RAW_PRESSURE,
    BSEC_OUTPUT_SENSOR_HEAT_COMPENSATED_HUMIDITY,
    BSEC_OUTPUT_IAQ,
    BSEC_OUTPUT_CO2_EQUIVALENT,
    BSEC_OUTPUT_BREATH_VOC_EQUIVALENT,
};

static bool reset_provisioned = false;
static volatile bool wifi_connected = false;

/*********************************************** Internal Declarations ************************************************/
static int64_t GetTimestamp(void);
static bool CheckSensor(void);
static void DumpState(const char *name, const uint8_t *state);
static void handleWakeup(void);
static void SysProvEvent(arduino_event_t *sys_event);
static void PublishBSEC(bsec_results_t results);

/***************************************************** Functions ******************************************************/
void setup()
{
    Serial.begin(115200);
    delay(3000);

    // wifi callback
    WiFi.onEvent(SysProvEvent);

    // GPIOs
    pinMode(GENERIC_LED_IO, OUTPUT);
    digitalWrite(GENERIC_LED_IO, LOW);
    pinMode(GENERIC_SW_IO, INPUT);

    handleWakeup();

    sensor.begin(BME68X_I2C_ADDR_HIGH, Wire);
    if (!CheckSensor())
    {
        LOG("Failed to init BME680, check wiring!");
        return;
    }

    LOG("BSEC version %d.%d.%d.%d", sensor.version.major, sensor.version.minor, sensor.version.major_bugfix, sensor.version.minor_bugfix);

    sensor.setConfig(bsec_config_iaq);
    if (!CheckSensor())
    {
        LOG("Failed to set config!");
        return;
    }

    if (sensor_state_time)
    {
        DumpState("setState", sensor_state);
        sensor.setState(sensor_state);
        if (!CheckSensor())
        {
            LOG("Failed to set state!");
            return;
        }
        else
        {
            LOG("Successfully set state from %lld", sensor_state_time);
        }
    }
    else
    {
        LOG("Saved state missing");
    }

    sensor.updateSubscription(sensor_list, sizeof(sensor_list) / sizeof(sensor_list[0]), BSEC_SAMPLE_RATE_ULP);
    if (!CheckSensor())
    {
        LOG("Failed to update subscription!");
        return;
    }

    LOG("Sensor init done");
}

void loop()
{
    if (sensor.run())
    {
        LOG("Temperature compensated %.2f", sensor.temperature);
        LOG("Humidity compensated %.2f", sensor.humidity);
        LOG("Pressure %.2f kPa", sensor.pressure / 1000);
        LOG("IAQ %.2f", sensor.iaq);
        LOG("CO2e %.2f PPM", sensor.co2Equivalent);
        LOG("VOCe %.2f PPM", sensor.breathVocEquivalent);

        last_results.temperature = sensor.temperature;
        last_results.humidity = sensor.humidity;
        last_results.pressure = sensor.pressure;
        last_results.iaq = sensor.iaq;
        last_results.co2e = sensor.co2Equivalent;
        last_results.voce = sensor.breathVocEquivalent;

        if (wifi_prov_status == WIFI_PROV_PROVISIONED || wifi_prov_status == WIFI_PROV_UNKNOWN)
        {
            LOG("Waiting WiFi connection");
            WiFiProv.beginProvision(WIFI_PROV_SCHEME_BLE, WIFI_PROV_SCHEME_HANDLER_FREE_BTDM, WIFI_PROV_SECURITY_1, pop, NULL, service_key, NULL, reset_provisioned);

            int buckets_to_wait = TIMEOUT_FOR_WAITING_WIFI_CONNECTION_MSEC / 100;
            while (!wifi_connected && (buckets_to_wait-- > 0))
            {
                delay(100);
                Serial.printf(".");
            }

            if (wifi_connected)
            {
                PublishBSEC(last_results);

                // Disconnect to ensure smooth connection next time
                WiFi.disconnect(true);
                delay(100);
            }
        }

        sensor_state_time = GetTimestamp();
        sensor.getState(sensor_state);
        DumpState("getState", sensor_state);
        LOG("Saved state to RTC memory at %lld", sensor_state_time);
        CheckSensor();

        time_us = (sensor.nextCall * 1000) - esp_timer_get_time();
        LOG("Deep sleep for %llu ms. BSEC next call at %llu ms.", time_us / 1000, sensor.nextCall);
        esp_sleep_enable_timer_wakeup(time_us);
        esp_sleep_enable_ext0_wakeup((gpio_num_t)GENERIC_SW_IO, 0);
        esp_deep_sleep_start();
    }
}

/************************************************* Internal Functions *************************************************/
/**
 *
 * @brief   This is a brief description of the function.
 * @param   first_param  Describe here what the parameter is.
 * @note    Note about the first_param.
 * @param   second_param Describe here what the parameter is.
 * @return  Returns the uint32_t value which refers to something.
 *
 **/
static int64_t GetTimestamp(void)
{
    struct timeval tv;
    gettimeofday(&tv, NULL);
    return (tv.tv_sec * 1000LL + (tv.tv_usec / 1000LL));
}

/**
 *
 * @brief   This is a brief description of the function.
 * @param   first_param  Describe here what the parameter is.
 * @note    Note about the first_param.
 * @param   second_param Describe here what the parameter is.
 * @return  Returns the uint32_t value which refers to something.
 *
 **/
static bool CheckSensor(void)
{
    if (sensor.bsecStatus < BSEC_OK)
    {
        LOG("BSEC error, status %d!", sensor.bsecStatus);
        return false;
        ;
    }
    else if (sensor.bsecStatus > BSEC_OK)
    {
        LOG("BSEC warning, status %d!", sensor.bsecStatus);
    }

    if (sensor.bme68xStatus < BME68X_OK)
    {
        LOG("Sensor error, bme680_status %d!", sensor.bme68xStatus);
        return false;
    }
    else if (sensor.bme68xStatus > BME68X_OK)
    {
        LOG("Sensor warning, status %d!", sensor.bme68xStatus);
    }

    return true;
}

/**
 *
 * @brief   This is a brief description of the function.
 * @param   first_param  Describe here what the parameter is.
 * @note    Note about the first_param.
 * @param   second_param Describe here what the parameter is.
 * @return  Returns the uint32_t value which refers to something.
 *
 **/
static void DumpState(const char *name, const uint8_t *state)
{
    LOG("%s:", name);
    for (int i = 0; i < BSEC_MAX_STATE_BLOB_SIZE; i++)
    {
        Serial.printf("%02x ", state[i]);
        if (i % 16 == 15)
        {
            Serial.print("\n");
        }
    }
    Serial.print("\n");
}

/**
 *
 * @brief   This is a brief description of the function.
 * @param   first_param  Describe here what the parameter is.
 * @note    Note about the first_param.
 * @param   second_param Describe here what the parameter is.
 * @return  Returns the uint32_t value which refers to something.
 *
 **/
static void handleWakeup(void)
{
    esp_sleep_wakeup_cause_t wakeup_reason = esp_sleep_get_wakeup_cause();
    if (wakeup_reason == ESP_SLEEP_WAKEUP_TIMER)
    {
        LOG("Woke up from timer.");
    }
    else if (wakeup_reason == ESP_SLEEP_WAKEUP_EXT0)
    {
        LOG("Woke up from GPIO.");

        LOG("Temperature compensated %.2f", last_results.temperature);
        LOG("Humidity compensated %.2f", last_results.humidity);
        LOG("Pressure %.2f kPa", last_results.pressure / 1000);
        LOG("IAQ %.2f", last_results.iaq);
        LOG("CO2e %.2f PPM", last_results.co2e);
        LOG("VOCe %.2f PPM", last_results.voce);

        int buckets_to_wait;
        bool status = false;
        if (wifi_prov_status == WIFI_PROV_PROVISIONED)
        {
            LOG("Connecting to WiFi");
            buckets_to_wait = TIMEOUT_FOR_WAITING_WIFI_CONNECTION_MSEC / 100;
        }
        else
        {
            LOG("Starting provision via BLE");
            buckets_to_wait = TIMEOUT_FOR_WAITING_PROVISION_MSEC / 100;
        }
        WiFiProv.beginProvision(WIFI_PROV_SCHEME_BLE, WIFI_PROV_SCHEME_HANDLER_FREE_BTDM, WIFI_PROV_SECURITY_1, pop, NULL, service_key, NULL, reset_provisioned);

        while (!wifi_connected && (buckets_to_wait-- > 0))
        {
            delay(100);
            Serial.printf(".");
            if (status)
            {
                digitalWrite(GENERIC_LED_IO, HIGH);
            }
            else
            {
                digitalWrite(GENERIC_LED_IO, LOW);
            }
            status = !status;
        }

        if (wifi_connected)
        {
            PublishBSEC(last_results);

            // Disconnect to ensure smooth connection next time
            WiFi.disconnect(true);
            delay(100);
        }

        // turn off the led
        digitalWrite(GENERIC_LED_IO, LOW);

        int64_t sleep_time = GetTimestamp() - sensor_state_time;
        if ((sleep_time * 1000) < time_us)
        {
            uint64_t remaining_time_us = time_us - (sleep_time * 1000);
            LOG("Going back to sleep for remaining time: %llu ms", remaining_time_us / 1000);
            esp_sleep_enable_timer_wakeup(remaining_time_us);
            esp_sleep_enable_ext0_wakeup((gpio_num_t)GENERIC_SW_IO, 0);
            esp_deep_sleep_start();
        }
    }
    else
    {
        LOG("Woke up no cause.");
    }
}

/**
 *
 * @brief   This is a brief description of the function.
 * @param   first_param  Describe here what the parameter is.
 * @note    Note about the first_param.
 * @param   second_param Describe here what the parameter is.
 * @return  Returns the uint32_t value which refers to something.
 *
 **/
static void SysProvEvent(arduino_event_t *sys_event)
{
    switch (sys_event->event_id)
    {
    case ARDUINO_EVENT_WIFI_STA_GOT_IP:
        Serial.print("\nConnected IP address : ");
        Serial.println(IPAddress(sys_event->event_info.got_ip.ip_info.ip.addr));
        wifi_connected = true;
        wifi_prov_status = WIFI_PROV_PROVISIONED;
        break;
    case ARDUINO_EVENT_WIFI_STA_DISCONNECTED:
        Serial.println("\nDisconnected. Connecting to the AP again... ");
        wifi_connected = false;
        break;
    case ARDUINO_EVENT_PROV_START:
        Serial.println("\nProvisioning started\nGive Credentials of your access point using smartphone app");
        wifi_prov_status = WIFI_PROV_UNPROVISIONED;
        break;
    case ARDUINO_EVENT_PROV_CRED_RECV:
    {
        Serial.println("\nReceived Wi-Fi credentials");
        Serial.print("\tSSID : ");
        Serial.println((const char *)sys_event->event_info.prov_cred_recv.ssid);
        Serial.print("\tPassword : ");
        Serial.println((char const *)sys_event->event_info.prov_cred_recv.password);
        break;
    }
    case ARDUINO_EVENT_PROV_CRED_FAIL:
    {
        Serial.println("\nProvisioning failed!\nPlease reset to factory and retry provisioning\n");
        if (sys_event->event_info.prov_fail_reason == WIFI_PROV_STA_AUTH_ERROR)
            Serial.println("\nWi-Fi AP password incorrect");
        else
            Serial.println("\nWi-Fi AP not found....Add API \" nvs_flash_erase() \" before beginProvision()");
        break;
    }
    case ARDUINO_EVENT_PROV_CRED_SUCCESS:
        Serial.println("\nProvisioning Successful");
        wifi_prov_status = WIFI_PROV_PROVISIONED;
        break;
    case ARDUINO_EVENT_PROV_END:
        Serial.println("\nProvisioning Ends");
        break;
    default:
        break;
    }
}

/**
 *
 * @brief   This is a brief description of the function.
 * @param   first_param  Describe here what the parameter is.
 * @note    Note about the first_param.
 * @param   second_param Describe here what the parameter is.
 * @return  Returns the uint32_t value which refers to something.
 *
 **/
static void PublishBSEC(bsec_results_t results)
{
    uint8_t baseMac[6];
    esp_err_t ret = esp_wifi_get_mac(WIFI_IF_STA, baseMac);
    if (ret == ESP_OK)
    {
        char measure_web_endpoint[MEASURE_WEB_ENDPOINT_LEN] = {'\0'};
        snprintf(measure_web_endpoint, sizeof(measure_web_endpoint), MEASURE_WEB_ENDPOINT_PREFIX,
                 baseMac[0],
                 baseMac[1],
                 baseMac[2],
                 baseMac[3],
                 baseMac[4],
                 baseMac[5]);

        WiFiClient client;
        HTTPClient http;

        Serial.printf("Trying to connect to: %s\n", measure_web_endpoint);

        if (http.begin(client, String(measure_web_endpoint)))
        {
            char data[255] = {'\0'};
            http.addHeader("Content-Type", "application/json");
            snprintf(data, sizeof(data), "{\"t\":%.2f,\"h\":%.2f,\"p\":%.2f,\"iaq\":%.2f,\"co2e\":%.2f,\"voce\":%.2f}",
                     results.temperature,
                     results.humidity,
                     results.pressure / 1000,
                     results.iaq,
                     results.co2e,
                     results.voce);
            Serial.printf("Trying to publish: %s\n", data);
            int httpResponseCode = http.POST(String(data));
            Serial.printf("Return code: %d\n", httpResponseCode);
        }
        else
        {
            Serial.printf("Failed to connect\n");
        }

        // free resources
        http.end();
    }
}