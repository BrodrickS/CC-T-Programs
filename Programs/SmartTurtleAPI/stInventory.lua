local isCC = (os.version ~= nil)
if not isCC then
  require("ComputerCraftStubs.stub_turtle")
  require("ComputerCraftStubs.stub_shell")
end

-- Set the inventory methods on the smartTurtle class
return function(st) 

  -- ## INVENTORY ##

  -- Grabs the first empty slot in the inventory
  function st.findEmpty()
    for slot = 1, 16 do
      if turtle.getItemCount(slot) == 0 then
        return slot
      end
    end
    return nil
  end
  --

  -- Grabs the first item with the name quoted. Can be exact
  function st.findFirst(name, exact)
    exact = exact or false
    for slot = 1, 16 do
      local data = turtle.getItemDetail(slot)
      if data ~= nil then
          local blockName = data.name:sub((data.name:find(":") or 0)+1)
          if exact then
            if blockName == name then
              return slot
            end
          else
            if blockName:find(name) ~= nil then
              return slot
            end
          end
      end
    end
  end
  --

end
