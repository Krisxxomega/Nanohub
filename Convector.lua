-- КОНВЕРТЕР КРИСТАЛОВ → МОНЕТЫ (прямой ввод)
local gui = Instance.new("ScreenGui")
gui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 350, 0, 120)
frame.Position = UDim2.new(0.5, -175, 0.5, -60)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
title.Text = "💎 Crystals → Coins (Вводи цифры)"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 16
title.Font = Enum.Font.GothamBold
title.Parent = frame

local input = Instance.new("TextBox")
input.Size = UDim2.new(0.75, 0, 0, 40)
input.Position = UDim2.new(0.125, 0, 0.35, 0)
input.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
input.Text = "9999999999999999"
input.TextColor3 = Color3.fromRGB(0, 255, 255)
input.TextSize = 18
input.Font = Enum.Font.Gotham
input.ClearTextOnFocus = false
input.Parent = frame

local convertBtn = Instance.new("TextButton")
convertBtn.Size = UDim2.new(0.75, 0, 0, 40)
convertBtn.Position = UDim2.new(0.125, 0, 0.75, 0)
convertBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
convertBtn.Text = "➕ КОНВЕРТИРОВАТЬ"
convertBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
convertBtn.TextSize = 16
convertBtn.Font = Enum.Font.GothamBold
convertBtn.Parent = frame

convertBtn.MouseButton1Click:Connect(function()
    local amount = tonumber(input.Text)
    
    if amount and amount > 0 then
        -- КОНВЕРСИЯ КРИСТАЛОВ В МОНЕТЫ (ремоут из твоего скрипта)
        local args = {
            [1] = "convertGems",  -- или "convertCrystals" — проверь SimpleSpy
            [2] = amount
        }
        
        game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("zenMasterEvent"):FireServer(unpack(args))
        
        input.Text = "✓ " .. amount .. " монет добавлено!"
        convertBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        wait(1)
        input.Text = amount  -- Возврат к числу
        convertBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        
        print("💰 Добавлено монет: " .. amount)
    else
        input.Text = "❌ Только цифры > 0!"
        convertBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        wait(1)
        convertBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    end
end)

print("✅ Конвертер кристаллов загружен!")