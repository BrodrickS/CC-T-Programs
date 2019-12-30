local isCC = (os.version ~= nil)
if not isCC then
  --require("ComputerCraftStubs.stub_turtle")
  require("Programs.SmartTurtleAPI.smartTurtle")
else
  require("/Programs.SmartTurtleAPI.smartTurtle")
end

-- Limits
local forwardLimit = 4

-- Remember height
local startPoint = smartTurtle.newPoint()

-- Check the block ahead
local exists, data, isLog = smartTurtle.inspectIsLogDirection(TD.FORWARD)
while not isLog and not exists and forward <= forwardLimit do
  smartTurtle.move(D.FORWARD)
  exists, data, isLog = smartTurtle.inspectIsLogDirection(TD.FORWARD)
end

if isLog then
  local success = turtle.dig()
  smartTurtle.move(D.FORWARD)
  exists, data, isLog = smartTurtle.inspectIsLogDirection(TD.UP, true)
  while exists and isLog do
    turtle.digUp()
    smartTurtle.move(D.UP)
    exists, data, isLog = smartTurtle.inspectIsLogDirection(TD.UP, true)
  end
end

smartTurtle.returnPoint(startPoint)