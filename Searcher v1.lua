--[[
    🔥 SEARCHNEO: COMPACT EDITION
    Build: v1.0 (Next Gen)
    Features: Multi-Tab Editor, Smart Images, Scroll Assist, Mini-UI
]]

local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

-- // CLEANUP //
if CoreGui:FindFirstChild("SearchNeo") then
    CoreGui.SearchNeo:Destroy()
end

-- // THEME CONFIG //
local C = {
    Bg = Color3.fromRGB(20, 20, 20),           -- Main Body
    Header = Color3.fromRGB(10, 10, 10),       -- Top Bar
    Card = Color3.fromRGB(30, 30, 30),         -- Card Bg
    Accent = Color3.fromRGB(120, 80, 255),     -- Neon Purple
    Text = Color3.fromRGB(240, 240, 240),      -- White
    SubText = Color3.fromRGB(140, 140, 140),   -- Grey
    Green = Color3.fromRGB(80, 255, 120),
    Red = Color3.fromRGB(255, 80, 80),
    ButtonHover = Color3.fromRGB(40, 40, 40)
}

-- // GUI SETUP //
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SearchNeo"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- 1. FLOATING TOGGLE
local ToggleBtn = Instance.new("ImageButton")
ToggleBtn.Name = "Toggle"
ToggleBtn.Size = UDim2.new(0, 40, 0, 40) -- Smaller
ToggleBtn.Position = UDim2.new(0.05, 0, 0.4, 0)
ToggleBtn.BackgroundColor3 = C.Header
ToggleBtn.Image = "rbxassetid://6031154871"
ToggleBtn.Parent = ScreenGui
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", ToggleBtn).Color = C.Accent
Instance.new("UIStroke", ToggleBtn).Thickness = 2

-- 2. MAIN WINDOW (COMPACT)
local Main = Instance.new("Frame")
Main.Name = "MainFrame"
Main.Size = UDim2.new(0, 440, 0, 270) -- Very Compact
Main.Position = UDim2.new(0.5, 0, 0.5, 0)
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.BackgroundColor3 = C.Bg
Main.ClipsDescendants = true
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)
local MainStroke = Instance.new("UIStroke")
MainStroke.Thickness = 1.5
MainStroke.Color = Color3.fromRGB(40,40,40)
MainStroke.Parent = Main

-- HEADER
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 28)
Header.BackgroundColor3 = C.Header
Header.Parent = Main

local Title = Instance.new("TextLabel")
Title.Text = "SearchNeo 🔥"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 12
Title.TextColor3 = C.Accent
Title.Size = UDim2.new(0, 100, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

-- Window Controls (- X)
local WinControls = Instance.new("Frame")
WinControls.Size = UDim2.new(0, 60, 1, 0)
WinControls.Position = UDim2.new(1, -60, 0, 0)
WinControls.BackgroundTransparency = 1
WinControls.Parent = Header

local BtnClose = Instance.new("TextButton")
BtnClose.Text = "×"
BtnClose.Size = UDim2.new(0, 30, 1, 0)
BtnClose.Position = UDim2.new(1, -30, 0, 0)
BtnClose.BackgroundTransparency = 1
BtnClose.TextColor3 = C.SubText
BtnClose.TextSize = 20
BtnClose.Parent = WinControls

local BtnMin = Instance.new("TextButton")
BtnMin.Text = "-"
BtnMin.Size = UDim2.new(0, 30, 1, 0)
BtnMin.Position = UDim2.new(0, 0, 0, 0)
BtnMin.BackgroundTransparency = 1
BtnMin.TextColor3 = C.SubText
BtnMin.TextSize = 20
BtnMin.Parent = WinControls

-- TABS CONTAINER (Top of Main)
local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, -120, 0, 28)
TabContainer.Position = UDim2.new(0, 100, 0, 0)
TabContainer.BackgroundTransparency = 1
TabContainer.Parent = Header
local TabListLayout = Instance.new("UIListLayout")
TabListLayout.FillDirection = Enum.FillDirection.Horizontal
TabListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
TabListLayout.Padding = UDim.new(0, 5)
TabListLayout.Parent = TabContainer

