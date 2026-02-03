-- NW Mobile Movement & Tsunami Hub (Studio Safe)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

if not RunService:IsStudio() then return end

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local hrp = char:WaitForChild("HumanoidRootPart")
local cam = workspace.CurrentCamera

-- STATES
local state = {
	fly = false,
	noclip = false,
	infJump = false,
	speed = false
}

local flySpeed = 60
local vertical = 0
local smoothVel = Vector3.zero
local spawnCF = hrp.CFrame

-- BODY
local bv = Instance.new("BodyVelocity")
bv.P = 15000
bv.Parent = hrp

-- UI
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false

local open = Instance.new("TextButton", gui)
open.Size = UDim2.fromOffset(56,56)
open.Position = UDim2.fromScale(0.05,0.45)
open.Text = "NW"
open.BackgroundColor3 = Color3.fromRGB(20,20,20)
open.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", open).CornerRadius = UDim.new(1,0)

local panel = Instance.new("Frame", gui)
panel.Size = UDim2.fromOffset(260,340)
panel.Position = UDim2.fromScale(0.5,0.5)
panel.AnchorPoint = Vector2.new(0.5,0.5)
panel.BackgroundColor3 = Color3.fromRGB(10,10,10)
panel.Visible = false
Instance.new("UICorner", panel)

open.MouseButton1Click:Connect(function()
	panel.Visible = not panel.Visible
end)

local scroll = Instance.new("ScrollingFrame", panel)
scroll.Size = UDim2.fromScale(1,1)
scroll.CanvasSize = UDim2.new(0,0,2.5,0)
scroll.ScrollBarThickness = 4
scroll.BackgroundTransparency = 1

local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0,10)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local function btn(text, func)
	local b = Instance.new("TextButton", scroll)
	b.Size = UDim2.fromOffset(220,44)
	b.Text = text
	b.Font = Enum.Font.GothamBold
	b.TextSize = 14
	b.TextColor3 = Color3.new(1,1,1)
	b.BackgroundColor3 = Color3.fromRGB(30,30,30)
	Instance.new("UICorner", b)
	b.MouseButton1Click:Connect(func)
end

-- ✈️ FLY
btn("TOGGLE FLY", function()
	state.fly = not state.fly
	hum.PlatformStand = state.fly
end)

btn("FLY SPEED +", function()
	flySpeed = math.clamp(flySpeed + 10, 20, 200)
end)

btn("FLY SPEED -", function()
	flySpeed = math.clamp(flySpeed - 10, 20, 200)
end)

btn("UP ▲", function() vertical = 1 end)
btn("DOWN ▼", function() vertical = -1 end)
btn("STOP VERTICAL", function() vertical = 0 end)

-- 🌊 ESCAPE TSUNAMI STYLE
btn("TELEPORT HOME", function()
	hrp.CFrame = spawnCF
end)

btn("SKY SAFE PLATFORM", function()
	local p = Instance.new("Part", workspace)
	p.Size = Vector3.new(40,2,40)
	p.Anchored = true
	p.CFrame = hrp.CFrame * CFrame.new(0,100,0)
	hrp.CFrame = p.CFrame + Vector3.new(0,5,0)
end)

btn("AUTO HIGH GROUND", function()
	local highest, target = -math.huge, nil
	for _,v in pairs(workspace:GetDescendants()) do
		if v:IsA("BasePart") and v.CanCollide and v.Position.Y > highest then
			highest = v.Position.Y
			target = v
		end
	end
	if target then
		hrp.CFrame = target.CFrame + Vector3.new(0,5,0)
	end
end)

-- ⚙️ EXTRAS
btn("INFINITE JUMP", function()
	state.infJump = not state.infJump
end)

btn("SPEED BOOST", function()
	state.speed = not state.speed
	hum.WalkSpeed = state.speed and 80 or 16
end)

btn("NOCLIP", function()
	state.noclip = not state.noclip
end)

-- ENGINE
RunService.RenderStepped:Connect(function()
	if state.fly then
		local dir = cam.CFrame.LookVector
		local target = (dir * flySpeed) + Vector3.new(0, vertical * flySpeed, 0)
		smoothVel = smoothVel:Lerp(target, 0.15)
		bv.MaxForce = Vector3.new(1e6,1e6,1e6)
		bv.Velocity = smoothVel
	else
		bv.MaxForce = Vector3.zero
	end

	if state.noclip then
		for _,v in pairs(char:GetDescendants()) do
			if v:IsA("BasePart") then v.CanCollide = false end
		end
	end
end)

UIS.JumpRequest:Connect(function()
	if state.infJump then
		hum:ChangeState(Enum.HumanoidStateType.Jumping)
	end
end)
