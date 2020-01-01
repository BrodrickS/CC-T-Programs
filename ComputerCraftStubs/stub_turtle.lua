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

t._fuelLevel = 500
function t.getFuelLevel()
  return t._fuelLevel
end

function t.refuel()
  t._fuelLevel = t._fuelLevel + 500
  return true
end  

-- ## Place and Pick Blocks ##
function t.placeDown()
  print("PLACE DOWN")
end
--

-- ## Inventory ##
function t.select(slot)
  if slot == nil then
    print("error!")
  else
    print("SELECT " .. slot)
  end
end
--

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
--
function t.getItemDetail()  
  local exists, data = t.getInspectResult(false)
  return data
end


t.goodInspectResult = { true, { state = { age = 7 }, name = "minecraft:potatoes", metadata = 7, } }
t.badInspectResult = { false, nil }
t.goodInspects = 5
function t.getInspectResult(increment)
  if t.goodInspects > 0 then
    if increment == nil or increment then
      t.goodInspects = t.goodInspects - 1
    end
    return t.goodInspectResult[1], t.goodInspectResult[2]
  end
  return t.badInspectResult[1], t.badInspectResult[2]
end

turtle = t
