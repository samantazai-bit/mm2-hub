local OrionLib = loadstring(game:HttpGet(('https://githubusercontent.com')))()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local Window = OrionLib:MakeWindow({
    Name = "MM2 Anti-Toxic Hub", 
    HidePremium = false, 
    SaveConfig = true,
    ConfigFolder = "MM2_AntiToxic"
})

local CombatTab   = Window:MakeTab({ Name = "Combat", Icon = "rbxassetid://4483345998" })
local VisualsTab  = Window:MakeTab({ Name = "Visuals", Icon = "rbxassetid://4483345998" })
local MovementTab = Window:MakeTab({ Name = "Movement & Troll", Icon = "rbxassetid://4483345998" })
local TeleportTab = Window:MakeTab({ Name = "Teleports", Icon = "rbxassetid://4483345998" })

CombatTab:MakeLabel({
    Name = "rbxassetid://109675684892198"
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

CombatTab:MakeButton({
    Name = "One-Shot Murderer (Auto)",
    Callback = function()
        local murderer = getMurderer()
        if not murderer then
            OrionLib:MakeNotification({
                Name = "Ошибка",
                Content = "Убийца еще не взял нож или не найден!",
                Time = 3
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
            OrionLib:MakeNotification({
                Name = "Упс!",
                Content = "У тебя нет пистолета! Ты не Шериф и не Герой.",
                Time = 3
            })
        end
    end    
})
