local isCC = (os.version ~= nil)
if not isCC then
  --require("ComputerCraftStubs.stub_turtle")
  require("Programs.SmartTurtleAPI.smartTurtle")
else
  require("/Programs.SmartTurtleAPI.smartTurtle")
end

-- Remember height
local height = 0

-- Check the block ahead
local exists, data, isLog = smartTurtle.inspectIsLogDirection(TD.FORWARD)
if isLog then
  local success = turtle.dig()
  turtle.forward()
  exists, data, isLog = smartTurtle.inspectIsLogDirection(TD.UP, true)
  while exists and isLog do
    turtle.digUp()
    turtle.up()
    exists, data, isLog = smartTurtle.inspectIsLogDirection(TD.UP, true)
    height = height + 1
  end
  while height > 0 do
    turtle.down()
    height = height - 1
  end
end
