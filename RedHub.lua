local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

-- STATE VARS (Old + New)
local states = {
    fly = false, noclip = false, esp = false, 
    infJump = false, speed = false, autoClick = false,
    noFog = false
}
local flySpeed = 70
local walkSpeedAmt = 150

-- 1. STABLE UI SETUP
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "NWMobileHub_V2"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true -- Ensures it stays on top of everything

-- Compact Toggle Button
local openBtn = Instance.new("TextButton", screenGui)
openBtn.Size = UDim2.new(0, 60, 0, 60)
openBtn.Position = UDim2.new(0, 10, 0.4, 0)
openBtn.Text = "NW"
openBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
openBtn.TextColor3 = Color3.new(1, 1, 1)
openBtn.ZIndex = 10
Instance.new("UICorner", openBtn).CornerRadius = ToolBuffer.new(0, 30)

-- Main Menu
local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 240, 0, 320)
mainFrame.Position = UDim2.new(0.5, -120, 0.5, -160)
mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
mainFrame.Visible = false
mainFrame.ZIndex = 11
Instance.new("UICorner", mainFrame)

local scroll = Instance.new("ScrollingFrame", mainFrame)
scroll.Size = UDim2.new(1, -10, 1, -10)
scroll.Position = UDim2.new(0, 5, 0, 5)
scroll.BackgroundTransparency = 1
scroll.CanvasSize = UDim2.new(0, 0, 7, 0) -- MASSIVE for "More" features
scroll.ScrollBarThickness = 5

local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0, 8)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local function makeBtn(text, color, callback)
    local b = Instance.new("TextButton", scroll)
    b.Size = UDim2.new(0, 200, 0, 45)
    b.Text = text
    b.BackgroundColor3 = color or Color3.fromRGB(35, 35, 35)
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 14
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(callback)
end

-- 2. THE MEGA FEATURE LIST (NO FEATURES REMOVED)

-- [ MOVEMENT & SPEED ]
makeBtn("TOGGLE FLY", Color3.fromRGB(0, 80, 200), function()
    states.fly = not states.fly
    humanoid.PlatformStand = states.fly
end)

makeBtn("SUPER SPEED (150)", Color3.fromRGB(200, 150, 0), function()
    states.speed = not states.speed
    humanoid.WalkSpeed = states.speed and walkSpeedAmt or 16
end)

makeBtn("NOCLIP", Color3.fromRGB(150, 0, 0), function()
    states.noclip = not states.noclip
end)

makeBtn("INFINITE JUMP", nil, function()
    states.infJump = not states.infJump
end)

-- [ TSUNAMI & SURVIVAL ]
makeBtn("TSUNAMI: SKY BASE", Color3.fromRGB(0, 200, 100), function()
    local p = Instance.new("Part", workspace)
    p.Size = Vector3.new(30, 2, 30)
    p.CFrame = hrp.CFrame * CFrame.new(0, 100, 0)
    p.Anchored = true
    hrp.CFrame = p.CFrame + Vector3.new(0, 5, 0)
end)

makeBtn("AUTO-HIGH GROUND", nil, function()
    local high = -500
    local target = nil
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and v.Position.Y > high and v.CanCollide then
            high = v.Position.Y
            target = v
        end
    end
    if target then hrp.CFrame = target.CFrame + Vector3.new(0, 5, 0) end
end)

-- [ EXTRAS - MORE MORE MORE ]
makeBtn("REMOVE FOG / FULL BRIGHT", Color3.fromRGB(255, 255, 255), function()
    Lighting.FogEnd = 999999
    Lighting.Brightness = 2
    Lighting.ClockTime = 14
end)

makeBtn("AUTO-CLICKER (TAP)", nil, function()
    states.autoClick = not states.autoClick
    task.spawn(function()
        while states.autoClick do
            local virtualUser = game:GetService("VirtualUser")
            virtualUser:CaptureController()
            virtualUser:ClickButton1(Vector2.new(0,0))
            task.wait(0.1)
        end
    end)
end)

makeBtn("PLAYER ESP", Color3.fromRGB(255, 0, 255), function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Character then
            local h = p.Character:FindFirstChild("Highlight") or Instance.new("Highlight", p.Character)
            h.FillColor = Color3.new(1, 0, 0)
        end
    end
end)

makeBtn("BTOOLS (BUILD TOOLS)", nil, function()
    local hopper = Instance.new("HopperBin", player.Backpack)
    hopper.BinType = Enum.HopperBinType.Hammer
end)

-- 3. THE ENGINE
openBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

local bv = Instance.new("BodyVelocity", hrp)
bv.MaxForce = Vector3.new(0, 0, 0)

RunService.RenderStepped:Connect(function()
    if states.fly then
        bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * flySpeed
    else
        bv.MaxForce = Vector3.new(0, 0, 0)
    end
    
    if states.noclip then
        for _, v in pairs(character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if states.infJump then humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
end)
