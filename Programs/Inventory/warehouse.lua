local isCC = (os.version ~= nil)
if not isCC then
  require("ComputerCraftStubs.stub_turtle")
  require("ComputerCraftStubs.stub_shell")
  require("Programs.SmartTurtleAPI.smartTurtle")
else
  require("/Programs.SmartTurtleAPI.smartTurtle")
end

function moveToChest(wall, chest)
  if wall ~= "a" and wall ~= "b" then
    print("CHEST_WARN: No Wall Labeled '" .. wall .. "'")
    return
  end
  
  if chest > 45 then 
    print("CHEST_WARN: No Chests Greater than 45!")
    return 
  end
  
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
  smartTurtle.face(horizDir)
  for int = 1,vert do
    smartTurtle.move(vertDir)
  end

end

-- Entry point of program
function main()
  
  if isCC then smartTurtle.refuel(2000, 16, D.DOWN) end
  local startPoint = smartTurtle.newPoint()
  moveToChest("a",15)
  
  print("-- DONE --")
  smartTurtle.returnPoint(startPoint)
  
end
main()

