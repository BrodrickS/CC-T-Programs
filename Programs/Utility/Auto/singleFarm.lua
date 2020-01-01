local isCC = (os.version ~= nil)
if not isCC then
  require("ComputerCraftStubs.stub_turtle")
  require("ComputerCraftStubs.stub_shell")
  require("Programs.SmartTurtleAPI.smartTurtle")
else
  require("/Programs.SmartTurtleAPI.smartTurtle")
end

-- Gather number of rows and reset time
local rows = tonumber(arg[1]) or -5
local pause = tonumber(arg[2]) or 10
local seed = arg[3] or "potato"

local rowDir = D.LEFT
if rows == 0 then
  rows = 1
elseif rows < 0 then
  rows = -rows
  rowDir = -rowDir
end

-- Check fuel level, refuel if needed
local function refuelFarmer()
  local fuelCount = turtle.getFuelLevel()
  while fuelCount < 750 do
    local slot = smartTurtle.findEmpty()
    if slot == nil then
      print("WARN: Inventory Full")
      os.sleep(15)
    else
      turtle.select(slot)
      local success = turtle.suckDown(8)
      if success then
        turtle.refuel()
      else
        print("WARN: Fuel Chest Empty")
        os.sleep(15)
      end
    end
  end
end
--

-- Farm a row of plants
local function farmRow()
  local rowStart = smartTurtle.newPoint()
  -- Evaluate if this is farmland
  local isPlant, isReady, seedName, isTilledEarth = smartTurtle.inspectIsCropDown()
  
  while isPlant or isTilledEarth do
    if isReady then
      turtle.digDown()
    end
    if isTilledEarth or isReady then
      local slot = smartTurtle.findFirst(seed, false)
      if slot then
        turtle.select(slot)
        turtle.placeDown()
      end
    end
    smartTurtle.move(D.FORWARD)
    isPlant, isReady, seedName, isTilledEarth = smartTurtle.inspectIsCropDown()
  end
  
  smartTurtle.returnPoint(rowStart)
  smartTurtle.removePoint(rowStart)
end
--

-- Deposit crops in box from start point
local function deposit()
  print("TODO: Deposit")
end
--

-- Main Method
local function main()
  local startPoint = smartTurtle.newPoint()
  
  while true do
    -- Move up and into position
    smartTurtle.move(D.UP)
    smartTurtle.move(D.FORWARD)
    
    for rowIdx = 1, rows do
      print("Farming row #" .. rowIdx .. " of " .. rows)
      farmRow()
      print("Done.")
      if rowIdx < rows then
        smartTurtle.face(rowDir)
        smartTurtle.move(D.FORWARD)
        smartTurtle.face(-rowDir)
      end
    end
  
    smartTurtle.returnPoint(startPoint)
    deposit()
    os.sleep(pause)
  end
end
--

main()

