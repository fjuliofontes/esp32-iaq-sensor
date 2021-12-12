/*
 * Copyright (C) 2017 Robert Bosch. All Rights Reserved. 
 *
 * Disclaimer
 *
 * Common:
 * Bosch Sensortec products are developed for the consumer goods industry. They may only be used
 * within the parameters of the respective valid product data sheet.  Bosch Sensortec products are
 * provided with the express understanding that there is no warranty of fitness for a particular purpose.
 * They are not fit for use in life-sustaining, safety or security sensitive systems or any system or device
 * that may lead to bodily harm or property damage if the system or device malfunctions. In addition,
 * Bosch Sensortec products are not fit for use in products which interact with motor vehicle systems.
 * The resale and/or use of products are at the purchasers own risk and his own responsibility. The
 * examination of fitness for the intended use is the sole responsibility of the Purchaser.
 *
 * The purchaser shall indemnify Bosch Sensortec from all third party claims, including any claims for
 * incidental, or consequential damages, arising from any product use not covered by the parameters of
 * the respective valid product data sheet or not approved by Bosch Sensortec and reimburse Bosch
 * Sensortec for all costs in connection with such claims.
 *
 * The purchaser must monitor the market for the purchased products, particularly with regard to
 * product safety and inform Bosch Sensortec without delay of all security relevant incidents.
 *
 * Engineering Samples are marked with an asterisk (*) or (e). Samples may vary from the valid
 * technical specifications of the product series. They are therefore not intended or fit for resale to third
 * parties or for use in end products. Their sole purpose is internal client testing. The testing of an
 * engineering sample may in no way replace the testing of a product series. Bosch Sensortec
 * assumes no liability for the use of engineering samples. By accepting the engineering samples, the
 * Purchaser agrees to indemnify Bosch Sensortec from all claims arising from the use of engineering
 * samples.
 *
 * Special:
 * This software module (hereinafter called "Software") and any information on application-sheets
 * (hereinafter called "Information") is provided free of charge for the sole purpose to support your
 * application work. The Software and Information is subject to the following terms and conditions:
 *
 * The Software is specifically designed for the exclusive use for Bosch Sensortec products by
 * personnel who have special experience and training. Do not use this Software if you do not have the
 * proper experience or training.
 *
 * This Software package is provided `` as is `` and without any expressed or implied warranties,
 * including without limitation, the implied warranties of merchantability and fitness for a particular
 * purpose.
 *
 * Bosch Sensortec and their representatives and agents deny any liability for the functional impairment
 * of this Software in terms of fitness, performance and safety. Bosch Sensortec and their
 * representatives and agents shall not be liable for any direct or indirect damages or injury, except as
 * otherwise stipulated in mandatory applicable law.
 *
 * The Information provided is believed to be accurate and reliable. Bosch Sensortec assumes no
 * responsibility for the consequences of use of such Information nor for any infringement of patents or
 * other rights of third parties which may result from its use. No license is granted by implication or
 * otherwise under any patent or patent rights of Bosch. Specifications mentioned in the Information are
 * subject to change without notice.
 *
 * It is not allowed to deliver the source code of the Software to any third party without permission of
 * Bosch Sensortec.
 *
 */

/*!
 * @file bsec_iot_example.c
 *
 * @brief
 * Example for using of BSEC library in a fixed configuration with the BME680 sensor.
 * This works by running an endless loop in the bsec_iot_loop() function.
 */

/*!
 * @addtogroup bsec_examples BSEC Examples
 * @brief BSEC usage examples
 * @{*/

/**********************************************************************************************************************/
/* header files */
/**********************************************************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>

#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "esp_err.h"
#include "esp_system.h"
#include "nvs_flash.h"
#include "nvs.h"
#include "esp_log.h"
#include "driver/i2c.h"

#include "bsec_integration.h"
#include "bsec_iot_example.h"
#include "bsec_serialized_configurations_iaq.h"

#include "http_post.h"

#define STORAGE_NAMESPACE "bsec-storage"
static const char *TAG = "bsec_iot_example";

#define I2C_MASTER_SCL_IO           22      /*!< GPIO number used for I2C master clock */
#define I2C_MASTER_SDA_IO           21      /*!< GPIO number used for I2C master data  */
#define I2C_MASTER_NUM              0                          /*!< I2C master i2c port number, the number of i2c peripheral interfaces available will depend on the chip */
#define I2C_MASTER_FREQ_HZ          400000                     /*!< I2C master clock frequency */
#define I2C_MASTER_TX_BUF_DISABLE   0                          /*!< I2C master doesn't need buffer */
#define I2C_MASTER_RX_BUF_DISABLE   0                          /*!< I2C master doesn't need buffer */
#define I2C_MASTER_TIMEOUT_MS       1000

#define PUBLISHER_THRESHOLD 6 // every 6 readings - 5 * 6 = 30 min

/**********************************************************************************************************************/
/* functions */
/**********************************************************************************************************************/

/**
 * @brief i2c master initialization
 */
