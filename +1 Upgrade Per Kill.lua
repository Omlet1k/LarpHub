local Env = getgenv()
if Env.__LarpHubUpgradePerKill then
    Env.__LarpHubUpgradePerKill:Unload()
end

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local Run = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Debris = game:GetService("Debris")
local Http = game:GetService("HttpService")
local SoundService = game:GetService("SoundService")
local Player = Players.LocalPlayer
local Remotes = assert(RS:WaitForChild("Remotes", 10), "Game Remotes not found")
local Client = assert(Player.PlayerScripts:WaitForChild("Client", 10), "Game Client not found")
local Controllers = Client:WaitForChild("Controllers", 10)
local Movement = require(Controllers.MovementController)
local CameraController = require(Controllers.CameraController)
local GameInput = require(Controllers.Input)
local WorldRenderer = require(Controllers.WorldRenderer)
local Combat = require(Controllers.CombatController)
local Physics = require(RS.Shared.Physics.PlayerPhysics)
local Blocks = require(RS.Shared.Voxel.Blocks)
local GameConfig = require(RS.Shared.Config)
local ClientState = require(Client.Core.ClientState)
local BlockSize = GameConfig.World.BlockSize
local Height = GameConfig.Physics.PlayerHeight * BlockSize
local Accent = Color3.fromRGB(177, 116, 255)
local MaxSpeedMultiplier = 1.10
local DefaultSpeedMultiplier = 1.05
local function clampSpeed(value)
    if type(value)~="number" or value~=value or math.abs(value)==math.huge then return DefaultSpeedMultiplier end
    return math.clamp(value,1,MaxSpeedMultiplier)
end

local LocaleStrings={
    ["Home"]="Главная",
    ["Settings"]="Настройки",
    ["Appearance and menu controls"]="Оформление и управление меню",
    ["Show welcome"]="Показать приветствие",
    ["Version: "]="Версия: ",
    ["Toggle menu: RightShift. On mobile, use the menu button."]="Скрыть / показать меню: RightShift. На телефоне используйте кнопку меню.",
    ["Test notification"]="Проверить уведомление",
    ["Interface"]="Интерфейс",
    ["Menu key"]="Клавиша меню",
    ["Show watermark"]="Показывать watermark",
    ["Custom cursor"]="Кастомный курсор",
    ["Interface scale"]="Масштаб интерфейса",
    ["Combat"]="Бой",
    ["Movement"]="Передвижение",
    ["Visuals"]="Визуалы",
    ["Tracking"]="Отслеживание",
    ["Camera"]="Камера",
    ["Hit Feedback"]="Отклик попаданий",
    ["Keybinds"]="Бинды",
    ["Adapted from the requested ScriptBlox source; the original attack packet is preserved."]="Адаптация указанного ScriptBlox-скрипта; исходный пакет атаки сохранён.",
    ["Range (blocks)"]="Дальность (блоки)",
    ["Attack delay"]="Задержка атаки",
    ["Ignore teammates"]="Не атаковать команду",
    ["Check walls"]="Проверять стены",
    ["Defense / hits"]="Защита / попадания",
    ["Game code: normal reach is 3 blocks; ServerEntity is 4. Default: 3 blocks / 0.50 s. The server validates hits."]="Код игры: обычный удар — 3 блока; ServerEntity — 4 блока. По умолчанию 3 блока / 0.50 с. Проверка сервера определяет результат.",
    ["Blocks impulses in the game's movement controller."]="Блокирует импульс в собственном контроллере игры.",
    ["Particles appear only on your server-confirmed hits."]="Партиклы только на подтверждённых сервером ваших попаданиях.",
    ["Particle style"]="Тип партиклов",
    ["Count"]="Количество",
    ["Rainbow particles"]="Радужные партиклы",
    ["Particle color"]="Цвет партиклов",
    ["Hitmarker color"]="Цвет отметки попадания",
    ["Hitmarker duration"]="Длительность отметки",
    ["Hitmarker size"]="Размер отметки",
    ["Sound"]="Звук",
    ["Custom sound ID"]="ID своего звука",
    ["Volume"]="Громкость",
    ["Sound pitch"]="Тон звука",
    ["Damage number color"]="Цвет чисел урона",
    ["Damage units"]="Единицы урона",
    ["Damage lifetime"]="Время чисел урона",
    ["Test Hit Feedback"]="Проверить Hit Feedback",
    ["Speed multiplier"]="Множитель скорости",
    ["Keep Speed while jumping"]="Сохранять Speed в прыжке",
    ["Automatically jump while moving on the ground. Disabled in water, lava, on ladders and while sneaking."]="Автоматически прыгает при движении по земле. В воде, лаве, на лестнице и при Sneak не срабатывает.",
    ["Scales horizontal air acceleration. Jump height stays unchanged."]="Масштабирует горизонтальное ускорение в воздухе. Высота прыжка остаётся игровой.",
    ["Speed: 1.05x by default, 1.10x maximum. Older configs are automatically clamped."]="Speed: 1.05x по умолчанию, максимум 1.10x. Старые конфиги автоматически ограничиваются.",
    ["Orbit radius"]="Радиус обхода",
    ["Target search range"]="Поиск цели",
    ["Direction"]="Направление",
    ["Jump while strafing"]="Прыгать при обходе",
    ["Orbit the nearest player at the selected radius. Reverse direction on collision."]="Обход ближайшего игрока с удержанием радиуса. При столкновении направление меняется.",
    ["Boxes"]="Рамки",
    ["Names"]="Имена",
    ["Health bar"]="Полоса здоровья",
    ["Distance"]="Расстояние",
    ["Character chams"]="Подсветка персонажей",
    ["Chams transparency"]="Прозрачность подсветки",
    ["Text size"]="Размер текста",
    ["Visible only"]="Только видимые",
    ["Hide teammates"]="Скрывать команду",
    ["Team colors"]="Цвет команды",
    ["ESP / Tracers / Arrows color"]="Цвет ESP / Tracers / Arrows",
    ["Display range"]="Дальность отображения",
    ["Tracer origin"]="Начало линии",
    ["Tracer thickness"]="Толщина линии",
    ["Arrows near crosshair"]="Arrows — указатели у прицела",
    ["Distance from crosshair"]="Отступ от прицела",
    ["Arrow size"]="Размер стрелок",
    ["Off-screen players only"]="Только игроки за экраном",
    ["Color, range, team and visibility filters are shared with ESP."]="Цвет, дальность, проверка команды и видимости общие с ESP.",
    ["Current target color"]="Цвет текущей цели",
    ["Target transparency"]="Прозрачность цели",
    ["Active keybinds only"]="Только активные бинды",
    ["Keep target after hit"]="Держать цель после удара",
    ["Keep HUD after kill"]="Оставлять HUD после убийства",
    ["HUD scale"]="Масштаб HUD",
    ["Background transparency"]="Прозрачность фона",
    ["Health bar color"]="Цвет полосы здоровья",
    ["Keybinds header color"]="Цвет заголовка Keybinds",
    ["HUD editor"]="Редактор HUD",
    ["Preview panels without enabling combat modules."]="Показывает панели для настройки без включения боевых модулей.",
    ["Snap to edges / center"]="Привязка к краям / центру",
    ["Snap distance"]="Расстояние привязки",
    ["Reset HUD positions"]="Сбросить позиции HUD",
    ["Drag either HUD with the mouse. HP is shown in hearts; Win / Lose compares current health. R: KillAura; F: Strafe."]="Оба HUD перетаскиваются мышью. HP показан в сердцах; Win / Lose сравнивает текущее здоровье. R — KillAura; F — Strafe.",
    ["Preview HUD (5 s)"]="Предпросмотр HUD (5 с)",
    ["HUD EDITOR · drag panels · snap to edges and center"]="РЕДАКТОР HUD · перетаскивай панели · привязка к краям и центру",
    ["FOV"]="FOV — угол обзора",
    ["Field of view"]="Угол обзора",
    ["Keep sprint / speed FOV effects"]="Сохранять эффекты спринта / скорости",
    ["Aspect ratio"]="Соотношение сторон",
    ["1.33 = 4:3; 1.78 = 16:9. Adjusts camera projection."]="1.33 = 4:3; 1.78 = 16:9. Меняет проекцию камеры.",
    ["ViewModel / free look"]="ViewModel / свободный обзор",
    ["Hold for free look"]="Удерживать для обзора",
    ["Free look"]="Свободный обзор",
    ["Hold the key for third-person free look. Camera rotation does not change movement direction. Release to restore the view."]="При удержании клавиши: вид от третьего лица, камера вращается независимо, направление движения сохраняется. После отпускания вид восстанавливается.",
    ["Enabling hides the game's crosshair; disabling restores it."]="Включение скрывает штатный прицел; выключение возвращает его.",
    ["Crosshair color"]="Цвет прицела",
    ["Length"]="Длина",
    ["Gap"]="Отступ",
    ["Thickness"]="Толщина",
    ["Center dot"]="Точка в центре",
    ["Rotation"]="Вращение",
    ["Rainbow hat"]="Радужная шляпа",
    ["Hat color"]="Цвет шляпы",
    ["Hat radius"]="Радиус шляпы",
    ["Cone height"]="Высота конуса",
    ["Opacity"]="Непрозрачность",
    ["Show in first person"]="Показывать от первого лица",
    ["Amb — lighting"]="Amb — освещение",
    ["Brightness"]="Яркость",
    ["Time of day"]="Время суток",
    ["Remove fog"]="Убрать туман",
    ["Appearance and notifications"]="Оформление и уведомления",
    ["Theme preset"]="Профиль оформления",
    ["Module notifications"]="Уведомления о модулях",
    ["Configs"]="Конфиги",
    ["Config name"]="Название конфига",
    ["Saved configs"]="Сохранённые конфиги",
    ["Autosave changes"]="Автосохранение изменений",
    ["Save"]="Сохранить",
    ["Load"]="Загрузить",
    ["Load on startup"]="Загружать при запуске",
    ["Delete selected"]="Удалить выбранный",
    ["Refresh list"]="Обновить список",
    ["Saves settings, modified keybinds, appearance and HUD positions. The HUD editor starts closed."]="Сохраняются настройки, бинды с модификаторами, оформление и позиции HUD. Редактор HUD при запуске закрыт.",
    ["Current: "]="Текущий: ",
    ["Config: "]="Конфиг: ",
    ["Saved: "]="Сохранён: ",
    ["Loaded: "]="Загружен: ",
    ["Autoload: "]="Автозагрузка: ",
    ["Deleted: "]="Удалён: ",
    ["Autosave: "]="Автосохранение: ",
    ["Config not loaded: "]="Конфиг не загружен: ",
    ["Menu: RightShift\nFree look: hold V\nFirst launch: features off. Configs restore saved settings."]="Меню: RightShift\nСвободный обзор: удерживать V\nПервый запуск: функции выключены. Конфиги восстанавливают сохранённые настройки.",
    ["Disable all features"]="Выключить все функции",
    ["All features disabled."]="Все функции выключены.",
    ["Test hit particles"]="Проверить хит-партиклы",
    ["Game status"]="Статус игры",
    ["Ready"]="Готово",
    ["Attacks: "]="Атак: ",
    ["Confirmed hits: "]="Подтверждённых попаданий: ",
    ["Knockbacks blocked: "]="Отбрасываний заблокировано: ",
    ["Ready! Combat / Movement / Visuals. Menu: RightShift."]="Готово! Combat / Movement / Visuals. Меню: RightShift.",
    ["ON"]="ВКЛ",
    ["OFF"]="ВЫКЛ",
    ["Armor: "]="Броня: ",
    ["Weapon: "]="Оружие: ",
    ["HP: "]="ОЗ: ",
    ["Win"]="Победа",
    ["Lose"]="Поражение",
    ["Even"]="Равно",
    ["Kill"]="Убит",
    ["Hearts"]="Сердца",
    ["Right"]="Вправо",
    ["Left"]="Влево",
    ["Bottom"]="Снизу",
    ["Center"]="Центр",
    ["Mouse"]="Мышь",
    ["Stars"]="Звёзды",
    ["Sparks"]="Искры",
    ["Custom"]="Свой",
    ["Hold"]="Удерживать",
    ["Toggle"]="Переключать",
    ["Always"]="Всегда",
    ["Press"]="Нажатие",
    ["Use the Combat, Movement and Visuals tabs for +1 Upgrade Per Kill features."]="Функции +1 Upgrade Per Kill находятся во вкладках Combat, Movement и Visuals.",
    ["KillAura: ScriptBlox source"]="KillAura: исходник ScriptBlox",
    ["LarpHub is ready!"]="LarpHub готов к работе!",
    ["Welcome to LarpHub"]="Добро пожаловать в LarpHub",
    ["Welcome to LarpHub!"]="Добро пожаловать в LarpHub!",
    ["Thanks for using LarpHub."]="Спасибо, что используете LarpHub.",
    ["Open LarpHub"]="Открыть LarpHub",
    ["LarpHub menu"]="Меню LarpHub",
    ["LarpHub accent"]="Акцент LarpHub",
    ["LarpHub color"]="Цвет LarpHub",
    ["Unload LarpHub"]="Выгрузить LarpHub",
    ["About LarpHub"]="О LarpHub",
    ["Energy: cyan; LarpHub: purple; White: minimal white. Presets change interface and effect colors."]="Energy — голубой; LarpHub — фиолетовый; White — минималистичный белый. Профиль меняет интерфейс и цвета визуальных эффектов.",
    ["default"]="по умолчанию",
    ["Damage Indicators"]="Индикаторы урона",
    ["Hit Particles"]="Партиклы попаданий",
    ["Hit Sound"]="Звук попадания",
    ["Hitmarker"]="Хитмаркер",
    ["Target HUD"]="HUD цели",
    ["Keybinds HUD"]="HUD биндов",
    ["Target Highlight"]="Подсветка цели",
    ["Crosshair"]="Прицел",
    ["Ambient"]="Окружение",
    ["Outdoor Ambient"]="Внешнее окружение",
    ["Combat · Movement · Visuals"]="Бой · Передвижение · Визуалы",
    ["Tracers"]="Трейсеры",
}

