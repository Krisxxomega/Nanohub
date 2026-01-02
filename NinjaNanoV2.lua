local lp = game.Players.LocalPlayer
local rEvents = game:GetService("ReplicatedStorage"):WaitForChild("rEvents")
local ninjaEvent = lp:WaitForChild("ninjaEvent")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")

-- // GLOBAL VARIABLES //
getgenv().autoopencrystals = false
getgenv().autobuyranks = false
getgenv().autobuybelts = false
getgenv().autobuy = false
getgenv().autobuyskills = false
getgenv().autosell = false
getgenv().autosell35 = false
getgenv().autoswing = false
getgenv().autosellpets = false
getgenv().antiafk = false

local startTime = tick()

-- // DATA LISTS //
local IslandsOrdered = {
    "Enchanted Island", "Astral Island", "Mystical Island", "Space Island",
    "Tundra Island", "Eternal Island", "Sandstorm", "Thunderstorm",
    "Ancient Inferno Island", "Midnight Shadow Island", "Mythical Souls Island",
    "Winter Wonder Island", "Golden Master Island", "Dragon Legend Island",
    "Cybernetic Legends Island", "Skystorm Ultraus Island", "Chaos Legends Island",
    "Soul Fusion Island", "Dark Elements Island", "Inner Peace Island",
    "Blazing Vortex Island"
}
-- Разворачиваем список островов, чтобы последние были первыми (для удобства)
local ReversedIslands = {}
for i = #IslandsOrdered, 1, -1 do table.insert(ReversedIslands, IslandsOrdered[i]) end

local ChiIslands = {
    {name = "Soul Fusion Island", id = 18},
    {name = "Chaos Legends Island", id = 17},
    {name = "Skystorm Ultraus Island", id = 16},
    {name = "Golden Master Island", id = 13}
}

local KarmaIslands = {
    {name = "Mythical Souls Island", id = 11}
}

local ElementsList = {
    "Lightning", "Inferno", "Frost", "Shadowfire",
    "Electral Chaos", "Masterful Wrath", "Shadow Charge",
    "Eternity Storm", "Blazing Entity"
}

-- // CLEANUP //
if game.Players.LocalPlayer.PlayerGui:FindFirstChild("NanoHub_V3") then
    game.Players.LocalPlayer.PlayerGui.NanoHub_V3:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NanoHub_V3"
ScreenGui.Parent = lp.PlayerGui
ScreenGui.ResetOnSpawn = false

-- // RGB FUNC //
local function AddRainbow(instance)
    local Gradient = Instance.new("UIGradient")
    Gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0.00, Color3.fromHSV(0.0, 1, 1)),
        ColorSequenceKeypoint.new(0.20, Color3.fromHSV(0.2, 1, 1)),
        ColorSequenceKeypoint.new(0.40, Color3.fromHSV(0.4, 1, 1)),
        ColorSequenceKeypoint.new(0.60, Color3.fromHSV(0.6, 1, 1)),
        ColorSequenceKeypoint.new(0.80, Color3.fromHSV(0.8, 1, 1)),
        ColorSequenceKeypoint.new(1.00, Color3.fromHSV(1.0, 1, 1))
    }
    Gradient.Rotation = 45
    Gradient.Parent = instance

    task.spawn(function()
        local rot = 0
        while instance.Parent do
            rot = rot + 1
            Gradient.Rotation = rot
            if rot >= 360 then rot = 0 end
            task.wait(0.02)
        end
    end)
end

-- // DRAGGABLE FUNCTION (FIXED) //
-- target = то что двигаем, handle = то за что тянем
local function MakeDraggable(target, handle)
    local dragging, dragInput, dragStart, startPos
    
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = target.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            target.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- ==========================
-- КРУГЛАЯ ИКОНКА (FIXED)
-- ==========================
local OpenIcon = Instance.new("Frame")
OpenIcon.Size = UDim2.new(0, 55, 0, 55)
OpenIcon.Position = UDim2.new(0.05, 0, 0.15, 0) 
OpenIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
OpenIcon.Visible = false
OpenIcon.Parent = ScreenGui
OpenIcon.ZIndex = 10
Instance.new("UICorner", OpenIcon).CornerRadius = UDim.new(1, 0)
AddRainbow(OpenIcon)

local IconBtn = Instance.new("TextButton")
IconBtn.Size = UDim2.new(1, -6, 1, -6)
IconBtn.Position = UDim2.new(0, 3, 0, 3)
IconBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
IconBtn.Text = "V3"
IconBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
IconBtn.Font = Enum.Font.GothamBlack
IconBtn.TextSize = 20
IconBtn.Parent = OpenIcon
IconBtn.ZIndex = 11
Instance.new("UICorner", IconBtn).CornerRadius = UDim.new(1, 0)

