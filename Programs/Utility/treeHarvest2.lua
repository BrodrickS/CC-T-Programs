local isCC = (os.version ~= nil)
if not isCC then
  --require("ComputerCraftStubs.stub_turtle")
  require("Programs.SmartTurtleAPI.smartTurtle")
else
  require("/Programs.SmartTurtleAPI.smartTurtle")
end

-- Limits
local forwardLimit = 40

-- Remember start point
local startPoint = smartTurtle.newPoint()

-- Check the block ahead
local exists, data, isLog = smartTurtle.inspectIsLogDirection(TD.FORWARD)
while forwardLimit > 0 do
  smartTurtle.move(D.FORWARD)
  exists, data, isLog = smartTurtle.inspectIsLogDirection(TD.FORWARD)
  forwardLimit = forwardLimit - 1

  if isLog then
    local success = turtle.dig()
    smartTurtle.move(D.FORWARD)
    local basePoint = smartTurtle.newPoint()
    
    exists, data, isLog = smartTurtle.inspectIsLogDirection(TD.UP, true)
    while exists and isLog do
      turtle.digUp()
      smartTurtle.move(D.UP)
      exists, data, isLog = smartTurtle.inspectIsLogDirection(TD.UP, true)
    end
    
    smartTurtle.returnPoint(basePoint)
    smartTurtle.removePoint(basePoint)
  end
end

smartTurtle.returnPoint(startPoint)