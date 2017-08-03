luaunit = require('luaunit')

require('adc')
require('dht')
require('file')
require('gpio')
require('i2c')
require('mdns')
require('net')
require('node')
require('sjson')
require('tmr')
require('u8g')
require('wifi')

function testInit()
  wifi.TestData.sta.onConfigureCb = function(cfg) return true end

  require('init')
  
  Timer.joinAll(20000)
  
  luaunit.assertIsNil(package.loaded["wificon"])
  luaunit.assertIsNil(package.loaded["main"])
  luaunit.assertNotIsNil(waterLevelSensor)
  luaunit.assertNotIsNil(humiditySensor)
  luaunit.assertNotIsNil(doorSensor)
  luaunit.assertNotIsNil(mistifier)
  luaunit.assertNotIsNil(display)
end

os.exit( luaunit.LuaUnit.run() )
