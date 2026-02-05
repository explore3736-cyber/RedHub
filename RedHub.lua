-- NW Blox Fruits: Level & Chest Farmer (Mobile Optimized)
-- Works with Delta, Hydrogen, and Vega X

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local hum = char:WaitForChild("Humanoid")

-- // STATE SETTINGS //
local state = {
    levelFarm = false,
    chestFarm = false,
    fruitSniper = true,
    fastAttack = true
}

-- // UI MINIMALIST //
local gui = Instance.new("ScreenGui", player.PlayerGui)
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromOffset(220, 180)
frame.Position = UDim2.new(0.05, 0, 0.2, 0)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Instance.new("UICorner", frame)

local function createToggle(name, pos, callback)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.Position = UDim2.new(0.05, 0, 0, pos)
    btn.Text = name .. ": OFF"
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    btn.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", btn)
    
    local active = false
    btn.MouseButton1Click:Connect(function()
        active = not active
        btn.Text = name .. (active and ": ON" or ": OFF")
        btn.BackgroundColor3 = active and Color3.fromRGB(0, 150, 100) or Color3.fromRGB(30, 30, 40)
        callback(active)
    end)
end

-- // 1. CHEST FARM LOGIC //
local function doChestFarm()
    while state.chestFarm do
        for _, v in pairs(workspace:GetDescendants()) do
            if v.Name:find("Chest") and v:IsA("TouchTransmitter") then
                if not state.chestFarm then break end
                hrp.CFrame = v.Parent.CFrame
                task.wait(0.2) -- Faster TP might get you kicked
            end
        end
        task.wait(1)
    end
end

-- // 2. LEVEL FARM LOGIC //
local function doLevelFarm()
    while state.levelFarm do
        pcall(function()
            -- Find Nearest Mob & Auto-Quest (Simplified for script)
            local enemy = workspace.Enemies:FindFirstChildWhichIsA("Model")
            if enemy and enemy:FindFirstChild("HumanoidRootPart") and enemy.Humanoid.Health > 0 then
                hrp.CFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
                -- Auto Attack
                local tool = char:FindFirstChildOfClass("Tool")
                if tool then tool:Activate() end
            end
        end)
        task.wait()
    end
end

-- // UI BUTTONS //
createToggle("Auto Level Farm", 10, function(v) 
    state.levelFarm = v 
    if v then doLevelFarm() end 
end)

createToggle("Auto Chest Farm", 55, function(v) 
    state.chestFarm = v 
    if v then doChestFarm() end 
end)

createToggle("Fruit Sniper", 100, function(v) 
    state.fruitSniper = v 
end)

print("NW V2 Loaded! Use Chest Farm for Beli and Level Farm for XP.")
