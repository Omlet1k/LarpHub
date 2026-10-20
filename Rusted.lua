local t1 = {}
local t2 = {}
local v3 = unpack or table.unpack
t2.value1 = game:GetService("CoreGui")
t2.value2 = game:GetService("Players")
t2.value3 = game:GetService("RunService")
t2.value4 = game:GetService("UserInputService")
game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
t2.value5 = game:GetService("Lighting")
t2.value6 = game:GetService("Debris")
t2.value7 = game:GetService("SoundService")
t2.value8 = t2.value2.LocalPlayer
t2.value9 = workspace.CurrentCamera
t2.value10 = {
	SILENT_AIM = false,
	HIT_CHANCE = 95,
	HIT_PART = "Head",
	FOV_RADIUS = 200,
	SHOW_FOV = false,
	TEAM_CHECK = false,
	SNAPLINE = false,
	TRACER = false,
	TRACER_TYPE = "Red Laser",
	TRACER_LIFE = 3,
	RAPID_FIRE = false,
	RAPID_VALUE = 1000,
	HIT_SOUND = false,
	HIT_SOUND_ID = "121566025787365",
	HIT_SOUND_VOL = 1,
	ESP = false,
	ESP_BOX = false,
	ESP_NAME = false,
	ESP_HEALTH = false,
	ESP_DIST = false,
	SKYBOX = false,
	CUSTOM_HANDS = false,
	HANDS_X = 5,
	HANDS_Y = -2,
	HANDS_Z = -8,
	SPEED = false,
	SPEED_VAL = 50,
	INF_JUMP = false,
	NO_CLIP = false,
	NOCLIP_KEY = false,
	GIGA_JUMP = false,
	GIGA_POWER = 50,
	GIGA_KEY = false,
	FLOAT = false,
	FLOAT_SPEED = 5,
	FLOAT_KEY = false,
	FULLBRIGHT = false,
	TP_DIST = 50,
	TP_KEY = false,
	JUMP_SHOT = false,
	NO_JUMP_CD = false,
	WHITELIST = false,
	NEON_GUNS = false,
	FURRY_DROP = false,
	FURRY_DROP_DIST = 10,
	FURRY_DROP_KEY = false
}
t2.value11 = {
	originalJumpPower = nil,
	originalRateOfFire = {},
	floatPlatform = nil,
	skyObject = nil,
	weaponConn = nil,
	hitSoundObj = nil,
	hitSoundHook = nil,
	snapLine = nil,
	espData = {},
	rainbowOffset = 0,
	tpCooldown = 0,
	whitelist = {},
	chamsConn = nil,
	isTeleporting = false,
	teleportButton = nil,
	teleportButtonLocked = false,
	teleportButtonDragging = false,
	teleportButtonDragStart = nil,
	teleportButtonStartPos = nil,
	noclipButton = nil,
	noclipButtonLocked = false,
	noclipButtonDragging = false,
	noclipButtonDragStart = nil,
	noclipButtonStartPos = nil,
	noclipParts = {},
	furryDropButton = nil,
	furryDropButtonLocked = false,
	furryDropButtonDragging = false,
	furryDropButtonDragStart = nil,
	furryDropButtonStartPos = nil,
	furryDropActive = false,
	furryDropOriginalCFrame = nil,
	furryDropConnection = nil
}
function t2.value12(p1)
    local StarterGui = game:GetService("StarterGui")
    local SetCore = StarterGui.SetCore
    local str = tostring(p1)

    SetCore(StarterGui, "SendNotification", {
		Title = "LarpHub",
		Text = str,
		Duration = 3
	})
end
t2.value15 = nil
function t2.value15()
    local Character = t2.value8.Character

    if Character then
        Character = t2.value8.Character:FindFirstChild("HumanoidRootPart")
    end

    return Character
end
function t2.value16()
    if t2.value11.furryDropConnection then
        t2.value11.furryDropConnection:Disconnect()
        t2.value11.furryDropConnection = nil
    end

    local v83 = t2.value15()

    if not v83 or not v83.Parent then
        return
    end

    t2.value11.furryDropOriginalCFrame = v83.CFrame
    v83.CFrame = v83.CFrame * CFrame.new(0, -t2.value10.FURRY_DROP_DIST, 0)
    t2.value11.furryDropActive = true
    t2.value11.furryDropConnection = t2.value3.Heartbeat:Connect(function()
        local v375 = t2.value15()
        local v376 = v375

        if v375 then
            v376 = t2.value11.furryDropActive
        end

        if v376 then
            v375.CFrame = t2.value11.furryDropOriginalCFrame * CFrame.new(0, -t2.value10.FURRY_DROP_DIST, 0)
        end
    end)

    if t2.value11.furryDropButton then
        t2.value11.furryDropButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        t2.value11.furryDropButton.BackgroundTransparency = 0.1
        t2.value11.furryDropButton.ImageColor3 = Color3.fromRGB(255, 100, 100)
    end
end
t2.value17 = nil
function t2.value17()
    t2.value11.furryDropActive = false

    if t2.value11.furryDropConnection then
        t2.value11.furryDropConnection:Disconnect()
        t2.value11.furryDropConnection = nil
    end

    local v84 = t2.value15()
    local v85 = v84

    if v84 then
        v85 = t2.value11.furryDropOriginalCFrame
    end

    if v85 then
        v84.CFrame = t2.value11.furryDropOriginalCFrame
        t2.value11.furryDropOriginalCFrame = nil
    end

    if t2.value11.furryDropButton then
        t2.value11.furryDropButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        t2.value11.furryDropButton.BackgroundTransparency = 0.2
        t2.value11.furryDropButton.ImageColor3 = Color3.fromRGB(255, 255, 255)
    end
end
function t2.value18()
    if t2.value11.furryDropActive then
        t2.value17()

        return
    end

    t2.value16()
end;
(function()
    if t2.value11.furryDropButton then
        return
    end

    local ScreenGui = Instance.new("ScreenGui")

    ScreenGui.Name = "FurryDropButton"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.DisplayOrder = 999
    ScreenGui.Parent = t2.value1

    local ImageButton = Instance.new("ImageButton")

    ImageButton.Size = UDim2.new(0, 70, 0, 70)
    ImageButton.Position = UDim2.new(0.7, 0, 0.5, 0)
    ImageButton.AnchorPoint = Vector2.new(0.5, 0.5)
    ImageButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    ImageButton.BackgroundTransparency = 0.2
    ImageButton.BorderSizePixel = 0
    ImageButton.Image = "rbxassetid://6019251097"
    ImageButton.ImageColor3 = Color3.fromRGB(255, 255, 255)
    ImageButton.AutoButtonColor = true
    ImageButton.ZIndex = 300
    ImageButton.Parent = ScreenGui
    ImageButton.Visible = false
    Instance.new("UICorner", ImageButton).CornerRadius = UDim.new(0, 0)

    local UIStroke = Instance.new("UIStroke", ImageButton)

    UIStroke.Color = Color3.fromRGB(255, 200, 255)
    UIStroke.Thickness = 2
    UIStroke.Transparency = 0.3
    ImageButton.InputBegan:Connect(function(input)
        if t2.value11.furryDropButtonLocked then
            return
        end

        local v378 = input.UserInputType == Enum.UserInputType.MouseButton1

        if not v378 then
            v378 = input.UserInputType == Enum.UserInputType.Touch
        end

        if v378 then
            t2.value11.furryDropButtonDragging = true
            t2.value11.furryDropButtonDragStart = input.Position
            t2.value11.furryDropButtonStartPos = ImageButton.Position
        end
    end)
    ImageButton.InputEnded:Connect(function()
        t2.value11.furryDropButtonDragging = false
    end)
    t2.value4.InputChanged:Connect(function(input)
        local furryDropButtonDragging = t2.value11.furryDropButtonDragging

        if furryDropButtonDragging then
            furryDropButtonDragging = input.UserInputType == Enum.UserInputType.MouseMovement

            if not furryDropButtonDragging then
                furryDropButtonDragging = input.UserInputType == Enum.UserInputType.Touch
            end
        end

        if furryDropButtonDragging then
            local v381 = input.Position - t2.value11.furryDropButtonDragStart

            ImageButton.Position = UDim2.new(t2.value11.furryDropButtonStartPos.X.Scale, t2.value11.furryDropButtonStartPos.X.Offset + v381.X, t2.value11.furryDropButtonStartPos.Y.Scale, t2.value11.furryDropButtonStartPos.Y.Offset + v381.Y)
        end
    end)
    ImageButton.MouseButton1Click:Connect(function()
        if not t2.value11.furryDropButtonDragging then
            t2.value18()
        end
    end)
    ImageButton.TouchTap:Connect(function()
        if not t2.value11.furryDropButtonDragging then
            t2.value18()
        end
    end)
    t2.value11.furryDropButton = ImageButton
end)()
for _, v in pairs({
	"LarpHub",
	"LarpHubButton",
	"LarpHubFOV",
	"FOV_Indicator"
}) do
    local v2 = t2.value1:FindFirstChild(v)

    if v2 then
        v2:Destroy()
    end
end
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LarpHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
local _syn = syn
if _syn then
    _syn = syn.protect_gui
end
if _syn then
    syn.protect_gui(ScreenGui)
elseif gethui then
    ScreenGui.Parent = gethui()
else
    ScreenGui.Parent = t2.value1
