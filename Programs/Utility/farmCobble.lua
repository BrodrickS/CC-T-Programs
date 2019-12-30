local isCC = (os.version ~= nil)
if not isCC then
  require("Programs.SmartTurtleAPI.smartTurtle")
else
  require("/Programs.SmartTurtleAPI.smartTurtle")
end

local failures = 0
while true do
  success = turtle.dig()
  if not success then
    failures = failures + 1
  else
    failures = 0
  end
  if failures > 15 then
    turtle.forward()
    os.sleep(5)
    turtle.back()
    os.sleep(5)
    failures = 0
  end
end