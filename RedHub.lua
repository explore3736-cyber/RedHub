--[[
    RED HUB ULTRA | MOBILE
    Key: 67
    Smooth • Clean • Rounded • Delta Compatible
]]

---------------- SERVICES ----------------
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

---------------- HELPERS ----------------
local function round(ui, r)
    local c = Instance.new("UICorner", ui)
    c.CornerRadius = UDim.new(0, r)
end

local function tween(obj, t, props)
    TweenService:Create(obj, TweenInfo.new(t, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end

local function getChar()
    return player.Character or player.CharacterAdded:Wait()
end

---------------- ROOT GUI ----------------
local ScreenGui = Instance.new("ScreenGui", PlayerGui)
ScreenGui.Name = "RedHubUltra"
ScreenGui.ResetOnSpawn = false

---------------- LOADING ----------------
local Load = Instance.new("Frame", ScreenGui)
Load.Size = UDim2.new(1,0,1,0)
Load.BackgroundColor3 = Color3.fromRGB(10,10,10)

local LoadText = Instance.new("TextLabel", Load)
LoadText.Size = UDim2.new(0,300,0,50)
LoadText.Position = UDim2.new(0.5,-150,0.5,-25)
LoadText.Text = "Loading Red Hub Ultra..."
LoadText.TextColor3 = Color3.fromRGB(255,0,0)
LoadText.TextScaled = true
LoadText.BackgroundTransparency = 1

task.wait(1.8)
tween(Load, 0.6, {BackgroundTransparency = 1})
task.wait(0.6)
Load:Destroy()

---------------- KEY SYSTEM ----------------
local KeyFrame = Instance.new("Frame", ScreenGui)
KeyFrame.Size = UDim2.new(0,320,0,190)
KeyFrame.Position = UDim2.new(0.5,-160,0.5,-95)
KeyFrame.BackgroundColor3 = Color3.fromRGB(18,18,18)
KeyFrame.BorderSizePixel = 0
KeyFrame.Active = true
KeyFrame.Draggable = true
round(KeyFrame, 18)

local KT = Instance.new("TextLabel", KeyFrame)
KT.Size = UDim2.new(1,0,0,40)
KT.Text = "RED HUB • KEY"
KT.TextScaled = true
KT.BackgroundColor3 = Color3.fromRGB(255,0,0)
KT.TextColor3 = Color3.new(1,1,1)
round(KT, 18)

local KeyBox = Instance.new("TextBox", KeyFrame)
KeyBox.Size = UDim2.new(0,220,0,42)
KeyBox.Position = UDim2.new(0.5,-110,0.5,-10)
KeyBox.PlaceholderText = "Enter Key"
KeyBox.TextScaled = true
KeyBox.BackgroundColor3 = Color3.fromRGB(30,30,30)
KeyBox.TextColor3 = Color3.new(1,1,1)
round(KeyBox, 12)

local KeyBtn = Instance.new("TextButton", KeyFrame)
KeyBtn.Size = UDim2.new(0,140,0,36)
KeyBtn.Position = UDim2.new(0.5,-70,1,-50)
KeyBtn.Text = "UNLOCK"
KeyBtn.TextScaled = true
KeyBtn.BackgroundColor3 = Color3.fromRGB(40,0,0)
KeyBtn.TextColor3 = Color3.new(1,1,1)
round(KeyBtn, 12)

---------------- MAIN HUB ----------------
local Hub = Instance.new("Frame", ScreenGui)
Hub.Size = UDim2.new(0,380,0,360)
Hub.Position = UDim2.new(0.5,-190,0.5,-180)
Hub.BackgroundColor3 = Color3.fromRGB(15,15,15)
Hub.Visible = false
Hub.Active = true
Hub.Draggable = true
round(Hub, 22)

local HT = Instance.new("TextLabel", Hub)
HT.Size = UDim2.new(1,0,0,42)
HT.Text = "RED HUB ULTRA"
HT.TextScaled = true
HT.BackgroundColor3 = Color3.fromRGB(255,0,0)
HT.TextColor3 = Color3.new(1,1,1)
round(HT, 22)

---------------- BUTTON MAKER ----------------
local function button(txt, y)
    local b = Instance.new("TextButton", Hub)
    b.Size = UDim2.new(0,300,0,42)
    b.Position = UDim2.new(0.5,-150,0,y)
    b.Text = txt
    b.TextScaled = true
    b.BackgroundColor3 = Color3.fromRGB(35,0,0)
    b.TextColor3 = Color3.new(1,1,1)
    round(b, 14)
    return b
end

---------------- OPTIONS ----------------
local FlyBtn     = button("FLY : OFF", 60)
local CarpetBtn = button("MAGIC CARPET : OFF", 112)
local SpeedBtn  = button("SPEED : OFF", 164)
local JumpBtn   = button("JUMP : OFF", 216)
local ESPBtn    = button("ESP : OFF", 268)

---------------- LOGIC ----------------
local flying, carpetOn, speedOn, jumpOn, espOn = false,false,false,false,false
local bv, bg, conn, carpet

-- FLY
FlyBtn.MouseButton1Click:Connect(function()
    local hrp = getChar():WaitForChild("HumanoidRootPart")
    flying = not flying
    FlyBtn.Text = flying and "FLY : ON" or "FLY : OFF"

    if flying then
        bv = Instance.new("BodyVelocity", hrp)
        bv.MaxForce = Vector3.new(1e9,1e9,1e9)
        bg = Instance.new("BodyGyro", hrp)
        bg.MaxTorque = Vector3.new(1e9,1e9,1e9)

        conn = RunService.RenderStepped:Connect(function()
            local cam = workspace.CurrentCamera
            bv.Velocity = cam.CFrame.LookVector * 65
            bg.CFrame = cam.CFrame
        end)
    else
        if conn then conn:Disconnect() end
        if bv then bv:Destroy() end
        if bg then bg:Destroy() end
    end
end)

-- MAGIC CARPET
CarpetBtn.MouseButton1Click:Connect(function()
    carpetOn = not carpetOn
    CarpetBtn.Text = carpetOn and "MAGIC CARPET : ON" or "MAGIC CARPET : OFF"

    if carpetOn then
        carpet = Instance.new("Part", workspace)
        carpet.Size = Vector3.new(6,0.3,4)
        carpet.Color = Color3.fromRGB(150,0,0)
        carpet.Anchored = true
        carpet.Material = Enum.Material.SmoothPlastic

        RunService.RenderStepped:Connect(function()
            if carpetOn then
                local hrp = getChar():WaitForChild("HumanoidRootPart")
                carpet.CFrame = hrp.CFrame * CFrame.new(0,-3,0)
            end
        end)
    else
        if carpet then carpet:Destroy() end
    end
end)

-- SPEED
SpeedBtn.MouseButton1Click:Connect(function()
    speedOn = not speedOn
    getChar():WaitForChild("Humanoid").WalkSpeed = speedOn and 55 or 16
    SpeedBtn.Text = speedOn and "SPEED : ON" or "SPEED : OFF"
end)

-- JUMP
JumpBtn.MouseButton1Click:Connect(function()
    jumpOn = not jumpOn
    getChar():WaitForChild("Humanoid").JumpPower = jumpOn and 120 or 50
    JumpBtn.Text = jumpOn and "JUMP : ON" or "JUMP : OFF"
end)

-- ESP
ESPBtn.MouseButton1Click:Connect(function()
    espOn = not espOn
    ESPBtn.Text = espOn and "ESP : ON" or "ESP : OFF"

    for _,p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Character then
            local h = Instance.new("Highlight", p.Character)
            h.FillColor = Color3.fromRGB(255,0,0)
            h.Enabled = espOn
        end
    end
end)

---------------- KEY CHECK ----------------
KeyBtn.MouseButton1Click:Connect(function()
    if KeyBox.Text == "67" then
        KeyFrame:Destroy()
        Hub.Visible = true
        tween(Hub, 0.4, {Size = UDim2.new(0,380,0,360)})
    else
        KeyBox.Text = ""
        KeyBox.PlaceholderText = "WRONG KEY"
    end
end)
