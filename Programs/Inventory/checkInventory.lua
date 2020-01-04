local isCC = (os.version ~= nil)
if not isCC then
  require("ComputerCraftStubs.stub_turtle")
  require("ComputerCraftStubs.stub_shell")
  require("Programs.SmartTurtleAPI.smartTurtle")
else
  require("/Programs.SmartTurtleAPI.smartTurtle")
end

local start = smartTurtle.newPoint()

-- check that we have chests ready
local slot = smartTurtle.findFirst("chest", true)
while slot == nil do
  print("Need 2 chests!")
  os.sleep(5)
  slot = smartTurtle.findFirst("chest", true)
end
turtle.select(slot)

smartTurtle.face(D.BACK)
smartTurtle.move(D.FORWARD)
turtle.place()
smartTurtle.move(D.BACK)
turtle.place()

smartTurtle.face(D.BACK)

-- Empty the entire box into the chest behind
local emptySlot = nil
while emptySlot == nil do
  while turtle.suck() do end
  emptySlot = smartTurtle.findEmpty()
  smartTurtle.face(D.BACK)
  while turtle.drop() do end
end



smartTurtle.returnPoint(start)