-- CONTENT PAGES
local PagesContainer = Instance.new("Frame")
PagesContainer.Size = UDim2.new(1, 0, 1, -28)
PagesContainer.Position = UDim2.new(0, 0, 0, 28)
PagesContainer.BackgroundTransparency = 1
PagesContainer.Parent = Main

-- GLOBALS
local Pages = {}
local TabButtons = {}
local ActiveTab = nil

-- FUNCTION: CREATE TAB
local function CreateMainTab(name)
    local btn = Instance.new("TextButton")
    btn.Text = name
    btn.Size = UDim2.new(0, 60, 1, 0)
    btn.BackgroundTransparency = 1
    btn.TextColor3 = C.SubText
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    btn.Parent = TabContainer
    
    local page = Instance.new("Frame")
    page.Name = name.."Page"
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.Parent = PagesContainer
    
    Pages[name] = page
    TabButtons[name] = btn
    
    btn.MouseButton1Click:Connect(function()
        for n, p in pairs(Pages) do p.Visible = false end
        for n, b in pairs(TabButtons) do b.TextColor3 = C.SubText end
        page.Visible = true
        btn.TextColor3 = C.Accent
        ActiveTab = name
    end)
end

CreateMainTab("Home")
CreateMainTab("Editor")
CreateMainTab("Universal")
CreateMainTab("Info")

-- Set Default
Pages.Home.Visible = true
TabButtons.Home.TextColor3 = C.Accent


-- // =========================
-- // TAB: HOME
-- // =========================
local Home = Pages.Home

-- LEFT: SCRIPT LIST AREA
local LeftArea = Instance.new("Frame")
LeftArea.Size = UDim2.new(0, 290, 1, -10)
LeftArea.Position = UDim2.new(0, 5, 0, 5)
LeftArea.BackgroundTransparency = 1
LeftArea.Parent = Home

-- Page Switcher (1 2 3 4)
local PageSwitcher = Instance.new("Frame")
PageSwitcher.Size = UDim2.new(1, 0, 0, 20)
PageSwitcher.BackgroundTransparency = 1
PageSwitcher.Parent = LeftArea
local PList = Instance.new("UIListLayout")
PList.FillDirection = Enum.FillDirection.Horizontal
PList.Padding = UDim.new(0, 4)
PList.Parent = PageSwitcher

local CurrentApiPage = 1
local IsLoading = false -- ДОБАВЛЕНО
local function CreatePageBtn(num)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, 20, 1, 0)
    b.BackgroundColor3 = C.Card
    b.Text = tostring(num)
    b.TextColor3 = C.SubText
    b.Font = Enum.Font.GothamBold
    b.TextSize = 10
    b.Parent = PageSwitcher
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
    return b
end
local PageBtns = {}
for i=1, 4 do PageBtns[i] = CreatePageBtn(i) end

-- Scroll & Grid
local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, -20, 1, -25) -- Leave space for page switcher
Scroll.Position = UDim2.new(0, 0, 0, 25)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 2
Scroll.ScrollBarImageColor3 = C.Accent
Scroll.Parent = LeftArea

local Grid = Instance.new("UIGridLayout")
Grid.CellSize = UDim2.new(0, 85, 0, 100) -- Small 3x3 cells
Grid.CellPadding = UDim2.new(0, 5, 0, 5)
Grid.Parent = Scroll

-- Scroll Arrows (Visual Assist)
local ArrowContainer = Instance.new("Frame")
ArrowContainer.Size = UDim2.new(0, 15, 1, -25)
ArrowContainer.Position = UDim2.new(1, -15, 0, 25)
ArrowContainer.BackgroundTransparency = 1
ArrowContainer.Parent = LeftArea

local UpArr = Instance.new("TextButton")
UpArr.Size = UDim2.new(1, 0, 0, 20)
UpArr.Text = "▲"
UpArr.BackgroundTransparency = 1
UpArr.TextColor3 = C.SubText
UpArr.Parent = ArrowContainer

local DownArr = Instance.new("TextButton")
DownArr.Size = UDim2.new(1, 0, 0, 20)
DownArr.Position = UDim2.new(0, 0, 1, -20)
DownArr.Text = "▼"
DownArr.BackgroundTransparency = 1
DownArr.TextColor3 = C.SubText
DownArr.Parent = ArrowContainer