local Config = {
    KillAura = false, AuraRange = GameConfig.Combat.Reach.Entity, AuraCooldown = 0.5, TeamCheck = false, WallCheck = true,
    AntiKnockBack = false,
    TargetStrafe = false, StrafeRange = 40, StrafeRadius = 8, StrafeDirection = "Right", StrafeJump = false,
    Speed = false, SpeedMultiplier = DefaultSpeedMultiplier, SpeedAir = true, AutoSprint = false, AutoJump = false,
    ESP = false, ESPBoxes = true, ESPNames = true, ESPHealth = true, ESPDistance = true,
    ESPChams = false, ESPVisibleOnly = false, ESPTeamCheck = false, ESPTeamColor = false,
    VisualRange = 500, VisualColor = Accent, ESPFontSize = 13, ChamsTransparency = 0.65,
    Tracers = false, TracerOrigin = "Bottom", TracerThickness = 1,
    Arrows = false, ArrowRadius = 95, ArrowSize = 10, ArrowsOffscreen = false,
    AspectRatio = false, AspectValue = 1.33,
    FOV = false, FOVValue = 90, FOVEffects = true,
    TargetHUD = false, KeybindHUD = false, KeybindActiveOnly = true, TargetHUDTimeout = 4,
    HUDColor = Color3.fromRGB(45, 174, 237), KeybindHeaderColor = Color3.fromRGB(112, 101, 255),
    HUDTransparency = 0.12, HUDScale = 1,
    HUDEditor = false, HUDSnap = true, HUDSnapDistance = 12, HUDKillHold = 1.5,
    ThemeProfile = "LarpHub", Language = "English", ModuleNotifications = true, AutoSave = true,
    TargetHighlight = false, TargetHighlightColor = Color3.fromRGB(28,190,255), TargetHighlightTransparency = 0.45,
    Hitmarker = false, HitmarkerColor = Color3.fromRGB(120,225,255), HitmarkerDuration = 0.28, HitmarkerSize = 8,
    HitSound = false, HitSoundStyle = "Ping", HitSoundAsset = "", HitSoundVolume = 0.5, HitSoundPitch = 1,
    DamageIndicators = false, DamageColor = Color3.fromRGB(28,190,255), DamageLifetime = 0.9, DamageUnits = "HP",
    ViewModel = false, FreeLookKey = "V",
    Crosshair = false, CrosshairColor = Color3.fromRGB(255, 255, 255),
    CrosshairGap = 5, CrosshairLength = 8, CrosshairThickness = 1.5,
    CrosshairDot = true, CrosshairRotate = false,
    Particles = false, ParticleColor = Color3.fromRGB(28, 190, 255), ParticleRainbow = false,
    ParticleCount = 28, ParticleStyle = "Energy",
    ChinaHat = false, HatColor = Accent, HatRainbow = true, HatRadius = 2,
    HatHeight = 0.8, HatOpacity = 0.65, HatFirstPerson = false,
    Amb = false, AmbientColor = Color3.fromRGB(150, 120, 200),
    OutdoorColor = Color3.fromRGB(170, 145, 210), Brightness = 2, ClockTime = 14,
    NoFog = true,
}

local State = {
    Config = Config, Alive = true, Connections = {}, Bindings = {}, Hooks = {},
    Drawings = {}, Overlays = {}, Bursts = {}, Errors = {}, HiddenCrosshairs = {},
    Stats = { Attacks = 0, ConfirmedHits = 0, BlockedKnockback = 0, PhysicsTicks = 0 },
    FreeLook = nil, AspectCamera = nil, AspectBase = nil, AmbientOriginal = nil,
    FOVCamera = nil, FOVBase = nil,
    DamageEntries = {}, Sounds = {}, ConfigName = "default", DirtyAt = nil,
    SpeedLimit = MaxSpeedMultiplier,
}
Env.__LarpHubUpgradePerKill = State

local function speedMultiplier()
    Config.SpeedMultiplier=clampSpeed(Config.SpeedMultiplier)
    return Config.SpeedMultiplier
end
function State:GetSpeedMultiplier() return speedMultiplier() end

local function connect(signal, fn)
    local connection = signal:Connect(fn)
    table.insert(State.Connections, connection)
    return connection
end

local function guarded(name, fn)
    return function(...)
        if not State.Alive then return end
        local ok, err = xpcall(fn, debug.traceback, ...)
        if not ok and not State.Errors[name] then
            State.Errors[name] = tostring(err)
            warn("[LarpHub/UpgradePerKill/" .. name .. "] " .. tostring(err))
        end
    end
end

local function bind(name, priority, fn)
    name = "LarpHub_UPK_" .. name
    table.insert(State.Bindings, name)
    Run:BindToRenderStep(name, priority, guarded(name, fn))
end

local function hook(owner, key, factory)
    local original = owner[key]
    local replacement = factory(original)
    table.insert(State.Hooks, { Owner = owner, Key = key, Original = original, Replacement = replacement })
    owner[key] = replacement
    return original
end

local function drawing(kind, properties)
    local object = Drawing.new(kind)
    State.Drawings[object] = true
    object.Visible = false
    for key, value in pairs(properties or {}) do object[key] = value end
    return object
end

local function removeDrawing(object)
    if not State.Drawings[object] then return end
    State.Drawings[object] = nil
    pcall(function() object:Remove() end)
end

function State:MarkConfigDirty()
    if self.Ready and not self.LoadingConfig and not self.SuppressPersistence then self.DirtyAt=os.clock() end
end

local function restoreAspect()
    if State.AspectCamera and State.AspectBase then
        pcall(function() State.AspectCamera.CFrame = State.AspectBase end)
    end
    State.AspectCamera, State.AspectBase = nil, nil
end

local function restoreFOV()
    if State.FOVCamera and State.FOVBase then
        pcall(function() State.FOVCamera.FieldOfView = State.FOVBase end)
    end
    State.FOVCamera, State.FOVBase = nil, nil
end

local function stopFreeLook()
    local saved = State.FreeLook
    if not saved then return end
    State.FreeLook = nil
    CameraController.setPerspective(saved.Perspective)
    Movement.setMoveYaw(nil)
    GameInput.setFreeLook(saved.FreeLook)
end

local function restoreAmbient()
    if not State.AmbientOriginal then return end
    for property, value in pairs(State.AmbientOriginal) do Lighting[property] = value end
    State.AmbientOriginal = nil
end

local function restoreNativeCrosshairs()
    for object, saved in pairs(State.HiddenCrosshairs) do

        if object.Parent == saved.Holder and saved.Parent.Parent then object.Parent = saved.Parent end
        saved.Holder:Destroy()
    end
    table.clear(State.HiddenCrosshairs)
end

local function syncNativeCrosshair()
    if not Config.Crosshair then restoreNativeCrosshairs(); return end
    for object, saved in pairs(State.HiddenCrosshairs) do
        if not object.Parent or not saved.Holder.Parent then
            saved.Holder:Destroy()
            State.HiddenCrosshairs[object] = nil
        end
    end
    local playerGui = Player:FindFirstChildOfClass("PlayerGui")
    local hud = playerGui and playerGui:FindFirstChild("Hud")
    local canvas = hud and hud:FindFirstChild("Canvas")
    local native = canvas and canvas:FindFirstChild("Crosshair")
    if not native or not native:IsA("GuiObject") then return end

    local holder = Instance.new("Frame")
    holder.Name = "LarpHub_NativeCrosshairHidden"
    holder.BackgroundTransparency = 1
    holder.Size = UDim2.fromScale(1, 1)
    holder.Visible = false
    holder.Parent = canvas
    State.HiddenCrosshairs[native] = { Parent = canvas, Holder = holder }
    native.Parent = holder
end

function State:Unload()
    if not self.Alive then return end
    if self.Ready and Config.AutoSave and self.DirtyAt and not self.SuppressPersistence and self.SaveConfig then
        pcall(function() self:SaveConfig(self.ConfigName) end)
    end
    self.Alive = false
    for _, name in ipairs(self.Bindings) do Run:UnbindFromRenderStep(name) end
    for _, connection in ipairs(self.Connections) do connection:Disconnect() end
    pcall(stopFreeLook)
    pcall(restoreAspect)
    pcall(restoreFOV)
    pcall(restoreAmbient)
    pcall(restoreNativeCrosshairs)
    for index = #self.Hooks, 1, -1 do
        local entry = self.Hooks[index]
        if entry.Owner[entry.Key] == entry.Replacement then entry.Owner[entry.Key] = entry.Original end
    end
    for object in pairs(self.Drawings) do pcall(function() object:Remove() end) end
    table.clear(self.Drawings)
    for attachment in pairs(self.Bursts) do pcall(function() attachment:Destroy() end) end
    for sound in pairs(self.Sounds) do pcall(function() sound:Destroy() end) end
    if self.Folder then self.Folder:Destroy() end
    if self.OverlayGui then self.OverlayGui:Destroy() end
    if Env.__LarpHubUpgradePerKill == self then Env.__LarpHubUpgradePerKill = nil end
    if self.Library and not self.Library.Unloaded then self.Library:Unload() end
    print("[LarpHub/UpgradePerKill] Unloaded; movement, camera and lighting restored.")
end

local function health(character)
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return 0, 1 end
    local value, maximum = character:GetAttribute("Health"), character:GetAttribute("MaxHealth")
    return type(value) == "number" and value or humanoid.Health,
        type(maximum) == "number" and maximum or humanoid.MaxHealth
end

local function alive(character)
    return character and character.Parent and character:GetAttribute("Zone") ~= "Dead"
        and character:FindFirstChild("HumanoidRootPart") and health(character) > 0
end

local function sameTeam(other)
    return not Player.Neutral and not other.Neutral and Player.Team ~= nil and Player.Team == other.Team
end

local function getWorld()
    if WorldRenderer.isReady() then return WorldRenderer.getWorld() end
end

local function clearPath(from, to)
    local world = getWorld()
    local delta = (to - from) / BlockSize
    if not world or delta.Magnitude < 0.01 then return true end

    local start = from / BlockSize
    local steps = math.min(160, math.ceil(delta.Magnitude * 4))
    for index = 1, steps - 1 do
        local position = start + delta * (index / steps)
        if Blocks.isSolid(world:get(math.floor(position.X), math.floor(position.Y), math.floor(position.Z))) then
            return false
        end
    end
    return true
end

local function nearestTarget(range, from)
    local character = Player.Character
    if not alive(character) then return end
    from = from or character.HumanoidRootPart.Position
    local selected, distance = nil, range
    for _, other in ipairs(Players:GetPlayers()) do
        local target = other.Character
        if other ~= Player and alive(target) and not (Config.TeamCheck and sameTeam(other)) then
            local separation = (target.HumanoidRootPart.Position - from).Magnitude
            if separation <= distance and (not Config.WallCheck or clearPath(from, target.HumanoidRootPart.Position)) then
                selected, distance = target, separation
            end
        end
    end
    return selected, distance
end

