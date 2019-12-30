local isCC = (os.version ~= nil)
if not isCC then
  require("Programs.SmartTurtleAPI.smartTurtle")
else
  require("/Programs.SmartTurtleAPI.smartTurtle")
end

local function breakTree(basePoint, leafCount)
  local origin = false
  if basePoint == nil then
    basePoint = smartTurtle.newPoint()
    origin = true
    leafCount = 0
  end
  
  for idx, dir in pairs(breakOrder) do
    local exists, data, isLog = smartTurtle.inspectIsLogDirection(dir)
    exists, data, isLeaf = smartTurtle.inspectIsLeavesDirection(dir)
    if exists then 
      if isLog then
        digFunc[dir]()
        smartTurtle.move(dir)
        leafCount = 0
        breakTree(basePoint, leafCount)
      else
        if isLeaf and leafCount < 1 then
          leafCount = leafCount + 1
          digFunc[dir]()
          smartTurtle.move(dir)
          breakTree(basePoint, leafCount)
        end
      end
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
  D.FORWARD,
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
  forwardLimit = forwardLimit - 1
  exists, data, isLog = smartTurtle.inspectIsLogDirection(TD.FORWARD)
  
  if exists then
    if isLog then
      local success = turtle.dig()
      smartTurtle.move(D.FORWARD)
      forwardLimit = forwardLimit - 1
      
      breakTree()
    else
      local exists, dat, isLeaf = smartTurtle.inspectIsLeavesDirection(TD.FORWARD)
      if isLeaf then
        turtle.dig()
      end
    end
  end
end

smartTurtle.returnPoint(startPoint)