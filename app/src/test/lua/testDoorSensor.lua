luaunit = require('luaunit')

require('gpio')
require('tmr')

local function waitForDebounceTimeout()
  Timer.createSingle(250,function(timerObj) end):start()
  Timer.joinAll(255)
end

local function newSensor()
  gpio.TestData.reset()
  tmr.TestData.reset()
  local moduleName = 'doorSensor'
  local s = require(moduleName)
  package.loaded[moduleName] = nil
  waitForDebounceTimeout()
  return s
end

function testDoorOpen()
  local s = newSensor()
  luaunit.assertTrue( s.isDoorOpen )
  gpio.TestData.setHigh( s.DoorSwitchPin )
  Timer.joinAll(550)
  luaunit.assertTrue( s.isDoorOpen )
end

function testDoorClosed()
  local s = newSensor()
  luaunit.assertTrue( s.isDoorOpen )
  gpio.TestData.setLow( s.DoorSwitchPin )
  Timer.joinAll(550)
  luaunit.assertFalse( s.isDoorOpen )
end

function testDoorSensorIsDisabled()
  local s = newSensor()
  luaunit.assertTrue( s.IsSensorMonitored )
  s.IsSensorMonitored = false
  Timer.joinAll(550)
  luaunit.assertFalse( s.IsSensorMonitored )
  luaunit.assertFalse( s.isDoorOpen )
end

function testDoorSensorIsEabled()
  local s = newSensor()
  luaunit.assertTrue( s.IsSensorMonitored )
  luaunit.assertTrue( s.isDoorOpen )
  s.IsSensorMonitored = false
  Timer.joinAll(550)
  luaunit.assertFalse( s.IsSensorMonitored )
  luaunit.assertFalse( s.isDoorOpen )
  s.IsSensorMonitored = true
  Timer.joinAll(550)
  luaunit.assertTrue( s.IsSensorMonitored )
  luaunit.assertTrue( s.isDoorOpen )
end

os.exit( luaunit.LuaUnit.run() )
