-- Simple Roblox Script Hub
-- Using NixoUI Library
-- Easy to use with essential features

-- Load NixoUI Library
local NixoUI = loadstring(game:HttpGet('https://raw.githubusercontent.com/chhinhlongdev/NixoUI/refs/heads/main/NixoUI.lua'))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")

-- Settings
local Settings = {
    WalkSpeed = 16,
    JumpPower = 50,
    Fly = false,
    Noclip = false,
    InfiniteJump = false,
    FullBright = false,
    SelectedPlayer = nil
}

-- Create Window
local Window = NixoUI:CreateWindow({
    Name = "Simple Hub | Universal Script",
    LoadingTitle = "Simple Hub",
    LoadingSubtitle = "Universal Script V1.0",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "SimpleHubConfig"
    }
})

-- Create Tabs
local MovementTab = Window:CreateTab({
    Name = "Movement",
    Icon = "🏃"
})

local PlayerTab = Window:CreateTab({
    Name = "Player",
    Icon = "👤"
})

local VisualTab = Window:CreateTab({
    Name = "Visual",
    Icon = "👁️"
})

local MiscTab = Window:CreateTab({
    Name = "Misc",
    Icon = "⚙️"
})

-- Movement Tab
MovementTab:CreateSection({Name = "Speed & Jump"})

MovementTab:CreateSlider({
    Name = "Walk Speed",
    Min = 16,
    Max = 200,
    Default = 16,
    Callback = function(value)
        Settings.WalkSpeed = value
        if Humanoid then
            Humanoid.WalkSpeed = value
        end
    end
})

MovementTab:CreateSlider({
    Name = "Jump Power",
    Min = 50,
    Max = 300,
    Default = 50,
    Callback = function(value)
        Settings.JumpPower = value
        if Humanoid then
            Humanoid.JumpPower = value
        end
    end
})

MovementTab:CreateSection({Name = "Flight & Movement"})

MovementTab:CreateToggle({
    Name = "Fly",
    Default = false,
    Callback = function(state)
        Settings.Fly = state
    end
})

MovementTab:CreateToggle({
    Name = "Noclip",
    Default = false,
    Callback = function(state)
        Settings.Noclip = state
    end
})

MovementTab:CreateToggle({
    Name = "Infinite Jump",
    Default = false,
    Callback = function(state)
        Settings.InfiniteJump = state
    end
})

-- Player Tab
PlayerTab:CreateSection({Name = "Player Selection"})

-- Get Player List Function
local function GetPlayerList()
    local playerList = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= Player then
            table.insert(playerList, player.Name)
        end
    end
    if #playerList == 0 then
        table.insert(playerList, "No Players")
    end
    return playerList
end

local playerList = GetPlayerList()

PlayerTab:CreateDropdown({
    Name = "Select Player",
    Options = playerList,
    Callback = function(value)
        Settings.SelectedPlayer = value
        print("Selected: " .. value)
    end
})

PlayerTab:CreateButton({
    Name = "Refresh Player List",
    Callback = function()
        playerList = GetPlayerList()
        print("Player list refreshed!")
    end
})

PlayerTab:CreateSection({Name = "Player Actions"})

PlayerTab:CreateButton({
    Name = "Teleport to Player",
    Callback = function()
        if Settings.SelectedPlayer and Settings.SelectedPlayer ~= "No Players" then
            local targetPlayer = Players:FindFirstChild(Settings.SelectedPlayer)
            if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame
                print("✅ Teleported to " .. Settings.SelectedPlayer)
            else
                print("❌ Player not found!")
            end
        else
            print("❌ No player selected!")
        end
    end
})

PlayerTab:CreateButton({
    Name = "Bring Player to You",
    Callback = function()
        if Settings.SelectedPlayer and Settings.SelectedPlayer ~= "No Players" then
            local targetPlayer = Players:FindFirstChild(Settings.SelectedPlayer)
            if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                targetPlayer.Character.HumanoidRootPart.CFrame = HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
                print("✅ Brought " .. Settings.SelectedPlayer .. " to you")
            else
                print("❌ Player not found!")
            end
        else
            print("❌ No player selected!")
        end
    end
})

