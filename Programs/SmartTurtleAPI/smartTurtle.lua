local isCC = (os.version ~= nil)
if not isCC then
  require("ComputerCraftStubs.stub_turtle")
end

local st = {}

function st:agressiveForward()
  while not turtle.forward() do
    turtle.attack()
  end
end

-- Checks if this block ahead is a log
function st:inspectIsLog()
  exists, data = turtle.inspect()
  if not exists then return false end
  if string.find(data.name, "log") then return true end
end

smartTurtle = st
