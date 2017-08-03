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

function testMain()
  local m = require('main')
  
  wifi.TestData.sta.onConfigureCb = function(cfg) return true end

  m(function(srvStarted)
    luaunit.assertTrue(srvStarted) 
    TcpListener.TestData.receiveIncomingConnection(
      net.TestData.listeners[ netsrv.ServerPort ], 
      44, 
      '33.33.33.33', 
      net.TestData.inputArrayFnc({'return 1234', 'return { a="AA" }'}, false),
      net.TestData.collectDataFnc
    )
  end)

  Timer.joinAll(4000)

  luaunit.assertIsNil(package.loaded["wificon"])
--  luaunit.assertNotIsNil(package.loaded["main"])
  luaunit.assertNotIsNil(waterLevelSensor)
  luaunit.assertNotIsNil(humiditySensor)
  luaunit.assertNotIsNil(doorSensor)
  luaunit.assertNotIsNil(mistifier)
  luaunit.assertNotIsNil(display)

  luaunit.assertEquals(net.TestData.collected, { '{"result":1234,"status":true}', '{"result":{"a":"AA"},"status":true}' })
end

os.exit( luaunit.LuaUnit.run() )
