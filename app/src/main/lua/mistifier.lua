local data = {
  msg = nil,
  isFanOn = true,
  isMistifierOn = true,
  StopFanAfterMicrosec  =  20000000, -- 20sec
  StartFanAfterMicrosec = 120000000, -- 120sec  2min
  FanOnPin = 6 -- D6 -- GPIO12 -- default high
  ,MistifierOnPin = 7 -- D7 -- GPI13 -- default high
  ,IsControlLoopEnabled = true
  ,ReadIntervalMs = 500
}

local fanMsg = nil
local mistifierMsg = nil
local fanTimestamp = 0

local function setFan(isOn)
  if data.isFanOn ~= isOn then
    gpio.mode(data.FanOnPin, gpio.OUTPUT)
    gpio.write(data.FanOnPin, isOn and gpio.LOW or gpio.HIGH)
    fanTimestamp = tmr.now()
    data.isFanOn = isOn
    fanMsg = isOn and 'Fan:ON' or 'Fan:OFF'
  end
end

local function setMistifier(isOn)
  if data.isMistifierOn ~= isOn then
    gpio.mode(data.MistifierOnPin, gpio.OUTPUT)
    gpio.write(data.MistifierOnPin, isOn and gpio.LOW or gpio.HIGH)
    data.isMistifierOn = isOn
    fanTimestamp = tmr.now()
    mistifierMsg = isOn and 'Mist:ON' or 'Mist:OFF'
  end
end

local function controlMistifier(isDoorOpen)
  local isWaterLow = not require('waterLevelSensor').isWaterLevelOk
  local isHumidityLow = require('humiditySensor').isHumidityTooLow
  local isHumidityTooMuch = not isHumidityLow
  if isDoorOpen or isWaterLow or isHumidityTooMuch then
    setMistifier(false)
  elseif isHumidityLow then
    setMistifier(true)
  end
end

local function controlFan(isDoorOpen)
  local isFanOn = data.isFanOn
  local isFanOff = not isFanOn
  local isMistifierOn = data.isMistifierOn
  local deltaTime = require('duration').getDelta(fanTimestamp)
  local isTimeToStopCirculatingAir = deltaTime >= tonumber(data.StopFanAfterMicrosec)
  local isTimeToStartCirculatingAir = deltaTime >= tonumber(data.StartFanAfterMicrosec)
  if isMistifierOn then
    setFan(true)
  elseif isDoorOpen then
    setFan(false)
  elseif isFanOn and isTimeToStopCirculatingAir then 
    setFan(false)
  elseif isFanOff and isTimeToStartCirculatingAir then 
    setFan(true)
  end
end

local function controlLoop(timerObj)
  if timerObj then
    if data.IsControlLoopEnabled then
      local isDoorOpen = require('doorSensor').isDoorOpen
      controlMistifier(isDoorOpen)
      controlFan(isDoorOpen)
      data.msg = mistifierMsg..' '..fanMsg
    else
      data.msg = 'Control loop disabled.'
      setMistifier(false)
      setFan(false)
    end
  else
    data.msg = 'Control loop initializing.'
    setFan(false)
    setMistifier(false)
  end
  if not tmr.create():alarm(data.ReadIntervalMs, tmr.ALARM_SINGLE, controlLoop) then 
    data.msg = 'Control loop stopped.'
    setFan(false)
    setMistifier(false)
  end
  print(data.msg)
end

controlLoop(nil)

return data
