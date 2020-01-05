--[[
#This includes all the methods associated with the SmartTurtle's Actions
#This includes the following types of method:
- Dig
- Place
- Suck
- Drop
- Inspect

]]--
local isCC = (os.version ~= nil)
if not isCC then
  require("ComputerCraftStubs.stub_turtle")
  require("ComputerCraftStubs.stub_shell")
end

return function(st) 

  -- ## DIG ## --

  -- Digs in a dirction
  function st.dig(dir)
    local func =  st._digFunc[dir]
    if func then
      return func()
    end
    return nil
  end
  st._digFunc = {
    [D.UP] = turtle.digUp,
    [D.FORWARD] = turtle.dig,
    [D.DOWN] = turtle.digDown,
  }
  --

  -- ## PLACE ## --

  -- ## SUCK ## --
  function st.suck(dir)
    local func = st._suckFunc[dir]
    if func then
      return func()
    end
    return nil
  end
  st._suckFunc = {
    [D.UP] = turtle.suckUp,
    [D.FORWARD] = turtle.suck,
    [D.DOWN] = turtle.suckDown,
  }


  -- ## DROP ## --
  function st.drop(dir)
    local func = st._dropFunc[dir]
    if func then
      return func()
    end
    return nil
  end
  st._dropFunc = {
    [D.UP] = turtle.dropUp,
    [D.FORWARD] = turtle.drop,
    [D.DOWN] = turtle.dropDown,
  }

  -- ## INSPECT ## --
  function st.inspect(dir)
    local func = st._inspectFunc[dir]
    if  func then
      local point = st.newPoint()
      st.face(dir)
      local exists, data = func()
      st.returnPoint(point)
      st.removePoint(point)
      return exists, data
    end
  end
  st._inspectFunc = {
    [D.UP] = turtle.inspectUp,
    [D.FORWARD] = turtle.inspect,
    [D.LEFT] = turtle.inspect,
    [D.RIGHT] = turtle.inspect,
    [D.BACK] = turtle.inspect,
    [D.DOWN] = turtle.inspectDown,
  }

end