local function loadGui()
    local Environment = type(getgenv) == "function" and getgenv() or _G
    local Player = game:GetService("Players").LocalPlayer
    local RunService = game:GetService("RunService")
    local TweenService = game:GetService("TweenService")
    local Input = game:GetService("UserInputService")
    local function download(url)
        return game:HttpGet(url)
    end
    local function createLarpHub()
        local brand={Name="LarpHub",Version="1.0.0",Accent=Color3.fromRGB(167,110,255)}
        local lib=assert(loadstring(download("https://raw.githubusercontent.com/deividcomsono/Obsidian/bdaa9b8f555ed5ff1c4d87bb2d7339babe874e6f/Library.lua"),"LarpHub.Obsidian"))()
        local previous=Environment.__LarpHubInstance
        if previous and not previous.Unloaded then pcall(function() previous:Unload() end) end
        lib.ScreenGui.Name="LarpHub"
        lib.Scheme.BackgroundColor=Color3.fromRGB(17,12,27)
        lib.Scheme.MainColor=Color3.fromRGB(29,21,43)
        lib.Scheme.OutlineColor=Color3.fromRGB(66,45,91)
        lib.Scheme.FontColor=Color3.fromRGB(245,237,255)
        lib.Scheme.AccentColor=brand.Accent
        local function updateButtonColors(accent)
            local hue,saturation=accent:ToHSV()
            lib.Scheme.LarpHubButtonColor=Color3.fromHSV(hue,math.max(saturation,0.55),0.60)
            lib.Scheme.LarpHubButtonHoverColor=Color3.fromHSV(hue,math.max(saturation,0.55),0.72)
        end
        updateButtonColors(brand.Accent)
        lib:SetFont(Enum.Font.GothamMedium);lib:UpdateColorsUsingRegistry()
        local window=lib:CreateWindow({Title=brand.Name,Footer="LarpHub  •  v"..brand.Version,
            Icon="mountain",IconSize=UDim2.fromOffset(32,32),Font=Enum.Font.GothamMedium,
            Center=true,AutoShow=true,Size=UDim2.fromOffset(820,560),Resizable=true,CornerRadius=10,
            ToggleKeybind=Enum.KeyCode.RightShift,ShowMobileButtons=true,MobileButtonsSide="Left",
            ShowCustomCursor=false,NotifySide="Right",EnableSidebarResize=true,MinSidebarWidth=180,
            Animations={ToggleWindow=true,TabSwitch=true,Groupbox=true,Dropdown=true,KeyPicker=true},
            TabButtonsStyle={Gap=5,Padding=8,CornerRadius=7,Indicator=true}})
        local tabs={Main=window:AddTab("Home","house","Welcome to LarpHub"),
            Settings=window:AddTab("Settings","settings","Appearance and menu controls")}
        local watermark=lib:AddDraggableLabel("LarpHub │ -- FPS │ -- ms","mountain","Left")
        watermark:SetVisible(true)
        local watermarkLabel=watermark.Label
        watermarkLabel.Name="LarpHubWatermark"
        watermarkLabel.Position=UDim2.fromOffset(16,16);watermarkLabel.TextSize=14;watermarkLabel.Active=true
        watermarkLabel.RichText=true;watermarkLabel.BackgroundTransparency=0.06
        lib:AddToRegistry(watermarkLabel,{BackgroundColor3="MainColor",TextColor3="FontColor"})
        local padding=watermarkLabel:FindFirstChildOfClass("UIPadding")
        if padding then
            padding.PaddingLeft=UDim.new(0,44);padding.PaddingRight=UDim.new(0,14)
            padding.PaddingTop=UDim.new(0,10);padding.PaddingBottom=UDim.new(0,10)
        end
        local outline=watermarkLabel:FindFirstChildOfClass("UIStroke")
        if outline then
            outline.Thickness=1;outline.Transparency=0.15;lib:AddToRegistry(outline,{Color="AccentColor"})
        end
        for _,item in ipairs(watermarkLabel:GetChildren()) do
            if item:IsA("ImageLabel") then
                item.Size=UDim2.fromOffset(26,26);item.Position=UDim2.new(0,-34,0.5,0)
                lib:AddToRegistry(item,{ImageColor3="AccentColor"})
            end
        end
        local pressed
        lib:GiveSignal(watermarkLabel.InputBegan:Connect(function(input)
            if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
                pressed={Input=input,Position=Vector2.new(input.Position.X,input.Position.Y),Label=watermarkLabel.AbsolutePosition,Dragged=false}
            end
        end))
        lib:GiveSignal(Input.InputChanged:Connect(function(input)
            if pressed and (input==pressed.Input or input.UserInputType==Enum.UserInputType.MouseMovement)
                and (Vector2.new(input.Position.X,input.Position.Y)-pressed.Position).Magnitude>6 then pressed.Dragged=true end
        end))
        lib:GiveSignal(Input.InputEnded:Connect(function(input)
            if pressed and input==pressed.Input then
                if not pressed.Dragged and input.UserInputState~=Enum.UserInputState.Cancel
                    and (Vector2.new(input.Position.X,input.Position.Y)-pressed.Position).Magnitude<=6
                    and (watermarkLabel.AbsolutePosition-pressed.Label).Magnitude<=6 then window:Toggle() end
                pressed=nil
            end
        end))
        lib:GiveSignal(Input.WindowFocusReleased:Connect(function() pressed=nil end))
        local function updateWatermark(fps)
            local ok,ping=pcall(function() return game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue() end)
            if not ok or type(ping)~="number" then ok,ping=pcall(function() return Player:GetNetworkPing()*1000 end) end
            local sep=' <font color="#9E87B8">│</font> '
            local text='<font color="#'..lib.Scheme.AccentColor:ToHex()..'"><b>LarpHub</b></font>'
                ..sep..fps..' <font color="#CBB5E3">FPS</font>'
                ..sep..(ok and type(ping)=="number" and tostring(math.floor(ping+0.5)) or "--")..' <font color="#CBB5E3">ms</font>'
            local camera=workspace.CurrentCamera
            watermark:SetText(text)
        end
        updateWatermark("--")
        local elapsed,frames=0,0
        lib:GiveSignal(RunService.RenderStepped:Connect(function(dt)
            if lib.Unloaded or watermark.Destroyed then return end
            elapsed+=dt;frames+=1
            if elapsed>=1 then
                updateWatermark(tostring(math.floor(frames/elapsed+0.5)))
                elapsed,frames=0,0
            end
        end))
        local function brandNotify(text) lib:Notify({Title=brand.Name,Description=text,Time=4,Icon="mountain"}) end
        local welcome
        local function showWelcome()
            if welcome then welcome:Dismiss() end
            welcome=window:AddDialog("LarpHubWelcome",{Title=brand.Name,Icon="mountain",
                Description="Welcome to LarpHub",AutoDismiss=false,OutsideClickDismiss=false,
                FooterButtons={Continue={Title="Open LarpHub",Variant="Secondary",Order=1,
                    Callback=function() if welcome then welcome:Dismiss();welcome=nil end end}}})
            welcome:AddLabel("Thanks for using LarpHub.",true)
            lib:UpdateColorsUsingRegistry()
        end
        local home=tabs.Main:AddLeftGroupbox("LarpHub","mountain")
        home:AddLabel("Welcome to LarpHub!",true)
        home:AddDivider()
        home:AddButton({Text="Show welcome",Func=showWelcome})
        local main=tabs.Main:AddRightGroupbox("LarpHub menu","layout-dashboard")
        main:AddLabel("Version: "..brand.Version,true)
        main:AddLabel("Toggle menu: RightShift. On mobile, use the menu button.",true)
        main:AddDivider()
        main:AddLabel("Use the Combat, Movement and Visuals tabs for +1 Upgrade Per Kill features.",true)
        main:AddButton({Text="Test notification",Func=function() brandNotify("LarpHub is ready!") end})
        local settings=tabs.Settings:AddLeftGroupbox("Interface","sliders-horizontal")
        settings:AddLabel("Menu key"):AddKeyPicker("LarpHubMenuKey",{Default="RightShift",NoUI=true,Text="LarpHub menu"})
        lib.ToggleKeybind=lib.Options.LarpHubMenuKey
        settings:AddToggle("LarpHubWatermarkVisible",{Text="Show watermark",Default=true,Callback=function(v) watermark:SetVisible(v) end})
        settings:AddToggle("LarpHubCursor",{Text="Custom cursor",Default=false,Callback=function(v) lib.ShowCustomCursor=v end})
        settings:AddDropdown("LarpHubScale",{Text="Interface scale",Values={"75%","100%","125%","150%"},Default="100%",
            Callback=function(v) lib:SetDPIScale(tonumber((v:gsub("%%","")))) end})
        settings:AddLabel("LarpHub accent"):AddColorPicker("LarpHubAccent",{Default=brand.Accent,Title="LarpHub color",
            Callback=function(v) lib.Scheme.AccentColor=v;updateButtonColors(v);lib:UpdateColorsUsingRegistry() end})
        settings:AddDivider()
        settings:AddButton({Text="Unload LarpHub",Func=function() lib:Unload() end})
        local about=tabs.Settings:AddRightGroupbox("About LarpHub","info")
        about:AddLabel("LarpHub • v"..brand.Version,true)
        lib.LarpHubWindow=window;lib.LarpHubTabs=tabs;lib.LarpHubWatermark=watermark;lib.LarpHubShowWelcome=showWelcome
        lib.LarpHubBrand=brand
        lib:OnUnload(function()
            watermark:Destroy()
            if Environment.__LarpHubInstance==lib then Environment.__LarpHubInstance=nil end
        end)
        Environment.__LarpHubInstance=lib
        showWelcome()
        return lib
    end

    return createLarpHub()
end

