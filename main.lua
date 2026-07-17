local CoreGui, Players, RunService, UIS = game:GetService("CoreGui"), game:GetService("Players"), game:GetService("RunService"), game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

if CoreGui:FindFirstChild("AntiToxicHub") then CoreGui.AntiToxicHub:Destroy() end

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "AntiToxicHub"

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 500, 0, 360)
MainFrame.Position = UDim2.new(0.3, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

local dragging, dragInput, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging, dragStart, startPos = true, input.Position, MainFrame.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
MainFrame.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end end)
UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Title.Text = "   MM2 Anti-Toxic Hub (by samantazai)"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 16
Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 10)

local CloseBtn = Instance.new("TextButton", MainFrame)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -40, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.TextSize = 14
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

local KennyImage = Instance.new("ImageLabel", MainFrame)
KennyImage.Size = UDim2.new(0, 180, 0, 180)
KennyImage.Position = UDim2.new(0.04, 0, 0.2, 15)
KennyImage.Image = "rbxassetid://109675684892198"
KennyImage.BackgroundTransparency = 1

local function getMurderer()
    for _, player in ipairs(Players:GetPlayers()) do
        local character = player.Character
        if character then
            local backpack = player:FindFirstChild("Backpack")
            if (backpack and backpack:FindFirstChild("Knife")) or character:FindFirstChild("Knife") then return player end
        end
    end
    return nil
end

local ShootBtn = Instance.new("TextButton", MainFrame)
ShootBtn.Size = UDim2.new(0, 240, 0, 40)
ShootBtn.Position = UDim2.new(0.46, 0, 0.18, 10)
ShootBtn.BackgroundColor3 = Color3.fromRGB(45, 120, 45)
ShootBtn.Text = "One-Shot Murderer (Auto)"
ShootBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ShootBtn.Font = Enum.Font.SourceSansBold
ShootBtn.TextSize = 14
Instance.new("UICorner", ShootBtn).CornerRadius = UDim.new(0, 8)

ShootBtn.MouseButton1Click:Connect(function()
    local murderer = getMurderer()
    if not murderer or not murderer.Character or not murderer.Character:FindFirstChild("HumanoidRootPart") then return end
    local gun = LocalPlayer.Backpack:FindFirstChild("Gun") or LocalPlayer.Character:FindFirstChild("Gun")
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if gun and root then
        LocalPlayer.Character.Humanoid:EquipTool(gun)
        task.wait(0.4)
        root.CFrame = CFrame.new(root.Position, murderer.Character.HumanoidRootPart.Position)
        gun:Activate()
    end
end)

local EspBtn = Instance.new("TextButton", MainFrame)
EspBtn.Size = UDim2.new(0, 240, 0, 40)
EspBtn.Position = UDim2.new(0.46, 0, 0.33, 15)
EspBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 120)
EspBtn.Text = "Toggle ESP (ВХ): OFF"
EspBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
EspBtn.Font = Enum.Font.SourceSansBold
EspBtn.TextSize = 14
Instance.new("UICorner", EspBtn).CornerRadius = UDim.new(0, 8)

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
                        local highlight = player.Character:FindFirstChild("ESP_Highlight") or Instance.new("Highlight", player.Character)
                        highlight.Name = "ESP_Highlight"
                        highlight.FillTransparency, highlight.OutlineTransparency = 0.5, 0
                        local backpack = player:FindFirstChild("Backpack")
                        if (backpack and backpack:FindFirstChild("Knife")) or player.Character:FindFirstChild("Knife") then
                            highlight.FillColor, highlight.OutlineColor = Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 0, 0)
                        elseif (backpack and backpack:FindFirstChild("Gun")) or player.Character:FindFirstChild("Gun") then
                            highlight.FillColor, highlight.OutlineColor = Color3.fromRGB(0, 0, 255), Color3.fromRGB(0, 0, 255)
                        else
                            highlight.FillColor, highlight.OutlineColor = Color3.fromRGB(0, 255, 0), Color3.fromRGB(0, 255, 0)
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
            if player.Character and player.Character:FindFirstChild("ESP_Highlight") then player.Character.ESP_Highlight:Destroy() end
        end
    end
end)

local SelectedPlayerName = ""
local PlayerInput = Instance.new("TextBox", MainFrame)
PlayerInput.Size = UDim2.new(0, 240, 0, 35)
PlayerInput.Position = UDim2.new(0.46, 0, 0.52, 20)
PlayerInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
PlayerInput.Text = ""
PlayerInput.PlaceholderText = "Введите ник..."
PlayerInput.TextColor3 = Color3.fromRGB(255, 255, 255)
PlayerInput.Font = Enum.Font.SourceSans
PlayerInput.TextSize = 14
Instance.new("UICorner", PlayerInput).CornerRadius = UDim.new(0, 6)

PlayerInput.FocusLost:Connect(function()
    local text = PlayerInput.Text:lower()
    if text == "" then return end
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Name:lower():sub(1, #text) == text or p.DisplayName:lower():sub(1, #text) == text then
            SelectedPlayerName, PlayerInput.Text = p.Name, p.DisplayName
            break
        end
    end
end)

local FlingBtn = Instance.new("TextButton", MainFrame)
FlingBtn.Size = UDim2.new(0, 240, 0, 40)
FlingBtn.Position = UDim2.new(0.46, 0, 0.68, 25)
FlingBtn.BackgroundColor3 = Color3.fromRGB(150, 75, 0)
FlingBtn.Text = "Fling Target (Разгонать цель)"
FlingBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FlingBtn.Font = Enum.Font.SourceSansBold
FlingBtn.TextSize = 14
Instance.new("UICorner", FlingBtn).CornerRadius = UDim.new(0, 8)

FlingBtn.MouseButton1Click:Connect(function()
    local target = Players:FindFirstChild(SelectedPlayerName)
    if not target or not target.Character or not target.Character:FindFirstChild("HumanoidRootPart") then return end
    local myChar = LocalPlayer.Character
    local root = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    local oldPos = root.CFrame
    local nocollide = RunService.Stepped:Connect(function()
        for _, part in ipairs(myChar:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end)
    
    local AV = Instance.new("AngularVelocity", root)
    local Att = Instance.new("Attachment", root)
    AV.Attachment0 = Att
    AV.MaxTorque = math.huge
    AV.AngularVelocity = Vector3.new(0, 99999, 0)
    
    local BV = Instance.new("BodyVelocity", root)
    BV.maxForce = Vector3.new(math.huge, math.huge, math.huge)
    
    for i = 1, 50 do
        if target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            root.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(i*20), 0)
            BV.velocity = Vector3.new(50, 0, 50)
        end
        task.wait(0.04)
    end
    
    nocollide:Disconnect()
    AV:Destroy()
    Att:Destroy()
    BV:Destroy()
    root.Velocity = Vector3.new(0,0,0)
    root.CFrame = oldPos
end)