-- Применяем фикс: тянем за IconBtn, но двигается OpenIcon
MakeDraggable(OpenIcon, IconBtn)

-- ==========================
-- MAIN GUI
-- ==========================
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 520, 0, 340) -- Чуть шире для ресайзера
Main.Position = UDim2.new(0.5, -260, 0.5, -170)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Parent = ScreenGui
Main.Active = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 14)

local MainScale = Instance.new("UIScale")
MainScale.Parent = Main
MainScale.Scale = 1

-- // SEAMLESS RESIZER (4 ARROWS) //
local Resizer = Instance.new("ImageButton")
Resizer.Name = "ResizeHandle"
Resizer.Size = UDim2.new(0, 24, 0, 24) -- Аккуратный размер иконки
Resizer.Position = UDim2.new(1, -26, 1, -26) -- Отступ от края
Resizer.BackgroundTransparency = 1 -- ГЛАВНОЕ: Убрали фон, теперь это часть UI
Resizer.Image = "rbxassetid://6031094678" -- Иконка "Expand/Arrows" (Стрелки во все стороны)
Resizer.ImageColor3 = Color3.fromRGB(150, 150, 160) -- Цвет стрелок (светло-серый)
Resizer.Parent = Main
Resizer.ZIndex = 20

local function EnableResizer()
    local dragging, dragStart, startScale
    Resizer.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startScale = MainScale.Scale
            
            -- Легкая анимация цвета при нажатии, чтобы понять что схватил
            Resizer.ImageColor3 = Color3.fromRGB(255, 255, 255)
            
            input.Changed:Connect(function() 
                if input.UserInputState == Enum.UserInputState.End then 
                    dragging = false 
                    Resizer.ImageColor3 = Color3.fromRGB(150, 150, 160) -- Возврат цвета
                end 
            end)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            local newScale = startScale + (delta.X / 300)
            if newScale < 0.5 then newScale = 0.5 end
            if newScale > 3 then newScale = 3 end
            MainScale.Scale = newScale
        end
    end)
end
EnableResizer()


-- // SIDEBAR //
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 110, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Sidebar.Parent = Main
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 12)
AddRainbow(Sidebar)

local SidebarOverlay = Instance.new("Frame")
SidebarOverlay.Size = UDim2.new(1, -4, 1, -4)
SidebarOverlay.Position = UDim2.new(0, 2, 0, 2)
SidebarOverlay.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
SidebarOverlay.Parent = Sidebar
SidebarOverlay.ZIndex = 2
Instance.new("UICorner", SidebarOverlay).CornerRadius = UDim.new(0, 10)

-- Тянем за само окно Main, но только если клик не по интерактивным элементам
MakeDraggable(Main, Main)

-- Заголовок (сдвинут чтобы кнопка сворачивания не мешала)
local Logo = Instance.new("TextLabel")
Logo.Size = UDim2.new(1, -40, 0, 25)
Logo.Position = UDim2.new(0, 10, 0, 8) -- Отступ слева 10
Logo.Text = "NanoHub V3"
Logo.TextColor3 = Color3.fromRGB(255, 255, 255)
Logo.Font = Enum.Font.GothamBlack
Logo.TextSize = 13
Logo.TextXAlignment = Enum.TextXAlignment.Left
Logo.BackgroundTransparency = 1
Logo.Parent = SidebarOverlay
Logo.ZIndex = 3

local MiniBtn = Instance.new("TextButton")
MiniBtn.Size = UDim2.new(0, 25, 0, 25)
MiniBtn.Position = UDim2.new(1, -30, 0, 8)
MiniBtn.Text = "-"
MiniBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
MiniBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MiniBtn.Font = Enum.Font.GothamBold
MiniBtn.TextSize = 16
MiniBtn.Parent = SidebarOverlay
MiniBtn.ZIndex = 4
Instance.new("UICorner", MiniBtn).CornerRadius = UDim.new(0, 6)

-- Меню кнопок
local MenuContainer = Instance.new("Frame")
MenuContainer.Size = UDim2.new(1, 0, 1, -80)
MenuContainer.Position = UDim2.new(0, 0, 0, 45)
MenuContainer.BackgroundTransparency = 1
MenuContainer.Parent = SidebarOverlay
MenuContainer.ZIndex = 3

local MenuListLayout = Instance.new("UIListLayout", MenuContainer)
MenuListLayout.SortOrder = Enum.SortOrder.LayoutOrder
MenuListLayout.Padding = UDim.new(0, 6)
MenuListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Логика сворачивания
local isMinimized = false
local function ToggleUI()
    if isMinimized then
        OpenIcon.Visible = false
        Main.Visible = true
        isMinimized = false
    else
        Main.Visible = false
        OpenIcon.Visible = true
        isMinimized = true
    end
