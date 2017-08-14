local base_char,keywords=128,{"and","break","do","else","elseif","end","false","for","function","if","in","local","nil","not","or","repeat","return","then","true","until","while",}; function prettify(code) return code:gsub("["..string.char(base_char).."-"..string.char(base_char+#keywords).."]", 
	function (c) return keywords[c:byte()-base_char]; end) end return assert(loadstring(prettify[===[package.preload['waterLevelSensor']=(â(...)
å e={
IsSensorMonitored=ì,
WhatSensorValueIsWaterTooLow=20,
ReadIntervalMs=900,
isWaterLevelOk=á,
msg=ç
}
å â a(t)
ä t í
ä e.IsSensorMonitored í
ä adc.read(0)>=e.WhatSensorValueIsWaterTooLow í
e.isWaterLevelOk=á
e.msg='Water : Add water!!!'
Ñ
e.isWaterLevelOk=ì
e.msg='Water : level ok'
Ü
Ñ
e.isWaterLevelOk=ì
e.msg='Water : disabled'
Ü
t:unregister()
Ñ
e.isWaterLevelOk=á
e.msg='Water : init ...'
Ü
ä é tmr.create():alarm(e.ReadIntervalMs,tmr.ALARM_SINGLE,a)í
e.isWaterLevelOk=ì
e.msg='Water : disabled'
Ü
print(e.msg);
Ü
a(ç)
ë e Ü)
package.preload['humiditySensor']=(â(...)
å e={
temperature=0,
humidity=0,
msg=ç,
isHumiditySensorOk=á,
isHumidityTooLow=á,
ReadIntervalMs=7e3,
HumidityThreshold=70,
IsSensorMonitored=ì,
DhtPin=3
}
å â o(t)
ä t í
ä e.IsSensorMonitored í
å t,a,i,o,n=dht.read(e.DhtPin)
ä t==dht.OK í
e.temperature=tonumber(a)
ä(a==0 Å o<0)í
e.temperature=tonumber("-"..a)
Ü
e.humidity=tonumber(i)
e.msg='   '..tostring(e.humidity)..'%   '..tostring(e.temperature)..'¬∞C'
e.isHumiditySensorOk=ì
e.isHumidityTooLow=e.humidity<e.HumidityThreshold
Ñ
e.isHumiditySensorOk=á
e.isHumidityTooLow=á
ä t==dht.ERROR_CHECKSUM í
e.msg='Humidity : checksum err'
Ö t==dht.ERROR_TIMEOUT í
e.msg='Humidity : timeout'
Ñ
e.msg='Humidity : err '..tostring(t)
Ü
Ü
Ñ
e.isHumiditySensorOk=á
e.isHumidityTooLow=á
e.msg='Humidity : disabled'
Ü
Ñ
e.msg='Humidity : init ...'
e.isHumiditySensorOk=á
e.isHumidityTooLow=á
Ü
ä é tmr.create():alarm(e.ReadIntervalMs,tmr.ALARM_SINGLE,o)í
e.isHumiditySensorOk=á
e.isHumidityTooLow=á
e.msg='Humidity : stopped'
Ü
print(e.msg);
Ü
o(ç)
ë e Ü)
package.preload['doorSensor']=(â(...)
å e={
isDoorOpen=á,
msg=ç,
IsSensorMonitored=á,
DoorSwitchPin=5
}
å o=2e5
å a=-2e5
å â t(t)
ä require('duration').getDelta(a)<o í ë Ü
a=tmr.now()
e.isDoorOpen=t==gpio.HIGH
e.msg=e.isDoorOpen Å'Door : CLOSE IT!'è'Door : is closed.'
print(e.msg)
Ü
e.enableTheSensor=â(a)
ä a Å é e.IsSensorMonitored í
print('Door sensor enabled.')
e.IsSensorMonitored=ì
gpio.trig(e.DoorSwitchPin,'both',t)
t(gpio.read(e.DoorSwitchPin)==0 Å gpio.LOW è gpio.HIGH)
ë'Door sensor enabled.'
Ö é a Å e.IsSensorMonitored í
print('Door sensor disabled.')
e.IsSensorMonitored=á
e.isDoorOpen=á
e.msg='Door : disabled'
gpio.trig(e.DoorSwitchPin,"none",ç)
ë'Door sensor disabled.'
Ü
Ü
gpio.mode(e.DoorSwitchPin,gpio.INT,gpio.PULLUP)
e.enableTheSensor(ì)
ë e Ü)
package.preload['mistifier']=(â(...)
å e={
msg=ç,
isFanOn=ì,
isMistifierOn=ì,
StopFanAfterMicrosec=2e7,
StartFanAfterMicrosec=12e7,
FanOnPin=6
,MistifierOnPin=7
,IsControlLoopEnabled=ì
,ReadIntervalMs=500
}
å n=ç
å i=ç
å o=0
å â t(t)
ä e.isFanOn~=t í
gpio.mode(e.FanOnPin,gpio.OUTPUT)
gpio.write(e.FanOnPin,t Å gpio.LOW è gpio.HIGH)
o=tmr.now()
e.isFanOn=t
n=t Å'Fan:ON'è'Fan:OFF'
Ü
Ü
å â a(t)
ä e.isMistifierOn~=t í
gpio.mode(e.MistifierOnPin,gpio.OUTPUT)
gpio.write(e.MistifierOnPin,t Å gpio.LOW è gpio.HIGH)
e.isMistifierOn=t
o=tmr.now()
i=t Å'Mist:ON'è'Mist:OFF'
Ü
Ü
å â r(i)
å o=é require('waterLevelSensor').isWaterLevelOk
å e=require('humiditySensor').isHumidityTooLow
å t=é e
ä i è o è t í
a(á)
Ö e í
a(ì)
Ü
Ü
å â h(i)
å a=e.isFanOn
å n=é a
å h=e.isMistifierOn
å o=require('duration').getDelta(o)
å s=o>=tonumber(e.StopFanAfterMicrosec)
å e=o>=tonumber(e.StartFanAfterMicrosec)
ä h í
t(ì)
Ö i í
t(á)
Ö a Å s í
t(á)
Ö n Å e í
t(ì)
Ü
Ü
å â o(s)
ä s í
ä e.IsControlLoopEnabled í
å t=require('doorSensor').isDoorOpen
r(t)
h(t)
e.msg=i..' '..n
Ñ
e.msg='Control loop disabled.'
a(á)
t(á)
Ü
Ñ
e.msg='Control loop initializing.'
t(á)
a(á)
Ü
ä é tmr.create():alarm(e.ReadIntervalMs,tmr.ALARM_SINGLE,o)í
e.msg='Control loop stopped.'
t(á)
a(á)
Ü
print(e.msg)
Ü
o(ç)
ë e
Ü)
package.preload['display']=(â(...)
å e={
Sda=1
,Scl=2
,Sla=60
,ReadIntervalMs=2e3
,disp={}
}
å â t(a)
ä a í
a:unregister()
e.disp:firstPage()
ê
e.disp:drawFrame(0,0,127,63)
e.disp:drawStr(3,8,humiditySensor Å humiditySensor.msg è'Humidity stopped')
e.disp:drawStr(3,16,doorSensor Å doorSensor.msg è'Door stopped')
e.disp:drawStr(3,24,waterLevelSensor Å waterLevelSensor.msg è'Water stopped')
e.disp:drawStr(3,32,mistifier Å mistifier.msg è'Mist+FAN stopped')
e.disp:drawStr(3,40,netsrv Å netsrv.msgWifi è'Wifi stopped')
e.disp:drawStr(3,48,netsrv Å netsrv.msg è'Srv stopped')
î e.disp:nextPage()==á
Ñ
print('Display : initializing')
i2c.setup(0,e.Sda,e.Scl,i2c.SLOW)
e.disp=u8g.ssd1306_128x64_i2c(e.Sla)
e.disp:setFont(u8g.font_6x10)
e.disp:setFontRefHeightExtendedText()
e.disp:setDefaultForegroundColor()
e.disp:setFontPosTop()
Ü
ä é tmr.create():alarm(e.ReadIntervalMs,tmr.ALARM_SINGLE,t)í
print('Display : stopped')
e.disp:firstPage()
ê
e.disp:drawFrame(0,0,127,63)
e.disp:drawStr(3,24,'Display stopped')
î e.disp:nextPage()==á
Ü
Ü
t(ç)
ë e Ü)
package.preload['netsrv']=(â(...)
å e={
msg='',
msgWifi='',
ServerPort=8765
}
å t=ç
å â i(t,a,e)
ä é e í e=''Ü
å e={status=a,result=e}
å a=sjson.encoder(e)
å â o(e)
å a=a:read(1024)
ä a í
e:send(a)
Ñ
e:close()
Ü
Ü
t:on('sent',o)
o(t)
Ü
å â a(t)
print('netsrv: new connection')
t:on('receive',â(t,e)
print('netsrv: handling request '..e)
å a,e=pcall(loadstring(e))
i(t,a,e)
Ü)
Ü
e.startServer=â()
å o,i,i=wifi.getmode()==wifi.SOFTAP Å wifi.ap.getip()è wifi.sta.getip()
e.msg=o..':'..e.ServerPort
t=net.createServer(net.TCP)
t:listen(e.ServerPort,a)
ä wifi.getmode()==wifi.STATION è wifi.getmode()==wifi.STATIONAP í
mdns.register(wifi.sta.gethostname(),{port=e.ServerPort,service='tcp',descrption='Humidifer API'})
e.msgWifi='Wifi: '..wifi.sta.getconfig(ì).ssid
Ñ
e.msgWifi='Wifi: '..wifi.ap.getconfig(ì).ssid
Ü
print(e.msg)
e.startServer=ç
ë t
Ü
ë e Ü)
package.preload['wificon']=(â(...)
å e={
StaHostname='humidifier',
STASsId=ç,
STASsKey=ç,
STATimeoutFailureMs=6e4,
APSsId='Humidifier',
APSsKey=ç,
APIp='192.168.255.1',
APMask='255.255.255.0',
APGw='192.168.255.255',
WifiCredsFile="wifi-credentials.txt"
}
å â t()
wifi.eventmon.register(wifi.eventmon.STA_DISCONNECTED,ç)
wifi.eventmon.register(wifi.eventmon.STA_DHCP_TIMEOUT,ç)
wifi.eventmon.register(wifi.eventmon.STA_GOT_IP,ç)
Ü
å â r()
print('wificon: init.')
wifi.setmode(wifi.NULLMODE,ì)
t()
Ü
å â a(n,i)
print('wificon: starting up '..e.APSsId)
wifi.setmode(wifi.SOFTAP,á)
wifi.ap.setip({ip=e.APIp,netmask=e.APMask,gateway=e.APGw})
å t={ssid=e.APSsId,pwd=e.APSsKey,auth=wifi.OPEN,hidden=á,save=á}
ä wifi.ap.config(t)í
å o,a,t=wifi.ap.getip()
n(e.APSsId,{IP=o,netmask=a,gateway=t})
Ñ
wifi.setmode(wifi.NULLMODE,ì)
i(e.APSsId)
Ü
Ü
å â h(o,n)
print('wificon: starting up '..e.STASsId)
wifi.setmode(wifi.STATION,á)
wifi.sta.sethostname(e.StaHostname)
wifi.sta.autoconnect(1)
å s=tmr.now()
å â i()
å i=require('duration').getDelta(s)
ä i>e.STATimeoutFailureMs í
t()
print('wificon: connecting to '..e.STASsId..' failed, starting AP mode.')
a(o,n)
Ü
Ü
å â s(a)
print('wificon: got ip '..a.IP)
t()
o(e.STASsId,a.IP)
Ü
wifi.eventmon.register(wifi.eventmon.STA_DISCONNECTED,i)
wifi.eventmon.register(wifi.eventmon.STA_DHCP_TIMEOUT,i)
wifi.eventmon.register(wifi.eventmon.STA_GOT_IP,s)
å e={ssid=e.STASsId,pwd=e.STASsKey,auto=ì,save=á}
ä wifi.sta.config(e)í
Ñ
a(o,n)
Ü
Ü
å â t(e)
ä file.exists(e)í ë e
Ñ
å e=e
à t ã string.gmatch(package.path,'([^;]+)')É
å e=string.gsub(t,"%?.lua?",e)
ä file.exists(e)í ë e Ü
Ü
ë ç
Ü
Ü
å â o()
å t=t(e.WifiCredsFile)
ä t í
å a,t=loadfile(t)
ä t í
print('wificon: failed reading '..e.WifiCredsFile..' : '..t)
ë á
Ñ
print('wificon: '..e.WifiCredsFile..' found, reading it ...')
å t=a()
ä t.ssid í
e.STASsId=t.ssid
Ñ
print('wificon: didnot find "ssid" field after reading '..e.WifiCredsFile..' .')
ë á
Ü
ä t.pwd í
e.STASsKey=t.pwd
Ñ
print('wificon: didnot find "pwd" field after reading '..e.WifiCredsFile..' .')
ë á
Ü
ë ì
Ü
Ñ
print('wificon: no '..e.WifiCredsFile..' found.')
ë á
Ü
Ü
e.startWifi=â(t,e)
r()
ä o()í
h(t,e)
Ñ
a(t,e)
Ü
Ü
ë e Ü)
package.preload['duration']=(â(...)
duration={}
duration.TMR_SWAP_TIME=1073741823
duration.TMR_SWAP_TIME=duration.TMR_SWAP_TIME*2
duration.getDelta=â(e)
å e=tmr.now()-e
ä e<0 í e=e+duration.TMR_SWAP_TIME Ü
ë e
Ü
ë duration Ü)
å â o(e)
å â t()
collectgarbage()
print('main: starting sensors and display ...')
waterLevelSensor=require("waterLevelSensor")
humiditySensor=require("humiditySensor")
doorSensor=require("doorSensor")
mistifier=require("mistifier")
display=require("display")
Ü
å â a(a,a)
print('main: wifi ok.')
tmr.create():alarm(1e3,tmr.ALARM_SINGLE,â()
print('main: starting server ...')
collectgarbage()
netsrv=require("netsrv")
netsrv.startServer()
tmr.create():alarm(1e3,tmr.ALARM_SINGLE,â()
print('main: server ok.')
t()
ä e í e(ì)Ü
Ü)
Ü)
Ü
å â o(a)
print("ERROR : failed starting wifi "..a)
t()
ä e í e(á)Ü
Ü
print('main: starting wifi ...')
require('wificon').startWifi(a,o)
package.loaded["wificon"]=ç
Ü
ë o]===], '@humidifier.lua'))()