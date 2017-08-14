local data = {
  IsSensorMonitored = true,
  WhatSensorValueIsWaterTooLow = 1024,
  ReadIntervalMs = 900,
  isWaterLevelOk = false,
  msg = nil
}

local function readWaterSensor(timerObj)
  if timerObj then
    if data.IsSensorMonitored then
      if adc.read(0) >= data.WhatSensorValueIsWaterTooLow then
        data.isWaterLevelOk = false
        data.msg = 'Water : Add water!!!'
      else
        data.isWaterLevelOk = true
        data.msg = 'Water : level ok'
      end
    else
      data.isWaterLevelOk = true
      data.msg = 'Water : disabled'
    end
    timerObj:unregister()
  else
    data.isWaterLevelOk = false
    data.msg = 'Water : init ...'
  end
  if not tmr.create():alarm(data.ReadIntervalMs, tmr.ALARM_SINGLE, readWaterSensor) then 
    data.isWaterLevelOk = true
    data.msg = 'Water : disabled'
  end
  print(data.msg);
end

readWaterSensor(nil)

return data