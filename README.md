# ESP32 Indoor-Air-Quality monitor based on BME680

## How to use

### Software Required

ESP-IDF

### Hardware Required

This example should be able to run on any commonly available ESP32 development board. However feel free to use the kicad-design-files to replicate the final board.

### Configure the project

Set your firebase configuration in:
```
components/https_post/firebase_conf.h
```

### Build and Flash

Build the project and flash it to the board, then run monitor tool to view serial output:

```
idf.py -p PORT flash monitor
```

(Replace PORT with the name of the serial port to use.)

(To exit the serial monitor, type ``Ctrl-]``.)

See the Getting Started Guide of ESP-IDF to build the project.

## Media

### IAQ Board
<p align="center">
<img src="media/board/with-battery.jpg" width="200" height="200">
<img src="media/board/front.jpg" width="200" height="200">
<img src="media/board/back.jpg" width="200" height="200">
</p>

### Schematics
<p align="center">
<img src="media/schematic/brd.png" width="300" height="300"></br>
<img src="media/schematic/sch.png" width="340" height="270">
</p>

### Power Consumption
<p align="center">
<img src="media/power-consumption/normal_operation.png" width="300" height="160">
<img src="media/power-consumption/provisioning.png" width="300" height="160">
</p>