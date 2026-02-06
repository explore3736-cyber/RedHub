-- NW V20: ZENITH OVERLORD (DRAGGABLE, CLOSABLE, SEARCHABLE)
-- KEY: NWH4X

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local hrp = char:WaitForChild("HumanoidRootPart")

local settings = {flySpeed = 150, walkSpeed = 16, gravity = 196.2, jump = 50}
local state = {fly = false, noclip = false, infJump = false, magnet = false, autoWin = false, rainbow = false, esp = false}

-- // UI CONSTRUCTION //
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "NW_ZENITH_V20"

-- Main Frame (The "Everything" Hub)
local main = Instance.new("Frame", gui)
main.Size = UDim2.fromOffset(650, 400); main.Position = UDim2.fromScale(0.5, 0.5)
main.AnchorPoint = Vector2.new(0.5, 0.5); main.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
main.Visible = false; main.Active = true; main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)
local mStroke = Instance.new("UIStroke", main); mStroke.Thickness = 2; mStroke.Color = Color3.new(0.5, 0, 1)

-- Top Bar (Close/Minimize)
local topBar = Instance.new("Frame", main)
topBar.Size = UDim2.new(1, 0, 0, 40); topBar.BackgroundTransparency = 1
local closeBtn = Instance.new("TextButton", topBar)
closeBtn.Size = UDim2.fromOffset(30, 30); closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.Text = "X"; closeBtn.TextColor3 = Color3.new(1,0,0); closeBtn.BackgroundColor3 = Color3.fromRGB(30,30,30)
closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)

-- Sidebar
local sidebar = Instance.new("ScrollingFrame", main)
sidebar.Size = UDim2.new(0.25, 0, 1, -50); sidebar.Position = UDim2.new(0, 10, 0, 45)
sidebar.BackgroundTransparency = 1; sidebar.ScrollBarThickness = 0
local sideLayout = Instance.new("UIListLayout", sidebar); sideLayout.Padding = UDim.new(0, 5)

-- Content Container
local container = Instance.new("ScrollingFrame", main)
container.Size = UDim2.new(0.7, 0, 1, -50); container.Position = UDim2.new(0.28, 0, 0, 45)
container.BackgroundTransparency = 1; container.ScrollBarThickness = 2
local conLayout = Instance.new("UIListLayout", container); conLayout.Padding = UDim.new(0, 10)

-- // FUNCTIONS //
local function addTab(name)
    local b = Instance.new("TextButton", sidebar)
    b.Size = UDim2.new(1, 0, 0, 40); b.Text = name; b.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    b.TextColor3 = Color3.new(1, 1, 1); Instance.new("UICorner", b)
    return b
end

local function clearCon() for _,v in pairs(container:GetChildren()) do if v:IsA("Frame") or v:IsA("TextButton") then v:Destroy() end end end

local function addToggle(txt, cb)
    local b = Instance.new("TextButton", container)
    b.Size = UDim2.new(0.95, 0, 0, 45); b.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    b.Text = "[OFF] " .. txt; b.TextColor3 = Color3.new(0.7,0.7,0.7); Instance.new("UICorner", b)
    local act = false; b.MouseButton1Click:Connect(function() act = not act; b.Text = act and "[ON] "..txt or "[OFF] "..txt; b.TextColor3 = act and Color3.new(0,1,1) or Color3.new(0.7,0.7,0.7); cb(act) end)
end

local function addSlider(txt, min, max, def, cb)
    local f = Instance.new("Frame", container); f.Size = UDim2.new(0.95, 0, 0, 65); f.BackgroundTransparency = 1
    local l = Instance.new("TextLabel", f); l.Size = UDim2.new(1, 0, 0, 25); l.Text = txt .. " (" .. def .. ")"; l.TextColor3 = Color3.new(1,1,1); l.BackgroundTransparency = 1
    local box = Instance.new("TextBox", f); box.Size = UDim2.new(1, 0, 0, 30); box.Position = UDim2.new(0,0,0,25)
    box.BackgroundColor3 = Color3.fromRGB(30,30,35); box.TextColor3 = Color3.new(0,1,1); box.Text = tostring(def); Instance.new("UICorner", box)
    box.FocusLost:Connect(function() local v = math.clamp(tonumber(box.Text) or def, min, max); l.Text = txt .. " (" .. v .. ")"; cb(v) end)
