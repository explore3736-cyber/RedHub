--[[ 
REDHUB PRO ULTRA MOBILE EDITION
Key: 67
Escape Tsunami for Brainrots | Fully Mobile + Delta Compatible
All OP Features, AI Prompter, Teleport UI, Ultra Survival, Fly, Carpet
]]--

-- SERVICES
local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local TweenService=game:GetService("TweenService")
local UIS=game:GetService("UserInputService")
local LP=Players.LocalPlayer
local Camera=workspace.CurrentCamera

-- UTILS
local function getChar() return LP.Character or LP.CharacterAdded:Wait() end
local function getHRP() return getChar():WaitForChild("HumanoidRootPart") end
local function getHum() return getChar():WaitForChild("Humanoid") end
local function round(ui,r) local c=Instance.new("UICorner",ui)c.CornerRadius=UDim.new(0,r) end
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
local function makeTabButton(txt,y,parent)
    local b=Instance.new("TextButton",parent)
    b.Size=UDim2.new(0,120,0,30)
    b.Position=UDim2.new(0,y,0,0)
    b.Text=txt
    b.TextScaled=true
    b.BackgroundColor3=Color3.fromRGB(20,20,20)
    b.TextColor3=Color3.new(1,1,1)
    round(b,10)
    return b
end

-- STATES
local KEY="67"
local unlocked=true
local survivalOn,flyOn,carpetOn,infJump,noclip,espOn,aiAutoMove=false,false,false,true,false,false,false
local lastSafeCFrame,flyBV,flyBG,carpet,airPart=nil,nil,nil,nil,nil
local homeCFrame=nil

-- GUI
local ScreenGui=Instance.new("ScreenGui",LP:WaitForChild("PlayerGui"))
ScreenGui.ResetOnSpawn=false
ScreenGui.Name="RedHubProUltra"

local Hub=Instance.new("Frame",ScreenGui)
Hub.Size=UDim2.new(0,400,0,550)
Hub.Position=UDim2.new(0.5,-200,0.5,-275)
Hub.BackgroundColor3=Color3.fromRGB(15,15,15)
Hub.Active=true
Hub.Draggable=true
round(Hub,22)

local Title=Instance.new("TextLabel",Hub)
Title.Size=UDim2.new(1,0,0,42)
Title.Text="RED HUB PRO ULTRA"
Title.TextScaled=true
Title.BackgroundColor3=Color3.fromRGB(255,0,0)
Title.TextColor3=Color3.new(1,1,1)
round(Title,22)

-- TAB BUTTONS
local tabButtons={}
local tabFrames={}
local tabs={"Movement","Survival","Teleport","Fun","AI Prompter","Extra"}
for i,v in pairs(tabs) do
    tabButtons[v]=makeTabButton(v,(i-1)*130,Hub)
    tabFrames[v]=Instance.new("ScrollingFrame",Hub)
    tabFrames[v].Size=UDim2.new(1,-20,1,-50)
    tabFrames[v].Position=UDim2.new(0,10,0,45)
    tabFrames[v].CanvasSize=UDim2.new(0,0,0,0)
    tabFrames[v].BackgroundTransparency=1
    tabFrames[v].ScrollBarThickness=8
    tabFrames[v].Visible=false
end
tabFrames["Movement"].Visible=true -- default

for name,btn in pairs(tabButtons) do
    btn.MouseButton1Click:Connect(function()
        for n,f in pairs(tabFrames) do f.Visible=false end
        tabFrames[name].Visible=true
    end)
end

