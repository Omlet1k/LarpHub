local Players            = game:GetService("Players")
local TweenService       = game:GetService("TweenService")
local UserInputService   = game:GetService("UserInputService")
local MarketplaceService = game:GetService("MarketplaceService")

local LocalPlayer = Players.LocalPlayer

local WINDOW_TITLE = "LarpLoader"
local VERSION      = "1.4.0"

local SHOW_NOTIFICATIONS = true
local SHOW_LOADED_BADGE  = true
local DEBUG              = true

local MIN_SIZE = Vector2.new(340, 280)
local MAX_SIZE = Vector2.new(760, 560)

local THEME = {
    Background   = Color3.fromRGB(21, 13, 38),
    Surface      = Color3.fromRGB(32, 21, 58),
    SurfaceLight = Color3.fromRGB(45, 30, 80),
    Stroke       = Color3.fromRGB(116, 70, 205),
    Accent       = Color3.fromRGB(158, 111, 255),
    AccentSoft   = Color3.fromRGB(199, 172, 255),
    Text         = Color3.fromRGB(241, 237, 251),
    TextMuted    = Color3.fromRGB(151, 140, 182),
    Warning      = Color3.fromRGB(255, 176, 84),
    Danger       = Color3.fromRGB(255, 91, 110),
    Success      = Color3.fromRGB(96, 220, 130),
}

local GAMES = {
    ["NFT Battle"]                  = { placeIds = { 76603753346534 },  url = "https://raw.githubusercontent.com/Omlet1k/LarpHub/refs/heads/main/NFT%20Battle.lua" },
    ["rost alpha"]                  = { placeIds = { 13769775130 },     url = "https://raw.githubusercontent.com/Omlet1k/LarpHub/refs/heads/main/rost%20alpha.lua" },
    ["Rusted"]                      = { placeIds = { 18944968230 },     url = "https://raw.githubusercontent.com/Omlet1k/LarpHub/refs/heads/main/Rusted.lua" },
    ["Survival LAVA for Brainrots"] = { placeIds = { 119987266683883 }, url = "https://raw.githubusercontent.com/Omlet1k/LarpHub/refs/heads/main/Survival%20LAVA%20for%20Brainrots.lua" },
    ["Murder Mystery 2"]            = { placeIds = { 142823291, 335132309, 636649648 }, url = "https://raw.githubusercontent.com/Omlet1k/LarpHub/refs/heads/main/Murder%20Mystery%202.lua" },
    ["Blade Ball"]                  = { placeIds = { 13772394625, 16281300371 },        url = "https://raw.githubusercontent.com/Omlet1k/LarpHub/refs/heads/main/Blade%20Ball.lua" },
    ["BloxStrike"]                  = { placeIds = { 114234929420007, 108194354348181, 135434213652028 }, url = "https://raw.githubusercontent.com/Omlet1k/LarpHub/refs/heads/main/BloxStrike.lua" },
}

local function destroyOld(container)
    if not container then
        return
    end
    for _, child in ipairs(container:GetChildren()) do
        if child.Name == WINDOW_TITLE then
            child:Destroy()
        end
    end
end

pcall(function()
    if getgenv and getgenv().LarpLoaderGUI then
        getgenv().LarpLoaderGUI:Destroy()
    end
end)
pcall(function()
    if type(gethui) == "function" then
        destroyOld(gethui())
    end
end)
pcall(function()
    destroyOld(game:GetService("CoreGui"))
end)
pcall(function()
    if LocalPlayer then
        destroyOld(LocalPlayer:FindFirstChild("PlayerGui"))
    end
end)

local function create(className, props)
    local inst = Instance.new(className)
    for prop, value in pairs(props) do
        if prop ~= "Parent" then
            inst[prop] = value
        end
    end
    inst.Parent = props.Parent
    return inst
end

local function resolveGuiParent()
    if type(gethui) == "function" then
        local ok, ui = pcall(gethui)
        if ok and typeof(ui) == "Instance" then
            return ui
        end
    end
    return game:GetService("CoreGui")
end

local function trim(value)
    local s = type(value) == "string" and value or ""
    s = s:gsub("^%s+", "")
    s = s:gsub("%s+$", "")
    return s
end

