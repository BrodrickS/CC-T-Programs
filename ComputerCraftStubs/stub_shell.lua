local s = {}
local o = {}

function s.run(...)
  local arg = {...}
  print(unpack(arg))
end

function o.sleep(arg)
  print("SLEEPING " .. arg)
end

shell = s
os = o