-- MOVEMENT TAB
local function addMovementButtons()
    local frame=tabFrames["Movement"]
    local y=10
    local function add(txt,callback)
        local b=makeButton(txt,y,frame)
        b.MouseButton1Click:Connect(callback)
        y=y+50
        frame.CanvasSize=UDim2.new(0,0,0,y+50)
        return b
    end

    local FlyBtn=add("FLY : OFF",function()
        flyOn=not flyOn
        FlyBtn.Text=flyOn and "FLY : ON" or "FLY : OFF"
        if flyOn then
            local hrp=getHRP()
            flyBV=Instance.new("BodyVelocity",hrp)
            flyBG=Instance.new("BodyGyro",hrp)
            flyBV.MaxForce=Vector3.new(9e9,9e9,9e9)
            flyBG.MaxTorque=Vector3.new(9e9,9e9,9e9)
        else
            if flyBV then flyBV:Destroy() end
            if flyBG then flyBG:Destroy() end
        end
    end)
    local CarpetBtn=add("MAGIC CARPET : OFF",function()
        carpetOn=not carpetOn
        CarpetBtn.Text=carpetOn and "MAGIC CARPET : ON" or "MAGIC CARPET : OFF"
        if carpetOn then
            carpet=Instance.new("Part",workspace)
            carpet.Size=Vector3.new(6,1,8)
            carpet.Anchored=true
            carpet.Material=Enum.Material.Neon
            carpet.Color=Color3.fromRGB(255,0,0)
        else
            if carpet then carpet:Destroy() carpet=nil end
        end
    end)
    add("SPEED BOOST",function() getHum().WalkSpeed=getHum().WalkSpeed+20 end)
    add("SUPER JUMP",function() getHum().JumpHeight=50 end)
    add("AIR WALK",function() getHRP().Anchored=true task.delay(5,function() getHRP().Anchored=false end) end)
    add("GRAVITY ZERO",function() workspace.Gravity=0 task.delay(5,function() workspace.Gravity=196.2 end) end)
end

-- SURVIVAL TAB
local function addSurvivalButtons()
    local frame=tabFrames["Survival"]
    local y=10
    local function add(txt,callback)
        local b=makeButton(txt,y,frame)
        b.MouseButton1Click:Connect(callback)
        y=y+50
        frame.CanvasSize=UDim2.new(0,0,0,y+50)
        return b
    end
    add("ULTRA SURVIVAL",function() survivalOn=not survivalOn end)
    add("IMMORTAL MODE",function() task.spawn(function() while survivalOn do local hum=getHum() if hum.Health<hum.MaxHealth then hum.Health=hum.MaxHealth end task.wait(0.1) end end) end)
    add("AUTO HEAL",function() survivalOn=true end)
    add("ANTI FALL",function() RunService.RenderStepped:Connect(function() local hrp=getHRP() if hrp.Position.Y<18 then hrp.Velocity=Vector3.new(0,75,0) end end) end)
    add("NOCLIP",function() noclip=not noclip end)
end

-- TELEPORT TAB
local function addTeleportButtons()
    local frame=tabFrames["Teleport"]
    local y=10
    local function add(txt,callback)
        local b=makeButton(txt,y,frame)
        b.MouseButton1Click:Connect(callback)
        y=y+50
        frame.CanvasSize=UDim2.new(0,0,0,y+50)
        return b
    end
    homeCFrame=getHRP().CFrame
    add("TELEPORT HOME",function() getHRP().CFrame=homeCFrame+Vector3.new(0,3,0) end)
    add("LAST SAFE SPOT",function() if lastSafeCFrame then getHRP().CFrame=lastSafeCFrame+Vector3.new(0,3,0) end end)
    add("HIGHEST PLATFORM",function() getHRP().CFrame=CFrame.new(0,200,0) end)
    add("SAFE AREA",function() getHRP().CFrame=CFrame.new(50,30,50) end)
end

-- FUN / GAME-BREAKING TAB
local function addFunButtons()
    local frame=tabFrames["Fun"]
    local y=10
    local function add(txt,callback)
        local b=makeButton(txt,y,frame)
        b.MouseButton1Click:Connect(callback)
        y=y+50
        frame.CanvasSize=UDim2.new(0,0,0,y+50)
        return b
    end
    add("PLAYER ESP",function() for _,plr in pairs(Players:GetPlayers()) do if plr~=LP and plr.Character then if not plr.Character:FindFirstChild("ESP_Highlight") then local hl=Instance.new("Highlight",plr.Character) hl.Name="ESP_Highlight" hl.FillColor=Color3.fromRGB(255,0,0) hl.OutlineColor=Color3.fromRGB(255,255,255) end end end end)
    add("TSUNAMI WARN",function() for _,obj in pairs(workspace:GetChildren()) do if obj.Name:lower():find("tsunami") then if not obj:FindFirstChild("Warn") then local box=Instance.new("SelectionBox",obj) box.Adornee=obj box.Color3=Color3.fromRGB(255,0,0) box.LineThickness=0.05 box.Name="Warn" end end end end)
    add("AI AUTO MOVE",function() aiAutoMove=not aiAutoMove end)