local function notify(text, kind, duration)
    if not SHOW_NOTIFICATIONS then
        return
    end
    kind     = kind or "info"
    duration = duration or 4

    local color = THEME.Accent
    if kind == "warn" then
        color = THEME.Warning
    elseif kind == "error" then
        color = THEME.Danger
    elseif kind == "success" then
        color = THEME.Success
    end

    local gui = create("ScreenGui", {
        Name           = WINDOW_TITLE,
        ResetOnSpawn   = false,
        IgnoreGuiInset = true,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder   = 999999,
    })

    local holder = create("Frame", {
        AnchorPoint      = Vector2.new(0.5, 0),
        Position         = UDim2.new(0.5, 0, 0, -70),
        Size             = UDim2.fromOffset(380, 46),
        BackgroundColor3 = THEME.Surface,
        BorderSizePixel  = 0,
        Parent           = gui,
    })
    create("UICorner", { CornerRadius = UDim.new(0, 10), Parent = holder })
    create("UIStroke", { Color = THEME.Stroke, Thickness = 1, Transparency = 0.3, Parent = holder })

    local bar = create("Frame", {
        Size             = UDim2.new(0, 4, 1, -16),
        Position         = UDim2.new(0, 12, 0, 8),
        BackgroundColor3 = color,
        BorderSizePixel  = 0,
        Parent           = holder,
    })
    create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = bar })

    create("TextLabel", {
        BackgroundTransparency = 1,
        Position               = UDim2.new(0, 28, 0, 0),
        Size                   = UDim2.new(1, -40, 1, 0),
        Font                   = Enum.Font.GothamMedium,
        Text                   = text,
        TextSize               = 12,
        TextColor3             = THEME.Text,
        TextXAlignment         = Enum.TextXAlignment.Left,
        TextYAlignment         = Enum.TextYAlignment.Center,
        TextWrapped            = true,
        Parent                 = holder,
    })

    if type(syn) == "table" and type(syn.protect_gui) == "function" then
        pcall(syn.protect_gui, gui)
    end
    local ok = pcall(function()
        gui.Parent = resolveGuiParent()
    end)
    if not ok and LocalPlayer then
        gui.Parent = LocalPlayer:FindFirstChild("PlayerGui")
            or LocalPlayer:WaitForChild("PlayerGui", 5)
    end

    TweenService:Create(holder, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, 0, 0, 16),
    }):Play()

    task.delay(duration, function()
        local out = TweenService:Create(holder, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
            Position = UDim2.new(0.5, 0, 0, -70),
        })
        out:Play()
        out.Completed:Wait()
        gui:Destroy()
    end)
end

local function showLoadedBadge(gameName)
    if not SHOW_LOADED_BADGE then
        return
    end

    local gui = create("ScreenGui", {
        Name           = WINDOW_TITLE,
        ResetOnSpawn   = false,
        IgnoreGuiInset = true,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder   = 999999,
    })

    local holder = create("Frame", {
        Name             = "LoadedBadge",
        AnchorPoint      = Vector2.new(1, 1),
        Position         = UDim2.new(1, 32, 1, 32),
        Size             = UDim2.fromOffset(264, 56),
        BackgroundColor3 = THEME.Surface,
        BorderSizePixel  = 0,
        Parent           = gui,
    })
    create("UICorner", { CornerRadius = UDim.new(0, 10), Parent = holder })
    create("UIStroke", { Color = THEME.Stroke, Thickness = 1, Transparency = 0.3, Parent = holder })

    local dot = create("Frame", {
        Size             = UDim2.fromOffset(10, 10),
        Position         = UDim2.new(0, 18, 0, 12),
        BackgroundColor3 = THEME.Success,
        BorderSizePixel  = 0,
        Parent           = holder,
    })
    create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = dot })

    create("TextLabel", {
        Name                   = "LoadedTitle",
        BackgroundTransparency = 1,
        Position               = UDim2.new(0, 36, 0, 9),
        Size                   = UDim2.new(1, -48, 0, 16),
        Font                   = Enum.Font.GothamBold,
        Text                   = "Script loaded",
        TextSize               = 12,
        TextColor3             = THEME.Success,
        TextXAlignment         = Enum.TextXAlignment.Left,
        Parent                 = holder,
    })

    create("TextLabel", {
        Name                   = "LoadedGame",
        BackgroundTransparency = 1,
        Position               = UDim2.new(0, 36, 0, 28),
        Size                   = UDim2.new(1, -48, 0, 18),
        Font                   = Enum.Font.GothamMedium,
        Text                   = gameName or "Unknown Game",
        TextSize               = 13,
        TextColor3             = THEME.Text,
        TextXAlignment         = Enum.TextXAlignment.Left,
        TextTruncate           = Enum.TextTruncate.AtEnd,
        Parent                 = holder,
    })

    if type(syn) == "table" and type(syn.protect_gui) == "function" then
        pcall(syn.protect_gui, gui)
    end
    local ok = pcall(function()
        gui.Parent = resolveGuiParent()
    end)
    if not ok and LocalPlayer then
        gui.Parent = LocalPlayer:FindFirstChild("PlayerGui")
            or LocalPlayer:WaitForChild("PlayerGui", 5)
    end

    TweenService:Create(holder, TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Position = UDim2.new(1, -18, 1, -18),
    }):Play()

    task.delay(6, function()
        local out = TweenService:Create(holder, TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
            Position = UDim2.new(1, 32, 1, 32),
        })
        out:Play()
        out.Completed:Wait()
        gui:Destroy()
    end)
