-- JS HUB v2 | REAL FEATURES (STUDIO)
-- Mobile Sliders | Smooth Fly Physics | One Script

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LP = Players.LocalPlayer

-- ===== CHARACTER =====
local char, hum, hrp
local function loadChar()
    char = LP.Character or LP.CharacterAdded:Wait()
    hum = char:WaitForChild("Humanoid")
    hrp = char:WaitForChild("HumanoidRootPart")
end
loadChar()
LP.CharacterAdded:Connect(loadChar)

-- ===== STATES =====
local flying = false
local flySpeed = 40
local accel = 6
local noclip = false
local airJump = false
local jumps = 0

-- ===== UI UTILS =====
local function round(ui, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r)
    c.Parent = ui
end

local function label(txt, parent)
    local l = Instance.new("TextLabel", parent)
    l.Size = UDim2.new(1,-20,0,26)
    l.BackgroundTransparency = 1
    l.TextColor3 = Color3.new(1,1,1)
    l.TextScaled = true
    l.Text = txt
    return l
end

local function toggle(txt, parent, cb)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(1,-20,0,42)
    b.BackgroundColor3 = Color3.fromRGB(25,25,25)
    b.TextColor3 = Color3.new(1,1,1)
    b.TextScaled = true
    b.Text = txt.." : OFF"
    round(b,12)
    local on = false
    b.MouseButton1Click:Connect(function()
        on = not on
        b.Text = txt.." : "..(on and "ON" or "OFF")
        cb(on)
    end)
    return b
end

local function slider(txt, parent, min, max, val, cb)
    local wrap = Instance.new("Frame", parent)
    wrap.Size = UDim2.new(1,-20,0,60)
    wrap.BackgroundTransparency = 1

    local t = Instance.new("TextLabel", wrap)
    t.Size = UDim2.new(1,0,0,22)
    t.BackgroundTransparency = 1
    t.TextColor3 = Color3.new(1,1,1)
    t.TextScaled = true
    t.Text = txt..": "..val

    local bar = Instance.new("Frame", wrap)
    bar.Position = UDim2.new(0,0,0,30)
    bar.Size = UDim2.new(1,0,0,16)
    bar.BackgroundColor3 = Color3.fromRGB(30,30,30)
    round(bar,8)

    local fill = Instance.new("Frame", bar)
    fill.Size = UDim2.new((val-min)/(max-min),0,1,0)
    fill.BackgroundColor3 = Color3.fromRGB(220,220,220)
    round(fill,8)

    local dragging=false
    local function set(x)
        local p = math.clamp(x,0,1)
        fill.Size = UDim2.new(p,0,1,0)
        val = math.floor(min + (max-min)*p)
        t.Text = txt..": "..val
        cb(val)
    end

    bar.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
            dragging=true
            set((i.Position.X-bar.AbsolutePosition.X)/bar.AbsoluteSize.X)
        end
    end)

    UIS.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
            set((i.Position.X-bar.AbsolutePosition.X)/bar.AbsoluteSize.X)
        end
    end)

    UIS.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
            dragging=false
        end
    end)
end

-- ===== GUI =====
local gui = Instance.new("ScreenGui", LP.PlayerGui)
gui.Name = "JSHub"

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0,420,0,560)
main.Position = UDim2.new(0.5,-210,0.5,-280)
main.BackgroundColor3 = Color3.fromRGB(15,15,15)
main.Active, main.Draggable = true, true
round(main,22)

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,50)
title.Text = "JS HUB"
title.TextScaled = true
title.BackgroundColor3 = Color3.fromRGB(0,0,0)
title.TextColor3 = Color3.new(1,1,1)
round(title,22)

local page = Instance.new("ScrollingFrame", main)
page.Position = UDim2.new(0,10,0,60)
page.Size = UDim2.new(1,-20,1,-70)
page.ScrollBarThickness = 6
page.BackgroundTransparency = 1

local layout = Instance.new("UIListLayout", page)
layout.Padding = UDim.new(0,10)

-- ===== FEATURES =====
toggle("Fly", page, function(v) flying = v end)
slider("Fly Speed", page, 20, 120, flySpeed, function(v) flySpeed = v end)
slider("Fly Smoothness", page, 2, 12, accel, function(v) accel = v end)
toggle("Noclip", page, function(v) noclip = v end)
toggle("Air Jump", page, function(v) airJump = v end)
toggle("Speed Boost", page, function(v) hum.WalkSpeed = v and 40 or 16 end)

-- ===== AIR JUMP LOGIC =====
UIS.JumpRequest:Connect(function()
    if airJump and jumps < 1 then
        jumps += 1
        hum:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

hum.StateChanged:Connect(function(_, s)
    if s == Enum.HumanoidStateType.Landed then jumps = 0 end
end)

-- ===== NOCLIP LOOP =====
RunService.Stepped:Connect(function()
    if noclip and char then
        for _,v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide=false end
        end
    end
end)

-- ===== SMOOTH FLY PHYSICS =====
local vel = Vector3.zero
RunService.RenderStepped:Connect(function(dt)
    if not flying then
        vel = vel * 0.85
        return
    end

    local cam = workspace.CurrentCamera
    local dir = Vector3.zero

    if UIS:IsKeyDown(Enum.KeyCode.W) then dir += cam.CFrame.LookVector end
    if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= cam.CFrame.LookVector end
    if UIS:IsKeyDown(Enum.KeyCode.A) then dir -= cam.CFrame.RightVector end
    if UIS:IsKeyDown(Enum.KeyCode.D) then dir += cam.CFrame.RightVector end
    if UIS:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0,1,0) end
    if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then dir -= Vector3.new(0,1,0) end

    if dir.Magnitude > 0 then
        dir = dir.Unit * flySpeed
    end

    vel = vel:Lerp(dir, math.clamp(accel*dt,0,1))
    hrp.AssemblyLinearVelocity = vel
    hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + cam.CFrame.LookVector)
end)

print("JS HUB v2 loaded | Mobile sliders | Smooth fly")
