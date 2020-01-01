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
    local slot = smartTurtle.selectEmpty()
    if slot == nil then
      print("WARN: Inventory Full")
      os.sleep(15)
    else
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

-- Main Method
local function main()
  local startPoint = smartTurtle.newPoint()
  
  while true do
    -- Move up and into position
    smartTurtle.move(D.UP)
    smartTurtle.move(D.FORWARD)
    
    -- Evaluate if this is farmland
    local isPlant, isReady = smartTurtle.inspectIsCropDown()
  
    smartTurtle.returnPoint(startPoint)
    os.sleep(pause)
  end
end
--

main()