static esp_err_t i2c_master_init(void)
{
    int i2c_master_port = I2C_MASTER_NUM;

    i2c_config_t conf = {
        .mode = I2C_MODE_MASTER,
        .sda_io_num = I2C_MASTER_SDA_IO,
        .scl_io_num = I2C_MASTER_SCL_IO,
        .sda_pullup_en = GPIO_PULLUP_ENABLE,
        .scl_pullup_en = GPIO_PULLUP_ENABLE,
        .master.clk_speed = I2C_MASTER_FREQ_HZ,
    };

    i2c_param_config(i2c_master_port, &conf);

    return i2c_driver_install(i2c_master_port, conf.mode, I2C_MASTER_RX_BUF_DISABLE, I2C_MASTER_TX_BUF_DISABLE, 0);
}

/*!
 * @brief           Write operation in either I2C or SPI
 *
 * param[in]        dev_addr        I2C or SPI device address
 * param[in]        reg_addr        register address
 * param[in]        reg_data_ptr    pointer to the data to be written
 * param[in]        data_len        number of bytes to be written
 *
 * @return          result of the bus communication function
 */
int8_t bus_write(uint8_t dev_addr, uint8_t reg_addr, uint8_t *reg_data_ptr, uint16_t data_len)
{
    // ...
    // Please insert system specific function to write to the bus where BME680 is connected
    // ...
    uint8_t write_buf[1+data_len];
    memset(write_buf,0,sizeof(write_buf));

    write_buf[0] = reg_addr;

    memcpy(&write_buf[1],reg_data_ptr,data_len*sizeof(uint8_t));

    return i2c_master_write_to_device(I2C_MASTER_NUM, dev_addr, write_buf, sizeof(write_buf), I2C_MASTER_TIMEOUT_MS / portTICK_RATE_MS);     
}

/*!
 * @brief           Read operation in either I2C or SPI
 *
 * param[in]        dev_addr        I2C or SPI device address
 * param[in]        reg_addr        register address
 * param[out]       reg_data_ptr    pointer to the memory to be used to store the read data
 * param[in]        data_len        number of bytes to be read
 *
 * @return          result of the bus communication function
 */
int8_t bus_read(uint8_t dev_addr, uint8_t reg_addr, uint8_t *reg_data_ptr, uint16_t data_len)
{
    // ...
    // Please insert system specific function to read from bus where BME680 is connected
    // ...
    return i2c_master_write_read_device(I2C_MASTER_NUM, dev_addr, &reg_addr, 1, reg_data_ptr, data_len, I2C_MASTER_TIMEOUT_MS / portTICK_RATE_MS);
}

/*!
 * @brief           System specific implementation of sleep function
 *
 * @param[in]       t_ms    time in milliseconds
 *
 * @return          none
 */
void custom_sleep(uint32_t t_ms)
{
    vTaskDelay(pdMS_TO_TICKS(t_ms));
}

/*!
 * @brief           Capture the system time in microseconds
 *
 * @return          system_current_time    current system timestamp in microseconds
 */
int64_t get_timestamp_us()
{
    int64_t system_current_time = esp_timer_get_time();
    // ...
    // Please insert system specific function to retrieve a timestamp (in microseconds)
    // ...
    return system_current_time;
}

/*!
 * @brief           Handling of the ready outputs
 *
 * @param[in]       timestamp       time in nanoseconds
 * @param[in]       iaq             IAQ signal
 * @param[in]       iaq_accuracy    accuracy of IAQ signal
 * @param[in]       temperature     temperature signal
 * @param[in]       humidity        humidity signal
 * @param[in]       pressure        pressure signal
 * @param[in]       raw_temperature raw temperature signal
 * @param[in]       raw_humidity    raw humidity signal
 * @param[in]       gas             raw gas sensor signal
 * @param[in]       bsec_status     value returned by the bsec_do_steps() call
 *
 * @return          none
 */
void output_ready(int64_t timestamp, float iaq, uint8_t iaq_accuracy, float temperature, float humidity,
     float pressure, float raw_temperature, float raw_humidity, float gas, bsec_library_return_t bsec_status,
     float static_iaq, float co2_equivalent, float breath_voc_equivalent)
{
    static int message_counter = 0;

    if (bsec_status != BSEC_OK) {
        ESP_LOGE(TAG,"BME680 error. Restarting.");
        vTaskDelay(pdMS_TO_TICKS(100));
        esp_restart();
    }

    message_t message = {
        .timestamp = esp_timer_get_time() / 1000,
        .accuracy = iaq_accuracy,
        .bme_co2 = co2_equivalent,
        .bme_evoc = breath_voc_equivalent,
        .bme_humi = humidity,
        .bme_press = pressure,
        .bme_temp = temperature,
        .bme_iaq = iaq
    };

    https_post_add_message(message);

    ESP_LOGI(TAG,"temperature %.2f humidity %.2f pressure %.2f iaq %.2f",temperature,humidity,pressure,iaq);

    if (++message_counter >= PUBLISHER_THRESHOLD) {
        // restart counter
        message_counter = 0;
        // publish 
        http_post_resume();
    }
    
    // ...
    // Please insert system specific code to further process or display the BSEC outputs
    // ...
}

