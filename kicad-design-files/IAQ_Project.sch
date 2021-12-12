EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 1
Title ""
Date ""
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
Text Notes 1050 2850 0    59   ~ 0
For SPI set CSB low at startup\nSDO=MISO, SDI=MOSI, SCK=SCK, CSB=CS/SSEL
Text Notes 1050 3150 0    59   ~ 0
For I2C leave CSB pulled high (default value)\nSDI=SDA, SCK=SCL
$Comp
L power:+3.3V #PWR0102
U 1 1 60BB7F42
P 3200 900
F 0 "#PWR0102" H 3200 750 50  0001 C CNN
F 1 "+3.3V" H 3215 1073 50  0000 C CNN
F 2 "" H 3200 900 50  0001 C CNN
F 3 "" H 3200 900 50  0001 C CNN
	1    3200 900 
	1    0    0    -1  
$EndComp
Text Label 2400 1450 0    67   ~ 0
SDO_ADR
$Comp
L power:+3.3V #PWR0101
U 1 1 60BB48E5
P 1750 1100
F 0 "#PWR0101" H 1750 950 50  0001 C CNN
F 1 "+3.3V" H 1765 1273 50  0000 C CNN
F 2 "" H 1750 1100 50  0001 C CNN
F 3 "" H 1750 1100 50  0001 C CNN
	1    1750 1100
	1    0    0    -1  
$EndComp
Wire Wire Line
	1750 1150 1750 1100
Wire Wire Line
	1750 2400 1750 2350
$Comp
L power:GND #PWR0104
U 1 1 60BBA1B2
P 1750 2400
F 0 "#PWR0104" H 1750 2150 50  0001 C CNN
F 1 "GND" H 1755 2227 50  0000 C CNN
F 2 "" H 1750 2400 50  0001 C CNN
F 3 "" H 1750 2400 50  0001 C CNN
	1    1750 2400
	1    0    0    -1  
$EndComp
Wire Wire Line
	1850 1150 1750 1150
Wire Wire Line
	2350 2050 3350 2050
Wire Wire Line
	1650 2350 1750 2350
$Comp
L Sensor:BME680 U1
U 1 1 60BD2FC2
P 1750 1750
F 0 "U1" H 1321 1796 50  0000 R CNN
F 1 "BME680" H 1321 1705 50  0000 R CNN
F 2 "Package_LGA:Bosch_LGA-8_3x3mm_P0.8mm_ClockwisePinNumbering" H 3200 1300 50  0001 C CNN
F 3 "https://ae-bst.resource.bosch.com/media/_tech/media/datasheets/BST-BME680-DS001.pdf" H 1750 1550 50  0001 C CNN
	1    1750 1750
	1    0    0    -1  
$EndComp
Text Label 2400 1650 0    67   ~ 0
SCK_3V
Text Label 2400 1850 0    67   ~ 0
SDI_3V
$Comp
L Regulator_Linear:MIC5205-3.3YM5 U2
U 1 1 60BEF6D1
P 1650 4050
F 0 "U2" H 1650 4392 50  0000 C CNN
F 1 "MIC5255-3.3" H 1650 4301 50  0000 C CNN
F 2 "Package_TO_SOT_SMD:SOT-23-5" H 1650 4375 50  0001 C CNN
F 3 "http://ww1.microchip.com/downloads/en/DeviceDoc/20005785A.pdf" H 1650 4050 50  0001 C CNN
	1    1650 4050
	1    0    0    -1  
$EndComp
Wire Wire Line
	1350 3950 1250 3950
Wire Wire Line
	1250 3950 1250 4050
Wire Wire Line
	1250 4050 1350 4050
$Comp
L power:VCC #PWR01
U 1 1 60BF562F
P 1150 3800
F 0 "#PWR01" H 1150 3650 50  0001 C CNN
F 1 "VCC" H 1165 3973 50  0000 C CNN
F 2 "" H 1150 3800 50  0001 C CNN
F 3 "" H 1150 3800 50  0001 C CNN
	1    1150 3800
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR03
U 1 1 60BF7C7F
P 1650 4450
F 0 "#PWR03" H 1650 4200 50  0001 C CNN
F 1 "GND" H 1655 4277 50  0000 C CNN
F 2 "" H 1650 4450 50  0001 C CNN
F 3 "" H 1650 4450 50  0001 C CNN
	1    1650 4450
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR02
U 1 1 60BF9468
P 1150 4450
F 0 "#PWR02" H 1150 4200 50  0001 C CNN
F 1 "GND" H 1155 4277 50  0000 C CNN
F 2 "" H 1150 4450 50  0001 C CNN
F 3 "" H 1150 4450 50  0001 C CNN
	1    1150 4450
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR05
U 1 1 60BFA284
P 2150 4450
F 0 "#PWR05" H 2150 4200 50  0001 C CNN
F 1 "GND" H 2155 4277 50  0000 C CNN
F 2 "" H 2150 4450 50  0001 C CNN
F 3 "" H 2150 4450 50  0001 C CNN
	1    2150 4450
	1    0    0    -1  
$EndComp
Wire Wire Line
	1150 3800 1150 3950
Wire Wire Line
	1150 3950 1250 3950
Connection ~ 1250 3950
Wire Wire Line
	1650 4350 1650 4450
$Comp
L power:+3.3V #PWR04
U 1 1 60BFBBB0
P 2150 3750
F 0 "#PWR04" H 2150 3600 50  0001 C CNN
F 1 "+3.3V" H 2165 3923 50  0000 C CNN
F 2 "" H 2150 3750 50  0001 C CNN
F 3 "" H 2150 3750 50  0001 C CNN
	1    2150 3750
	1    0    0    -1  
