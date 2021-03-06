local isCC = (os.version ~= nil)
if not isCC then
  require("ComputerCraftStubs.stub_turtle")
  require("ComputerCraftStubs.stub_shell")
  require("Programs.SmartTurtleAPI.smartTurtle")
else
  require("/Programs.SmartTurtleAPI.smartTurtle")
end


-- Checks that the input chest coordinates are valid
function validateTarget(wall, chest)
  if wall ~= "a" and wall ~= "b" then
    print("WH_WARN: No Wall Labeled '" .. wall .. "'")
    return false
  end
  
  if chest > 45 then 
    print("WH_WARN: No Chests Greater than 45!")
    return false
  end
  
  return true
end
--

-- Navigates the turtle from the start position to facing the target chest
function moveToChest(wall, chest)
  smartTurtle.move(D.FORWARD)
  
  local flip = false
  if wall == "b" then
    flip = true
    chest = 46 - chest
  end
  
  -- Find shelf number and box position
  local shelf = math.floor((chest-1)/15) + 1
  local pos = 1 + ((chest-1))%15
  local row = 1 + math.floor((pos-1)/5)
  local col = 1 + ((pos-1)%5)
  
  if flip then 
      row = 4 - row
  end
  
  -- Turn shelf num and position into horiz, vert, and dir
  local HORIZ_OFFSET = -6
  local SHELF_HORIZ_SPACING = 6
  local VERT_OFFSET = -2
  
  local horiz = col + ((shelf - 1) * SHELF_HORIZ_SPACING) + HORIZ_OFFSET
  local vert = (4-row) + VERT_OFFSET 
  
  local horizDir = D.LEFT
  if horiz < 0 then
    horiz = -horiz
    horizDir = -horizDir
  end
  local vertDir = D.UP
  if vert < 0 then
    vert = -vert
    vertDir = -vertDir
  end
  
  smartTurtle.face(horizDir)
  for int = 1,horiz do
    smartTurtle.move(D.FORWARD)
  end
  if not flip then 
    smartTurtle.face(horizDir)
  else
    smartTurtle.face(-horizDir)
    smartTurtle.move(D.FORWARD)
  end
  for int = 1,vert do
    smartTurtle.move(vertDir)
  end

end
--

-- Moves the contents of the chest ahead to the empty ender chest contained
function transferToEnder()
  
  -- Get and place enderchest
  local slot = smartTurtle.findFirst("ender_storage")
  if slot == nil then
    print("WH_WARN: No Ender Chest Found!")
    return false
  end
  turtle.select(slot)
  
  smartTurtle.face(D.BACK)
  smartTurtle.place(D.FORWARD)
  smartTurtle.face(D.BACK)
  
  local emptySlot = nil
  while emptySlot == nil do
    while turtle.suck() do end
    emptySlot = smartTurtle.findEmpty()
    smartTurtle.face(D.BACK)
    for slotIdx = 1,16 do
      if turtle.getItemCount(slotIdx) > 0 then
        turtle.select(slotIdx)
        turtle.drop()
      end
    end
    
    if emptySlot ~= nil then
      smartTurtle.dig(D.FORWARD)  
    end
    smartTurtle.face(D.BACK)
  end
  
  smartTurtle.dig(D.FORWARD)
  
end
--

-- Moves the contents of the full ender chest to the empty lockbox
function transferFromEnder()
  
  -- Get and place chest or lockChest
  local slot = smartTurtle.findFirst("chest")
  if isCC and slot == nil then
    print("WH_WARN: No Chest Found!")
    return false
  end
  turtle.select(slot)
  smartTurtle.place(D.FORWARD)
  
    -- Get and place enderchest
  local slot = smartTurtle.findFirst("ender_storage")
  if isCC and slot == nil then
    print("WH_WARN: No Ender Chest Found!")
    return false
  end
  turtle.select(slot)
  
  smartTurtle.face(D.BACK)
  smartTurtle.place(D.FORWARD)
  
  local emptySlot = nil
  while emptySlot == nil do
    while turtle.suck() do end
    emptySlot = smartTurtle.findEmpty()
    smartTurtle.face(D.BACK)
    for slotIdx = 1,16 do
      if turtle.getItemCount(slotIdx) > 0 then
        turtle.select(slotIdx)
        turtle.drop()
      end
    end
    
    smartTurtle.face(D.BACK)
  end
  
  smartTurtle.dig(D.FORWARD)
  
end
--

-- Entry point of program
function main()
  local filename = "warehouse.lock"
  
  local wall = arg[1]
  local chest = tonumber(arg[2])
  local isValid = validateTarget(wall, chest)
  if not isValid then
    return
  end
  
  if isCC then smartTurtle.refuel(2000, 16, D.DOWN) end
  local startPoint = smartTurtle.newPoint()
  
  -- Get current lockbox
  local file = io.open(filename, "r")
  if file ~= nil then
    local oldWall = file:read()
    local oldChest = tonumber(file:read())
    local oldIsValid = validateTarget(oldWall, oldChest)
    if not oldIsValid then
      return
    elseif wall == oldWall and chest == oldChest then
      print("WH_INFO: The selected chest is already in use")
      return
    end
    moveToChest(oldWall, oldChest)
    transferFromEnder()
    smartTurtle.returnPoint(startPoint)
  end
  
  moveToChest(wall, chest)
  transferToEnder()
  file = io.open(filename, "w+")
  file:write(wall .. "\n" .. tostring(chest))
  file:close()
  
  print("-- DONE --")
  
  smartTurtle.returnPoint(startPoint)
  
end
main()

