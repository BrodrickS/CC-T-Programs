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

-- #### FIELDS AND PROPERTIES ####

-- #### METHODS ####

-- ## MOVEMENT ##

-- Moves aggressively
function st.agressiveForward()
  while not turtle.forward() do
    turtle.attack()
  end
end

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
  
  local isLog = string.find(data.name, "log")
  if includeLeaves then
    isLog = isLog or string.find(data.name, "leaves")
  end

  return exists, data, isLog
end

smartTurtle = st