end
MiniBtn.MouseButton1Click:Connect(ToggleUI)
IconBtn.MouseButton1Click:Connect(ToggleUI)

-- Контент
local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -125, 1, -10)
ContentArea.Position = UDim2.new(0, 120, 0, 5) -- Отступ от сайдбара
ContentArea.BackgroundTransparency = 1
ContentArea.Parent = Main

local tabs = {}
local function createTab(name, order)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, 90, 0, 28)
    b.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    b.Text = name
    b.TextColor3 = Color3.fromRGB(150, 150, 150)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 10
    b.Parent = MenuContainer
    b.LayoutOrder = order
    b.ZIndex = 3
    b.AutoButtonColor = false
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)

    local page = Instance.new("Frame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.Parent = ContentArea
    tabs[name] = {b = b, page = page}
    
    b.MouseButton1Click:Connect(function()
        for _, v in pairs(tabs) do 
            v.page.Visible = false
            v.b.TextColor3 = Color3.fromRGB(150, 150, 150)
            v.b.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
        end
        page.Visible = true
        b.TextColor3 = Color3.fromRGB(255, 255, 255)
        b.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    end)
    return page
end

-- // TAB CREATION ORDER //
local MainPage = createTab("MAIN", 1)
local AutofarmPage = createTab("AUTOFARM", 2)
local WorldPage = createTab("WORLD", 3)
local ElementsPage = createTab("ELEMENTS", 4)
local ExtraPage = createTab("EXTRA", 5)
local PlayerPage = createTab("PLAYER", 6)

tabs["MAIN"].page.Visible = true
tabs["MAIN"].b.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
tabs["MAIN"].b.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Helpers
local function createScroll(parent)
    local s = Instance.new("ScrollingFrame")
    s.Size = UDim2.new(1, 0, 1, 0)
    s.BackgroundTransparency = 1
    s.ScrollBarThickness = 2
    s.Parent = parent
    local l = Instance.new("UIListLayout", s)
    l.Padding = UDim.new(0, 6)
    l.HorizontalAlignment = Enum.HorizontalAlignment.Center
    l:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        s.CanvasSize = UDim2.new(0, 0, 0, l.AbsoluteContentSize.Y + 10)
    end)
    return s
end

local function AddToggleSwitch(parent, text, globalVar, callback)
    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(0.98, 0, 0, 32)
    Container.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    Container.Parent = parent
    Instance.new("UICorner", Container).CornerRadius = UDim.new(0, 8)

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.6, 0, 1, 0)
    Label.Position = UDim2.new(0.05, 0, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(220, 220, 220)
    Label.Font = Enum.Font.GothamMedium
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.TextSize = 11
    Label.Parent = Container

    local SwitchBg = Instance.new("TextButton")
    SwitchBg.Size = UDim2.new(0, 36, 0, 18)
    SwitchBg.Position = UDim2.new(1, -45, 0.5, -9)
    SwitchBg.BackgroundColor3 = getgenv()[globalVar] and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(60, 60, 65)
    SwitchBg.Text = ""
    SwitchBg.Parent = Container
    Instance.new("UICorner", SwitchBg).CornerRadius = UDim.new(1, 0)

    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.new(0, 14, 0, 14)
    Knob.Position = getgenv()[globalVar] and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
    Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Knob.Parent = SwitchBg
    Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)

    SwitchBg.MouseButton1Click:Connect(function()
        getgenv()[globalVar] = not getgenv()[globalVar]
        local state = getgenv()[globalVar]
        TweenService:Create(SwitchBg, TweenInfo.new(0.2), {BackgroundColor3 = state and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(60, 60, 65)}):Play()
        TweenService:Create(Knob, TweenInfo.new(0.2), {Position = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)}):Play()
        if state then
            task.spawn(function()
                while getgenv()[globalVar] do callback() task.wait(0.1) end
            end)
        end
    end)
end

local function AddButton(parent, text, callback, color)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0.98, 0, 0, 32)
    b.BackgroundColor3 = color or Color3.fromRGB(45, 45, 50)
    b.Text = text
    b.TextColor3 = Color3.fromRGB(240, 240, 240)
    b.Font = Enum.Font.GothamMedium
    b.TextSize = 11
    b.Parent = parent
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    b.MouseButton1Click:Connect(callback)
end

-- ==================================================
-- 1. MAIN TAB (RE-DESIGNED CARDS)
-- ==================================================
local MainScroll = createScroll(MainPage)

