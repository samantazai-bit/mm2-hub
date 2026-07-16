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

-- Добавляем картинку с Кенни на главную вкладку Combat
CombatTab:AddImage({
    Title = "Kenny McCormick",
    Image = "rbxassetid://109675684892198",
    Size = UDim2.fromOffset(200, 200)
})

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
