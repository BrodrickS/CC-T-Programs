local isCC = (os.version ~= nil)
if not isCC then
  require("Programs.SmartTurtleAPI.smartTurtle")
else
  require("/Programs.SmartTurtleAPI.smartTurtle")
end

-- Inputs and variables
local verticalLength = tonumber(arg[1]) or 4
local horizontalRows = tonumber(arg[2]) or 1
local horizontalPadding = tonumber(arg[3]) or 2
local horizontalDirection = D.LEFT

if horizontalRows < 0 then
  horizontalRows = -horizontalRows
  horizontalDirection = -horizontalDirection
end

local function breakTree(basePoint, leafCount)
  local origin = false
  if basePoint == nil then
    basePoint = smartTurtle.newPoint()
    origin = true
    leafCount = 0
  end
  
  local lastDir = nil
  local savePoint = nil
  for idx, dir in pairs(breakOrder) do
    if dir == lastDir then
      if savePoint == nil then
        savePoint = smartTurtle.newPoint()
      end
      smartTurtle.face(D.LEFT)
    elseif savePoint ~= nil then
      smartTurtle.returnPoint(savePoint)
      smartTurtle.removePoint(savePoint)
    end
    local exists, data, isLog = smartTurtle.inspectIsLogDirection(dir)
    exists, data, isLeaf = smartTurtle.inspectIsLeavesDirection(dir)
    if exists then 
      if isLog then
        digFunc[dir]()
        smartTurtle.move(dir)
        leafCount = 0
        breakTree(basePoint, leafCount)
      else
        if isLeaf and leafCount < 1 and data.state.variant == "oak" then
          leafCount = leafCount + 1
          digFunc[dir]()
          smartTurtle.move(dir)
          breakTree(basePoint, leafCount)
          leafCount = leafCount - 1
        end
      end
    end
    lastDir = dir
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
--

local function turnAndBreak()
  print("turning and breaking...")
  local turnPoint = smartTurtle.newPoint()
  smartTurtle.face(D.BACK)
  breakTree()
  smartTurtle.returnPoint(turnPoint)
  smartTurtle.removePoint(turnPoint)
end
--

local function breakRow()
  local rowStartPoint = smartTurtle.newPoint()
  local forward = 0
  
  -- Check the block ahead
  local exists, data, isLog = smartTurtle.inspectIsLogDirection(D.FORWARD)
  while forward < verticalLength do
    smartTurtle.move(D.FORWARD)
    forward = forward + 1
    exists, data, isLog = smartTurtle.inspectIsLogDirection(D.FORWARD)
    
    if exists then
      if isLog then
        local success = turtle.dig()
        smartTurtle.move(D.FORWARD)
        forward = forward + 1
        
        breakTree()
      else
        local exists, dat, isLeaf = smartTurtle.inspectIsLeavesDirection(D.FORWARD)
        if isLeaf then
          turtle.dig()
        end
      end
    end
  end
  
  smartTurtle.returnPoint(rowStartPoint, turnAndBreak)
  smartTurtle.removePoint(rowStartPoint)
end
--

-- Remember start point
local startPoint = smartTurtle.newPoint()
-- For each row do
for rowIndex = 1, horizontalRows do
  
  breakRow()
  
  if rowIndex < horizontalRows then
    smartTurtle.face(horizontalDirection)
    for itr = 0, horizontalPadding do
      smartTurtle.move(D.FORWARD)
    end
    smartTurtle.face(-horizontalDirection)
  end
  
end
smartTurtle.returnPoint(startPoint)