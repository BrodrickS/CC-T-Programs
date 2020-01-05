local isCC = (os.version ~= nil)
if not isCC then
  require("ComputerCraftStubs.stub_turtle")
  require("ComputerCraftStubs.stub_shell")
end

-- Set the inventory methods on the smartTurtle class
return function(st) 
  
  -- Moves Directionally
  function st.move(dir, remember)
    if remember == nil then
      remember = true
    end
    
    local func = st._moveFunc[dir]
    if func then
      local success = func()
      if success and remember then
        st.rememberMove(dir)
      end
      return success
    end
  end
  st._moveFunc = {
    [D.UP] = turtle.up,
    [D.FORWARD] = turtle.forward,
    [D.DOWN] = turtle.down,
    [D.LEFT] = turtle.turnLeft,
    [D.BACK] = turtle.back,
    [D.RIGHT] = turtle.turnRight,
  }
  --

  -- Turns to face a direction
  function st.face(dir, remember)
    if remember == nil then
      remember = true
    end
    
    local dirs = st._faceDirs[dir]
    if dirs then
      for idx, val in pairs(dirs) do
        st.move(val, remember)
      end
    end
  end
  st._faceDirs = {
    [D.LEFT] = {D.LEFT},
    [D.RIGHT] = {D.RIGHT},
    [D.BACK] = {D.LEFT, D.LEFT},
  }
  --
  
  -- Logs moves
  -- Called inside st.move(), so we can call st.returnPoint() later
  function st.rememberMove(dir)
    for idx = 1, st.memPointsCount do
      local point = st.memPoints[idx]
      if point ~= nil then
        local lastMove = point[#point]
        local last2Move = point[#point - 1]
        if (lastMove == D.LEFT or lastMove == D.RIGHT) and lastMove == dir and lastMove == last2Move then
          table.remove(point)
          table.remove(point)
          table.insert(point, -dir)
        elseif lastMove == -dir then
          table.remove(point)
        else
          table.insert(point, dir)
        end
      end
    end
  end 
  --

  -- Create New Memory Point
  function st.newPoint()
    local memPoint = {}
    st.memPointsCount = st.memPointsCount + 1
    st.memPoints[st.memPointsCount] = memPoint
    return st.memPointsCount
  end
  st.memPoints = {}
  st.memPointsCount = 0

  -- Renove a Memory Point
  function st.removePoint(pointIndex)
    st.memPoints[pointIndex] = nil
  end
  --

  -- Return to Memory Point
  function st.returnPoint(pointIndex, failFunction)
    -- Set fail function to a sleep function if it's not defined by the call
    
    if failFunction == nil then
      failFunction = st._moveFail
    end
    
    local point = st.memPoints[pointIndex]
    if point ~= nil then
      -- reverse table
      invList = {}
      for idx, value in pairs(point) do
        table.insert(invList, 1, value)
      end
      for idx, value in pairs(invList) do
          
          local attempts = 0
          while not st.move(-value) and attempts < 3 do
            attempts = attempts + 1
            print("move failed, attempting fix #" .. tostring(attempts) .. "...")
            failFunction()
          end
      
        if not success and failFunction then
        end
      end
    end
  end
  function st._moveFail()
    print("sleeping 1...")
    os.sleep(1)
  end
  --

  function st.stepBackToPoint(pointIndex)
    local point = st.memPoints[pointIndex]
    if point ~= nil then
      local lastMove = point[#point]
      st.move(-lastMove)
    end
  end
  --

  
end