$EndComp
Wire Wire Line
	1950 3950 2150 3950
Wire Wire Line
	2150 3950 2150 3750
$Comp
L Adafruit_BME680-eagle-import:CAP_CERAMIC0805-NOOUTLINE C2
U 1 1 60BFD1C1
P 2150 4200
F 0 "C2" V 2060 4249 50  0000 C CNN
F 1 "10uF" V 2240 4249 50  0000 C CNN
F 2 "Capacitor_SMD:C_0805_2012Metric" H 2150 4200 50  0001 C CNN
F 3 "" H 2150 4200 50  0001 C CNN
	1    2150 4200
	1    0    0    -1  
$EndComp
Wire Wire Line
	2150 3950 2150 4000
Connection ~ 2150 3950
Wire Wire Line
	2150 4300 2150 4450
$Comp
L Adafruit_BME680-eagle-import:CAP_CERAMIC0805-NOOUTLINE C1
U 1 1 60BFE705
P 1150 4250
F 0 "C1" V 1060 4299 50  0000 C CNN
F 1 "10uF" V 1240 4299 50  0000 C CNN
F 2 "Capacitor_SMD:C_0805_2012Metric" H 1150 4250 50  0001 C CNN
F 3 "" H 1150 4250 50  0001 C CNN
	1    1150 4250
	1    0    0    -1  
$EndComp
Wire Wire Line
	1150 3950 1150 4050
Connection ~ 1150 3950
Wire Wire Line
	1150 4450 1150 4350
Connection ~ 1750 2350
Wire Wire Line
	1750 2350 1850 2350
Connection ~ 1750 1150
Wire Wire Line
	1750 1150 1650 1150
$Comp
L RF_Module:ESP32-WROOM-32 U3
U 1 1 60BB5A02
P 5650 3700
F 0 "U3" H 5650 5281 50  0000 C CNN
F 1 "ESP32-WROOM-32" H 5650 5190 50  0000 C CNN
F 2 "RF_Module:ESP32-WROOM-32" H 5650 2200 50  0001 C CNN
F 3 "https://www.espressif.com/sites/default/files/documentation/esp32-wroom-32_datasheet_en.pdf" H 5350 3750 50  0001 C CNN
	1    5650 3700
	1    0    0    -1  
$EndComp
$Comp
L Regulator_Linear:TC1262-33 U4
U 1 1 60BBCA11
P 9450 1350
F 0 "U4" H 9450 1592 50  0000 C CNN
F 1 "TC1262-33" H 9450 1501 50  0000 C CNN
F 2 "Package_TO_SOT_SMD:SOT-223" H 9450 1575 50  0001 C CIN
F 3 "http://ww1.microchip.com/downloads/en/DeviceDoc/21373C.pdf" H 9450 1050 50  0001 C CNN
	1    9450 1350
	1    0    0    -1  
$EndComp
$Comp
L Device:CP_Small C3
U 1 1 60BC3D34
P 8950 1500
F 0 "C3" H 9038 1546 50  0000 L CNN
F 1 "7S 100 16V" V 8850 1350 50  0000 L CNN
F 2 "Capacitor_SMD:CP_Elec_5x5.9" H 8950 1500 50  0001 C CNN
F 3 "~" H 8950 1500 50  0001 C CNN
	1    8950 1500
	1    0    0    -1  
$EndComp
$Comp
L Adafruit_BME680-eagle-import:CAP_CERAMIC0805-NOOUTLINE C4
U 1 1 60BC5266
P 9950 1550
F 0 "C4" V 9860 1599 50  0000 C CNN
F 1 "10uF" V 10040 1599 50  0000 C CNN
F 2 "Capacitor_SMD:C_0805_2012Metric" H 9950 1550 50  0001 C CNN
F 3 "" H 9950 1550 50  0001 C CNN
	1    9950 1550
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR09
U 1 1 60BC726A
P 9450 1750
F 0 "#PWR09" H 9450 1500 50  0001 C CNN
F 1 "GND" H 9455 1577 50  0000 C CNN
F 2 "" H 9450 1750 50  0001 C CNN
F 3 "" H 9450 1750 50  0001 C CNN
	1    9450 1750
	1    0    0    -1  
$EndComp
Wire Wire Line
	9750 1350 9950 1350
Wire Wire Line
	9450 1750 9450 1700
Wire Wire Line
	9150 1350 8950 1350
Wire Wire Line
	8950 1350 8950 1400
$Comp
L power:GND #PWR08
U 1 1 60BC98A9
P 8950 1750
F 0 "#PWR08" H 8950 1500 50  0001 C CNN
F 1 "GND" H 8955 1577 50  0000 C CNN
F 2 "" H 8950 1750 50  0001 C CNN
F 3 "" H 8950 1750 50  0001 C CNN
	1    8950 1750
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR011
U 1 1 60BC9F69
P 9950 1750
F 0 "#PWR011" H 9950 1500 50  0001 C CNN
F 1 "GND" H 9955 1577 50  0000 C CNN
F 2 "" H 9950 1750 50  0001 C CNN
F 3 "" H 9950 1750 50  0001 C CNN
	1    9950 1750
	1    0    0    -1  
$EndComp
Wire Wire Line
	9950 1650 9950 1750
Wire Wire Line
	8950 1600 8950 1750
