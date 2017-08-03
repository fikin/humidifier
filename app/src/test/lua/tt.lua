local function getCurrentTimeMs()
   local a, ms = math.modf(os.clock())
   if ms > 0 then 
      ms = tonumber(tostring(ms):sub(3,5)) 
   end
   local t = ((os.time() * 1000) + ms) * 1000 -- in microsec
   return t % 2147483647 -- mimic 31bit cycle over
end

while true do
  local oldT = 0
  local t = getCurrentTimeMs()
  if t < oldT then
    print( t ..' '..oldT )
    break
  end
  oldT = t
end