-- Card 1: Place ID
local CardPlace = Instance.new("Frame")
CardPlace.Size = UDim2.new(0.98, 0, 0, 45)
CardPlace.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
CardPlace.Parent = MainScroll
Instance.new("UICorner", CardPlace).CornerRadius = UDim.new(0, 8)

local PlaceTitle = Instance.new("TextLabel")
PlaceTitle.Text = "Place ID: " .. game.PlaceId
PlaceTitle.Size = UDim2.new(0.6, 0, 1, 0)
PlaceTitle.Position = UDim2.new(0.05, 0, 0, 0)
PlaceTitle.BackgroundTransparency = 1
PlaceTitle.TextColor3 = Color3.fromRGB(150, 150, 150)
PlaceTitle.Font = Enum.Font.GothamBold
PlaceTitle.TextXAlignment = Enum.TextXAlignment.Left
PlaceTitle.TextSize = 12
PlaceTitle.Parent = CardPlace

local CopyIdBtn = Instance.new("TextButton")
CopyIdBtn.Size = UDim2.new(0.25, 0, 0.6, 0)
CopyIdBtn.Position = UDim2.new(0.7, 0, 0.2, 0)
CopyIdBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
CopyIdBtn.Text = "COPY"
CopyIdBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CopyIdBtn.Font = Enum.Font.GothamBold
CopyIdBtn.TextSize = 10
CopyIdBtn.Parent = CardPlace
Instance.new("UICorner", CopyIdBtn).CornerRadius = UDim.new(0, 6)
CopyIdBtn.MouseButton1Click:Connect(function()
    setclipboard(tostring(game.PlaceId))
    CopyIdBtn.Text = "DONE"
    task.wait(1)
    CopyIdBtn.Text = "COPY"
end)

-- Card 2: Played on server (Timer)
local CardTime = Instance.new("Frame")
CardTime.Size = UDim2.new(0.98, 0, 0, 40)
CardTime.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
CardTime.Parent = MainScroll
Instance.new("UICorner", CardTime).CornerRadius = UDim.new(0, 8)

local TimeTitle = Instance.new("TextLabel")
TimeTitle.Text = "Played on server"
TimeTitle.Size = UDim2.new(0.5, 0, 1, 0)
TimeTitle.Position = UDim2.new(0.05, 0, 0, 0)
TimeTitle.BackgroundTransparency = 1
TimeTitle.TextColor3 = Color3.fromRGB(180, 180, 180)
TimeTitle.Font = Enum.Font.GothamMedium
TimeTitle.TextXAlignment = Enum.TextXAlignment.Left
TimeTitle.TextSize = 11
TimeTitle.Parent = CardTime

local TimeValue = Instance.new("TextLabel")
TimeValue.Text = "00:00:00"
TimeValue.Size = UDim2.new(0.4, 0, 1, 0)
TimeValue.Position = UDim2.new(0.55, 0, 0, 0)
TimeValue.BackgroundTransparency = 1
TimeValue.TextColor3 = Color3.fromRGB(100, 200, 255)
TimeValue.Font = Enum.Font.Code
TimeValue.TextXAlignment = Enum.TextXAlignment.Right
TimeValue.TextSize = 12
TimeValue.Parent = CardTime

-- Card 3: Position (Coords top, Copy Bottom)
local CardPos = Instance.new("Frame")
CardPos.Size = UDim2.new(0.98, 0, 0, 65)
CardPos.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
CardPos.Parent = MainScroll
Instance.new("UICorner", CardPos).CornerRadius = UDim.new(0, 8)

local PosValue = Instance.new("TextLabel")
PosValue.Text = "X:0 Y:0 Z:0"
PosValue.Size = UDim2.new(1, 0, 0.5, 0)
PosValue.BackgroundTransparency = 1
PosValue.TextColor3 = Color3.fromRGB(150, 255, 150)
PosValue.Font = Enum.Font.Code
PosValue.TextSize = 12
PosValue.Parent = CardPos

local CopyPosBtn = Instance.new("TextButton")
CopyPosBtn.Size = UDim2.new(0.9, 0, 0.35, 0)
CopyPosBtn.Position = UDim2.new(0.05, 0, 0.55, 0)
CopyPosBtn.BackgroundColor3 = Color3.fromRGB(50, 60, 50)
CopyPosBtn.Text = "COPY COORDINATES"
CopyPosBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CopyPosBtn.Font = Enum.Font.GothamBold
CopyPosBtn.TextSize = 10
CopyPosBtn.Parent = CardPos
Instance.new("UICorner", CopyPosBtn).CornerRadius = UDim.new(0, 4)
CopyPosBtn.MouseButton1Click:Connect(function()
    if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
        local p = lp.Character.HumanoidRootPart.Position
        setclipboard(string.format("%.1f, %.1f, %.1f", p.X, p.Y, p.Z))
        CopyPosBtn.Text = "COPIED"
        task.wait(1)
        CopyPosBtn.Text = "COPY COORDINATES"
    end
end)

