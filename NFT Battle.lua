local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local farming = false
local autoSell = true
local openAmount = 10
local alive = true
local runId = 0

local Events = game:GetService("ReplicatedStorage"):WaitForChild("Events")

local caseGroups = {
   ["Free"] = {"Trash"},
   ["Newest"] = {"Glitch 2.0", "SBR", "Mirage Lamps"},
   ["Special"] = {"Bloody Night", "Ninja Turtles", "Monarch", "Radioactive", "Angel", "Desk Calendars", "Dio", "TSUM", "Spider Man"},
   ["Tons"] = {"Durov", "Sunny Day", "REDO", "Death Note", "Mineblox", "Sunglasses", "Champions"},
   ["Gems"] = {"Magnate", "Cirque", "Blue Eyes", "The Boys", "Butterfly"},
   ["Cars"] = {"M5 F90", "G63", "Porsche 911", "URUS", "Cyber"},
   ["NFT"] = {"Frozen Heart", "Bubble Gum", "Cats", "Glitch", "Dream"},
   ["Retro"] = {"Beggar", "Plodder", "Office Clerk", "Manager", "Oligarch", "Gold", "Director", "Dark", "Palm", "Burj", "Luxury"}
}

local groupOrder = {"Free", "Newest", "Special", "Tons", "Gems", "Cars", "NFT", "Retro"}

local selectedCategory = groupOrder[1]
local selectedCase = caseGroups[selectedCategory][1]
local customCase = ""

local Window = Rayfield:CreateWindow({
   Name = "LarpHub - NFT Battle",
   Icon = 0,
   LoadingTitle = "Loading...",
   LoadingSubtitle = "v.1.3",
   ShowText = "LarpHub",
   Theme = "Amethyst",
   ToggleUIKeybind = "K",
   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false,
   ConfigurationSaving = {
      Enabled = false,
      FolderName = nil,
      FileName = "Big Hub"
   }
})

local TabFarm = Window:CreateTab("Case", "banknote")
local TabInfo = Window:CreateTab("Info", "book-text")

TabInfo:CreateLabel("Guy: Sirius")
TabInfo:CreateLabel("Tested on: Delta")

TabInfo:CreateButton({
   Name = "Destroy UI",
   Callback = function()
      farming = false
      alive = false
      runId = runId + 1
      Rayfield:Destroy()
   end,
})

Rayfield:Notify({
   Title = "Good news",
   Content = "The script is fully optimized",
   Duration = 6.5,
   Image = "x",
})

local CaseDropdown

TabFarm:CreateDropdown({
   Name = "Select Category",
   Options = groupOrder,
   CurrentOption = {selectedCategory},
   MultipleOptions = false,
   Callback = function(Option)
      selectedCategory = Option[1]
      local availableCases = caseGroups[selectedCategory]
      selectedCase = availableCases[1]

      if CaseDropdown then
         CaseDropdown:Refresh(availableCases)
         CaseDropdown:Set({selectedCase})
      end
   end,
})

CaseDropdown = TabFarm:CreateDropdown({
   Name = "Select Case",
   Options = caseGroups[selectedCategory],
   CurrentOption = {selectedCase},
   MultipleOptions = false,
   Callback = function(Option)
      selectedCase = Option[1]
   end,
})

TabFarm:CreateInput({
   Name = "Custom Case",
   CurrentValue = "",
   PlaceholderText = "Case name (empty = use selected)",
   RemoveTextAfterFocusLost = false,
   Flag = "CustomCaseInput",
   Callback = function(Text)
      customCase = (Text or ""):match("^%s*(.-)%s*$")
   end,
})

TabFarm:CreateSlider({
   Name = "Cases per open",
   Range = {1, 10},
   Increment = 1,
   Suffix = "cases",
   CurrentValue = 10,
   Flag = "OpenAmountSlider",
   Callback = function(Value)
      openAmount = math.clamp(math.floor(Value), 1, 10)
   end,
})

TabFarm:CreateToggle({
   Name = "Sell Items",
   CurrentValue = true,
   Flag = "AutoSellToggle",
   Callback = function(Value)
      autoSell = Value
   end,
})

local function sellAll()
   pcall(function()
      Events:WaitForChild("Inventory"):FireServer("Sell", "ALL")
   end)
end

-- Окремий цикл продажу: працює незалежно від відкриття,
-- тому тумблер "Sell Items" можна вмикати/вимикати в будь-який момент.
task.spawn(function()
   while alive do
      if farming and autoSell then
         sellAll()
      end
      task.wait(1.5)
   end
end)

TabFarm:CreateToggle({
   Name = "Auto Open",
   CurrentValue = false,
   Flag = "AutoFarmToggle",
   Callback = function(Value)
      farming = Value
      runId = runId + 1 -- скасовує старий цикл, щоб не було дублів
      if farming then
         local myId = runId
         task.spawn(function()
            while alive and farming and runId == myId do
               -- pcall: помилка від сервера більше не вбиває цикл
               local ok = pcall(function()
                  local caseToOpen = (customCase ~= "" and customCase) or selectedCase
                  Events:WaitForChild("OpenCase"):InvokeServer(caseToOpen, openAmount)
               end)
               task.wait(ok and 1 or 2)
            end
         end)
      end
   end,
})
