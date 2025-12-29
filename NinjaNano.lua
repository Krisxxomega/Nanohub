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

-- Специальные списки для Chi и Karma
local ChiIslands = {
    {name = "Soul Fusion Island", id = 18},
    {name = "Chaos Legends Island", id = 17},
    {name = "Skystorm Ultraus Island", id = 16},
    {name = "Golden Master Island", id = 13}
}

local KarmaIslands = {
    {name = "Mythical Souls Island", id = 11}
}

-- Список элементов
local ElementsList = {
    "Lightning",
    "Inferno",
    "Frost",
    "Shadowfire",
    "Electral Chaos",
    "Masterful Wrath",
    "Shadow Charge",
    "Eternity Storm",
    "Blazing Entity"
}

-- // UI SETUP //
if game.Players.LocalPlayer.PlayerGui:FindFirstChild("NanoNinja_v2") then
    game.Players.LocalPlayer.PlayerGui.NanoNinja_v2:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NanoNinja_v2"
ScreenGui.Parent = lp.PlayerGui
ScreenGui.ResetOnSpawn = false

-- // ANTI-AFK //
lp.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- // ФУНКЦИЯ ПЕРЕТАСКИВАНИЯ (UNIVERSAL DRAG) //
local function MakeDraggable(triggerObject, moveObject)
    local dragging = false
    local dragInput, dragStart, startPos

    local function update(input)
        local delta = input.Position - dragStart
        local targetPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        TweenService:Create(moveObject, TweenInfo.new(0.1), {Position = targetPos}):Play()
    end

    triggerObject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = moveObject.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    triggerObject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

-- // RGB ЭФФЕКТ //
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

-- ==========================
-- КРУГЛАЯ ИКОНКА (MINIMIZED)
-- ==========================
local OpenIcon = Instance.new("Frame")
OpenIcon.Size = UDim2.new(0, 55, 0, 55)
OpenIcon.Position = UDim2.new(0.05, 0, 0.15, 0) 
OpenIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
OpenIcon.Visible = false
OpenIcon.Parent = ScreenGui
OpenIcon.ZIndex = 10
OpenIcon.Active = true 
Instance.new("UICorner", OpenIcon).CornerRadius = UDim.new(1, 0)
AddRainbow(OpenIcon)
MakeDraggable(OpenIcon, OpenIcon)

local IconBtn = Instance.new("TextButton")
IconBtn.Size = UDim2.new(1, -6, 1, -6)
IconBtn.Position = UDim2.new(0, 3, 0, 3)
IconBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
IconBtn.Text = "v2"
IconBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
IconBtn.Font = Enum.Font.GothamBlack
IconBtn.TextSize = 20
IconBtn.Parent = OpenIcon
IconBtn.ZIndex = 11
Instance.new("UICorner", IconBtn).CornerRadius = UDim.new(1, 0)

-- ==========================
-- MAIN GUI
-- ==========================
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 500, 0, 320)
Main.Position = UDim2.new(0.5, -250, 0.5, -160)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Parent = ScreenGui
Main.Active = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

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

MakeDraggable(SidebarOverlay, Main)

local Logo = Instance.new("TextLabel")
Logo.Size = UDim2.new(1, -35, 0, 25)
Logo.Position = UDim2.new(0, 8, 0, 8)
Logo.Text = "nano v2"
Logo.TextColor3 = Color3.fromRGB(255, 255, 255)
Logo.Font = Enum.Font.GothamBlack
Logo.TextSize = 14
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

local MenuContainer = Instance.new("Frame")
MenuContainer.Size = UDim2.new(1, 0, 1, -80)
MenuContainer.Position = UDim2.new(0, 0, 0, 40)
MenuContainer.BackgroundTransparency = 1
MenuContainer.Parent = SidebarOverlay
MenuContainer.ZIndex = 3

local MenuListLayout = Instance.new("UIListLayout", MenuContainer)
MenuListLayout.SortOrder = Enum.SortOrder.LayoutOrder
MenuListLayout.Padding = UDim.new(0, 5)
MenuListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- // ЛОГИКА СВОРАЧИВАНИЯ //
local isMinimized = false
local function ToggleUI()
    if isMinimized then
        OpenIcon:TweenSize(UDim2.new(0, 0, 0, 0), "Out", "Quad", 0.2, true)
        task.wait(0.1)
        OpenIcon.Visible = false
        Main.Visible = true
        Main:TweenSize(UDim2.new(0, 500, 0, 320), "Out", "Back", 0.3, true)
        isMinimized = false
    else
        Main:TweenSize(UDim2.new(0, 500, 0, 0), "In", "Quad", 0.2, true)
        task.wait(0.2)
        Main.Visible = false
        OpenIcon.Visible = true
        OpenIcon:TweenSize(UDim2.new(0, 55, 0, 55), "Out", "Back", 0.3, true)
        isMinimized = true
    end
