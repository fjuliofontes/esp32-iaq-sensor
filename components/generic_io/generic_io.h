#ifndef GENERIC_IO_
#define GENERIC_IO_

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
// #include "driver/gpio.h"

#define GPIO_OUTPUT_LED    14
#define GPIO_OUTPUT_PIN_SEL  ((1ULL<<GPIO_OUTPUT_LED))

#define GPIO_INPUT_SW   13
#define GPIO_INPUT_PIN_SEL  ((1ULL<<GPIO_INPUT_SW))

void generic_io_init(void);
void turn_light_on(void);
void turn_light_off(void);
int create_blink_task(int blink_period_ms);

#endif