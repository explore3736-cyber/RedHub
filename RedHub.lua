local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

-- STATE VARS
local states = {
    fly = false, noclip = false, esp = false, 
    infJump = false, platform = false, speed = false
}
local flySpeed = 70

-- 1. MOBILE UI SETUP
local screenGui = Instance.new("ScreenGui", player.PlayerGui)
screenGui.Name = "NWMobileHub"
screenGui.ResetOnSpawn = false

-- Compact Open/Close Button (Draggable)
local openBtn = Instance.new("TextButton", screenGui)
openBtn.Size = UDim2.new(0, 50, 0, 50)
openBtn.Position = UDim2.new(0.1, 0, 0.5, 0)
openBtn.Text = "NW"
openBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
openBtn.TextColor3 = Color3.new(0, 0, 0)
openBtn.Font = Enum.Font.GothamBold
local corner = Instance.new("UICorner", openBtn)
corner.CornerRadius = ToolBuffer.new(0, 25)

-- Main Menu Frame
local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 220, 0, 300)
mainFrame.Position = UDim2.new(0.5, -110, 0.5, -150)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
mainFrame.Visible = false
Instance.new("UICorner", mainFrame)

local scroll = Instance.new("ScrollingFrame", mainFrame)
scroll.Size = UDim2.new(1, -10, 1, -10)
scroll.Position = UDim2.new(0, 5, 0, 5)
scroll.BackgroundTransparency = 1
scroll.CanvasSize = UDim2.new(0, 0, 5, 0) -- Extra long for "moreeee"
scroll.ScrollBarThickness = 4

local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0, 8)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Helper to make buttons
local function makeBtn(text, color, callback)
    local b = Instance.new("TextButton", scroll)
    b.Size = UDim2.new(0, 180, 0, 40)
    b.Text = text
    b.BackgroundColor3 = color or Color3.fromRGB(40, 40, 40)
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 14
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(callback)
end

-- 2. THE MEGA FEATURE LIST

-- [ MOVEMENT ]
makeBtn("FLY: OFF", Color3.fromRGB(0, 100, 250), function(self)
    states.fly = not states.fly
    humanoid.PlatformStand = states.fly
    self.Text = states.fly and "FLY: ON" or "FLY: OFF"
end)

makeBtn("NOCLIP: OFF", nil, function(self)
    states.noclip = not states.noclip
    self.Text = states.noclip and "NOCLIP: ON" or "NOCLIP: OFF"
end)

makeBtn("SUPER SPEED (MOBILE)", nil, function()
    states.speed = not states.speed
    humanoid.WalkSpeed = states.speed and 150 or 16
end)

makeBtn("INFINITE JUMP", nil, function()
    states.infJump = not states.infJump
end)

-- [ TSUNAMI BRAINROT SPECIALS ]
makeBtn("SKY PLATFORM (SAFE)", Color3.fromRGB(150, 0, 250), function()
    local p = Instance.new("Part", workspace)
    p.Size = Vector3.new(20, 1, 20)
    p.CFrame = hrp.CFrame * CFrame.new(0, 50, 0)
    p.Anchored = true
    hrp.CFrame = p.CFrame + Vector3.new(0, 3, 0)
end)

makeBtn("TSUNAMI AUTO-HIGH", Color3.fromRGB(0, 200, 0), function()
    -- Scans for highest point
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

-- [ EXTRAS & TROLLING ]
makeBtn("PLAYER ESP", nil, function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Character then
            local h = Instance.new("Highlight", p.Character)
            h.FillColor = Color3.new(1, 0, 0)
        end
    end
end)

makeBtn("SPINBOT", nil, function()
    local v = hrp:FindFirstChild("Spin") or Instance.new("BodyAngularVelocity", hrp)
    v.Name = "Spin"
    v.AngularVelocity = Vector3.new(0, 100, 0)
    v.MaxTorque = Vector3.new(0, math.huge, 0)
end)

makeBtn("GIVE ALL TOOLS", Color3.fromRGB(100, 100, 0), function()
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("Tool") or v:IsA("HopperBin") then
            v.Parent = player.Backpack
        end
    end
end)

makeBtn("SERVER HOP", nil, function()
    game:GetService("TeleportService"):Teleport(game.PlaceId)
end)

-- 3. THE ENGINE (Loops)
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
