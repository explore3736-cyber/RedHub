-- NW V9: ABSOLUTE OVERLORD (TSUNAMI & BRAINROT SPECIAL)
-- Optimized for Delta, Hydrogen, Fluxus, & Mobile Executors

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local hrp = char:WaitForChild("HumanoidRootPart")
local cam = workspace.CurrentCamera

-- // GLOBAL SETTINGS //
local state = {
    fly = false, noclip = false, infJump = false, speed = false,
    godMode = false, waterWalk = false, voidProtect = true,
    esp = false, autoWin = false, autoCollect = false, antiLava = false
}
local savedPos = nil
local spawnPos = hrp.CFrame
local lastZonePos = nil

-- // RGB THEME ENGINE //
local function getRGB()
    return Color3.fromHSV(tick() % 5 / 5, 0.8, 1)
end

-- // CORE UI SETUP //
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "NW_V9_FINAL"
gui.ResetOnSpawn = false

local open = Instance.new("TextButton", gui)
open.Size = UDim2.fromOffset(55, 55)
open.Position = UDim2.new(0.02, 0, 0.45, 0)
open.Text = "NW V9"
open.Font = Enum.Font.GothamBold
open.TextColor3 = Color3.new(1, 1, 1)
open.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Instance.new("UICorner", open).CornerRadius = UDim.new(1,0)
local openStroke = Instance.new("UIStroke", open)
openStroke.Thickness = 2

local panel = Instance.new("Frame", gui)
panel.Size = UDim2.fromOffset(310, 450)
panel.Position = UDim2.fromScale(0.5, 0.5)
panel.AnchorPoint = Vector2.new(0.5, 0.5)
panel.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
panel.Visible = false
panel.Active = true
panel.Draggable = true 
Instance.new("UICorner", panel)
local panelStroke = Instance.new("UIStroke", panel)
panelStroke.Thickness = 3

open.MouseButton1Click:Connect(function() panel.Visible = not panel.Visible end)

local scroll = Instance.new("ScrollingFrame", panel)
scroll.Size = UDim2.new(1, -10, 1, -50)
scroll.Position = UDim2.new(0, 5, 0, 45)
scroll.CanvasSize = UDim2.new(0, 0, 0, 2200)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 2
local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0, 5)

-- // UI BUILDER //
local function addSection(name)
    local l = Instance.new("TextLabel", scroll)
    l.Size = UDim2.new(1, 0, 0, 30)
    l.Text = "── " .. name .. " ──"
    l.Font = Enum.Font.GothamBold
    l.TextColor3 = Color3.fromRGB(180, 180, 180)
    l.BackgroundTransparency = 1
    l.TextSize = 12
end

local function addToggle(name, callback)
    local btn = Instance.new("TextButton", scroll)
    btn.Size = UDim2.new(0.95, 0, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
    btn.Text = name .. " [OFF]"
    btn.Font = Enum.Font.GothamMedium
    btn.TextColor3 = Color3.new(0.7, 0.7, 0.7)
    btn.TextSize = 13
    Instance.new("UICorner", btn)

    local active = false
    btn.MouseButton1Click:Connect(function()
        active = not active
        btn.Text = name .. (active and " [ON]" or " [OFF]")
        btn.TextColor3 = active and Color3.new(1,1,1) or Color3.new(0.7, 0.7, 0.7)
        btn.BackgroundColor3 = active and Color3.fromRGB(45, 45, 65) or Color3.fromRGB(22, 22, 26)
        callback(active)
    end)
end

-- // --- NEW V9 HACKS --- //

addSection("VOID & SAFETY")
addToggle("VOID PROTECTION", function(v) state.voidProtect = v end)
addToggle("AUTO HIGH GROUND (SMART)", function()
    local top, y = nil, -math.huge
    for _, p in pairs(workspace:GetDescendants()) do
        if p:IsA("BasePart") and p.CanCollide and p.Position.Y > y and p.Size.Y < 30 then
            y = p.Position.Y top = p.CFrame
        end
    end
    if top then hrp.CFrame = top + Vector3.new(0, 5, 0) end
end)

addSection("EXCLUSIVE BRAINROT OP")
addToggle("AUTO WIN (WIN-PAD TP)", function(v)
    state.autoWin = v
    while state.autoWin do
        for _, p in pairs(workspace:GetDescendants()) do
            if p.Name:lower():find("win") or p.Name:lower():find("end") then
                hrp.CFrame = p.CFrame + Vector3.new(0, 3, 0)
            end
        end
        task.wait(1)
    end
end)
addToggle("AUTO COLLECT BRAINROTS", function(v)
    state.autoCollect = v
    while state.autoCollect do
        for _, d in pairs(workspace:GetDescendants()) do
            if d.Name:lower():find("brainrot") or d:IsA("TouchTransmitter") then
                firetouchinterest(hrp, d.Parent, 0)
                firetouchinterest(hrp, d.Parent, 1)
            end
        end
        task.wait(0.3)
    end
end)

addSection("TSUNAMI DESTRUCTION")
addToggle("REMOVE ALL TSUNAMI/WATER", function()
    for _, w in pairs(workspace:GetDescendants()) do
        if w.Name:lower():find("water") or w.Name:lower():find("wave") then w:Destroy() end
    end
end)
addToggle("FREEZE WATER (NO MOVEMENT)", function(v)
    for _, w in pairs(workspace:GetDescendants()) do
        if w.Name:lower():find("water") then w.Anchored = v end
    end
end)

addSection("CORE HACKS (20+)")
addToggle("FE GOD MODE", function(v) state.godMode = v end)
addToggle("JESUS MODE", function(v) state.waterWalk = v end)
addToggle("NOCLIP (GHOST)", function(v) state.noclip = v end)
addToggle("FLY (JOYSTICK)", function(v) state.fly = v hum.PlatformStand = v end)
addToggle("ULTRA SPEED (200)", function(v) state.speed = v hum.WalkSpeed = v and 200 or 16 end)
addToggle("INF JUMP", function(v) state.infJump = v end)
addToggle("PLAYER ESP", function(v)
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Character then
            local h = p.Character:FindFirstChild("Highlight") or Instance.new("Highlight", p.Character)
            h.Enabled = v
        end
    end
end)

-- // ENGINE LOOPS //
RunService.RenderStepped:Connect(function()
    local rgb = getRGB()
    openStroke.Color = rgb
    panelStroke.Color = rgb

    if state.voidProtect and hrp.Position.Y < -50 then
        hrp.CFrame = spawnPos
    end
    if state.godMode then hum.Health = hum.MaxHealth end
    if state.fly then
        local bv = hrp:FindFirstChild("NW_V") or Instance.new("BodyVelocity", hrp)
        bv.MaxForce = Vector3.new(1e6, 1e6, 1e6)
        bv.Velocity = cam.CFrame.LookVector * 80
    end
    if state.noclip then
        for _, p in pairs(char:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end
    end
    if state.waterWalk then
        local p = workspace:FindFirstChild("Jesus") or Instance.new("Part", workspace)
        p.Name = "Jesus"; p.Size = Vector3.new(20, 1, 20); p.Anchored = true; p.Transparency = 1
        p.CFrame = hrp.CFrame * CFrame.new(0, -3.3, 0)
    end
end)

UIS.JumpRequest:Connect(function() if state.infJump then hum:ChangeState(Enum.HumanoidStateType.Jumping) end end)
