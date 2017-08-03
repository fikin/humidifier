luaunit = require('luaunit')

require('gpio')
require('tmr')

local function newObj()
  gpio.TestData.reset()
  tmr.TestData.reset()
  package.loaded['humiditySensor'] = {
    isHumidityTooLow = false
  }
  package.loaded['waterLevelSensor'] = {
    isWaterLevelOk = true
  }
  package.loaded['doorSensor'] = {
    isDoorOpen = false
  }
  local moduleName = 'mistifier'
  local s = require(moduleName)
  package.loaded[moduleName] = nil
  return s
end

function testInit()
  local s = newObj()
  luaunit.assertFalse( s.isFanOn )
  luaunit.assertFalse( s.isMistifierOn )
  luaunit.assertTrue( s.IsControlLoopEnabled )
end

function testLowHumidity()
  local s = newObj()
  require('humiditySensor').isHumidityTooLow = true
  Timer.joinAll(550)
  luaunit.assertTrue( s.isFanOn )
  luaunit.assertTrue( s.isMistifierOn )
end

function testDoorOpen()
  local s = newObj()
  require('humiditySensor').isHumidityTooLow = true
  Timer.joinAll(550)
  luaunit.assertTrue( s.isFanOn )
  luaunit.assertTrue( s.isMistifierOn )
  require('doorSensor').isDoorOpen = true
  Timer.joinAll(500)
  luaunit.assertFalse( s.isFanOn )
  luaunit.assertFalse( s.isMistifierOn )
  require('doorSensor').isDoorOpen = false
  Timer.joinAll(500)
  luaunit.assertTrue( s.isFanOn )
  luaunit.assertTrue( s.isMistifierOn )
end

function testWaterLow()
  local s = newObj()
  require('humiditySensor').isHumidityTooLow = true
  Timer.joinAll(550)
  luaunit.assertTrue( s.isMistifierOn )
  require('waterLevelSensor').isWaterLevelOk = false
  Timer.joinAll(500)
  luaunit.assertFalse( s.isMistifierOn )
  require('waterLevelSensor').isWaterLevelOk = true
  Timer.joinAll(500)
  luaunit.assertTrue( s.isMistifierOn )
end

function testPeriodicFanOn()
  local s = newObj()
  luaunit.assertFalse( s.isMistifierOn )
  luaunit.assertFalse( s.isFanOn )
  s.StartFanAfterMicrosec = 500000 -- 500ms in microsec format
  s.StopFanAfterMicrosec = 500000
  Timer.joinAll(550)
  luaunit.assertTrue( s.isFanOn )
  Timer.joinAll(500)
  luaunit.assertFalse( s.isFanOn )
  Timer.joinAll(500)
  luaunit.assertTrue( s.isFanOn )
  Timer.joinAll(500)
  luaunit.assertFalse( s.isFanOn )
end

function testDisableLoop()
  local s = newObj()
  luaunit.assertFalse( s.isMistifierOn )
  luaunit.assertFalse( s.isFanOn )
  luaunit.assertTrue( s.IsControlLoopEnabled )
  s.IsControlLoopEnabled = false
  Timer.joinAll(550)
  luaunit.assertFalse( s.isMistifierOn )
  luaunit.assertFalse( s.isFanOn )
  luaunit.assertFalse( s.IsControlLoopEnabled )
  s.IsControlLoopEnabled = true
  Timer.joinAll(500)
  luaunit.assertFalse( s.isMistifierOn )
  luaunit.assertFalse( s.isFanOn )
  luaunit.assertTrue( s.IsControlLoopEnabled )
end

os.exit( luaunit.LuaUnit.run() )