-- Card 4: Anti Afk
AddToggleSwitch(MainScroll, "Anti afk", "antiafk", function() end)

-- Anti AFK Event Logic
lp.Idled:Connect(function()
    if getgenv().antiafk then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)

-- Card 5: Rejoin
AddButton(MainScroll, "REJOIN SERVER", function()
    if queue_on_teleport then queue_on_teleport('print("Rejoining NanoHub V3...")') end
    TeleportService:Teleport(game.PlaceId, lp)
end, Color3.fromRGB(180, 50, 50))

-- Update Loop for Time/Pos
task.spawn(function()
    while MainScroll.Parent do
        local diff = tick() - startTime
        local hrs = math.floor(diff / 3600)
        local mins = math.floor((diff % 3600) / 60)
        local secs = math.floor(diff % 60)
        TimeValue.Text = string.format("%02d:%02d:%02d", hrs, mins, secs)
        
        if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
            local p = lp.Character.HumanoidRootPart.Position
            PosValue.Text = string.format("X:%.0f  Y:%.0f  Z:%.0f", p.X, p.Y, p.Z)
        end
        task.wait(0.5)
    end
end)

-- ==================================================
-- 2. AUTOFARM TAB (CLEANED)
-- ==================================================
local AutoLeft = Instance.new("Frame")
AutoLeft.Size = UDim2.new(0.48, 0, 1, 0)
AutoLeft.Position = UDim2.new(0, 5, 0, 0)
AutoLeft.BackgroundTransparency = 1
AutoLeft.Parent = AutofarmPage

local AutoRight = Instance.new("Frame")
AutoRight.Size = UDim2.new(0.48, 0, 1, 0)
AutoRight.Position = UDim2.new(0.51, 0, 0, 0)
AutoRight.BackgroundTransparency = 1
AutoRight.Parent = AutofarmPage

local AutoLScroll = createScroll(AutoLeft)
local AutoRScroll = createScroll(AutoRight)

-- Left
AddToggleSwitch(AutoLScroll, "Auto Swing", "autoswing", function()
    for _, v in pairs(lp.Backpack:GetChildren()) do
        if v:FindFirstChild("ninjitsuGain") then lp.Character.Humanoid:EquipTool(v) break end
    end
    ninjaEvent:FireServer("swingKatana")
end)
AddToggleSwitch(AutoLScroll, "Sell (Std)", "autosell", function()
    workspace.sellAreaCircles["sellAreaCircle16"].circleInner.CFrame = lp.Character.HumanoidRootPart.CFrame
    task.wait(0.1)
    workspace.sellAreaCircles["sellAreaCircle16"].circleInner.CFrame = CFrame.new(0, 0, 0)
end)
AddToggleSwitch(AutoLScroll, "Sell 35x", "autosell35", function()
    local islandPart = workspace.islandUnlockParts:FindFirstChild("Blazing Vortex Island")
    if islandPart and not getgenv().BlazingVortexCircle then
        local closestDist, closest = 999999, nil
        for _, v in pairs(workspace.sellAreaCircles:GetChildren()) do
            if v:FindFirstChild("circleInner") then
                local dist = (v.circleInner.Position - islandPart.Position).Magnitude
                if dist < closestDist then closestDist = dist closest = v end
            end
        end
        getgenv().BlazingVortexCircle = closest
    end
    local target = getgenv().BlazingVortexCircle or workspace.sellAreaCircles:FindFirstChild("sellAreaCircle16")
    if target and target:FindFirstChild("circleInner") then
        target.circleInner.CFrame = lp.Character.HumanoidRootPart.CFrame
        task.wait(0.1)
        target.circleInner.CFrame = CFrame.new(0, 0, 0)
    end
end)
AddButton(AutoLScroll, "OPEN SHOP", function()
    workspace.shopAreaCircles.shopAreaCircle19.circleInner.CFrame = lp.Character.HumanoidRootPart.CFrame
    task.wait(0.4)
    workspace.shopAreaCircles.shopAreaCircle19.circleInner.CFrame = CFrame.new(0, 0, 0)
end, Color3.fromRGB(60, 120, 60))