end

local function runScriptCode(source, badgeName)
    if type(loadstring) ~= "function" then
        warn("[LarpLoader] loadstring is unavailable in this environment.")
        notify("loadstring is not supported by this executor", "error", 6)
        return false
    end

    local okRun, runErr = pcall(function()
        loadstring(source)()
    end)
    if not okRun then
        warn("[LarpLoader] Failed to execute script: " .. tostring(runErr))
        notify("Script failed to load - check the F9 console", "error", 6)
        return false
    end

    print(("[LarpLoader] '%s' - script loaded successfully."):format(badgeName))
    task.spawn(showLoadedBadge, badgeName)
    notify("Script loaded successfully", "success", 4)
    return true
end

local function runScriptFromUrl(url, badgeName)
    url = trim(url)

    local hasHttpGet = false
    pcall(function()
        hasHttpGet = type(game.HttpGet) == "function"
    end)
    if not hasHttpGet then
        warn("[LarpLoader] game:HttpGet is unavailable in this environment (executor does not support it).")
        notify("HttpGet is not supported by this executor", "error", 6)
        return false
    end

    local source
    local okDownload, downloadErr = pcall(function()
        source = game:HttpGet(url)
    end)
    if not okDownload then
        warn("[LarpLoader] Failed to download script: " .. tostring(downloadErr))
        notify("Failed to download script - check the F9 console", "error", 6)
        return false
    end

    return runScriptCode(source, badgeName)
end

local function runManualInput(rawInput)
    local input = trim(rawInput)
    if input == "" then
        notify("Paste a script URL (or script code) first", "warn", 5)
        return false
    end

    if input:match("^www%.") then
        input = "https://" .. input
    end

    if input:match("^https?://%S") then
        return runScriptFromUrl(input, "Manual script")
    end

    return runScriptCode(input, "Manual script")
end

local function makeDraggable(handle, target, bind)
    local dragging, dragStart, startPos, dragInput

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging  = true
            dragStart = input.Position
            startPos  = target.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    bind(UserInputService.InputChanged, function(input)
        if dragging and input == dragInput then
            local delta = input.Position - dragStart
            target.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
end

local function makeResizable(handle, win, dirX, dirY, bind)
    local active, startInput, startSize, startAbs, moveInput

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            active     = true
            startInput = input.Position
            startSize  = win.Size
            startAbs   = win.AbsolutePosition
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    active = false
                end
            end)
        end
    end)

    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch then
            moveInput = input
        end
    end)

    bind(UserInputService.InputChanged, function(input)
        if active and input == moveInput then
            local delta = input.Position - startInput
            local w = math.clamp(startSize.X.Offset + dirX * delta.X, MIN_SIZE.X, MAX_SIZE.X)
            local h = math.clamp(startSize.Y.Offset + dirY * delta.Y, MIN_SIZE.Y, MAX_SIZE.Y)
            win.Size     = UDim2.fromOffset(w, h)
            win.Position = UDim2.fromOffset(startAbs.X + w * 0.5, startAbs.Y + h * 0.5)
        end
    end)
end

