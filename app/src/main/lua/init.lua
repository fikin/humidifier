local delay = 15
local cnt = 0
local function startDelay()
  local cnt = 0
  tmr.alarm( 1, 1000, tmr.ALARM_AUTO, function(timerObj)
--  tmr.create():alarm( 1000, tmr.ALARM_SINGLE, function()
    if cnt >= delay then
      tmr.unregister(timerObj)
      require('main')(nil)
      package.loaded["main"] = nil
    else
      print('Starting in '..(delay-cnt)..'sec, to interrupt issue command : tmr.unregister(1)')
      cnt = cnt + 1
    end
  end)
end
startDelay()