local data = {
  isDoorOpen = false,
  msg = nil,
  IsSensorMonitored = true,
  ReadIntervalMs = 500,
  DoorSwitchPin = 5 -- D5 -- GPIO14
}

local function readDoorSensor(timerObj)
  if data.IsSensorMonitored then
    data.isDoorOpen = gpio.read(data.DoorSwitchPin) == gpio.HIGH
    data.msg = data.isDoorOpen and 'Door : CLOSE IT!' or 'Door : is closed.'
  else
    print('Door sensor disabled.')
    data.isDoorOpen = false
    data.msg = 'Door : disabled'
  end
  if not tmr.create():alarm(data.ReadIntervalMs, tmr.ALARM_SINGLE, readDoorSensor) then 
    data.isWaterLevelOk = true
    data.msg = 'Door : disabled'
  end
  print(data.msg)
end

gpio.mode(data.DoorSwitchPin,gpio.INPUT,gpio.PULLUP)
readDoorSensor(nil)

return data