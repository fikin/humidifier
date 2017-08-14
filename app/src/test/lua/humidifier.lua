local base_char,keywords=128,{"and","break","do","else","elseif","end","false","for","function","if","in","local","nil","not","or","repeat","return","then","true","until","while",}; function prettify(code) return code:gsub("["..string.char(base_char).."-"..string.char(base_char+#keywords).."]", 
	function (c) return keywords[c:byte()-base_char]; end) end return assert(loadstring(prettify[===[package.preload['waterLevelSensor']=(�(...)
� e={
IsSensorMonitored=�,
WhatSensorValueIsWaterTooLow=20,
ReadIntervalMs=900,
isWaterLevelOk=�,
msg=�
}
� � a(t)
� t �
� e.IsSensorMonitored �
� adc.read(0)>=e.WhatSensorValueIsWaterTooLow �
e.isWaterLevelOk=�
e.msg='Water : Add water!!!'
�
e.isWaterLevelOk=�
e.msg='Water : level ok'
�
�
e.isWaterLevelOk=�
e.msg='Water : disabled'
�
t:unregister()
�
e.isWaterLevelOk=�
e.msg='Water : init ...'
�
� � tmr.create():alarm(e.ReadIntervalMs,tmr.ALARM_SINGLE,a)�
e.isWaterLevelOk=�
e.msg='Water : disabled'
�
print(e.msg);
�
a(�)
� e �)
package.preload['humiditySensor']=(�(...)
� e={
temperature=0,
humidity=0,
msg=�,
isHumiditySensorOk=�,
isHumidityTooLow=�,
ReadIntervalMs=7e3,
HumidityThreshold=70,
IsSensorMonitored=�,
DhtPin=3
}
� � o(t)
� t �
� e.IsSensorMonitored �
� t,a,i,o,n=dht.read(e.DhtPin)
� t==dht.OK �
e.temperature=tonumber(a)
�(a==0 � o<0)�
e.temperature=tonumber("-"..a)
�
e.humidity=tonumber(i)
e.msg='   '..tostring(e.humidity)..'%   '..tostring(e.temperature)..'°C'
e.isHumiditySensorOk=�
e.isHumidityTooLow=e.humidity<e.HumidityThreshold
�
e.isHumiditySensorOk=�
e.isHumidityTooLow=�
� t==dht.ERROR_CHECKSUM �
e.msg='Humidity : checksum err'
� t==dht.ERROR_TIMEOUT �
e.msg='Humidity : timeout'
�
e.msg='Humidity : err '..tostring(t)
�
�
�
e.isHumiditySensorOk=�
e.isHumidityTooLow=�
e.msg='Humidity : disabled'
�
�
e.msg='Humidity : init ...'
e.isHumiditySensorOk=�
e.isHumidityTooLow=�
�
� � tmr.create():alarm(e.ReadIntervalMs,tmr.ALARM_SINGLE,o)�
e.isHumiditySensorOk=�
e.isHumidityTooLow=�
e.msg='Humidity : stopped'
�
print(e.msg);
�
o(�)
� e �)
package.preload['doorSensor']=(�(...)
� e={
isDoorOpen=�,
msg=�,
IsSensorMonitored=�,
DoorSwitchPin=5
}
� o=2e5
� a=-2e5
� � t(t)
� require('duration').getDelta(a)<o � � �
a=tmr.now()
e.isDoorOpen=t==gpio.HIGH
e.msg=e.isDoorOpen �'Door : CLOSE IT!'�'Door : is closed.'
print(e.msg)
�
e.enableTheSensor=�(a)
� a � � e.IsSensorMonitored �
print('Door sensor enabled.')
e.IsSensorMonitored=�
gpio.trig(e.DoorSwitchPin,'both',t)
t(gpio.read(e.DoorSwitchPin)==0 � gpio.LOW � gpio.HIGH)
�'Door sensor enabled.'
� � a � e.IsSensorMonitored �
print('Door sensor disabled.')
e.IsSensorMonitored=�
e.isDoorOpen=�
e.msg='Door : disabled'
gpio.trig(e.DoorSwitchPin,"none",�)
�'Door sensor disabled.'
�
�
gpio.mode(e.DoorSwitchPin,gpio.INT,gpio.PULLUP)
e.enableTheSensor(�)
� e �)
package.preload['mistifier']=(�(...)
� e={
msg=�,
isFanOn=�,
isMistifierOn=�,
StopFanAfterMicrosec=2e7,
StartFanAfterMicrosec=12e7,
FanOnPin=6
,MistifierOnPin=7
,IsControlLoopEnabled=�
,ReadIntervalMs=500
}
� n=�
� i=�
� o=0
� � t(t)
� e.isFanOn~=t �
gpio.mode(e.FanOnPin,gpio.OUTPUT)
gpio.write(e.FanOnPin,t � gpio.LOW � gpio.HIGH)
o=tmr.now()
e.isFanOn=t
n=t �'Fan:ON'�'Fan:OFF'
�
�
� � a(t)
� e.isMistifierOn~=t �
gpio.mode(e.MistifierOnPin,gpio.OUTPUT)
gpio.write(e.MistifierOnPin,t � gpio.LOW � gpio.HIGH)
e.isMistifierOn=t
o=tmr.now()
i=t �'Mist:ON'�'Mist:OFF'
�
�
� � r(i)
� o=� require('waterLevelSensor').isWaterLevelOk
� e=require('humiditySensor').isHumidityTooLow
� t=� e
� i � o � t �
a(�)
� e �
a(�)
�
�
� � h(i)
� a=e.isFanOn
� n=� a
� h=e.isMistifierOn
� o=require('duration').getDelta(o)
� s=o>=tonumber(e.StopFanAfterMicrosec)
� e=o>=tonumber(e.StartFanAfterMicrosec)
� h �
t(�)
� i �
t(�)
� a � s �
t(�)
� n � e �
t(�)
�
�
� � o(s)
� s �
� e.IsControlLoopEnabled �
� t=require('doorSensor').isDoorOpen
r(t)
h(t)
e.msg=i..' '..n
�
e.msg='Control loop disabled.'
a(�)
t(�)
�
�
e.msg='Control loop initializing.'
t(�)
a(�)
�
� � tmr.create():alarm(e.ReadIntervalMs,tmr.ALARM_SINGLE,o)�
e.msg='Control loop stopped.'
t(�)
a(�)
�
print(e.msg)
�
o(�)
� e
�)
package.preload['display']=(�(...)
� e={
Sda=1
,Scl=2
,Sla=60
,ReadIntervalMs=2e3
,disp={}
}
� � t(a)
� a �
a:unregister()
e.disp:firstPage()
�
e.disp:drawFrame(0,0,127,63)
e.disp:drawStr(3,8,humiditySensor � humiditySensor.msg �'Humidity stopped')
e.disp:drawStr(3,16,doorSensor � doorSensor.msg �'Door stopped')
e.disp:drawStr(3,24,waterLevelSensor � waterLevelSensor.msg �'Water stopped')
e.disp:drawStr(3,32,mistifier � mistifier.msg �'Mist+FAN stopped')
e.disp:drawStr(3,40,netsrv � netsrv.msgWifi �'Wifi stopped')
e.disp:drawStr(3,48,netsrv � netsrv.msg �'Srv stopped')
� e.disp:nextPage()==�
�
print('Display : initializing')
i2c.setup(0,e.Sda,e.Scl,i2c.SLOW)
e.disp=u8g.ssd1306_128x64_i2c(e.Sla)
e.disp:setFont(u8g.font_6x10)
e.disp:setFontRefHeightExtendedText()
e.disp:setDefaultForegroundColor()
e.disp:setFontPosTop()
�
� � tmr.create():alarm(e.ReadIntervalMs,tmr.ALARM_SINGLE,t)�
print('Display : stopped')
e.disp:firstPage()
�
e.disp:drawFrame(0,0,127,63)
e.disp:drawStr(3,24,'Display stopped')
� e.disp:nextPage()==�
�
�
t(�)
� e �)
package.preload['netsrv']=(�(...)
� e={
msg='',
msgWifi='',
ServerPort=8765
}
� t=�
� � i(t,a,e)
� � e � e=''�
� e={status=a,result=e}
� a=sjson.encoder(e)
� � o(e)
� a=a:read(1024)
� a �
e:send(a)
�
e:close()
�
�
t:on('sent',o)
o(t)
�
� � a(t)
print('netsrv: new connection')
t:on('receive',�(t,e)
print('netsrv: handling request '..e)
� a,e=pcall(loadstring(e))
i(t,a,e)
�)
�
e.startServer=�()
� o,i,i=wifi.getmode()==wifi.SOFTAP � wifi.ap.getip()� wifi.sta.getip()
e.msg=o..':'..e.ServerPort
t=net.createServer(net.TCP)
t:listen(e.ServerPort,a)
� wifi.getmode()==wifi.STATION � wifi.getmode()==wifi.STATIONAP �
mdns.register(wifi.sta.gethostname(),{port=e.ServerPort,service='tcp',descrption='Humidifer API'})
e.msgWifi='Wifi: '..wifi.sta.getconfig(�).ssid
�
e.msgWifi='Wifi: '..wifi.ap.getconfig(�).ssid
�
print(e.msg)
e.startServer=�
� t
�
� e �)
package.preload['wificon']=(�(...)
� e={
StaHostname='humidifier',
STASsId=�,
STASsKey=�,
STATimeoutFailureMs=6e4,
APSsId='Humidifier',
APSsKey=�,
APIp='192.168.255.1',
APMask='255.255.255.0',
APGw='192.168.255.255',
WifiCredsFile="wifi-credentials.txt"
}
� � t()
wifi.eventmon.register(wifi.eventmon.STA_DISCONNECTED,�)
wifi.eventmon.register(wifi.eventmon.STA_DHCP_TIMEOUT,�)
wifi.eventmon.register(wifi.eventmon.STA_GOT_IP,�)
�
� � r()
print('wificon: init.')
wifi.setmode(wifi.NULLMODE,�)
t()
�
� � a(n,i)
print('wificon: starting up '..e.APSsId)
wifi.setmode(wifi.SOFTAP,�)
wifi.ap.setip({ip=e.APIp,netmask=e.APMask,gateway=e.APGw})
� t={ssid=e.APSsId,pwd=e.APSsKey,auth=wifi.OPEN,hidden=�,save=�}
� wifi.ap.config(t)�
� o,a,t=wifi.ap.getip()
n(e.APSsId,{IP=o,netmask=a,gateway=t})
�
wifi.setmode(wifi.NULLMODE,�)
i(e.APSsId)
�
�
� � h(o,n)
print('wificon: starting up '..e.STASsId)
wifi.setmode(wifi.STATION,�)
wifi.sta.sethostname(e.StaHostname)
wifi.sta.autoconnect(1)
� s=tmr.now()
� � i()
� i=require('duration').getDelta(s)
� i>e.STATimeoutFailureMs �
t()
print('wificon: connecting to '..e.STASsId..' failed, starting AP mode.')
a(o,n)
�
�
� � s(a)
print('wificon: got ip '..a.IP)
t()
o(e.STASsId,a.IP)
�
wifi.eventmon.register(wifi.eventmon.STA_DISCONNECTED,i)
wifi.eventmon.register(wifi.eventmon.STA_DHCP_TIMEOUT,i)
wifi.eventmon.register(wifi.eventmon.STA_GOT_IP,s)
� e={ssid=e.STASsId,pwd=e.STASsKey,auto=�,save=�}
� wifi.sta.config(e)�
�
a(o,n)
�
�
� � t(e)
� file.exists(e)� � e
�
� e=e
� t � string.gmatch(package.path,'([^;]+)')�
� e=string.gsub(t,"%?.lua?",e)
� file.exists(e)� � e �
�
� �
�
�
� � o()
� t=t(e.WifiCredsFile)
� t �
� a,t=loadfile(t)
� t �
print('wificon: failed reading '..e.WifiCredsFile..' : '..t)
� �
�
print('wificon: '..e.WifiCredsFile..' found, reading it ...')
� t=a()
� t.ssid �
e.STASsId=t.ssid
�
print('wificon: didnot find "ssid" field after reading '..e.WifiCredsFile..' .')
� �
�
� t.pwd �
e.STASsKey=t.pwd
�
print('wificon: didnot find "pwd" field after reading '..e.WifiCredsFile..' .')
� �
�
� �
�
�
print('wificon: no '..e.WifiCredsFile..' found.')
� �
�
�
e.startWifi=�(t,e)
r()
� o()�
h(t,e)
�
a(t,e)
�
�
� e �)
package.preload['duration']=(�(...)
duration={}
duration.TMR_SWAP_TIME=1073741823
duration.TMR_SWAP_TIME=duration.TMR_SWAP_TIME*2
duration.getDelta=�(e)
� e=tmr.now()-e
� e<0 � e=e+duration.TMR_SWAP_TIME �
� e
�
� duration �)
� � o(e)
� � t()
collectgarbage()
print('main: starting sensors and display ...')
waterLevelSensor=require("waterLevelSensor")
humiditySensor=require("humiditySensor")
doorSensor=require("doorSensor")
mistifier=require("mistifier")
display=require("display")
�
� � a(a,a)
print('main: wifi ok.')
tmr.create():alarm(1e3,tmr.ALARM_SINGLE,�()
print('main: starting server ...')
collectgarbage()
netsrv=require("netsrv")
netsrv.startServer()
tmr.create():alarm(1e3,tmr.ALARM_SINGLE,�()
print('main: server ok.')
t()
� e � e(�)�
�)
�)
�
� � o(a)
print("ERROR : failed starting wifi "..a)
t()
� e � e(�)�
�
print('main: starting wifi ...')
require('wificon').startWifi(a,o)
package.loaded["wificon"]=�
�
� o]===], '@humidifier.lua'))()