end
t2.value19 = Instance.new("Frame")
t2.value19.Size = UDim2.new(0, 640, 0, 360)
t2.value19.Position = UDim2.new(0.5, -320, 0.5, -180)
t2.value19.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
t2.value19.BorderSizePixel = 1
t2.value19.BorderColor3 = Color3.fromRGB(150, 50, 220)
t2.value19.Active = true
t2.value19.Draggable = true
t2.value19.Visible = true
t2.value19.Parent = ScreenGui
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(1, 0, 0, 35)
Frame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
Frame.BorderSizePixel = 0
Frame.Parent = t2.value19
local Frame2 = Instance.new("Frame")
Frame2.Size = UDim2.new(1, 0, 0, 1)
Frame2.Position = UDim2.new(0, 0, 1, 0)
Frame2.BackgroundColor3 = Color3.fromRGB(150, 50, 220)
Frame2.BorderSizePixel = 0
Frame2.Parent = Frame
local TextLabel = Instance.new("TextLabel")
TextLabel.Size = UDim2.new(1, 0, 1, 0)
TextLabel.BackgroundTransparency = 1
TextLabel.Text = "LarpHub  |  Rusted"
TextLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
TextLabel.Font = Enum.Font.SourceSans
TextLabel.TextSize = 15
TextLabel.Parent = Frame
t2.value20 = Instance.new("TextButton")
t2.value20.Size = UDim2.new(0, 72, 0, 30)
t2.value20.Position = UDim2.new(0, 10, 1, -45)
t2.value20.BackgroundColor3 = Color3.fromRGB(90, 30, 160)
t2.value20.BorderSizePixel = 1
t2.value20.BorderColor3 = Color3.fromRGB(150, 50, 220)
t2.value20.Text = "LARPHUB"
t2.value20.TextColor3 = Color3.fromRGB(230, 230, 230)
t2.value20.Font = Enum.Font.SourceSansBold
t2.value20.TextSize = 12
t2.value20.ZIndex = 999
t2.value20.Parent = ScreenGui
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 6)
UICorner.Parent = t2.value20
t2.value21 = false
t2.value22 = nil
t2.value23 = nil
t2.value20.InputBegan:Connect(function(input)
    local v90 = input.UserInputType == Enum.UserInputType.MouseButton1

    if not v90 then
        v90 = input.UserInputType == Enum.UserInputType.Touch
    end

    if v90 then
        t2.value21 = true
        t2.value22 = input.Position
        t2.value23 = t2.value20.Position
    end
end)
t2.value20.InputEnded:Connect(function()
    t2.value21 = false
end)
t2.value4.InputChanged:Connect(function(input)
    local value21 = t2.value21

    if value21 then
        value21 = input.UserInputType == Enum.UserInputType.MouseMovement

        if not value21 then
            value21 = input.UserInputType == Enum.UserInputType.Touch
        end
    end

    if value21 then
        local v93 = input.Position - t2.value22

        t2.value20.Position = UDim2.new(t2.value23.X.Scale, t2.value23.X.Offset + v93.X, t2.value23.Y.Scale, t2.value23.Y.Offset + v93.Y)
    end
end)
local function v16()
    if not t2.value21 then
        t2.value19.Visible = not t2.value19.Visible
    end
end
t2.value20.MouseButton1Click:Connect(v16)
t2.value20.TouchTap:Connect(v16)
t2.value4.InputBegan:Connect(function(input, gameProcessed)
    local v96 = not gameProcessed and not t2.binding

    if v96 then
        v96 = input.KeyCode == Enum.KeyCode.Insert
    end

    if v96 then
        t2.value19.Visible = not t2.value19.Visible
    end
end)
local Frame3 = Instance.new("Frame")
Frame3.Size = UDim2.new(1, 0, 0, 25)
Frame3.Position = UDim2.new(0, 0, 0, 35)
Frame3.BackgroundTransparency = 1
Frame3.Parent = t2.value19
t2.value24 = {
	"Combat",
	"Visuals",
	"Misc",
	"Settings"
}
t2.value25 = {}
t2.value26 = {}
for i, v in ipairs(t2.value24) do
    local v20 = i

    t1.value1 = Instance.new("TextButton")

    local value1 = t1.value1

    t1.value1 = value1

    local uDim2 = UDim2.new(0.25, 0, 1, 0)

    t1.value1.Size = uDim2
    t1.value1 = value1

    local uDim2_2 = UDim2.new((v20 - 1) * 0.25, 0, 0, 0)

    t1.value1.Position = uDim2_2
    t1.value1 = value1
    t1.value1.BackgroundTransparency = 1
    t1.value1 = value1
    t1.value1.Text = v
    t1.value1 = value1
    t1.value4 = v20 == 1
    t1.value3 = t1.value4

    if t1.value4 then
        t1.value3 = Color3.fromRGB(150, 50, 220)
    end

    t1.value2 = t1.value3

    if not t1.value3 then
        t1.value2 = Color3.fromRGB(140, 140, 140)
    end

    t1.value1.TextColor3 = t1.value2
    t1.value1 = value1
    t1.value2 = Enum.Font.SourceSans
    t1.value1.Font = t1.value2
    t1.value1 = value1
    t1.value1.TextSize = 14
    t1.value1 = value1
    t1.value1.Parent = Frame3
    t2.value25[v] = value1

    local Frame4 = Instance.new("Frame")

    t1.value2 = "Size"
    t1.value3 = UDim2.new(1, -20, 1, -75)
    Frame4[t1.value2] = t1.value3
    t1.value2 = "Position"
    t1.value3 = UDim2.new(0, 10, 0, 70)
    Frame4[t1.value2] = t1.value3
    t1.value2 = "BackgroundTransparency"
    Frame4[t1.value2] = 1
    t1.value2 = "Visible"
    Frame4[t1.value2] = v20 == 1
    t1.value2 = "Parent"
    Frame4[t1.value2] = t2.value19

    local t4 = {}

    t1.value3 = 3

    for i2 = 1, t1.value3 do
        t1.value5 = Instance.new("ScrollingFrame")
        t1.value6 = UDim2.new(0.333, -4, 1, 0)
        t1.value5.Size = t1.value6
        t1.value6 = UDim2.new((i2 - 1) * 0.333, i2 ~= 1 and 4 or 0, 0, 0)
        t1.value5.Position = t1.value6
        t1.value5.BackgroundTransparency = 1
        t1.value5.BorderSizePixel = 0
        t1.value5.ScrollBarThickness = 6
        t1.value5.Active = true
        t1.value5.ScrollingEnabled = true
        t1.value5.ScrollingDirection = Enum.ScrollingDirection.Y
        t1.value5.ElasticBehavior = Enum.ElasticBehavior.Never
        t1.value5.ClipsDescendants = true
        t1.value6 = Color3.fromRGB(150, 50, 220)
        t1.value5.ScrollBarImageColor3 = t1.value6

        local AutomaticSizeY = Enum.AutomaticSize.Y

        t1.value5.AutomaticCanvasSize = AutomaticSizeY
        t1.value6 = UDim2.new()
        t1.value5.CanvasSize = t1.value6
        t1.value5.Parent = Frame4

        local UIPadding = Instance.new("UIPadding")

        UIPadding.PaddingBottom = UDim.new(0, 20)
        UIPadding.PaddingRight = UDim.new(0, 8)
        UIPadding.Parent = t1.value5

        local UIListLayout = Instance.new("UIListLayout")

        UIListLayout.Padding = UDim.new(0, 6)
        t1.value6 = Enum.SortOrder.LayoutOrder
        UIListLayout.SortOrder = t1.value6
        UIListLayout.Parent = t1.value5
        t4[i2] = t1.value5
    end

    t1.value2 = t2.value26
    t1.value2[v] = {
		content = Frame4,
		cols = t4
	}
    t1.value2 = value1.MouseButton1Click

    function t1.value3()
        for _, v4 in ipairs(t2.value24) do
            t2.value25[v4].TextColor3 = Color3.fromRGB(140, 140, 140)
            t2.value26[v4].content.Visible = false
        end

        value1.TextColor3 = Color3.fromRGB(150, 50, 220)
        Frame4.Visible = true
    end

    t1.value2:Connect(t1.value3)
end
function t1.value1(p2)
    if not t2.value10.WHITELIST then
        return false
    end

    return t2.value11.whitelist[p2.Name] == true
end
local function v29(p3, p4, p5, p6)
    local Frame5 = Instance.new("Frame")
    Frame5.Size = UDim2.new(1, 0, 0, 20)
    Frame5.BackgroundTransparency = 1
    Frame5.Parent = p3
    local TextLabel3 = Instance.new("TextLabel")
    TextLabel3.Size = UDim2.new(1, -50, 1, 0)
    TextLabel3.BackgroundTransparency = 1
    TextLabel3.Text = p4
    TextLabel3.TextColor3 = Color3.fromRGB(160, 160, 160)
    TextLabel3.Font = Enum.Font.SourceSans
    TextLabel3.TextSize = 13
    TextLabel3.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel3.Parent = Frame5
    local TextButton2 = Instance.new("TextButton")
    TextButton2.Size = UDim2.new(0, 40, 1, 0)
    TextButton2.Position = UDim2.new(1, -40, 0, 0)
    TextButton2.BackgroundTransparency = 1
    TextButton2.Text = not p5 and "OFF" or "ON"
    local v107 = p5
    if p5 then
        v107 = Color3.fromRGB(150, 50, 220)
    end
    if not v107 then
        v107 = Color3.fromRGB(90, 90, 90)
    end
    TextButton2.TextColor3 = v107
    TextButton2.Font = Enum.Font.SourceSans
    TextButton2.TextSize = 12
    TextButton2.TextXAlignment = Enum.TextXAlignment.Right
    TextButton2.Parent = Frame5
    local u108 = p5
    local function v109()
        u108 = not u108
        TextButton2.Text = not u108 and "OFF" or "ON"

        local v382 = TextButton2
        local v383 = u108

        if v383 then
            v383 = Color3.fromRGB(150, 50, 220)
        end

        if not v383 then
            v383 = Color3.fromRGB(90, 90, 90)
        end

        v382.TextColor3 = v383

        if p6 then
            p6(u108)
        end
    end
    TextButton2.MouseButton1Click:Connect(v109)

    return TextButton2
