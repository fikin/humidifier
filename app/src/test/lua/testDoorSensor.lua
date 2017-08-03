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
  luaunit.assertTrue( s.isDoorOpen )
end

function testDoorClosed()
  local s = newSensor()
  luaunit.assertTrue( s.isDoorOpen )
  gpio.TestData.setLow( s.DoorSwitchPin )
  luaunit.assertFalse( s.isDoorOpen )
end

function testDoorSensorIsDisabled()
  local s = newSensor()
  luaunit.assertTrue( s.IsSensorMonitored )
  s.enableTheSensor(false)
  luaunit.assertFalse( s.IsSensorMonitored )
  luaunit.assertFalse( s.isDoorOpen )
end

function testDoorSensorIsEabled()
  local s = newSensor()
  luaunit.assertTrue( s.IsSensorMonitored )
  s.enableTheSensor(true)
  luaunit.assertTrue( s.IsSensorMonitored )
  luaunit.assertTrue( s.isDoorOpen )
end

os.exit( luaunit.LuaUnit.run() )
