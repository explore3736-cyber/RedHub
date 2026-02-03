local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")
local camera = workspace.CurrentCamera

-- SETTINGS
local flySpeed = 50
local isFlying = false
local canFly = false -- Locked until they touch/find the "NW HUB X"

-- CREATE THE GUI BUTTON
local screenGui = Instance.new("ScreenGui", player.PlayerGui)
screenGui.Name = "FlyGui"

local toggleButton = Instance.new("TextButton", screenGui)
toggleButton.Size = UDim2.new(0, 150, 0, 50)
toggleButton.Position = UDim2.new(0.5, -75, 0.1, 0)
toggleButton.Text = "Fly: OFF (Locked)"
toggleButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
toggleButton.TextColor3 = Color3.new(1, 1, 1)
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.TextSize = 20

-- SEARCH FOR THE BOX "NW HUB X"
-- This assumes the box is in the Workspace
task.spawn(function()
	while true do
		local hubBox = workspace:FindFirstChild("NW HUB X", true)
		if hubBox then
			canFly = true
			toggleButton.Text = isFlying and "Fly: ON" or "Fly: OFF"
			toggleButton.BackgroundColor3 = isFlying and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(60, 60, 60)
		else
			canFly = false
			toggleButton.Text = "NW HUB X NOT FOUND"
		end
		task.wait(2) -- Check every 2 seconds
	end
end)

-- FLIGHT ENGINE (BodyVelocity)
local bv = Instance.new("BodyVelocity")
bv.MaxForce = Vector3.new(0, 0, 0)
bv.Parent = hrp

-- TOGGLE FUNCTION
local function toggleFly()
	if not canFly then return end
	isFlying = not isFlying
	
	if isFlying then
		bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
		humanoid.PlatformStand = true -- Prevents falling animations
		toggleButton.Text = "Fly: ON"
		toggleButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
	else
		bv.MaxForce = Vector3.new(0, 0, 0)
		humanoid.PlatformStand = false
		toggleButton.Text = "Fly: OFF"
		toggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	end
end

-- TRIGGERS
toggleButton.MouseButton1Click:Connect(toggleFly)

-- "HOLD JUMP" LOGIC
UserInputService.JumpRequest:Connect(function()
	if canFly and not isFlying then
		toggleFly()
	end
end)

-- MOVEMENT
RunService.RenderStepped:Connect(function()
	if isFlying then
		bv.Velocity = camera.CFrame.LookVector * flySpeed
	end
end)
