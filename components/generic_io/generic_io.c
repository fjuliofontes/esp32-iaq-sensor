#include "generic_io.h"

#include <esp_log.h>
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "driver/gpio.h"

#include "wifi_prov.h"
#include "http_post.h"
#include "bsec_iot_example.h"

TaskHandle_t push_button_task_handler = NULL;
TaskHandle_t blink_task_handler = NULL;

static const char *TAG = "generic-io";

#ifndef ESP_INTR_FLAG_DEFAULT
#define ESP_INTR_FLAG_DEFAULT 0
#endif

static void IRAM_ATTR gpio_isr_handler(void* arg) {
    // notify the button task
    if ((push_button_task_handler != NULL) && (eTaskGetState(push_button_task_handler) == eSuspended) ) {
        xTaskResumeFromISR(push_button_task_handler);
    }
}

void push_button_action(uint32_t pressed_time_ms) {
    // un-provision
    if (pressed_time_ms >= 5000) {
        // erase bme680 state
        state_erase();

        // erase stored measurements 
        http_post_erase();

        if (wifi_unprovision() != pdPASS) {
            ESP_LOGE(TAG,"Error while un-provisioning");
        } else {
            ESP_LOGI(TAG,"Un-provisioned!");
            esp_restart();
        }
    } else {
        // just wake-up and publish 
        http_post_resume();
    }
}

static void push_button_task(void *pvparameters){
    // variables
    int time_counter = 0;

    for (;;) {

        ESP_LOGI(TAG,"button-loop()");

        // debounce time
        vTaskDelay(pdMS_TO_TICKS(100)); // delay 100 ms

        // count the number of seconds with the button pressed
        time_counter = 100; // 100 ms (min)

        while ( gpio_get_level(GPIO_INPUT_SW) == 0 ) {
            time_counter += 10;
            vTaskDelay(pdMS_TO_TICKS(10)); // resolution of 10 ms
        }

        // debounce validator
        if ( time_counter >= 200 ) {
            ESP_LOGI(TAG,"SW pressed for approx: %d ms",time_counter);
            
            push_button_action(time_counter);
        }

        // go back to sleep
        vTaskSuspend(NULL);
    }

    vTaskDelete(NULL);
}

void generic_io_init(void) {

    // Config GPIOs

    //zero-initialize the config structure.
    gpio_config_t io_conf = {};

    // LED
    //disable interrupt
    io_conf.intr_type = GPIO_INTR_DISABLE;
    //set as output mode
    io_conf.mode = GPIO_MODE_OUTPUT;
    //bit mask of the pins that you want to set,e.g.GPIO18/19
    io_conf.pin_bit_mask = GPIO_OUTPUT_PIN_SEL;
    //disable pull-down mode
    io_conf.pull_down_en = 0;
    //disable pull-up mode
    io_conf.pull_up_en = 0;
    //configure GPIO with the given settings
    gpio_config(&io_conf);

    // SW
    //disable interrupt
    io_conf.intr_type = GPIO_INTR_NEGEDGE;
    //set as output mode
    io_conf.mode = GPIO_MODE_INPUT;
    //bit mask of the pins that you want to set,e.g.GPIO18/19
    io_conf.pin_bit_mask = GPIO_INPUT_PIN_SEL;
    //disable pull-down mode
    io_conf.pull_down_en = 0;
    //disable pull-up mode
    io_conf.pull_up_en = 0;
    //configure GPIO with the given settings
    gpio_config(&io_conf);

    // attach isr handler
    gpio_install_isr_service(ESP_INTR_FLAG_DEFAULT);
    gpio_isr_handler_add(GPIO_INPUT_SW, gpio_isr_handler, NULL);

    // turn off led
    turn_light_off();

    xTaskCreate(&push_button_task, "push_button_task", 2048, NULL, 5, &push_button_task_handler);
}

static void blink_task(void *pvparameters) {

    int blink_period_ms = (int) pvparameters;

    for (;;) {
        turn_light_on();
        vTaskDelay(pdMS_TO_TICKS(blink_period_ms));
        turn_light_off();
        vTaskDelay(pdMS_TO_TICKS(blink_period_ms));
    }

    vTaskDelete(NULL);
}

void turn_light_on(void) {
    gpio_set_level(GPIO_OUTPUT_LED, 1);
}

void turn_light_off(void) {
    gpio_set_level(GPIO_OUTPUT_LED, 0);
}

int create_blink_task(int blink_period_ms) {
    if ( xTaskCreate(&blink_task, "blink_task", 1024, ( void * ) blink_period_ms, 3, &blink_task_handler) != pdPASS ) {
        return pdFAIL;
    } 
    return pdPASS;
}