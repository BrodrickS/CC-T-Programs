local isCC = (os.version ~= nil)
if not isCC then
  require("/ComputerCraftStubs.stub_turtle")
end
require("/Programs.SmartTurtleAPI.smartTurtle")

-- Check the block ahead
if smartTurtle.inspectIsLog() then
  print("Is log!")
else
  print("Is not log!")
end
