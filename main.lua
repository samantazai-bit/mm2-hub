-- ПОДКЛЮЧЕНИЕ БИБЛИОТЕКИ И СЕРВИСОВ
local KavoLib = loadstring(game:HttpGet("https://githubusercontent.com"))()
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- СОЗДАНИЕ ОКНА
local Window = KavoLib.CreateLib("MM2 Anti-Toxic Hub (by samantazai)", "DarkTheme")

-- ВКЛАДКИ
local CombatTab = Window:NewTab("Combat")
local VisualsTab = Window:NewTab("Visuals")

-- СЕКЦИИ И НАПОЛНЕНИЕ
local CombatSection = CombatTab:NewSection("Боевые функции")
local VisualsSection = VisualsTab:NewSection("Визуалы (ВХ)")

-- Картинка с Кенни
CombatSection:NewImageLabel({
    Title = "Kenny McCormick",
    Image = "rbxassetid://109675684892198",
    Size = UDim2.new(0, 200, 0, 200)
})

-- Функция поиска Мардера
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

-- Кнопка авто-выстрела
CombatSection:NewButton("One-Shot Murderer (Auto)", "Авто-выстрел в голову Убийце", function()
    local murderer = getMurderer()
    if not murderer then return end

    local gun = LocalPlayer.Backpack:FindFirstChild("Gun") or LocalPlayer.Character:FindFirstChild("Gun")
    if gun then
        LocalPlayer.Character.Humanoid:EquipTool(gun)
        task.wait(0.1)
        local targetPos = murderer.Character.Head.Position
        gun.KnifeServer.ShootGun:InvokeServer({
            TargetCoords = targetPos
        })
    end
end)

-- Тумблер для ESP (ВХ)
VisualsSection:NewToggle("Player ESP (ВХ)", "Подсветка ролей сквозь стены", function(state)
    _G.ESP_Enabled = state
    
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
    
    if not _G.ESP_Enabled then
        for _, player in ipairs(Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("ESP_Highlight") then
                player.Character.ESP_Highlight:Destroy()
            end
        end
    end
end)
