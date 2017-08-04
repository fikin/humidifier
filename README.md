# humidifier
This is an IoT setup to control a humidify in a cabinet. I use [Ikea TOCKARP cupboard](http://www.ikea.com/fi/fi/catalog/products/50296829/#/10296826) but the setup can scale down or up.

The setup is based on IoT stack, notably NodeMCU in combination with DHT22 for humidity sensing and usb-powered vaporizers for humidifying element. There are also fan(s) to circulate the air, door and low water level sensors used. Running information is displayed to OLED 128x64 display. And externalö statuc and control operations are possible over simple tcp server protocol.

## How is behaves?
The control loop is based on binary-level check for humidity lelve, by default set to 70%. If below than that, vaporizer is on, if equal or above the vaporizer is off.
Fan is always working together with vaporizer, in order to circulate the mist. 
In idle times, fan circulates the air periodically, like for 20sec every 2min.
When door is opened, vaporizer and fan are stopped until the door closes.
Similarly if the water level is too low.
Upon boot time, NodeMCU connects to pre-configured Wifi network (STATION mode). Details are defined in lua-syntax wifi-credentials.txt file, stored in NodeMCU file system. If no such configured or connectivity fails, it starts own access point (AP mode) with the name "humidifier".
Upon boot time also a tcp server is started up on port 8765. The server accepts plain text lua commands and returns the execution of the command as json data. This way one can echo lua commands via netcat and visualize the result via javascript. Submitted command has to fit in single tpc frame as there is no read loop over the connection, whatever data arrives with first tcp frame, it is evaluated as plain lua command. 
Connected OLED display shows information about running activities including present humidity levels and tcp server endpoint.

## Schematics and components
* Schematics is [here](https://easyeda.com/normal/Humidifier_schematics-a8e7a2e2f8624814bcee30da7ef66c57)
* PCB [here](https://easyeda.com/normal/Humidifier_PCB-ea9598f94f3648109ea022063cb1b199). PCB is designed to use NodeMCU 0.9 (sold in yellow color), which is, inconveniently, bigger size component for breadboards, but I happened to have such around. One can re-design it with NodeMC 1.0 and use same wiring. NodeMCU 0.9 or 1.0, wiring is identical, only physical dimentions differ.
* [DHT22](https://www.google.fi/url?sa=t&rct=j&q=&esrc=s&source=web&cd=1&cad=rja&uact=8&ved=0ahUKEwi_9vG_zabVAhUxS5oKHYH_DiAQFggmMAA&url=https%3A%2F%2Fwww.adafruit.com%2Fproduct%2F385&usg=AFQjCNFbRDPAJjYFipUvioCU9MC8iahblg) for humidity sensing.
* [OLED 128x64 i2c display](https://www.google.fi/url?sa=t&rct=j&q=&esrc=s&source=web&cd=1&cad=rja&uact=8&ved=0ahUKEwi40IvJzabVAhWGHpoKHVD3AZIQFggmMAA&url=https%3A%2F%2Fwww.adafruit.com%2Fproduct%2F938&usg=AFQjCNErzBhoFRdpFBCtOP0zG13FpqpjAg) to display useful status information like current humidity and tcp server endpoint address.
* [2 relay module](http://modtronix.com/mod-rly2-5v.html) to control fan and vaporizer power. Make sure to short-jumper JD-VCC and VCC together, it will indicate to the module that single power input will be used for the opto-couple.
* [5v fan](https://www.google.fi/url?sa=t&rct=j&q=&esrc=s&source=web&cd=1&cad=rja&uact=8&ved=0ahUKEwiO8_SBzqbVAhWFHpoKHYDwBJkQFggmMAA&url=https%3A%2F%2Fwww.adafruit.com%2Fproduct%2F3368&usg=AFQjCNGwcKJoz_zj9CBwvwvejntjYVeOqw) or similar. For larger spaces make sure to source enough fans as by definition 5v fans are not very powerfull.
* 2x [Reed magnetic switch](https://www.google.fi/url?sa=t&rct=j&q=&esrc=s&source=web&cd=2&cad=rja&uact=8&ved=0ahUKEwjRhqiTzqbVAhVJL1AKHcS_DrAQFggyMAE&url=https%3A%2F%2Fwww.sparkfun.com%2Fproducts%2F8642&usg=AFQjCNFH63Wpxtjxo6HaqfcIasXa-zPbkA), one to be used as door sensor and another as water level sensor.
* Usb-powered [mistifiers/vaporizers/purifiers](https://www.ebay.com/sch/i.html?_odkw=usb+vaporizer&_osacat=0&_from=R40&_trksid=p2045573.m570.l1313.TR0.TRC0.H0.Xusb+vaporizer+or+mist.TRS0&_nkw=usb+vaporizer+or+mist&_sacat=0) used for creating mist. Initially I used to rip apart them and reuse the control board while replacing the ceramic element only. Nowadays I see there are separate sells for only [the control board](http://www.ebay.com/itm/5V-USB-Ultrasonic-Mist-Maker-Driver-Board-Atomization-Discs-Humidifier-Nebulizer-/172645819896?hash=item28327e25f8:g:GAsAAOSw1WJZN5kI) and [the ceramic elements](http://www.ebay.com/itm/10pcs-113KHz-Mist-Maker-D16mm-Transducer-Ceramic-Humidifier-Accessories/361916513356?_trksid=p2047675.c100005.m1851&_trkparms=aid%3D555018%26algo%3DPL.SIM%26ao%3D2%26asc%3D45726%26meid%3D0e9ba0835b294102a850797236c75709%26pid%3D100005%26rk%3D1%26rkt%3D6%26sd%3D371897595021).
* Male pin headers, start with 12 but more is better.
* [5V 2A usb power supply](https://www.google.fi/url?sa=t&rct=j&q=&esrc=s&source=web&cd=1&cad=rja&uact=8&ved=0ahUKEwid_eW__qbVAhUFnJQKHd68A0wQFggmMAA&url=https%3A%2F%2Fwww.adafruit.com%2Fproduct%2F1995&usg=AFQjCNFjOZmfMJAFXk2wgQhEhLgwscKljg)

Usb-vaporizer schematics is based on assumption that you'd use physically separated control board and ceramic element. If you opt to use single package setup, as they sell them ready to use, you can omit the atomizer ceramic disk connectivity.

The door sensor input is sofware debounced since reed sensors tend to flicker when switching on. I used to have a hardware debouncer but now I tend to use software for it.

Water level sensor would require some ingenuinity from your side. Initially I used plain cable wires as contacts to detect water. But there were inherent problems with this approach:
* using good quality destilled water is also deionized. For the wires contact to operate, one should add salt, vinegar or orther additives.
* resistance experienced by the wires would vary greatly, depending on wires length, distance and ionization of the water.
* electroise effect of the current passing through the wires eventially would disolve one of them. In my case thin cable wires where disolving for just about 2 days.
So, eventually I settled for a magnet and reed sensor, placed in sealed bottle cap.

## Assembly

### Control board
Perhaps the simples way is to use provided PCB and solder only the elements and components. If you want, ask me if I have some left-over boards, otherwise you can order from [EasyEDA](https://easyeda.com/nikolai.fiikov/humidifier-ab647a3a4d064fe59c5edce4c8fcaf46).

Or use breadboard or any other means to assemble the schematics.

### Active elements
These are the thinks outside software or electronics. One has to prepare running setup for ;
* fan
* vaporizer
* assembly case/setup for fan and vaporizer
* door sensor
* water sensor

#### Fan
Fan's purpose is to circulate air, during and after vaporization.
Any ideas for setup should be generally good but here are few comments to note:
* typically the large space to humidify, the more the fan has to work (change in sw code). Or the large fan to be used (to move more air). Initially I used an internal laptop cooling fan, in my last last setup I use 2 fans.
* perhaps it is good idea to have the fans "blow" the air rather than "suck" it. When vaporizer is on, if the the mist passes through the fan will wears them fast. In my initial setup the internal laptop fan I used was sucking the air and directing it towards the cabinet's top. But after 1y it wore out and became noisy. Nowadays I have a small box made of plexyglass, where vaporizing element is placed with pipe exit and fans blow air into it.

#### Usb vaporizer
They come in many shapes and features. Initially I used one line this [one](http://www.ebay.com/itm/USB-Mini-Water-Bottle-Caps-Humidifier-Air-Diffuser-Aroma-Mist-Maker-Home-Office-/122255682245?var=&hash=item1c7701aac5:m:minNTUWiu_GnYQEJ53BO-XA). And then ripped it apart and started reusing the control board and replace ceramic disks only (by ripping apart another mistifier). As I listed abobe, nowadays one can order these separately. Basically you can choose whatever you like. Few comments to note about them:
* some come with explicit on/off button. In such case, you'd have to solder shortcut because the schematics expects to switch it on only by applying power.
* some are generally workign better than others, do not expect that every one you buy will be ok. Experiment.
* originally I left the vaporizer be standing and simply sucked its air with the fan. But because the humidity destroys th fan, nowadays I've assembled a small plexyglass chamber, where the ceramic disk vaporizes and fans are blowing air into it. There is single exit whole, so humidified air exists from there. 

#### Assembly case
Basic goal is to keep fan and the vaporizer in such relation that the fan can blow the air into the vaporizer and then direct it somewhere, in my case from bottom to the top of the cabinet.

#### Door sensor
I used reed sensor attached to the coupbaord side and magnet attached to the door. Feel free to choose any setup you like here as long as keeps closed contact when "door is closed".

### Water sensor
The design is based on reading NodeMCU analog A0 input. 
Initially I intended to use submerged plain wires as contacts +3v-A0 but because of the mentioned above side effects I changed my mind. Now I use a sealed bottle cap with reed sensor insider and magnet, placed in the water cup.
Feel free to choose your way as long as it keeps contacts open when there is "enough" water.

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
This though does not survive restart sequence.

### To disable water sensor

One can leave JP1 unconnected. This is equivalent to water being enough always.

Or one can modify sw code and skip the entire door-related input schematics : 
```lua
waterLevelSensor.lua: data.IsSensorMonitored = false
```

Or it can issue following command over running tcp server :
```shell
echo 'waterLevelSensor.IsSensorMonitored = false' | nc [IP] 8765
```
This though does not survive restart sequence.

## Installing the software
Deployment to NodeMCU happens via normal upload means i.e. nodemcu-tool or nodemcu-uploader.

```shell
git clone https://github.com/fikin/humidifier.git humidifier
cd humidifier/app
make dist
vi target/dist/wifi-credentials.txt # enter your wifi details or remove the file altogether (to start own "humidifier" AP)
nodemcu-tools -o target/dist/*.lua
nodemcu-tools target/dist/*.txt
```

## Hacking the code
Once NodeMCU is powered on, init.lua offers a 15sec delay to interrup the boot sequence, with ESPlorer just issue 'tmr.stop(1)'.

Then it connects to specified wifi AP or opens its own (named "humidifier").
Lastly it initializes the sensors and starts the control loop (500ms loop interval).

All sensors code is isolated from each other. 
The modules export data structures only, mostly the functionality is implemented as local functions.
Main.lua is the only one defining global vars.
All sensors are having their read control loops done as timers, populating the data structure fields.

Display.lua is the only module referrencing all sensors. As such it "weakly" expects them as global variables (main.lua does that).

Mistifier.lua is the control loop for the fan and vaporizer. It require() door, water and humidity sensors.

Main.lua require() all other modules, defines them as global variables and then frees the memory for wifi.

Init.lua will require() main and then free its memory.

Wifi-credentials.txt contains ssId and pwd for the wifi to connect to. The syntax used is lua because it is loaded via loadfile(), Make sure to modify it accordingly before uploading to NodeMCU. Or remove it completely, in this case NodeMCU will start own AP.

## Using the humidifier
Basically provide power and water. 

I used to use tap water but algae was forming rather fast. For long time I used to add a tap of vinegar, which slowed algae growth but apparently there are other types of algae, vinegar friendly.

Now I use distiled water, sold for car batteries. It is deionized and generally the best option one can make.

Remote control can be done via humidifier.local or humidifier.<default domain>:8765.
The server expects plain Lua command and returns the result in json format.
For example :
```
echo 'return { waterLevelSensor, humiditySensor, doorSensor, mistifier }' | nc humidifier.local 8765 | python -m json.tool
```
will return the state of each sensor as array of objects.

If you want to change values, make sure to check which field you want to change and send an assignement command. 
For example :
```
echo 'humiditySensor.HumidityThreshold = 60' | nc humidifier.local 8765 | python -m json.tool
```
will set the humidifier control loop to 60% target instead of default 70%.

*Note* that there is limited memory in NodeMCU and submitting some types of commands can brick it.