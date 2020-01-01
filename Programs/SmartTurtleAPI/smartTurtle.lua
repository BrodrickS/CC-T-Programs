local isCC = (os.version ~= nil)
if not isCC then
  require("ComputerCraftStubs.stub_turtle")
  require("ComputerCraftStubs.stub_shell")
end

local st = {}

-- #### STATIC FIELDS AND PROPERTIES ####

D = {
  UP = 1,
  FORWARD = 2,
  LEFT = 3,
  DOWN = -1,
  BACK = -2,
  RIGHT = -3,
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
    local success = func()
    if success and remember then
      st.rememberMove(dir)
    end
    return success
  end
end
st._moveFunc = {
  [D.UP] = turtle.up,
  [D.FORWARD] = turtle.forward,
  [D.DOWN] = turtle.down,
  [D.LEFT] = turtle.turnLeft,
  [D.BACK] = turtle.back,
  [D.RIGHT] = turtle.turnRight,
}
--

function st.face(dir, remember)
  if remember == nil then
    remember = true
  end
  
  local dirs = st._faceDirs[dir]
  if dirs then
    for idx, val in pairs(dirs) do
      st.move(val, remember)
    end
  end
end
st._faceDirs = {
  [D.LEFT] = {D.LEFT},
  [D.RIGHT] = {D.RIGHT},
  [D.BACK] = {D.LEFT, D.LEFT},
}
--

-- Logs moves
-- Called inside st.move(), so we can call st.returnPoint() later
function st.rememberMove(dir)
  for idx = 1, st.memPointsCount do
    local point = st.memPoints[idx]
    if point ~= nil then
      local lastMove = point[#point]
      local last2Move = point[#point - 1]
      if (lastMove == D.LEFT or lastMove == D.RIGHT) and lastMove == dir and lastMove == last2Move then
        table.remove(point)
        table.remove(point)
        table.insert(point, -dir)
      elseif lastMove == -dir then
        table.remove(point)
      else
        table.insert(point, dir)
      end
    end
  end
end 
--

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
--

-- Return to Memory Point
function st.returnPoint(pointIndex, failFunction)
  -- Set fail function to a sleep function if it's not defined by the call
  
  failFunction = failFunction or moveFail
  
  local point = st.memPoints[pointIndex]
  if point ~= nil then
    -- reverse table
    invList = {}
    for idx, value in pairs(point) do
      table.insert(invList, 1, value)
    end
    for idx, value in pairs(invList) do
        
        local attempts = 0
        while not st.move(-value) and attempts < 3 do
          attempts = attempts + 1
          print("move failed, attempting fix #" .. tostring(attempts) .. "...")
          failFunction()
        end
    
      if not success and failFunction then
      end
    end
  end
end
local function moveFail()
  print("sleeping 1...")
  os.sleep(1)
end
--

function st.stepBackToPoint(pointIndex)
  local point = st.memPoints[pointIndex]
  if point ~= nil then
    local lastMove = point[#point]
    st.move(-lastMove)
  end
end
--

-- ## INSPECTION ##

-- Directional inspection
function st.inspectDirection(dir)
  local func = st._inspectDirection[dir]
  if (func) then
    local point = st.newPoint()
    st.face(dir)
    local exists, data = func()
    st.returnPoint(point)
    st.removePoint(point)
    return exists, data
  end
end
st._inspectDirection = {
  [D.UP] = turtle.inspectUp,
  [D.FORWARD] = turtle.inspect,
  [D.LEFT] = turtle.inspect,
  [D.RIGHT] = turtle.inspect,
  [D.BACK] = turtle.inspect,
  [D.DOWN] = turtle.inspectDown,
}
--

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
--

-- Directionally checks if this block ahead is leaves
function st.inspectIsLeavesDirection(dir)
  local exists, data = st.inspectDirection(dir)
  if not exists then
    return exists, data, false
  end
  
  local isLeaves = string.find(data.name, "leaves") ~= nil
  return exists, data, isLeaves
end
--

-- Checks if the block under is a crop, and if so, if it's ready to harvest
function st.inspectIsCropDown()
  local isPlant = false
  local isReady = false
  local seedName = nil
  local isTilledEarth = false
  
  local exists, data = st.inspectDirection(D.DOWN)
  if exists then
    local name = data.name:sub((data.name:find(":") or 0)+1)
    if st._crops[name] ~= nil then
      isPlant = true
      if data.state.age == st._crops[name].age then
        isReady = true
      end
      seedName = st._crops[name].seed
    end
  else
    if st.move(D.DOWN) and st.move(D.UP) and turtle.digDown() then
      isTilledEarth = true
    end
  end
  return isPlant, isReady, seedName, isTilledEarth
end
st._crops = {
  ["potatoes"] = {
    age = 7,
    seed = "potato",
  },
}
--

-- ## INVENTORY ##

-- Grabs the first empty slot in the inventory
function st.findEmpty()
  for slot = 1, 16 do
    if turtle.getItemCount(slot) == 0 then
      return slot
    end
  end
  return nil
end
--

-- Grabs the first item with the name quoted. Can be exact
function st.findFirst(name, exact)
  exact = exact or false
  for slot = 1, 16 do
    local data = turtle.getItemDetail(slot)
    if data ~= nil then
        local blockName = data.name:sub((data.name:find(":") or 0)+1)
        if exact then
          if blockName == name then
            return slot
          end
        else
          if blockName:find(name) ~= nil then
            return slot
          end
        end
    end
  end
end
--

smartTurtle = st
