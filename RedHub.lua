-- NW Mobile Movement & Tsunami Hub (V2 - Delta Optimized)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local hrp = char:WaitForChild("HumanoidRootPart")
local cam = workspace.CurrentCamera

-- RE-INITIALIZE ON RESPAWN
player.CharacterAdded:Connect(function(newChar)
    char = newChar
    hum = char:WaitForChild("Humanoid")
    hrp = char:WaitForChild("HumanoidRootPart")
    task.wait(0.5)
    if state.speed then hum.WalkSpeed = 100 end
end)

-- HUB STATES
local state = {
	fly = false,
	noclip = false,
	infJump = false,
	speed = false,
    autoFarm = false
}

local flySpeed = 70
local vertical = 0
local smoothVel = Vector3.zero
local spawnCF = hrp.CFrame

-- VELOCITY HANDLER
local function getBV()
    local existing = hrp:FindFirstChild("NW_Velocity")
    if existing then return existing end
    local bv = Instance.new("BodyVelocity")
    bv.Name = "NW_Velocity"
    bv.P = math.huge
    bv.MaxForce = Vector3.zero
    bv.Parent = hrp
    return bv
end

-- UI CREATION
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "NWMobile_V2"
gui.ResetOnSpawn = false

local open = Instance.new("TextButton", gui)
open.Size = UDim2.fromOffset(45,45)
open.Position = UDim2.new(0.05, 0, 0.15, 0)
open.Text = "NW"
open.BackgroundColor3 = Color3.fromRGB(40, 120, 255)
open.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", open).CornerRadius = UDim.new(1,0)

local panel = Instance.new("Frame", gui)
panel.Size = UDim2.fromOffset(250, 380)
panel.Position = UDim2.fromScale(0.5, 0.5)
panel.AnchorPoint = Vector2.new(0.5, 0.5)
panel.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
panel.Visible = false
Instance.new("UICorner", panel)

open.MouseButton1Click:Connect(function() panel.Visible = not panel.Visible end)

local scroll = Instance.new("ScrollingFrame", panel)
scroll.Size = UDim2.new(1, 0, 1, -10)
scroll.CanvasSize = UDim2.new(0, 0, 0, 700)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 3

local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0, 5)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local function createBtn(name, color, func)
    local b = Instance.new("TextButton", scroll)
    b.Size = UDim2.new(0.9, 0, 0, 38)
    b.Text = name
    b.BackgroundColor3 = color
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamBold
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(func)
end

--- FEATURES ---

-- 1. FLIGHT SECTION
createBtn("TOGGLE FLY", Color3.fromRGB(60, 60, 80), function()
    state.fly = not state.fly
    hum.PlatformStand = state.fly
    if not state.fly then getBV().MaxForce = Vector3.zero end
end)

createBtn("FLY UP", Color3.fromRGB(40, 150, 40), function() vertical = 1 end)
createBtn("FLY DOWN", Color3.fromRGB(150, 40, 40), function() vertical = -1 end)
createBtn("STOP VERTICAL", Color3.fromRGB(100, 100, 100), function() vertical = 0 end)

-- 2. MOVEMENT SECTION
createBtn("SPEED BOOST (100)", Color3.fromRGB(0, 180, 255), function()
    state.speed = not state.speed
    hum.WalkSpeed = state.speed and 100 or 16
end)

createBtn("INFINITE JUMP", Color3.fromRGB(180, 0, 255), function()
    state.infJump = not state.infJump
end)

createBtn("NOCLIP (WALK THROUGH WALLS)", Color3.fromRGB(255, 100, 0), function()
    state.noclip = not state.noclip
end)

-- 3. TSUNAMI / DISASTER SPECIALS
createBtn("GOTO HIGHEST POINT", Color3.fromRGB(255, 215, 0), function()
    local topPos = nil
    local topY = -math.huge
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and v.CanCollide and v.Position.Y > topY and v.Size.Y < 100 then
            topY = v.Position.Y
            topPos = v.CFrame
        end
    end
    if topPos then hrp.CFrame = topPos + Vector3.new(0, 5, 0) end
end)

createBtn("INSTANT WATER BUBBLE (FIX)", Color3.fromRGB(0, 255, 200), function()
    -- Sets swim state even if not in water to prevent drowning mechanics in some games
    hum:ChangeState(Enum.HumanoidStateType.Swimming)
end)

createBtn("DELETE ALL WATER/LAVA", Color3.fromRGB(255, 0, 0), function()
    for _, v in pairs(workspace:GetDescendants()) do
        if v.Name:lower():find("water") or v.Name:lower():find("lava") or v.Name:lower():find("liquid") then
            v:Destroy()
        end
    end
end)

createBtn("TP TO SPAWN", Color3.fromRGB(120, 120, 120), function()
    hrp.CFrame = spawnCF
end)

-- 4. UTILITY
createBtn("REJOIN SERVER", Color3.fromRGB(50, 50, 50), function()
    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, player)
end)

--- ENGINE LOOP ---

RunService.RenderStepped:Connect(function()
    -- Flight Logic (Directional based on Camera)
    if state.fly then
        local bv = getBV()
        local moveDir = hum.MoveDirection -- Uses Mobile Joystick direction
        local camDir = cam.CFrame.LookVector
        
        -- If joystick isn't moving, just hover or go vertical
        local targetVel = Vector3.zero
        if moveDir.Magnitude > 0 then
            targetVel = camDir * flySpeed
        end
        
        targetVel = targetVel + Vector3.new(0, vertical * flySpeed, 0)
        smoothVel = smoothVel:Lerp(targetVel, 0.1)
        
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.Velocity = smoothVel
    end
    
    -- Noclip Logic
    if state.noclip then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

UIS.JumpRequest:Connect(function()
    if state.infJump then
        hum:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

print("NW Hub Loaded Successfully for Mobile!")
