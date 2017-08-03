local data = {
  isDoorOpen = false,
  msg = nil,
  IsSensorMonitored = false,
  DoorSwitchPin = 5 -- D5 -- GPIO14
}

local eventsDropWindowMicrosec = 200000 -- 200ms
local lastChangeTs = -200000 -- to ensure entry from initialization code passes debouncing timeout

local function readDoorSensor(level)
  -- sw debounce for reed switch
  if require('duration').getDelta(lastChangeTs) < eventsDropWindowMicrosec then return end
  -- accept event
  lastChangeTs = tmr.now()
  data.isDoorOpen = level == gpio.HIGH
  data.msg = data.isDoorOpen and 'Door : CLOSE IT!' or 'Door : is closed.'
  print(data.msg)
end

data.enableTheSensor = function(flg)
  if flg and not data.IsSensorMonitored then
    print('Door sensor enabled.')
    data.IsSensorMonitored = true
    gpio.trig(data.DoorSwitchPin, 'both', readDoorSensor)
    readDoorSensor(gpio.read(data.DoorSwitchPin) == 0 and gpio.LOW or gpio.HIGH)
    return 'Door sensor enabled.'
  elseif not flg and data.IsSensorMonitored then
    print('Door sensor disabled.')
    data.IsSensorMonitored = false
    data.isDoorOpen = false
    data.msg = 'Door : disabled'
    gpio.trig(data.DoorSwitchPin, "none", nil)
    return 'Door sensor disabled.'
  end
end

gpio.mode(data.DoorSwitchPin, gpio.INT, gpio.PULLUP)
data.enableTheSensor(true)

return data