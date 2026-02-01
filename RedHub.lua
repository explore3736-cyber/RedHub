--[[ 
 REDHUB PRO | ESCAPE TSUNAMI HUB
 Key: 67
 Mobile Friendly | Curved UI | Smooth
]]--

-----------------------------
-- SERVICES
-----------------------------
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local LP = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-----------------------------
-- UTILS
-----------------------------
local function getChar() return LP.Character or LP.CharacterAdded:Wait() end
local function getHRP() return getChar():WaitForChild("HumanoidRootPart") end
local function getHum() return getChar():WaitForChild("Humanoid") end
local function round(ui,r) local c = Instance.new("UICorner",ui) c.CornerRadius=UDim.new(0,r) end
local function tween(obj,t,props) TweenService:Create(obj, TweenInfo.new(t,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),props):Play() end

-----------------------------
-- STATES
-----------------------------
local KEY = "67"
local unlocked = true

local survivalOn, flyOn, carpetOn, infJump, noclip, espOn, aiAutoMove = false,false,false,false,false,false,false
local lastSafeCFrame = nil
local flyBV, flyBG
local carpet
local airPart

-----------------------------
-- ROOT GUI
-----------------------------
local ScreenGui = Instance.new("ScreenGui", LP:WaitForChild("PlayerGui"))
ScreenGui.ResetOnSpawn = false
ScreenGui.Name = "RedHubPro"

local Hub = Instance.new("Frame", ScreenGui)
Hub.Size = UDim2.new(0,380,0,400)
Hub.Position = UDim2.new(0.5,-190,0.5,-200)
Hub.BackgroundColor3 = Color3.fromRGB(15,15,15)
Hub.Active = true
Hub.Draggable = true
round(Hub,22)

local HT = Instance.new("TextLabel", Hub)
HT.Size = UDim2.new(1,0,0,42)
HT.Text = "RED HUB PRO"
HT.TextScaled = true
HT.BackgroundColor3 = Color3.fromRGB(255,0,0)
HT.TextColor3 = Color3.new(1,1,1)
round(HT,22)

-----------------------------
-- TAB MAKER
-----------------------------
local function makeButton(txt,y,parent)
    local b=Instance.new("TextButton",parent)
    b.Size=UDim2.new(0,300,0,40)
    b.Position=UDim2.new(0.5,-150,0,y)
    b.Text=txt
    b.TextScaled=true
    b.BackgroundColor3=Color3.fromRGB(35,0,0)
    b.TextColor3=Color3.new(1,1,1)
    round(b,12)
    return b
end

-----------------------------
-- MOVEMENT BUTTONS
-----------------------------
local FlyBtn = makeButton("FLY : OFF",60,Hub)
local CarpetBtn = makeButton("MAGIC CARPET : OFF",110,Hub)
local SpeedBtn = makeButton("SPEED : OFF",160,Hub)
local JumpBtn = makeButton("JUMP : OFF",210,Hub)
local NoclipBtn = makeButton("NOCLIP : OFF",260,Hub)
local SurvivalBtn = makeButton("ULTRA SURVIVAL : OFF",310,Hub)
local AiMoveBtn = makeButton("AI AUTO MOVE : OFF",360,Hub)

-----------------------------
-- LOGIC
-----------------------------

-- FLY
local function startFly()
    local hrp = getHRP()
    flyBV = Instance.new("BodyVelocity", hrp)
    flyBG = Instance.new("BodyGyro", hrp)
    flyBV.MaxForce=Vector3.new(9e9,9e9,9e9)
    flyBG.MaxTorque=Vector3.new(9e9,9e9,9e9)
end
local function stopFly()
    if flyBV then flyBV:Destroy() end
    if flyBG then flyBG:Destroy() end
end
FlyBtn.MouseButton1Click:Connect(function()
    flyOn = not flyOn
    FlyBtn.Text = flyOn and "FLY : ON" or "FLY : OFF"
    if flyOn then startFly() else stopFly() end
end)
RunService.RenderStepped:Connect(function()
    if not flyOn then return end
    local dir = Vector3.zero
    local hrp=getHRP()
    if UIS:IsKeyDown(Enum.KeyCode.W) then dir+=Camera.CFrame.LookVector end
    if UIS:IsKeyDown(Enum.KeyCode.S) then dir-=Camera.CFrame.LookVector end
    if UIS:IsKeyDown(Enum.KeyCode.A) then dir-=Camera.CFrame.RightVector end
    if UIS:IsKeyDown(Enum.KeyCode.D) then dir+=Camera.CFrame.RightVector end
    if flyBV then flyBV.Velocity = dir*80 end
    if flyBG then flyBG.CFrame = Camera.CFrame end
end)