$Comp
L power:VCC #PWR07
U 1 1 60BCBBA7
P 8950 1150
F 0 "#PWR07" H 8950 1000 50  0001 C CNN
F 1 "VCC" H 8965 1323 50  0000 C CNN
F 2 "" H 8950 1150 50  0001 C CNN
F 3 "" H 8950 1150 50  0001 C CNN
	1    8950 1150
	1    0    0    -1  
$EndComp
Wire Wire Line
	8950 1150 8950 1350
Connection ~ 8950 1350
$Comp
L power:VDDA #PWR010
U 1 1 60BCEDCF
P 9950 1150
F 0 "#PWR010" H 9950 1000 50  0001 C CNN
F 1 "VDDA" H 9965 1323 50  0000 C CNN
F 2 "" H 9950 1150 50  0001 C CNN
F 3 "" H 9950 1150 50  0001 C CNN
	1    9950 1150
	1    0    0    -1  
$EndComp
Wire Wire Line
	9950 1150 9950 1350
Connection ~ 9950 1350
$Comp
L power:VDDA #PWR06
U 1 1 60BF086F
P 5650 1550
F 0 "#PWR06" H 5650 1400 50  0001 C CNN
F 1 "VDDA" H 5665 1723 50  0000 C CNN
F 2 "" H 5650 1550 50  0001 C CNN
F 3 "" H 5650 1550 50  0001 C CNN
	1    5650 1550
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR012
U 1 1 60BF2318
P 5650 5200
F 0 "#PWR012" H 5650 4950 50  0001 C CNN
F 1 "GND" H 5655 5027 50  0000 C CNN
F 2 "" H 5650 5200 50  0001 C CNN
F 3 "" H 5650 5200 50  0001 C CNN
	1    5650 5200
	1    0    0    -1  
$EndComp
Wire Wire Line
	5650 5200 5650 5100
$Comp
L Connector_Generic:Conn_01x06 J1
U 1 1 60BF4C82
P 1750 6100
F 0 "J1" H 1830 6092 50  0000 L CNN
F 1 "Conn_01x06" H 1830 6001 50  0000 L CNN
F 2 "Connector:2.54-programming-header" H 1750 6100 50  0001 C CNN
F 3 "~" H 1750 6100 50  0001 C CNN
	1    1750 6100
	1    0    0    -1  
$EndComp
Wire Wire Line
	1550 5900 1350 5900
Wire Wire Line
	1550 6400 1350 6400
$Comp
L power:GND #PWR014
U 1 1 60BFA113
P 1350 6550
F 0 "#PWR014" H 1350 6300 50  0001 C CNN
F 1 "GND" H 1355 6377 50  0000 C CNN
F 2 "" H 1350 6550 50  0001 C CNN
F 3 "" H 1350 6550 50  0001 C CNN
	1    1350 6550
	1    0    0    -1  
$EndComp
Wire Wire Line
	1350 6400 1350 6550
$Comp
L power:VDDA #PWR013
U 1 1 60BFB21F
P 1350 5800
F 0 "#PWR013" H 1350 5650 50  0001 C CNN
F 1 "VDDA" H 1365 5973 50  0000 C CNN
F 2 "" H 1350 5800 50  0001 C CNN
F 3 "" H 1350 5800 50  0001 C CNN
	1    1350 5800
	1    0    0    -1  
$EndComp
Wire Wire Line
	1350 5900 1350 5800
Text Label 1300 6000 0    50   ~ 0
ESP_RX
Wire Wire Line
	1300 6000 1550 6000
Wire Wire Line
	1300 6100 1550 6100
Wire Wire Line
	1300 6200 1550 6200
Wire Wire Line
	1300 6300 1550 6300
Text Label 1300 6100 0    50   ~ 0
ESP_TX
Text Label 1300 6200 0    50   ~ 0
ESP_EN
Text Label 1300 6300 0    50   ~ 0
ESP_I0
Text Notes 1050 4900 0    59   ~ 0
Leave this LDO close to the BME680 to remove noise.
Text Notes 8600 2150 0    59   ~ 0
ESP32 WROOM min required current: 500mA
Text Notes 1050 6850 0    59   ~ 0
2.54mm Programming Header
Wire Wire Line
	6250 2800 6550 2800
Text Label 6300 2600 0    50   ~ 0
ESP_TX
Text Label 6300 2800 0    50   ~ 0
ESP_RX
Text Label 6300 2500 0    50   ~ 0
ESP_I0
$Comp
L Adafruit_BME680-eagle-import:CAP_CERAMIC0805-NOOUTLINE C7
U 1 1 60BC2B3F
P 5800 1800
F 0 "C7" V 5710 1849 50  0000 C CNN
F 1 "0.1uF/50V(10%)" V 5890 1849 50  0000 C CNN
F 2 "Capacitor_SMD:C_0805_2012Metric" H 5800 1800 50  0001 C CNN
F 3 "" H 5800 1800 50  0001 C CNN
	1    5800 1800
	1    0    0    -1  
$EndComp
$Comp
L Adafruit_BME680-eagle-import:CAP_CERAMIC0805-NOOUTLINE C6
U 1 1 60BC3AFF
P 5500 1700
F 0 "C6" V 5410 1749 50  0000 C CNN
F 1 "22uF/10V(20%)" V 5590 1749 50  0000 C CNN
F 2 "Capacitor_SMD:C_0805_2012Metric" H 5500 1700 50  0001 C CNN
F 3 "" H 5500 1700 50  0001 C CNN
	1    5500 1700
	-1   0    0    1   
$EndComp
$Comp
L power:GND #PWR019
U 1 1 60BC7427
P 5500 1900
F 0 "#PWR019" H 5500 1650 50  0001 C CNN
F 1 "GND" H 5505 1727 50  0000 C CNN
F 2 "" H 5500 1900 50  0001 C CNN
F 3 "" H 5500 1900 50  0001 C CNN
	1    5500 1900
	1    0    0    -1  
