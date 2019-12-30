local isCC = (os.version ~= nil)
if not isCC then
  require("ComputerCraftStubs.stub_turtle")
end

local st = {}

-- #### STATIC FIELDS AND PROPERTIES ####

TD = {
  UP = 0,
  FORWARD = 1,
  DOWN = 2,
}

D = {
  UP = 1,
  FORWARD = 2,
  DOWN = -1,
  BACK = -2,
  LEFT_T = 3,
  RIGHT_T = -3,
}

-- #### FIELDS AND PROPERTIES ####

-- #### METHODS ####

-- ## MOVEMENT ##
-- Moves Directionally
function st.move(dir, remember)
  if remember == nil then
    remember = true
  end
  
  local func = st._moveFunc[dir]
  if func then
    if remember then
      st.rememberMove(dir)
    end
    return func()
  end
end
st._moveFunc = {
  [D.UP] = turtle.up,
  [D.FORWARD] = turtle.forward,
  [D.DOWN] = turtle.down,
  [D.BACK] = turtle.back,
  [D.RIGHT_T] = turtle.turnRight,
  [D.LEFT_T] = turtle.turnLeft,
}

-- Logs moves
-- Called inside st.move(), so we can call st.returnPoint() later
function st.rememberMove(dir)
  for idx = 1, st.memPointsCount do
    local point = st.memPoints[idx]
    if point ~= nil then
      local lastMove = point[#point]
      if lastMove == -dir then
        table.remove(point)
      else
        table.insert(point, dir)
      end
    end
  end
end 

-- Create New Memory Point
function st.newPoint()
  local memPoint = {}
  st.memPointsCount = st.memPointsCount + 1
  st.memPoints[st.memPointsCount] = memPoint
  return st.memPointsCount
end
st.memPoints = {}
st.memPointsCount = 0

-- Renove a Memory Point
function st.removePoint(pointIndex)
  st.memPoints[pointIndex] = nil
end

-- Return to Memory Point
function st.returnPoint(pointIndex)
  local point = st.memPoints[pointIndex]
  if point ~= nil then
    -- reverse table
    invList = {}
    for idx, value in pairs(point) do
      table.insert(invList, 1, value)
    end
    for idx, value in pairs(invList) do
      st.move(-value)
    end
  end
end

---- Moves aggressively
--function st.agressiveForward()
--  while not turtle.forward() do
--    turtle.attack()
--  end
--end

-- ## INSPECTION ##

-- Directional inspection
function st.inspectDirection(dir)
  local func = st._inspectDirection[dir]
  if (func) then
    return func()
  end
end
st._inspectDirection = {
  [TD.UP] = turtle.inspectUp,
  [TD.FORWARD] = turtle.inspect,
  [TD.DOWN] = turtle.inspectDown,
}

-- Directionally checks if this block ahead is a log
function st.inspectIsLogDirection(dir, includeLeaves)
  if includeLeaves == nil then
    local includeLeaves = false
  end
  local exists, data = st.inspectDirection(dir)
  if not exists then
    return exists, data, false
  end
  
  local isLog = string.find(data.name, "log") ~= nil
  if includeLeaves then
    isLog = isLog or string.find(data.name, "leaves")
  end

  return exists, data, isLog
end

function st.inspectIsLeavesDirection(dir)
  local exists, data = st.inspectDirection(dir)
  if not exists then
    return exists, data, false
  end
  
  local isLeaves = string.find(data.name, "leaves") ~= nil
  return exists, data, isLeaves
end

smartTurtle = st
