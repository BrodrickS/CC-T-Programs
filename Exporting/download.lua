local isCC = (os.version ~= nil)
if not isCC then
  require("/ComputerCraftStubs.stub_turtle")
  require("/ComputerCraftStubs.stub_shell")
end

mainURL = "https://raw.githubusercontent.com/BrodrickS/CC-T-Programs/master"

source = {
  "startup.lua",
  Exporting = {
    "download.lua",
  },
  Programs = {
    SmartTurtleAPI = {
      "smartTurtle.lua",
      "stInventory.lua",
      "stMovement.lua",
      "stActions.lua",
    },
    Inventory = {
      "checkInventory.lua",
      "transferInventory.lua",
      "warehouse.lua",
    },
    Utility = {
      Auto = {
        "singleFarm.lua"
      },
      "attackForever.lua",
      "treeHarvest.lua",
      "mineAhead.lua",
      "treeHarvestLarge.lua",
      "farmCobble.lua",
      "mineFlat.lua",
    },
  },
}

local function download(directory, path)
  for key,value in pairs(directory) do
    --print(key)
    --print(value)
    if type(value) == "table" then
      shell.run("mkdir " .. path .. key)
      --shell.run("cd " .. key)
      download(value, path .. key .. "/" )
    else
      print("Downloading file " .. value)
      targetURL = mainURL .. "/" .. path .. value
      if isCC then
        local text = http.get(targetURL).readAll()
        local targetFile = io.open(path .. value, "w+")
        targetFile:write(text)
      else
        print("target = " .. targetURL)
        print("saveFile = " .. path .. value)
      end
    end
  end
  --shell.run("cd ..")
end

download(source, "")


