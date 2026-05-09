-- Example: How to use Discord Button in NixoUI
local NixoUI = loadstring(game:HttpGet('https://raw.githubusercontent.com/chhinhlongdev/NixoUI/refs/heads/main/NixoUI.lua'))()

local Window = NixoUI:CreateWindow({
    Name = "Discord Button Example",
    LoadingTitle = "Loading",
    LoadingSubtitle = "Discord Integration Demo"
})

-- Create Community Tab
local CommunityTab = Window:CreateTab({
    Name = "Community",
    Icon = "👥"
})

-- Add Discord Button
CommunityTab:CreateSection({Name = "Join Our Community"})

CommunityTab:CreateDiscord({
    Name = "Join Discord Server",
    Invite = "https://discord.gg/yourserver",
    Callback = function()
        print("Discord invite copied to clipboard!")
    end
})

CommunityTab:CreateLabel({
    Text = "Click the button above to copy the invite link!"
})

-- Another example with different invite
CommunityTab:CreateDiscord({
    Name = "Support Server",
    Invite = "https://discord.gg/support",
    Callback = function()
        print("Support server invite copied!")
    end
})

print("Discord Button Example loaded!")