-- Right
AddToggleSwitch(AutoRScroll, "Buy Ranks", "autobuyranks", function()
    for _, v in pairs(game:GetService("ReplicatedStorage").Ranks.Ground:GetChildren()) do ninjaEvent:FireServer("buyRank", v.Name) end
end)
AddToggleSwitch(AutoRScroll, "Buy Belts", "autobuybelts", function() ninjaEvent:FireServer("buyAllBelts", "Inner Peace Island") end)
AddToggleSwitch(AutoRScroll, "Buy Swords", "autobuy", function() ninjaEvent:FireServer("buyAllSwords", "Inner Peace Island") end)
AddToggleSwitch(AutoRScroll, "Buy Skills", "autobuyskills", function() ninjaEvent:FireServer("buyAllSkills", "Inner Peace Island") end)

-- ==================================================
-- 3. WORLD TAB (DROPDOWN SYSTEM)
-- ==================================================
local WorldLeft = Instance.new("Frame")
WorldLeft.Size = UDim2.new(0.48, 0, 1, 0)
WorldLeft.Position = UDim2.new(0, 5, 0, 0)
WorldLeft.BackgroundTransparency = 1
WorldLeft.Parent = WorldPage

local WorldRight = Instance.new("Frame")
WorldRight.Size = UDim2.new(0.48, 0, 1, 0)
WorldRight.Position = UDim2.new(0.51, 0, 0, 0)
WorldRight.BackgroundTransparency = 1
WorldRight.Parent = WorldPage

local LeftScroll = createScroll(WorldLeft)
local RightScroll = createScroll(WorldRight)

-- Функция создания Dropdown Selector
local function CreateDropdownSelector(parent, title, items, onTeleport)
    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(0.98, 0, 0, 95)
    Container.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    Container.Parent = parent
    Instance.new("UICorner", Container).CornerRadius = UDim.new(0, 8)
    Container.ZIndex = 5 

    local TitleLbl = Instance.new("TextLabel")
    TitleLbl.Text = title
    TitleLbl.Size = UDim2.new(1, 0, 0, 20)
    TitleLbl.BackgroundTransparency = 1
    TitleLbl.TextColor3 = Color3.fromRGB(150, 150, 150)
    TitleLbl.Font = Enum.Font.GothamBold
    TitleLbl.TextSize = 10
    TitleLbl.Parent = Container
    TitleLbl.ZIndex = 5

    -- Кнопка выбора
    local SelectBtn = Instance.new("TextButton")
    SelectBtn.Size = UDim2.new(0.9, 0, 0, 25)
    SelectBtn.Position = UDim2.new(0.05, 0, 0.25, 0)
    SelectBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
    SelectBtn.Text = "Select Island..."
    SelectBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    SelectBtn.Font = Enum.Font.GothamMedium
    SelectBtn.TextSize = 11
    SelectBtn.Parent = Container
    SelectBtn.ZIndex = 6
    Instance.new("UICorner", SelectBtn).CornerRadius = UDim.new(0, 6)

    -- Кнопка телепорта
    local TeleportBtn = Instance.new("TextButton")
    TeleportBtn.Size = UDim2.new(0.9, 0, 0, 25)
    TeleportBtn.Position = UDim2.new(0.05, 0, 0.65, 0)
    TeleportBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30) -- Сначала серая
    TeleportBtn.Text = "TELEPORT"
    TeleportBtn.TextColor3 = Color3.fromRGB(100, 100, 100)
    TeleportBtn.Font = Enum.Font.GothamBold
    TeleportBtn.TextSize = 11
    TeleportBtn.Parent = Container
    TeleportBtn.ZIndex = 5
    Instance.new("UICorner", TeleportBtn).CornerRadius = UDim.new(0, 6)
    TeleportBtn.AutoButtonColor = false

    -- Выпадающий список
    local Dropdown = Instance.new("ScrollingFrame")
    Dropdown.Size = UDim2.new(0.9, 0, 0, 150)
    Dropdown.Position = UDim2.new(0.05, 0, 0.55, 0) -- Поверх телепорта
    Dropdown.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    Dropdown.Visible = false
    Dropdown.BorderSizePixel = 0
    Dropdown.ScrollBarThickness = 2
    Dropdown.Parent = Container -- Нужно вытащить выше если клиппинг мешает, но в скролле норм
    Dropdown.ZIndex = 10
    Instance.new("UICorner", Dropdown).CornerRadius = UDim.new(0, 6)

    local listLayout = Instance.new("UIListLayout", Dropdown)
    listLayout.Padding = UDim.new(0, 2)
    listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() Dropdown.CanvasSize = UDim2.new(0,0,0,listLayout.AbsoluteContentSize.Y) end)

    local selectedValue = nil

    -- Заполнение списка
    for _, item in ipairs(items) do
        local val = (type(item) == "string") and item or item.name
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(1, 0, 0, 25)
        b.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
        b.Text = val
        b.TextColor3 = Color3.fromRGB(220, 220, 220)
        b.Font = Enum.Font.Gotham
        b.TextSize = 10
        b.Parent = Dropdown
        b.ZIndex = 11
        
        b.MouseButton1Click:Connect(function()
            selectedValue = val
            SelectBtn.Text = val
            Dropdown.Visible = false
            -- Активируем кнопку телепорта
            TeleportBtn.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
            TeleportBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            TeleportBtn.AutoButtonColor = true
        end)
    end

    SelectBtn.MouseButton1Click:Connect(function()
        Dropdown.Visible = not Dropdown.Visible
    end)

    TeleportBtn.MouseButton1Click:Connect(function()
        if selectedValue then
            onTeleport(selectedValue)
        end
    end)
    
    -- Хак чтобы список был поверх всего (Zindex)
    -- Но в скролл контейнере это сложно, оставим так.