-- Scrolling Logic
local ScrollSpeed = 0
local function HandleScroll(dir)
    ScrollSpeed = dir * 10
    local conn
    conn = RunService.RenderStepped:Connect(function()
        if ScrollSpeed == 0 then conn:Disconnect() return end
        Scroll.CanvasPosition = Vector2.new(0, Scroll.CanvasPosition.Y + ScrollSpeed)
    end)
end
UpArr.MouseButton1Down:Connect(function() HandleScroll(-1) end)
UpArr.MouseButton1Up:Connect(function() ScrollSpeed = 0 end)
DownArr.MouseButton1Down:Connect(function() HandleScroll(1) end)
DownArr.MouseButton1Up:Connect(function() ScrollSpeed = 0 end)


-- RIGHT: CONTROLS
local RightArea = Instance.new("Frame")
RightArea.Size = UDim2.new(1, -305, 1, -10)
RightArea.Position = UDim2.new(1, -5, 0, 5)
RightArea.AnchorPoint = Vector2.new(1, 0)
RightArea.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
RightArea.Parent = Home
Instance.new("UICorner", RightArea).CornerRadius = UDim.new(0, 8)

-- Search
local SearchBox = Instance.new("TextBox")
SearchBox.Size = UDim2.new(1, -10, 0, 25)
SearchBox.Position = UDim2.new(0, 5, 0, 5)
SearchBox.BackgroundColor3 = C.Card
SearchBox.PlaceholderText = "Search..."
SearchBox.Text = ""
SearchBox.TextColor3 = C.Text
SearchBox.Font = Enum.Font.Gotham
SearchBox.TextSize = 11
SearchBox.Parent = RightArea
Instance.new("UICorner", SearchBox).CornerRadius = UDim.new(0, 6)

local ClearSearch = Instance.new("TextButton")
ClearSearch.Size = UDim2.new(1, -10, 0, 15)
ClearSearch.Position = UDim2.new(0, 5, 0, 32)
ClearSearch.Text = "CLEAR"
ClearSearch.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
ClearSearch.TextColor3 = C.SubText
ClearSearch.Font = Enum.Font.GothamBold
ClearSearch.TextSize = 9
ClearSearch.Parent = RightArea
Instance.new("UICorner", ClearSearch).CornerRadius = UDim.new(0, 4)
ClearSearch.MouseButton1Click:Connect(function() SearchBox.Text = "" end)

-- Filters
local FilterLabel = Instance.new("TextLabel")
FilterLabel.Text = "FILTERS"
FilterLabel.Size = UDim2.new(1, 0, 0, 15)
FilterLabel.Position = UDim2.new(0, 0, 0, 55)
FilterLabel.TextColor3 = C.Accent
FilterLabel.BackgroundTransparency = 1
FilterLabel.Font = Enum.Font.GothamBold
FilterLabel.TextSize = 9
FilterLabel.Parent = RightArea

local FilterContainer = Instance.new("Frame")
FilterContainer.Size = UDim2.new(1, -10, 0, 60)
FilterContainer.Position = UDim2.new(0, 5, 0, 70)
FilterContainer.BackgroundTransparency = 1
FilterContainer.Parent = RightArea
local FL = Instance.new("UIListLayout"); FL.Padding = UDim.new(0, 4); FL.Parent = FilterContainer

local Filters = {HasKey = false, NoKey = false}
local function AddFilterBtn(txt, id)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 0, 18)
    b.BackgroundColor3 = C.Card
    b.Text = txt
    b.TextColor3 = C.SubText
    b.Font = Enum.Font.Gotham
    b.TextSize = 9
    b.Parent = FilterContainer
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
    return b
end
local BtnHasKey = AddFilterBtn("Has Key 🔑", "HasKey")
local BtnNoKey = AddFilterBtn("No Key 🟢", "NoKey")

-- Actions (Bottom)
local ActionContainer = Instance.new("Frame")
ActionContainer.Size = UDim2.new(1, -10, 0, 80)
ActionContainer.Position = UDim2.new(0, 5, 1, -5)
ActionContainer.AnchorPoint = Vector2.new(0, 1)
ActionContainer.BackgroundTransparency = 1
ActionContainer.Parent = RightArea
local AL = Instance.new("UIListLayout"); AL.VerticalAlignment = Enum.VerticalAlignment.Bottom; AL.Padding = UDim.new(0, 4); AL.Parent = ActionContainer

