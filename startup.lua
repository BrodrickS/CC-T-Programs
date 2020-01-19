local isCC = (os.version ~= nil)
if not isCC then
  require("ComputerCraftStubs.stub_shell")
end

local filename = "startup_target.csv"

-- Insertion point of the program
function main()
  -- Check if we have recieved the set arguement
  if arg[1] == "set" then
    table.remove(arg, 1)
    local file = io.open(filename, "w+")
    for key, value in pairs(arg) do
      if key > 0 then
        file:write(value .. "\n")
      end
    end
    file:close()
    print("STARTUP: New command saved")
  else  
    -- Check if there is a file designating the startup program
    local file = io.open(filename, "r")
    if file ~= nil then
      local callArgs = {}
      local line = file:read()
      while line ~= nil do
          table.insert(callArgs, line)
          line = file:read()
      end
      file:close()
      print("STARTUP: Running command")
      shell.run(unpack(callArgs))
    else
      print("STARTUP: No command for startup execution")
    end
  end
end
--

main()