end

-- Создаем селекторы
CreateDropdownSelector(LeftScroll, "ALL ISLANDS", ReversedIslands, function(name)
    if workspace.islandUnlockParts:FindFirstChild(name) then lp.Character.HumanoidRootPart.CFrame = workspace.islandUnlockParts[name].CFrame end
end)

CreateDropdownSelector(LeftScroll, "CHI CHESTS", ChiIslands, function(name)
    if workspace.islandUnlockParts:FindFirstChild(name) then lp.Character.HumanoidRootPart.CFrame = workspace.islandUnlockParts[name].CFrame end
end)

CreateDropdownSelector(LeftScroll, "KARMA ISLANDS", KarmaIslands, function(name)
    if workspace.islandUnlockParts:FindFirstChild(name) then lp.Character.HumanoidRootPart.CFrame = workspace.islandUnlockParts[name].CFrame end
end)

-- Buttons Right side
local function TP(x, y, z)
    if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then lp.Character.HumanoidRootPart.CFrame = CFrame.new(x, y, z) end
end

AddButton(RightScroll, "Evil Karma (x75)", function() TP(618.70, 39, 2414.65) end, Color3.fromRGB(180, 50, 50))
AddButton(RightScroll, "Light Karma (x75)", function() TP(5033.53, 39, 1584.58) end, Color3.fromRGB(0, 150, 150))
AddButton(RightScroll, "Altar of Elements", function() TP(729.91, 123, -5905.91) end, Color3.fromRGB(200, 0, 200))
AddButton(RightScroll, "Ancient Magma Boss", function() TP(246.10, 123, 1657.82) end, Color3.fromRGB(200, 100, 0))
AddButton(RightScroll, "Infinity Stats Dojo", function() TP(-4115.14, 123, -5919.19) end, Color3.fromRGB(100, 0, 160))
AddButton(RightScroll, "Pet Cloning Altar", function() TP(4496.50, 123, 1389.34) end, Color3.fromRGB(50, 160, 80))
AddButton(RightScroll, "Duel Arena", function() TP(-6551.23, 117, -563.48) end, Color3.fromRGB(100, 100, 100))

-- ==================================================
-- 4. ELEMENTS TAB
-- ==================================================
local ElementsScroll = createScroll(ElementsPage)
local GlitchBtn = Instance.new("TextButton")
GlitchBtn.Size = UDim2.new(0.6, 0, 0, 40)
GlitchBtn.BackgroundColor3 = Color3.fromRGB(80, 0, 120)
GlitchBtn.Text = "GET ALL ELEMENTS"
GlitchBtn.TextColor3 = Color3.fromRGB(100, 255, 0)
GlitchBtn.Font = Enum.Font.GothamBlack
GlitchBtn.TextSize = 14
GlitchBtn.Parent = ElementsScroll
Instance.new("UICorner", GlitchBtn).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", GlitchBtn).Color = Color3.fromRGB(0, 0, 0)
Instance.new("UIStroke", GlitchBtn).Thickness = 2
GlitchBtn.MouseButton1Click:Connect(function()
    if game.Players.LocalPlayer.PlayerGui.gameGui.sideButtons.excludeFolder.gemsFrame.amountLabel.Text:lower() == "inf" then
        game.ReplicatedStorage.rEvents.zenMasterEvent:FireServer("convertGems", 1e+124)
    else
        game.ReplicatedStorage.rEvents.zenMasterEvent:FireServer("convertGems", -math.huge)
        for _, k in pairs(ElementsList) do pcall(function() game.ReplicatedStorage.rEvents.elementMasteryEvent:FireServer(k) end) end
    end
end)

local Sep = Instance.new("Frame")
Sep.Size = UDim2.new(0.9, 0, 0, 2)
Sep.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Sep.BorderSizePixel = 0
Sep.Parent = ElementsScroll

