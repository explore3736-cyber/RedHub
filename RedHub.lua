-- NW ULTIMATE V7: ABSOLUTE GOD-TIER (RGB MOBILE)
-- Optimized for Delta, Vega X, and Hydrogen

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local hrp = char:WaitForChild("HumanoidRootPart")
local cam = workspace.CurrentCamera

-- // GLOBAL STATE //
local state = {
    fly = false, noclip = false, infJump = false, speed = false,
    saveTpActive = false, autoClick = false, waterWalk = false,
    antiRagdoll = true, safeMode = false, godMode = false,
    magnet = false, esp = false, fullBright = false,
    autoHighGround = false, chatSpam = false
}
local savedPos = nil
local flySpeed = 80

-- // RGB THEME ENGINE //
local function getRGB()
    return Color3.fromHSV(tick() % 5 / 5, 0.8, 1)
end

-- // CORE UI SETUP //
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "NW_V7_GODTIER"
gui.ResetOnSpawn = false

local open = Instance.new("TextButton", gui)
open.Size = UDim2.fromOffset(50, 50)
open.Position = UDim2.new(0.02, 0, 0.45, 0)
open.Text = "NW V7"
open.Font = Enum.Font.GothamBold
open.TextColor3 = Color3.new(1, 1, 1)
open.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Instance.new("UICorner", open).CornerRadius = UDim.new(1,0)
local openStroke = Instance.new("UIStroke", open)
openStroke.Thickness = 2

local panel = Instance.new("Frame", gui)
panel.Size = UDim2.fromOffset(320, 440)
panel.Position = UDim2.fromScale(0.5, 0.5)
panel.AnchorPoint = Vector2.new(0.5, 0.5)
panel.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
panel.Visible = false
Instance.new("UICorner", panel)
local panelStroke = Instance.new("UIStroke", panel)
panelStroke.Thickness = 3

open.MouseButton1Click:Connect(function() panel.Visible = not panel.Visible end)

local scroll = Instance.new("ScrollingFrame", panel)
scroll.Size = UDim2.new(1, -10, 1, -50)
scroll.Position = UDim2.new(0, 5, 0, 45)
scroll.CanvasSize = UDim2.new(0, 0, 0, 1800)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 2
local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0, 6)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- // UI HELPERS //
local function addSection(name)
    local l = Instance.new("TextLabel", scroll)
    l.Size = UDim2.new(1, 0, 0, 30)
    l.Text = "── " .. name .. " ──"
    l.Font = Enum.Font.GothamBold
    l.TextColor3 = Color3.fromRGB(150, 150, 150)
    l.BackgroundTransparency = 1
    l.TextSize = 12
end