end
MiniBtn.MouseButton1Click:Connect(ToggleUI)
IconBtn.MouseButton1Click:Connect(ToggleUI)

-- // CONTENT AREA //
local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -120, 1, -10)
ContentArea.Position = UDim2.new(0, 115, 0, 5)
ContentArea.BackgroundTransparency = 1
ContentArea.Parent = Main
-- // FLY SYSTEM (MOBILE & PC) //
local FlySettings = {
    speed = 50,
    flying = false
}

local function CreateFlyUI()
    if ScreenGui:FindFirstChild("FlyMenu") then ScreenGui.FlyMenu:Destroy() end

    local FlyMenu = Instance.new("Frame")
    FlyMenu.Name = "FlyMenu"
    FlyMenu.Size = UDim2.new(0, 150, 0, 100)
    FlyMenu.Position = UDim2.new(0.5, 100, 0.5, -50)
    FlyMenu.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    FlyMenu.Parent = ScreenGui
    FlyMenu.Active = true
    Instance.new("UICorner", FlyMenu).CornerRadius = UDim.new(0, 10)
    AddRainbow(FlyMenu) -- Твой RGB эффект
    MakeDraggable(FlyMenu, FlyMenu)

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 25)
    Title.BackgroundTransparency = 1
    Title.Text = "FLY CONTROL"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 10
    Title.Parent = FlyMenu

    local SpeedInput = Instance.new("TextBox")
    SpeedInput.Size = UDim2.new(0.8, 0, 0, 25)
    SpeedInput.Position = UDim2.new(0.1, 0, 0.3, 0)
    SpeedInput.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    SpeedInput.Text = tostring(FlySettings.speed)
    SpeedInput.TextColor3 = Color3.fromRGB(255, 200, 50)
    SpeedInput.Font = Enum.Font.GothamMedium
    SpeedInput.TextSize = 12
    SpeedInput.Parent = FlyMenu
    Instance.new("UICorner", SpeedInput).CornerRadius = UDim.new(0, 4)

    SpeedInput.FocusLost:Connect(function()
        local n = tonumber(SpeedInput.Text)
        if n then FlySettings.speed = n else SpeedInput.Text = tostring(FlySettings.speed) end
    end)

    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Size = UDim2.new(0.8, 0, 0, 25)
    ToggleBtn.Position = UDim2.new(0.1, 0, 0.65, 0)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
    ToggleBtn.Text = "TOGGLE FLY"
    ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleBtn.Font = Enum.Font.GothamBold
    ToggleBtn.TextSize = 10
    ToggleBtn.Parent = FlyMenu
    Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 4)

    ToggleBtn.MouseButton1Click:Connect(function()
        FlySettings.flying = not FlySettings.flying
        ToggleBtn.BackgroundColor3 = FlySettings.flying and Color3.fromRGB(60, 120, 60) or Color3.fromRGB(45, 45, 50)
        
        local char = lp.Character
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        if FlySettings.flying then
            local bg = Instance.new("BodyGyro", hrp)
            bg.Name = "FlyGyro"
            bg.P = 9e4
            bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
            bg.cframe = hrp.CFrame
            
            local bv = Instance.new("BodyVelocity", hrp)
            bv.Name = "FlyVel"
            bv.velocity = Vector3.new(0, 0.1, 0)
            bv.maxForce = Vector3.new(9e9, 9e9, 9e9)

            task.spawn(function()
                while FlySettings.flying and char.Parent do
                    local cam = workspace.CurrentCamera
                    local moveDir = char.Humanoid.MoveDirection
                    local up = UserInputService:IsKeyDown(Enum.KeyCode.Space) and 1 or (UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) and -1 or 0)
                    
                    -- Адаптация под мобильные (если нет кнопок, летит по направлению камеры)
                    if moveDir.Magnitude > 0 then
                        bv.velocity = (cam.CFrame.LookVector * moveDir.Z + cam.CFrame.RightVector * moveDir.X).Unit * FlySettings.speed
                    else
                        bv.velocity = Vector3.new(0, 0.1, 0)
                    end
                    
                    -- Обработка высоты (Space)
                    if up ~= 0 then
                        bv.velocity = bv.velocity + Vector3.new(0, up * FlySettings.speed, 0)
                    end

                    bg.cframe = cam.CFrame
                    task.wait()
                end
                bg:Destroy()
                bv:Destroy()
            end)
        end
    end)
