-- Contains several API calls to turtles and other fun stuffs
local t = {}

-- ## Movement ##

function t:forward()
  print("FORWARD")
  return true
end
function t:back()
  print("BACK")
  return true
end
function t:up()
  print("UP")
  return true
end
function t:down()
  print("DOWN")
  return true
end
function t.turnLeft()
  print("LEFT")
  return true
end
function t.turnRight()
  print("RIGHT")
  return true
end

-- ## Attack ##

function t:attack()
  print("ATTACK")
  return true
end

function t:suck()
  print("SUCK")
  return true
end

-- ## Mining ##

function t.digUp()
  print("DIG UP")
  return getDigSuccess()
end
function t.dig() 
  print("DIG")
  return getDigSuccess()
end
function t.digDown()
  print("DIG DOWN")
  return getDigSuccess()
end

t.digSuccesses = 5
function getDigSuccess()
  if t.digSuccesses > 0 then
    t.digSuccesses = t.digSuccesses - 1
    return true
  end
  return false
end

-- ## Utility ##

function t.getFuelLevel()
  return 50
end

-- ## Place and Pick Blocks ##

-- ## Inventory ##

-- ## Inspection + Inspection Automation ##

-- Turtle.Inspect
function t.inspectUp()
  return t.getInspectResult()
end
function t.inspect()
  return t.getInspectResult()
end
function t.inspectDown()
  return t.getInspectResult()
end

t.goodInspectResult = { true, { state = { axis = "y", variant = "birch", }, name = "minecraft:log", metadata = 2, } }
t.badInspectResult = { false, nil }
t.goodInspects = 5
function t.getInspectResult()
  if t.goodInspects > 0 then
    t.goodInspects = t.goodInspects - 1
    return t.goodInspectResult[1], t.goodInspectResult[2]
  end
  return t.badInspectResult[1], t.badInspectResult[2]
end

turtle = t
