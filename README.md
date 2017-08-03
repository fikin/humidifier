# humidifier
This is an IoT setup to control a humidify in a cabinet. I use [Ikea TOCKARP cupboard](http://www.ikea.com/fi/fi/catalog/products/50296829/#/10296826) but the setup can scale down or up.

The setup is based on IoT stack, notably NodeMCU in combination of DHT22 for humidity sensing and usb-powered vaporizers as they sell on Ebay. Additionally there is fan to circulate the air, door and low water level sensors used. The running information is displayed to OLED 128x64 display.

## How is behaves?
The control is based on binary-level of humidity set to 70%. If below than that, vaporizer is on, if equal or above the vaporizer is off.
Fan is always working together with vaporizer, in order to circulate the mist. 
In idle times, fan starts every 2min for 10sec to ensure the air is circulated constantly.
When door is opened, vaporizer is stopped until the door closes.
Similarly if the water level is too low.
Upon boot time, NodeMCU connects to configured Wifi network (STATION mode), if such configured. If no such configured or connectivity fails, it starts own access point (AP mode) with the name "humidifier".
Upon boot time also a tcp server is started up on port 8765. The server accepts plain text lua commands and returns the execution of the command as json data. This way one can echo via netcat lua commands and visualize the result via javascript.
Connected OLED display shows information about running activities including present humidity levels and tcp server endpoint.

## Schematics and components
* Schematics is [here](https://easyeda.com/normal/Humidifier_schematics-a8e7a2e2f8624814bcee30da7ef66c57)
* PCB [here](https://easyeda.com/normal/Humidifier_PCB-ea9598f94f3648109ea022063cb1b199). PCB is designed to use NodeMCU 0.9, which is inconveniently bigger size component for breadboards, but I happened to have such around. Once re-design it with NodeMC 1.0 and use same wiring.
* NodeMCU 0.9 (for the PCB) or 1.0 (wiring is identical, only physical dimentions differ).
* [DHT22](https://www.google.fi/url?sa=t&rct=j&q=&esrc=s&source=web&cd=1&cad=rja&uact=8&ved=0ahUKEwi_9vG_zabVAhUxS5oKHYH_DiAQFggmMAA&url=https%3A%2F%2Fwww.adafruit.com%2Fproduct%2F385&usg=AFQjCNFbRDPAJjYFipUvioCU9MC8iahblg) for humidity sensing.
* [OLED 128x64 i2c display](https://www.google.fi/url?sa=t&rct=j&q=&esrc=s&source=web&cd=1&cad=rja&uact=8&ved=0ahUKEwi40IvJzabVAhWGHpoKHVD3AZIQFggmMAA&url=https%3A%2F%2Fwww.adafruit.com%2Fproduct%2F938&usg=AFQjCNErzBhoFRdpFBCtOP0zG13FpqpjAg) to display useful status information like current humidity and tcp server endpoint address.
* [2 relay module](http://modtronix.com/mod-rly2-5v.html) to control fan and vaporizer power. Make sure to jumper JD-VCC and VCC together, it will indicate to the module that single power input will be used for opto-couple.
* [5v fan](https://www.google.fi/url?sa=t&rct=j&q=&esrc=s&source=web&cd=1&cad=rja&uact=8&ved=0ahUKEwiO8_SBzqbVAhWFHpoKHYDwBJkQFggmMAA&url=https%3A%2F%2Fwww.adafruit.com%2Fproduct%2F3368&usg=AFQjCNGwcKJoz_zj9CBwvwvejntjYVeOqw) or similar.
* [Reed magnetic switch](https://www.google.fi/url?sa=t&rct=j&q=&esrc=s&source=web&cd=2&cad=rja&uact=8&ved=0ahUKEwjRhqiTzqbVAhVJL1AKHcS_DrAQFggyMAE&url=https%3A%2F%2Fwww.sparkfun.com%2Fproducts%2F8642&usg=AFQjCNFH63Wpxtjxo6HaqfcIasXa-zPbkA) to be used as door sensor.
* Usb-powered [mistifiers/vaporizers/purifiers](https://www.ebay.com/sch/i.html?_odkw=usb+vaporizer&_osacat=0&_from=R40&_trksid=p2045573.m570.l1313.TR0.TRC0.H0.Xusb+vaporizer+or+mist.TRS0&_nkw=usb+vaporizer+or+mist&_sacat=0) used for creating mist.
* Resistor 100kΩ to be used in door input debouncer logic.
* Resistor 10kΩ to be used in door input debouncer logic.
* Capacitor 100nF to be used in door input debouncer logic.
* Male pin headers, start with 12 but more is better.
* [5V 2A usb power supply](https://www.google.fi/url?sa=t&rct=j&q=&esrc=s&source=web&cd=1&cad=rja&uact=8&ved=0ahUKEwid_eW__qbVAhUFnJQKHd68A0wQFggmMAA&url=https%3A%2F%2Fwww.adafruit.com%2Fproduct%2F1995&usg=AFQjCNFjOZmfMJAFXk2wgQhEhLgwscKljg)
The door sensor input is debounced, not that it matters much for the code but it is good from practice pov.
Power is 5v, provided to the jumpers. I use 5V 2A power supply.

## Assembly

### Control board
Perhaps the simples way is to use provided PCB and solder only the elements and components. If you want, ask me if I have to left-over boards, otherwise you can order from [EasyEDA](https://easyeda.com/nikolai.fiikov/humidifier-ab647a3a4d064fe59c5edce4c8fcaf46).

Another option is to assemble the schematics on it own, either using breadboard or other means.
From software point of view, digital debouncer logic (R1,R2 and U1) is not really needed, rest is.  

### Active element
This is the most demanding part for your setup.

One has to prepare running setup for ;
* fan
* vaporizer
* door sensor
* water sensor
* assemble case/setup for them

#### Usb vaporizer
They come in many shapes and features. Initially I used one line this [one](http://www.ebay.com/itm/USB-Mini-Water-Bottle-Caps-Humidifier-Air-Diffuser-Aroma-Mist-Maker-Home-Office-/122255682245?var=&hash=item1c7701aac5:m:minNTUWiu_GnYQEJ53BO-XA). You can choose but beware that some come with explicit on/off button. In such case, you'd have to solder shortcut because the schematics expects to switch it on only by applying power.

Nowadays, I purchase these only to rip apart them. I ripped from one such the circuit board in past and replace only the ceramic disk, which worries out with use. If find somewhere a genuine sell of such disks only for such usb vaporizers, I'd appreciate a hint.

#### Fan
Typically the large space to humidify, the more the fan has to work (change in sw code) or the large fan to be used (to move more air). Initially I used internal laptop cooling fan.

#### Door sensor
I used reed sensor attached to the coupbaord side and magnet attached to the door. Feel free to choose any switch setup you like here as long as keeps closed when "door is closed".

### Water sensor
The design is based on reading NodeMCU analog A0 input. Current schematics provides +3.3V to it which indicates enough water. Internally in the code this results to reading of 1024 value. Once the value goes below, it assumed water is missing.

I've implemented my sensor by 2 plain wires, submerged in water and connected to JP1.

### Assembling case
Before I didn't have door and water sensors, so they weren't TODO

#### To disable the door sensor
One can short-wire (close) JP2. This is equivalent to door being closed.

Or one can modify sw code and skip the entire door-related input schematics : 
```lua
doorSensor.lua: data.IsSensorMonitored = false
```

Or it can issue following command over running tcp server :
```shell
echo 'doorSensor.monitorDoorFnc(false)' | nc [IP] 8765
```

### To disable water sensor

One can short-wire (close) JP1. This is equivalent to water being enough always.

Or one can modify sw code and skip the entire door-related input schematics : 
```lua
waterLevelSensor.lua: data.IsSensorMonitored = false
```

Or it can issue following command over running tcp server :
```shell
echo 'waterLevelSensor.IsSensorMonitored = false' | nc [IP] 8765
```

## Installing the software
The code doesn't need 

## Using the humidifier
TODO