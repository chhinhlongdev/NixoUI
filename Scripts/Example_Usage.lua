-- Example: How to use NixoUI Library
-- Load the UI library (replace with your actual URL)
local NixoUI = loadstring(game:HttpGet('YOUR_URL_HERE'))()

-- Create Window
local Window = NixoUI:CreateWindow({
    Name = "NixoUI | Universal Hub",
    LoadingTitle = "NixoUI",
    LoadingSubtitle = "Universal Hub V1.0",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "NixoConfig"
    }
})

-- Create Tabs
local MainTab = Window:CreateTab({
    Name = "Main",
    Icon = "🏠"
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

-- Main Tab Elements
MainTab:CreateSection({Name = "Movement"})

MainTab:CreateSlider({
    Name = "Walk Speed",
    Min = 16,
    Max = 200,
    Default = 16,
    Callback = function(value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
    end
})

MainTab:CreateSlider({
    Name = "Jump Power",
    Min = 50,
    Max = 300,
    Default = 50,
    Callback = function(value)
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = value
    end
})

MainTab:CreateToggle({
    Name = "Fly",
    Default = false,
    Callback = function(state)
        print("Fly:", state)
    end
})

MainTab:CreateToggle({
    Name = "Noclip",
    Default = false,
    Callback = function(state)
        print("Noclip:", state)
    end
})

-- Player Tab Elements
PlayerTab:CreateSection({Name = "Player Interaction"})

PlayerTab:CreateDropdown({
    Name = "Select Player",
    Options = {"Player1", "Player2", "Player3"},
    Callback = function(value)
        print("Selected:", value)
    end
})

PlayerTab:CreateButton({
    Name = "Teleport to Player",
    Callback = function()
        print("Teleporting...")
    end
})

PlayerTab:CreateButton({
    Name = "Kill Player",
    Callback = function()
        print("Killing player...")
    end
})

-- Visual Tab Elements
VisualTab:CreateSection({Name = "ESP Options"})

VisualTab:CreateToggle({
    Name = "ESP Players",
    Default = false,
    Callback = function(state)
        print("ESP Players:", state)
    end
})

VisualTab:CreateToggle({
    Name = "ESP Enemies",
    Default = false,
    Callback = function(state)
        print("ESP Enemies:", state)
    end
})

VisualTab:CreateToggle({
    Name = "ESP Chests",
    Default = false,
    Callback = function(state)
        print("ESP Chests:", state)
    end
})

VisualTab:CreateToggle({
    Name = "Full Bright",
    Default = false,
    Callback = function(state)
        if state then
            game.Lighting.Brightness = 2
            game.Lighting.ClockTime = 14
            game.Lighting.FogEnd = 100000
        else
            game.Lighting.Brightness = 1
            game.Lighting.ClockTime = 12
            game.Lighting.FogEnd = 2500
        end
    end
})

-- Misc Tab Elements
MiscTab:CreateSection({Name = "Utilities"})

MiscTab:CreateToggle({
    Name = "Anti AFK",
    Default = false,
    Callback = function(state)
        print("Anti AFK:", state)
    end
})

MiscTab:CreateLabel({
    Text = "Script Version: 1.0"
})

MiscTab:CreateButton({
    Name = "Destroy GUI",
    Callback = function()
        Window.ScreenGui:Destroy()
    end
})

print("NixoUI loaded successfully!")
