local data = {
  msg = '',
  msgWifi = '',
  ServerPort = 8765
}

local srv = nil

local function sendData(conn, execStatus, val)
  --print('sendData: conn='..tostring(conn)..' status='..tostring(execStatus)..' value='..tostring(val))
  if not val then val = '' end
  local data = { status = execStatus, result = val }
  local encoder = sjson.encoder(data)
  local function sendJsonStr(conn1)
    local str = encoder:read(1024)
    if str then
      conn1:send(str)
    else
      conn1:close()
    end
  end
  conn:on('sent', sendJsonStr)
  sendJsonStr(conn)
end

-- START

-- following 2 functions are meant to handle requests in JSON format
-- where data is '{ "cmd": "return 1" }"

--local function handleRequest(conn, req)
--  if req.cmd then
--    print('netsrv: handling request '..req.cmd)
--    local execStatus, val = pcall(loadstring(req.cmd))
--    sendData( conn, execStatus, val )
--  else
--    sendData(conn, false, 'request has not "cmd" attribute to interpret.')
--  end
--end

--local function acceptNewConnection(conn)
--  print('netsrv: new connection')
--  local decoder = sjson.decoder()
--  conn:on('receive', function(conn1,data)
--    --print('netsrv: receive : '..data)
--    decoder:write(data);
--    local execStatus, req = pcall(function() return decoder:result(); end)
--    --print('netsrv: decode res : '..tostring(execStatus)..' : '..tostring(req))
--    if execStatus then
--      decoder = nil
--      handleRequest(conn1,req)
--    end;
--  end)
--  conn:on('disconnection', function(conn1,err) decoder = nil; end) 
--end

-- These 2 functions handle lua comands as directly sent input on socket.

local function acceptNewConnection(conn)
  print('netsrv: new connection')
  conn:on('receive', function(conn1,data)
    --print('netsrv: receive : '..data)
    print('netsrv: handling request '..data)
    local execStatus, val = pcall(loadstring(data))
    sendData( conn1, execStatus, val )
  end)
end

-- END

data.startServer = function()
  local ip, nm, gw = wifi.getmode() == wifi.SOFTAP and wifi.ap.getip() or wifi.sta.getip()
  data.msg = ip..':'..data.ServerPort
  srv = net.createServer(net.TCP)
  srv:listen(data.ServerPort, acceptNewConnection)
  -- set mdns if in STA mode
  if wifi.getmode() == wifi.STATION or wifi.getmode() == wifi.STATIONAP then 
    mdns.register(wifi.sta.gethostname(), { port=data.ServerPort, service='tcp', descrption='Humidifer API'})
    data.msgWifi = 'Wifi: '..wifi.sta.getconfig(true).ssid
  else
    data.msgWifi = 'Wifi: '..wifi.ap.getconfig(true).ssid
  end
  print(data.msg)
  data.startServer = nil -- cleanup memory
  return srv
end

-- Not really needed because we always start server on boot-up
--data.stopServer = function()
--  if srv then
--    srv:close()
--    srv = nil
--    data.msg = 'Server : stopped.'
--  end
--  print(data.msg)
--end

return data