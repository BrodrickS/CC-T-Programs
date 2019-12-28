-- Contains several API calls to turtles and other fun stuffs

local function forward()
  print("FORWARD")
end

local function back()
  print("BACK")
end

turtle = {
  forward = forward,
  back = back
  }