local function buildFallbackUI(gameName, iconAssetId)
    local connections = {}
    local function bind(signal, fn)
        local conn = signal:Connect(fn)
        connections[#connections + 1] = conn
        return conn
    end
    local function disconnectAll()
        for i = 1, #connections do
            pcall(function()
                connections[i]:Disconnect()
            end)
        end
        table.clear(connections)
    end

    local screenGui = create("ScreenGui", {
        Name           = WINDOW_TITLE,
        ResetOnSpawn   = false,
        IgnoreGuiInset = true,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder   = 999999,
    })

    local window = create("CanvasGroup", {
        Name              = "Window",
        AnchorPoint       = Vector2.new(0.5, 0.5),
        Position          = UDim2.fromScale(0.5, 0.5),
        Size              = UDim2.fromOffset(430, 384),
        BackgroundColor3  = THEME.Background,
        BorderSizePixel   = 0,
        Active            = true,
        ClipsDescendants  = true,
        GroupTransparency = 1,
        Parent            = screenGui,
    })
    create("UICorner", { CornerRadius = UDim.new(0, 14), Parent = window })
    create("UIStroke", { Color = THEME.Stroke, Thickness = 1.5, Transparency = 0.25, Parent = window })
    local uiScale = create("UIScale", { Scale = 0.92, Parent = window })

    local titleBar = create("Frame", {
        Name                   = "TitleBar",
        BackgroundTransparency = 1,
        Size                   = UDim2.new(1, 0, 0, 46),
        Active                 = true,
        Parent                 = window,
    })

    local titleDot = create("Frame", {
        Size             = UDim2.fromOffset(8, 8),
        Position         = UDim2.new(0, 18, 0, 19),
        BackgroundColor3 = THEME.Accent,
        BorderSizePixel  = 0,
        Parent           = titleBar,
    })
    create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = titleDot })

    local titleLabel = create("TextLabel", {
        BackgroundTransparency = 1,
        Position               = UDim2.new(0, 34, 0, 0),
        Size                   = UDim2.new(1, -76, 1, 0),
        Font                   = Enum.Font.GothamBold,
        Text                   = WINDOW_TITLE,
        TextSize               = 15,
        TextColor3             = THEME.Text,
        TextXAlignment         = Enum.TextXAlignment.Left,
        Parent                 = titleBar,
    })
    create("UIGradient", {
        Color    = ColorSequence.new(THEME.AccentSoft, THEME.Accent),
        Rotation = 90,
        Parent   = titleLabel,
    })

    local closeBtn = create("TextButton", {
        Name             = "Close",
        Size             = UDim2.fromOffset(28, 28),
        Position         = UDim2.new(1, -38, 0, 9),
        BackgroundColor3 = THEME.Surface,
        BorderSizePixel  = 0,
        AutoButtonColor  = false,
        Font             = Enum.Font.GothamBold,
        Text             = "X",
        TextSize         = 13,
        TextColor3       = THEME.TextMuted,
        Parent           = titleBar,
    })
    create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = closeBtn })

    closeBtn.MouseEnter:Connect(function()
        TweenService:Create(closeBtn, TweenInfo.new(0.15), {
            BackgroundColor3 = THEME.Danger,
            TextColor3       = THEME.Text,
        }):Play()
    end)
    closeBtn.MouseLeave:Connect(function()
        TweenService:Create(closeBtn, TweenInfo.new(0.15), {
            BackgroundColor3 = THEME.Surface,
            TextColor3       = THEME.TextMuted,
        }):Play()
    end)
    closeBtn.MouseButton1Click:Connect(function()
        disconnectAll()
        screenGui:Destroy()
    end)

    local accentLine = create("Frame", {
        Size                   = UDim2.new(1, -36, 0, 1),
        Position               = UDim2.new(0, 18, 0, 46),
        BackgroundColor3       = THEME.Accent,
        BackgroundTransparency = 0.45,
        BorderSizePixel        = 0,
        Parent                 = window,
    })
    create("UIGradient", {
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(1, 1),
        }),
        Parent = accentLine,
    })

    local homePage = create("Frame", {
        Name                   = "HomePage",
        BackgroundTransparency = 1,
        Position               = UDim2.new(0, 0, 0, 47),
        Size                   = UDim2.new(1, 0, 1, -83),
        ClipsDescendants       = true,
        Parent                 = window,
    })

    local thumbHolder = create("Frame", {
        Name             = "Thumbnail",
        Position         = UDim2.new(0, 22, 0, 21),
        Size             = UDim2.fromOffset(116, 116),
        BackgroundColor3 = THEME.Surface,
        BorderSizePixel  = 0,
        ClipsDescendants = true,
        Parent           = homePage,
    })
    create("UICorner", { CornerRadius = UDim.new(0, 12), Parent = thumbHolder })
    create("UIStroke", { Color = THEME.Stroke, Thickness = 1, Transparency = 0.55, Parent = thumbHolder })

    create("TextLabel", {
        Name                   = "IconFallback",
        BackgroundTransparency = 1,
        Size                   = UDim2.fromScale(1, 1),
        Font                   = Enum.Font.GothamBold,
        Text                   = gameName:sub(1, 1):upper(),
        TextSize               = 40,
        TextColor3             = THEME.AccentSoft,
        TextTransparency       = 0.35,
        Parent                 = thumbHolder,
    })

    local thumbImage = create("ImageLabel", {
        Name                   = "GameIcon",
        BackgroundTransparency = 1,
        Size                   = UDim2.fromScale(1, 1),
        ZIndex                 = 2,
        ScaleType              = Enum.ScaleType.Fit,
        Parent                 = thumbHolder,
    })
    if iconAssetId and iconAssetId > 0 then
        thumbImage.Image = "rbxassetid://" .. tostring(iconAssetId)
    else
        pcall(function()
            thumbImage.Image = ("rbxthumb://type=GameIcon&id=%d&w=150&h=150"):format(game.PlaceId)
        end)
    end

    create("TextLabel", {
        Name                   = "GameName",
        BackgroundTransparency = 1,
        Position               = UDim2.new(0, 156, 0, 19),
        Size                   = UDim2.new(1, -176, 0, 38),
        Font                   = Enum.Font.GothamBold,
        Text                   = gameName,
        TextSize               = 17,
        TextColor3             = THEME.Text,
        TextXAlignment         = Enum.TextXAlignment.Left,
        TextYAlignment         = Enum.TextYAlignment.Top,
        TextWrapped            = true,
        Parent                 = homePage,
    })

    create("TextLabel", {
        Name                   = "PlaceIdLabel",
        BackgroundTransparency = 1,
        Position               = UDim2.new(0, 156, 0, 61),
        Size                   = UDim2.new(1, -176, 0, 16),
        Font                   = Enum.Font.Gotham,
        Text                   = ("PlaceId  %d"):format(game.PlaceId),
        TextSize               = 12,
        TextColor3             = THEME.TextMuted,
        TextXAlignment         = Enum.TextXAlignment.Left,
        Parent                 = homePage,
    })

    local statusDot = create("Frame", {
        Size             = UDim2.fromOffset(8, 8),
        Position         = UDim2.new(0, 156, 0, 90),
        BackgroundColor3 = THEME.Warning,
        BorderSizePixel  = 0,
        Parent           = homePage,
    })
    create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = statusDot })

    create("TextLabel", {
        Name                   = "StatusLabel",
        BackgroundTransparency = 1,
        Position               = UDim2.new(0, 172, 0, 84),
        Size                   = UDim2.new(1, -192, 0, 18),
        Font                   = Enum.Font.GothamMedium,
        Text                   = "No script for this game yet",
        TextSize               = 12,
        TextColor3             = THEME.Warning,
        TextXAlignment         = Enum.TextXAlignment.Left,
        Parent                 = homePage,
    })

    create("TextLabel", {
        Name                   = "Hint",
        BackgroundTransparency = 1,
        Position               = UDim2.new(0, 22, 0, 150),
        Size                   = UDim2.new(1, -44, 0, 44),
        Font                   = Enum.Font.Gotham,
        Text                   = "LarpLoader has no script for this game yet. New scripts are regularly added to our GitHub (github.com/Omlet1k/LarpHub) - or paste a script URL below and run it yourself.",
        TextSize               = 12,
        TextColor3             = THEME.TextMuted,
        TextTransparency       = 0.1,
        TextXAlignment         = Enum.TextXAlignment.Left,
        TextYAlignment         = Enum.TextYAlignment.Top,
        TextWrapped            = true,
        Parent                 = homePage,
    })

    create("TextLabel", {
        Name                   = "ManualLabel",
        BackgroundTransparency = 1,
        Position               = UDim2.new(0, 22, 0, 198),
        Size                   = UDim2.new(1, -44, 0, 14),
        Font                   = Enum.Font.GothamMedium,
        Text                   = "LOAD SCRIPT MANUALLY",
        TextSize               = 11,
        TextColor3             = THEME.AccentSoft,
        TextXAlignment         = Enum.TextXAlignment.Left,
        Parent                 = homePage,
    })

    local urlInput = create("TextBox", {
        Name              = "UrlInput",
        Position          = UDim2.new(0, 22, 0, 216),
        Size              = UDim2.new(1, -44, 0, 32),
        BackgroundColor3  = THEME.Surface,
        BorderSizePixel   = 0,
        Font              = Enum.Font.Gotham,
        PlaceholderText   = "https://... paste script URL here",
        PlaceholderColor3 = THEME.TextMuted,
        Text              = "",
        TextSize          = 12,
        TextColor3        = THEME.Text,
        TextXAlignment    = Enum.TextXAlignment.Left,
        ClearTextOnFocus  = false,
        ClipsDescendants  = true,
        Parent            = homePage,
    })
    create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = urlInput })
    create("UIStroke", { Color = THEME.Stroke, Thickness = 1, Transparency = 0.45, Parent = urlInput })
    create("UIPadding", {
        PaddingLeft  = UDim.new(0, 10),
        PaddingRight = UDim.new(0, 10),
        Parent       = urlInput,
    })

    local loadBtn = create("TextButton", {
        Name             = "LoadScriptButton",
        Position         = UDim2.new(0, 22, 0, 256),
        Size             = UDim2.new(1, -44, 0, 34),
        BackgroundColor3 = THEME.Accent,
        BorderSizePixel  = 0,
        AutoButtonColor  = false,
        Font             = Enum.Font.GothamBold,
        Text             = "Load & Run Script",
        TextSize         = 13,
        TextColor3       = THEME.Text,
        Parent           = homePage,
    })
    create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = loadBtn })

    loadBtn.MouseEnter:Connect(function()
        TweenService:Create(loadBtn, TweenInfo.new(0.15), { BackgroundColor3 = THEME.Stroke }):Play()
    end)
    loadBtn.MouseLeave:Connect(function()
        TweenService:Create(loadBtn, TweenInfo.new(0.15), { BackgroundColor3 = THEME.Accent }):Play()
    end)
    loadBtn.MouseButton1Click:Connect(function()
        runManualInput(urlInput.Text)
    end)
    urlInput.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            runManualInput(urlInput.Text)
        end
    end)

    local gamesBtn = create("TextButton", {
        Name             = "GamesButton",
        Position         = UDim2.new(0, 156, 0, 110),
        Size             = UDim2.fromOffset(164, 32),
        BackgroundColor3 = THEME.Surface,
        BorderSizePixel  = 0,
        AutoButtonColor  = false,
        Font             = Enum.Font.GothamMedium,
        Text             = "Available Games   >",
        TextSize         = 12,
        TextColor3       = THEME.AccentSoft,
        Parent           = homePage,
    })
    create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = gamesBtn })
    create("UIStroke", { Color = THEME.Stroke, Thickness = 1, Transparency = 0.45, Parent = gamesBtn })

    gamesBtn.MouseEnter:Connect(function()
        TweenService:Create(gamesBtn, TweenInfo.new(0.15), { BackgroundColor3 = THEME.SurfaceLight }):Play()
    end)
    gamesBtn.MouseLeave:Connect(function()
        TweenService:Create(gamesBtn, TweenInfo.new(0.15), { BackgroundColor3 = THEME.Surface }):Play()
    end)

    create("Frame", {
        Size             = UDim2.new(1, -36, 0, 1),
        Position         = UDim2.new(0, 18, 1, -36),
        BackgroundColor3 = THEME.SurfaceLight,
        BorderSizePixel  = 0,
        Parent           = window,
    })

    create("TextLabel", {
        BackgroundTransparency = 1,
        Position               = UDim2.new(0, 18, 1, -26),
        Size                   = UDim2.new(1, -140, 0, 16),
        Font                   = Enum.Font.Gotham,
        Text                   = ("PlaceId %d  |  Universe %d"):format(game.PlaceId, game.GameId),
        TextSize               = 11,
        TextColor3             = THEME.TextMuted,
        TextXAlignment         = Enum.TextXAlignment.Left,
        Parent                 = window,
    })

    create("TextLabel", {
        BackgroundTransparency = 1,
        AnchorPoint            = Vector2.new(1, 0),
        Position               = UDim2.new(1, -18, 1, -26),
        Size                   = UDim2.fromOffset(140, 16),
        Font                   = Enum.Font.GothamMedium,
        Text                   = WINDOW_TITLE .. "  v" .. VERSION,
        TextSize               = 11,
        TextColor3             = THEME.TextMuted,
        TextXAlignment         = Enum.TextXAlignment.Right,
        Parent                 = window,
    })

    local gamesPage = create("Frame", {
        Name                   = "GamesPage",
        BackgroundTransparency = 1,
        Position               = UDim2.new(0, 0, 0, 47),
        Size                   = UDim2.new(1, 0, 1, -83),
        Visible                = false,
        ClipsDescendants       = true,
        Parent                 = window,
    })

    local gameNames = {}
    for name in pairs(GAMES) do
        table.insert(gameNames, name)
    end
    table.sort(gameNames)

    local backBtn = create("TextButton", {
        Name             = "BackButton",
        Position         = UDim2.new(0, 18, 0, 10),
        Size             = UDim2.fromOffset(64, 28),
        BackgroundColor3 = THEME.Surface,
        BorderSizePixel  = 0,
        AutoButtonColor  = false,
        Font             = Enum.Font.GothamMedium,
        Text             = "< Back",
        TextSize         = 12,
        TextColor3       = THEME.TextMuted,
        Parent           = gamesPage,
    })
    create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = backBtn })

    create("TextLabel", {
        BackgroundTransparency = 1,
        Position               = UDim2.new(0, 94, 0, 10),
        Size                   = UDim2.fromOffset(200, 28),
        Font                   = Enum.Font.GothamBold,
        Text                   = "Available Games",
        TextSize               = 14,
        TextColor3             = THEME.Text,
        TextXAlignment         = Enum.TextXAlignment.Left,
        Parent                 = gamesPage,
    })

    create("TextLabel", {
        BackgroundTransparency = 1,
        AnchorPoint            = Vector2.new(1, 0),
        Position               = UDim2.new(1, -18, 0, 10),
        Size                   = UDim2.fromOffset(140, 28),
        Font                   = Enum.Font.Gotham,
        Text                   = ("%d registered"):format(#gameNames),
        TextSize               = 11,
        TextColor3             = THEME.TextMuted,
        TextXAlignment         = Enum.TextXAlignment.Right,
        Parent                 = gamesPage,
    })

    local gamesScroll = create("ScrollingFrame", {
        Name                   = "GamesList",
        Position               = UDim2.new(0, 18, 0, 46),
        Size                   = UDim2.new(1, -36, 1, -54),
        BackgroundTransparency = 1,
        BorderSizePixel        = 0,
        ScrollBarThickness     = 3,
        ScrollBarImageColor3   = THEME.Stroke,
        CanvasSize             = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize    = Enum.AutomaticSize.Y,
        Parent                 = gamesPage,
    })
    create("UIListLayout", {
        Padding   = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent    = gamesScroll,
    })

    for order, gameEntryName in ipairs(gameNames) do
        local gameEntry  = GAMES[gameEntryName]
        local hasUrl     = trim(gameEntry.url) ~= ""
        local entryIds   = gameEntry.placeIds or { gameEntry.placeId }
        local rowPlaceId = tonumber(entryIds[1]) or 0

        local row = create("Frame", {
            Size             = UDim2.new(1, -6, 0, 50),
            BackgroundColor3 = THEME.Surface,
            BorderSizePixel  = 0,
            LayoutOrder      = order,
            Parent           = gamesScroll,
        })
        create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = row })

        local rowIconHolder = create("Frame", {
            Position         = UDim2.new(0, 8, 0, 8),
            Size             = UDim2.fromOffset(34, 34),
            BackgroundColor3 = THEME.SurfaceLight,
            BorderSizePixel  = 0,
            ClipsDescendants = true,
            Parent           = row,
        })
        create("UICorner", { CornerRadius = UDim.new(0, 7), Parent = rowIconHolder })

        create("TextLabel", {
            BackgroundTransparency = 1,
            Size                   = UDim2.fromScale(1, 1),
            Font                   = Enum.Font.GothamBold,
            Text                   = gameEntryName:sub(1, 1):upper(),
            TextSize               = 15,
            TextColor3             = THEME.AccentSoft,
            TextTransparency       = 0.35,
            Parent                 = rowIconHolder,
        })

        local rowIcon = create("ImageLabel", {
            BackgroundTransparency = 1,
            Size                   = UDim2.fromScale(1, 1),
            ZIndex                 = 2,
            ScaleType              = Enum.ScaleType.Fit,
            Parent                 = rowIconHolder,
        })
        if rowPlaceId ~= 0 then
            task.spawn(function()
                local ok, info = pcall(function()
                    return MarketplaceService:GetProductInfo(rowPlaceId)
                end)
                if ok and info then
                    local assetId = tonumber(info.IconImageAssetId) or 0
                    if assetId > 0 then
                        rowIcon.Image = "rbxassetid://" .. assetId
                        return
                    end
                end
                pcall(function()
                    rowIcon.Image = ("rbxthumb://type=GameIcon&id=%d&w=150&h=150"):format(rowPlaceId)
                end)
            end)
        end

        create("TextLabel", {
            BackgroundTransparency = 1,
            Position               = UDim2.new(0, 52, 0, 0),
            Size                   = UDim2.new(1, -172, 1, 0),
            Font                   = Enum.Font.GothamMedium,
            Text                   = gameEntryName,
            TextSize               = 13,
            TextColor3             = THEME.Text,
            TextXAlignment         = Enum.TextXAlignment.Left,
            TextTruncate           = Enum.TextTruncate.AtEnd,
            Parent                 = row,
        })

        create("TextLabel", {
            BackgroundTransparency = 1,
            AnchorPoint            = Vector2.new(1, 0),
            Position               = UDim2.new(1, -14, 0, 0),
            Size                   = UDim2.fromOffset(110, 50),
            Font                   = Enum.Font.Gotham,
            Text                   = hasUrl and "Script ready" or "No script",
            TextSize               = 11,
            TextColor3             = hasUrl and THEME.Success or THEME.TextMuted,
            TextXAlignment         = Enum.TextXAlignment.Right,
            Parent                 = row,
        })
    end

    backBtn.MouseEnter:Connect(function()
        TweenService:Create(backBtn, TweenInfo.new(0.15), { BackgroundColor3 = THEME.SurfaceLight }):Play()
    end)
    backBtn.MouseLeave:Connect(function()
        TweenService:Create(backBtn, TweenInfo.new(0.15), { BackgroundColor3 = THEME.Surface }):Play()
    end)
    backBtn.MouseButton1Click:Connect(function()
        gamesPage.Visible = false
        homePage.Visible  = true
    end)
    gamesBtn.MouseButton1Click:Connect(function()
        homePage.Visible  = false
        gamesPage.Visible = true
    end)

    local rightEdge = create("Frame", {
        BackgroundTransparency = 1,
        Active                 = true,
        ZIndex                 = 5,
        Size                   = UDim2.new(0, 6, 1, -40),
        Position               = UDim2.new(1, -6, 0, 8),
        Parent                 = window,
    })
    local bottomEdge = create("Frame", {
        BackgroundTransparency = 1,
        Active                 = true,
        ZIndex                 = 5,
        Size                   = UDim2.new(1, -40, 0, 6),
        Position               = UDim2.new(0, 8, 1, -6),
        Parent                 = window,
    })
    local cornerGrip = create("Frame", {
        BackgroundTransparency = 1,
        Active                 = true,
        ZIndex                 = 6,
        Size                   = UDim2.fromOffset(22, 22),
        Position               = UDim2.new(1, -26, 1, -26),
        Parent                 = window,
    })
    for _, point in ipairs({ Vector2.new(0.32, 0.68), Vector2.new(0.5, 0.5), Vector2.new(0.68, 0.32) }) do
        create("Frame", {
            AnchorPoint            = Vector2.new(0.5, 0.5),
            Position               = UDim2.fromScale(point.X, point.Y),
            Size                   = UDim2.fromOffset(10, 2),
            Rotation               = -45,
            BackgroundColor3       = THEME.TextMuted,
            BackgroundTransparency = 0.35,
            BorderSizePixel        = 0,
            Parent                 = cornerGrip,
        })
    end

    makeDraggable(titleBar, window, bind)
    makeResizable(rightEdge, window, 1, 0, bind)
    makeResizable(bottomEdge, window, 0, 1, bind)
    makeResizable(cornerGrip, window, 1, 1, bind)

    screenGui.Destroying:Connect(disconnectAll)

    if getgenv then
        pcall(function()
            getgenv().LarpLoaderGUI = screenGui
        end)
    end

    if type(syn) == "table" and type(syn.protect_gui) == "function" then
        pcall(syn.protect_gui, screenGui)
    end

    local parented = pcall(function()
        screenGui.Parent = resolveGuiParent()
    end)
    if not parented and LocalPlayer then
        screenGui.Parent = LocalPlayer:FindFirstChild("PlayerGui")
            or LocalPlayer:WaitForChild("PlayerGui", 5)
    end

    TweenService:Create(uiScale, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 }):Play()
    TweenService:Create(window, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { GroupTransparency = 0 }):Play()

    return screenGui