$EndComp
Wire Wire Line
	5650 1550 5650 1600
Wire Wire Line
	5800 1600 5650 1600
Connection ~ 5650 1600
Wire Wire Line
	5650 1600 5500 1600
$Comp
L Adafruit_BME680-eagle-import:RESISTOR_0603_NOOUT R5
U 1 1 60BE84F3
P 4450 2200
F 0 "R5" H 4450 2300 50  0000 C CNN
F 1 "10K" H 4450 2200 40  0000 C CNB
F 2 "Resistor_SMD:R_0603_1608Metric" H 4450 2200 50  0001 C CNN
F 3 "" H 4450 2200 50  0001 C CNN
	1    4450 2200
	0    -1   -1   0   
$EndComp
$Comp
L Adafruit_BME680-eagle-import:CAP_CERAMIC0805-NOOUTLINE C5
U 1 1 60BE9CB7
P 4450 2650
F 0 "C5" H 4360 2699 50  0000 C CNN
F 1 "0.1uF/50V(10%)" V 4540 2699 50  0000 C CNN
F 2 "Capacitor_SMD:C_0805_2012Metric" H 4450 2650 50  0001 C CNN
F 3 "" H 4450 2650 50  0001 C CNN
	1    4450 2650
	-1   0    0    1   
$EndComp
Wire Wire Line
	5650 1600 5650 2300
$Comp
L power:GND #PWR020
U 1 1 60BEC9F5
P 5800 1900
F 0 "#PWR020" H 5800 1650 50  0001 C CNN
F 1 "GND" H 5805 1727 50  0000 C CNN
F 2 "" H 5800 1900 50  0001 C CNN
F 3 "" H 5800 1900 50  0001 C CNN
	1    5800 1900
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR018
U 1 1 60BEE05C
P 4450 2950
F 0 "#PWR018" H 4450 2700 50  0001 C CNN
F 1 "GND" H 4455 2777 50  0000 C CNN
F 2 "" H 4450 2950 50  0001 C CNN
F 3 "" H 4450 2950 50  0001 C CNN
	1    4450 2950
	1    0    0    -1  
$EndComp
Wire Wire Line
	4450 2850 4450 2950
Wire Wire Line
	4450 2400 4450 2500
$Comp
L power:VDDA #PWR017
U 1 1 60BF0DE3
P 4450 1900
F 0 "#PWR017" H 4450 1750 50  0001 C CNN
F 1 "VDDA" H 4465 2073 50  0000 C CNN
F 2 "" H 4450 1900 50  0001 C CNN
F 3 "" H 4450 1900 50  0001 C CNN
	1    4450 1900
	1    0    0    -1  
$EndComp
Wire Wire Line
	4450 2000 4450 1900
Wire Wire Line
	5050 2500 4450 2500
Connection ~ 4450 2500
Wire Wire Line
	4450 2500 4450 2550
Wire Wire Line
	6250 3900 6600 3900
Wire Wire Line
	6250 4000 6600 4000
Wire Wire Line
	2350 1450 3050 1450
Wire Wire Line
	2350 1650 3150 1650
Wire Wire Line
	2350 1850 3250 1850
Text Label 6350 3900 0    50   ~ 0
SDI_3V
Text Label 6350 4000 0    50   ~ 0
SCK_3V
$Comp
L Adafruit_BME680-eagle-import:RESISTOR_0603_NOOUT R6
U 1 1 60C09015
P 6800 2200
F 0 "R6" H 6800 2300 50  0000 C CNN
F 1 "10K" H 6800 2200 40  0000 C CNB
F 2 "Resistor_SMD:R_0603_1608Metric" H 6800 2200 50  0001 C CNN
F 3 "" H 6800 2200 50  0001 C CNN
	1    6800 2200
	0    -1   -1   0   
$EndComp
Wire Wire Line
	6800 2500 6800 2400
Wire Wire Line
	6250 2500 6800 2500
$Comp
L power:VDDA #PWR021
U 1 1 60C0B0BC
P 6800 1850
F 0 "#PWR021" H 6800 1700 50  0001 C CNN
F 1 "VDDA" H 6815 2023 50  0000 C CNN
F 2 "" H 6800 1850 50  0001 C CNN
F 3 "" H 6800 1850 50  0001 C CNN
	1    6800 1850
	1    0    0    -1  
$EndComp
Wire Wire Line
	6800 1850 6800 2000
$Comp
L Adafruit_BME680-eagle-import:RESISTOR_0603_NOOUT R8
U 1 1 60C0CBB3
P 7050 2700
F 0 "R8" H 7050 2800 50  0000 C CNN
F 1 "10K" H 7050 2700 40  0000 C CNB
F 2 "Resistor_SMD:R_0603_1608Metric" H 7050 2700 50  0001 C CNN
F 3 "" H 7050 2700 50  0001 C CNN
	1    7050 2700
	1    0    0    -1  
$EndComp
Wire Wire Line
	6250 2600 6550 2600
Wire Wire Line
	6250 2700 6850 2700
$Comp
L power:GND #PWR022
U 1 1 60C13016
P 7250 2850
F 0 "#PWR022" H 7250 2600 50  0001 C CNN
F 1 "GND" H 7255 2677 50  0000 C CNN
F 2 "" H 7250 2850 50  0001 C CNN
F 3 "" H 7250 2850 50  0001 C CNN
	1    7250 2850
	1    0    0    -1  