end
local function v30(p7, p8, p9)
    local Frame6 = Instance.new("Frame")

    Frame6.Size = UDim2.new(1, 0, 0, 30)
    Frame6.AutomaticSize = Enum.AutomaticSize.Y
    Frame6.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Frame6.BorderColor3 = Color3.fromRGB(40, 40, 40)
    Frame6.ClipsDescendants = false
    Frame6.Parent = p7

    local TextLabel4 = Instance.new("TextLabel")

    TextLabel4.Size = UDim2.new(1, -10, 0, 18)
    TextLabel4.Position = UDim2.new(0, 10, 0, -9)
    TextLabel4.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    TextLabel4.Text = "  " .. p8 .. "  "
    TextLabel4.TextColor3 = Color3.fromRGB(200, 200, 200)
    TextLabel4.Font = Enum.Font.SourceSansSemibold
    TextLabel4.TextSize = 13
    TextLabel4.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel4.Parent = Frame6

    local UIListLayout = Instance.new("UIListLayout")

    UIListLayout.Padding = UDim.new(0, 6)
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Parent = Frame6

    local UIPadding = Instance.new("UIPadding")

    UIPadding.PaddingTop = UDim.new(0, 12)
    UIPadding.PaddingBottom = UDim.new(0, 10)
    UIPadding.PaddingLeft = UDim.new(0, 10)
    UIPadding.PaddingRight = UDim.new(0, 10)
    UIPadding.Parent = Frame6

    return Frame6
end
local function v31(p10, p11, p12)
    local TextLabel5 = Instance.new("TextLabel")

    TextLabel5.Size = UDim2.new(1, 0, 0, 20)
    TextLabel5.BackgroundTransparency = 1
    TextLabel5.Text = p11

    if not p12 then
        p12 = Color3.fromRGB(200, 200, 200)
    end

    TextLabel5.TextColor3 = p12
    TextLabel5.Font = Enum.Font.SourceSans
    TextLabel5.TextSize = 13
    TextLabel5.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel5.Parent = p10

    return TextLabel5
end
t2.value27 = nil
local function v32(p13, p14, p15, p16, p17, p18)
    local Frame7 = Instance.new("Frame")

    Frame7.Size = UDim2.new(1, 0, 0, 34)
    Frame7.BackgroundTransparency = 1
    Frame7.Parent = p13

    local TextLabel6 = Instance.new("TextLabel")

    TextLabel6.Size = UDim2.new(0.6, 0, 0, 15)
    TextLabel6.BackgroundTransparency = 1
    TextLabel6.Text = p14
    TextLabel6.TextColor3 = Color3.fromRGB(160, 160, 160)
    TextLabel6.Font = Enum.Font.SourceSans
    TextLabel6.TextSize = 13
    TextLabel6.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel6.Parent = Frame7

    local TextLabel7 = Instance.new("TextLabel")

    TextLabel7.Size = UDim2.new(0.4, 0, 0, 15)
    TextLabel7.Position = UDim2.new(0.6, 0, 0, 0)
    TextLabel7.BackgroundTransparency = 1
    TextLabel7.Text = tostring(p17)
    TextLabel7.TextColor3 = Color3.fromRGB(150, 50, 220)
    TextLabel7.Font = Enum.Font.SourceSans
    TextLabel7.TextSize = 12
    TextLabel7.TextXAlignment = Enum.TextXAlignment.Right
    TextLabel7.Parent = Frame7

    local Frame8 = Instance.new("Frame")

    Frame8.Size = UDim2.new(1, 0, 0, 6)
    Frame8.Position = UDim2.new(0, 0, 0, 20)
    Frame8.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Frame8.BorderSizePixel = 0
    Frame8.Active = true
    Frame8.Parent = Frame7

    local Frame9 = Instance.new("Frame")

    Frame9.Size = UDim2.new((p17 - p15) / (p16 - p15), 0, 1, 0)
    Frame9.BackgroundColor3 = Color3.fromRGB(150, 50, 220)
    Frame9.BorderSizePixel = 0
    Frame9.Parent = Frame8

    local Frame10 = Instance.new("Frame")

    Frame10.Size = UDim2.new(0, 10, 0, 12)
    Frame10.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame10.Position = UDim2.new((p17 - p15) / (p16 - p15), 0, 0.5, 0)
    Frame10.BackgroundColor3 = Color3.fromRGB(200, 100, 255)
    Frame10.BorderSizePixel = 0
    Frame10.ZIndex = 3
    Frame10.Parent = Frame8

    local u133 = p17
    local u134 = false

    local function v135(p19)
        local AbsolutePositionX = Frame8.AbsolutePosition.X
        local AbsoluteSizeX = Frame8.AbsoluteSize.X

        if AbsoluteSizeX <= 0 then
            return
        end

        local v388 = math.clamp((p19 - AbsolutePositionX) / AbsoluteSizeX, 0, 1)

        u133 = math.floor(p15 + (p16 - p15) * v388 + 0.5)
        Frame9.Size = UDim2.new(v388, 0, 1, 0)
        Frame10.Position = UDim2.new(v388, 0, 0.5, 0)
        TextLabel7.Text = tostring(u133)

        if p18 then
            p18(u133)
        end
    end

    Frame8.InputBegan:Connect(function(input)
        local v390 = input.UserInputType == Enum.UserInputType.MouseButton1

        if not v390 then
            v390 = input.UserInputType == Enum.UserInputType.Touch
        end

        if v390 then
            u134 = true
            v135(input.Position.X)
        end
    end)
    t2.value4.InputChanged:Connect(function(input)
        local v392 = u134

        if v392 then
            v392 = input.UserInputType == Enum.UserInputType.MouseMovement

            if not v392 then
                v392 = input.UserInputType == Enum.UserInputType.Touch
            end
        end

        if v392 then
            v135(input.Position.X)
        end
    end)
    t2.value4.InputEnded:Connect(function(input)
        local v394 = input.UserInputType == Enum.UserInputType.MouseButton1

        if not v394 then
            v394 = input.UserInputType == Enum.UserInputType.Touch
        end

        if v394 then
            u134 = false
        end
    end)

    return Frame7
end
local function v33(p20, p21, p22, p23, p24)
    local Frame11 = Instance.new("Frame")

    Frame11.Size = UDim2.new(1, 0, 0, 35)
    Frame11.BackgroundTransparency = 1
    Frame11.Parent = p20

    local TextLabel8 = Instance.new("TextLabel")

    TextLabel8.Size = UDim2.new(1, 0, 0, 15)
    TextLabel8.BackgroundTransparency = 1
    TextLabel8.Text = p21
    TextLabel8.TextColor3 = Color3.fromRGB(160, 160, 160)
    TextLabel8.Font = Enum.Font.SourceSans
    TextLabel8.TextSize = 13
    TextLabel8.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel8.Parent = Frame11

    local TextButton3 = Instance.new("TextButton")

    TextButton3.Size = UDim2.new(1, 0, 0, 16)
    TextButton3.Position = UDim2.new(0, 0, 0, 17)
    TextButton3.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    TextButton3.BorderColor3 = Color3.fromRGB(45, 45, 45)
    TextButton3.Text = ""
    TextButton3.Parent = Frame11

    local TextLabel9 = Instance.new("TextLabel")

    TextLabel9.Size = UDim2.new(1, -20, 1, 0)
    TextLabel9.Position = UDim2.new(0, 5, 0, 0)
    TextLabel9.BackgroundTransparency = 1
    TextLabel9.Text = p23 or p22[1]
    TextLabel9.TextColor3 = Color3.fromRGB(200, 200, 200)
    TextLabel9.Font = Enum.Font.SourceSans
    TextLabel9.TextSize = 12
    TextLabel9.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel9.Parent = TextButton3

    local TextLabel10 = Instance.new("TextLabel")

    TextLabel10.Size = UDim2.new(0, 15, 1, 0)
    TextLabel10.Position = UDim2.new(1, -15, 0, 0)
    TextLabel10.BackgroundTransparency = 1
    TextLabel10.Text = "▼"
    TextLabel10.TextColor3 = Color3.fromRGB(100, 100, 100)
    TextLabel10.Font = Enum.Font.SourceSans
    TextLabel10.TextSize = 10
    TextLabel10.Parent = TextButton3

    local u146 = p23 or p22[1]

    local function v147()
        local n1 = 1

        for i, v in ipairs(p22) do
            if v == u146 then
                n1 = i + 1
            end
        end

        if n1 > #p22 then
            n1 = 1
        end

        u146 = p22[n1]
        TextLabel9.Text = u146

        if p24 then
            p24(u146)
        end
    end

    local function v147x()
        local old = t2.value19:FindFirstChild("DropdownPopup")

        if old then
            old:Destroy()
        end

        local Popup = Instance.new("Frame")

        Popup.Name = "DropdownPopup"
        Popup.Size = UDim2.new(1, 0, 1, 0)
        Popup.BackgroundTransparency = 1
        Popup.ZIndex = 50
        Popup.Parent = t2.value19

        local Blocker = Instance.new("TextButton")

        Blocker.Size = UDim2.new(1, 0, 1, 0)
        Blocker.BackgroundTransparency = 1
        Blocker.Text = ""
        Blocker.ZIndex = 50
        Blocker.Parent = Popup
        Blocker.MouseButton1Click:Connect(function()
            Popup:Destroy()
        end)

        local rel = TextButton3.AbsolutePosition - t2.value19.AbsolutePosition
        local h = math.min(#p22 * 20 + 4, 150)
        local List = Instance.new("ScrollingFrame")

        List.Size = UDim2.new(0, math.max(TextButton3.AbsoluteSize.X, 120), 0, h)
        List.Position = UDim2.new(0, rel.X, 0, rel.Y + TextButton3.AbsoluteSize.Y)
        List.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        List.BorderColor3 = Color3.fromRGB(150, 50, 220)
        List.ScrollBarThickness = 4
        List.Active = true
        List.ZIndex = 51
        List.AutomaticCanvasSize = Enum.AutomaticSize.Y
        List.CanvasSize = UDim2.new()
        List.Parent = Popup

        local Layout = Instance.new("UIListLayout")

        Layout.SortOrder = Enum.SortOrder.LayoutOrder
        Layout.Parent = List

        for _, opt in ipairs(p22) do
            local Opt = Instance.new("TextButton")

            Opt.Size = UDim2.new(1, -4, 0, 20)
            Opt.BackgroundColor3 = opt == u146 and Color3.fromRGB(60, 25, 90) or Color3.fromRGB(20, 20, 20)
            Opt.BorderSizePixel = 0
            Opt.Text = tostring(opt)
            Opt.TextColor3 = Color3.fromRGB(220, 220, 220)
            Opt.Font = Enum.Font.SourceSans
            Opt.TextSize = 13
            Opt.ZIndex = 52
            Opt.Parent = List
            Opt.MouseButton1Click:Connect(function()
                u146 = opt
                TextLabel9.Text = u146
                Popup:Destroy()

                if p24 then
                    p24(u146)
                end
            end)
        end
    end

    TextButton3.MouseButton1Click:Connect(v147x)

    return Frame11
end
t2.binding = false
function t2.kcode(name)
    if not name then
        return nil
    end

    return Enum.KeyCode[name]
end
function t2.keybind(parent, label, callback)
    local Frame11 = Instance.new("Frame")

    Frame11.Size = UDim2.new(1, 0, 0, 35)
    Frame11.BackgroundTransparency = 1
    Frame11.Parent = parent

    local Label = Instance.new("TextLabel")

    Label.Size = UDim2.new(1, 0, 0, 15)
    Label.BackgroundTransparency = 1
    Label.Text = label
    Label.TextColor3 = Color3.fromRGB(160, 160, 160)
    Label.Font = Enum.Font.SourceSans
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame11

    local Button = Instance.new("TextButton")

    Button.Size = UDim2.new(1, 0, 0, 16)
    Button.Position = UDim2.new(0, 0, 0, 17)
    Button.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Button.BorderColor3 = Color3.fromRGB(45, 45, 45)
    Button.Text = "None"
    Button.TextColor3 = Color3.fromRGB(200, 200, 200)
    Button.Font = Enum.Font.SourceSans
    Button.TextSize = 12
    Button.Parent = Frame11

    local conn

    Button.MouseButton1Click:Connect(function()
        if t2.binding then
            return
        end

        t2.binding = true
        Button.Text = "Press a key..."
        Button.TextColor3 = Color3.fromRGB(200, 100, 255)
        conn = t2.value4.InputBegan:Connect(function(input)
            if input.UserInputType ~= Enum.UserInputType.Keyboard then
                return
            end

            conn:Disconnect()

            local name = input.KeyCode.Name

            if input.KeyCode == Enum.KeyCode.Escape or input.KeyCode == Enum.KeyCode.Backspace then
                name = nil
            end

            Button.Text = name or "None"
            Button.TextColor3 = Color3.fromRGB(200, 200, 200)
            callback(name or false)
            task.defer(function()
                t2.binding = false
            end)
        end)
    end)

    return Frame11
end
t2.value27 = t1.value1
function t1.value2(p25, p26)
    if not t2.value10.TRACER then
        return
    end

    if (p26 - p25).Magnitude < 1 then
        return
    end

    local Part = Instance.new("Part")

    Part.Name = "LaserHolder"
    Part.Size = Vector3.new(0.05, 0.05, 0.05)
    Part.Transparency = 1
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanTouch = false
    Part.CanQuery = false
    Part.Position = p25
    Part.Parent = workspace

    local Attachment = Instance.new("Attachment", Part)

    Attachment.WorldPosition = p25

    local Attachment2 = Instance.new("Attachment", Part)

    Attachment2.WorldPosition = p26

    local Beam = Instance.new("Beam")

    Beam.Attachment0 = Attachment
    Beam.Attachment1 = Attachment2
    Beam.FaceCamera = true
    Beam.LightEmission = 1
    Beam.LightInfluence = 0

    if t2.value10.TRACER_TYPE == "Red Laser" then
        Beam.Texture = "rbxassetid://6060542021"
        Beam.TextureMode = Enum.TextureMode.Wrap
        Beam.TextureLength = 3
        Beam.Width0 = 1.2
        Beam.Width1 = 1.2
        Beam.Color = ColorSequence.new(Color3.fromRGB(255, 10, 10))
    else
        Beam.Texture = "rbxassetid://10259604258"
        Beam.TextureMode = Enum.TextureMode.Wrap
        Beam.TextureLength = 2
        Beam.Width0 = 0.4
        Beam.Width1 = 0.4
        Beam.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(150, 50, 220)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
		})
    end

    Beam.Parent = Part
    t2.value6:AddItem(Part, t2.value10.TRACER_LIFE)
