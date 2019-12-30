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

-- ## Attack ##

function t:attack()
  print("ATTACK")
  return true
end

function t:suck()
  print("SUCK")
  return true
end

-- ## Utility ##

function t:getFuelLevel()
  return 50
end

-- ## Place and Pick Blocks ##

-- ## Inventory ##

-- ## Inspection + Inspection Automation ##

-- Turtle.Inspect
function t:inspectUp()
  return true, { state = { axis = "y", variant = "birch", }, name = "minecraft:log", metadata = 2, }
end
function t:inspect()
  return true, { state = { axis = "y", variant = "birch", }, name = "minecraft:log", metadata = 2, }
end
function t:inspectDown()
  return true, { state = { axis = "y", variant = "birch", }, name = "minecraft:log", metadata = 2, }
end

turtle = t