$EndComp
Text Label 6300 2700 0    50   ~ 0
ESP_I2
Text Notes 4550 6100 0    59   ~ 0
PIN | Default | SPI Boot | Download Boot \nIO0 |.….UP…..|………1……|………..0 \nIO2 |..DOWN….|..D’ Care…|……….0    \n\nEnabling Debugging Log Print over U0TXD - MTDO - 1\nDisabling Debugging Log Print over U0TXD  - MTDO  - 0
Text Label 6300 3400 0    50   ~ 0
ESP_MTDO
$Comp
L Adafruit_BME680-eagle-import:RESISTOR_0603_NOOUT R7
U 1 1 60C169D1
P 6950 3400
F 0 "R7" H 6950 3500 50  0000 C CNN
F 1 "10K" H 6950 3400 40  0000 C CNB
F 2 "Resistor_SMD:R_0603_1608Metric" H 6950 3400 50  0001 C CNN
F 3 "" H 6950 3400 50  0001 C CNN
	1    6950 3400
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR023
U 1 1 60C1A2DC
P 7250 3550
F 0 "#PWR023" H 7250 3300 50  0001 C CNN
F 1 "GND" H 7255 3377 50  0000 C CNN
F 2 "" H 7250 3550 50  0001 C CNN
F 3 "" H 7250 3550 50  0001 C CNN
	1    7250 3550
	1    0    0    -1  
$EndComp
Wire Wire Line
	7150 3400 7250 3400
Wire Wire Line
	6250 3400 6750 3400
Wire Wire Line
	6250 3300 6550 3300
Text Label 6300 3300 0    50   ~ 0
ESP_LED
Wire Wire Line
	3050 1300 3050 1450
Wire Wire Line
	3150 1300 3150 1650
Wire Wire Line
	3250 1300 3250 1850
Wire Wire Line
	3350 1300 3350 2050
$Comp
L Device:R_Pack04 RN1
U 1 1 60C43CC8
P 3250 1100
F 0 "RN1" H 3438 1146 50  0000 L CNN
F 1 "R_Pack04" H 3438 1055 50  0000 L CNN
F 2 "Resistor_SMD:R_Array_Convex_4x0603" V 3525 1100 50  0001 C CNN
F 3 "~" H 3250 1100 50  0001 C CNN
	1    3250 1100
	1    0    0    -1  
$EndComp
Wire Wire Line
	3350 900  3250 900 
Connection ~ 3150 900 
Wire Wire Line
	3150 900  3050 900 
Connection ~ 3250 900 
Wire Wire Line
	3250 900  3200 900 
Connection ~ 3200 900 
Wire Wire Line
	3200 900  3150 900 
$Comp
L Connector:USB_B_Micro J2
U 1 1 60C55053
P 8700 3150
F 0 "J2" H 8757 3617 50  0000 C CNN
F 1 "USB_B_Micro" H 8757 3526 50  0000 C CNN
F 2 "Connector_USB:USB_Micro_SMD_China" H 8850 3100 50  0001 C CNN
F 3 "~" H 8850 3100 50  0001 C CNN
	1    8700 3150
	1    0    0    -1  
$EndComp
$Comp
L tp4056:TP4056 U6
U 1 1 60C7FB0D
P 10000 3200
F 0 "U6" H 10000 3737 60  0000 C CNN
F 1 "TP4056" H 10000 3631 60  0000 C CNN
F 2 "lib:TP4056_SOP-8-PP" H 10000 3200 60  0001 C CNN
F 3 "" H 10000 3200 60  0000 C CNN
	1    10000 3200
	1    0    0    -1  
$EndComp
$Comp
L dw01:DW01 U5
U 1 1 60C80883
P 10200 4800
F 0 "U5" H 10225 5237 60  0000 C CNN
F 1 "DW01" H 10225 5131 60  0000 C CNN
F 2 "Package_TO_SOT_SMD:SOT-23-6" H 10150 4500 60  0001 C CNN
F 3 "" H 10150 4500 60  0001 C CNN
	1    10200 4800
	1    0    0    -1  
$EndComp
$Comp
L fs8205a:FS8205A U7
U 1 1 60C8160D
P 8850 4850
F 0 "U7" V 8363 4750 60  0000 C CNN
F 1 "FS8205A" V 8469 4750 60  0000 C CNN
F 2 "Package_SO:TSSOP-8_4.4x3mm_P0.65mm" H 9800 5100 60  0001 C CNN
F 3 "" H 9800 5100 60  0001 C CNN
	1    8850 4850
	0    1    1    0   
$EndComp
$Comp
L power:GND #PWR024
U 1 1 60CA295E
P 8700 3600
F 0 "#PWR024" H 8700 3350 50  0001 C CNN
F 1 "GND" H 8705 3427 50  0000 C CNN
F 2 "" H 8700 3600 50  0001 C CNN
F 3 "" H 8700 3600 50  0001 C CNN
	1    8700 3600
	1    0    0    -1  
$EndComp
Wire Wire Line
	8700 3550 8700 3600
Wire Wire Line
	9500 2950 9150 2950
Wire Wire Line
	9500 3050 9500 2950