end

-- // --- TABS CONFIG --- //

-- 1. PHYSICS (Movement)
addTab("PHYSICS").MouseButton1Click:Connect(function()
    clearCon()
    addSlider("Normal Speed", 16, 2000, 16, function(v) hum.WalkSpeed = v end)
    addSlider("Fly Speed", 50, 1500, 150, function(v) settings.flySpeed = v end)
    addToggle("Infinite Jump (Air Walk)", function(v) state.infJump = v end)
    addToggle("Omni-Flight", function(v) state.fly = v; hum.PlatformStand = v end)
    addToggle("Noclip (Ghost)", function(v) state.noclip = v end)
end)

-- 2. SURVIVAL (Tsunami)
addTab("SURVIVAL").MouseButton1Click:Connect(function()
    clearCon()
    addToggle("Auto-Win (Infinite Wins)", function(v) state.autoWin = v while state.autoWin do for _,o in pairs(workspace:GetDescendants()) do if o.Name:lower():find("win") then hrp.CFrame = o.CFrame end end task.wait(0.5) end end)
    addToggle("Global Brainrot Magnet", function(v) state.magnet = v while state.magnet do for _,t in pairs(workspace:GetDescendants()) do if t:IsA("TouchTransmitter") then firetouchinterest(hrp, t.Parent, 0) end end task.wait(0.2) end end)
    addToggle("Instant Water Delete", function() for _,w in pairs(workspace:GetDescendants()) do if w.Name:lower():find("water") then w:Destroy() end end end)
end)

-- 3. TELEPORTS
addTab("WARPS").MouseButton1Click:Connect(function()
    clearCon()
    addToggle("TP to Spawn", function() hrp.CFrame = CFrame.new(0, 50, 0) end)
    addToggle("TP to Safest Peak", function() local t,y = nil,-math.huge; for _,p in pairs(workspace:GetDescendants()) do if p:IsA("BasePart") and p.CanCollide and p.Position.Y > y then y=p.Position.Y; t=p.CFrame end end; if t then hrp.CFrame = t+Vector3.new(0,5,0) end end)
end)

-- 4. CHARACTER
addTab("ENTITY").MouseButton1Click:Connect(function()
    clearCon()
    addSlider("Character Size", 0.1, 50, 1, function(v) local s=hum:FindFirstChild("BodyHeightScale") or Instance.new("NumberValue", hum); s.Value = v end)
    addToggle("Rainbow Body", function(v) state.rainbow = v end)
end)

-- // LOGIN & ENGINE //
local kFrame = Instance.new("Frame", gui); kFrame.Size = UDim2.fromOffset(300, 150); kFrame.Position = UDim2.fromScale(0.5, 0.5); kFrame.AnchorPoint = Vector2.new(0.5, 0.5); kFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15); Instance.new("UICorner", kFrame)
local kInp = Instance.new("TextBox", kFrame); kInp.Size = UDim2.new(0.8, 0, 0, 40); kInp.Position = UDim2.new(0.1, 0, 0.2, 0); kInp.PlaceholderText = "KEY: NWH4X"; kInp.BackgroundColor3 = Color3.fromRGB(30,30,30); kInp.TextColor3 = Color3.new(1,1,1)
local kBtn = Instance.new("TextButton", kFrame); kBtn.Size = UDim2.new(0.6, 0, 0, 35); kBtn.Position = UDim2.new(0.2, 0, 0.65, 0); kBtn.Text = "ACTIVATE"; kBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)

kBtn.MouseButton1Click:Connect(function() if kInp.Text == "NWH4X" then kFrame.Visible = false; main.Visible = true end end)

RunService.RenderStepped:Connect(function()
    local rgb = Color3.fromHSV(tick() % 5 / 5, 0.8, 1); mStroke.Color = rgb
    if state.fly then local bv = hrp:FindFirstChild("NWV") or Instance.new("BodyVelocity", hrp); bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * settings.flySpeed; bv.MaxForce = Vector3.new(1e6,1e6,1e6) end
    if state.noclip then for _,p in pairs(char:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end end
    if state.rainbow then for _,p in pairs(char:GetChildren()) do if p:IsA("BasePart") then p.Color = rgb end end end
end)
UIS.JumpRequest:Connect(function() if state.infJump then hum:ChangeState(3) end end)
