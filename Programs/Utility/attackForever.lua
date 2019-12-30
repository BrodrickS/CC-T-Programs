local isCC = (os.version ~= nil)
if not isCC then
  require("ComputerCraftStubs.stub_turtle")
end

-- Attack Forever
while true do
  turtle.attack()
  turtle.suck()
end
