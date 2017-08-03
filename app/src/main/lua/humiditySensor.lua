local data = {
  temperature = 0,
  humidity = 0,
  msg = nil,
  isHumiditySensorOk = false,
  isHumidityTooLow = false,
  ReadIntervalMs = 7000,
  HumidityThreshold = 70,
  IsSensorMonitored = true,
  DhtPin = 3 -- D3 -- GPIO0 -- Flash
}

local function readHumiditySensor(timerObj)
  if timerObj then
    if data.IsSensorMonitored then
      local status, temperature, humi, temp_decimial, humi_decimial = dht.read(data.DhtPin)
      if status == dht.OK then
        -- Prevent "0.-2 deg C" or "-2.-6"          
        --data.temperature = tonumber(temperature.."."..(math.abs(temp_decimial)/100))  -- with decimal precision, for floaf firmware
        data.temperature = tonumber(temperature)
        -- If temp is zero and temp_decimal is negative, then add "-" to the temperature string
        if(temperature == 0 and temp_decimial<0) then
          data.temperature = tonumber("-"..temperature)
        end
        -- data.humidity = tonumber(humi.."."..(math.abs(humi_decimial)/100))  -- with decimal precision, for floaf firmware
        data.humidity = tonumber(humi)
        data.msg = '   '..tostring(data.humidity)..'%   '..tostring(data.temperature)..'°C'
        data.isHumiditySensorOk = true
        data.isHumidityTooLow = data.humidity < data.HumidityThreshold
      else
        data.isHumiditySensorOk = false
        data.isHumidityTooLow = false
        if status == dht.ERROR_CHECKSUM then
          data.msg = 'Humidity : checksum err'
        elseif status == dht.ERROR_TIMEOUT then
          data.msg = 'Humidity : timeout'
        else
          data.msg = 'Humidity : err '..tostring(status)
        end
      end
    else
       data.isHumiditySensorOk = false
       data.isHumidityTooLow = false
       data.msg = 'Humidity : disabled'
    end
  else
    data.msg = 'Humidity : init ...'
    data.isHumiditySensorOk = false
    data.isHumidityTooLow = false
  end
  if not tmr.create():alarm(data.ReadIntervalMs, tmr.ALARM_SINGLE, readHumiditySensor) then
    data.isHumiditySensorOk = false
    data.isHumidityTooLow = false
    data.msg = 'Humidity : stopped'
  end
  print(data.msg);
end

readHumiditySensor(nil)

return data