Connection ~ 9500 2950
$Comp
L Adafruit_BME680-eagle-import:CAP_CERAMIC0805-NOOUTLINE C8
U 1 1 60CACD62
P 9150 3250
F 0 "C8" V 9060 3299 50  0000 C CNN
F 1 "100nF" V 9240 3299 50  0000 C CNN
F 2 "Capacitor_SMD:C_0402_1005Metric" H 9150 3250 50  0001 C CNN
F 3 "" H 9150 3250 50  0001 C CNN
	1    9150 3250
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR025
U 1 1 60CB02FF
P 9150 3450
F 0 "#PWR025" H 9150 3200 50  0001 C CNN
F 1 "GND" H 9155 3277 50  0000 C CNN
F 2 "" H 9150 3450 50  0001 C CNN
F 3 "" H 9150 3450 50  0001 C CNN
	1    9150 3450
	1    0    0    -1  
$EndComp
Wire Wire Line
	9150 3350 9150 3450
Wire Wire Line
	9150 2950 9150 3050
Connection ~ 9150 2950
Wire Wire Line
	9150 2950 9000 2950
$Comp
L power:GND #PWR027
U 1 1 60CB429A
P 10000 3700
F 0 "#PWR027" H 10000 3450 50  0001 C CNN
F 1 "GND" H 10005 3527 50  0000 C CNN
F 2 "" H 10000 3700 50  0001 C CNN
F 3 "" H 10000 3700 50  0001 C CNN
	1    10000 3700
	1    0    0    -1  
$EndComp
Wire Wire Line
	10000 3600 10000 3700
Wire Wire Line
	10500 3250 10650 3250
Wire Wire Line
	10650 3250 10650 3600
Wire Wire Line
	10650 3600 10000 3600
Connection ~ 10000 3600
$Comp
L Adafruit_BME680-eagle-import:RESISTOR_0603_NOOUT R4
U 1 1 60CB89E7
P 10500 3750
F 0 "R4" H 10500 3850 50  0000 C CNN
F 1 "1.2K" H 10500 3750 40  0000 C CNB
F 2 "Resistor_SMD:R_0603_1608Metric" H 10500 3750 50  0001 C CNN
F 3 "" H 10500 3750 50  0001 C CNN
	1    10500 3750
	0    -1   -1   0   
$EndComp
$Comp
L power:GND #PWR028
U 1 1 60CBA231
P 10500 4050
F 0 "#PWR028" H 10500 3800 50  0001 C CNN
F 1 "GND" H 10505 3877 50  0000 C CNN
F 2 "" H 10500 4050 50  0001 C CNN
F 3 "" H 10500 4050 50  0001 C CNN
	1    10500 4050
	1    0    0    -1  
$EndComp
Wire Wire Line
	10500 3950 10500 4050
Wire Wire Line
	10500 3550 10500 3350
$Comp
L Adafruit_BME680-eagle-import:RESISTOR_0603_NOOUT R3
U 1 1 60CBEBE1
P 9600 3650
F 0 "R3" H 9600 3750 50  0000 C CNN
F 1 "1K" H 9600 3650 40  0000 C CNB
F 2 "Resistor_SMD:R_0603_1608Metric" H 9600 3650 50  0001 C CNN
F 3 "" H 9600 3650 50  0001 C CNN
	1    9600 3650
	0    -1   -1   0   
$EndComp
$Comp
L Adafruit_BME680-eagle-import:RESISTOR_0603_NOOUT R1
U 1 1 60CC1630
P 9400 3650
F 0 "R1" H 9400 3750 50  0000 C CNN
F 1 "1K" H 9400 3650 40  0000 C CNB
F 2 "Resistor_SMD:R_0603_1608Metric" H 9400 3650 50  0001 C CNN
F 3 "" H 9400 3650 50  0001 C CNN
	1    9400 3650
	0    -1   -1   0   
$EndComp
Wire Wire Line
	9500 3250 9400 3250
Wire Wire Line
	9400 3250 9400 3450
Wire Wire Line
	9500 3350 9500 3450
Wire Wire Line
	9500 3450 9600 3450
$Comp
L Device:LED D1
U 1 1 60CC6FA7
P 9400 4050
F 0 "D1" V 9350 3850 50  0000 L CNN
F 1 "LED" V 9450 3850 50  0000 L CNN
F 2 "LED_SMD:LED_0805_2012Metric" H 9400 4050 50  0001 C CNN
F 3 "~" H 9400 4050 50  0001 C CNN
	1    9400 4050
	0    1    1    0   
$EndComp
$Comp
L Device:LED D2
U 1 1 60CC8EBD
P 9600 4050
F 0 "D2" V 9547 4130 50  0000 L CNN
F 1 "LED" V 9638 4130 50  0000 L CNN
F 2 "LED_SMD:LED_0805_2012Metric" H 9600 4050 50  0001 C CNN
F 3 "~" H 9600 4050 50  0001 C CNN
	1    9600 4050
	0    1    1    0   
$EndComp
Wire Wire Line
	9400 3850 9400 3900
Wire Wire Line
	9600 3850 9600 3900
Wire Wire Line
	9600 4200 9400 4200
Text Label 9250 2950 0    50   ~ 0
VBUS
$Comp
L power:VCC #PWR029
U 1 1 60D16013
P 10650 2850
F 0 "#PWR029" H 10650 2700 50  0001 C CNN
F 1 "VCC" H 10665 3023 50  0000 C CNN
F 2 "" H 10650 2850 50  0001 C CNN
F 3 "" H 10650 2850 50  0001 C CNN
	1    10650 2850
	1    0    0    -1  
$EndComp
Wire Wire Line
	10500 2950 10650 2950
Wire Wire Line
	10650 2950 10650 2850
