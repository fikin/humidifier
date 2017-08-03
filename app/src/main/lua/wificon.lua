local data = {
  StaHostname = 'humidifier',
  STASsId = nil,
  STASsKey = nil,
  STATimeoutFailureMs = 60000, -- 1min
  APSsId = 'Humidifier',
  APSsKey = nil,
  APIp = '192.168.255.1',
  APMask = '255.255.255.0',
  APGw = '192.168.255.255',
  WifiCredsFile = "wifi-credentials.txt"
}

local function unregisterStaCallbacks()
  wifi.eventmon.register(wifi.eventmon.STA_DISCONNECTED, nil)
  wifi.eventmon.register(wifi.eventmon.STA_DHCP_TIMEOUT, nil)
  wifi.eventmon.register(wifi.eventmon.STA_GOT_IP,       nil)
end

local function init()
  print('wificon: init.')
  wifi.setmode(wifi.NULLMODE, true)
  unregisterStaCallbacks()
end

local function startAP(onReadyCb, onErrCb)
  print('wificon: starting up '..data.APSsId)
  wifi.setmode(wifi.SOFTAP, false)
  wifi.ap.setip( { ip=data.APIp, netmask=data.APMask, gateway=data.APGw } )
  local cfg = { ssid = data.APSsId, pwd = data.APSsKey, auth = wifi.OPEN, hidden = false, save = false }
  if wifi.ap.config(cfg) then
    local ip, nm, gw = wifi.ap.getip()
    onReadyCb(data.APSsId, { IP=ip, netmask=nm, gateway=gw  })
  else
    wifi.setmode(wifi.NULLMODE, true)
    onErrCb(data.APSsId)
  end
end


local function startSTA(onReadyCb, onErrCb)
  print('wificon: starting up '..data.STASsId)
  wifi.setmode(wifi.STATION, false)
  wifi.sta.sethostname(data.StaHostname)
  wifi.sta.autoconnect(1)
  local startTime = tmr.now()
  local function onStaFailure()
    local delta = require('duration').getDelta(startTime)
    if delta > data.STATimeoutFailureMs then
      unregisterStaCallbacks()
      print('wificon: connecting to '..data.STASsId..' failed, starting AP mode.')
      startAP(onReadyCb,onErrCb)
    end
  end
  local function onStaOk(T)
    print('wificon: got ip '..T.IP) 
    unregisterStaCallbacks()
    onReadyCb(data.STASsId, T.IP)
  end
  wifi.eventmon.register(wifi.eventmon.STA_DISCONNECTED, onStaFailure)
  wifi.eventmon.register(wifi.eventmon.STA_DHCP_TIMEOUT, onStaFailure)
  wifi.eventmon.register(wifi.eventmon.STA_GOT_IP, onStaOk)
  local cfg = { ssid = data.STASsId, pwd = data.STASsKey, auto = true, save = false }
  if wifi.sta.config( cfg ) then
    -- ok case, do nothing
  else
    -- sta fails, go to AP mode
    startAP(onReadyCb, onErrCb)
  end
end

local function findFile(loc)
  if file.exists(loc) then return loc
  else 
    local modulepath = loc
    for path in string.gmatch(package.path,'([^;]+)') do
      local filename = string.gsub(path, "%?.lua?", modulepath)
      if file.exists(filename) then return filename end
    end
    return nil
  end
end

local function loadSTACredentials()
  local fileLoc = findFile(data.WifiCredsFile)
  if fileLoc then
    local f, err = loadfile(fileLoc)
    if err then
      print('wificon: failed reading '..data.WifiCredsFile..' : '..err)
      return false
    else
      print('wificon: '..data.WifiCredsFile..' found, reading it ...')
      local dt = f()
      if dt.ssid then
        data.STASsId = dt.ssid
      else
        print('wificon: didnot find "ssid" field after reading '..data.WifiCredsFile..' .')
        return false
      end
      if dt.pwd then
        data.STASsKey = dt.pwd
      else
        print('wificon: didnot find "pwd" field after reading '..data.WifiCredsFile..' .')
        return false
      end
      return true
    end
  else
    print('wificon: no '..data.WifiCredsFile..' found.')
    return false
  end
end

data.startWifi = function(onReadyCb, onErrCb)
  init()
  if loadSTACredentials() then
    startSTA(onReadyCb, onErrCb)
  else
    startAP(onReadyCb, onErrCb)
  end
end

return data