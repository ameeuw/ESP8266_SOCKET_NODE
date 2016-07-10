## ESP8266_SONOFF_NODE

This repository holds the code for a internet connected node. The hardware is based on very cheap in line relay switches called "SonOff" made by and available at ITEAD:
- [WiFi version](https://www.itead.cc/sonoff-wifi-wireless-switch.html)
- [WiFi & RF version](https://www.itead.cc/smart-home/im151116003.html)
- [Socket version](https://www.itead.cc/smart-home/slampher-wifi-wireless-light-holder.html)

The brain of this product is the Espressif ESP8266 chip, which is easy to program for. The collection of scripts makes use of a RestAPI module which allows for HTTP GET calls to control the relay of the device.

This is a very early version and will be improved over the next few weeks.

--------------

LED on pin 7
Relay on pin 6
Button on pin 3

--------------

Upload the following scripts to your SonOff using a USB to UART (FT232RL, Silabs cp210x) but _do not forget_ to supply 3.3V to VCC. The cp210x modules [found on Banggood](http://www.banggood.com/search/cp2102.html) can be easily converted ([Instructables Link](http://www.instructables.com/id/Mod-a-USB-to-TTL-Serial-Adapter-CP2102-to-program--1/)) using a linear regulator on the 5V line to support the ESP module.
I use [ESPlorer](http://esp8266.ru/esplorer/) for uploading, starting and configuring my scripts.

Scripts:
- init.lua
- Button.lua
- RestAPI.lua
- Socket.lua
- Sonoff.lua

--------------

Required nodeMCU modules (dev branch) check [nodemcu-build.com](http://nodemcu-build.com)

- cjson
- enduser_setup
- file
- gpio
- http
- mdns
- net
- node
- tmr
- uart
- wifi

Optionals
- (adc)
- (dht)
- (mqtt)
- (pwm)
- (ws2812)

--------------

The source scripts are meant for use with the [nodeMCU](https://github.com/nodemcu/nodemcu-firmware/tree/dev) lua interpreting firmware. Get the latest firmware from their [repository](https://github.com/nodemcu/nodemcu-firmware).
This code builds on top of revision 1.5.1 of the firmware and does not use floating point operations.
