local data = {
  Sda = 1 -- SDA pin -- D1 -- GPIO5
  ,Scl = 2 -- SCL pin -- D2 -- GPIO4
  ,Sla = 0x3C -- OLED address
  ,ReadIntervalMs = 2000
  ,disp = {}
}


local function refreshDisplay(timerObj)
  if timerObj then
    timerObj:unregister()
    -- draw page
    data.disp:firstPage()
    repeat
      data.disp:drawFrame(0,0,127,63)
      data.disp:drawStr(3, 8, humiditySensor and humiditySensor.msg or 'Humidity stopped')
      data.disp:drawStr(3, 16, doorSensor and doorSensor.msg or 'Door stopped')
      data.disp:drawStr(3, 24, waterLevelSensor and waterLevelSensor.msg or 'Water stopped')
      data.disp:drawStr(3, 32, mistifier and mistifier.msg or 'Mist+FAN stopped')
      data.disp:drawStr(3, 40, netsrv and netsrv.msgWifi or 'Wifi stopped')
      data.disp:drawStr(3, 48, netsrv and netsrv.msg or 'Srv stopped')
    until data.disp:nextPage() == false
  else
    print('Display : initializing')
    -- initialization
    i2c.setup(0, data.Sda, data.Scl, i2c.SLOW)
    data.disp = u8g.ssd1306_128x64_i2c(data.Sla)
    data.disp:setFont(u8g.font_6x10)
    data.disp:setFontRefHeightExtendedText()
    data.disp:setDefaultForegroundColor()
    data.disp:setFontPosTop()
    --data.disp:setRot180()           -- Rotate Display if needed
  end
  if not tmr.create():alarm(data.ReadIntervalMs, tmr.ALARM_SINGLE, refreshDisplay) then
    print('Display : stopped')
    data.disp:firstPage()
    repeat
      data.disp:drawFrame(0,0,127,63)
      data.disp:drawStr(3, 24, 'Display stopped')
    until data.disp:nextPage() == false
  end
end

refreshDisplay(nil)

return data