end

local function findGameEntry(productInfo)
    for name, entry in pairs(GAMES) do
        local ids = entry.placeIds or { entry.placeId }
        for _, rawId in ipairs(ids) do
            local pid = tonumber(rawId) or 0
            if pid ~= 0 and (pid == game.PlaceId or pid == game.GameId) then
                return entry, name, "PlaceId/GameId"
            end
        end
    end
    local infoName = productInfo and productInfo.Name
    if infoName then
        for name, entry in pairs(GAMES) do
            if name:lower() == infoName:lower() then
                return entry, name, "name"
            end
        end
    end
    return nil
end

if game.PlaceId == 0 then
    local started = os.clock()
    while game.PlaceId == 0 and os.clock() - started < 10 do
        task.wait(0.2)
    end
end

local productInfo
pcall(function()
    productInfo = MarketplaceService:GetProductInfo(game.PlaceId)
end)

local entry, matchedName, matchedHow = findGameEntry(productInfo)

if DEBUG then
    local debugName = (productInfo and productInfo.Name) or "n/a"
    local debugMsg  = ("[LarpLoader] Debug: PlaceId=%d | GameId=%d | Name=%s | Match=%s")
        :format(game.PlaceId, game.GameId, debugName, matchedName or "none")
    print(debugMsg)
end

if entry then
    local url = trim(entry.url)
    if url ~= "" then
        local message = ("[LarpLoader] Matched '%s' via %s - executing script..."):format(matchedName, matchedHow)
        print(message)
        runScriptFromUrl(url, (productInfo and productInfo.Name) or matchedName)
    else
        local message = ("[LarpLoader] '%s' is registered but its URL is still empty - nothing to load."):format(matchedName)
        warn(message)
        notify("Script for this game isn't published yet - check back soon", "warn", 6)
    end
else
    local gameName    = (productInfo and productInfo.Name) or "Unknown Game"
    local iconAssetId = (productInfo and tonumber(productInfo.IconImageAssetId)) or 0
    local message     = ("[LarpLoader] '%s' (PlaceId %d) is not in the game list - showing fallback UI."):format(gameName, game.PlaceId)
    print(message)
    buildFallbackUI(gameName, iconAssetId)
end