for i, elName in ipairs(ElementsList) do
    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(0.98, 0, 0, 30)
    Row.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    Row.Parent = ElementsScroll
    Instance.new("UICorner", Row).CornerRadius = UDim.new(0, 6)
    
    local Num = Instance.new("TextLabel")
    Num.Text = tostring(i) .. "."
    Num.Size = UDim2.new(0.1, 0, 1, 0)
    Num.TextColor3 = Color3.fromRGB(100, 100, 100)
    Num.BackgroundTransparency = 1
    Num.Font = Enum.Font.GothamBold
    Num.Parent = Row

    local NameLbl = Instance.new("TextLabel")
    NameLbl.Text = elName
    NameLbl.Size = UDim2.new(0.4, 0, 1, 0)
    NameLbl.Position = UDim2.new(0.12, 0, 0, 0)
    NameLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    NameLbl.BackgroundTransparency = 1
    NameLbl.Font = Enum.Font.GothamMedium
    NameLbl.TextXAlignment = Enum.TextXAlignment.Left
    NameLbl.Parent = Row

    local Check = Instance.new("Frame")
    Check.Size = UDim2.new(0, 16, 0, 16)
    Check.Position = UDim2.new(0.6, 0, 0.2, 0)
    Check.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Check.Parent = Row
    Instance.new("UICorner", Check).CornerRadius = UDim.new(0, 4)
    Instance.new("UIStroke", Check).Color = Color3.fromRGB(80, 80, 80)
    
    local CheckMark = Instance.new("Frame")
    CheckMark.Size = UDim2.new(1, -4, 1, -4)
    CheckMark.Position = UDim2.new(0, 2, 0, 2)
    CheckMark.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
    CheckMark.Visible = false
    CheckMark.Parent = Check
    Instance.new("UICorner", CheckMark).CornerRadius = UDim.new(0, 2)

    task.spawn(function()
        while Row.Parent do
            local found = false
            if lp:FindFirstChild("Elements") and lp.Elements:FindFirstChild(elName) then found = true end
            CheckMark.Visible = found
            task.wait(1)
        end
    end)

    local UnlockBtn = Instance.new("TextButton")
    UnlockBtn.Size = UDim2.new(0.25, 0, 0.8, 0)
    UnlockBtn.Position = UDim2.new(0.73, 0, 0.1, 0)
    UnlockBtn.BackgroundColor3 = Color3.fromRGB(40, 120, 60)
    UnlockBtn.Text = "UNLOCK"
    UnlockBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    UnlockBtn.Font = Enum.Font.GothamBold
    UnlockBtn.TextSize = 9
    UnlockBtn.Parent = Row
    Instance.new("UICorner", UnlockBtn).CornerRadius = UDim.new(0, 4)
    UnlockBtn.MouseButton1Click:Connect(function()
        rEvents.elementMasteryEvent:FireServer(elName)
        UnlockBtn.Text = "..."
        task.wait(0.5)
        UnlockBtn.Text = "UNLOCK"
    end)
end

-- ==================================================
-- 5. EXTRA TAB
-- ==================================================
local ExtraScroll = createScroll(ExtraPage)
AddButton(ExtraScroll, "Inf Crystals (Glitch)", function()
    rEvents.zenMasterEvent:FireServer("convertGems", -1e+50)
end, Color3.fromRGB(160, 40, 160))

-- ==================================================
-- 6. PLAYER TAB
-- ==================================================
local PlayerScroll = createScroll(PlayerPage)
AddButton(PlayerScroll, "Inf Jumps (999M)", function() lp.multiJumpCount.Value = 999999999 end)
AddButton(PlayerScroll, "Speed X200", function() lp.Character.Humanoid.WalkSpeed = 200 end)
AddButton(PlayerScroll, "Jump Power 300", function() lp.Character.Humanoid.JumpPower = 300 end)
AddButton(PlayerScroll, "Unlock Elements", function() for _, v in pairs(game:GetService("ReplicatedStorage").Elements:GetChildren()) do rEvents.elementMasteryEvent:FireServer(v.Name) end end, Color3.fromRGB(80, 60, 120))
AddButton(PlayerScroll, "Open All Chests", function()
    for _, v in pairs(workspace:GetChildren()) do
        if v:FindFirstChild("Chest") and v:FindFirstChild("circleInner") then
            firetouchinterest(lp.Character.HumanoidRootPart, v.circleInner, 0)
            task.wait()
            firetouchinterest(lp.Character.HumanoidRootPart, v.circleInner, 1)
        end
    end
end, Color3.fromRGB(120, 80, 40))