$Comp
L Adafruit_BME680-eagle-import:RESISTOR_0603_NOOUT R9
U 1 1 60D1FF9D
P 10950 4450
F 0 "R9" H 10950 4550 50  0000 C CNN
F 1 "100" H 10950 4450 40  0000 C CNB
F 2 "Resistor_SMD:R_0603_1608Metric" H 10950 4450 50  0001 C CNN
F 3 "" H 10950 4450 50  0001 C CNN
	1    10950 4450
	0    -1   -1   0   
$EndComp
Wire Wire Line
	10950 4650 10800 4650
$Comp
L power:VCC #PWR030
U 1 1 60D22F4A
P 10950 4150
F 0 "#PWR030" H 10950 4000 50  0001 C CNN
F 1 "VCC" H 10965 4323 50  0000 C CNN
F 2 "" H 10950 4150 50  0001 C CNN
F 3 "" H 10950 4150 50  0001 C CNN
	1    10950 4150
	1    0    0    -1  
$EndComp
Wire Wire Line
	10950 4150 10950 4250
Wire Wire Line
	10950 5000 10950 5050
$Comp
L Adafruit_BME680-eagle-import:CAP_CERAMIC0805-NOOUTLINE C9
U 1 1 60D28E2A
P 10950 4900
F 0 "C9" V 10860 4949 50  0000 C CNN
F 1 "100nF" V 11040 4949 50  0000 C CNN
F 2 "Capacitor_SMD:C_0402_1005Metric" H 10950 4900 50  0001 C CNN
F 3 "" H 10950 4900 50  0001 C CNN
	1    10950 4900
	1    0    0    -1  
$EndComp
Wire Wire Line
	10950 4650 10950 4700
Connection ~ 10950 4650
Wire Wire Line
	10800 4850 10800 5050
Wire Wire Line
	10800 5050 10950 5050
$Comp
L Connector_Generic:Conn_01x02 J3
U 1 1 60D3B7FE
P 3450 6450
F 0 "J3" H 3530 6442 50  0000 L CNN
F 1 "Conn_01x02" H 3530 6351 50  0000 L CNN
F 2 "Connector_PinHeader_2.00mm:PinHeader_1x02_P2.00mm_Vertical" H 3450 6450 50  0001 C CNN
F 3 "~" H 3450 6450 50  0001 C CNN
	1    3450 6450
	1    0    0    -1  
$EndComp
$Comp
L power:VCC #PWR015
U 1 1 60D3DD9C
P 3150 6350
F 0 "#PWR015" H 3150 6200 50  0001 C CNN
F 1 "VCC" H 3165 6523 50  0000 C CNN
F 2 "" H 3150 6350 50  0001 C CNN
F 3 "" H 3150 6350 50  0001 C CNN
	1    3150 6350
	1    0    0    -1  
$EndComp
Wire Wire Line
	3150 6350 3150 6450
Wire Wire Line
	3150 6450 3250 6450
Text GLabel 3250 6550 0    50   Input ~ 0
VBat-
Text Notes 3000 6850 0    59   ~ 0
Battery Connector\n
Text GLabel 10900 5050 3    50   Input ~ 0
VBat-
Text GLabel 9600 4200 2    50   Input ~ 0
VBUS
Wire Wire Line
	8250 4750 8250 4850
Wire Wire Line
	8250 4650 8000 4650
Wire Wire Line
	8000 4650 8000 5300
Wire Wire Line
	8000 5300 10050 5300
Wire Wire Line
	10050 5300 10050 5250
Wire Wire Line
	9250 4650 9350 4650
Wire Wire Line
	9350 4650 9350 5400
Wire Wire Line
	9350 5400 10350 5400
Wire Wire Line
	10350 5400 10350 5250
Wire Wire Line
	9250 4750 9250 4950
Text GLabel 9250 4850 2    50   Input ~ 0
VBat-
$Comp
L power:GND #PWR016
U 1 1 60D5BFB1
P 8150 5400
F 0 "#PWR016" H 8150 5150 50  0001 C CNN
F 1 "GND" H 8155 5227 50  0000 C CNN
F 2 "" H 8150 5400 50  0001 C CNN
F 3 "" H 8150 5400 50  0001 C CNN
	1    8150 5400
	1    0    0    -1  
$EndComp
Wire Wire Line
	8250 4850 8150 4850
Wire Wire Line
	8150 4850 8150 5400
Connection ~ 8250 4850
Wire Wire Line
	8250 4850 8250 4950
$Comp
L Adafruit_BME680-eagle-import:RESISTOR_0603_NOOUT R2
U 1 1 60D5FC63
P 9550 5350
F 0 "R2" H 9550 5450 50  0000 C CNN
F 1 "1K" H 9550 5350 40  0000 C CNB
F 2 "Resistor_SMD:R_0603_1608Metric" H 9550 5350 50  0001 C CNN
F 3 "" H 9550 5350 50  0001 C CNN
	1    9550 5350
	0    1    1    0   
$EndComp
Wire Wire Line
	9550 5150 9550 4850
Wire Wire Line
	9550 4850 9650 4850
$Comp
L power:GND #PWR026
U 1 1 60D67593
P 9550 5550
F 0 "#PWR026" H 9550 5300 50  0001 C CNN
F 1 "GND" H 9555 5377 50  0000 C CNN
F 2 "" H 9550 5550 50  0001 C CNN
F 3 "" H 9550 5550 50  0001 C CNN
	1    9550 5550
	1    0    0    -1  
$EndComp
Text Notes 8000 5950 0    59   ~ 0
Battery Management System\nControls the charging process of the battery
Wire Wire Line
	7250 2700 7250 2850
Wire Wire Line
	7250 3400 7250 3550
