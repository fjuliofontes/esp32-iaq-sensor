#ifndef HTTP_POST_H_
#define HTTP_POST_H_

#include <stdint.h>

typedef struct {
    float bme_temp;
    float bme_humi;
    float bme_co2;
    float bme_evoc;
    float bme_iaq;
    float bme_press;
    uint8_t accuracy;
    uint32_t timestamp;
} message_t;

int http_post_init(void);

void https_post_add_message(message_t message);

void http_post_resume(void);

#endif