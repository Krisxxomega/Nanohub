local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "NanoHub Ultimate | Multi-Game",
   LoadingTitle = "NanoHub Suite",
   LoadingSubtitle = "by Gemini",
   ConfigurationSaving = {
      Enabled = false
   },
   KeySystem = false
})

-- == CUSTOM MINI-MENU FUNCTION ==
local function OpenMiniMenu(gameName, scripts)
    -- Удаляем старое меню если есть
    if game.CoreGui:FindFirstChild("NanoGameMenu_"..gameName) then
        game.CoreGui["NanoGameMenu_"..gameName]:Destroy()
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "NanoGameMenu_"..gameName
    ScreenGui.Parent = game.CoreGui

    local Frame = Instance.new("Frame")
    Frame.Parent = ScreenGui
    Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Frame.BorderSizePixel = 0
    Frame.Position = UDim2.new(0.5, -150, 0.5, -100)
    Frame.Size = UDim2.new(0, 300, 0, 250)
    Frame.Active = true
    Frame.Draggable = true

    local Title = Instance.new("TextLabel")
    Title.Parent = Frame
    Title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Title.Size = UDim2.new(1, -40, 0, 30)
    Title.Font = Enum.Font.GothamBold
    Title.Text = "  " .. gameName
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 14
    Title.TextXAlignment = Enum.TextXAlignment.Left

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Parent = Frame
    CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    CloseBtn.Position = UDim2.new(1, -40, 0, 0)
    CloseBtn.Size = UDim2.new(0, 40, 0, 30)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.Text = "-"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.TextSize = 18

    CloseBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    local Scroll = Instance.new("ScrollingFrame")
    Scroll.Parent = Frame
    Scroll.BackgroundTransparency = 1
    Scroll.Position = UDim2.new(0, 0, 0, 35)
    Scroll.Size = UDim2.new(1, 0, 1, -35)
    Scroll.ScrollBarThickness = 4

    local UIList = Instance.new("UIListLayout")
    UIList.Parent = Scroll
    UIList.SortOrder = Enum.SortOrder.LayoutOrder
    UIList.Padding = UDim.new(0, 5)

    if #scripts == 0 then
        local EmptyLbl = Instance.new("TextLabel")
        EmptyLbl.Parent = Scroll
        EmptyLbl.Size = UDim2.new(1, 0, 0, 50)
        EmptyLbl.BackgroundTransparency = 1
        EmptyLbl.Text = "(Пусто / Empty)"
        EmptyLbl.TextColor3 = Color3.fromRGB(150, 150, 150)
        EmptyLbl.Font = Enum.Font.Gotham
    else
        for _, scriptData in pairs(scripts) do
            local Btn = Instance.new("TextButton")
            Btn.Parent = Scroll
            Btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            Btn.Size = UDim2.new(1, -10, 0, 35)
            Btn.Font = Enum.Font.Gotham
            Btn.Text = scriptData.Name
            Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            Btn.TextSize = 14
            
            Btn.MouseButton1Click:Connect(function()
                pcall(scriptData.Callback)
            end)
        end
    end
end

-- == TABS ==

-- 1. UNIVERSAL TAB
local UniversalTab = Window:CreateTab("Universal", 4483362458)

UniversalTab:CreateButton({
   Name = "Infinite Yield (Latest)",
   Callback = function()
       loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
   end,
})

UniversalTab:CreateButton({
   Name = "Position Finder",
   Callback = function()
       loadstring(game:HttpGet("https://raw.githubusercontent.com/LiarRise/Copy-Location/refs/heads/main/README.md"))()
   end,
})

UniversalTab:CreateSlider({
   Name = "WalkSpeed",
   Range = {16, 500},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 16,
   Flag = "WS",
   Callback = function(Value)
       pcall(function() game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value end)
   end,
})

UniversalTab:CreateSlider({
   Name = "JumpPower",
   Range = {50, 1000},
   Increment = 1,
   Suffix = "Power",
   CurrentValue = 50,
   Flag = "JP",
   Callback = function(Value)
       pcall(function() game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value end)
   end,
})

-- 2. GAMES TAB
local GamesTab = Window:CreateTab("Games", 4483362458)