local function setup()
    local Library = loadGui()
    State.Library = Library
    Library:OnUnload(function() State:Unload() end)
    local Window = Library.LarpHubWindow
    local Options = Library.Options
    local localized={}
    local replacements={}
    local exact={}
    for english,russian in pairs(LocaleStrings) do
        exact[english]=russian
        table.insert(replacements,{Source=english,Value=russian})
    end
    table.sort(replacements,function(a,b) return #a.Source>#b.Source end)
    function State:Translate(text)
        if type(text)~="string" or Config.Language~="Русский" then return text end
        if exact[text] then return exact[text] end
        local result=text
        for _,entry in ipairs(replacements) do
            if result:find(entry.Source,1,true) then
                local pattern=entry.Source:gsub("([^%w])","%%%1")
                if entry.Source:match("^%a+$") then pattern="%f[%w]"..pattern.."%f[%W]" end
                result=result:gsub(pattern,function() return entry.Value end)
            end
        end
        return result
    end
    local function localizeObject(object)
        if not State.Alive or localized[object] or object:GetAttribute("LarpHubNoTranslate") then return end
        local property=(object:IsA("TextLabel") or object:IsA("TextButton")) and "Text" or object:IsA("TextBox") and "PlaceholderText"
        if not property then return end
        local entry={Source=object[property],Property=property}
        localized[object]=entry
        local function update()
            if entry.Applying or not State.Alive or object:GetAttribute("LarpHubNoTranslate") then return end
            entry.Output=State:Translate(entry.Source)
            if object[property]~=entry.Output then
                entry.Applying=true
                object[property]=entry.Output
                entry.Applying=false
            end
        end
        entry.Update=update
        connect(object:GetPropertyChangedSignal(property),function()
            if entry.Applying or not State.Alive then return end
            local text=object[property]
            if text==entry.Output then return end
            entry.Source=text
            update()
        end)
        connect(object.Destroying,function() localized[object]=nil end)
        update()
    end
    function State:LocalizeTree(root)
        for _,object in ipairs(root:GetDescendants()) do localizeObject(object) end
        connect(root.DescendantAdded,function(object)
            task.defer(function() if State.Alive and object.Parent then localizeObject(object) end end)
        end)
    end
    function State:SetLanguage(language)
        assert(language=="English" or language=="Русский","Unknown language")
        Config.Language=language
        for _,entry in pairs(localized) do entry.Update() end
        if Options.UPK_Language and Options.UPK_Language.Value~=language then Options.UPK_Language:SetValue(language) end
        self:MarkConfigDirty()
    end
    State:LocalizeTree(Library.ScreenGui)
    local function notify(text)
        Library:Notify({ Title = "+1 Upgrade Per Kill", Description = text, Time = 5 })
    end

    local storageRoot="LarpHub/UpgradePerKill"
    local storageFolder=storageRoot.."/configs"
    local function storage()
        assert(type(writefile)=="function" and type(readfile)=="function" and type(isfile)=="function"
            and type(isfolder)=="function" and type(makefolder)=="function","Executor file API unavailable")
        for _,path in ipairs({"LarpHub",storageRoot,storageFolder}) do if not isfolder(path) then makefolder(path) end end
    end
    local function profileName(name)
        assert(type(name)=="string","Config name must be a string")
        name=name:match("^%s*(.-)%s*$")
        assert(#name>0 and #name<=64 and not name:find('[\\/:*?"<>|%.%c]'),"Invalid config name")
        return name
    end
    local function encodeValue(value)
        if typeof(value)=="Color3" then return {Type="Color3",R=value.R,G=value.G,B=value.B} end
        return value
    end
    local function finite(value)
        return type(value)=="number" and value==value and math.abs(value)<math.huge
    end
    local function decodeValue(value,expected)
        if typeof(expected)=="Color3" then
            assert(type(value)=="table" and value.Type=="Color3" and finite(value.R) and finite(value.G) and finite(value.B),"Invalid color")
            return Color3.new(math.clamp(value.R,0,1),math.clamp(value.G,0,1),math.clamp(value.B,0,1))
        end
        assert(type(value)==type(expected),"Invalid setting type")
        if type(value)=="number" then assert(finite(value),"Invalid setting number") end
        return value
    end
    function State:ExportConfig()
        speedMultiplier()
        local result={Version=1,Settings={},Binds={},Positions={},UI={}}
        for key,value in pairs(Config) do
            if key=="HUDEditor" then result.Settings[key]=false else result.Settings[key]=encodeValue(value) end
        end
        for key,option in pairs(Options) do
            if option.Type=="KeyPicker" and (key:sub(1,4)=="UPK_" or key=="LarpHubMenuKey") then
                local modifiers={}
                for _,modifier in ipairs(option.Modifiers or {}) do table.insert(modifiers,typeof(modifier)=="EnumItem" and modifier.Name or tostring(modifier)) end
                result.Binds[key]={Key=option.Value,Mode=option.Mode,Modifiers=modifiers}
            end
        end
        if self.HUD then
            for key,frame in pairs({Target=self.HUD.TargetFrame,Keys=self.HUD.KeysFrame}) do
                local p=frame.Position
                result.Positions[key]={p.X.Scale,p.X.Offset,p.Y.Scale,p.Y.Offset}
            end
        end
        for _,key in ipairs({"LarpHubScale","LarpHubAccent","LarpHubWatermarkVisible","LarpHubCursor"}) do
            local control=Options[key] or Library.Toggles[key]
            if control then result.UI[key]=encodeValue(control.Value) end
        end
        return result
    end
    function State:ApplySetting(key,value)
        if key=="SpeedMultiplier" then value=clampSpeed(value) end
        local toggle=Library.Toggles["UPK_"..key]
        local option=Options["UPK_"..key]
        if toggle then toggle:SetValue(value)
        elseif option and option.Type=="ColorPicker" then option:SetValueRGB(value)
        elseif option and option.Type~="KeyPicker" then option:SetValue(value)
        else Config[key]=value end
    end
    function State:ApplyConfig(data)
        assert(type(data)=="table" and data.Version==1 and type(data.Settings)=="table","Unsupported config format")
        local settings,binds,positions,interface={},{},{},{}
        for key,value in pairs(data.Settings) do
            if Config[key]~=nil and key~="HUDEditor" then
                local decoded=decodeValue(value,Config[key])
                local option=Options["UPK_"..key]
                if option and option.Type=="Slider" then decoded=math.clamp(decoded,option.Min,option.Max) end
                if option and option.Type=="Dropdown" then assert(table.find(option.Values,decoded),"Invalid dropdown value: "..key) end
                settings[key]=decoded
            end
        end
        assert(data.Binds==nil or type(data.Binds)=="table","Invalid keybind section")
        for key,value in pairs(data.Binds or {}) do
            local picker=Options[key]
            if picker and picker.Type=="KeyPicker" and (key:sub(1,4)=="UPK_" or key=="LarpHubMenuKey") then
                assert(type(value)=="table" and type(value.Key)=="string","Invalid keybind")
                local valid=value.Key=="None" or value.Key=="MB1" or value.Key=="MB2" or value.Key=="MB3"
                if not valid then valid=pcall(function() assert(Enum.KeyCode[value.Key]) end) end
                assert(valid and table.find({"Hold","Toggle","Always","Press"},value.Mode),"Invalid keybind mode/key")
                local modifiers={}
                assert(value.Modifiers==nil or type(value.Modifiers)=="table","Invalid modifiers")
                local aliases={LeftControl="LCtrl",RightControl="RCtrl",LeftShift="LShift",RightShift="RShift",LeftAlt="LAlt",RightAlt="RAlt"}
                for _,name in ipairs(value.Modifiers or {}) do
                    assert(type(name)=="string","Invalid modifier")
                    local modifier=aliases[name] or name
                    assert(table.find({"LCtrl","RCtrl","LShift","RShift","LAlt","RAlt"},modifier),"Invalid modifier")
                    table.insert(modifiers,modifier)
                end
                binds[key]={value.Key,key=="UPK_FreeLookKey" and "Hold" or value.Mode,modifiers}
            end
        end
        assert(data.Positions==nil or type(data.Positions)=="table","Invalid HUD positions")
        for key,value in pairs(data.Positions or {}) do
            if key=="Target" or key=="Keys" then
                assert(type(value)=="table" and #value==4,"Invalid HUD position")
                for _,number in ipairs(value) do assert(finite(number),"Invalid HUD coordinate") end
                positions[key]=UDim2.new(math.clamp(value[1],-1,2),value[2],math.clamp(value[3],-1,2),value[4])
            end
        end
        assert(data.UI==nil or type(data.UI)=="table","Invalid UI settings")
        for _,key in ipairs({"LarpHubScale","LarpHubAccent","LarpHubWatermarkVisible","LarpHubCursor"}) do
            local control=Options[key] or Library.Toggles[key]
            if control and data.UI and data.UI[key]~=nil then
                local value=decodeValue(data.UI[key],control.Value)
                if control.Type=="Dropdown" then assert(table.find(control.Values,value),"Invalid UI scale") end
                interface[key]=value
            end
        end
        self.LoadingConfig=true
        local ok,err=xpcall(function()
            if settings.ThemeProfile then self:ApplySetting("ThemeProfile",settings.ThemeProfile) end
            for key,value in pairs(binds) do Options[key]:SetValue(value) end
            for key,value in pairs(settings) do if key~="ThemeProfile" then self:ApplySetting(key,value) end end
            for key,value in pairs(interface) do
                local control=Options[key] or Library.Toggles[key]
                if control.Type=="ColorPicker" then control:SetValueRGB(value) else control:SetValue(value) end
            end
            if self.HUD then
                if positions.Target then self.HUD.TargetFrame.Position=positions.Target end
                if positions.Keys then self.HUD.KeysFrame.Position=positions.Keys end
                if self.ClampHUD then self:ClampHUD() end
            end
        end,debug.traceback)
        self.LoadingConfig=false
        assert(ok,err)
        return true
    end
    function State:SaveConfig(name)
        storage();name=profileName(name or self.ConfigName)
        writefile(storageFolder.."/"..name..".json",Http:JSONEncode(self:ExportConfig()))
        self.ConfigName,self.DirtyAt=name,nil
        if not isfile(storageRoot.."/autoload.json") then self:SetAutoload(name) end
        return name
    end
    function State:LoadConfig(name)
        storage();name=profileName(name or self.ConfigName)
        local path=storageFolder.."/"..name..".json"
        assert(isfile(path),"Config not found: "..name)
        self:ApplyConfig(Http:JSONDecode(readfile(path)))
        self.ConfigName,self.DirtyAt=name,nil
        return name
    end
    function State:SetAutoload(name)
        storage();name=profileName(name)
        assert(isfile(storageFolder.."/"..name..".json"),"Save the config first")
        writefile(storageRoot.."/autoload.json",Http:JSONEncode({Version=1,Name=name}))
    end
    function State:ListConfigs()
        storage()
        local names={}
        if type(listfiles)=="function" then
            for _,path in ipairs(listfiles(storageFolder)) do
                local name=path:match("([^/\\]+)%.json$")
                if name then table.insert(names,name) end
            end
        end
        table.sort(names)
        if #names==0 then table.insert(names,"default") end
        return names
    end
    function State:DeleteConfig(name)
        storage();name=profileName(name)
        assert(type(delfile)=="function","Executor cannot delete files")
        local path=storageFolder.."/"..name..".json"
        if isfile(path) then delfile(path) end
        local meta=storageRoot.."/autoload.json"
        if isfile(meta) then
            local ok,data=pcall(function() return Http:JSONDecode(readfile(meta)) end)
            if ok and data.Name==name then delfile(meta) end
        end
        if self.ConfigName==name then self.ConfigName="default" end
    end

    local folder = Instance.new("Folder")
    folder.Name = "LarpHubUpgradePerKill_Visuals"
    folder.Parent = workspace
    State.Folder = folder

    hook(Movement, "setMotion", function(original)
        return function(vector)
            if State.Alive and Config.AntiKnockBack then
                State.Stats.BlockedKnockback += 1
                return
            end
            return original(vector)
        end
    end)
    hook(Movement, "addMotion", function(original)
        return function(vector)
            if State.Alive and Config.AntiKnockBack then
                State.Stats.BlockedKnockback += 1
                return
            end
            return original(vector)
        end
    end)
    hook(Movement, "setLook", function(original)
        return function(yaw, pitch)
            local saved = State.FreeLook
            if saved and State.Alive then return original(saved.Yaw, saved.Pitch) end
            return original(yaw, pitch)
        end
    end)
    hook(Movement, "setMoveYaw", function(original)
        return function(yaw)
            if State.FreeLook and State.Alive then return original(State.FreeLook.Yaw) end
            return original(yaw)
        end
    end)
    local speedPerLevel = GameConfig.Physics.Detail.SpeedPerLevel
    hook(Physics, "setEffects", function(original)
        return function(state, speed, slow, jump)
            if State.Alive and Config.Speed and state == Movement.getState() then
                speed = ((1 + speed * speedPerLevel) * speedMultiplier() - 1) / speedPerLevel
            end
            return original(state, speed, slow, jump)
        end
    end)

    local function applyAirSpeed(state, input)
        if not Config.Speed or not Config.SpeedAir or state.onGround
            or state.inWater or state.inLava or state.inWeb or state.onLadder then return end
        local physics = GameConfig.Physics
        local factor = physics.InputDamping
        if input.sneak then factor *= physics.SneakInputMultiplier end
        if state.usingItem then factor *= physics.UseItemInputMultiplier end
        local forward = math.clamp(input.forward,-1,1)*factor
        local strafe = math.clamp(input.strafe,-1,1)*factor
        local magnitudeSq = forward*forward+strafe*strafe
        if magnitudeSq < physics.Detail.MoveInputMinSq then return end

        local acceleration = state.sprinting and physics.SprintAirAcceleration or physics.AirAcceleration
        local extra = acceleration*(speedMultiplier()-1)/math.max(1,math.sqrt(magnitudeSq))
        local sine, cosine = math.sin(input.yaw), math.cos(input.yaw)
        state.motion += Vector3.new((strafe*cosine-forward*sine)*extra, 0,
            (-strafe*sine-forward*cosine)*extra)
    end

    local strafeSign, lastReverse = 1, 0
    hook(Physics, "step", function(original)
        return function(state, input, world)
            if not State.Alive or state ~= Movement.getState() then return original(state, input, world) end
            State.Stats.PhysicsTicks += 1
            if not alive(Player.Character) or ClientState.menuOpen or UIS:GetFocusedTextBox() then
                return original(state, input, world)
            end

            if Config.TargetStrafe then
                local target = State.StrafeTarget
                local now = os.clock()
                if not alive(target) or now >= (State.StrafeTargetNext or 0) then
                    target = nearestTarget(Config.StrafeRange)
                    State.StrafeTarget, State.StrafeTargetNext = target, now+0.15
                end
                if target then
                    local displacement = state.pos * BlockSize - target.HumanoidRootPart.Position
                    local radial = Vector3.new(displacement.X, 0, displacement.Z)
                    if radial.Magnitude < 0.01 then radial = Vector3.new(0, 0, 1) end
                    local distance = radial.Magnitude
                    radial = radial.Unit
                    local sign = Config.StrafeDirection == "Right" and strafeSign or -strafeSign
                    local tangent = Vector3.new(-radial.Z, 0, radial.X) * sign
                    local errorRadius = math.clamp((Config.StrafeRadius-distance) / 3, -1.5, 1.5)
                    local direction = (tangent + radial * errorRadius).Unit
                    if State.StrafeVector then
                        local smooth = State.StrafeVector:Lerp(direction,0.4)
                        if smooth.Magnitude > 0.01 then direction = smooth.Unit end
                    end
                    State.StrafeVector = direction
                    if state.collidedHorizontally and os.clock()-lastReverse > 0.4 then
                        strafeSign = -strafeSign
                        lastReverse = os.clock()
                    end
                    input.yaw = math.atan2(-direction.X, -direction.Z)
                    input.forward, input.strafe = 1, 0
                    if Config.StrafeJump and state.onGround then input.jump = true end
                end
            else
                State.StrafeTarget, State.StrafeVector = nil, nil
            end
            if Config.AutoSprint and input.forward > 0 then input.sprint = true end
            if Config.AutoJump and state.onGround and not input.sneak and not state.inWater
                and not state.inLava and not state.inWeb and not state.onLadder
                and input.forward*input.forward+input.strafe*input.strafe>0.01 then
                input.jump=true
            end
            applyAirSpeed(state,input)
            return original(state, input, world)
        end
    end)

    local attackRemote = assert(Remotes:FindFirstChild("Attack"), "Attack remote not found")
    local swingRemote = Remotes:FindFirstChild("Swing")
    local lastAttack, attackCount = 0, 0
    local function auraTick()
        if not Config.KillAura or os.clock()-lastAttack < Config.AuraCooldown then return end
        local character = Player.Character
        if not alive(character) then return end
        local eyePosition = character.HumanoidRootPart.Position / 3 + Vector3.new(0, 0.72, 0)
        local closestTarget, closestDistance = nil, Config.AuraRange
        for _, other in ipairs(Players:GetPlayers()) do
            local target = other.Character
            if other ~= Player and alive(target) and not (Config.TeamCheck and sameTeam(other)) then
                local targetPosition = target.HumanoidRootPart.Position / 3
                local distance = (targetPosition-eyePosition).Magnitude
                if distance <= closestDistance
                    and (not Config.WallCheck or clearPath(eyePosition*3, targetPosition*3)) then
                    closestTarget, closestDistance = target, distance
                end
            end
        end
        State.AuraTarget = closestTarget
        if not closestTarget then return end
        local delta = closestTarget.HumanoidRootPart.Position / 3 - eyePosition
        if delta.Magnitude < 0.001 then return end
        lastAttack = os.clock()
        attackCount += 1
        if swingRemote then swingRemote:FireServer() end
        attackRemote:FireServer(closestTarget, {
            sprint = false, charge = 1, vt = workspace:GetServerTimeNow(),
            dir = delta.Unit, eye = eyePosition, t = workspace.DistributedGameTime,
            crit = true, n = attackCount,
        })
        State.Stats.Attacks += 1
    end
    connect(Run.Heartbeat, guarded("KillAura", auraTick))

    local function burst(character)
        local root = character and character:FindFirstChild("HumanoidRootPart")
        if not root then return end
        local function at(position)
            local attachment = Instance.new("Attachment")
            attachment.Name = "LarpHub_HitParticles"
            attachment.Position = position
            attachment.Parent = root
            State.Bursts[attachment] = true
            Debris:AddItem(attachment,1)
            task.delay(1,function() State.Bursts[attachment]=nil end)
            return attachment
        end
        local color = Config.ParticleRainbow and Color3.fromHSV(os.clock()*0.18%1,0.7,1) or Config.ParticleColor
        if Config.ParticleStyle == "Energy" then
            local count = math.clamp(math.floor(Config.ParticleCount/7),3,8)
            local phase = math.random()*math.pi*2
            for index=1,count do
                local angle=phase+index/count*math.pi*2
                local direction=Vector3.new(math.cos(angle),0,math.sin(angle))
                local attachment=at(direction*1.4+Vector3.new(0,math.random()*2.2-0.8,0))
                for _,layer in ipairs({{Size=2.6,Color=color},{Size=0.8,Color=Color3.fromRGB(220,255,255)}}) do
                    local orb=Instance.new("ParticleEmitter")
                    orb.Name="LarpHub_EnergyOrb"
                    orb.Texture="rbxasset://textures/particles/flare_main.dds"
                    orb.Color=ColorSequence.new(layer.Color)
                    orb.LightEmission,orb.LightInfluence=1,0
                    orb.Brightness=3
                    orb.Rate=0
                    orb.Lifetime=NumberRange.new(0.55)
                    orb.Speed=NumberRange.new(0)
                    orb.Acceleration=direction*6+Vector3.new(0,1.5,0)
                    orb.LockedToPart=false
                    orb.Orientation=Enum.ParticleOrientation.FacingCamera
                    orb.Size=NumberSequence.new({NumberSequenceKeypoint.new(0,0.2),NumberSequenceKeypoint.new(0.15,layer.Size),NumberSequenceKeypoint.new(0.65,layer.Size*0.85),NumberSequenceKeypoint.new(1,0)})
                    orb.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0.05),NumberSequenceKeypoint.new(0.6,0.15),NumberSequenceKeypoint.new(1,1)})
                    orb.Parent=attachment
                    orb:Emit(1)
                end
            end
            return
        end
        local attachment = at(Vector3.zero)
        local emitter = Instance.new("ParticleEmitter")
        emitter.Name = "LarpHub_HitBurst"
        emitter.Texture = Config.ParticleStyle == "Stars" and "rbxasset://textures/particles/sparkles_main.dds"
            or "rbxasset://textures/particles/flare_main.dds"
        emitter.Color = ColorSequence.new(color, color:Lerp(Color3.new(1,1,1), 0.7))
        emitter.LightEmission = 1
        emitter.LightInfluence = 0
        emitter.Rate = 0
        emitter.Lifetime = NumberRange.new(0.35, 0.7)
        emitter.Speed = NumberRange.new(8, 17)
        emitter.Drag = 4
        emitter.SpreadAngle = Vector2.new(180, 180)
        emitter.Rotation = NumberRange.new(0, 360)
        emitter.RotSpeed = NumberRange.new(-180, 180)
        emitter.Acceleration = Vector3.new(0, -10, 0)
        emitter.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0,0.35), NumberSequenceKeypoint.new(1,0) })
        emitter.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0,0), NumberSequenceKeypoint.new(0.7,0.2), NumberSequenceKeypoint.new(1,1) })
        emitter.Parent = attachment
        emitter:Emit(Config.ParticleCount)
    end
    State.Burst = burst
    function State:PlayHitSound()
        if os.clock()-(self.LastSoundAt or 0)<0.05 then return end
        self.LastSoundAt=os.clock()
        local asset="rbxasset://sounds/electronicpingshort.wav"
        if Config.HitSoundStyle=="Custom" then
            local id=Config.HitSoundAsset:match("^%s*(%d+)%s*$") or Config.HitSoundAsset:match("^rbxassetid://(%d+)$")
            if not id then return end
            asset="rbxassetid://"..id
        end
        local sound=Instance.new("Sound")
        sound.Name="LarpHub_HitSound"
        sound.SoundId=asset
        sound.Volume=Config.HitSoundVolume
        local pitch=Config.HitSoundStyle=="Bell" and 0.75 or Config.HitSoundStyle=="Click" and 1.8 or 1.2
        sound.PlaybackSpeed=Config.HitSoundPitch*pitch
        sound.Parent=SoundService
        local count=0
        for previous in pairs(self.Sounds) do
            count+=1
            if count>=6 then previous:Destroy();self.Sounds[previous]=nil end
        end
        self.Sounds[sound]=true
        sound:Play()
        Debris:AddItem(sound,4)
        task.delay(4,function() self.Sounds[sound]=nil end)
    end
    function State:HandleConfirmedHit(packet,knownModel)
        if type(packet) ~= "table" then return end
        local character = Player.Character
        local id = character and character:GetAttribute("CombatantId")
        if not id or packet.attacker ~= id or packet.victim == id then return end
        if packet.dtype=="dummyReset" or packet.dtype=="fall" then return end
        State.Stats.ConfirmedHits += 1
        if Config.Hitmarker then
            self.HitmarkerUntil=os.clock()+Config.HitmarkerDuration
            self.HitmarkerKilled=packet.killed==true
        end
        if Config.HitSound then self:PlayHitSound() end
        local model=knownModel
        if not model then
            for _,candidate in pairs(Combat.getCombatants()) do
                if typeof(candidate)=="Instance" and candidate:GetAttribute("CombatantId")==packet.victim then model=candidate;break end
            end
        end
        if model then
            self.LastHitTarget,self.LastHitAt=model,os.clock()
            if packet.killed then self.LastKilledTarget,self.LastKillAt=model,os.clock() end
            if Config.Particles then burst(model) end
            local damage=packet.damage or packet.hpDamage
            if not finite(damage) and finite(packet.hearts) then damage=packet.hearts*2 end
            if finite(damage) and damage>0 and self.RecordDamage then self:RecordDamage(model,damage,packet.crit==true) end
        end
    end
    connect(Remotes.HitFx.OnClientEvent,guarded("HitFeedback",function(packet) State:HandleConfirmedHit(packet) end))

    local function removeOverlay(other)
        local overlay = State.Overlays[other]
        if not overlay then return end
        for _, object in ipairs(overlay.Objects) do removeDrawing(object) end
        overlay.Highlight:Destroy()
        State.Overlays[other] = nil
    end
    local function newOverlay(other)
        local overlay = { Objects = {} }
        local function add(key, kind, properties)
            overlay[key] = drawing(kind, properties)
            table.insert(overlay.Objects, overlay[key])
        end
        add("Outline", "Square", { Filled=false, Thickness=3, Color=Color3.new(0,0,0) })
        add("Box", "Square", { Filled=false, Thickness=1 })
        add("Name", "Text", { Center=true, Outline=true, Font=2 })
        add("Distance", "Text", { Center=true, Outline=true, Font=2 })
        add("HealthBack", "Line", { Thickness=4, Color=Color3.new(0,0,0) })
        add("Health", "Line", { Thickness=2 })
        add("Tracer", "Line", {})
        add("ArrowOutline", "Triangle", { Filled=false, Thickness=3, Color=Color3.new(0,0,0) })
        add("Arrow", "Triangle", { Filled=true })
        local highlight = Instance.new("Highlight")
        highlight.Name = "LarpHubESP_" .. other.UserId
        highlight.Enabled = false
        highlight.Parent = folder
        overlay.Highlight = highlight
        State.Overlays[other] = overlay
        return overlay
    end
    connect(Players.PlayerRemoving, removeOverlay)

    local crosshair, crossOutline = {}, {}
    for index = 1, 4 do
        crossOutline[index] = drawing("Line", { Color=Color3.new(0,0,0), ZIndex=20 })
        crosshair[index] = drawing("Line", { ZIndex=21 })
    end
    local crossDot = drawing("Circle", { Filled=true, Radius=1.5, NumSides=12, ZIndex=21 })
    local hitLines={}
    for index=1,4 do hitLines[index]=drawing("Line",{Thickness=2,ZIndex=25}) end
    local targetHighlight=Instance.new("Highlight")
    targetHighlight.Name="LarpHub_CurrentTarget"
    targetHighlight.Enabled=false
    targetHighlight.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
    targetHighlight.Parent=folder
    State.TargetHighlightObject=targetHighlight
    function State:RecordDamage(character,damage,critical)
        local root=character and character:FindFirstChild("HumanoidRootPart")
        if not Config.DamageIndicators or not root or not finite(damage) or damage<=0 then return end
        while #self.DamageEntries>=32 do removeDrawing(table.remove(self.DamageEntries,1).Drawing) end
        local amount=Config.DamageUnits=="Hearts" and damage/2 or damage
        local label=drawing("Text",{Center=true,Outline=true,Font=2,Size=critical and 21 or 17,ZIndex=30,
            Text=string.format("-%g%s",math.floor(amount*10+0.5)/10,Config.DamageUnits=="Hearts" and " ♥" or "")})
        table.insert(self.DamageEntries,{Drawing=label,Position=root.Position+Vector3.new(math.random()-0.5,Height*0.55,0),At=os.clock(),Lifetime=Config.DamageLifetime})
    end
    local function updateHitFeedback(camera)
        local now=os.clock()
        local remaining=(State.HitmarkerUntil or 0)-now
        for index,line in ipairs(hitLines) do
            line.Visible=Config.Hitmarker and remaining>0
            if line.Visible then
                local angle=math.pi/4+(index-1)*math.pi/2
                local direction=Vector2.new(math.cos(angle),math.sin(angle))
                line.From=camera.ViewportSize/2+direction*5
                line.To=camera.ViewportSize/2+direction*(5+Config.HitmarkerSize)
                line.Color=State.HitmarkerKilled and Color3.fromRGB(255,205,85) or Config.HitmarkerColor
                line.Transparency=math.clamp(remaining/Config.HitmarkerDuration,0,1)
            end
        end
        for index=#State.DamageEntries,1,-1 do
            local entry=State.DamageEntries[index]
            local progress=(now-entry.At)/entry.Lifetime
            if progress>=1 or not Config.DamageIndicators then
                removeDrawing(entry.Drawing);table.remove(State.DamageEntries,index)
            else
                local point,onScreen=camera:WorldToViewportPoint(entry.Position+Vector3.new(0,progress*2.5,0))
                entry.Drawing.Visible=onScreen and point.Z>0
                entry.Drawing.Position=Vector2.new(point.X,point.Y)
                entry.Drawing.Color=Config.DamageColor
                entry.Drawing.Transparency=1-progress
            end
        end
        local target=State.CurrentTarget
        targetHighlight.Enabled=Config.TargetHighlight and alive(target)~=nil and alive(target)~=false
        if targetHighlight.Enabled then
            targetHighlight.Adornee=target
            targetHighlight.FillColor,targetHighlight.OutlineColor=Config.TargetHighlightColor,Config.TargetHighlightColor
            targetHighlight.FillTransparency=Config.TargetHighlightTransparency
            targetHighlight.OutlineTransparency=0
        else targetHighlight.Adornee=nil end
    end
    local hatTriangles, hatLines = {}, {}
    local hatSegments = 32
    for index = 1, hatSegments do
        hatTriangles[index] = drawing("Triangle", { Filled=true, ZIndex=3 })
        hatLines[index] = drawing("Line", { Thickness=1.5, ZIndex=4 })
    end

    local function ui(class, properties, parent)
        local object = Instance.new(class)
        for key, value in pairs(properties) do object[key] = value end
        object.Parent = parent
        return object
    end
    local overlayGui = ui("ScreenGui", {
        Name="LarpHub_UPK_HUD", ResetOnSpawn=false, IgnoreGuiInset=true, DisplayOrder=90,
        ZIndexBehavior=Enum.ZIndexBehavior.Sibling,
    }, Player:WaitForChild("PlayerGui"))
    State.OverlayGui = overlayGui
    State:LocalizeTree(overlayGui)
    local hud = { Rows={}, AvatarId=nil, NextUpdate=0, Ratio=1, Visibility=0 }
    State.HUD = hud
    local function panel(name,size,position)
        local frame = ui("CanvasGroup", {
            Name=name, Size=size, Position=position, BackgroundColor3=Color3.fromRGB(18,20,24),
            BackgroundTransparency=Config.HUDTransparency, BorderSizePixel=0, Visible=false, Active=true,
        },overlayGui)
        ui("UICorner",{CornerRadius=UDim.new(0,8)},frame)
        ui("UIStroke",{Color=Color3.fromRGB(59,66,84),Transparency=0.35,Thickness=1},frame)
        local scale = ui("UIScale",{Scale=1},frame)
        return frame,scale
    end
    local function text(parent,name,size,position,value,fontSize)
        return ui("TextLabel",{
            Name=name,Size=size,Position=position,BackgroundTransparency=1,BorderSizePixel=0,
            Text=value,TextColor3=Color3.fromRGB(238,240,244),TextSize=fontSize or 14,
            Font=Enum.Font.GothamSemibold,TextXAlignment=Enum.TextXAlignment.Left,
            TextTruncate=Enum.TextTruncate.AtEnd,
        },parent)
    end
    hud.TargetFrame,hud.TargetScale = panel("TargetHUD",UDim2.fromOffset(294,102),UDim2.new(0.5,24,0.6,0))
    hud.Avatar = ui("ImageLabel",{
        Name="Avatar",Position=UDim2.fromOffset(7,7),Size=UDim2.fromOffset(54,54),
        BackgroundColor3=Color3.fromRGB(37,40,48),BorderSizePixel=0,Image="",
    },hud.TargetFrame)
    ui("UICorner",{CornerRadius=UDim.new(0,6)},hud.Avatar)
    ui("UIStroke",{Color=Color3.fromRGB(183,190,210),Thickness=1,Transparency=0.3},hud.Avatar)
    hud.TargetName = text(hud.TargetFrame,"TargetName",UDim2.fromOffset(214,23),UDim2.fromOffset(70,5),"Target",15)
    hud.TargetHP = text(hud.TargetFrame,"Health",UDim2.fromOffset(150,22),UDim2.fromOffset(70,27),"HP: -- | Even",14)
    hud.TargetName:SetAttribute("LarpHubNoTranslate",true)
    hud.TargetDistance=text(hud.TargetFrame,"Distance",UDim2.fromOffset(65,22),UDim2.fromOffset(220,27),"-- st",11)
    hud.TargetDistance.TextXAlignment=Enum.TextXAlignment.Right
    hud.TargetArmor=text(hud.TargetFrame,"Armor",UDim2.fromOffset(214,17),UDim2.fromOffset(70,66),"Armor: --",11)
    hud.TargetWeapon=text(hud.TargetFrame,"Weapon",UDim2.fromOffset(214,17),UDim2.fromOffset(70,82),"Weapon: --",11)
    local healthBack = ui("Frame",{
        Name="HealthBackground",Position=UDim2.fromOffset(71,53),Size=UDim2.fromOffset(213,6),
        BackgroundColor3=Color3.fromRGB(35,43,56),BorderSizePixel=0,ClipsDescendants=true,
    },hud.TargetFrame)
    ui("UICorner",{CornerRadius=UDim.new(0,3)},healthBack)
    hud.HealthFill = ui("Frame",{
        Name="HealthFill",Size=UDim2.fromScale(1,1),BorderSizePixel=0,BackgroundColor3=Config.HUDColor,
    },healthBack)
    ui("UICorner",{CornerRadius=UDim.new(0,3)},hud.HealthFill)
    hud.KeysFrame,hud.KeysScale = panel("Keybinds",UDim2.fromOffset(180,34),UDim2.new(0,20,0.35,0))
    hud.KeysTitle = text(hud.KeysFrame,"Title",UDim2.new(1,-16,0,30),UDim2.fromOffset(8,0),"Keybinds",16)
    hud.KeysTitle.TextXAlignment=Enum.TextXAlignment.Center
    hud.KeysTitle.TextColor3=Config.KeybindHeaderColor
    hud.EditorLabel=text(overlayGui,"EditorHint",UDim2.new(1,0,0,32),UDim2.fromOffset(0,45),"HUD EDITOR · drag panels · snap to edges and center",14)
    hud.EditorLabel.TextXAlignment=Enum.TextXAlignment.Center
    hud.EditorLabel.Visible=false
    hud.GuideX=ui("Frame",{Name="CenterX",Position=UDim2.fromScale(0.5,0),Size=UDim2.new(0,1,1,0),BackgroundTransparency=0.65,BorderSizePixel=0,Visible=false},overlayGui)
    hud.GuideY=ui("Frame",{Name="CenterY",Position=UDim2.fromScale(0,0.5),Size=UDim2.new(1,0,0,1),BackgroundTransparency=0.65,BorderSizePixel=0,Visible=false},overlayGui)
    local keyEntries = {
        {Feature="KillAura",Picker="UPK_AuraKey",Name="AttackAura"},
        {Feature="TargetStrafe",Picker="UPK_StrafeKey",Name="Strafe"},
        {Feature="ViewModel",Picker="UPK_FreeLookKey",Name="FreeLook",Hold=true},
    }
    for index, entry in ipairs(keyEntries) do
        local row=ui("Frame",{Name=entry.Name,Size=UDim2.new(1,-20,0,21),Position=UDim2.fromOffset(10,32),BackgroundTransparency=1,Visible=false},hud.KeysFrame)
        local label=text(row,"Module",UDim2.new(1,-80,1,0),UDim2.fromOffset(0,0),entry.Name,13)
        local key=text(row,"Key",UDim2.fromOffset(75,21),UDim2.new(1,-75,0,0),"",13)
        key.TextXAlignment=Enum.TextXAlignment.Right
        hud.Rows[index]={Frame=row,Label=label,Key=key,Entry=entry}
    end
    local drag
    function State:SnapHUDPosition(frame,position)
        local camera=workspace.CurrentCamera
        if not camera then return position end
        local size=frame.AbsoluteSize
        if size.X<1 or size.Y<1 then size=Vector2.new(frame.Size.X.Offset,frame.Size.Y.Offset)*Config.HUDScale end
        local maximum=camera.ViewportSize-size
        local x,y=position.X,position.Y
        if Config.HUDSnap then
            for _,edge in ipairs({0,maximum.X,maximum.X/2}) do if math.abs(x-edge)<=Config.HUDSnapDistance then x=edge;break end end
            for _,edge in ipairs({0,maximum.Y,maximum.Y/2}) do if math.abs(y-edge)<=Config.HUDSnapDistance then y=edge;break end end
        end
        return Vector2.new(math.clamp(x,0,math.max(0,maximum.X)),math.clamp(y,0,math.max(0,maximum.Y)))
    end
    function State:ClampHUD()
        local camera=workspace.CurrentCamera
        if not camera then return end
        for _,frame in ipairs({hud.TargetFrame,hud.KeysFrame}) do
            local p=frame.Position
            local position=self:SnapHUDPosition(frame,Vector2.new(p.X.Scale*camera.ViewportSize.X+p.X.Offset,p.Y.Scale*camera.ViewportSize.Y+p.Y.Offset))
            frame.Position=UDim2.fromOffset(position.X,position.Y)
        end
    end
    function State:ResetHUDPositions()
        hud.TargetFrame.Position=UDim2.new(0.5,24,0.6,0)
        hud.KeysFrame.Position=UDim2.new(0,20,0.35,0)
        self:ClampHUD()
        self:MarkConfigDirty()
    end
    for _,frame in ipairs({hud.TargetFrame,hud.KeysFrame}) do
        connect(frame.InputBegan,function(input)
            if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
                drag={Frame=frame,Input=input,Start=Vector2.new(input.Position.X,input.Position.Y),Position=frame.AbsolutePosition}
            end
        end)
    end
    connect(UIS.InputChanged,function(input)
        if not drag or not (input==drag.Input or input.UserInputType==Enum.UserInputType.MouseMovement) then return end
        local camera=workspace.CurrentCamera
        if not camera then return end
        local position=drag.Position+Vector2.new(input.Position.X,input.Position.Y)-drag.Start
        position=State:SnapHUDPosition(drag.Frame,position)
        drag.Frame.Position=UDim2.fromOffset(position.X,position.Y)
    end)
    connect(UIS.InputEnded,function(input) if drag and input==drag.Input then drag=nil;State:MarkConfigDirty() end end)
    connect(UIS.WindowFocusReleased,function() if drag then State:MarkConfigDirty() end;drag=nil end)

    local function hudTarget(now,preview)
        if preview and (Config.HUDEditor or now<(State.HUDPreviewUntil or 0)) then return Player.Character end
        if Config.KillAura and alive(State.AuraTarget) then return State.AuraTarget end
        if Config.TargetStrafe and alive(State.StrafeTarget) then return State.StrafeTarget end
        if now-(State.LastHitAt or -math.huge)<=Config.TargetHUDTimeout and alive(State.LastHitTarget) then
            return State.LastHitTarget
        end
        if preview and now-(State.LastKillAt or -math.huge)<Config.HUDKillHold and State.LastKilledTarget then
            return State.LastKilledTarget
        end
        local ok,target=pcall(Combat.getAttackTarget)
        if ok and typeof(target)=="Instance" and alive(target) then return target end
    end
    local function updateHUD(dt)
        local now=os.clock()
        hud.TargetFrame.BackgroundTransparency=Config.HUDTransparency
        hud.KeysFrame.BackgroundTransparency=Config.HUDTransparency
        hud.TargetScale.Scale,hud.KeysScale.Scale=Config.HUDScale,Config.HUDScale
        hud.HealthFill.BackgroundColor3=Config.HUDColor
        hud.KeysTitle.TextColor3=Config.KeybindHeaderColor
        hud.EditorLabel.Visible=Config.HUDEditor
        hud.EditorLabel.TextColor3=Config.HUDColor
        hud.GuideX.Visible,hud.GuideY.Visible=Config.HUDEditor,Config.HUDEditor
        hud.GuideX.BackgroundColor3,hud.GuideY.BackgroundColor3=Config.HUDColor,Config.HUDColor
        if now>=hud.NextUpdate then
            hud.NextUpdate=now+0.08
            State.CurrentTarget=(Config.TargetHUD or Config.TargetHighlight) and hudTarget(now,false) or nil
            local target=(Config.TargetHUD or Config.HUDEditor) and hudTarget(now,true) or nil
            local killHold=now-(State.LastKillAt or -math.huge)<Config.HUDKillHold
            if not target and Config.TargetHUD and killHold and hud.LastTarget==State.LastKilledTarget then target=hud.LastTarget end
            hud.DesiredVisible=target~=nil and target~=false
            hud.Target=target or nil
            if target then
                local killed=killHold and target==State.LastKilledTarget
                local sameTarget=hud.LastTarget==target
                local other=not killed and Players:GetPlayerFromCharacter(target) or nil
                local displayName=sameTarget and hud.LastDisplayName or nil
                if not displayName then displayName=target.Name end
                if other then displayName=other.DisplayName end
                hud.TargetName.Text=displayName
                local hp,maximum=health(target)
                if killed then hp=0 end
                local ownHP=health(Player.Character)
                local comparison=killed and "Kill" or math.abs(ownHP-hp)<0.1 and "Even" or ownHP>hp and "Win" or "Lose"
                hud.TargetHP.Text=string.format("HP: %.1f | %s",hp/2,comparison)
                hud.Ratio=math.clamp(hp/math.max(1,maximum),0,1)
                local root=target:FindFirstChild("HumanoidRootPart")
                local ownRoot=Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
                if root and ownRoot then hud.TargetDistance.Text=string.format("%.1f st",(root.Position-ownRoot.Position).Magnitude) end
                local armor=target:GetAttribute("FullTierId") or target:GetAttribute("TierId") or "—"
                local weapon=target:GetAttribute("HeldItem") or target:GetAttribute("WeaponTier") or "—"
                hud.TargetArmor.Text="Armor: "..(armor=="" and "none" or tostring(armor))
                hud.TargetWeapon.Text="Weapon: "..tostring(weapon)
                local userId=other and other.UserId or (sameTarget and hud.LastAvatarId) or 0
                hud.LastTarget,hud.LastDisplayName,hud.LastAvatarId=target,displayName,userId
                if hud.AvatarId~=userId then
                    hud.AvatarId=userId
                    hud.Avatar.Image=""
                    if userId>0 then
                        task.spawn(function()
                            local ok,image=pcall(Players.GetUserThumbnailAsync,Players,userId,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size100x100)
                            if ok and State.Alive and hud.AvatarId==userId then hud.Avatar.Image=image end
                        end)
                    end
                end
            end
            local count=0
            for _,row in ipairs(hud.Rows) do
                local entry=row.Entry
                local picker=Options[entry.Picker]
                local bound=picker and picker.Value~="None" and picker.Value~="Unknown"
                local active=Config[entry.Feature] and (not entry.Hold or State.FreeLook~=nil)
                local preview=(Config.HUDEditor or now<(State.HUDPreviewUntil or 0)) and not entry.Hold
                local visible=(Config.KeybindHUD or Config.HUDEditor) and bound and (not Config.KeybindActiveOnly or active or preview)
                row.Frame.Visible=visible==true
                if visible then
                    row.Frame.Position=UDim2.fromOffset(10,30+count*21)
                    row.Key.Text=picker.DisplayValue or picker.Value
                    row.Label.TextColor3=active and Color3.fromRGB(242,242,247) or Color3.fromRGB(185,188,198)
                    count+=1
                end
            end
            hud.VisibleKeyRows=count
            hud.KeysFrame.Size=UDim2.fromOffset(180,34+count*21)
            hud.KeysFrame.Visible=Config.KeybindHUD or Config.HUDEditor
        end
        local desired=(Config.TargetHUD or Config.HUDEditor) and hud.DesiredVisible and 1 or 0
        hud.Visibility+= (desired-hud.Visibility)*math.clamp(dt*12,0,1)
        if Config.HUDEditor then hud.Visibility=1 end
        hud.TargetFrame.GroupTransparency=1-hud.Visibility
        hud.TargetScale.Scale=Config.HUDScale*(0.92+hud.Visibility*0.08)
        hud.TargetFrame.Visible=(Config.TargetHUD or Config.HUDEditor) and hud.Visibility>0.01
        if not Config.KeybindHUD and not Config.HUDEditor then hud.KeysFrame.Visible=false end
        if hud.TargetFrame.Visible then
            hud.HealthFill.Size=hud.HealthFill.Size:Lerp(UDim2.fromScale(hud.Ratio,1),math.clamp(dt*12,0,1))
        end
    end

    local function updateCrosshair(camera)
        syncNativeCrosshair()
        local visible = Config.Crosshair
        local center = camera.ViewportSize / 2
        local angle = Config.CrosshairRotate and os.clock()*1.5 or 0
        for index = 1, 4 do
            local theta = angle + (index-1)*math.pi/2
            local direction = Vector2.new(math.cos(theta), math.sin(theta))
            for _, object in ipairs({ crossOutline[index], crosshair[index] }) do
                object.Visible = visible
                if visible then
                    object.From = center + direction*Config.CrosshairGap
                    object.To = center + direction*(Config.CrosshairGap+Config.CrosshairLength)
                end
            end
            crossOutline[index].Thickness = Config.CrosshairThickness+2
            crosshair[index].Thickness = Config.CrosshairThickness
            crosshair[index].Color = Config.CrosshairColor
        end
        crossDot.Visible = visible and Config.CrosshairDot
        crossDot.Position, crossDot.Color = center, Config.CrosshairColor
    end

    local function updateHat(camera)
        local character = Player.Character
        local head = character and character:FindFirstChild("Head")
        local visible = Config.ChinaHat and alive(character) and head
            and (Config.HatFirstPerson or (camera.CFrame.Position-head.Position).Magnitude > 2)
        for index = 1, hatSegments do
            local triangle, line = hatTriangles[index], hatLines[index]
            triangle.Visible, line.Visible = false, false
            if visible then
                local center = head.Position+Vector3.new(0, head.Size.Y/2+0.18, 0)
                local a, b = (index-1)/hatSegments*math.pi*2, index/hatSegments*math.pi*2
                local p0 = camera:WorldToViewportPoint(center+Vector3.new(0,Config.HatHeight,0))
                local p1 = camera:WorldToViewportPoint(center+Vector3.new(math.cos(a)*Config.HatRadius,0,math.sin(a)*Config.HatRadius))
                local p2 = camera:WorldToViewportPoint(center+Vector3.new(math.cos(b)*Config.HatRadius,0,math.sin(b)*Config.HatRadius))
                if p0.Z > 0 and p1.Z > 0 and p2.Z > 0 then
                    local color = Config.HatRainbow and Color3.fromHSV((os.clock()*0.12+index/hatSegments)%1,0.7,1) or Config.HatColor
                    triangle.PointA, triangle.PointB, triangle.PointC = Vector2.new(p0.X,p0.Y), Vector2.new(p1.X,p1.Y), Vector2.new(p2.X,p2.Y)
                    triangle.Color, triangle.Transparency, triangle.Visible = color, Config.HatOpacity, true
                    line.From, line.To, line.Color, line.Visible = triangle.PointB, triangle.PointC, color, true
                end
            end
        end
    end

    local function updatePlayers(camera)
        local origin = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
        local position = origin and origin.Position or camera.CFrame.Position
        local viewport, center = camera.ViewportSize, camera.ViewportSize/2
        local enabled = Config.ESP or Config.Tracers or Config.Arrows
        for _, other in ipairs(Players:GetPlayers()) do
            if other ~= Player then
                local overlay = State.Overlays[other]
                if enabled and not overlay then overlay = newOverlay(other) end
                if overlay then
                    for _, object in ipairs(overlay.Objects) do object.Visible = false end
                    overlay.Highlight.Enabled = false
                    local character = other.Character
                    if not enabled or not alive(character) or (Config.ESPTeamCheck and sameTeam(other)) then continue end
                    local root = character.HumanoidRootPart
                    local distance = (position-root.Position).Magnitude
                    if distance > Config.VisualRange then continue end
                    if Config.ESPVisibleOnly and not clearPath(camera.CFrame.Position, root.Position) then continue end
                    local color = Config.ESPTeamColor and not other.Neutral and other.TeamColor.Color or Config.VisualColor
                    local projected, onScreen = camera:WorldToViewportPoint(root.Position)
                    if Config.ESP and Config.ESPChams then
                        overlay.Highlight.Adornee = character
                        overlay.Highlight.FillColor, overlay.Highlight.OutlineColor = color, color
                        overlay.Highlight.FillTransparency = Config.ChamsTransparency
                        overlay.Highlight.OutlineTransparency = 0
                        overlay.Highlight.DepthMode = Config.ESPVisibleOnly and Enum.HighlightDepthMode.Occluded or Enum.HighlightDepthMode.AlwaysOnTop
                        overlay.Highlight.Enabled = true
                    end
                    if onScreen and projected.Z > 0 then
                        local top = camera:WorldToViewportPoint(root.Position+Vector3.new(0,Height*0.6,0))
                        local bottom = camera:WorldToViewportPoint(root.Position-Vector3.new(0,Height*0.6,0))
                        if top.Z > 0 and bottom.Z > 0 then
                            local height = math.clamp(math.abs(bottom.Y-top.Y), 4, viewport.Y*3)
                            local width = height*0.53
                            local x, y = projected.X-width/2, (top.Y+bottom.Y)/2-height/2
                            if Config.ESP and Config.ESPBoxes then
                                for _, object in ipairs({overlay.Box, overlay.Outline}) do
                                    object.Position, object.Size, object.Visible = Vector2.new(x,y), Vector2.new(width,height), true
                                end
                                overlay.Box.Color = color
                            end
                            if Config.ESP and Config.ESPNames then
                                overlay.Name.Position = Vector2.new(projected.X,y-Config.ESPFontSize-3)
                                overlay.Name.Text, overlay.Name.Size = other.DisplayName, Config.ESPFontSize
                                overlay.Name.Color, overlay.Name.Visible = color, true
                            end
                            if Config.ESP and Config.ESPDistance then
                                overlay.Distance.Position = Vector2.new(projected.X,y+height+3)
                                overlay.Distance.Text, overlay.Distance.Size = tostring(math.floor(distance+0.5)).." st", Config.ESPFontSize
                                overlay.Distance.Color, overlay.Distance.Visible = color, true
                            end
                            if Config.ESP and Config.ESPHealth then
                                local hp, maximum = health(character)
                                local ratio = math.clamp(hp/math.max(1,maximum),0,1)
                                overlay.HealthBack.From, overlay.HealthBack.To = Vector2.new(x-5,y), Vector2.new(x-5,y+height)
                                overlay.Health.From, overlay.Health.To = Vector2.new(x-5,y+height), Vector2.new(x-5,y+height*(1-ratio))
                                overlay.Health.Color = Color3.fromHSV(ratio/3,0.9,1)
                                overlay.HealthBack.Visible, overlay.Health.Visible = true, true
                            end
                        end
                        if Config.Tracers then
                            local from = Config.TracerOrigin == "Center" and center or Vector2.new(center.X,viewport.Y-5)
                            if Config.TracerOrigin == "Mouse" then from = UIS:GetMouseLocation()-game:GetService("GuiService"):GetGuiInset() end
                            overlay.Tracer.From, overlay.Tracer.To = from, Vector2.new(projected.X,projected.Y)
                            overlay.Tracer.Color, overlay.Tracer.Thickness = color, Config.TracerThickness
                            overlay.Tracer.Visible = true
                        end
                    end
                    if Config.Arrows and (not Config.ArrowsOffscreen or not onScreen) then
                        local relative = camera.CFrame:PointToObjectSpace(root.Position)
                        local angle = math.atan2(relative.X,-relative.Z)
                        local direction = Vector2.new(math.sin(angle),-math.cos(angle))
                        local side = Vector2.new(-direction.Y,direction.X)
                        local radius = math.min(Config.ArrowRadius,math.min(viewport.X,viewport.Y)*0.4)
                        local tip = center+direction*radius
                        local base = tip-direction*Config.ArrowSize*1.7
                        for _, object in ipairs({overlay.ArrowOutline,overlay.Arrow}) do
                            object.PointA, object.PointB, object.PointC = tip, base+side*Config.ArrowSize*0.65, base-side*Config.ArrowSize*0.65
                            object.Visible = true
                        end
                        overlay.Arrow.Color = color
                    end
                end
            end
        end
    end

    local function updateAmbient()
        if not Config.Amb then restoreAmbient(); return end
        if not State.AmbientOriginal then
            State.AmbientOriginal = {}
            for _, property in ipairs({"Ambient","OutdoorAmbient","Brightness","ClockTime","FogEnd","FogStart"}) do
                State.AmbientOriginal[property] = Lighting[property]
            end
        end
        Lighting.Ambient, Lighting.OutdoorAmbient = Config.AmbientColor, Config.OutdoorColor
        Lighting.Brightness, Lighting.ClockTime = Config.Brightness, Config.ClockTime
        Lighting.FogEnd = Config.NoFog and 1000000 or State.AmbientOriginal.FogEnd
        Lighting.FogStart = Config.NoFog and 1000000 or State.AmbientOriginal.FogStart
    end

    bind("RestoreCamera", Enum.RenderPriority.Input.Value-1, function()
        restoreAspect()
        restoreFOV()
    end)
    bind("FreeLook", Enum.RenderPriority.Input.Value+2, function()
        local picker = Options.UPK_FreeLookKey
        local held = picker and picker:GetState() and not UIS:GetFocusedTextBox()
        local active = Config.ViewModel and held and alive(Player.Character) and not ClientState.menuOpen and not State.FocusLost
        if active and not State.FreeLook then
            local yaw, pitch = Movement.getLook()
            State.FreeLook = {
                Yaw=yaw, Pitch=pitch, Perspective=CameraController.getPerspective(), FreeLook=GameInput.isFreeLook(),
            }
            CameraController.setPerspective(1)

            Movement.setLook(yaw,pitch)
            Movement.setMoveYaw(yaw)
        elseif not active then
            stopFreeLook()
        end
    end)
    connect(UIS.WindowFocusReleased, function() State.FocusLost = true; stopFreeLook() end)
    connect(UIS.WindowFocused, function() State.FocusLost = false end)
    connect(Player.CharacterRemoving, function() stopFreeLook() end)
    bind("Visuals", Enum.RenderPriority.Last.Value, function(dt)
        local camera = workspace.CurrentCamera
        if not camera then return end
        if Config.FOV then
            State.FOVCamera, State.FOVBase = camera, camera.FieldOfView
            local value = Config.FOVValue
            if Config.FOVEffects then
                local base = ClientState.getSetting("fov") or GameConfig.Presentation.Camera.Fov
                local effect = math.tan(math.rad(camera.FieldOfView)/2)/math.tan(math.rad(base)/2)
                value = math.deg(2*math.atan(math.tan(math.rad(value)/2)*effect))
            end
            camera.FieldOfView = math.clamp(value,30,120)
        end
        if Config.AspectRatio and camera.ViewportSize.Y > 0 then
            local native = camera.ViewportSize.X/camera.ViewportSize.Y
            State.AspectCamera, State.AspectBase = camera, camera.CFrame
            camera.CFrame *= CFrame.new(0,0,0, 1,0,0, 0,Config.AspectValue/native,0, 0,0,1)
        end
        updateCrosshair(camera)
        updatePlayers(camera)
        updateHat(camera)
        updateAmbient()
        updateHUD(dt)
        updateHitFeedback(camera)
    end)

    State.Themes={
        Energy={Accent=Color3.fromRGB(35,177,246),Color=Color3.fromRGB(28,190,255),Crosshair=Color3.fromRGB(175,240,255)},
        LarpHub={Accent=Accent,Color=Color3.fromRGB(177,116,255),Crosshair=Color3.fromRGB(230,204,255)},
        White={Accent=Color3.fromRGB(225,230,240),Color=Color3.fromRGB(240,244,255),Crosshair=Color3.new(1,1,1)},
    }
    function State:ApplyTheme(name)
        local theme=assert(self.Themes[name],"Unknown theme")
        self.ApplyingTheme=true
        Config.ThemeProfile=name
        for _,key in ipairs({"HUDColor","KeybindHeaderColor","VisualColor","TargetHighlightColor","HitmarkerColor","DamageColor","ParticleColor","HatColor"}) do
            self:ApplySetting(key,theme.Color)
        end
        self:ApplySetting("CrosshairColor",theme.Crosshair)
        if Options.LarpHubAccent then Options.LarpHubAccent:SetValueRGB(theme.Accent) end
        if Options.UPK_ThemeProfile and Options.UPK_ThemeProfile.Value~=name then Options.UPK_ThemeProfile:SetValue(name) end
        self.ApplyingTheme=false
        self:MarkConfigDirty()
    end
    State.ModuleNames={KillAura="KillAura",AntiKnockBack="AntiKnockBack",TargetStrafe="TargetStrafe",Speed="Speed",AutoSprint="AutoSprint",AutoJump="AutoJump",
        ESP="ESP",Tracers="Tracers",Arrows="Arrows",FOV="FOV",AspectRatio="AspectRatio",ViewModel="FreeLook",Crosshair="Crosshair",
        Particles="Hit Particles",ChinaHat="China Hat",Amb="Amb",TargetHUD="Target HUD",KeybindHUD="Keybinds HUD",
        TargetHighlight="Target Highlight",Hitmarker="Hitmarker",HitSound="Hit Sound",DamageIndicators="Damage Indicators",HUDEditor="HUD Editor"}
    function State:OnModuleChanged(key,value)
        if not self.Ready or self.LoadingConfig or self.SuppressNotifications or not Config.ModuleNotifications or not self.ModuleNames[key] then return end
        local bindId=key=="KillAura" and "UPK_AuraKey" or key=="TargetStrafe" and "UPK_StrafeKey" or key=="ViewModel" and "UPK_FreeLookKey"
        local picker=bindId and Options[bindId]
        local suffix=picker and picker.Value~="None" and " ["..(picker.DisplayValue or picker.Value).."]" or ""
        self.ModuleNoticeCount=(self.ModuleNoticeCount or 0)+1
        Library:Notify({Title="LarpHub",Description=self.ModuleNames[key]..": "..(value and "ON" or "OFF")..suffix,Time=2})
    end

    local function toggle(group, key, text, tooltip)
        return group:AddToggle("UPK_"..key, {
            Text=text, Default=Config[key], Tooltip=tooltip,
            Callback=function(value)
                local previous=Config[key]
                Config[key]=value
                if key == "Crosshair" then syncNativeCrosshair() end
                if key == "FOV" and not value then restoreFOV() end
                if previous~=value then State:OnModuleChanged(key,value) end
                State:MarkConfigDirty()
            end,
        })
    end
    local function slider(group,key,text,min,max,rounding,suffix)
        return group:AddSlider("UPK_"..key, {
            Text=text, Default=Config[key], Min=min, Max=max, Rounding=rounding or 0, Suffix=suffix,
            Callback=function(value) Config[key]=key=="SpeedMultiplier" and clampSpeed(value) or value;State:MarkConfigDirty() end,
        })
    end
    local function color(group,key,text)
        return group:AddLabel(text):AddColorPicker("UPK_"..key, {
            Default=Config[key], Title=text, Callback=function(value) Config[key]=value;State:MarkConfigDirty() end,
        })
    end
    local function dropdown(group,key,text,values)
        return group:AddDropdown("UPK_"..key, {
            Text=text, Values=values, Default=Config[key], Callback=function(value)
                Config[key]=value
                if key=="ThemeProfile" and not State.ApplyingTheme then State:ApplyTheme(value) end
                if key=="Language" then State:SetLanguage(value) end
                State:MarkConfigDirty()
            end,
        })
    end
    local tabs = {
        Combat=Window:AddTab("Combat","swords"),
        Movement=Window:AddTab("Movement","footprints"),
        Visuals=Window:AddTab("Visuals","eye"),
    }
    State.Tabs = tabs
    Library.LarpHubTabs.Main.Button.LayoutOrder=1
    tabs.Combat.Button.LayoutOrder=2
    tabs.Movement.Button.LayoutOrder=3
    tabs.Visuals.Button.LayoutOrder=4
    Library.LarpHubTabs.Settings.Button.LayoutOrder=1000

    local aura = tabs.Combat:AddLeftGroupbox("KillAura","swords")
    toggle(aura,"KillAura","KillAura","Adapted from the requested ScriptBlox source; the original attack packet is preserved.")
        :AddKeyPicker("UPK_AuraKey",{Default="R",SyncToggleState=true,Mode="Toggle",Text="KillAura"})
    slider(aura,"AuraRange","Range (blocks)",1,GameConfig.Combat.Reach.ServerEntity,1)
    slider(aura,"AuraCooldown","Attack delay",0.2,1,2," s")
    toggle(aura,"TeamCheck","Ignore teammates")
    toggle(aura,"WallCheck","Check walls")
    aura:AddLabel("Game code: normal reach is 3 blocks; ServerEntity is 4. Default: 3 blocks / 0.50 s. The server validates hits.",true)
    local defense = tabs.Combat:AddRightGroupbox("Defense / hits","shield")
    toggle(defense,"AntiKnockBack","AntiKnockBack","Blocks impulses in the game's movement controller.")
    toggle(defense,"Particles","Hit Particles","Particles appear only on your server-confirmed hits.")
    dropdown(defense,"ParticleStyle","Particle style",{"Energy","Stars","Sparks"})
    slider(defense,"ParticleCount","Count",5,80,0)
    toggle(defense,"ParticleRainbow","Rainbow particles")
    color(defense,"ParticleColor","Particle color")
    local feedback=tabs.Combat:AddRightGroupbox("Hit Feedback","sparkles")
    toggle(feedback,"Hitmarker","Hitmarker")
    color(feedback,"HitmarkerColor","Hitmarker color")
    slider(feedback,"HitmarkerDuration","Hitmarker duration",0.1,1,2," s")
    slider(feedback,"HitmarkerSize","Hitmarker size",4,20,0)
    toggle(feedback,"HitSound","Hit Sound")
    dropdown(feedback,"HitSoundStyle","Sound",{"Ping","Bell","Click","Custom"})
    feedback:AddInput("UPK_HitSoundAsset",{Text="Custom sound ID",Default=Config.HitSoundAsset,Finished=true,
        Callback=function(value) Config.HitSoundAsset=value;State:MarkConfigDirty() end})
    slider(feedback,"HitSoundVolume","Volume",0,1,2)
    slider(feedback,"HitSoundPitch","Sound pitch",0.5,2,2)
    toggle(feedback,"DamageIndicators","Damage Indicators")
    color(feedback,"DamageColor","Damage number color")
    dropdown(feedback,"DamageUnits","Damage units",{"HP","Hearts"})
    slider(feedback,"DamageLifetime","Damage lifetime",0.3,2,1," s")
    feedback:AddButton({Text="Test Hit Feedback",Func=function()
        if Config.Hitmarker then State.HitmarkerUntil=os.clock()+Config.HitmarkerDuration;State.HitmarkerKilled=false end
        State:PlayHitSound()
        if Player.Character then State:RecordDamage(Player.Character,4,false) end
    end})

    local movement = tabs.Movement:AddLeftGroupbox("Movement","footprints")
    toggle(movement,"Speed","Speed")
    slider(movement,"SpeedMultiplier","Speed multiplier",1,MaxSpeedMultiplier,2,"x")
    toggle(movement,"SpeedAir","Keep Speed while jumping","Scales horizontal air acceleration. Jump height stays unchanged.")
    toggle(movement,"AutoSprint","AutoSprint")
    toggle(movement,"AutoJump","AutoJump","Automatically jump while moving on the ground. Disabled in water, lava, on ladders and while sneaking.")
    movement:AddLabel("Speed: 1.05x by default, 1.10x maximum. Older configs are automatically clamped.",true)
    local strafe = tabs.Movement:AddRightGroupbox("TargetStrafe","orbit")
    toggle(strafe,"TargetStrafe","TargetStrafe")
        :AddKeyPicker("UPK_StrafeKey",{Default="F",SyncToggleState=true,Mode="Toggle",Text="TargetStrafe"})
    slider(strafe,"StrafeRadius","Orbit radius",3,20,1," st")
    slider(strafe,"StrafeRange","Target search range",10,150,0," st")
    dropdown(strafe,"StrafeDirection","Direction",{"Right","Left"})
    toggle(strafe,"StrafeJump","Jump while strafing")
    strafe:AddLabel("Orbit the nearest player at the selected radius. Reverse direction on collision.",true)

    local espTabs = tabs.Visuals:AddLeftTabbox()
    local esp = espTabs:AddTab("ESP")
    toggle(esp,"ESP","ESP")
    toggle(esp,"ESPBoxes","Boxes")
    toggle(esp,"ESPNames","Names")
    toggle(esp,"ESPHealth","Health bar")
    toggle(esp,"ESPDistance","Distance")
    toggle(esp,"ESPChams","Character chams")
    slider(esp,"ChamsTransparency","Chams transparency",0,1,2)
    slider(esp,"ESPFontSize","Text size",10,22,0)
    toggle(esp,"ESPVisibleOnly","Visible only")
    toggle(esp,"ESPTeamCheck","Hide teammates")
    toggle(esp,"ESPTeamColor","Team colors")
    color(esp,"VisualColor","ESP / Tracers / Arrows color")
    slider(esp,"VisualRange","Display range",25,2000,0," st")
    local tracking = espTabs:AddTab("Tracking")
    toggle(tracking,"Tracers","Tracers")
    dropdown(tracking,"TracerOrigin","Tracer origin",{"Bottom","Center","Mouse"})
    slider(tracking,"TracerThickness","Tracer thickness",1,4,1)
    tracking:AddDivider()
    toggle(tracking,"Arrows","Arrows near crosshair")
    slider(tracking,"ArrowRadius","Distance from crosshair",35,240,0," px")
    slider(tracking,"ArrowSize","Arrow size",5,20,0)
    toggle(tracking,"ArrowsOffscreen","Off-screen players only")
    tracking:AddLabel("Color, range, team and visibility filters are shared with ESP.",true)
    tracking:AddDivider()
    toggle(tracking,"TargetHighlight","Target Highlight")
    color(tracking,"TargetHighlightColor","Current target color")
    slider(tracking,"TargetHighlightTransparency","Target transparency",0,1,2)
    local hudSettings=espTabs:AddTab("HUD")
    toggle(hudSettings,"TargetHUD","Target HUD")
    toggle(hudSettings,"KeybindHUD","Keybinds HUD")
    toggle(hudSettings,"KeybindActiveOnly","Active keybinds only")
    slider(hudSettings,"TargetHUDTimeout","Keep target after hit",1,10,1," s")
    slider(hudSettings,"HUDKillHold","Keep HUD after kill",0,4,1," s")
    slider(hudSettings,"HUDScale","HUD scale",0.75,1.5,2,"x")
    slider(hudSettings,"HUDTransparency","Background transparency",0,0.7,2)
    color(hudSettings,"HUDColor","Health bar color")
    color(hudSettings,"KeybindHeaderColor","Keybinds header color")
    hudSettings:AddDivider()
    toggle(hudSettings,"HUDEditor","HUD editor","Preview panels without enabling combat modules.")
    toggle(hudSettings,"HUDSnap","Snap to edges / center")
    slider(hudSettings,"HUDSnapDistance","Snap distance",4,30,0," px")
    hudSettings:AddButton({Text="Reset HUD positions",Func=function() State:ResetHUDPositions() end})
    hudSettings:AddLabel("Drag either HUD with the mouse. HP is shown in hearts; Win / Lose compares current health. R: KillAura; F: Strafe.",true)
    hudSettings:AddButton({Text="Preview HUD (5 s)",Func=function()
        Library.Toggles.UPK_TargetHUD:SetValue(true)
        Library.Toggles.UPK_KeybindHUD:SetValue(true)
        State.HUDPreviewUntil=os.clock()+5
    end})

    local otherTabs = tabs.Visuals:AddRightTabbox()
    local camera = otherTabs:AddTab("Camera")
    toggle(camera,"FOV","FOV")
    slider(camera,"FOVValue","Field of view",40,120,0,"°")
    toggle(camera,"FOVEffects","Keep sprint / speed FOV effects")
    camera:AddDivider()
    toggle(camera,"AspectRatio","AspectRatio")
    slider(camera,"AspectValue","Aspect ratio",0.75,3,2)
    camera:AddLabel("1.33 = 4:3; 1.78 = 16:9. Adjusts camera projection.",true)
    camera:AddDivider()
    toggle(camera,"ViewModel","ViewModel / free look")
    camera:AddLabel("Hold for free look"):AddKeyPicker("UPK_FreeLookKey",{
        Default="V", Mode="Hold", Modes={"Hold"}, Text="Free look",
        ChangedCallback=function(key) Config.FreeLookKey=typeof(key)=="EnumItem" and key.Name or tostring(key) end,
    })
    camera:AddLabel("Hold the key for third-person free look. Camera rotation does not change movement direction. Release to restore the view.",true)
    local cross = otherTabs:AddTab("Crosshair")
    toggle(cross,"Crosshair","Crosshair","Enabling hides the game's crosshair; disabling restores it.")
    color(cross,"CrosshairColor","Crosshair color")
    slider(cross,"CrosshairLength","Length",2,25,0)
    slider(cross,"CrosshairGap","Gap",0,20,0)
    slider(cross,"CrosshairThickness","Thickness",1,5,1)
    toggle(cross,"CrosshairDot","Center dot")
    toggle(cross,"CrosshairRotate","Rotation")
    local hat = otherTabs:AddTab("China Hat")
    toggle(hat,"ChinaHat","China Hat")
    toggle(hat,"HatRainbow","Rainbow hat")
    color(hat,"HatColor","Hat color")
    slider(hat,"HatRadius","Hat radius",0.5,4,1)
    slider(hat,"HatHeight","Cone height",0.2,2,1)
    slider(hat,"HatOpacity","Opacity",0.1,1,2)
    toggle(hat,"HatFirstPerson","Show in first person")
    local amb = otherTabs:AddTab("Amb")
    toggle(amb,"Amb","Amb — lighting")
    color(amb,"AmbientColor","Ambient")
    color(amb,"OutdoorColor","Outdoor Ambient")
    slider(amb,"Brightness","Brightness",0,5,1)
    slider(amb,"ClockTime","Time of day",0,24,1)
    toggle(amb,"NoFog","Remove fog")

    local appearance=Library.LarpHubTabs.Settings:AddRightGroupbox("Appearance and notifications","palette")
    dropdown(appearance,"Language","Language / Язык",{"English","Русский"})
    dropdown(appearance,"ThemeProfile","Theme preset",{"Energy","LarpHub","White"})
    toggle(appearance,"ModuleNotifications","Module notifications")
    appearance:AddLabel("Energy: cyan; LarpHub: purple; White: minimal white. Presets change interface and effect colors.",true)
    local configs=Library.LarpHubTabs.Settings:AddLeftGroupbox("Configs","save")
    configs:AddInput("UPK_ConfigName",{Text="Config name",Default="default",Finished=true})
    configs:AddDropdown("UPK_ConfigSelect",{Text="Saved configs",Values={"default"},Default="default"})
    toggle(configs,"AutoSave","Autosave changes")
    local configLabel=configs:AddLabel("Current: default",true)
    State.ConfigStatusLabel=configLabel
    local function refreshConfigs()
        local names=State:ListConfigs()
        Options.UPK_ConfigSelect:SetValues(names)
        if table.find(names,State.ConfigName) then Options.UPK_ConfigSelect:SetValue(State.ConfigName) end
        Options.UPK_ConfigName:SetValue(State.ConfigName)
        configLabel:SetText("Current: "..State.ConfigName)
    end
    local function configAction(fn)
        local ok,message=pcall(fn)
        if ok then
            pcall(refreshConfigs)
            if message then notify(message) end
        else notify("Config: "..tostring(message)) end
    end
    configs:AddButton({Text="Save",Func=function() configAction(function()
        return "Saved: "..State:SaveConfig(Options.UPK_ConfigName.Value)
    end) end})
    configs:AddButton({Text="Load",Func=function() configAction(function()
        return "Loaded: "..State:LoadConfig(Options.UPK_ConfigSelect.Value)
    end) end})
    configs:AddButton({Text="Load on startup",Func=function() configAction(function()
        local name=Options.UPK_ConfigSelect.Value;State:SetAutoload(name);return "Autoload: "..name
    end) end})
    configs:AddButton({Text="Delete selected",Func=function() configAction(function()
        local name=Options.UPK_ConfigSelect.Value;State:DeleteConfig(name);return "Deleted: "..name
    end) end})
    configs:AddButton({Text="Refresh list",Func=function() configAction(refreshConfigs) end})
    configs:AddLabel("Saves settings, modified keybinds, appearance and HUD positions. The HUD editor starts closed.",true)
    for key,option in pairs(Options) do
        if (option.Type=="KeyPicker" or key:sub(1,7)=="LarpHub") and type(option.OnChanged)=="function" then
            option:OnChanged(function() State:MarkConfigDirty() end)
        end
    end
    for key,control in pairs(Library.Toggles) do
        if key:sub(1,7)=="LarpHub" and type(control.OnChanged)=="function" then control:OnChanged(function() State:MarkConfigDirty() end) end
    end

    local home = Library.LarpHubTabs.Main:AddLeftGroupbox("+1 Upgrade Per Kill","swords")
    home:AddLabel("Combat · Movement · Visuals",true)
    home:AddLabel("Menu: RightShift\nFree look: hold V\nFirst launch: features off. Configs restore saved settings.",true)
    home:AddButton({Text="Disable all features",Func=function()
        local previous=State.SuppressNotifications
        State.SuppressNotifications=true
        for key in pairs(State.ModuleNames) do
            Library.Toggles["UPK_"..key]:SetValue(false)
        end
        State.SuppressNotifications=previous
        stopFreeLook(); restoreAspect(); restoreFOV(); restoreAmbient()
        notify("All features disabled.")
    end})
    home:AddButton({Text="Test hit particles",Func=function()
        if Player.Character then burst(Player.Character) end
    end})
    local status = Library.LarpHubTabs.Main:AddRightGroupbox("Game status","activity")
    local statsLabel = status:AddLabel("Ready",true)
    status:AddLabel("KillAura: ScriptBlox source",true)
    local elapsed = 0
    connect(Run.Heartbeat, guarded("Status",function(dt)
        elapsed += dt
        if elapsed < 1 then return end
        elapsed = 0
        configLabel:SetText("Current: "..State.ConfigName..(Config.AutoSave and " · autosave" or ""))
        statsLabel:SetText("Attacks: "..State.Stats.Attacks.."\nConfirmed hits: "..State.Stats.ConfirmedHits
            .."\nKnockbacks blocked: "..State.Stats.BlockedKnockback)
    end))
    connect(Run.Heartbeat,guarded("AutoSave",function()
        if State.Ready and Config.AutoSave and State.DirtyAt and not State.SuppressPersistence and os.clock()-State.DirtyAt>=0.8 then
            local ok,err=pcall(function() State:SaveConfig(State.ConfigName) end)
            if not ok then
                State.DirtyAt=nil
                if State.LastStorageError~=tostring(err) then State.LastStorageError=tostring(err);notify("Autosave: "..tostring(err)) end
            else State.LastStorageError=nil end
        end
    end))
    State:ApplyTheme(Config.ThemeProfile)
    local loadedName
    local storageOK,storageError=pcall(function()
        storage()
        local name="default"
        if isfile(storageRoot.."/autoload.json") then
            local meta=Http:JSONDecode(readfile(storageRoot.."/autoload.json"))
            assert(type(meta)=="table" and meta.Version==1,"Invalid autoload metadata")
            name=profileName(meta.Name)
        end
        if isfile(storageFolder.."/"..name..".json") then loadedName=State:LoadConfig(name) end
        refreshConfigs()
    end)
    if not storageOK then notify("Config not loaded: "..tostring(storageError)) end
    State.Ready = true
    notify("Ready! Combat / Movement / Visuals. Menu: RightShift.")
    print("[LarpHub/UpgradePerKill] Ready | Place "..game.PlaceId.." | Config "..(loadedName or "defaults"))
end

local ok, err = xpcall(setup, debug.traceback)
if not ok then
    State:Unload()
    error("[LarpHub/UpgradePerKill] "..tostring(err),0)
end
return State
