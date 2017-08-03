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

function testStopInit()
  wifi.TestData.sta.onConfigureCb = function(cfg) return true end

  require('init')
  
  Timer.joinAll(5000)
  
  tmr.unregister(1)

  Timer.joinAll(5000)

  luaunit.assertIsNil(package.loaded["wificon"])
  luaunit.assertIsNil(package.loaded["main"])
  luaunit.assertIsNil(waterLevelSensor)
  luaunit.assertIsNil(humiditySensor)
  luaunit.assertIsNil(doorSensor)
  luaunit.assertIsNil(mistifier)
  luaunit.assertIsNil(display)
end

os.exit( luaunit.LuaUnit.run() )
