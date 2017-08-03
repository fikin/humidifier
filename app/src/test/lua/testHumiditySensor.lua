luaunit = require('luaunit')

require('Timer')
require('dht')
require('tmr')

local function newSensor()
  dht.TestData.reset()
  tmr.TestData.reset()
  local moduleName = 'humiditySensor'
  local s = require(moduleName)
  package.loaded[moduleName] = nil
  return s
end

function testInitState()
  local s = newSensor()
  luaunit.assertFalse( s.isHumiditySensorOk )
  luaunit.assertFalse( s.isHumidityTooLow )
  luaunit.assertTrue( s.IsSensorMonitored )
end

function testHumidityOk()
  local s = newSensor()
  dht.TestData.setValueReadSequence( { { dht.OK, 23, 70, 0, 0 } } )
  Timer.joinAll(7500)
  luaunit.assertFalse( s.isHumidityTooLow )
end

function testWaterNotOk()
  local s = newSensor()
  Timer.joinAll(7500)
  luaunit.assertTrue( s.isHumidityTooLow )
end

function testDisableMonitor()
  local s = newSensor()
  s.ReadIntervalMs = 500
  Timer.joinAll(7500)
  luaunit.assertTrue( s.isHumidityTooLow )
  s.IsSensorMonitored = false
  Timer.joinAll(500)
  luaunit.assertFalse( s.IsSensorMonitored )
  luaunit.assertFalse( s.isHumidityTooLow )
  s.IsSensorMonitored = true
  Timer.joinAll(500)
  luaunit.assertTrue( s.IsSensorMonitored )
  luaunit.assertTrue( s.isHumidityTooLow )
end

os.exit( luaunit.LuaUnit.run() )