PlayerTab:CreateButton({
    Name = "Kill Player",
    Callback = function()
        if Settings.SelectedPlayer and Settings.SelectedPlayer ~= "No Players" then
            local targetPlayer = Players:FindFirstChild(Settings.SelectedPlayer)
            if targetPlayer and targetPlayer.Character then
                local targetHumanoid = targetPlayer.Character:FindFirstChild("Humanoid")
                local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
                
                if targetHumanoid and targetRoot then
                    targetHumanoid.Health = 0
                    targetRoot.CFrame = CFrame.new(0, -500, 0)
                    print("✅ Attempted to kill " .. Settings.SelectedPlayer)
                else
                    print("❌ Cannot access player's character!")
                end
            else
                print("❌ Player not found!")
            end
        else
            print("❌ No player selected!")
        end
    end
})

-- Visual Tab
VisualTab:CreateSection({Name = "Lighting"})

VisualTab:CreateToggle({
    Name = "Full Bright",
    Default = false,
    Callback = function(state)
        Settings.FullBright = state
        if state then
            game.Lighting.Brightness = 2
            game.Lighting.ClockTime = 14
            game.Lighting.FogEnd = 100000
            game.Lighting.GlobalShadows = false
            game.Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
        else
            game.Lighting.Brightness = 1
            game.Lighting.ClockTime = 12
            game.Lighting.FogEnd = 2500
            game.Lighting.GlobalShadows = true
        end
    end
})

VisualTab:CreateLabel({
    Text = "More visual features coming soon!"
})

-- Misc Tab
MiscTab:CreateSection({Name = "Character"})

MiscTab:CreateButton({
    Name = "Reset Character",
    Callback = function()
        if Humanoid then
            Humanoid.Health = 0
            print("✅ Character reset")
        end
    end
})

MiscTab:CreateSection({Name = "Script Info"})

MiscTab:CreateLabel({
    Text = "Simple Hub V1.0"
})

MiscTab:CreateLabel({
    Text = "Using NixoUI Library"
})

MiscTab:CreateButton({
    Name = "Destroy GUI",
    Callback = function()
        Window.ScreenGui:Destroy()
        print("✅ GUI destroyed")
    end
})

-- Fly System
local flySpeed = 50
local flyConnection

local function StartFly()
    if flyConnection then return end
    
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Parent = HumanoidRootPart
    bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    
    local bodyGyro = Instance.new("BodyGyro")
    bodyGyro.Parent = HumanoidRootPart
    bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    
    flyConnection = RunService.Heartbeat:Connect(function()
        if not Settings.Fly then
            bodyVelocity:Destroy()
            bodyGyro:Destroy()
            if flyConnection then
                flyConnection:Disconnect()
                flyConnection = nil
            end
            return
        end
        
        local camera = workspace.CurrentCamera
        local moveDirection = Vector3.new(0, 0, 0)
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveDirection = moveDirection + camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveDirection = moveDirection - camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveDirection = moveDirection - camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveDirection = moveDirection + camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            moveDirection = moveDirection + Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            moveDirection = moveDirection - Vector3.new(0, 1, 0)
        end
        
        bodyVelocity.Velocity = moveDirection * flySpeed
        bodyGyro.CFrame = camera.CFrame
    end)
end

-- Main Loop
RunService.Heartbeat:Connect(function()
    pcall(function()
        -- Update Character Reference
        if not Character or not Character.Parent then
            Character = Player.Character
            if Character then
                HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
                Humanoid = Character:WaitForChild("Humanoid")
            end
        end
        
        -- Fly
        if Settings.Fly and not flyConnection then
            StartFly()
        end
        
        -- Noclip
        if Settings.Noclip and Character then
            for _, part in pairs(Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
        
        -- Infinite Jump
        if Settings.InfiniteJump then
            UserInputService.JumpRequest:Connect(function()
                if Humanoid then
                    Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
        end
    end)
end)

print("=================================")
print("Simple Hub loaded successfully!")
print("Using NixoUI Library")
print("=================================")