end
function t2.value28()
    local v148
    local FOV_RADIUS = t2.value10.FOV_RADIUS
    for _, player in pairs(t2.value2:GetPlayers()) do
        local v152 = player ~= t2.value8

        if v152 then
            v152 = player.Character and not t2.value27(player)
        end

        if v152 then
            local TEAM_CHECK = t2.value10.TEAM_CHECK

            if TEAM_CHECK then
                TEAM_CHECK = player.Team == t2.value8.Team
            end

            if not TEAM_CHECK then
                local v154 = player.Character:FindFirstChild(t2.value10.HIT_PART) or player.Character:FindFirstChild("Head")
                local Humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                local v156 = v154

                if v154 then
                    v156 = Humanoid and Humanoid.Health > 0
                end

                if v156 then
                    local v158, t5Result = t2.value9:WorldToViewportPoint(v154.Position)
                    if t5Result then
                        local vector2 = Vector2.new(t2.value9.ViewportSize.X / 2, t2.value9.ViewportSize.Y / 2)
                        local Magnitude = (Vector2.new(v158.X, v158.Y) - vector2).Magnitude

                        if Magnitude < FOV_RADIUS then
                            v148 = v154
                            FOV_RADIUS = Magnitude
                        end
                    end
                end
            end
        end
    end

    return v148
end
t2.value29 = t1.value2
if Drawing then
    t1.value2 = t2.value11

    local drawing = Drawing.new("Line")

    t1.value2.snapLine = drawing
    t1.value2 = t2.value11.snapLine
    t1.value2.Visible = false
    t1.value2 = t2.value11.snapLine

    local color3 = Color3.fromRGB(255, 0, 255)

    t1.value2.Color = color3
    t1.value2 = t2.value11.snapLine
    t1.value2.Thickness = 2
    t1.value2 = t2.value11.snapLine
    t1.value2.Transparency = 0.8
end
function t1.value2()
    local v167 = not t2.value11.snapLine
    if not v167 then
        v167 = not t2.value10.SILENT_AIM
    end
    if v167 then
        if t2.value11.snapLine then
            t2.value11.snapLine.Visible = false
        end

        return
    end
    if not t2.value10.SNAPLINE then
        if t2.value11.snapLine then
            t2.value11.snapLine.Visible = false
        end

        return
    end
    local v168 = t2.value28()
    if not v168 then
        if t2.value11.snapLine then
            t2.value11.snapLine.Visible = false
        end

        return
    end
    local v170, t6Result = t2.value9:WorldToViewportPoint(v168.Position)
    if not t6Result then
        if t2.value11.snapLine then
            t2.value11.snapLine.Visible = false
        end

        return
    end
    local vector2 = Vector2.new(t2.value9.ViewportSize.X / 2, t2.value9.ViewportSize.Y / 2)
    if (Vector2.new(v170.X, v170.Y) - vector2).Magnitude > t2.value10.FOV_RADIUS then
        if t2.value11.snapLine then
            t2.value11.snapLine.Visible = false
        end

        return
    end
    t2.value11.snapLine.From = vector2
    t2.value11.snapLine.To = Vector2.new(v170.X, v170.Y)
    t2.value11.snapLine.Visible = true
end
t2.value3.RenderStepped:Connect(t1.value2)
t1.value6 = ReplicatedStorage.FindFirstChild
local value4
t1.value3 = pcall
local _require = require
t1.value6 = t1.value6(ReplicatedStorage, "Blaster")
t1.value5 = t1.value6
if t1.value6 then
    local Utility = ReplicatedStorage.Blaster:FindFirstChild("Utility")

    t1.value6 = Utility

    if Utility then
        t1.value6 = ReplicatedStorage.Blaster.Utility:FindFirstChild("castRays")
    end

    t1.value5 = t1.value6
end
local v39, v40 = t1.value3(_require, t1.value5)
t1.value4 = v40
if v39 then
    v39 = t1.value4
end
t1.value3 = v39
if t1.value3 then
    value4 = t1.value4
end
if value4 and hookfunction then
    local u41
    function t1.value6(p27, p28, p29, p30)
        local v176 = p27 == t2.value8

        if v176 then
            v176 = t2.value10.SILENT_AIM

            if v176 then
                v176 = type(p29) == "table"
            end
        end

        if v176 then
            for k, _ in pairs(p29) do
                p29[k] = Vector3.new(0, 0, -1)
            end
        end

        local v179 = u41(p27, p28, p29, p30)

        if p27 == t2.value8 then
            local v180 = t2.value28()

            if v180 then
                if t2.value10.TRACER then
                    t2.value29(p28, v180.Position)
                end

                if t2.value10.HIT_CHANCE / 100 > math.random() then
                    if type(v179) == "table" then
                        if v179.position then
                            v179.position = v180.Position
                            v179.instance = v180

                            if v180.Parent then
                                v179.taggedHumanoid = v180.Parent:FindFirstChildOfClass("Humanoid")

                                return v179
                            end
                        else
                            local v181 = v179[1]

                            if v181 then
                                v181 = type(v179[1]) == "table"
                            end

                            if v181 then
                                v179[1].position = v180.Position
                                v179[1].instance = v180

                                if v180.Parent then
                                    v179[1].taggedHumanoid = v180.Parent:FindFirstChildOfClass("Humanoid")
                                end
                            end
                        end
                    end

                    return v179
                end
            end

            local TRACER = t2.value10.TRACER

            if TRACER then
                TRACER = type(v179) == "table"
            end

            if TRACER then
                if v179.position then
                    t2.value29(p28, v179.position)

                    return v179
                end

                local v183 = v179[1]

                if v183 then
                    v183 = v179[1].position
                end

                if v183 then
                    t2.value29(p28, v179[1].position)
                end
            end
        end

        return v179
    end
    u41 = hookfunction(value4, t1.value6)
