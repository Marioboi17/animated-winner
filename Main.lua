-- Main.lua — FischAdmin by You
-- Paste this in your GitHub repo as Main.lua

print("🎮 Admin loaded!")

-- Configuration: Admin usernames (lowercase)
local Admins = { "guest_2323143" }

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Create RemoteEvent
local Remote = ReplicatedStorage:FindFirstChild("AdminCommand")
if not Remote then
    Remote = Instance.new("RemoteEvent")
    Remote.Name = "AdminCommand"
    Remote.Parent = ReplicatedStorage
end

-- Command definitions
local Commands = {}

Commands["fly"] = function(target)
    local char = target.Character
    if char and not char:FindFirstChild("BodyGyro") then
        local root = char:FindFirstChild("HumanoidRootPart")
        if root then
            local gyro = Instance.new("BodyGyro", root)
            gyro.P = 9e4
            gyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
            gyro.CFrame = root.CFrame

            local vel = Instance.new("BodyVelocity", root)
            vel.Velocity = Vector3.new(0, 50, 0)
            vel.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        end
    end
end

Commands["unfly"] = function(target)
    local root = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
    if root then
        if root:FindFirstChild("BodyGyro") then root.BodyGyro:Destroy() end
        if root:FindFirstChild("BodyVelocity") then root.BodyVelocity:Destroy() end
    end
end

Commands["forcefield"] = function(target)
    local char = target.Character
    if char and not char:FindFirstChildOfClass("ForceField") then
        Instance.new("ForceField", char)
    end
end

Commands["unforcefield"] = function(target)
    local char = target.Character
    local ff = char and char:FindFirstChildOfClass("ForceField")
    if ff then ff:Destroy() end
end

Commands["kill"] = function(target)
    local hum = target.Character and target.Character:FindFirstChild("Humanoid")
    if hum then hum.Health = 0 end
end

Commands["spamkill"] = function(target)
    for i = 1, 10 do
        task.delay(i * 0.5, function()
            if target and target.Character then
                local hum = target.Character:FindFirstChild("Humanoid")
                if hum then hum.Health = 0 end
            end
        end)
    end
end

Commands["bring"] = function(target, caller)
    if target.Character and caller.Character then
        local tRoot = target.Character:FindFirstChild("HumanoidRootPart")
        local cRoot = caller.Character:FindFirstChild("HumanoidRootPart")
        if tRoot and cRoot then
            tRoot.CFrame = cRoot.CFrame + Vector3.new(2, 0, 0)
        end
    end
end

Commands["freeze"] = function(target)
    local root = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
    if root and not root:FindFirstChild("Frozen") then
        local bv = Instance.new("BodyVelocity")
        bv.Name = "Frozen"
        bv.Velocity = Vector3.new(0, 0, 0)
        bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        bv.Parent = root
    end
end

Commands["invisible"] = function(target)
    if target.Character then
        for _, obj in ipairs(target.Character:GetDescendants()) do
            if obj:IsA("BasePart") then
                obj.Transparency = 1
            elseif obj:IsA("Decal") then
                obj.Transparency = 1
            end
        end
    end
end

-- Handle remote commands
Remote.OnServerEvent:Connect(function(caller, input)
    if not table.find(Admins, caller.Name:lower()) then return end

    local parts = string.split(input, " ")
    local cmd = parts[1]:lower()
    local targetName = parts[2]
    local target = targetName and Players:FindFirstChild(targetName)

    if Commands[cmd] then
        if target then
            Commands[cmd](target, caller)
        else
            Commands[cmd](caller)
        end
    end
end)
