luaunit = require('luaunit')

require('duration')
require('tmr')

function testDelta()
  local s = tmr.now() - 100
  luaunit.assertTrue( duration.getDelta(s) > 1 )
end

function testTmrCycleOver()
  local s = tmr.now() + 100
  luaunit.assertTrue( duration.getDelta(s) > 1 )
end

os.exit( luaunit.LuaUnit.run() )