local function addToggle(name, callback)
    local btn = Instance.new("TextButton", scroll)
    btn.Size = UDim2.new(0.92, 0, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    btn.Text = name .. "  [OFF]"
    btn.Font = Enum.Font.GothamMedium
    btn.TextColor3 = Color3.new(0.6, 0.6, 0.6)
    btn.TextSize = 14
    Instance.new("UICorner", btn)

    local active = false
    btn.MouseButton1Click:Connect(function()
        active = not active
        btn.Text = name .. (active and "  [ON]" or "  [OFF]")
        btn.TextColor3 = active and Color3.new(1, 1, 1) or Color3.new(0.6, 0.6, 0.6)
        btn.BackgroundColor3 = active and Color3.fromRGB(40, 40, 55) or Color3.fromRGB(25, 25, 30)
        callback(active)
    end)
end

-- // --- FEATURES --- //

addSection("OP TSUNAMI SURVIVAL")
addToggle("GOD MODE (Infinite Health)", function(v) state.godMode = v end)
addToggle("Auto High Ground", function(v)
    if v then
        local topPos, topY = nil, -math.huge
        for _, p in pairs(workspace:GetDescendants()) do
            if p:IsA("BasePart") and p.CanCollide and p.Position.Y > topY and p.Size.Y < 40 then
                topY = p.Position.Y topPos = p.CFrame
            end
        end
        if topPos then hrp.CFrame = topPos + Vector3.new(0, 5, 0) end
    end
end)
addToggle("Jesus Mode (Walk on Water)", function(v) state.waterWalk = v end)
addToggle("Safe Mode (Auto-TP Saved)", function(v) state.safeMode = v end)
addToggle("Delete Tsunami Waves", function()
    for _, w in pairs(workspace:GetDescendants()) do
        if w.Name:lower():find("water") or w.Name:lower():find("wave") then w:Destroy() end
    end
end)

addSection("AUTO-FARM & CLICKER")
addToggle("Magnet (Snatch All Brainrots)", function(v) state.magnet = v end)
addToggle("God-Tier Auto Clicker", function(v)
    state.autoClick = v
    task.spawn(function()
        while state.autoClick do
            local t = char:FindFirstChildOfClass("Tool")
            if t then t:Activate() end
            task.wait(0.01)
        end
    end)
end)

addSection("MOVEMENT & CORE")
addToggle("Joystick Fly", function(v) state.fly = v hum.PlatformStand = v end)
addToggle("Super Speed (150)", function(v) state.speed = v hum.WalkSpeed = v and 150 or 16 end)
addToggle("Noclip (Wall-Hack)", function(v) state.noclip = v end)
addToggle("Infinite Jump", function(v) state.infJump = v end)

addSection("VISUALS & WORLD")
addToggle("Player ESP", function(v)
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Character then
            local h = p.Character:FindFirstChild("Highlight") or Instance.new("Highlight", p.Character)
            h.Enabled = v
        end
    end
end)
addToggle("Full Bright & No Fog", function(v)
    state.fullBright = v
    Lighting.Brightness = v and 2 or 1
    Lighting.FogEnd = v and 100000 or 1000
end)

addSection("TELEPORTS")
addToggle("Double-Tap Save Active", function(v) state.saveTpActive = v end)
addToggle("Warp to Saved Position", function() if savedPos then hrp.CFrame = savedPos end end)
addToggle("Server Hop", function()
    local x = game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100")
    local y = game:GetService("HttpService"):JSONDecode(x)
    TeleportService:TeleportToPlaceInstance(game.PlaceId, y.data[1].id)
end)

-- // ENGINE LOOPS //
RunService.RenderStepped:Connect(function()
    local rgb = getRGB()
    openStroke.Color = rgb
    panelStroke.Color = rgb

    if state.godMode then hum.Health = hum.MaxHealth end
    if state.fly then
        local b = hrp:FindFirstChild("NW_V") or Instance.new("BodyVelocity", hrp)
        b.Name = "NW_V"
        b.MaxForce = Vector3.new(1e6, 1e6, 1e6)
        b.Velocity = cam.CFrame.LookVector * flySpeed
    end
    if state.noclip then
        for _, p in pairs(char:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end
    end
    if state.magnet then
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("TouchTransmitter") and v.Parent and v.Parent:IsA("BasePart") then
                firetouchinterest(hrp, v.Parent, 0)
                firetouchinterest(hrp, v.Parent, 1)
            end
        end
    end
    if state.waterWalk then
        local p = workspace:FindFirstChild("JPart") or Instance.new("Part", workspace)
        p.Name = "JPart" p.Size = Vector3.new(10, 1, 10) p.Anchored = true p.Transparency = 1
        p.CFrame = hrp.CFrame * CFrame.new(0, -3.2, 0)
    end
    if state.safeMode and hum.Health < 30 and savedPos then hrp.CFrame = savedPos end
end)

UIS.TouchTapInWorld:Connect(function(pos, proc)
    if proc or not state.saveTpActive then return end
    if tick() - lastTap < 0.3 then
        local ray = cam:ViewportPointToRay(pos.X, pos.Y)
        savedPos = CFrame.new(ray.Origin + (ray.Direction * 15))
    end
    lastTap = tick()
end)

UIS.JumpRequest:Connect(function() if state.infJump then hum:ChangeState(Enum.HumanoidStateType.Jumping) end end)

