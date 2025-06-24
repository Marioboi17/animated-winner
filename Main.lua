local player = game.Players.LocalPlayer
local prefix = "!"

local function onCommand(cmd)
	cmd = cmd:lower()

	local character = player.Character
	local root = character and character:FindFirstChild("HumanoidRootPart")
	local humanoid = character and character:FindFirstChild("Humanoid")

	if cmd == "fly" and root then
		if not root:FindFirstChild("BodyGyro") then
			local gyro = Instance.new("BodyGyro")
			gyro.P = 9e4
			gyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
			gyro.CFrame = root.CFrame
			gyro.Name = "BodyGyro"
			gyro.Parent = root

			local vel = Instance.new("BodyVelocity")
			vel.Velocity = Vector3.new(0, 50, 0)
			vel.MaxForce = Vector3.new(9e9, 9e9, 9e9)
			vel.Name = "BodyVelocity"
			vel.Parent = root
		end

	elseif cmd == "unfly" and root then
		local gyro = root:FindFirstChild("BodyGyro")
		local vel = root:FindFirstChild("BodyVelocity")
		if gyro then gyro:Destroy() end
		if vel then vel:Destroy() end

	elseif cmd == "ff" and character then
		if not character:FindFirstChildOfClass("ForceField") then
			Instance.new("ForceField", character)
		end

	elseif cmd == "unff" and character then
		local ff = character:FindFirstChildOfClass("ForceField")
		if ff then ff:Destroy() end

	elseif cmd == "kill" and humanoid then
		humanoid.Health = 0
	end
end

-- Hook into chat
player.Chatted:Connect(function(msg)
	if msg:sub(1, #prefix) == prefix then
		local command = msg:sub(#prefix + 1)
		onCommand(command)
	end
end)
