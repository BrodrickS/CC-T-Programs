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
  
-- #### APPLY METHODS ####

reqs = {
  "Programs.SmartTurtleAPI.stMovement",
  "Programs.SmartTurtleAPI.stInventory",
  "Programs.SmartTurtleAPI.stActions",
}
if isCC then
  for k, v in pairs(reqs) do
    reqs[k] = "/" .. reqs[k]
  end
end
for k, value in pairs(reqs) do
  local adder = require(value)
  adder(st)
end
--

-- ## INSPECTION ##

-- Directionally checks if this block ahead is a log
function st.inspectIsLogDirection(dir, includeLeaves)
  if includeLeaves == nil then
    local includeLeaves = false
  end
  local exists, data = st.inspect(dir)
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
  local exists, data = st.inspect(dir)
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
  
  local exists, data = st.inspect(D.DOWN)
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

-- ## MISC ##

-- Check fuel level, refuel if needed
function st.refuel(_minLevel, _suckAmt, _dir)
  local minLevel = _minLevel or 2000
  local suckAmt = _suckAmt or 16
  local dir = _dir or D.DOWN
  
  local fuelCount = turtle.getFuelLevel()
  while fuelCount < minLevel do
    print("REFUEL: " .. tostring(fuelCount) .. " remaining")
    local slot = smartTurtle.findEmpty()
    if slot == nil then
      print("REFUEL_WARN: Inventory Full")
    else
      turtle.select(slot)
      local success = smartTurtle.suck(dir)
      if success then
        turtle.refuel()
      else
        print("REFUEL_WARN: Fuel Chest Empty")
        os.sleep(15)
      end
    end
  end
end
--

smartTurtle = st
