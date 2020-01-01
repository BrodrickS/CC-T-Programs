local isCC = (os.version ~= nil)
if not isCC then
  require("Programs.SmartTurtleAPI.smartTurtle")
  require("ComputerCraftStubs.stub_turtle")
else
  require("/Programs.SmartTurtleAPI.smartTurtle")
end

local forwardMax = tonumber(arg[1])
if forwardMax == nil then
  forwardMax = 10
end
local sideMax = tonumber(arg[2])
if sideMax == nil or sideMax == 0 then
  sideMax = 10
end

local dir = nil
if sideMax > 0 then
  dir = D.LEFT
else
  sideMax = -sideMax
  dir = D.RIGHT
end

local side = -1

local trueStart = smartTurtle.newPoint()
while side < sideMax do
  
  local colStart = smartTurtle.newPoint()
  local forward = 0
  while forward < forwardMax do
    turtle.dig()
    smartTurtle.move(D.FORWARD)
    forward = forward + 1
  end
  smartTurtle.returnPoint(colStart)
  smartTurtle.removePoint(colStart)
  
  side = side + 1
  if (side < sideMax) then
    smartTurtle.face(dir)
    turtle.dig()
    smartTurtle.move(D.FORWARD)
    smartTurtle.face(-dir)
  end

end
smartTurtle.returnPoint(trueStart)

