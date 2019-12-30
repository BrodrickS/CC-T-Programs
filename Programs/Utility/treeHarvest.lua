local isCC = (os.version ~= nil)
if not isCC then
  require("ComputerCraftStubs.stub_turtle")
end
require("Programs.SmartTurtleAPI.smartTurtle")

-- Remember movements

-- Check the block ahead
exists, data, isLog = smartTurtle.inspectIsLogDirection(TD.FORWARD)
if isLog then
  print("Is log!")
else
  print("Is not log!")
end
