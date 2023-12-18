/***********************************************************************************************************************
 * 
 * @file    main.c
 * @brief   Main Source File.
 * @date    26/12/2022
 * @author  Fernando Fontes
 * @note    Platform Target: ESP32-WROOM-32D
 *
 * TAB SIZE: 4 SPACES
 *
***********************************************************************************************************************/

/****************************************************** Includes ******************************************************/
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "freertos/semphr.h"
#include "esp_err.h"
#include "driver/gpio.h"
#include <nvs_flash.h>
#include <time.h>
#include <sys/time.h>
#include "esp_sntp.h"
#include "esp_log.h"
#include "esp_sleep.h"

#include "wifi_prov.h"
#include "bsec_iot_example.h"
// #include "http_post.h"
#include "generic_io.h"

/****************************************************** Defines *******************************************************/

/****************************************************** Typedefs ******************************************************/

/***************************************************** Constants ******************************************************/
static const char *TAG = "main";

/***************************************************** Variables ******************************************************/

/*********************************************** Internal Declarations ************************************************/
static void init_sntp(void);
static void init_nvs(void);

/***************************************************** Functions ******************************************************/
void app_main(void)
{
    // Init NVS
    init_nvs();

    // init gpios
    generic_io_init();

    // enter deep sleep
    esp_deep_sleep_start();

    // wait until provisioned
    wifi_prov_start();

    // init sntp
    // init_sntp();

    // init bme680
    if ( bsec_iot_example_init() != pdPASS ){
        ESP_LOGE(TAG,"Error while initing bme680");
    }

    // // init http post
    // if ( http_post_init() != pdPASS ){
    //     ESP_LOGE(TAG,"Error while initing http_post");
    // }
}

/************************************************* Internal Functions *************************************************/
static void init_sntp(void) {
    esp_sntp_setoperatingmode(ESP_SNTP_OPMODE_POLL);
    esp_sntp_setservername(0, "pool.ntp.org");
    esp_sntp_setservername(1, "pt.pool.ntp.org");
    esp_sntp_init();
}

static void init_nvs(void) {
    esp_err_t ret = nvs_flash_init();
    if (ret == ESP_ERR_NVS_NO_FREE_PAGES || ret == ESP_ERR_NVS_NEW_VERSION_FOUND) {
        /* NVS partition was truncated
         * and needs to be erased */
        ESP_ERROR_CHECK(nvs_flash_erase());

        /* Retry nvs_flash_init */
        ESP_ERROR_CHECK(nvs_flash_init());
    }
}