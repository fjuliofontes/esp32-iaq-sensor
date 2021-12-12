/* FreeRTOS Real Time Stats Example

   This example code is in the Public Domain (or CC0 licensed, at your option.)

   Unless required by applicable law or agreed to in writing, this
   software is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
   CONDITIONS OF ANY KIND, either express or implied.
*/

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

#include "wifi_prov.h"
#include "bsec_iot_example.h"
#include "http_post.h"
#include "generic_io.h"

static const char *TAG = "main";

static void init_sntp(void) {
    sntp_setoperatingmode(SNTP_OPMODE_POLL);
    sntp_setservername(0, "pool.ntp.org");
    sntp_setservername(1, "pt.pool.ntp.org");
    sntp_init();
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

void app_main(void)
{
    // Init NVS
    init_nvs();

    // init gpios
    generic_io_init();

    // wait until provisioned
    wifi_prov_init();

    // init sntp
    init_sntp();

    // init bme680
    if ( bsec_iot_example_init() != pdPASS ){
        ESP_LOGE(TAG,"Error while initing bme680");
    }

    // init http post
    if ( http_post_init() != pdPASS ){
        ESP_LOGE(TAG,"Error while initing http_post");
    }
}