end
function t1.value5()
    if t2.value11.isTeleporting then
        return
    end

    if not t2.value8.Character then
        return
    end

    local HumanoidRootPart = t2.value8.Character:FindFirstChild("HumanoidRootPart")

    if not HumanoidRootPart then
        return
    end

    local LookVector = t2.value9.CFrame.LookVector

    t2.value11.isTeleporting = true
    HumanoidRootPart.CFrame = CFrame.new(HumanoidRootPart.Position + LookVector * t2.value10.TP_DIST)
    task.wait(0.15)
    t2.value11.isTeleporting = false
end
t2.value30 = t1.value5
function t1.value5()
    if t2.value11.teleportButton then
        return
    end

    local ScreenGui2 = Instance.new("ScreenGui")

    ScreenGui2.Name = "LarpHub_Teleport"
    ScreenGui2.ResetOnSpawn = false
    ScreenGui2.IgnoreGuiInset = true
    ScreenGui2.DisplayOrder = 999
    ScreenGui2.Parent = t2.value1

    local TextButton4 = Instance.new("TextButton")

    TextButton4.Size = UDim2.fromOffset(45, 45)
    TextButton4.Position = UDim2.new(0.9, 0, 0.5, 0)
    TextButton4.AnchorPoint = Vector2.new(0.5, 0.5)
    TextButton4.BackgroundColor3 = Color3.fromRGB(100, 50, 200)
    TextButton4.Text = "TP"
    TextButton4.TextColor3 = Color3.new(1, 1, 1)
    TextButton4.Font = Enum.Font.GothamBold
    TextButton4.TextSize = 14
    TextButton4.ZIndex = 300
    TextButton4.Parent = ScreenGui2
    TextButton4.Visible = false

    local UICorner2 = Instance.new("UICorner")

    UICorner2.CornerRadius = UDim.new(1, 0)
    UICorner2.Parent = TextButton4

    local UIStroke = Instance.new("UIStroke")

    UIStroke.Color = Color3.fromRGB(150, 80, 255)
    UIStroke.Thickness = 2
    UIStroke.Parent = TextButton4
    TextButton4.InputBegan:Connect(function(input)
        if t2.value11.teleportButtonLocked then
            return
        end

        local v399 = input.UserInputType == Enum.UserInputType.MouseButton1

        if not v399 then
            v399 = input.UserInputType == Enum.UserInputType.Touch
        end

        if v399 then
            t2.value11.teleportButtonDragging = true
            t2.value11.teleportButtonDragStart = input.Position
            t2.value11.teleportButtonStartPos = TextButton4.Position
        end
    end)
    TextButton4.InputEnded:Connect(function()
        t2.value11.teleportButtonDragging = false
    end)
    t2.value4.InputChanged:Connect(function(input)
        local teleportButtonDragging = t2.value11.teleportButtonDragging

        if teleportButtonDragging then
            teleportButtonDragging = input.UserInputType == Enum.UserInputType.MouseMovement

            if not teleportButtonDragging then
                teleportButtonDragging = input.UserInputType == Enum.UserInputType.Touch
            end
        end

        if teleportButtonDragging then
            local v402 = input.Position - t2.value11.teleportButtonDragStart

            TextButton4.Position = UDim2.new(t2.value11.teleportButtonStartPos.X.Scale, t2.value11.teleportButtonStartPos.X.Offset + v402.X, t2.value11.teleportButtonStartPos.Y.Scale, t2.value11.teleportButtonStartPos.Y.Offset + v402.Y)
        end
    end)
    TextButton4.MouseButton1Click:Connect(function()
        if not t2.value11.teleportButtonDragging then
            t2.value30()
        end
    end)
    TextButton4.TouchTap:Connect(function()
        if not t2.value11.teleportButtonDragging then
            t2.value30()
        end
    end)
    t2.value11.teleportButton = TextButton4
end
function t2.value31()
    t2.value11.noclipParts = {}
    for v188, v189 in pairs(workspace:GetDescendants()) do

        if v189:IsA("BasePart") and v189.CanCollide == true then
            table.insert(t2.value11.noclipParts, v189)
            v189.CanCollide = false
        end
    end
    t2.value10.NO_CLIP = true
    if t2.value11.noclipButton then
        t2.value11.noclipButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        t2.value11.noclipButton.Text = "NC ON"
    end
end
function t2.value32()

    for v192, v193 in pairs(t2.value11.noclipParts) do

        local v194 = v193
        local v195 = v194

        if v195 then
            v195 = v194.Parent
        end

        if v195 then
            pcall(function()
                v194.CanCollide = true
            end)
        end
    end
    t2.value11.noclipParts = {}
    t2.value10.NO_CLIP = false
    if t2.value11.noclipButton then
        t2.value11.noclipButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        t2.value11.noclipButton.Text = "NC OFF"
    end
end
function t2.value33()
    if t2.value10.NO_CLIP then
        t2.value32()

        return
    end

    t2.value31()
end
t1.value5();
(function()
    if t2.value11.noclipButton then
        return
    end

    local ScreenGui3 = Instance.new("ScreenGui")

    ScreenGui3.Name = "NoclipButton"
    ScreenGui3.ResetOnSpawn = false
    ScreenGui3.IgnoreGuiInset = true
    ScreenGui3.DisplayOrder = 999
    ScreenGui3.Parent = t2.value1

    local TextButton5 = Instance.new("TextButton")

    TextButton5.Size = UDim2.fromOffset(80, 45)
    TextButton5.Position = UDim2.new(0.5, 0, 0.92, 0)
    TextButton5.AnchorPoint = Vector2.new(0.5, 0.5)

    local NO_CLIP = t2.value10.NO_CLIP

    if NO_CLIP then
        NO_CLIP = Color3.fromRGB(0, 200, 0)
    end

    if not NO_CLIP then
        NO_CLIP = Color3.fromRGB(200, 0, 0)
    end

    TextButton5.BackgroundColor3 = NO_CLIP
    TextButton5.Text = not t2.value10.NO_CLIP and "NC OFF" or "NC ON"
    TextButton5.TextColor3 = Color3.new(1, 1, 1)
    TextButton5.Font = Enum.Font.GothamBold
    TextButton5.TextSize = 16
    TextButton5.ZIndex = 300
    TextButton5.Parent = ScreenGui3
    TextButton5.Visible = false

    local UICorner3 = Instance.new("UICorner")

    UICorner3.CornerRadius = UDim.new(0, 10)
    UICorner3.Parent = TextButton5

    local UIStroke = Instance.new("UIStroke")

    UIStroke.Color = Color3.fromRGB(255, 255, 255)
    UIStroke.Thickness = 2
    UIStroke.Parent = TextButton5
    TextButton5.InputBegan:Connect(function(input)
        if t2.value11.noclipButtonLocked then
            return
        end

        local v404 = input.UserInputType == Enum.UserInputType.MouseButton1

        if not v404 then
            v404 = input.UserInputType == Enum.UserInputType.Touch
        end

        if v404 then
            t2.value11.noclipButtonDragging = true
            t2.value11.noclipButtonDragStart = input.Position
            t2.value11.noclipButtonStartPos = TextButton5.Position
        end
    end)
    TextButton5.InputEnded:Connect(function()
        t2.value11.noclipButtonDragging = false
    end)
    t2.value4.InputChanged:Connect(function(input)
        local noclipButtonDragging = t2.value11.noclipButtonDragging

        if noclipButtonDragging then
            noclipButtonDragging = input.UserInputType == Enum.UserInputType.MouseMovement

            if not noclipButtonDragging then
                noclipButtonDragging = input.UserInputType == Enum.UserInputType.Touch
            end
        end

        if noclipButtonDragging then
            local v407 = input.Position - t2.value11.noclipButtonDragStart

            TextButton5.Position = UDim2.new(t2.value11.noclipButtonStartPos.X.Scale, t2.value11.noclipButtonStartPos.X.Offset + v407.X, t2.value11.noclipButtonStartPos.Y.Scale, t2.value11.noclipButtonStartPos.Y.Offset + v407.Y)
        end
    end)
    TextButton5.MouseButton1Click:Connect(function()
        if not t2.value11.noclipButtonDragging then
            t2.value33()
        end
    end)
    TextButton5.TouchTap:Connect(function()
        if not t2.value11.noclipButtonDragging then
            t2.value33()
        end
    end)
    t2.value11.noclipButton = TextButton5
end)()
function t2.value34(p31)
    if not p31:IsA("Tool") then
        return
    end

    local GetAttributes = p31.GetAttributes

    for k in pairs(GetAttributes(p31)) do
        local v203 = k

        if string.lower(v203) == "rateoffire" then
            local v204 = p31.Name .. tostring(p31)

            if t2.value11.originalRateOfFire[v204] == nil then
                t2.value11.originalRateOfFire[v204] = p31:GetAttribute(v203)
            end

            local RAPID_FIRE = t2.value10.RAPID_FIRE

            if RAPID_FIRE then
                RAPID_FIRE = t2.value10.RAPID_VALUE
            end

            if not RAPID_FIRE then
                RAPID_FIRE = t2.value11.originalRateOfFire[v204]
            end

            p31:SetAttribute(v203, RAPID_FIRE)
        end
    end
end
local function reapplyRapid()
    local ch = t2.value8.Character
    if ch then
        for _, child in ipairs(ch:GetChildren()) do
            t2.value34(child)
        end
    end
end
local function v42(p32)
    if not p32 then
        return
    end

    for _, child in ipairs(p32:GetChildren()) do
        t2.value34(child)
    end

    p32.ChildAdded:Connect(function(child)
        task.wait(0.05)
        t2.value34(child)
    end)
