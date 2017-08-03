local function run(onFinishedCb)

  local function startSensors()
    collectgarbage()
    print('main: starting sensors and display ...') 
    waterLevelSensor = require("waterLevelSensor")
    humiditySensor = require("humiditySensor")
    doorSensor = require("doorSensor")
    mistifier = require("mistifier")
    display = require("display")
  end

  local function onWifiOk(ssId,ip)
    print('main: wifi ok.') 
    -- start server
    tmr.create():alarm( 1000, tmr.ALARM_SINGLE, function()
      print('main: starting server ...') 
      collectgarbage()
      netsrv = require("netsrv")
      netsrv.startServer()
      tmr.create():alarm( 1000, tmr.ALARM_SINGLE, function() 
        print('main: server ok.') 
        startSensors()
        if onFinishedCb then onFinishedCb(true) end
      end)
    end)
  end

  local function onWifiErr(ssId) 
    print("ERROR : failed starting wifi "..ssId)
    startSensors()
    if onFinishedCb then onFinishedCb(false) end
  end

  print('main: starting wifi ...') 
  require('wificon').startWifi(onWifiOk,onWifiErr)
  package.loaded["wificon"] = nil
end

return run