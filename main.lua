local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

if CoreGui:FindFirstChild("AntiToxicHub") then CoreGui.AntiToxicHub:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AntiToxicHub"
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 480, 0, 320)
MainFrame.Position = UDim2.new(0.3, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

-- ПЕРЕТАСКИВАНИЕ МЫШКОЙ
local dragging, dragInput, dragStart, startPos
local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then update(input) end
end)

-- НАЗВАНИЕ ХАБА
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Title.Text = "   MM2 Anti-Toxic Hub (by samantazai)"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 16
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = Title

-- КНОПКА ЗАКРЫТИЯ
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -40, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.TextSize = 14
CloseBtn.Parent = MainFrame

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- КЕННИ МАККОРМИК (КАРТИНКА)
local KennyImage = Instance.new("ImageLabel")
KennyImage.Size = UDim2.new(0, 180, 0, 180)
KennyImage.Position = UDim2.new(0.04, 0, 0.22, 10)
KennyImage.Image = "rbxassetid://109675684892198"
KennyImage.BackgroundTransparency = 1
KennyImage.Parent = MainFrame

-- ФУНКЦИЯ ПОИСКА МАРДЕРА
local function getMurderer()
    for _, player in ipairs(Players:GetPlayers()) do
        local character = player.Character
        if character then
            local backpack = player:FindFirstChild("Backpack")
            if (backpack and backpack:FindFirstChild("Knife")) or character:FindFirstChild("Knife") then
                return player
            end
        end
    end
    return nil
end

-- КНОПКА 1: АВТО-ВЫСТРЕЛ (ОБНОВЛЁННЫЙ)
local ShootBtn = Instance.new("TextButton")
ShootBtn.Size = UDim2.new(0, 230, 0, 45)
ShootBtn.Position = UDim2.new(0.48, 0, 0.22, 10)
ShootBtn.BackgroundColor3 = Color3.fromRGB(45, 120, 45)
ShootBtn.Text = "One-Shot Murderer (Auto)"
ShootBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ShootBtn.Font = Enum.Font.SourceSansBold
ShootBtn.TextSize = 14
ShootBtn.Parent = MainFrame

local ShootCorner = Instance.new("UICorner")
ShootCorner.CornerRadius = UDim.new(0, 8)
ShootCorner.Parent = ShootBtn

ShootBtn.MouseButton1Click:Connect(function()
    local murderer = getMurderer()
    if not murderer then return end
    local gun = LocalPlayer.Backpack:FindFirstChild("Gun") or LocalPlayer.Character:FindFirstChild("Gun")
    if gun then
        LocalPlayer.Character.Humanoid:EquipTool(gun)
        task.wait(0.4) -- Добавили правильную паузу, чтобы MM2 пропустил выстрел
        if murderer.Character and murderer.Character:FindFirstChild("Head") then
            gun.KnifeServer.ShootGun:InvokeServer({TargetCoords = murderer.Character.Head.Position})
        end
    end
end)

-- КНОПКА 2: ВХ (ESP)
local EspBtn = Instance.new("TextButton")
EspBtn.Size = UDim2.new(0, 230, 0, 45)
EspBtn.Position = UDim2.new(0.48, 0, 0.42, 20)
EspBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 120)
EspBtn.Text = "Toggle ESP (ВХ): OFF"
EspBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
EspBtn.Font = Enum.Font.SourceSansBold
EspBtn.TextSize = 14
EspBtn.Parent = MainFrame

local EspCorner = Instance.new("UICorner")
EspCorner.CornerRadius = UDim.new(0, 8)
EspCorner.Parent = EspBtn

_G.ESP_Enabled = false
EspBtn.MouseButton1Click:Connect(function()
    _G.ESP_Enabled = not _G.ESP_Enabled
    if _G.ESP_Enabled then
        EspBtn.Text = "Toggle ESP (ВХ): ON"
        EspBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        task.spawn(function()
            while _G.ESP_Enabled do
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        local highlight = player.Character:FindFirstChild("ESP_Highlight")
                        if not highlight then
                            highlight = Instance.new("Highlight")
                            highlight.Name = "ESP_Highlight"
                            highlight.Parent = player.Character
                            highlight.FillTransparency = 0.5
                            highlight.OutlineTransparency = 0
                        end
                        local backpack = player:FindFirstChild("Backpack")
                        if (backpack and backpack:FindFirstChild("Knife")) or player.Character:FindFirstChild("Knife") then
                            highlight.FillColor = Color3.fromRGB(255, 0, 0)
                            highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
                        elseif (backpack and backpack:FindFirstChild("Gun")) or player.Character:FindFirstChild("Gun") then
                            highlight.FillColor = Color3.fromRGB(0, 0, 255)
                            highlight.OutlineColor = Color3.fromRGB(0, 0, 255)
                        else
                            highlight.FillColor = Color3.fromRGB(0, 255, 0)
                            highlight.OutlineColor = Color3.fromRGB(0, 255, 0)
                        end
                    end
                end
                task.wait(1)
            end
        end)
    else
        EspBtn.Text = "Toggle ESP (ВХ): OFF"
        EspBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 120)
        for _, player in ipairs(Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("ESP_Highlight") then
                player.Character.ESP_Highlight:Destroy()
            end
        end
    end
end)

-- КНОПКА 3: ФЛИНГ (РАЗГОН ТОКСИКА)
local FlingBtn = Instance.new("TextButton")
FlingBtn.Size = UDim2.new(0, 230, 0, 45)
FlingBtn.Position = UDim2.new(0.48, 0, 0.62, 30)
FlingBtn.BackgroundColor3 = Color3.fromRGB(150, 75, 0)
FlingBtn.Text = "Fling Murderer (Убить взлётом)"
FlingBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FlingBtn.Font = Enum.Font.SourceSansBold
FlingBtn.TextSize = 14
FlingBtn.Parent = MainFrame

local FlingCorner = Instance.new("UICorner")
FlingCorner.CornerRadius = UDim.new(0, 8)
FlingCorner.Parent = FlingBtn

FlingBtn.MouseButton1Click:Connect(function()
    local murderer = getMurderer()
    if not murderer or not murderer.Character or not murderer.Character:FindFirstChild("HumanoidRootPart") then return end
    local RootPart = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not RootPart then return end
    
    -- Скрипт бешеного вращения для флинга физики
    local Bamboozle = Instance.new("BodyAngularVelocity")
    Bamboozle.AngularVelocity = Vector3.new(0, 99999, 0)
    Bamboozle.MaxTorque = Vector3.new(0, math.huge, 0)
    Bamboozle.Parent = RootPart
    
    -- Телепортируем тебя прямо под Мардера на 1.5 секунды, чтобы физика столкновения выкинула его за карту
    local oldPos = RootPart.CFrame
    for i = 1, 30 do
        if murderer.Character and murderer.Character:FindFirstChild("HumanoidRootPart") then
            RootPart.CFrame = murderer.Character.HumanoidRootPart.CFrame + Vector3.new(0, 1, 0)
        end
        task.wait(0.05)
    end
    
    Bamboozle:Destroy()
    RootPart.CFrame = oldPos -- Возвращаем тебя на старое безопасное место
end)