-- 1. Ninja Legends
GamesTab:CreateButton({
   Name = "1. Ninja Legends",
   Callback = function()
       OpenMiniMenu("Ninja Legends", {
           {
               Name = "Load NanoHub V2",
               Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Krisxxomega/Nanohub/main/NinjaNanoV2.lua"))() end
           },
           {
               Name = "Load Convector",
               Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Krisxxomega/Nanohub/main/Convector.lua"))() end
           }
       })
   end,
})

-- 2. Muscle Legends
GamesTab:CreateButton({
   Name = "2. Muscle Legends",
   Callback = function()
       OpenMiniMenu("Muscle Legends", {})
   end,
})

-- 3. 3008
GamesTab:CreateButton({
   Name = "3. 3008",
   Callback = function()
       OpenMiniMenu("3008", {})
   end,
})

-- 4. 99 night in the forest
GamesTab:CreateButton({
   Name = "4. 99 night in the forest",
   Callback = function()
       OpenMiniMenu("99 Night in the Forest", {})
   end,
})

-- 5. Doors
GamesTab:CreateButton({
   Name = "5. Doors",
   Callback = function()
       OpenMiniMenu("Doors", {})
   end,
})

-- 6. Natural Disaster
GamesTab:CreateButton({
   Name = "6. Natural Disaster",
   Callback = function()
       OpenMiniMenu("Natural Disaster", {})
   end,
})

-- 7. Break in 1 (Story)
GamesTab:CreateButton({
   Name = "7. Break in 1 (Story)",
   Callback = function()
       OpenMiniMenu("Break In 1", {})
   end,
})

-- 8. Tower of Hell
GamesTab:CreateButton({
   Name = "8. Tower of Hell",
   Callback = function()
       OpenMiniMenu("Tower of Hell", {})
   end,
})

-- 3. VISUALS TAB (Spectator, ESP)
local VisualsTab = Window:CreateTab("Visuals", 4483362458)

local ESP_Settings = {Enabled = false, Tracers = false, Studs = false, Color = Color3.fromRGB(255,0,0)}
local RunService = game:GetService("RunService")

RunService.RenderStepped:Connect(function()
    if ESP_Settings.Enabled then
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                -- Highlights
                if not v.Character:FindFirstChild("NanoHighlight") then
                    local hl = Instance.new("Highlight", v.Character)
                    hl.Name = "NanoHighlight"
                    hl.FillColor = ESP_Settings.Color
                    hl.OutlineColor = ESP_Settings.Color
                end
                
                -- Tracers
                if ESP_Settings.Tracers then
                    if not v.Character:FindFirstChild("NanoBeam") then
                        local att0 = Instance.new("Attachment", game.Players.LocalPlayer.Character.HumanoidRootPart)
                        local att1 = Instance.new("Attachment", v.Character.HumanoidRootPart)
                        local beam = Instance.new("Beam", v.Character)
                        beam.Name = "NanoBeam"
                        beam.Attachment0 = att0
                        beam.Attachment1 = att1
                        beam.Color = ColorSequence.new(ESP_Settings.Color)
                        beam.FaceCamera = true
                        beam.Width0 = 0.1
                        beam.Width1 = 0.1
                    end
                else
                     if v.Character:FindFirstChild("NanoBeam") then v.Character.NanoBeam:Destroy() end
                end

                -- Studs
                if ESP_Settings.Studs and v.Character:FindFirstChild("Head") then
                    if not v.Character.Head:FindFirstChild("NanoStuds") then
                        local bgui = Instance.new("BillboardGui", v.Character.Head)
                        bgui.Name = "NanoStuds"
                        bgui.Size = UDim2.new(0, 100, 0, 50)
                        bgui.StudsOffset = Vector3.new(0, 2, 0)
                        bgui.AlwaysOnTop = true
                        local lbl = Instance.new("TextLabel", bgui)
                        lbl.BackgroundTransparency = 1
                        lbl.Size = UDim2.new(1,0,1,0)
                        lbl.TextColor3 = Color3.new(1,1,1)
                        lbl.TextStrokeTransparency = 0
                    end
                    local dist = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
                    v.Character.Head.NanoStuds.TextLabel.Text = math.floor(dist) .. " Studs"
                else
                    if v.Character:FindFirstChild("Head") and v.Character.Head:FindFirstChild("NanoStuds") then v.Character.Head.NanoStuds:Destroy() end
                end
            end
        end
    else
        for _, v in pairs(game.Players:GetPlayers()) do
            if v.Character then
                if v.Character:FindFirstChild("NanoHighlight") then v.Character.NanoHighlight:Destroy() end
                if v.Character:FindFirstChild("NanoBeam") then v.Character.NanoBeam:Destroy() end
                if v.Character:FindFirstChild("Head") and v.Character.Head:FindFirstChild("NanoStuds") then v.Character.Head.NanoStuds:Destroy() end
            end
        end
    end
end)