local function AddActionBtn(txt, col)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 0, 22)
    b.BackgroundColor3 = Color3.fromRGB(30, 30, 35) -- Disabled state
    b.Text = txt
    b.TextColor3 = Color3.fromRGB(100, 100, 100)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 9
    b.AutoButtonColor = false
    b.Parent = ActionContainer
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
    return b
end

local BtnExec = AddActionBtn("EXECUTE", C.Green)
local BtnCopy = AddActionBtn("COPY", C.Accent)
local BtnEdit = AddActionBtn("OPEN IN EDITOR", C.Accent)

-- // =========================
-- // LOGIC: EDITOR TABS
-- // =========================
local EditorTabsData = {} -- { {name="1", code="..."} }
local EditorTabList = nil
local EditorInput = nil
local CurrentEditorTab = 1

local function RefreshEditorUI()
    -- Clear Tab Buttons
    for _, v in pairs(Pages.Editor.TabsBar:GetChildren()) do 
        if v:IsA("TextButton") and v.Name ~= "Add" then v:Destroy() end 
    end
    
    -- Create Tab Buttons
    for i, data in ipairs(EditorTabsData) do
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(0, 25, 1, 0)
        b.BackgroundColor3 = (i == CurrentEditorTab) and C.Accent or C.Card
        b.Text = tostring(i)
        b.TextColor3 = C.Text
        b.Font = Enum.Font.GothamBold
        b.TextSize = 10
        b.Parent = Pages.Editor.TabsBar
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
        
        b.MouseButton1Click:Connect(function()
            EditorTabsData[CurrentEditorTab].code = EditorInput.Text -- Save prev
            CurrentEditorTab = i
            EditorInput.Text = EditorTabsData[i].code -- Load new
            RefreshEditorUI()
        end)
    end
    
    -- Move Add button to end
    Pages.Editor.TabsBar.Add.LayoutOrder = 999
end

