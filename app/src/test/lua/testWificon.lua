luaunit = require('luaunit')

require('wifi')
require('file')
require('tmr')

local function newObj()
  wifi.TestData.reset()
  file.TestData.reset()
  tmr.TestData.reset()
  local moduleName = 'wificon'
  local s = require(moduleName)
  package.loaded[moduleName] = nil
  return s
end

function testWifiCredsOk()
  local s = newObj()
  
  wifi.TestData.sta.onConfigureCb = function(cfg) return true end
  
  local gotConnected = false
  s.startWifi(
    function(ssId, ip) 
      gotConnected = true
      luaunit.assertEquals(ssId, 'XYZ') -- from wifi-credentials.txt
      luaunit.assertEquals(wifi.sta.gethostname(), s.StaHostname)
      luaunit.assertNotIsNil(ip)
      local i, nm, gw = wifi.sta.getip()
      luaunit.assertNotIsNil(i)
      luaunit.assertNotIsNil(nm)
      luaunit.assertNotIsNil(gw)
    end,
    function(ssId) error('We shoud not be here.') end
  )
  Timer.joinAll(100)
  luaunit.assertTrue(gotConnected)
end

local function doTestBrokenWifiCreds(fileName)
  local s = newObj()
  
  wifi.TestData.sta.onConfigureCb = function(cfg) return true end
  wifi.TestData.ap.onConfigureCb = function(cfg) return true end
  s.WifiCredsFile = fileName
  
  local gotConnected = false
  s.startWifi(
    function(ssId, ip) 
      gotConnected = true
      luaunit.assertEquals(ssId, s.APSsId)
      luaunit.assertNotIsNil(ip)
      local i, nm, gw = wifi.ap.getip()
      luaunit.assertEquals(i, s.APIp)
      luaunit.assertEquals(nm, s.APMask)
      luaunit.assertEquals(gw, s.APGw)
    end,
    function(ssId) 
      error('We shoud not be here.') 
    end
  )
  Timer.joinAll(100)
  luaunit.assertTrue(gotConnected)
  
  luaunit.assertEquals(wifi.getmode(), wifi.SOFTAP)
end

function testNoWifiCreds()
  doTestBrokenWifiCreds('not-existing-file')
end
function testBrokenWifiCreds()
  doTestBrokenWifiCreds('err-wifi-creds.txt')
end
function testMissingSsidWifiCreds()
  doTestBrokenWifiCreds('err-wifi-creds2.txt')
end
function testMissingPwdWifiCreds()
  doTestBrokenWifiCreds('err-wifi-creds3.txt')
end

function testAPStartFails()
  local s = newObj()
  
  local gotFailed = false
  s.startWifi(
    function(ssId, ip) 
      error('We shoud not be here.') 
    end,
    function(ssId) 
      gotFailed = true
    end
  )
  luaunit.assertTrue(gotFailed)
end

os.exit( luaunit.LuaUnit.run() )
