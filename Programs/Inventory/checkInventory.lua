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

local itemTable = {}

-- Empty the entire box into the chest behind
local emptySlot = nil
while emptySlot == nil do
  while turtle.suck() do end
  emptySlot = smartTurtle.findEmpty()
  smartTurtle.face(D.BACK)
  for slotIdx = 1,16 do
    turtle.select(slotIdx)
    local details =  turtle.getItemDetail()
    local fullname = details.name
    if details.damage ~= nil then
      fullname = fullname .. tostring(details.damage)
    end
    if itemTable[fullname] == nil then
      itemTable[fullname] = 0
    end
    itemTable[fullname] = itemTable[fullname] + details.count
    turtle.drop()
  end
end

print(itemTable)

smartTurtle.returnPoint(start)