end
t2.value8.CharacterAdded:Connect(function(character)
    task.wait(0.3)
    v42(character)

    if t2.value10.SPEED then
        local Humanoid = character:FindFirstChildOfClass("Humanoid")

        if Humanoid then
            Humanoid.WalkSpeed = t2.value10.SPEED_VAL
        end
    end

    if t2.value10.GIGA_JUMP then
        local Humanoid = character:FindFirstChildOfClass("Humanoid")

        if Humanoid then
            t2.value11.originalJumpPower = t2.value11.originalJumpPower or Humanoid.JumpPower
            Humanoid.JumpPower = t2.value10.GIGA_POWER
        end
    end

    if t2.value10.FLOAT and not t2.value11.floatPlatform then
        local Part = Instance.new("Part")

        Part.Size = Vector3.new(5, 0.5, 5)
        Part.Anchored = true
        Part.CanCollide = true
        Part.Transparency = 0.3
        Part.BrickColor = BrickColor.new("Bright blue")
        Part.Parent = workspace
        t2.value11.floatPlatform = Part
    end

    if t2.value10.NO_JUMP_CD then
        task.wait(0.5)

        local JumpCooldown = t2.value8.PlayerGui:FindFirstChild("JumpCooldown")

        if JumpCooldown then
            JumpCooldown.Disabled = true
        end
    end

    if t2.value10.NEON_GUNS then
        t2.value39(character)
    end

    if t2.value10.CUSTOM_HANDS then
        t2.value36()
    end
end)
pcall(v42, t2.value8.Character)
t2.value3.Stepped:Connect(function()
    local NO_CLIP = t2.value10.NO_CLIP

    if NO_CLIP then
        NO_CLIP = t2.value8.Character
    end

    if NO_CLIP then
        for _, descendant in ipairs(t2.value8.Character:GetDescendants()) do
            if descendant:IsA("BasePart") then
                descendant.CanCollide = false
            end
        end
    end

    local floatPlatform = t2.value11.floatPlatform

    if floatPlatform then
        floatPlatform = t2.value10.FLOAT

        if floatPlatform then
            floatPlatform = t2.value8.Character
        end
    end

    if floatPlatform then
        local HumanoidRootPart = t2.value8.Character:FindFirstChild("HumanoidRootPart")

        if HumanoidRootPart then
            t2.value11.floatPlatform.Position = Vector3.new(HumanoidRootPart.Position.X, HumanoidRootPart.Position.Y - 2.8, HumanoidRootPart.Position.Z)
        end
    end
end)
t2.value4.JumpRequest:Connect(function()
    if t2.value10.INF_JUMP then
        local Character = t2.value8.Character

        if Character then
            Character = t2.value8.Character:FindFirstChildOfClass("Humanoid")
        end

        if Character then
            Character:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)
local ScreenGui4 = Instance.new("ScreenGui")
ScreenGui4.Name = "LarpHubFOV"
ScreenGui4.IgnoreGuiInset = true
ScreenGui4.ResetOnSpawn = false
local _syn2 = syn
if _syn2 then
    _syn2 = syn.protect_gui
end
if _syn2 then
    syn.protect_gui(ScreenGui4)
elseif gethui then
    ScreenGui4.Parent = gethui()
else
    ScreenGui4.Parent = t2.value1
end
t2.value35 = Instance.new("Frame")
t2.value35.BackgroundTransparency = 1
t2.value35.BorderSizePixel = 0
t2.value35.Visible = true
t2.value35.ZIndex = 999
t2.value35.Parent = ScreenGui4
local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(150, 50, 220)
UIStroke.Thickness = 1.5
UIStroke.Transparency = 0.3
UIStroke.Parent = t2.value35
local UICorner4 = Instance.new("UICorner")
UICorner4.CornerRadius = UDim.new(1, 0)
UICorner4.Parent = t2.value35
t2.value3.RenderStepped:Connect(function()
    local vector2 = Vector2.new(t2.value9.ViewportSize.X / 2, t2.value9.ViewportSize.Y / 2)
    local FOV_RADIUS = t2.value10.FOV_RADIUS

    t2.value35.Position = UDim2.new(0, vector2.X - FOV_RADIUS, 0, vector2.Y - FOV_RADIUS)
    t2.value35.Size = UDim2.new(0, FOV_RADIUS * 2, 0, FOV_RADIUS * 2)
    t2.value35.Visible = t2.value10.SHOW_FOV
end)
t2.value4.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed or t2.binding then
        return
    end

    if input.KeyCode == t2.kcode(t2.value10.GIGA_KEY) and t2.value10.GIGA_JUMP then
        local Character = t2.value8.Character

        if Character then
            Character = t2.value8.Character:FindFirstChild("HumanoidRootPart")
        end

        if Character then
            Character.Velocity = Vector3.new(0, t2.value10.GIGA_POWER, 0)
        end
    end

    if input.KeyCode == t2.kcode(t2.value10.TP_KEY) then
        t2.value30()
    end

    if input.KeyCode == t2.kcode(t2.value10.FLOAT_KEY) then
        t2.value10.FLOAT = not t2.value10.FLOAT

        if t2.value10.FLOAT then
            if not t2.value11.floatPlatform then
                local Part = Instance.new("Part")

                Part.Size = Vector3.new(5, 0.5, 5)
                Part.Anchored = true
                Part.CanCollide = true
                Part.Transparency = 0.3
                Part.BrickColor = BrickColor.new("Bright blue")
                Part.Parent = workspace
                t2.value11.floatPlatform = Part
            end
        elseif t2.value11.floatPlatform then
            t2.value11.floatPlatform:Destroy()
            t2.value11.floatPlatform = nil
        end
    end

    if input.KeyCode == t2.kcode(t2.value10.NOCLIP_KEY) then
        t2.value33()
    end

    if input.KeyCode == t2.kcode(t2.value10.FURRY_DROP_KEY) then
        t2.value18()
    end
end)
local function v47()
    if t2.value11.skyObject then
        t2.value11.skyObject:Destroy()
        t2.value11.skyObject = nil
    end

    if t2.value10.SKYBOX then
        local Sky = Instance.new("Sky")
        local s1 = "rbxassetid://159454299"

        Sky.SkyboxBk = "rbxassetid://159454299"
        Sky.SkyboxDn = "rbxassetid://159454299"
        Sky.SkyboxFt = s1
        Sky.SkyboxLf = s1
        Sky.SkyboxRt = s1
        Sky.SkyboxUp = s1
        Sky.Parent = t2.value5
        t2.value11.skyObject = Sky
    end
end
function t2.value36()
    if t2.value11.weaponConn then
        t2.value11.weaponConn:Disconnect()
        t2.value11.weaponConn = nil
    end

    if not t2.value10.CUSTOM_HANDS then
        return
    end

    t2.value11.weaponConn = t2.value3.RenderStepped:Connect(function()
        local Character = t2.value8.Character

        if not Character then
            return
        end

        local Tool = Character:FindFirstChildOfClass("Tool")

        if not Tool then
            return
        end

        local ToolName = workspace:FindFirstChild(Tool.Name)

        if not ToolName then
            return
        end

        ToolName:PivotTo(t2.value9.CFrame * CFrame.new(t2.value10.HANDS_X, t2.value10.HANDS_Y, t2.value10.HANDS_Z))
    end)
end
pcall(function()
    pcall(function()
        if not getgc then
            return
        end

        for _, v in pairs(getgc(true)) do
            local v418 = type(v) == "table"

            if v418 then
                v418 = rawget(v, "canShoot")
            end

            if v418 then
                local canShoot = v.canShoot

                function v.canShoot(...)
                    if t2.value10.JUMP_SHOT then
                        return true
                    end

                    return canShoot(...)
                end
            end
        end
    end)
end)
t2.value37 = nil
t2.value38 = nil
function t2.value38(p33)
    local p33_2 = workspace:FindFirstChild(p33)

    if not p33_2 then
        return
    end

    local Blaster = p33_2:FindFirstChild("Blaster")

    if Blaster then
        Blaster = p33_2.Blaster:FindFirstChild("Body")
    end

    if not Blaster then
        return
    end

    local GetDescendants = Blaster.GetDescendants

    for _, v in ipairs(GetDescendants(Blaster)) do
        if v:IsA("BasePart") then
            v.Material = Enum.Material.Neon
            v.Color = Color3.fromRGB(60, 0, 120)
        end
    end
end
function t2.value39(p34)
    if t2.value37 then
        t2.value37:Disconnect()
        t2.value37 = nil
    end

    local GetChildren = p34.GetChildren

    for _, v in ipairs(GetChildren(p34)) do
        local v244 = v

        if v244:IsA("Tool") then
            if t2.value37 then
                t2.value37:Disconnect()
            end

            t2.value37 = t2.value3.RenderStepped:Connect(function()
                t2.value38(v244.Name)
            end)
        end
    end

    p34.ChildAdded:Connect(function(child)
        if child:IsA("Tool") then
            if t2.value37 then
                t2.value37:Disconnect()
            end

            t2.value37 = t2.value3.RenderStepped:Connect(function()
                t2.value38(child.Name)
            end)
        end
    end)
    p34.ChildRemoved:Connect(function(child)
        if child:IsA("Tool") and t2.value37 then
            t2.value37:Disconnect()
            t2.value37 = nil
        end
    end)
end
function t2.value40()
    t2.value10.NEON_GUNS = false

    if t2.value37 then
        t2.value37:Disconnect()
    end
end
if not Drawing then
    warn("Drawing не поддерживается, ESP не будет работать")
