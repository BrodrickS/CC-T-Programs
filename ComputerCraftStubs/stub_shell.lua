local s = {}
local o = {}

function s.run(arg)
  print(arg)
end

function o.sleep(arg)
  print("SLEEPING " .. arg)
end

shell = s
os = o