/*!
 * @brief           Load previous library state from non-volatile memory
 *
 * @param[in,out]   state_buffer    buffer to hold the loaded state string
 * @param[in]       n_buffer        size of the allocated state buffer
 *
 * @return          number of bytes copied to state_buffer
 */
uint32_t state_load(uint8_t *state_buffer, uint32_t n_buffer)
{
    // ...
    // Load a previous library state from non-volatile memory, if available.
    //
    // Return zero if loading was unsuccessful or no state was available, 
    // otherwise return length of loaded state string.
    // ...
    nvs_handle my_handle;
    esp_err_t err;

    // Open
    err = nvs_open(STORAGE_NAMESPACE, NVS_READWRITE, &my_handle);
    if (err != ESP_OK) return 0;

    // Read run time blob
    size_t required_size = 0;  // value will default to 0, if not set yet in NVS
    // obtain required memory space to store blob being read from NVS
    err = nvs_get_blob(my_handle, "state", NULL, &required_size);
    if (err != ESP_OK && err != ESP_ERR_NVS_NOT_FOUND) return 0;
    
    // read from nvs
    if (required_size == 0) {
        ESP_LOGI(TAG,"Nothing saved yet!");
    } else if (required_size <= n_buffer) {
        ESP_LOGI(TAG,"Loading %d bytes",required_size);

        err = nvs_get_blob(my_handle, "state", state_buffer, &required_size);
        if (err != ESP_OK) return 0;
        for (int i = 0; i < required_size; i++) {
            ESP_LOGI(TAG,"%d: %d", i + 1, state_buffer[i]);
        }
    }

    // Close
    nvs_close(my_handle);

    return required_size;
}

/*!
 * @brief           Save library state to non-volatile memory
 *
 * @param[in]       state_buffer    buffer holding the state to be stored
 * @param[in]       length          length of the state string to be stored
 *
 * @return          none
 */
void state_save(const uint8_t *state_buffer, uint32_t length)
{
    // ...
    // Save the string some form of non-volatile memory, if possible.
    // ...
    nvs_handle my_handle;
    esp_err_t err;

    ESP_LOGI(TAG,"Going to save state.");

    // Open
    err = nvs_open(STORAGE_NAMESPACE, NVS_READWRITE, &my_handle);
    if (err != ESP_OK) return;

    // set
    err = nvs_set_blob(my_handle, "state", state_buffer, length);
    if (err != ESP_OK) return;

    // Commit
    err = nvs_commit(my_handle);
    if (err != ESP_OK) return;

    // close
    nvs_close(my_handle);
}
 
/*!
 * @brief           Load library config from non-volatile memory
 *
 * @param[in,out]   config_buffer    buffer to hold the loaded state string
 * @param[in]       n_buffer        size of the allocated state buffer
 *
 * @return          number of bytes copied to config_buffer
 */
uint32_t config_load(uint8_t **config_buffer, uint32_t n_buffer)
{
    // ...
    // Load a library config from non-volatile memory, if available.
    //
    // Return zero if loading was unsuccessful or no config was available, 
    // otherwise return length of loaded config string.
    // ...
    ESP_LOGI(TAG,"config_load");
    *config_buffer = (uint8_t*)bsec_config_iaq;
    return sizeof(bsec_config_iaq);
}

void bsec_iot_example_loop(void *pvparameters) {

    /* Call to endless loop function which reads and processes data based on sensor settings */
    /* State is saved every 48 samples, which means every 48 * 5 min = 240 minutes  */
    bsec_iot_loop(custom_sleep, get_timestamp_us, output_ready, state_save, 48);
    
    // go back to sleep
    vTaskDelete(NULL);
}

/*!
 * @brief       Main function which configures BSEC library and then reads and processes the data from sensor based
 *              on timer ticks
 *
 * @return      result of the processing
 */
int bsec_iot_example_init(void)
{
    ESP_LOGI(TAG,"going to init bme680");

    ESP_ERROR_CHECK(i2c_master_init());
    ESP_LOGI(TAG, "I2C initialized successfully");

    return_values_init ret;
    
    /* Call to the function which initializes the BSEC library 
     * Switch on low-power mode and provide no temperature offset */
    ret = bsec_iot_init(BSEC_SAMPLE_RATE_ULP, 1.0f, bus_write, bus_read, custom_sleep, state_load, config_load);
    
    if (ret.bme680_status)
    {
        /* Could not intialize BME680 */
        ESP_LOGE(TAG,"Could not intialize BME680 %d",(int)ret.bme680_status);
        return pdFAIL;
    }
    else if (ret.bsec_status)
    {
        /* Could not intialize BSEC library */
        ESP_LOGE(TAG,"Could not intialize BSEC library %d",(int)ret.bsec_status);
        return pdFAIL;
    }

    if ( xTaskCreate(&bsec_iot_example_loop, "bsec_iot_example_loop", 10000, NULL, 5, NULL) != pdPASS ) {
        return pdFAIL;
    } 

    return pdPASS;
}

/*! @}*/

