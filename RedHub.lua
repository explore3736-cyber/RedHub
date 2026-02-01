--[=[
    RED & BLACK HUB (MOBILE)
    Real Fly Included
    Works on Delta Executor
]=]

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RedHub"
ScreenGui.Parent = PlayerGui

-- LOADING SCREEN
local LoadingFrame = Instance.new("Frame")
LoadingFrame.Size = UDim2.new(1, 0, 1, 0)
LoadingFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
LoadingFrame.Parent = ScreenGui

local LoadingText = Instance.new("TextLabel")
LoadingText.Size = UDim2.new(0, 250, 0, 50)
LoadingText.Position = UDim2.new(0.5, -125, 0.5, -25)
LoadingText.Text = "LOADING RED HUB..."
LoadingText.TextColor3 = Color3.fromRGB(255, 0, 0)
LoadingText.TextScaled = true
LoadingText.BackgroundTransparency = 1
LoadingText.Parent = LoadingFrame

task.wait(3)
LoadingFrame:Destroy()

-- MAIN FRAME
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 200)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(255, 0, 0)
MainFrame.Parent = ScreenGui
MainFrame.Active = true
MainFrame.Draggable = true

-- TITLE
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
Title.Text = "RED HUB | MOBILE"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextScaled = true
Title.Parent = MainFrame

-- FLY BUTTON
local FlyButton = Instance.new("TextButton")
FlyButton.Size = UDim2.new(0, 200, 0, 50)
FlyButton.Position = UDim2.new(0.5, -100, 0.5, -25)
FlyButton.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
FlyButton.Text = "FLY : OFF"
FlyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FlyButton.TextScaled = true
FlyButton.Parent = MainFrame

-- REAL FLY LOGIC
local flying = false
local speed = 60
local bv, bg
local flyConnection

FlyButton.MouseButton1Click:Connect(function()
    local character = player.Character or player.CharacterAdded:Wait()
    local hrp = character:WaitForChild("HumanoidRootPart")

    if not flying then
        flying = true
        FlyButton.Text = "FLY : ON"

        bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        bv.Velocity = Vector3.zero
        bv.Parent = hrp

        bg = Instance.new("BodyGyro")
        bg.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
        bg.CFrame = hrp.CFrame
        bg.Parent = hrp

        flyConnection = RunService.RenderStepped:Connect(function()
            if flying then
                local cam = workspace.CurrentCamera
                bv.Velocity = cam.CFrame.LookVector * speed
                bg.CFrame = cam.CFrame
            end
        end)
    else
        flying = false
        FlyButton.Text = "FLY : OFF"

        if flyConnection then flyConnection:Disconnect() end
        if bv then bv:Destroy() end
        if bg then bg:Destroy() end
    end
end)
