local Fluent = loadstring(game:HttpGet("https://github.com"))()
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Window = Fluent:CreateWindow({
    Title = "MM2 Anti-Toxic Hub",
    SubTitle = "by samantazai",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark"
})

local CombatTab = Window:AddTab({ Title = "Combat", Icon = "sword" })
local VisualsTab = Window:AddTab({ Title = "Visuals", Icon = "eye" })
local MovementTab = Window:AddTab({ Title = "Movement & Troll", Icon = "run" })

-- Картинка с Кенни Маккормиком на главной вкладке
CombatTab:AddImage({
    Title = "Kenny McCormick",
    Image = "rbxassetid://109675684892198",
    Size = UDim2.fromOffset(200, 200)
})

-- Общая функция поиска Убийцы
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

-- =========================================================================
-- ВКЛАДКА COMBAT (АВТО-ВЫСТРЕЛ)
-- =========================================================================
CombatTab:AddButton({
    Title = "One-Shot Murderer (Auto)",
    Description = "Автоматически стреляет в Убийцу, если вы Шериф",
    Callback = function()
        local murderer = getMurderer()
        if not murderer then
            Fluent:Notify({
                Title = "Ошибка",
                Content = "Убийца еще не взял нож или не найден!",
                Duration = 3
            })
            return
        end

        local gun = LocalPlayer.Backpack:FindFirstChild("Gun") or LocalPlayer.Character:FindFirstChild("Gun")
        if gun then
            LocalPlayer.Character.Humanoid:EquipTool(gun)
            task.wait(0.1)
            local targetPos = murderer.Character.Head.Position
            gun.KnifeServer.ShootGun:InvokeServer({
                TargetCoords = targetPos
            })
        else
            Fluent:Notify({
                Title = "Упс!",
                Content = "У тебя нет пистолета! Ты не Шериф.",
                Duration = 3
            })
        end
    end
})

-- =========================================================================
-- ВКЛАДКА VISUALS (ESP / ВХ НА СТЕНЫ)
-- =========================================================================
VisualsTab:AddToggle({
    Title = "Player ESP (ВХ)",
    Default = false,
    Callback = function(Value)
        _G.ESP_Enabled = Value
        
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
    end
})
