local isCC = (os.version ~= nil)
if not isCC then
  require("Programs.SmartTurtleAPI.smartTurtle")
else
  require("/Programs.SmartTurtleAPI.smartTurtle")
end

local function breakTree(basePoint)
  local origin = false
  if basePoint == nil then
    basePoint = smartTurtle.newPoint()
    origin = true
  end
  
  for idx, dir in pairs(breakOrder) do
    local exists, data, isLog = smartTurtle.inspectIsLogDirection(dir, true)
    if exists and isLog then
      digFunc[dir]()
      smartTurtle.move(dir)
      breakTree(basePoint)
    end
  end
  if origin then
    smartTurtle.returnPoint(basePoint)
    smartTurtle.removePoint(basePoint)
  else
    smartTurtle.stepBackToPoint(basePoint)
  end
end
breakOrder = {
  D.DOWN,
  D.UP,
}
digFunc = {
  [D.DOWN] = turtle.digDown,
  [D.FORWARD] = turtle.dig,
  [D.UP] = turtle.digUp,
}

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
    
    breakTree()
  end
end

smartTurtle.returnPoint(startPoint)