local isCC = (os.version ~= nil)
if not isCC then
  require("Programs.SmartTurtleAPI.smartTurtle")
  require("ComputerCraftStubs.stub_turtle")
else
  require("/Programs.SmartTurtleAPI.smartTurtle")
end

local forwardMax = tonumber(arg[1])
if forwardMax == nil then
  forwardMax = 1
end
local vertMax = tonumber(arg[2])
if vertMax == nil or vertMax == 0 then
  vertMax = 1
end
local horizMax = tonumber(arg[3])
if horizMax == nil or horizMax == 0 then
  horizMax = 1
end

local vertDir = nil
if vertMax > 0 then
  vertDir = D.UP
else
  vertMax = -vertMax
  vertDir = D.DOWN
end

local horizDir = nil
if horizMax > 0 then
  horizDir = D.LEFT
else
  horizMax = -horizMax
  horizDir = D.RIGHT
end

-- Do forward last
local forward = 0
local forwardStart = smartTurtle.newPoint()
while forward < forwardMax do
  
  local horiz = 0
  local horizStart = smartTurtle.newPoint()
  while horiz < horizMax do
    
    local vert  = 1
    local vertStart = smartTurtle.newPoint()
    while vert < vertMax do
      smartTurtle.dig(vertDir)
      smartTurtle.move(vertDir)
      vert = vert + 1
    end
    smartTurtle.returnPoint(vertStart)
    smartTurtle.removePoint(vertStart)
    
    
    horiz = horiz + 1
    if horiz < horizMax then
      smartTurtle.face(horizDir)
      smartTurtle.dig(D.FORWARD)
      smartTurtle.move(D.FORWARD)
      smartTurtle.face(-horizDir)
    end
    
  end
  smartTurtle.returnPoint(horizStart)
  smartTurtle.removePoint(horizStart)
  
  
  forward = forward + 1
  if forward < forwardMax then
    smartTurtle.dig(D.FORWARD)
    smartTurtle.move(D.FORWARD)
  end
  
end
smartTurtle.returnPoint(forwardStart)