VisualsTab:CreateToggle({
   Name = "ESP On/Off",
   CurrentValue = false,
   Flag = "ESPMain",
   Callback = function(Value) ESP_Settings.Enabled = Value end,
})

VisualsTab:CreateToggle({
   Name = "Tracers (Lines)",
   CurrentValue = false,
   Flag = "ESPLine",
   Callback = function(Value) ESP_Settings.Tracers = Value end,
})

VisualsTab:CreateToggle({
   Name = "Show Studs",
   CurrentValue = false,
   Flag = "ESPStuds",
   Callback = function(Value) ESP_Settings.Studs = Value end,
})

VisualsTab:CreateColorPicker({
    Name = "ESP Color",
    Color = Color3.fromRGB(255, 0, 0),
    Callback = function(Value)
        ESP_Settings.Color = Value
        -- Обновляем существующие хайлайты мгновенно
        for _, v in pairs(game.Players:GetPlayers()) do
            if v.Character and v.Character:FindFirstChild("NanoHighlight") then
                v.Character.NanoHighlight.FillColor = Value
                v.Character.NanoHighlight.OutlineColor = Value
            end
        end
    end,
})

-- Spectator GUI Function
local function SpectateGUI()
    if game.CoreGui:FindFirstChild("NanoSpectator") then return end
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "NanoSpectator"
    ScreenGui.Parent = game.CoreGui
    
    local Frame = Instance.new("Frame", ScreenGui)
    Frame.Size = UDim2.new(0, 200, 0, 100)
    Frame.Position = UDim2.new(0.5, -100, 0.8, 0)
    Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Frame.Active = true
    Frame.Draggable = true
    
    local Name = Instance.new("TextLabel", Frame)
    Name.Size = UDim2.new(1,0,0.3,0)
    Name.BackgroundTransparency = 1
    Name.TextColor3 = Color3.new(1,1,1)
    Name.Text = "Spectating..."
    
    local Left = Instance.new("TextButton", Frame)
    Left.Text = "<"
    Left.Size = UDim2.new(0.3,0,0.4,0)
    Left.Position = UDim2.new(0,0,0.3,0)
    
    local Right = Instance.new("TextButton", Frame)
    Right.Text = ">"
    Right.Size = UDim2.new(0.3,0,0.4,0)
    Right.Position = UDim2.new(0.7,0,0.3,0)
    
    local Teleport = Instance.new("TextButton", Frame)
    Teleport.Text = "TP to Player"
    Teleport.Size = UDim2.new(1,0,0.3,0)
    Teleport.Position = UDim2.new(0,0,0.7,0)
    Teleport.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
    
    local Close = Instance.new("TextButton", Frame)
    Close.Text = "X"
    Close.Size = UDim2.new(0, 20, 0, 20)
    Close.Position = UDim2.new(1, -20, 0, -20)
    Close.BackgroundColor3 = Color3.new(1,0,0)

    local players = game.Players:GetPlayers()
    local idx = 1
    
    local function update()
        players = game.Players:GetPlayers()
        if idx > #players then idx = 1 end
        if idx < 1 then idx = #players end
        local p = players[idx]
        Name.Text = p.Name
        workspace.CurrentCamera.CameraSubject = p.Character.Humanoid
    end
    
    Left.MouseButton1Click:Connect(function() idx = idx - 1; update() end)
    Right.MouseButton1Click:Connect(function() idx = idx + 1; update() end)
    Teleport.MouseButton1Click:Connect(function()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = players[idx].Character.HumanoidRootPart.CFrame
    end)
    Close.MouseButton1Click:Connect(function()
        workspace.CurrentCamera.CameraSubject = game.Players.LocalPlayer.Character.Humanoid
        ScreenGui:Destroy()
    end)
end

VisualsTab:CreateButton({
   Name = "Spectator Control Panel",
   Callback = SpectateGUI
})

Rayfield:LoadConfiguration()
