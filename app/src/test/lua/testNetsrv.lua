luaunit = require('luaunit')

require('net')
require('wifi')
require('file')
require('tmr')
require('mdns')
require('sjson')

local function newObj(moduleName)
  local s = require(moduleName)
  package.loaded[moduleName] = nil
  return s
end

local function newNetsrv()
  wifi.TestData.reset()
  net.TestData.reset()
  file.TestData.reset()
  tmr.TestData.reset()
  mdns.TestData.reset()
  sjson.TestData.reset()
  local w = newObj('wificon')
  local s = newObj('netsrv')
  return w, s
end

function testStartServerInStationMode()
  local w, s = newNetsrv()
  
  wifi.TestData.sta.onConfigureCb = function(cfg) return true end
  w.startWifi(function(ssId, ip) end, function(ssId) error('We shoud not be here.') end )
  Timer.joinAll(10)

  local listener = s.startServer()
  
  luaunit.assertNotIsNil(listener)

  TcpListener.TestData.receiveIncomingConnection(listener, 44, '33.33.33.33', 
    net.TestData.inputArrayFnc({'return 1234', 'return { a="AA" }'}, false),
    net.TestData.collectDataFnc
  )

  Timer.joinAll(100)

  luaunit.assertEquals(net.TestData.collected, { '{"result":1234,"status":true}', '{"result":{"a":"AA"},"status":true}' })
end

function testStartServerInAPMode()
  local w, s = newNetsrv()
  
  wifi.TestData.ap.onConfigureCb = function(cfg) return true end
  w.startWifi(function(ssId, ip) end, function(ssId) error('We shoud not be here.') end )
  Timer.joinAll(10)

  local listener = s.startServer()
  
  luaunit.assertNotIsNil(listener)

  TcpListener.TestData.receiveIncomingConnection(listener, 44, '33.33.33.33', 
    net.TestData.inputArrayFnc({'return 1234', 'return { a="AA" }'}, false),
    net.TestData.collectDataFnc
  )

  Timer.joinAll(10)

  luaunit.assertEquals(net.TestData.collected, { '{"result":1234,"status":true}', '{"result":{"a":"AA"},"status":true}' })
end

os.exit( luaunit.LuaUnit.run() )