local function NewEditorTab(startCode)
    table.insert(EditorTabsData, {code = startCode or "-- Tab "..(#EditorTabsData+1)})
    CurrentEditorTab = #EditorTabsData
    if EditorInput then EditorInput.Text = EditorTabsData[CurrentEditorTab].code end
    RefreshEditorUI()
    
    -- Switch to Editor Tab visually
    for n, p in pairs(Pages) do p.Visible = false end
    for n, b in pairs(TabButtons) do b.TextColor3 = C.SubText end
    Pages.Editor.Visible = true
    TabButtons.Editor.TextColor3 = C.Accent
end

-- SETUP EDITOR UI
local EBar = Instance.new("Frame")
EBar.Name = "TabsBar"
EBar.Size = UDim2.new(1, -10, 0, 25)
EBar.Position = UDim2.new(0, 5, 0, 5)
EBar.BackgroundTransparency = 1
EBar.Parent = Pages.Editor
local EL = Instance.new("UIListLayout"); EL.FillDirection = Enum.FillDirection.Horizontal; EL.Padding = UDim.new(0, 2); EL.Parent = EBar

local EAdd = Instance.new("TextButton")
EAdd.Name = "Add"
EAdd.Size = UDim2.new(0, 25, 1, 0)
EAdd.BackgroundColor3 = C.Card
EAdd.Text = "+"
EAdd.TextColor3 = C.Green
EAdd.Parent = EBar
Instance.new("UICorner", EAdd).CornerRadius = UDim.new(0, 4)
EAdd.MouseButton1Click:Connect(function() NewEditorTab() end)

EditorInput = Instance.new("TextBox")
EditorInput.Size = UDim2.new(1, -10, 1, -70)
EditorInput.Position = UDim2.new(0, 5, 0, 35)
EditorInput.BackgroundColor3 = C.Card
EditorInput.TextColor3 = C.Text
EditorInput.TextXAlignment = Enum.TextXAlignment.Left
EditorInput.TextYAlignment = Enum.TextYAlignment.Top
EditorInput.ClearTextOnFocus = false
EditorInput.MultiLine = true
EditorInput.Font = Enum.Font.Code
EditorInput.TextSize = 11
EditorInput.Parent = Pages.Editor
Instance.new("UICorner", EditorInput).CornerRadius = UDim.new(0, 6)

local EControls = Instance.new("Frame")
EControls.Size = UDim2.new(1, -10, 0, 25)
EControls.Position = UDim2.new(0, 5, 1, -5)
EControls.AnchorPoint = Vector2.new(0, 1)
EControls.BackgroundTransparency = 1
EControls.Parent = Pages.Editor
local ECL = Instance.new("UIListLayout"); ECL.FillDirection = Enum.FillDirection.Horizontal; ECL.Padding = UDim.new(0, 5); ECL.Parent = EControls

local function AddEBtn(txt, col, func)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0.32, 0, 1, 0)
    b.BackgroundColor3 = col
    b.Text = txt
    b.TextColor3 = C.Text
    b.Font = Enum.Font.GothamBold
    b.TextSize = 10
    b.Parent = EControls
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
    b.MouseButton1Click:Connect(func)
end

AddEBtn("CLEAR", C.Card, function() EditorInput.Text = "" end)
AddEBtn("PASTE", C.Card, function() if setclipboard then EditorInput.Text = getclipboard() end end)
AddEBtn("EXECUTE", C.Accent, function() loadstring(EditorInput.Text)() end)

NewEditorTab("-- Welcome to SearchNeo") -- Init 1 tab

-- // =========================
-- // LOGIC: SEARCH ENGINE
-- // =========================
local CurrentQuery = ""
local SelectedScript = nil
local RainbowTask = nil

-- Apply Filter Colors
local function UpdateFilterVisuals()
    BtnHasKey.BackgroundColor3 = Filters.HasKey and C.Accent or C.Card
    BtnHasKey.TextColor3 = Filters.HasKey and C.Text or C.SubText
    
    BtnNoKey.BackgroundColor3 = Filters.NoKey and C.Accent or C.Card
    BtnNoKey.TextColor3 = Filters.NoKey and C.Text or C.SubText
end

BtnHasKey.MouseButton1Click:Connect(function() Filters.HasKey = not Filters.HasKey; UpdateFilterVisuals(); NewSearch(SearchBox.Text) end)
BtnNoKey.MouseButton1Click:Connect(function() Filters.NoKey = not Filters.NoKey; UpdateFilterVisuals(); NewSearch(SearchBox.Text) end)

-- Toggle Actions
local function ToggleActions(on)
    local col = on and C.Accent or Color3.fromRGB(30,30,35)
    local txt = on and C.Text or Color3.fromRGB(100,100,100)
    BtnExec.BackgroundColor3 = on and C.Green or Color3.fromRGB(30,30,35)
    BtnCopy.BackgroundColor3 = col
    BtnEdit.BackgroundColor3 = col
    
    BtnExec.TextColor3 = txt
    BtnCopy.TextColor3 = txt
    BtnEdit.TextColor3 = txt
end

-- Create Card
local function AddCard(data)
    local btn = Instance.new("ImageButton")
    btn.BackgroundColor3 = C.Card
    btn.AutoButtonColor = false
    btn.Parent = Scroll
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    
    local stroke = Instance.new("UIStroke")
    stroke.Transparency = 1; stroke.Thickness = 2; stroke.Parent = btn

    -- Image Logic (Smart)
    local img = Instance.new("ImageLabel")
    img.Size = UDim2.new(1, 0, 0.6, 0)
    img.BackgroundTransparency = 1
    img.ScaleType = Enum.ScaleType.Crop
    img.Parent = btn
    Instance.new("UICorner", img).CornerRadius = UDim.new(0, 8)
    
if data.game and data.game.placeId and data.game.placeId > 0 then
    img.Image = "rbxthumb://type=GameIcon&id="..tostring(data.game.placeId).."&w=150&h=150"
else
    img.Image = "rbxassetid://10619149097"
    img.ImageColor3 = Color3.fromRGB(180,180,180)
end
    
    -- Title Container
    local tCont = Instance.new("Frame")
    tCont.Size = UDim2.new(1, 0, 0.4, 0)
    tCont.Position = UDim2.new(0, 0, 0.6, 0)
    tCont.BackgroundTransparency = 1
    tCont.Parent = btn
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -6, 0.6, 0)
    title.Position = UDim2.new(0, 3, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = data.title
    title.TextColor3 = C.Text
    title.TextWrapped = true
    title.TextSize = 9
    title.Font = Enum.Font.GothamBold
    title.Parent = tCont

    -- Stats
    local stats = Instance.new("TextLabel")
    stats.Size = UDim2.new(1, -6, 0.4, 0)
    stats.Position = UDim2.new(0, 3, 0.6, 0)
    stats.BackgroundTransparency = 1
    stats.TextColor3 = C.SubText
    stats.TextSize = 8
    stats.Font = Enum.Font.Gotham
    stats.Parent = tCont
    
local ver = data.verified and "✅ " or ""
    stats.Text = ver.."👁️"..(data.views or 0).." ❤️"..(data.likes or 0)

    -- Selection
    btn.MouseButton1Click:Connect(function()
        for _, c in pairs(Scroll:GetChildren()) do if c:IsA("ImageButton") then c.UIStroke.Transparency = 1 end end
        if RainbowTask then RainbowTask:Disconnect() end
        
        SelectedScript = data.script
        stroke.Transparency = 0
        ToggleActions(true)
        
        local h = 0
        RainbowTask = RunService.RenderStepped:Connect(function()
            h = tick() % 1.5 / 1.5
            stroke.Color = Color3.fromHSV(h, 0.8, 1)
        end)
    end)
end

-- Fetch Logic (УЛУЧШЕНО)
function Fetch(q, page)
    if IsLoading then return end -- ДОБАВЛЕНО
    IsLoading = true -- ДОБАВЛЕНО
    
    spawn(function()
        local mode = ""
        if Filters.NoKey and not Filters.HasKey then mode = "&mode=free"
        elseif Filters.HasKey and not Filters.NoKey then mode = "&mode=paid" end
        
        local url = "https://scriptblox.com/api/script/search?q="..HttpService:UrlEncode(q)..mode.."&page="..page
        local s, r = pcall(function() return game:HttpGet(url) end)
        if s then
            local d = HttpService:JSONDecode(r)
            if d and d.result and d.result.scripts then
                for _, s in pairs(d.result.scripts) do AddCard(s) end
                Scroll.CanvasSize = UDim2.new(0, 0, 0, Grid.AbsoluteContentSize.Y + 20)
            end
        end
        IsLoading = false -- ДОБАВЛЕНО
    end)
end

function NewSearch(q)
    for _, v in pairs(Scroll:GetChildren()) do if v:IsA("ImageButton") then v:Destroy() end end
    SelectedScript = nil
    ToggleActions(false)
    CurrentApiPage = 1 -- RESET PAGE
    CurrentQuery = q -- СОХРАНИТЬ QUERY
    Fetch(q, CurrentApiPage)
end

SearchBox.FocusLost:Connect(function(e) if e then NewSearch(SearchBox.Text) end end)

-- AUTO-SCROLL PAGINATION (ДОБАВЛЕНО)
Scroll:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
    if Scroll.CanvasPosition.Y + Scroll.AbsoluteWindowSize.Y >= Scroll.AbsoluteCanvasSize.Y - 50 then
        if not IsLoading and SearchBox.Text ~= "" then
            CurrentApiPage = CurrentApiPage + 1
            -- Обновляем кнопки визуально
            for _, btn in pairs(PageBtns) do btn.TextColor3 = C.SubText; btn.BackgroundColor3 = C.Card end
            if PageBtns[CurrentApiPage] and CurrentApiPage <= 4 then
                PageBtns[CurrentApiPage].TextColor3 = C.Accent
                PageBtns[CurrentApiPage].BackgroundColor3 = Color3.fromRGB(40,40,40)
            end
            Fetch(SearchBox.Text, CurrentApiPage)
        end
    end
end)

-- AUTO-SCROLL PAGINATION
Scroll:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
    if Scroll.CanvasPosition.Y + Scroll.AbsoluteWindowSize.Y >= Scroll.AbsoluteCanvasSize.Y - 50 then
        if not IsLoading and SearchBox.Text ~= "" then
            CurrentApiPage = CurrentApiPage + 1
            for _, btn in pairs(PageBtns) do btn.TextColor3 = C.SubText; btn.BackgroundColor3 = C.Card end
            if PageBtns[CurrentApiPage] and CurrentApiPage <= 4 then
                PageBtns[CurrentApiPage].TextColor3 = C.Accent
                PageBtns[CurrentApiPage].BackgroundColor3 = Color3.fromRGB(40,40,40)
            end
            Fetch(SearchBox.Text, CurrentApiPage)
        end
    end
end)

