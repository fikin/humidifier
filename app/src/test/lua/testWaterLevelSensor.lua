luaunit = require('luaunit')

require('adc')
require('tmr')

local function newSensor()
  adc.TestData.reset()
  tmr.TestData.reset()
  local moduleName = 'waterLevelSensor'
  local s = require(moduleName)
  package.loaded[moduleName] = nil
  return s
end

function testInitState()
  local s = newSensor()
  luaunit.assertTrue( s.IsSensorMonitored )
  luaunit.assertFalse( s.isWaterLevelOk )
end

function testWaterOk()
  local s = newSensor()
  adc.TestData.setValueReadSequence( { 0 } )
  Timer.joinAll(1000)
  luaunit.assertTrue( s.isWaterLevelOk )
end

function testWaterNotOk()
  local s = newSensor()
  Timer.joinAll(1000)
  luaunit.assertFalse( s.isWaterLevelOk )
end

function testDisableMonitor()
  local s = newSensor()
  Timer.joinAll(1000)
  luaunit.assertFalse( s.isWaterLevelOk )
  s.IsSensorMonitored = false
  Timer.joinAll(1000)
  luaunit.assertFalse( s.IsSensorMonitored )
  luaunit.assertTrue( s.isWaterLevelOk )
  s.IsSensorMonitored = true
  Timer.joinAll(1000)
  luaunit.assertTrue( s.IsSensorMonitored )
  luaunit.assertFalse( s.isWaterLevelOk )
end

os.exit( luaunit.LuaUnit.run() )
