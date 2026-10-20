local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "LarpHub[govno = Survival LAVA for Brainrots]",
   Icon = 0,
   LoadingTitle = "Loading...",
   LoadingSubtitle = "V.1.0 (forever)",
   ShowText = "LarpHub",
   Theme = "Amethyst",

   ToggleUIKeybind = "K",

   DisableRayfieldPrompts = true,
   DisableBuildWarnings = false,

   ConfigurationSaving = {
      Enabled = false,
      FolderName = nil,
      FileName = "ProHub"
   }
})

local states = {
    InfiniteJump = false,
    NotFall = false
}

local MovementTab = Window:CreateTab("Movement", 4483362458)

MovementTab:CreateSection("Movement")

local InfinityJump = MovementTab:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Flag = "Toggle1", 
    Callback = function(Value)
        states.InfiniteJump = Value
    end,
})

game:GetService("UserInputService").JumpRequest:Connect(function()
    if states.InfiniteJump then
        local character = game.Players.LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end
end)

local WalkSpeed = MovementTab:CreateSlider({
    Name = "WalkSpeed",
    Range = {16, 500},
    Increment = 1,
    Suffix = "Walkspeed",
    CurrentValue = 16,
    Flag = "Slider1",
Callback = function(v)
game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v
end,
 })

local JumpPower = MovementTab:CreateSlider({
    Name = "JumpPower",
    Range = {50, 500},
    Increment = 1,
    Suffix = "JumpPower",
    CurrentValue = 50,
    Flag = "Slider1",
    Callback = function(v)
game.Players.LocalPlayer.Character.Humanoid.JumpPower = v
    end,
 })

local NotFall = MovementTab:CreateToggle({
   Name = "Not Fall",
   CurrentValue = false,
   Flag = "Toggle1",
   Callback = function(Value)
   states.NotFall = Value
      
      local player = game.Players.LocalPlayer
      local character = player.Character or player.CharacterAdded:Wait()
      local hrp = character:WaitForChild("HumanoidRootPart")
      
      if Value then
         local bv = Instance.new("BodyVelocity")
         bv.Name = "NotFallForce"
         bv.MaxForce = Vector3.new(0, math.huge, 0)
         bv.Velocity = Vector3.new(0, 0, 0)
         bv.Parent = hrp
         
         task.spawn(function()
            while states.NotFall do
               if character and hrp then
                  if not hrp:FindFirstChild("NotFallForce") then
                     local newBv = Instance.new("BodyVelocity")
                     newBv.Name = "NotFallForce"
                     newBv.MaxForce = Vector3.new(0, math.huge, 0)
                     newBv.Velocity = Vector3.new(0, 0, 0)
                     newBv.Parent = hrp
                  end
               end
               task.wait(0.5)
            end
         end)
      else
         local force = hrp:FindFirstChild("NotFallForce")
         if force then
            force:Destroy()
         end
      end
   end,
})

MovementTab:CreateSection("Teleports")

local TPSpawn = MovementTab:CreateButton({
   Name = "Tp to Spawn",
   Callback = function()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, 3, 0)
   end,
})

local TPCelestial = MovementTab:CreateButton({
   Name = "Teleport to Celestial Brainrot",
   Callback = function()
       local gameFolder = workspace:FindFirstChild("GameFolder")
       local brainrots = gameFolder and gameFolder:FindFirstChild("Brainrots")
       local celestial = brainrots and brainrots:FindFirstChild("Celestial")

       if not celestial then
           Rayfield:Notify({Title = "Error", Content = "Celestial folder not found!", Duration = 3})
           return
       end

       local items = celestial:GetChildren()

       if #items > 0 then
           local character = game.Players.LocalPlayer.Character
           local root = character and character:FindFirstChild("HumanoidRootPart")
           
           if root then
               root.CFrame = items[1]:GetPivot() + Vector3.new(0, 3, 0)
           end
       else
           Rayfield:Notify({Title = "Error", Content = "Celestial is not spawned!", Duration = 3})
       end
   end,
})

local MainTab = Window:CreateTab("Main", 4483362458)

MainTab:CreateSection("Main")

local ProximityPrompt = MainTab:CreateToggle({
   Name = "Proximity Prompt",
   CurrentValue = false,
   Flag = "Toggle1",
   Callback = function(Value)
     
   end,
})

local VisualsTab = Window:CreateTab("Visuals", 4483345998)

VisualsTab:CreateSection("ESP")

local ESPP = VisualsTab:CreateToggle({
   Name = "ESP for Players",
   CurrentValue = false,
   Flag = "Toggle1",
   Callback = function(Value)
    _G.ESP_Enabled = Value
    
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local LocalPlayer = Players.LocalPlayer
    local ESP_COLOR = Color3.fromRGB(255, 0, 0)

    local function removeESP(character)
        if character:FindFirstChild("ESPHighlight") then character.ESPHighlight:Destroy() end
        local head = character:FindFirstChild("Head")
        if head and head:FindFirstChild("ESPBillboard") then head.ESPBillboard:Destroy() end
    end

    local function createESP(player)
        if player == LocalPlayer then return end

        local function onCharacterAdded(character)
            if not _G.ESP_Enabled then return end

            local humanoid = character:WaitForChild("Humanoid", 10)
            local head = character:WaitForChild("Head", 10)
            local root = character:WaitForChild("HumanoidRootPart", 10)
            if not humanoid or not head or not root then return end

            local highlight = Instance.new("Highlight")
            highlight.Name = "ESPHighlight"
            highlight.Parent = character
            highlight.FillColor = ESP_COLOR
            highlight.OutlineColor = ESP_COLOR
            highlight.FillTransparency = 0.5
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

            local billboard = Instance.new("BillboardGui")
            billboard.Name = "ESPBillboard"
            billboard.Size = UDim2.new(0, 200, 0, 50)
            billboard.StudsOffset = Vector3.new(0, 3, 0) 
            billboard.AlwaysOnTop = true                 
            billboard.Parent = head

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.TextColor3 = ESP_COLOR
            label.TextStrokeTransparency = 0             
            label.TextSize = 14
            label.Font = Enum.Font.RobotoMono
            label.Parent = billboard

            local connection
            connection = RunService.RenderStepped:Connect(function()
                if not _G.ESP_Enabled or not character or not character.Parent or not humanoid or humanoid.Health <= 0 then
                    connection:Disconnect()
                    removeESP(character)
                    return
                end
                local distance = math.floor((root.Position - workspace.CurrentCamera.CFrame.Position).Magnitude)
                label.Text = string.format("%s\n[%dм]", player.Name, distance)
            end)
        end

        player.CharacterAdded:Connect(onCharacterAdded)
        if player.Character then onCharacterAdded(player.Character) end
    end

    if not Value then
        for _, player in ipairs(Players:GetPlayers()) do
            if player.Character then removeESP(player.Character) end
        end
    else
        for _, player in ipairs(Players:GetPlayers()) do
            createESP(player)
        end
    end
   end,
})