-- Pagination (РУЧНАЯ - СОХРАНЕНО)
for i, b in ipairs(PageBtns) do
    b.MouseButton1Click:Connect(function()
        for _, btn in pairs(PageBtns) do btn.TextColor3 = C.SubText; btn.BackgroundColor3 = C.Card end
        b.TextColor3 = C.Accent
        b.BackgroundColor3 = Color3.fromRGB(40,40,40)
        CurrentApiPage = i
        NewSearch(SearchBox.Text)
    end)
end
PageBtns[1].TextColor3 = C.Accent

-- Connect Actions
BtnExec.MouseButton1Click:Connect(function() if SelectedScript then loadstring(SelectedScript)() end end)
BtnCopy.MouseButton1Click:Connect(function() if SelectedScript then setclipboard(SelectedScript) end end)
BtnEdit.MouseButton1Click:Connect(function() if SelectedScript then NewEditorTab(SelectedScript) end end)

-- Initial Load
NewSearch("")

-- TAB: UNIVERSAL & INFO
local UList = Instance.new("UIListLayout"); UList.Padding = UDim.new(0, 5); UList.Parent = Pages.Universal
local function AddU(n, c)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -10, 0, 35)
    b.Position = UDim2.new(0, 5, 0, 0)
    b.BackgroundColor3 = C.Card
    b.Text = n
    b.TextColor3 = C.Text
    b.Parent = Pages.Universal
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    b.MouseButton1Click:Connect(function() loadstring(c)() end)
end
AddU("Brookhaven – Lyra Hub", 'loadstring(game:HttpGet("https://rawscripts.net/raw/Brookhaven-RP-Lyra-Hub-Brookhaven-81184"))()')
AddU("Infinite Yield", 'loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()')

