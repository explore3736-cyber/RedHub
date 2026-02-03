local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local PathfindingService = game:GetService("PathfindingService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")
local mouse = player:GetMouse()

-- STATE MANAGEMENT
local states = {fly = false, noclip = false, esp = false, airjump = false, freeze = false}
local flySpeed = 70

-- 1. ULTIMATE CLEAN UI
local screenGui = Instance.new("ScreenGui", player.PlayerGui)
screenGui.Name = "NWHUB_GOD"

local mainBtn = Instance.new("TextButton", screenGui)
mainBtn.Size = UDim2.new(0, 50, 0, 50)
mainBtn.Position = UDim2.new(0, 10, 0.5, -25)
mainBtn.Text = "NW"
mainBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
Instance.new("UICorner", mainBtn).CornerRadius = ToolBuffer.new(0, 25)

local menu = Instance.new("ScrollingFrame", screenGui)
menu.Size = UDim2.new(0, 220, 0, 350)
menu.Position = UDim2.new(0, 70, 0.5, -175)
menu.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
menu.Visible = false
menu.CanvasSize = UDim2.new(0, 0, 3, 0)
Instance.new("UICorner", menu)

local layout = Instance.new("UIListLayout", menu)
layout.Padding = UDim.new(0, 5)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local function createBtn(name, color, callback)
    local b = Instance.new("TextButton", menu)
    b.Size = UDim2.new(0, 200, 0, 40)
    b.Text = name
    b.BackgroundColor3 = color or Color3.fromRGB(40, 40, 40)
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.GothamBold
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(callback)
    return b
end

-- 2. THE FEATURES (MORE MORE MORE!)

-- [TSUNAMI GAME FEATURES]
createBtn("AUTO-WIN TSUNAMI", Color3.fromRGB(0, 120, 0), function()
    -- Attempts to find the highest point or end zone in Escape Tsunami
    local endZone = workspace:FindFirstChild("EndRegion") or workspace:FindFirstChild("Finish")
    if endZone then
        hrp.CFrame = endZone.CFrame + Vector3.new(0, 5, 0)
    else
        -- Fallback: Go to extreme height to avoid tsunami
        hrp.CFrame = hrp.CFrame + Vector3.new(0, 500, 0)
    end
end)

createBtn("TSUNAMI TRACKER (AI)", Color3.fromRGB(200, 100, 0), function()
    -- AI Pathfinding to the safest "High Ground"
    local parts = workspace:GetDescendants()
    local highestPart = nil
    local maxHeight = -math.huge
    for _, p in pairs(parts) do
        if p:IsA("BasePart") and p.Position.Y > maxHeight and p.CanCollide then
            maxHeight = p.Position.Y
            highestPart = p
        end
    end
    if highestPart then
        humanoid:MoveTo(highestPart.Position)
    end
end)

-- [PLAYER FEATURES]
createBtn("FREEZE WORLD (LOCAL)", Color3.fromRGB(100, 100, 255), function()
    states.freeze = not states.freeze
    for _, p in pairs(Players:GetPlayers()) do
        if p.Character and p ~= player then
            p.Character.PrimaryPart.Anchored = states.freeze
        end
    end
end)

createBtn("FLIGHT (Hold Jump)", Color3.fromRGB(50, 50, 50), function()
    states.fly = not states.fly
    humanoid.PlatformStand = states.fly
end)

createBtn("NO CLIP", Color3.fromRGB(50, 50, 50), function()
    states.noclip = not states.noclip
end)

createBtn("KILL ALL (FE-SIM)", Color3.fromRGB(150, 0, 0), function()
    -- Note: Only works if the game has a "Touch to kill" weapon in your hand
    local tool = character:FindFirstChildOfClass("Tool")
    if tool then
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= player and v.Character and v.Character:FindFirstChild("Hitbox") then
                firetouchinterest(v.Character.Hitbox, tool.Handle, 0)
            end
        end
    end
end)

createBtn("SPAM CHAT", Color3.fromRGB(80, 80, 80), function()
    for i = 1, 5 do
        game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer("NW HUB X ON TOP!", "All")
        task.wait(1)
    end
end)

-- 3. CORE LOOPS
mainBtn.MouseButton1Click:Connect(function() menu.Visible = not menu.Visible end)

local bv = Instance.new("BodyVelocity", hrp)
bv.MaxForce = Vector3.new(0,0,0)

RunService.RenderStepped:Connect(function()
    if states.fly then
        bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * flySpeed
    else
        bv.MaxForce = Vector3.new(0,0,0)
    end
    
    if states.noclip then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)