-- MAGIC CARPET
CarpetBtn.MouseButton1Click:Connect(function()
    carpetOn = not carpetOn
    CarpetBtn.Text = carpetOn and "MAGIC CARPET : ON" or "MAGIC CARPET : OFF"
    if carpetOn then
        carpet = Instance.new("Part",workspace)
        carpet.Size=Vector3.new(6,1,8)
        carpet.Anchored=true
        carpet.Material=Enum.Material.Neon
        carpet.Color=Color3.fromRGB(255,0,0)
    else
        if carpet then carpet:Destroy() carpet=nil end
    end
end)
RunService.RenderStepped:Connect(function()
    if carpetOn and carpet then
        carpet.CFrame = getHRP().CFrame * CFrame.new(0,-3,0)
    end
end)

-- SPEED
SpeedBtn.MouseButton1Click:Connect(function()
    local hum=getHum()
    if SpeedBtn.Text=="SPEED : OFF" then
        hum.WalkSpeed=55
        SpeedBtn.Text="SPEED : ON"
    else
        hum.WalkSpeed=16
        SpeedBtn.Text="SPEED : OFF"
    end
end)

-- JUMP
JumpBtn.MouseButton1Click:Connect(function()
    local hum=getHum()
    if JumpBtn.Text=="JUMP : OFF" then
        hum.UseJumpPower=false
        hum.JumpHeight=35
        JumpBtn.Text="JUMP : ON"
    else
        hum.JumpHeight=7.2
        JumpBtn.Text="JUMP : OFF"
    end
end)

-- NOCLIP
NoclipBtn.MouseButton1Click:Connect(function()
    noclip = not noclip
    NoclipBtn.Text = noclip and "NOCLIP : ON" or "NOCLIP : OFF"
end)
RunService.Stepped:Connect(function()
    if noclip then
        for _,v in pairs(getChar():GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide=false end
        end
    end
end)

-- ULTRA SURVIVAL
SurvivalBtn.MouseButton1Click:Connect(function()
    survivalOn = not survivalOn
    SurvivalBtn.Text = survivalOn and "ULTRA SURVIVAL : ON" or "ULTRA SURVIVAL : OFF"
end)

RunService.Stepped:Connect(function()
    if not survivalOn then return end
    local hrp = getHRP()
    local hum = getHum()
    if hum.Health < hum.MaxHealth then hum.Health=hum.MaxHealth end
    hum.PlatformStand=false
    hum:ChangeState(Enum.HumanoidStateType.Running)
    if hrp.Position.Y<18 then
        hrp.Velocity=Vector3.new(0,75,0)
    end
end)

-- AUTO SAFE POSITION & TELEPORT
RunService.RenderStepped:Connect(function()
    local hrp=getHRP()
    local hum=getHum()
    if hum.Health>0 and hrp.Position.Y>25 then
        lastSafeCFrame=hrp.CFrame
    end
    if survivalOn and lastSafeCFrame and hrp.Position.Y<12 then
        hrp.CFrame=lastSafeCFrame+Vector3.new(0,3,0)
        hrp.Velocity=Vector3.zero
    end
end)

-- AIR PLATFORM
RunService.RenderStepped:Connect(function()
    if not survivalOn then
        if airPart then airPart:Destroy() airPart=nil end
        return
    end
    local hrp=getHRP()
    if hrp.Position.Y<18 then
        if not airPart then
            airPart=Instance.new("Part",workspace)
            airPart.Size=Vector3.new(12,1,12)
            airPart.Anchored=true
            airPart.CanCollide=true
            airPart.Transparency=1
        end
        airPart.CFrame=CFrame.new(hrp.Position.X,hrp.Position.Y-4,hrp.Position.Z)
    end
end)

-- AI AUTO MOVE TO HIGHEST PLATFORM
AiMoveBtn.MouseButton1Click:Connect(function()
    aiAutoMove = not aiAutoMove
    AiMoveBtn.Text = aiAutoMove and "AI AUTO MOVE : ON" or "AI AUTO MOVE : OFF"
end)

RunService.RenderStepped:Connect(function()
    if not aiAutoMove then return end
    local hrp=getHRP()
    local highestY = -math.huge
    for _,p in pairs(workspace:GetChildren()) do
        if p:IsA("BasePart") and p.Position.Y>highestY then
            highestY=p.Position.Y
        end
    end
    if highestY>hrp.Position.Y then
        local dir=(Vector3.new(hrp.Position.X,highestY+3,hrp.Position.Z)-hrp.Position).Unit
        hrp.CFrame=hrp.CFrame + dir*0.5
    end
end)

-- ESP / TSUNAMI WARNINGS
espOn=true
RunService.RenderStepped:Connect(function()
    if not espOn then return end
    for _,obj in pairs(workspace:GetChildren()) do
        if obj.Name:lower():find("tsunami") then
            if not obj:FindFirstChild("Warn") then
                local box=Instance.new("SelectionBox",obj)
                box.Adornee=obj
                box.Color3=Color3.fromRGB(255,0,0)
                box.LineThickness=0.05
                box.Name="Warn"
            end
        end
    end
end)

-- INFINITE JUMP
infJump=true
UIS.JumpRequest:Connect(function()
    if infJump then
        getHum():ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- INITIAL BOOST
getHum().WalkSpeed=24
getHum().JumpPower=70

print("REDHUB PRO LOADED | ALL OPTIONS ACTIVE")