end

-- // TABS SYSTEM //
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

    tabs[name] = {b = b, page = page}
    return page
end

local MainPage = createTab("MAIN", 1)
local AutofarmPage = createTab("AUTOFARM", 2)
local WorldPage = createTab("WORLD", 3)
local PlayerPage = createTab("PLAYER", 4)
local ExtraPage = createTab("EXTRA", 5)
local ElementsPage = createTab("ELEMENTS", 6)

tabs["MAIN"].page.Visible = true
tabs["MAIN"].b.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
tabs["MAIN"].b.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Helper Functions
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

local function AddToggle(parent, text, globalVar, callback)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0.98, 0, 0, 32)
    b.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    b.Text = text .. " [OFF]"
    b.TextColor3 = Color3.fromRGB(255, 100, 100)
    b.Font = Enum.Font.GothamMedium
    b.TextSize = 11
    b.Parent = parent
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    b.MouseButton1Click:Connect(function()
        getgenv()[globalVar] = not getgenv()[globalVar]
        b.Text = text .. (getgenv()[globalVar] and " [ON]" or " [OFF]")
        b.TextColor3 = getgenv()[globalVar] and Color3.fromRGB(100, 255, 120) or Color3.fromRGB(255, 100, 100)
        if getgenv()[globalVar] then
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

local function CreateSelector(parent, title, dataList, teleportFunc)
    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(0.98, 0, 0, 85)
    Container.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    Container.Parent = parent
    Instance.new("UICorner", Container).CornerRadius = UDim.new(0, 8)

    local TitleLbl = Instance.new("TextLabel")
    TitleLbl.Size = UDim2.new(1, 0, 0, 20)
    TitleLbl.Position = UDim2.new(0, 0, 0, 5)
    TitleLbl.BackgroundTransparency = 1
    TitleLbl.Text = title
    TitleLbl.TextColor3 = Color3.fromRGB(150, 150, 150)
    TitleLbl.Font = Enum.Font.GothamBold
    TitleLbl.TextSize = 10
    TitleLbl.Parent = Container

    local currentIndex = 1
    
    local NameDisplay = Instance.new("TextLabel")
    NameDisplay.Size = UDim2.new(0.6, 0, 0, 25)
    NameDisplay.Position = UDim2.new(0.2, 0, 0, 25)
    NameDisplay.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    NameDisplay.TextColor3 = Color3.fromRGB(255, 200, 50)
    NameDisplay.Font = Enum.Font.GothamMedium
    NameDisplay.TextSize = 10
    NameDisplay.TextWrapped = true
    NameDisplay.Parent = Container
    Instance.new("UICorner", NameDisplay).CornerRadius = UDim.new(0, 4)

    local function UpdateText()
        local item = dataList[currentIndex]
        if type(item) == "string" then
            NameDisplay.Text = item
        else
            NameDisplay.Text = "["..item.id.."] " .. item.name
        end
    end
    UpdateText()

    local PrevBtn = Instance.new("TextButton")
    PrevBtn.Size = UDim2.new(0.15, 0, 0, 25)
    PrevBtn.Position = UDim2.new(0.03, 0, 0, 25)
    PrevBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
    PrevBtn.Text = "<"
    PrevBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    PrevBtn.Font = Enum.Font.GothamBold
    PrevBtn.Parent = Container
    Instance.new("UICorner", PrevBtn).CornerRadius = UDim.new(0, 4)
    PrevBtn.MouseButton1Click:Connect(function()
        currentIndex = currentIndex - 1
        if currentIndex < 1 then currentIndex = #dataList end
        UpdateText()
    end)

    local NextBtn = Instance.new("TextButton")
    NextBtn.Size = UDim2.new(0.15, 0, 0, 25)
    NextBtn.Position = UDim2.new(0.82, 0, 0, 25)
    NextBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
    NextBtn.Text = ">"
    NextBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    NextBtn.Font = Enum.Font.GothamBold
    NextBtn.Parent = Container
    Instance.new("UICorner", NextBtn).CornerRadius = UDim.new(0, 4)
    NextBtn.MouseButton1Click:Connect(function()
        currentIndex = currentIndex + 1
        if currentIndex > #dataList then currentIndex = 1 end
        UpdateText()
    end)

    local TpBtn = Instance.new("TextButton")
    TpBtn.Size = UDim2.new(0.94, 0, 0, 25)
    TpBtn.Position = UDim2.new(0.03, 0, 1, -30)
    TpBtn.BackgroundColor3 = Color3.fromRGB(60, 100, 60)
    TpBtn.Text = "SELECT / GET"
    TpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    TpBtn.Font = Enum.Font.GothamBold
    TpBtn.TextSize = 12
    TpBtn.Parent = Container
    Instance.new("UICorner", TpBtn).CornerRadius = UDim.new(0, 6)

    TpBtn.MouseButton1Click:Connect(function()
        local item = dataList[currentIndex]
        local targetName = (type(item) == "string") and item or item.name
        teleportFunc(targetName)
    end)
end

-- ==================================================
-- 1. MAIN TAB (NEW)
-- ==================================================
local MainScroll = createScroll(MainPage)

-- Info Container
local InfoFrame = Instance.new("Frame")
InfoFrame.Size = UDim2.new(0.98, 0, 0, 40)
InfoFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
InfoFrame.Parent = MainScroll
Instance.new("UICorner", InfoFrame).CornerRadius = UDim.new(0, 8)

local PlaceLabel = Instance.new("TextLabel")
PlaceLabel.Size = UDim2.new(1, 0, 1, 0)
PlaceLabel.BackgroundTransparency = 1
PlaceLabel.Text = "Place ID: " .. game.PlaceId
PlaceLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
PlaceLabel.Font = Enum.Font.GothamMedium
PlaceLabel.TextSize = 12
PlaceLabel.Parent = InfoFrame

AddButton(MainScroll, "REJOIN SERVER", function()
    TeleportService:Teleport(game.PlaceId, lp)
end, Color3.fromRGB(150, 50, 50))

local AfkStatus = Instance.new("TextLabel")
AfkStatus.Size = UDim2.new(0.98, 0, 0, 30)
AfkStatus.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
AfkStatus.Text = "ANTI-AFK: ACTIVE"
AfkStatus.TextColor3 = Color3.fromRGB(100, 255, 120)
AfkStatus.Font = Enum.Font.GothamBold
AfkStatus.TextSize = 12
AfkStatus.Parent = MainScroll
Instance.new("UICorner", AfkStatus).CornerRadius = UDim.new(0, 8)

-- ==================================================
-- 2. AUTOFARM TAB
-- ==================================================
local AutoScroll = createScroll(AutofarmPage)

AddToggle(AutoScroll, "Auto Swing", "autoswing", function()
    for _, v in pairs(lp.Backpack:GetChildren()) do
        if v:FindFirstChild("ninjitsuGain") then lp.Character.Humanoid:EquipTool(v) break end
    end
    ninjaEvent:FireServer("swingKatana")
end)

AddToggle(AutoScroll, "Auto Sell (Standard)", "autosell", function()
    workspace.sellAreaCircles["sellAreaCircle16"].circleInner.CFrame = lp.Character.HumanoidRootPart.CFrame
    task.wait(0.1)
    workspace.sellAreaCircles["sellAreaCircle16"].circleInner.CFrame = CFrame.new(0, 0, 0)
end)

AddToggle(AutoScroll, "Auto Sell 35x (Blazing)", "autosell35", function()
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

AddToggle(AutoScroll, "Auto Buy Ranks", "autobuyranks", function()
    for _, v in pairs(game:GetService("ReplicatedStorage").Ranks.Ground:GetChildren()) do ninjaEvent:FireServer("buyRank", v.Name) end
end)

AddToggle(AutoScroll, "Auto Buy Belts", "autobuybelts", function() ninjaEvent:FireServer("buyAllBelts", "Inner Peace Island") end)
AddToggle(AutoScroll, "Auto Buy Swords", "autobuy", function() ninjaEvent:FireServer("buyAllSwords", "Inner Peace Island") end)
AddToggle(AutoScroll, "Auto Buy Skills", "autobuyskills", function() ninjaEvent:FireServer("buyAllSkills", "Inner Peace Island") end)

AddButton(AutoScroll, "Unlock All Islands", function()
    for _, v in pairs(workspace.islandUnlockParts:GetChildren()) do
        firetouchinterest(lp.Character.HumanoidRootPart, v, 0)
        firetouchinterest(lp.Character.HumanoidRootPart, v, 1)
    end
end)

AddButton(AutoScroll, "Collect All Hoops", function()
    for _, v in pairs(workspace.Hoops:GetChildren()) do
        if v:IsA("MeshPart") then
            v.touchPart.CFrame = lp.Character.HumanoidRootPart.CFrame
            task.wait(0.05)
            v.touchPart.CFrame = CFrame.new(0,0,0)
        end
    end
end)

-- ==================================================
-- 3. WORLD TAB
-- ==================================================
local WorldScroll = createScroll(WorldPage)

local ReversedIslands = {}
for i = #IslandsOrdered, 1, -1 do
    table.insert(ReversedIslands, IslandsOrdered[i])
end

CreateSelector(WorldScroll, "ALL ISLANDS (High to Low)", ReversedIslands, function(name)
    if workspace.islandUnlockParts:FindFirstChild(name) then
        lp.Character.HumanoidRootPart.CFrame = workspace.islandUnlockParts[name].CFrame
    end
end)

CreateSelector(WorldScroll, "CHI CHEST ISLANDS", ChiIslands, function(name)
    if workspace.islandUnlockParts:FindFirstChild(name) then
        lp.Character.HumanoidRootPart.CFrame = workspace.islandUnlockParts[name].CFrame
    end
end)

CreateSelector(WorldScroll, "KARMA ISLANDS", KarmaIslands, function(name)
    if workspace.islandUnlockParts:FindFirstChild(name) then
        lp.Character.HumanoidRootPart.CFrame = workspace.islandUnlockParts[name].CFrame
    end
end)

-- ==================================================
-- 4. PLAYER TAB
-- ==================================================
local PlayerScroll = createScroll(PlayerPage)

AddButton(PlayerScroll, "OPEN SHOP", function()
    workspace.shopAreaCircles.shopAreaCircle19.circleInner.CFrame = lp.Character.HumanoidRootPart.CFrame
    task.wait(0.4)
    workspace.shopAreaCircles.shopAreaCircle19.circleInner.CFrame = CFrame.new(0, 0, 0)
end, Color3.fromRGB(60, 120, 60))
AddButton(PlayerScroll, "Open Fly Menu (Custom)", function()
    CreateFlyUI()
end, Color3.fromRGB(100, 60, 150))

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

-- ==================================================
-- 5. EXTRA TAB (NEW)
-- ==================================================
local ExtraScroll = createScroll(ExtraPage)

AddButton(ExtraScroll, "Inf Crystals (Glitch)", function()
    rEvents.zenMasterEvent:FireServer("convertGems", -1e+50) -- Massive negative number
end, Color3.fromRGB(160, 40, 160))

-- ==================================================
-- 6. ELEMENTS TAB (NEW)
-- ==================================================
local ElementsScroll = createScroll(ElementsPage)

-- Selector for single element
CreateSelector(ElementsScroll, "CHOOSE ELEMENT", ElementsList, function(name)
    rEvents.elementMasteryEvent:FireServer(name)
end)

AddButton(ElementsScroll, "Get All Elements (Glitch Method)", function()
    -- ТВОЙ КОД, БЕЗ ИЗМЕНЕНИЙ ЛОГИКИ, ТОЛЬКО СИНТАКСИС LUA
    if game.Players.LocalPlayer.PlayerGui.gameGui.sideButtons.excludeFolder.gemsFrame.amountLabel.Text:lower() == "inf" then
        game.ReplicatedStorage.rEvents.zenMasterEvent:FireServer("convertGems", 1e+124)
    else
        game.ReplicatedStorage.rEvents.zenMasterEvent:FireServer("convertGems", -math.huge)
        for Y, k in pairs({
            "Shadow Charge",
            "Electral Chaos",
            "Blazing Entity",
            "Shadowfire",
            "Lightning",
            "Masterful Wrath",
            "Inferno",
            "Eternity Storm",
            "Frost"
        }) do
            pcall(function()
                game.ReplicatedStorage.rEvents.elementMasteryEvent:FireServer(k)
            end)
        end
    end
end, Color3.fromRGB(200, 150, 50))