else
    local function v48(p36)
        local v246 = p36 == t2.value8

        if not v246 then
            v246 = t2.value11.espData[p36]
        end

        if v246 then
            return
        end

        local drawing = Drawing.new("Square")
        local drawing2 = Drawing.new("Text")
        local drawing3 = Drawing.new("Square")
        local drawing4 = Drawing.new("Text")
        local t7 = {
			Box = drawing,
			Name = drawing2,
			Health = drawing3,
			Dist = drawing4
		}

        t7.Box.Filled = false
        t7.Box.Thickness = 1.5
        t7.Box.Visible = false
        t7.Name.Size = 12
        t7.Name.Center = true
        t7.Name.Outline = true
        t7.Name.OutlineColor = Color3.fromRGB(0, 0, 0)
        t7.Name.Font = 3
        t7.Name.Visible = false
        t7.Health.Filled = true
        t7.Health.Thickness = 1
        t7.Health.Visible = false
        t7.Dist.Size = 10
        t7.Dist.Center = true
        t7.Dist.Outline = true
        t7.Dist.OutlineColor = Color3.fromRGB(0, 0, 0)
        t7.Dist.Font = 3
        t7.Dist.Visible = false
        t2.value11.espData[p36] = t7
    end

    for _, player in pairs(t2.value2:GetPlayers()) do
        v48(player)
    end

    t2.value2.PlayerAdded:Connect(v48)
    t2.value2.PlayerRemoving:Connect(function(player)
        local v253 = t2.value11.espData[player]

        if v253 then
            pcall(function()
                v253.Box:Remove()
                v253.Name:Remove()
                v253.Health:Remove()
                v253.Dist:Remove()
            end)
            t2.value11.espData[player] = nil
        end
    end)
    t2.value3.RenderStepped:Connect(function()
        if not t2.value10.ESP then
            for _, v in pairs(t2.value11.espData) do
                v.Box.Visible = false
                v.Name.Visible = false
                v.Health.Visible = false
                v.Dist.Visible = false
            end

            return
        end

        t2.value11.rainbowOffset = (t2.value11.rainbowOffset + 0.005) % 1

        local color3 = Color3.fromHSV(t2.value11.rainbowOffset, 1, 1)

        for k, v in pairs(t2.value11.espData) do
            local v259 = k
            local Character = v259.Character

            if not Character or not Character.Parent then
                v.Box.Visible = false
                v.Name.Visible = false
                v.Health.Visible = false
                v.Dist.Visible = false
            else
                local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
                local Head = Character:FindFirstChild("Head")

                if not HumanoidRootPart or not Head then
                    v.Box.Visible = false
                    v.Name.Visible = false
                    v.Health.Visible = false
                    v.Dist.Visible = false
                else
                    local v263 = Head.Position + Vector3.new(0, Head.Size.Y / 2, 0)
                    local v264 = HumanoidRootPart.Position - Vector3.new(0, HumanoidRootPart.Size.Y / 2, 0)
                    local v265 = HumanoidRootPart.CFrame:VectorToWorldSpace(Vector3.new(HumanoidRootPart.Size.X / 2, 0, 0))
                    local HumanoidRootPartCFrame = HumanoidRootPart.CFrame
                    local t8 = { Vector3.new(-HumanoidRootPart.Size.X / 2, 0, 0) }
                    local v268 = HumanoidRootPartCFrame:VectorToWorldSpace(v3(t8))
                    local v269 = HumanoidRootPart.Position + v265
                    local v270 = HumanoidRootPart.Position + v268
                    local v271, v272 = t2.value9:WorldToViewportPoint(v263)
                    local v273, v274 = t2.value9:WorldToViewportPoint(v264)
                    local v275, v276 = t2.value9:WorldToViewportPoint(v269)
                    local v277, v278 = t2.value9:WorldToViewportPoint(v270)

                    if not v272 then
                        v272 = v274 or (v276 or v278)
                    end

                    if not v272 then
                        v.Box.Visible = false
                        v.Name.Visible = false
                        v.Health.Visible = false
                        v.Dist.Visible = false
                    else
                        local v279 = math.abs(v271.Y - v273.Y)
                        local v280 = math.abs(v275.X - v277.X)

                        if v279 < 5 then
                            v279 = 5
                        end

                        if v280 < 5 then
                            v280 = 5
                        end

                        local v281 = (v277.X + v275.X) / 2
                        local Y = v271.Y
                        local Y2 = v273.Y
                        local value9 = t2.value9
                        local v285 = (Y + Y2) / 2
                        local Magnitude = (value9.CFrame.Position - HumanoidRootPart.Position).Magnitude

                        if t2.value10.ESP_BOX then
                            v.Box.Visible = true
                            v.Box.Size = Vector2.new(v280, v279)

                            local Box = v.Box
                            local new = Vector2.new
                            local v289 = v285 - v279 / 2

                            Box.Position = new(v281 - v280 / 2, v289)
                            v.Box.Color = color3
                        else
                            v.Box.Visible = false
                        end

                        if t2.value10.ESP_NAME then
                            v.Name.Visible = true
                            v.Name.Text = v259.Name
                            v.Name.Position = Vector2.new(v281, v271.Y - 15)
                            v.Name.Color = color3
                        else
                            v.Name.Visible = false
                        end

                        if t2.value10.ESP_HEALTH then
                            local Humanoid = Character:FindFirstChildOfClass("Humanoid")

                            if Humanoid and Humanoid.MaxHealth > 0 then
                                local v291 = math.clamp(Humanoid.Health / Humanoid.MaxHealth, 0, 1)

                                v.Health.Visible = true
                                v.Health.Size = Vector2.new(2, v279 * v291)
                                v.Health.Position = Vector2.new(v281 - v280 / 2 - 4, v285 + v279 / 2 - v279 * v291)
                                v.Health.Color = Color3.fromRGB(255 * (1 - v291), 255 * v291, 0)
                            else
                                v.Health.Visible = false
                            end
                        else
                            v.Health.Visible = false
                        end

                        if t2.value10.ESP_DIST then
                            v.Dist.Visible = true
                            v.Dist.Text = math.floor(Magnitude) .. "m"
                            v.Dist.Position = Vector2.new(v281, v273.Y + 15)
                            v.Dist.Color = color3
                        else
                            v.Dist.Visible = false
                        end
                    end
                end
            end
        end
    end)