-- Info
local IList = Instance.new("UIListLayout"); IList.Padding = UDim.new(0, 5); IList.Parent = Pages.Info
local function AddInf(txt)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -10, 0, 25)
    l.Position = UDim2.new(0, 5, 0, 0)
    l.BackgroundColor3 = C.Card
    l.TextColor3 = C.Text
    l.Text = txt
    l.Font = Enum.Font.Code
    l.TextSize = 11
    l.Parent = Pages.Info
    Instance.new("UICorner", l).CornerRadius = UDim.new(0, 6)
    return l
end
local CoordLbl = AddInf("XYZ: 0, 0, 0")
local CopyXYZ = Instance.new("TextButton")
CopyXYZ.Size = UDim2.new(0, 50, 0, 20)
CopyXYZ.Position = UDim2.new(1, -60, 0, 2.5)
CopyXYZ.BackgroundColor3 = C.Accent
CopyXYZ.Text = "COPY"
CopyXYZ.TextColor3 = C.Text
CopyXYZ.TextSize = 10
CopyXYZ.Parent = Pages.Info
Instance.new("UICorner", CopyXYZ).CornerRadius = UDim.new(0, 4)

RunService.RenderStepped:Connect(function()
    if Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local p = Players.LocalPlayer.Character.HumanoidRootPart.Position
        CoordLbl.Text = string.format("XYZ: %d, %d, %d", p.X, p.Y, p.Z)
    end
end)
CopyXYZ.MouseButton1Click:Connect(function() setclipboard(CoordLbl.Text) end)

-- MINIMIZE & DRAG
local Minimized = false
BtnMin.MouseButton1Click:Connect(function()
    Minimized = not Minimized
    if Minimized then
        Main:TweenSize(UDim2.new(0, 440, 0, 28), "Out", "Quad", 0.3)
        PagesContainer.Visible = false
    else
        Main:TweenSize(UDim2.new(0, 440, 0, 270), "Out", "Quad", 0.3)
        PagesContainer.Visible = true
    end
end)

local function Draggable(obj)
    local dragging, dragStart, startPos
    obj.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = obj.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    obj.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end
Draggable(Main)
Draggable(ToggleBtn)

local Open = false
ToggleBtn.MouseButton1Click:Connect(function() Open = not Open; Main.Visible = Open end)
BtnClose.MouseButton1Click:Connect(function() Open = false; Main.Visible = false end)