Text Label 6300 3200 0    50   ~ 0
ESP_SW
$Comp
L Device:LED D3
U 1 1 60D86737
P 6750 4400
F 0 "D3" V 6700 4200 50  0000 L CNN
F 1 "LED" V 6800 4200 50  0000 L CNN
F 2 "LED_SMD:LED_0805_2012Metric" H 6750 4400 50  0001 C CNN
F 3 "~" H 6750 4400 50  0001 C CNN
	1    6750 4400
	0    -1   -1   0   
$EndComp
$Comp
L Adafruit_BME680-eagle-import:RESISTOR_0603_NOOUT R10
U 1 1 60D87496
P 6750 4850
F 0 "R10" H 6750 4950 50  0000 C CNN
F 1 "1K" H 6750 4850 40  0000 C CNB
F 2 "Resistor_SMD:R_0603_1608Metric" H 6750 4850 50  0001 C CNN
F 3 "" H 6750 4850 50  0001 C CNN
	1    6750 4850
	0    -1   -1   0   
$EndComp
$Comp
L power:GND #PWR031
U 1 1 60D88087
P 6750 5100
F 0 "#PWR031" H 6750 4850 50  0001 C CNN
F 1 "GND" H 6755 4927 50  0000 C CNN
F 2 "" H 6750 5100 50  0001 C CNN
F 3 "" H 6750 5100 50  0001 C CNN
	1    6750 5100
	1    0    0    -1  
$EndComp
Wire Wire Line
	6750 5100 6750 5050
Wire Wire Line
	6750 4650 6750 4550
Wire Wire Line
	6750 4250 6850 4250
Text Label 6850 4250 0    50   ~ 0
ESP_LED
$Comp
L Switch:SW_Push SW1
U 1 1 60D942B6
P 7300 4850
F 0 "SW1" V 7346 4802 50  0000 R CNN
F 1 "SW_Push" V 7255 4802 50  0000 R CNN
F 2 "Button_Switch_SMD:SW_SPST_EVQP7C" V 7209 4802 50  0001 R CNN
F 3 "~" H 7300 5050 50  0001 C CNN
	1    7300 4850
	0    -1   -1   0   
$EndComp
$Comp
L power:GND #PWR032
U 1 1 60D96AF2
P 7300 5100
F 0 "#PWR032" H 7300 4850 50  0001 C CNN
F 1 "GND" H 7305 4927 50  0000 C CNN
F 2 "" H 7300 5100 50  0001 C CNN
F 3 "" H 7300 5100 50  0001 C CNN
	1    7300 5100
	1    0    0    -1  
$EndComp
Wire Wire Line
	7300 5050 7300 5100
Wire Wire Line
	7300 4650 7300 4250
Wire Wire Line
	7300 4250 7400 4250
Text Label 7400 4250 0    50   ~ 0
ESP_SW
$Comp
L Adafruit_BME680-eagle-import:RESISTOR_0603_NOOUT R11
U 1 1 60D9F03C
P 6950 3200
F 0 "R11" H 6950 3300 50  0000 C CNN
F 1 "10K" H 6950 3200 40  0000 C CNB
F 2 "Resistor_SMD:R_0603_1608Metric" H 6950 3200 50  0001 C CNN
F 3 "" H 6950 3200 50  0001 C CNN
	1    6950 3200
	1    0    0    -1  
$EndComp
$Comp
L power:VDDA #PWR033
U 1 1 60D9FB4F
P 7500 3150
F 0 "#PWR033" H 7500 3000 50  0001 C CNN
F 1 "VDDA" H 7515 3323 50  0000 C CNN
F 2 "" H 7500 3150 50  0001 C CNN
F 3 "" H 7500 3150 50  0001 C CNN
	1    7500 3150
	1    0    0    -1  
$EndComp
Wire Wire Line
	7150 3200 7500 3200
Wire Wire Line
	7500 3200 7500 3150
Wire Wire Line
	6250 3200 6750 3200
Text Notes 7000 7100 0    98   ~ 20
IAQ Monitoring Box\nPowered By BME680 & ESP32\nAuthor: Fernando Fontes
$Comp
L Adafruit_BME680-eagle-import:CAP_CERAMIC0805-NOOUTLINE C10
U 1 1 60DD6DE9
P 10850 3150
F 0 "C10" V 10760 3199 50  0000 C CNN
F 1 "10uF" V 10940 3199 50  0000 C CNN
F 2 "Capacitor_SMD:C_0504_1310Metric" H 10850 3150 50  0001 C CNN
F 3 "" H 10850 3150 50  0001 C CNN
	1    10850 3150
	1    0    0    -1  
$EndComp
Wire Wire Line
	10650 2950 10850 2950
Connection ~ 10650 2950
$Comp
L power:GND #PWR034
U 1 1 60DDB6FF
P 10850 3350
F 0 "#PWR034" H 10850 3100 50  0001 C CNN
F 1 "GND" H 10855 3177 50  0000 C CNN
F 2 "" H 10850 3350 50  0001 C CNN
F 3 "" H 10850 3350 50  0001 C CNN
	1    10850 3350
	1    0    0    -1  
$EndComp
Wire Wire Line
	10850 3250 10850 3350
Text Label 4650 2500 0    50   ~ 0
ESP_EN
Wire Wire Line
	9450 1700 9300 1700
Wire Wire Line
	9300 1700 9300 1650
Connection ~ 9450 1700
Wire Wire Line
	9450 1700 9450 1650
Wire Wire Line
	9500 3150 9350 3150
Wire Wire Line
	9350 3150 9350 3350
Wire Wire Line
	9350 3350 9150 3350
Connection ~ 9150 3350
$EndSCHEMATC