end

-- AI PROMPTER TAB
local function addAIPrompter()
    local frame=tabFrames["AI Prompter"]
    local y=10
    local AiTextBox=Instance.new("TextBox",frame)
    AiTextBox.Size=UDim2.new(0,300,0,40)
    AiTextBox.Position=UDim2.new(0.5,-150,0,y)
    AiTextBox.PlaceholderText="Type OP feature name"
    round(AiTextBox,12)
    y=y+50
    local AiButton=makeButton("GENERATE OP FEATURE",y,frame)
    y=y+50
    frame.CanvasSize=UDim2.new(0,0,0,y+50)

    local optionTemplates={
        ["SUPER JUMP"]=function() getHum().JumpHeight=50 end,
        ["FLY BOOST"]=function() if flyBV then flyBV.Velocity=flyBV.Velocity*1.5 end end,
        ["AIR WALK"]=function() getHRP().Anchored=true task.delay(5,function() getHRP().Anchored=false end) end,
        ["GRAVITY ZERO"]=function() workspace.Gravity=0 task.delay(5,function() workspace.Gravity=196.2 end) end,
        ["AUTO HEAL"]=function() survivalOn=true end,
        ["IMMORTAL MODE"]=function() task.spawn(function() while survivalOn do local hum=getHum() if hum.Health<hum.MaxHealth then hum.Health=hum.MaxHealth end task.wait(0.1) end end) end,
        ["ANTI FALL"]=function() RunService.RenderStepped:Connect(function() local hrp=getHRP() if hrp.Position.Y<18 then hrp.Velocity=Vector3.new(0,75,0) end end) end,
        ["PLAYER ESP"]=function() for _,plr in pairs(Players:GetPlayers()) do if plr~=LP and plr.Character then if not plr.Character:FindFirstChild("ESP_Highlight") then local hl=Instance.new("Highlight",plr.Character) hl.Name="ESP_Highlight" hl.FillColor=Color3.fromRGB(255,0,0) hl.OutlineColor=Color3.fromRGB(255,255,255) end end end end
    }

    AiButton.MouseButton1Click:Connect(function()
        local txt=AiTextBox.Text:upper()
        if optionTemplates[txt] then
            local newBtn=makeButton(txt,math.random(50,400),frame)
            newBtn.MouseButton1Click:Connect(optionTemplates[txt])
        end
    end)
end

-- EXTRA TAB (Fun / Random OP Buttons)
local function addExtraButtons()
    local frame=tabFrames["Extra"]
    local y=10
    local function add(txt,callback)
        local b=makeButton(txt,y,frame)
        b.MouseButton1Click:Connect(callback)
        y=y+50
        frame.CanvasSize=UDim2.new(0,0,0,y+50)
    end
    add("CARPET BOOST",function() if carpet then carpet.Size=carpet.Size+Vector3.new(2,0,2) end end)
    add("SPEED BOOST EXTRA",function() getHum().WalkSpeed=getHum().WalkSpeed+20 end)
    add("TELEPORT SAFE",function() local hrp=getHRP() hrp.CFrame=lastSafeCFrame or hrp.CFrame end)
end

-- INIT
addMovementButtons()
addSurvivalButtons()
addTeleportButtons()
addFunButtons()
addAIPrompter()
addExtraButtons()

-- INFINITE JUMP
UIS.JumpRequest:Connect(function() if infJump then getHum():ChangeState(Enum.HumanoidStateType.Jumping) end end)

-- AUTO SAFE
RunService.RenderStepped:Connect(function()
    local hrp=getHRP()
    if hrp.Position.Y>25 then lastSafeCFrame=hrp.CFrame end
end)

print("REDHUB PRO ULTRA MOBILE LOADED | ALL FEATURES ACTIVE")