end
t2.value43 = nil
local cols = t2.value26.Combat.cols
local cols2 = t2.value26.Visuals.cols
local cols3 = t2.value26.Misc.cols
local _ = t2.value26.Settings.cols
local v55 = v30(cols[1], "Silent Aim", 240)
v29(v55, "Enabled", false, function(p37)
    t2.value10.SILENT_AIM = p37
end)
v29(v55, "Team Check", false, function(p38)
    t2.value10.TEAM_CHECK = p38
end)
v29(v55, "Show FOV", false, function(p39)
    t2.value10.SHOW_FOV = p39
end)
v29(v55, "Snapline", false, function(p40)
    t2.value10.SNAPLINE = p40
end)
v32(v55, "Hit Chance", 0, 100, 95, function(p41)
    t2.value10.HIT_CHANCE = p41
end)
v32(v55, "FOV Radius", 1, 500, 200, function(p42)
    t2.value10.FOV_RADIUS = p42
end)
v33(v55, "Hit Part", {
	"Head",
	"Torso",
	"HumanoidRootPart",
	"Random"
}, "Head", function(p43)
    t2.value10.HIT_PART = p43
end)
local v56 = v30(cols[2], "Rapid Fire", 80)
v29(v56, "Enabled", false, function(p44)
    t2.value10.RAPID_FIRE = p44
    reapplyRapid()
end)
v32(v56, "Rate of Fire", 1, 100000, 1000, function(p45)
    t2.value10.RAPID_VALUE = p45
    if t2.value10.RAPID_FIRE then
        reapplyRapid()
    end
end)
local v57 = v30(cols[2], "Bullet Tracer", 90)
v29(v57, "Enabled", false, function(p46)
    t2.value10.TRACER = p46
end)
v32(v57, "Lifetime", 1, 10, 3, function(p47)
    t2.value10.TRACER_LIFE = p47
end)
v33(v57, "Type", {
	"Red Laser",
	"Neon Linia Bruh"
}, "Red Laser", function(p48)
    t2.value10.TRACER_TYPE = p48
end)
local v58 = v30(cols[3], "Hit Sound", 120)
v29(v58, "Enabled", false, function(p49)
    t2.value10.HIT_SOUND = p49

    if p49 then
        if not t2.value11.hitSoundObj then
            t2.value11.hitSoundObj = Instance.new("Sound")
            t2.value11.hitSoundObj.SoundId = "rbxassetid://" .. t2.value10.HIT_SOUND_ID
            t2.value11.hitSoundObj.Volume = t2.value10.HIT_SOUND_VOL
            t2.value11.hitSoundObj.Parent = t2.value7
        end

        if not t2.value11.hitSoundHook and hookmetamethod then
            t2.value11.hitSoundHook = hookmetamethod(game, "__namecall", function(p50, ...)
                local v423 = getnamecallmethod and getnamecallmethod():lower() or ""

                if v423 == "fireserver" or v423 == "invokeserver" then
                    local v424 = p50.Name == "BulletHit"

                    if not v424 then
                        v424 = p50.Name == "HitShot"
                    end

                    if v424 then
                        task.spawn(function()
                            local hitSoundObj = t2.value11.hitSoundObj

                            if hitSoundObj then
                                hitSoundObj = t2.value10.HIT_SOUND
                            end

                            if hitSoundObj then
                                t2.value11.hitSoundObj:Play()
                            end
                        end)
                    end
                end

                return t2.value11.hitSoundHook(p50, ...)
            end)
        end
    end
end)
v32(v58, "Volume", 0, 10, 1, function(p51)
    t2.value10.HIT_SOUND_VOL = p51

    if t2.value11.hitSoundObj then
        t2.value11.hitSoundObj.Volume = p51
    end
end)
v33(v58, "Sound ID", {
	"121566025787365",
	"2375539277",
	"9120255535"
}, "121566025787365", function(p52)
    t2.value10.HIT_SOUND_ID = p52

    if t2.value11.hitSoundObj then
        t2.value11.hitSoundObj.SoundId = "rbxassetid://" .. p52
    end
end)
local v59 = v30(cols2[1], "ESP", 150)
v29(v59, "Enabled", false, function(p53)
    t2.value10.ESP = p53
end)
v29(v59, "Boxes", false, function(p54)
    t2.value10.ESP_BOX = p54
end)
v29(v59, "Names", false, function(p55)
    t2.value10.ESP_NAME = p55
end)
v29(v59, "Health", false, function(p56)
    t2.value10.ESP_HEALTH = p56
end)
v29(v59, "Distance", false, function(p57)
    t2.value10.ESP_DIST = p57
end)
local v60 = v30(cols2[2], "Misc Visuals", 110)
v32(v60, "FOV Changer", 60, 120, 70, function(p58)
    t2.value9.FieldOfView = p58
end)
v29(v60, "Skybox", false, function(p59)
    t2.value10.SKYBOX = p59
    v47()
end)
v29(v60, "Fullbright", false, function(p71)
    t2.value10.FULLBRIGHT = p71

    if p71 then
        t2.value5.Brightness = 3
        t2.value5.ClockTime = 14
        t2.value5.FogEnd = 1000000000
        t2.value5.GlobalShadows = false

        return
    end

    t2.value5.Brightness = 1
    t2.value5.GlobalShadows = true
    t2.value5.FogEnd = 100000
end)
local v61 = v30(cols2[3], "Custom Hands", 150)
v29(v61, "Enabled", false, function(p60)
    t2.value10.CUSTOM_HANDS = p60
    t2.value36()
end)
v32(v61, "X", -20, 20, 5, function(p61)
    t2.value10.HANDS_X = p61

    if t2.value10.CUSTOM_HANDS then
        t2.value36()
    end
end)
v32(v61, "Y", -20, 20, -2, function(p62)
    t2.value10.HANDS_Y = p62

    if t2.value10.CUSTOM_HANDS then
        t2.value36()
    end
end)
v32(v61, "Z", -20, 20, -8, function(p63)
    t2.value10.HANDS_Z = p63

    if t2.value10.CUSTOM_HANDS then
        t2.value36()
    end
end)
local v62 = v30(cols3[1], "Movement", 280)
v29(v62, "Speed Hack", false, function(p64)
    t2.value10.SPEED = p64

    local Character = t2.value8.Character

    if Character then
        Character = t2.value8.Character:FindFirstChildOfClass("Humanoid")
    end

    if Character then
        if p64 then
            p64 = t2.value10.SPEED_VAL
        end

        Character.WalkSpeed = p64 or 16
    end
end)
v32(v62, "Speed Value", 16, 500, 50, function(p65)
    t2.value10.SPEED_VAL = p65

    if t2.value10.SPEED then
        local Character = t2.value8.Character

        if Character then
            Character = t2.value8.Character:FindFirstChildOfClass("Humanoid")
        end

        if Character then
            Character.WalkSpeed = p65
        end
    end
end)
v29(v62, "Infinite Jump", false, function(p66)
    t2.value10.INF_JUMP = p66
end)
v29(v62, "No Clip", false, function(p67)
    if p67 then
        t2.value31()
    else
        t2.value32()
    end

    if t2.value11.noclipButton then
        local noclipButton = t2.value11.noclipButton
        local v325 = p67

        if p67 then
            v325 = Color3.fromRGB(0, 200, 0)
        end

        if not v325 then
            v325 = Color3.fromRGB(200, 0, 0)
        end

        noclipButton.BackgroundColor3 = v325
        t2.value11.noclipButton.Text = not p67 and "NC OFF" or "NC ON"
    end
end)
t2.keybind(v62, "Noclip Keybind", function(p68)
    t2.value10.NOCLIP_KEY = p68
end)
v29(v62, "Show Noclip Button", false, function(p69)
    if t2.value11.noclipButton then
        t2.value11.noclipButton.Visible = p69
    end
end)
v29(v62, "Lock Noclip Button", false, function(p70)
    t2.value11.noclipButtonLocked = p70
end)
v29(v62, "Jump Shot", false, function(p72)
    t2.value10.JUMP_SHOT = p72
end)
v29(v62, "No Jump CD", false, function(p73)
    t2.value10.NO_JUMP_CD = p73

    local JumpCooldown = t2.value8.PlayerGui:FindFirstChild("JumpCooldown")

    if JumpCooldown then
        JumpCooldown.Disabled = p73
    end
end)
v29(v62, "Furry Drop", false, function(p75)
    t2.value10.FURRY_DROP = p75

    if t2.value11.furryDropButton then
        t2.value11.furryDropButton.Visible = p75
    end

    local v335 = not p75

    if v335 then
        v335 = t2.value11.furryDropActive
    end

    if v335 then
        t2.value17()
    end

    t2.value12("Furry Drop " .. (p75 and "ON" or "OFF"))
end)
v32(v62, "Drop Distance", 1, 100, 10, function(p76)
    t2.value10.FURRY_DROP_DIST = p76
end)
t2.keybind(v62, "Furry Keybind", function(p77)
    t2.value10.FURRY_DROP_KEY = p77
end)
v29(v62, "Show Furry Button", false, function(p78)
    if t2.value11.furryDropButton then
        t2.value11.furryDropButton.Visible = p78
    end
end)
v29(v62, "Lock Furry Button", false, function(p79)
    t2.value11.furryDropButtonLocked = p79
end)
local v63 = v30(cols3[2], "Giga Jump", 90)
v29(v63, "Enabled", false, function(p80)
    t2.value10.GIGA_JUMP = p80

    local Character = t2.value8.Character

    if Character then
        local Humanoid = Character:FindFirstChildOfClass("Humanoid")

        if Humanoid then
            if p80 then
                t2.value11.originalJumpPower = t2.value11.originalJumpPower or Humanoid.JumpPower
                Humanoid.JumpPower = t2.value10.GIGA_POWER

                return
            end

            if t2.value11.originalJumpPower then
                Humanoid.JumpPower = t2.value11.originalJumpPower
            end
        end
    end
end)
v32(v63, "Power", 30, 500, 50, function(p81)
    t2.value10.GIGA_POWER = p81

    if t2.value10.GIGA_JUMP then
        local Character = t2.value8.Character

        if Character then
            Character = t2.value8.Character:FindFirstChildOfClass("Humanoid")
        end

        if Character then
            Character.JumpPower = p81
        end
    end
end)
t2.keybind(v63, "Keybind", function(p82)
    t2.value10.GIGA_KEY = p82
end)
local v64 = v30(cols3[2], "Float", 80)
v29(v64, "Enabled", false, function(p83)
    t2.value10.FLOAT = p83

    if p83 then
        if not t2.value11.floatPlatform then
            local Part = Instance.new("Part")

            Part.Size = Vector3.new(5, 0.5, 5)
            Part.Anchored = true
            Part.CanCollide = true
            Part.Transparency = 0.3
            Part.BrickColor = BrickColor.new("Bright blue")
            Part.Parent = workspace
            t2.value11.floatPlatform = Part

            return
        end
    elseif t2.value11.floatPlatform then
        t2.value11.floatPlatform:Destroy()
        t2.value11.floatPlatform = nil
    end
end)
v32(v64, "Speed", 1, 20, 5, function(p84)
    t2.value10.FLOAT_SPEED = p84
end)
t2.keybind(v64, "Keybind", function(p85)
    t2.value10.FLOAT_KEY = p85
end)
v29(v30(cols3[3], "Neon Guns", 60), "Enabled", false, function(p86)
    if p86 then
        t2.value10.NEON_GUNS = true

        if t2.value8.Character then
            t2.value39(t2.value8.Character)

            return
        end
    else
        t2.value40()
    end
end)
local v65 = v30(cols3[3], "Teleport", 120)
v32(v65, "Distance", 1, 500, 50, function(p88)
    t2.value10.TP_DIST = p88
end)
t2.keybind(v65, "Keybind", function(p89)
    t2.value10.TP_KEY = p89
end)
v29(v65, "Show Teleport Button", false, function(p90)
    if t2.value11.teleportButton then
        t2.value11.teleportButton.Visible = p90
    end
end)
v29(v65, "Lock Teleport Button", false, function(p91)
    t2.value11.teleportButtonLocked = p91
end)
local cols4 = t2.value26.Settings.cols
local v67 = cols4[1]
local _ = cols4[3]
local v70 = v30(v67, "Whitelist", 180)
v29(v70, "Enabled", false, function(p92)
    t2.value10.WHITELIST = p92

    if t2.value43 then
        t2.value43()
    end
end)
t2.value44 = Instance.new("ScrollingFrame")
t2.value44.Size = UDim2.new(1, 0, 0, 120)
t2.value44.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
t2.value44.BorderColor3 = Color3.fromRGB(40, 40, 40)
t2.value44.ScrollBarThickness = 3
t2.value44.Active = true
t2.value44.ScrollBarImageColor3 = Color3.fromRGB(150, 50, 220)
t2.value44.AutomaticCanvasSize = Enum.AutomaticSize.Y
t2.value44.CanvasSize = UDim2.new()
t2.value44.Parent = v70
local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 3)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Parent = t2.value44
function t2.value43()

    for v359, v360 in ipairs(t2.value44:GetChildren()) do

        if v360:IsA("TextButton") then
            v360:Destroy()
        end
    end
    for _, player in ipairs(t2.value2:GetPlayers()) do
        local v363 = player

        if not (v363 == t2.value8) then
            local TextButton6 = Instance.new("TextButton")

            TextButton6.Size = UDim2.new(1, -6, 0, 20)

            local v365 = t2.value11.whitelist[v363.Name]

            if v365 then
                v365 = Color3.fromRGB(90, 30, 160)
            end

            if not v365 then
                v365 = Color3.fromRGB(20, 20, 20)
            end

            TextButton6.BackgroundColor3 = v365
            TextButton6.BorderSizePixel = 0
            TextButton6.Text = v363.Name .. (not t2.value11.whitelist[v363.Name] and "" or " ✓")
            TextButton6.TextColor3 = Color3.fromRGB(200, 200, 200)
            TextButton6.Font = Enum.Font.SourceSans
            TextButton6.TextSize = 11
            TextButton6.TextXAlignment = Enum.TextXAlignment.Left
            TextButton6.Parent = t2.value44

            local UICorner5 = Instance.new("UICorner")

            UICorner5.CornerRadius = UDim.new(0, 3)
            UICorner5.Parent = TextButton6
            TextButton6.MouseButton1Click:Connect(function()
                t2.value11.whitelist[v363.Name] = not t2.value11.whitelist[v363.Name] or nil
                t2.value43()
            end)
        end
    end
end
t2.value2.PlayerAdded:Connect(t2.value43)
t2.value2.PlayerRemoving:Connect(t2.value43)
t2.value43()
if t2.value10.FURRY_DROP and t2.value11.furryDropButton then
    t2.value11.furryDropButton.Visible = true
end
t2.value12("LarpHub loaded | Version 2.6.6")
print("LarpHub loaded | Version 2.6.6")
