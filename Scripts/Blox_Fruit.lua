-- Blox Fruits Advanced Auto Farm Script
-- Discord: https://discord.gg/bloxfruits

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")

-- Configuration
local Config = {
    Farming = {
        Enabled = false,
        WeaponType = "Melee", -- Melee, Sword, Gun, Blox Fruit
        UseSkills = false,
        FastAttack = false,
        SelectedWeapon = nil
    },
    Material = {
        AutoFarm = false,
        TargetMaterial = nil,
        FarmLegendary = false
    },
    Tweening = {
        Speed = 300,
        QuickTeleport = false,
        DodgePosition = CFrame.new(0, 50, 0)
    },
    Pulling = {
        Enabled = false,
        Range = 100
    },
    Options = {
        AntiAFK = true,
        AutoRespawn = true,
        RemoveFog = false,
        NoClip = false
    },
    Movement = {
        Fly = false,
        FlySpeed = 50,
        JumpPower = 50,
        WalkSpeed = 16,
        InfiniteJump = false
    },
    Player = {
        SelectedPlayer = nil,
        ESPEnabled = false,
        ESPItems = false,
        ESPChests = false,
        ESPFruits = false,
        ESPEnemies = false,
        ESPTracers = false,
        ESPBoxes = false,
        ESPDistance = true,
        ESPHealth = true
    },
    Dojo = {
        AutoQuest = false
    },
    Quest = {
        TrainingDummy = false
    },
    Skiller = {
        WeaponType = "Melee"
    },
    Boss = {
        Elite = false,
        CakePrince = false,
        RipIndra = false,
        TyrantSkies = false,
        Darkbeard = false
    },
    Fruit = {
        AutoCollect = false,
        AutoStore = false
    },
    Collectable = {
        Berry = false,
        Chest = false,
        QuestFruit = false
    }
}

-- GUI Library
local Library = {}

function Library:CreateWindow(title)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "BloxFruitsHub"
    ScreenGui.Parent = game.CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(0.3, 0, 0.2, 0)
    MainFrame.Size = UDim2.new(0, 600, 0, 500)
    MainFrame.Active = true
    MainFrame.Draggable = true
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 10)
    UICorner.Parent = MainFrame
    
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Parent = MainFrame
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 0, 0, 0)
    Title.Size = UDim2.new(1, -100, 0, 40)
    Title.Font = Enum.Font.GothamBold
    Title.Text = title
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 18
    
    -- Minimize Button
    local MinimizeBtn = Instance.new("TextButton")
    MinimizeBtn.Name = "MinimizeBtn"
    MinimizeBtn.Parent = MainFrame
    MinimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
    MinimizeBtn.Position = UDim2.new(1, -90, 0, 10)
    MinimizeBtn.Size = UDim2.new(0, 35, 0, 25)
    MinimizeBtn.Font = Enum.Font.GothamBold
    MinimizeBtn.Text = "—"
    MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinimizeBtn.TextSize = 16
    MinimizeBtn.AutoButtonColor = false
    
    local MinimizeCorner = Instance.new("UICorner")
    MinimizeCorner.CornerRadius = UDim.new(0, 6)
    MinimizeCorner.Parent = MinimizeBtn
    
    -- Close Button
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Name = "CloseBtn"
    CloseBtn.Parent = MainFrame
    CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
    CloseBtn.Position = UDim2.new(1, -50, 0, 10)
    CloseBtn.Size = UDim2.new(0, 35, 0, 25)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.Text = "×"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.TextSize = 20
    CloseBtn.AutoButtonColor = false
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 6)
    CloseCorner.Parent = CloseBtn
    
    -- Minimize Icon (when minimized)
    local MinimizedIcon = Instance.new("TextButton")
    MinimizedIcon.Name = "MinimizedIcon"
    MinimizedIcon.Parent = ScreenGui
    MinimizedIcon.BackgroundColor3 = Color3.fromRGB(50, 100, 200)
    MinimizedIcon.Position = UDim2.new(0, 10, 1, -60)
    MinimizedIcon.Size = UDim2.new(0, 50, 0, 50)
    MinimizedIcon.Font = Enum.Font.GothamBold
    MinimizedIcon.Text = "📦"
    MinimizedIcon.TextSize = 24
    MinimizedIcon.Visible = false
    MinimizedIcon.AutoButtonColor = false
    
    local IconCorner = Instance.new("UICorner")
    IconCorner.CornerRadius = UDim.new(0, 10)
    IconCorner.Parent = MinimizedIcon
    
    -- Button Hover Effects
    MinimizeBtn.MouseEnter:Connect(function()
        TweenService:Create(MinimizeBtn, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            BackgroundColor3 = Color3.fromRGB(255, 220, 100)
        }):Play()
    end)
    
    MinimizeBtn.MouseLeave:Connect(function()
        TweenService:Create(MinimizeBtn, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            BackgroundColor3 = Color3.fromRGB(255, 200, 50)
        }):Play()
    end)
    
    CloseBtn.MouseEnter:Connect(function()
        TweenService:Create(CloseBtn, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            BackgroundColor3 = Color3.fromRGB(255, 70, 70)
        }):Play()
    end)
    
    CloseBtn.MouseLeave:Connect(function()
        TweenService:Create(CloseBtn, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            BackgroundColor3 = Color3.fromRGB(220, 50, 50)
        }):Play()
    end)
    
    MinimizedIcon.MouseEnter:Connect(function()
        TweenService:Create(MinimizedIcon, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            BackgroundColor3 = Color3.fromRGB(70, 120, 220),
            Size = UDim2.new(0, 55, 0, 55)
        }):Play()
    end)
    
    MinimizedIcon.MouseLeave:Connect(function()
        TweenService:Create(MinimizedIcon, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            BackgroundColor3 = Color3.fromRGB(50, 100, 200),
            Size = UDim2.new(0, 50, 0, 50)
        }):Play()
    end)
    
    -- Minimize Functionality
    local isMinimized = false
    MinimizeBtn.MouseButton1Click:Connect(function()
        isMinimized = true
        
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0, 10, 1, -60)
        }):Play()
        
        task.wait(0.3)
        MainFrame.Visible = false
        MinimizedIcon.Visible = true
        
        TweenService:Create(MinimizedIcon, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 50, 0, 50)
        }):Play()
    end)
    
    -- Restore Functionality
    MinimizedIcon.MouseButton1Click:Connect(function()
        isMinimized = false
        MinimizedIcon.Visible = false
        MainFrame.Visible = true
        
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 600, 0, 500),
            Position = UDim2.new(0.3, 0, 0.2, 0)
        }):Play()
    end)
    
    -- Close Functionality
    CloseBtn.MouseButton1Click:Connect(function()
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0)
        }):Play()
        
        if MinimizedIcon.Visible then
            TweenService:Create(MinimizedIcon, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                Size = UDim2.new(0, 0, 0, 0)
            }):Play()
        end
        
        task.wait(0.3)
        ScreenGui:Destroy()
        _G.ScriptEnabled = false
        print("Script GUI closed")
    end)
    
    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Name = "TabContainer"
    TabContainer.Parent = MainFrame
    TabContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    TabContainer.BorderSizePixel = 0
    TabContainer.Position = UDim2.new(0, 10, 0, 50)
    TabContainer.Size = UDim2.new(0, 150, 1, -60)
    TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabContainer.ScrollBarThickness = 4
    TabContainer.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 120)
    TabContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
    TabContainer.ScrollingDirection = Enum.ScrollingDirection.Y
    
    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 8)
    TabCorner.Parent = TabContainer
    
    local TabLayout = Instance.new("UIListLayout")
    TabLayout.Parent = TabContainer
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabLayout.Padding = UDim.new(0, 5)
    TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    
    local TabPadding = Instance.new("UIPadding")
    TabPadding.Parent = TabContainer
    TabPadding.PaddingLeft = UDim.new(0, 5)
    TabPadding.PaddingRight = UDim.new(0, 5)
    TabPadding.PaddingTop = UDim.new(0, 5)
    TabPadding.PaddingBottom = UDim.new(0, 5)
    
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Parent = MainFrame
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Position = UDim2.new(0, 170, 0, 50)
    ContentContainer.Size = UDim2.new(1, -180, 1, -60)
    
    return {
        ScreenGui = ScreenGui,
        MainFrame = MainFrame,
        TabContainer = TabContainer,
        ContentContainer = ContentContainer,
        MinimizedIcon = MinimizedIcon,
        Tabs = {}
    }
end

function Library:CreateTab(window, name)
    local TabButton = Instance.new("TextButton")
    TabButton.Name = name
    TabButton.Parent = window.TabContainer
    TabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    TabButton.BorderSizePixel = 0
    TabButton.Size = UDim2.new(1, 0, 0, 35)
    TabButton.Font = Enum.Font.Gotham
    TabButton.Text = name
    TabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    TabButton.TextSize = 14
    TabButton.AutoButtonColor = false
    
    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 6)
    TabCorner.Parent = TabButton
    
    local TabContent = Instance.new("ScrollingFrame")
    TabContent.Name = name .. "Content"
    TabContent.Parent = window.ContentContainer
    TabContent.BackgroundTransparency = 1
    TabContent.BorderSizePixel = 0
    TabContent.Size = UDim2.new(1, 0, 1, 0)
    TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabContent.ScrollBarThickness = 6
    TabContent.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 120)
    TabContent.ScrollingDirection = Enum.ScrollingDirection.Y
    TabContent.ElasticBehavior = Enum.ElasticBehavior.WhenScrollable
    TabContent.ScrollingEnabled = true
    TabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
    TabContent.Visible = false
    
    local ContentLayout = Instance.new("UIListLayout")
    ContentLayout.Parent = TabContent
    ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ContentLayout.Padding = UDim.new(0, 8)
    ContentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    
    local ContentPadding = Instance.new("UIPadding")
    ContentPadding.Parent = TabContent
    ContentPadding.PaddingLeft = UDim.new(0, 5)
    ContentPadding.PaddingRight = UDim.new(0, 5)
    ContentPadding.PaddingTop = UDim.new(0, 5)
    ContentPadding.PaddingBottom = UDim.new(0, 5)
    
    TabButton.MouseButton1Click:Connect(function()
        for _, tab in pairs(window.Tabs) do
            tab.Content.Visible = false
            TweenService:Create(tab.Button, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                BackgroundColor3 = Color3.fromRGB(30, 30, 45)
            }):Play()
        end
        TabContent.Visible = true
        TweenService:Create(TabButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            BackgroundColor3 = Color3.fromRGB(50, 50, 70)
        }):Play()
    end)
    
    TabButton.MouseEnter:Connect(function()
        if TabContent.Visible == false then
            TweenService:Create(TabButton, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {
                BackgroundColor3 = Color3.fromRGB(40, 40, 55)
            }):Play()
        end
    end)
    
    TabButton.MouseLeave:Connect(function()
        if TabContent.Visible == false then
            TweenService:Create(TabButton, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {
                BackgroundColor3 = Color3.fromRGB(30, 30, 45)
            }):Play()
        end
    end)
    
    window.Tabs[name] = {Button = TabButton, Content = TabContent}
    
    if #window.TabContainer:GetChildren() == 2 then
        TabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
        TabContent.Visible = true
    end
    
    return TabContent
end

function Library:CreateToggle(parent, text, callback)
    local Toggle = Instance.new("Frame")
    Toggle.Parent = parent
    Toggle.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    Toggle.Size = UDim2.new(1, 0, 0, 35)
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 6)
    ToggleCorner.Parent = Toggle
    
    local Label = Instance.new("TextLabel")
    Label.Parent = Toggle
    Label.BackgroundTransparency = 1
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.Size = UDim2.new(1, -50, 1, 0)
    Label.Font = Enum.Font.Gotham
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(200, 200, 200)
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left
    
    local Button = Instance.new("TextButton")
    Button.Parent = Toggle
    Button.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    Button.Position = UDim2.new(1, -40, 0.5, -12)
    Button.Size = UDim2.new(0, 35, 0, 24)
    Button.Text = ""
    Button.AutoButtonColor = false
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(1, 0)
    ButtonCorner.Parent = Button
    
    local Indicator = Instance.new("Frame")
    Indicator.Parent = Button
    Indicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Indicator.Position = UDim2.new(0, 2, 0.5, -10)
    Indicator.Size = UDim2.new(0, 20, 0, 20)
    
    local IndicatorCorner = Instance.new("UICorner")
    IndicatorCorner.CornerRadius = UDim.new(1, 0)
    IndicatorCorner.Parent = Indicator
    
    local state = false
    Button.MouseButton1Click:Connect(function()
        state = not state
        
        TweenService:Create(Button, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            BackgroundColor3 = state and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
        }):Play()
        
        TweenService:Create(Indicator, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Position = state and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
        }):Play()
        
        callback(state)
    end)
    
    Button.MouseEnter:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0, 38, 0, 26)
        }):Play()
    end)
    
    Button.MouseLeave:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0, 35, 0, 24)
        }):Play()
    end)
    
    return Toggle
end

function Library:CreateDropdown(parent, text, options, callback)
    local Dropdown = Instance.new("Frame")
    Dropdown.Parent = parent
    Dropdown.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    Dropdown.Size = UDim2.new(1, 0, 0, 35)
    
    local DropdownCorner = Instance.new("UICorner")
    DropdownCorner.CornerRadius = UDim.new(0, 6)
    DropdownCorner.Parent = Dropdown
    
    local Label = Instance.new("TextLabel")
    Label.Parent = Dropdown
    Label.BackgroundTransparency = 1
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.Size = UDim2.new(0.5, 0, 1, 0)
    Label.Font = Enum.Font.Gotham
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(200, 200, 200)
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left
    
    local Button = Instance.new("TextButton")
    Button.Parent = Dropdown
    Button.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    Button.Position = UDim2.new(0.5, 5, 0.5, -12)
    Button.Size = UDim2.new(0.5, -15, 0, 24)
    Button.Font = Enum.Font.Gotham
    Button.Text = options[1] or "Select"
    Button.TextColor3 = Color3.fromRGB(200, 200, 200)
    Button.TextSize = 12
    Button.AutoButtonColor = false
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 4)
    ButtonCorner.Parent = Button
    
    Button.MouseButton1Click:Connect(function()
        local currentIndex = table.find(options, Button.Text) or 1
        local nextIndex = (currentIndex % #options) + 1
        Button.Text = options[nextIndex]
        
        TweenService:Create(Button, TweenInfo.new(0.2, Enum.EasingStyle.Back), {
            BackgroundColor3 = Color3.fromRGB(60, 60, 90)
        }):Play()
        
        task.wait(0.1)
        
        TweenService:Create(Button, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            BackgroundColor3 = Color3.fromRGB(40, 40, 60)
        }):Play()
        
        callback(options[nextIndex])
    end)
    
    Button.MouseEnter:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {
            BackgroundColor3 = Color3.fromRGB(50, 50, 70)
        }):Play()
    end)
    
    Button.MouseLeave:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {
            BackgroundColor3 = Color3.fromRGB(40, 40, 60)
        }):Play()
    end)
    
    return Dropdown
end

function Library:CreateSlider(parent, text, min, max, default, callback)
    local Slider = Instance.new("Frame")
    Slider.Parent = parent
    Slider.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    Slider.Size = UDim2.new(1, 0, 0, 50)
    
    local SliderCorner = Instance.new("UICorner")
    SliderCorner.CornerRadius = UDim.new(0, 6)
    SliderCorner.Parent = Slider
    
    local Label = Instance.new("TextLabel")
    Label.Parent = Slider
    Label.BackgroundTransparency = 1
    Label.Position = UDim2.new(0, 10, 0, 5)
    Label.Size = UDim2.new(1, -20, 0, 20)
    Label.Font = Enum.Font.Gotham
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(200, 200, 200)
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left
    
    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Parent = Slider
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.Position = UDim2.new(1, -60, 0, 5)
    ValueLabel.Size = UDim2.new(0, 50, 0, 20)
    ValueLabel.Font = Enum.Font.GothamBold
    ValueLabel.Text = tostring(default)
    ValueLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
    ValueLabel.TextSize = 13
    ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    
    local SliderBar = Instance.new("Frame")
    SliderBar.Parent = Slider
    SliderBar.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    SliderBar.Position = UDim2.new(0, 10, 0, 30)
    SliderBar.Size = UDim2.new(1, -20, 0, 8)
    
    local BarCorner = Instance.new("UICorner")
    BarCorner.CornerRadius = UDim.new(1, 0)
    BarCorner.Parent = SliderBar
    
    local SliderFill = Instance.new("Frame")
    SliderFill.Parent = SliderBar
    SliderFill.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
    SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    
    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(1, 0)
    FillCorner.Parent = SliderFill
    
    local SliderButton = Instance.new("TextButton")
    SliderButton.Parent = SliderBar
    SliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SliderButton.Position = UDim2.new((default - min) / (max - min), -6, 0.5, -6)
    SliderButton.Size = UDim2.new(0, 12, 0, 12)
    SliderButton.Text = ""
    SliderButton.AutoButtonColor = false
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(1, 0)
    ButtonCorner.Parent = SliderButton
    
    local dragging = false
    local value = default
    
    SliderButton.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    game:GetService("UserInputService").InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    SliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    
    game:GetService("RunService").RenderStepped:Connect(function()
        if dragging then
            local mouse = game.Players.LocalPlayer:GetMouse()
            local percent = math.clamp((mouse.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
            value = math.floor(min + (max - min) * percent)
            
            ValueLabel.Text = tostring(value)
            
            TweenService:Create(SliderFill, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {
                Size = UDim2.new(percent, 0, 1, 0)
            }):Play()
            
            TweenService:Create(SliderButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {
                Position = UDim2.new(percent, -6, 0.5, -6)
            }):Play()
            
            callback(value)
        end
    end)
    
    return Slider
end

function Library:CreateButton(parent, text, callback)
    local Button = Instance.new("TextButton")
    Button.Parent = parent
    Button.BackgroundColor3 = Color3.fromRGB(50, 100, 200)
    Button.Size = UDim2.new(1, 0, 0, 35)
    Button.Font = Enum.Font.GothamBold
    Button.Text = text
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 14
    Button.AutoButtonColor = false
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 6)
    ButtonCorner.Parent = Button
    
    Button.MouseButton1Click:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {
            Size = UDim2.new(1, 0, 0, 32)
        }):Play()
        
        task.wait(0.1)
        
        TweenService:Create(Button, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {
            Size = UDim2.new(1, 0, 0, 35)
        }):Play()
        
        callback()
    end)
    
    Button.MouseEnter:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            BackgroundColor3 = Color3.fromRGB(70, 120, 220)
        }):Play()
    end)
    
    Button.MouseLeave:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            BackgroundColor3 = Color3.fromRGB(50, 100, 200)
        }):Play()
    end)
    
    return Button
end

-- Create GUI
local Window = Library:CreateWindow("Blox Fruits Hub | Advanced Auto Farm")

-- Toggle GUI Visibility
local GuiVisible = true
local uis = game:GetService("UserInputService")

uis.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        GuiVisible = not GuiVisible
        
        if GuiVisible then
            -- Check if minimized
            if Window.MinimizedIcon.Visible then
                Window.MinimizedIcon.Visible = false
            end
            
            Window.MainFrame.Visible = true
            TweenService:Create(Window.MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 600, 0, 500),
                Position = UDim2.new(0.3, 0, 0.2, 0)
            }):Play()
        else
            TweenService:Create(Window.MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                Size = UDim2.new(0, 0, 0, 0)
            }):Play()
            
            task.wait(0.3)
            Window.MainFrame.Visible = false
        end
    end
end)

-- Community Tab
local CommunityTab = Library:CreateTab(Window, "Community")
Library:CreateButton(CommunityTab, "Join Discord Server", function()
    setclipboard("https://discord.gg/bloxfruits")
    print("Discord link copied to clipboard!")
end)

-- Farming Tab
local FarmingTab = Library:CreateTab(Window, "Farming")
Library:CreateToggle(FarmingTab, "Auto Farm", function(state)
    Config.Farming.Enabled = state
end)
Library:CreateDropdown(FarmingTab, "Weapon Type", {"Melee", "Sword", "Gun", "Blox Fruit"}, function(value)
    Config.Farming.WeaponType = value
end)
Library:CreateToggle(FarmingTab, "Use Skills", function(state)
    Config.Farming.UseSkills = state
end)
Library:CreateToggle(FarmingTab, "Fast Attack", function(state)
    Config.Farming.FastAttack = state
end)

-- Material Tab
local MaterialTab = Library:CreateTab(Window, "Material")
Library:CreateToggle(MaterialTab, "Auto Farm Materials", function(state)
    Config.Material.AutoFarm = state
end)
Library:CreateToggle(MaterialTab, "Farm Legendary Items", function(state)
    Config.Material.FarmLegendary = state
end)

-- Tweening Tab
local TweeningTab = Library:CreateTab(Window, "Tweening")
Library:CreateToggle(TweeningTab, "Quick Teleport", function(state)
    Config.Tweening.QuickTeleport = state
end)
Library:CreateToggle(TweeningTab, "Auto Dodge", function(state)
    -- Dodge implementation
end)

-- Pulling Tab
local PullingTab = Library:CreateTab(Window, "Pulling")
Library:CreateToggle(PullingTab, "Enemy Pulling", function(state)
    Config.Pulling.Enabled = state
end)

-- Options Tab
local OptionsTab = Library:CreateTab(Window, "Options")
Library:CreateToggle(OptionsTab, "Enable Script", function(state)
    _G.ScriptEnabled = state
    if state then
        print("✅ Script Enabled")
    else
        print("❌ Script Disabled")
    end
end)
Library:CreateToggle(OptionsTab, "Anti AFK", function(state)
    Config.Options.AntiAFK = state
end)
Library:CreateToggle(OptionsTab, "Auto Respawn", function(state)
    Config.Options.AutoRespawn = state
end)
Library:CreateToggle(OptionsTab, "Remove Fog", function(state)
    Config.Options.RemoveFog = state
    if state then
        game.Lighting.FogEnd = 100000
        for _, v in pairs(game.Lighting:GetDescendants()) do
            if v:IsA("Atmosphere") then
                v.Density = 0
            end
        end
    else
        game.Lighting.FogEnd = 2500
    end
end)
Library:CreateToggle(OptionsTab, "No Clip", function(state)
    Config.Options.NoClip = state
end)

-- Movement Tab
local MovementTab = Library:CreateTab(Window, "Movement")
Library:CreateToggle(MovementTab, "Fly", function(state)
    Config.Movement.Fly = state
end)
Library:CreateSlider(MovementTab, "Fly Speed", 0, 100, 50, function(value)
    Config.Movement.FlySpeed = value
end)
Library:CreateSlider(MovementTab, "Walk Speed", 16, 200, 16, function(value)
    Config.Movement.WalkSpeed = value
    if Humanoid then
        Humanoid.WalkSpeed = value
    end
end)
Library:CreateSlider(MovementTab, "Jump Power", 50, 300, 50, function(value)
    Config.Movement.JumpPower = value
    if Humanoid then
        Humanoid.JumpPower = value
    end
end)
Library:CreateToggle(MovementTab, "Infinite Jump", function(state)
    Config.Movement.InfiniteJump = state
end)

-- Player Tab
local PlayerTab = Library:CreateTab(Window, "Player")

-- Get player list
local function GetPlayerList()
    local players = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= Player then
            table.insert(players, player.Name)
        end
    end
    return players
end

local playerList = GetPlayerList()
if #playerList == 0 then
    table.insert(playerList, "No Players")
end

Library:CreateDropdown(PlayerTab, "Select Player", playerList, function(value)
    Config.Player.SelectedPlayer = value
end)

Library:CreateButton(PlayerTab, "Teleport to Player", function()
    if Config.Player.SelectedPlayer and Config.Player.SelectedPlayer ~= "No Players" then
        local targetPlayer = Players:FindFirstChild(Config.Player.SelectedPlayer)
        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame
            print("Teleported to " .. Config.Player.SelectedPlayer)
        else
            print("Player not found or invalid")
        end
    end
end)

Library:CreateButton(PlayerTab, "Refresh Player List", function()
    print("Player list refreshed")
end)

Library:CreateToggle(PlayerTab, "ESP Players", function(state)
    Config.Player.ESPEnabled = state
    if not state then
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                RemoveESP(player.Character.HumanoidRootPart)
            end
        end
    end
end)

Library:CreateToggle(PlayerTab, "ESP Enemies", function(state)
    Config.Player.ESPEnemies = state
    if not state then
        for _, enemy in pairs(game.Workspace.Enemies:GetChildren()) do
            if enemy:FindFirstChild("HumanoidRootPart") then
                RemoveESP(enemy.HumanoidRootPart)
            end
        end
    end
end)

Library:CreateToggle(PlayerTab, "ESP Items", function(state)
    Config.Player.ESPItems = state
end)

Library:CreateToggle(PlayerTab, "ESP Chests", function(state)
    Config.Player.ESPChests = state
    if not state then
        for _, chest in pairs(game.Workspace:GetChildren()) do
            if chest.Name:find("Chest") and chest:FindFirstChild("Root") then
                RemoveESP(chest.Root)
            end
        end
    end
end)

Library:CreateToggle(PlayerTab, "ESP Fruits", function(state)
    Config.Player.ESPFruits = state
    if not state then
        for _, fruit in pairs(game.Workspace:GetChildren()) do
            if string.find(fruit.Name, "Fruit") and fruit:IsA("Tool") and fruit:FindFirstChild("Handle") then
                RemoveESP(fruit.Handle)
            end
        end
    end
end)

Library:CreateToggle(PlayerTab, "ESP Tracers", function(state)
    Config.Player.ESPTracers = state
    if not state then
        ClearAllESP()
    end
end)

Library:CreateToggle(PlayerTab, "ESP Boxes", function(state)
    Config.Player.ESPBoxes = state
    if not state then
        ClearAllESP()
    end
end)

Library:CreateToggle(PlayerTab, "Show Distance", function(state)
    Config.Player.ESPDistance = state
end)

Library:CreateToggle(PlayerTab, "Show Health", function(state)
    Config.Player.ESPHealth = state
end)

-- Misc Tab
local MiscTab = Library:CreateTab(Window, "Misc")
Library:CreateButton(MiscTab, "Destroy GUI", function()
    TweenService:Create(Window.MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0)
    }):Play()
    
    if Window.MinimizedIcon.Visible then
        TweenService:Create(Window.MinimizedIcon, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0)
        }):Play()
    end
    
    task.wait(0.3)
    Window.ScreenGui:Destroy()
    _G.ScriptEnabled = false
    print("Script GUI destroyed")
end)

-- Dojo Tab
local DojoTab = Library:CreateTab(Window, "Dojo")
Library:CreateToggle(DojoTab, "Auto Quest", function(state)
    Config.Dojo.AutoQuest = state
end)

-- Quest Tab
local QuestTab = Library:CreateTab(Window, "Quest")
Library:CreateToggle(QuestTab, "Training Dummy", function(state)
    Config.Quest.TrainingDummy = state
end)

-- Skiller Tab
local SkillerTab = Library:CreateTab(Window, "Skiller")
Library:CreateDropdown(SkillerTab, "Weapon Type", {"Melee", "Sword", "Gun", "Blox Fruit"}, function(value)
    Config.Skiller.WeaponType = value
end)

-- Boss Tab
local BossTab = Library:CreateTab(Window, "Boss")
Library:CreateToggle(BossTab, "Elite Boss", function(state)
    Config.Boss.Elite = state
end)
Library:CreateToggle(BossTab, "Cake Prince", function(state)
    Config.Boss.CakePrince = state
end)
Library:CreateToggle(BossTab, "Rip Indra", function(state)
    Config.Boss.RipIndra = state
end)
Library:CreateToggle(BossTab, "Tyrant Skies", function(state)
    Config.Boss.TyrantSkies = state
end)
Library:CreateToggle(BossTab, "Darkbeard", function(state)
    Config.Boss.Darkbeard = state
end)

-- Fruit Tab
local FruitTab = Library:CreateTab(Window, "Fruit")
Library:CreateToggle(FruitTab, "Auto Collect Fruits", function(state)
    Config.Fruit.AutoCollect = state
end)
Library:CreateToggle(FruitTab, "Auto Store Fruits", function(state)
    Config.Fruit.AutoStore = state
end)

-- Collectable Tab
local CollectableTab = Library:CreateTab(Window, "Collectable")
Library:CreateToggle(CollectableTab, "Auto Collect Berry", function(state)
    Config.Collectable.Berry = state
end)
Library:CreateToggle(CollectableTab, "Auto Collect Chest", function(state)
    Config.Collectable.Chest = state
end)
Library:CreateToggle(CollectableTab, "Auto Quest Fruit", function(state)
    Config.Collectable.QuestFruit = state
end)

-- Global Script Control
_G.ScriptEnabled = false
_G.FlyConnection = nil

-- ESP Functions
local ESPObjects = {}

local function CreateESP(object, color, text, showDistance, showHealth)
    if not object or ESPObjects[object] then return end
    
    local BillboardGui = Instance.new("BillboardGui")
    BillboardGui.Parent = object
    BillboardGui.AlwaysOnTop = true
    BillboardGui.Size = UDim2.new(0, 200, 0, 100)
    BillboardGui.StudsOffset = Vector3.new(0, 3, 0)
    
    local Frame = Instance.new("Frame")
    Frame.Parent = BillboardGui
    Frame.BackgroundColor3 = color
    Frame.BackgroundTransparency = 0.8
    Frame.Size = UDim2.new(1, 0, 0, 30)
    Frame.BorderSizePixel = 0
    Frame.Position = UDim2.new(0, 0, 0, 0)
    
    local FrameCorner = Instance.new("UICorner")
    FrameCorner.CornerRadius = UDim.new(0, 6)
    FrameCorner.Parent = Frame
    
    local NameLabel = Instance.new("TextLabel")
    NameLabel.Parent = Frame
    NameLabel.BackgroundTransparency = 1
    NameLabel.Size = UDim2.new(1, 0, 1, 0)
    NameLabel.Font = Enum.Font.GothamBold
    NameLabel.Text = text
    NameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    NameLabel.TextSize = 14
    NameLabel.TextStrokeTransparency = 0.3
    NameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    
    -- Distance Label
    local DistanceLabel
    if showDistance then
        DistanceLabel = Instance.new("TextLabel")
        DistanceLabel.Parent = BillboardGui
        DistanceLabel.BackgroundTransparency = 1
        DistanceLabel.Position = UDim2.new(0, 0, 0, 35)
        DistanceLabel.Size = UDim2.new(1, 0, 0, 20)
        DistanceLabel.Font = Enum.Font.Gotham
        DistanceLabel.Text = "0m"
        DistanceLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        DistanceLabel.TextSize = 12
        DistanceLabel.TextStrokeTransparency = 0.5
    end
    
    -- Health Bar
    local HealthBarBG, HealthBarFill, HealthLabel
    if showHealth then
        HealthBarBG = Instance.new("Frame")
        HealthBarBG.Parent = BillboardGui
        HealthBarBG.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        HealthBarBG.BackgroundTransparency = 0.5
        HealthBarBG.Position = UDim2.new(0, 0, 0, 60)
        HealthBarBG.Size = UDim2.new(1, 0, 0, 8)
        HealthBarBG.BorderSizePixel = 0
        
        local HealthBarCorner = Instance.new("UICorner")
        HealthBarCorner.CornerRadius = UDim.new(1, 0)
        HealthBarCorner.Parent = HealthBarBG
        
        HealthBarFill = Instance.new("Frame")
        HealthBarFill.Parent = HealthBarBG
        HealthBarFill.BackgroundColor3 = Color3.fromRGB(50, 255, 50)
        HealthBarFill.Size = UDim2.new(1, 0, 1, 0)
        HealthBarFill.BorderSizePixel = 0
        
        local HealthFillCorner = Instance.new("UICorner")
        HealthFillCorner.CornerRadius = UDim.new(1, 0)
        HealthFillCorner.Parent = HealthBarFill
        
        HealthLabel = Instance.new("TextLabel")
        HealthLabel.Parent = BillboardGui
        HealthLabel.BackgroundTransparency = 1
        HealthLabel.Position = UDim2.new(0, 0, 0, 70)
        HealthLabel.Size = UDim2.new(1, 0, 0, 20)
        HealthLabel.Font = Enum.Font.Gotham
        HealthLabel.Text = "100%"
        HealthLabel.TextColor3 = Color3.fromRGB(50, 255, 50)
        HealthLabel.TextSize = 11
        HealthLabel.TextStrokeTransparency = 0.5
    end
    
    -- Tracer Line
    local Tracer
    if Config.Player.ESPTracers then
        Tracer = Drawing.new("Line")
        Tracer.Visible = true
        Tracer.Color = Color3.new(color.R, color.G, color.B)
        Tracer.Thickness = 2
        Tracer.Transparency = 0.7
    end
    
    -- Box ESP
    local BoxOutline
    if Config.Player.ESPBoxes then
        BoxOutline = Instance.new("BoxHandleAdornment")
        BoxOutline.Parent = object
        BoxOutline.Size = object.Parent:IsA("Model") and object.Parent:GetExtentsSize() or object.Size
        BoxOutline.Color3 = color
        BoxOutline.Transparency = 0.7
        BoxOutline.AlwaysOnTop = true
        BoxOutline.ZIndex = 1
        BoxOutline.Adornee = object
    end
    
    ESPObjects[object] = {
        Billboard = BillboardGui,
        DistanceLabel = DistanceLabel,
        HealthBarFill = HealthBarFill,
        HealthLabel = HealthLabel,
        Tracer = Tracer,
        BoxOutline = BoxOutline,
        ShowDistance = showDistance,
        ShowHealth = showHealth
    }
    
    -- Update Loop
    task.spawn(function()
        while ESPObjects[object] and object and object.Parent do
            pcall(function()
                -- Update Distance
                if showDistance and DistanceLabel and HumanoidRootPart then
                    local distance = math.floor((HumanoidRootPart.Position - object.Position).Magnitude)
                    DistanceLabel.Text = distance .. "m"
                    
                    -- Color based on distance
                    if distance < 50 then
                        DistanceLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
                    elseif distance < 150 then
                        DistanceLabel.TextColor3 = Color3.fromRGB(255, 255, 100)
                    else
                        DistanceLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
                    end
                end
                
                -- Update Health
                if showHealth and HealthBarFill and HealthLabel then
                    local humanoid = object.Parent:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        local healthPercent = humanoid.Health / humanoid.MaxHealth
                        HealthBarFill.Size = UDim2.new(healthPercent, 0, 1, 0)
                        HealthLabel.Text = math.floor(humanoid.Health) .. "/" .. math.floor(humanoid.MaxHealth)
                        
                        -- Color based on health
                        if healthPercent > 0.6 then
                            HealthBarFill.BackgroundColor3 = Color3.fromRGB(50, 255, 50)
                            HealthLabel.TextColor3 = Color3.fromRGB(50, 255, 50)
                        elseif healthPercent > 0.3 then
                            HealthBarFill.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
                            HealthLabel.TextColor3 = Color3.fromRGB(255, 200, 50)
                        else
                            HealthBarFill.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
                            HealthLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
                        end
                    end
                end
                
                -- Update Tracer
                if Tracer and HumanoidRootPart then
                    local camera = game.Workspace.CurrentCamera
                    local screenPos, onScreen = camera:WorldToViewportPoint(object.Position)
                    local screenCenter = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
                    
                    if onScreen then
                        Tracer.From = screenCenter
                        Tracer.To = Vector2.new(screenPos.X, screenPos.Y)
                        Tracer.Visible = true
                    else
                        Tracer.Visible = false
                    end
                end
            end)
            task.wait(0.1)
        end
    end)
end

local function RemoveESP(object)
    if ESPObjects[object] then
        if ESPObjects[object].Billboard then
            ESPObjects[object].Billboard:Destroy()
        end
        if ESPObjects[object].Tracer then
            ESPObjects[object].Tracer:Remove()
        end
        if ESPObjects[object].BoxOutline then
            ESPObjects[object].BoxOutline:Destroy()
        end
        ESPObjects[object] = nil
    end
end

local function ClearAllESP()
    for object, espData in pairs(ESPObjects) do
        if espData.Billboard then
            espData.Billboard:Destroy()
        end
        if espData.Tracer then
            espData.Tracer:Remove()
        end
        if espData.BoxOutline then
            espData.BoxOutline:Destroy()
        end
    end
    ESPObjects = {}
end

-- Fly System
local function StartFly()
    if _G.FlyConnection then return end
    
    local flySpeed = Config.Movement.FlySpeed
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Parent = HumanoidRootPart
    bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    
    local bodyGyro = Instance.new("BodyGyro")
    bodyGyro.Parent = HumanoidRootPart
    bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    bodyGyro.P = 9e4
    
    _G.FlyConnection = RunService.Heartbeat:Connect(function()
        if not Config.Movement.Fly then
            bodyVelocity:Destroy()
            bodyGyro:Destroy()
            if _G.FlyConnection then
                _G.FlyConnection:Disconnect()
                _G.FlyConnection = nil
            end
            return
        end
        
        local camera = game.Workspace.CurrentCamera
        local moveDirection = Vector3.new(0, 0, 0)
        local userInput = game:GetService("UserInputService")
        
        if userInput:IsKeyDown(Enum.KeyCode.W) then
            moveDirection = moveDirection + camera.CFrame.LookVector
        end
        if userInput:IsKeyDown(Enum.KeyCode.S) then
            moveDirection = moveDirection - camera.CFrame.LookVector
        end
        if userInput:IsKeyDown(Enum.KeyCode.A) then
            moveDirection = moveDirection - camera.CFrame.RightVector
        end
        if userInput:IsKeyDown(Enum.KeyCode.D) then
            moveDirection = moveDirection + camera.CFrame.RightVector
        end
        if userInput:IsKeyDown(Enum.KeyCode.Space) then
            moveDirection = moveDirection + Vector3.new(0, 1, 0)
        end
        if userInput:IsKeyDown(Enum.KeyCode.LeftShift) then
            moveDirection = moveDirection - Vector3.new(0, 1, 0)
        end
        
        bodyVelocity.Velocity = moveDirection * Config.Movement.FlySpeed
        bodyGyro.CFrame = camera.CFrame
    end)
end

-- Core Functions
local function TweenToPosition(position)
    if not HumanoidRootPart then return end
    local distance = (HumanoidRootPart.Position - position).Magnitude
    local speed = Config.Tweening.Speed
    local time = distance / speed
    
    local tween = TweenService:Create(HumanoidRootPart, TweenInfo.new(time, Enum.EasingStyle.Linear), {CFrame = CFrame.new(position)})
    tween:Play()
    return tween
end

local function GetNearestEnemy()
    local nearestEnemy = nil
    local shortestDistance = math.huge
    
    for _, v in pairs(game.Workspace.Enemies:GetChildren()) do
        if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v:FindFirstChild("HumanoidRootPart") then
            local distance = (HumanoidRootPart.Position - v.HumanoidRootPart.Position).Magnitude
            if distance < shortestDistance then
                shortestDistance = distance
                nearestEnemy = v
            end
        end
    end
    
    return nearestEnemy
end

local function AttackEnemy(enemy)
    if not enemy or not enemy:FindFirstChild("HumanoidRootPart") then return end
    
    local enemyPos = enemy.HumanoidRootPart.Position
    HumanoidRootPart.CFrame = CFrame.new(enemyPos + Vector3.new(0, 10, 0))
    
    -- Fast attack implementation
    if Config.Farming.FastAttack then
        for i = 1, 5 do
            game:GetService("VirtualUser"):CaptureController()
            game:GetService("VirtualUser"):ClickButton1(Vector2.new(0, 0))
            task.wait(0.01)
        end
    end
end

-- Main Loop
RunService.Heartbeat:Connect(function()
    pcall(function()
        -- Check if script is enabled
        if not _G.ScriptEnabled then return end
        
        -- Fly System
        if Config.Movement.Fly and not _G.FlyConnection then
            StartFly()
        end
        
        -- Infinite Jump
        if Config.Movement.InfiniteJump then
            game:GetService("UserInputService").JumpRequest:Connect(function()
                if Humanoid then
                    Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
        end
        
        -- ESP Players
        if Config.Player.ESPEnabled then
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= Player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    if not ESPObjects[player.Character.HumanoidRootPart] then
                        CreateESP(player.Character.HumanoidRootPart, Color3.fromRGB(100, 150, 255), player.Name, Config.Player.ESPDistance, Config.Player.ESPHealth)
                    end
                end
            end
        else
            for _, player in pairs(Players:GetPlayers()) do
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    RemoveESP(player.Character.HumanoidRootPart)
                end
            end
        end
        
        -- ESP Enemies
        if Config.Player.ESPEnemies then
            for _, enemy in pairs(game.Workspace.Enemies:GetChildren()) do
                if enemy:FindFirstChild("HumanoidRootPart") then
                    if not ESPObjects[enemy.HumanoidRootPart] then
                        CreateESP(enemy.HumanoidRootPart, Color3.fromRGB(255, 50, 50), enemy.Name, Config.Player.ESPDistance, Config.Player.ESPHealth)
                    end
                end
            end
        else
            for _, enemy in pairs(game.Workspace.Enemies:GetChildren()) do
                if enemy:FindFirstChild("HumanoidRootPart") then
                    RemoveESP(enemy.HumanoidRootPart)
                end
            end
        end
        
        -- ESP Fruits
        if Config.Player.ESPFruits then
            for _, fruit in pairs(game.Workspace:GetChildren()) do
                if string.find(fruit.Name, "Fruit") and fruit:IsA("Tool") and fruit:FindFirstChild("Handle") then
                    if not ESPObjects[fruit.Handle] then
                        CreateESP(fruit.Handle, Color3.fromRGB(255, 200, 50), fruit.Name, Config.Player.ESPDistance, false)
                    end
                end
            end
        else
            for _, fruit in pairs(game.Workspace:GetChildren()) do
                if string.find(fruit.Name, "Fruit") and fruit:IsA("Tool") and fruit:FindFirstChild("Handle") then
                    RemoveESP(fruit.Handle)
                end
            end
        end
        
        -- ESP Chests
        if Config.Player.ESPChests then
            for _, chest in pairs(game.Workspace:GetChildren()) do
                if chest.Name:find("Chest") and chest:FindFirstChild("Root") then
                    if not ESPObjects[chest.Root] then
                        CreateESP(chest.Root, Color3.fromRGB(255, 215, 0), "Chest", Config.Player.ESPDistance, false)
                    end
                end
            end
        else
            for _, chest in pairs(game.Workspace:GetChildren()) do
                if chest.Name:find("Chest") and chest:FindFirstChild("Root") then
                    RemoveESP(chest.Root)
                end
            end
        end
        
        -- Auto Farm
        if Config.Farming.Enabled then
            local enemy = GetNearestEnemy()
            if enemy then
                AttackEnemy(enemy)
            end
        end
        
        -- No Clip
        if Config.Options.NoClip then
            for _, v in pairs(Character:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CanCollide = false
                end
            end
        end
        
        -- Enemy Pulling
        if Config.Pulling.Enabled then
            for _, v in pairs(game.Workspace.Enemies:GetChildren()) do
                if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                    local distance = (HumanoidRootPart.Position - v.HumanoidRootPart.Position).Magnitude
                    if distance <= Config.Pulling.Range then
                        v.HumanoidRootPart.CFrame = HumanoidRootPart.CFrame * CFrame.new(0, 0, -5)
                        v.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
                        v.HumanoidRootPart.CanCollide = false
                    end
                end
            end
        end
        
        -- Auto Collect Fruits
        if Config.Fruit.AutoCollect then
            for _, v in pairs(game.Workspace:GetChildren()) do
                if string.find(v.Name, "Fruit") and v:IsA("Tool") then
                    v.Handle.CFrame = HumanoidRootPart.CFrame
                end
            end
        end
        
        -- Auto Collect Chests
        if Config.Collectable.Chest then
            for _, v in pairs(game.Workspace:GetChildren()) do
                if v.Name:find("Chest") and v:FindFirstChild("Root") then
                    TweenToPosition(v.Root.Position)
                    task.wait(0.5)
                end
            end
        end
    end)
end)

-- Anti AFK
if Config.Options.AntiAFK then
    local VirtualUser = game:GetService("VirtualUser")
    Player.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end

-- Startup Notification
local function CreateNotification(title, text, duration)
    local NotifGui = Instance.new("ScreenGui")
    NotifGui.Name = "Notification"
    NotifGui.Parent = game.CoreGui
    NotifGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    local NotifFrame = Instance.new("Frame")
    NotifFrame.Parent = NotifGui
    NotifFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    NotifFrame.BorderSizePixel = 0
    NotifFrame.Position = UDim2.new(1, 10, 0, 10)
    NotifFrame.Size = UDim2.new(0, 300, 0, 80)
    
    local NotifCorner = Instance.new("UICorner")
    NotifCorner.CornerRadius = UDim.new(0, 10)
    NotifCorner.Parent = NotifFrame
    
    local NotifTitle = Instance.new("TextLabel")
    NotifTitle.Parent = NotifFrame
    NotifTitle.BackgroundTransparency = 1
    NotifTitle.Position = UDim2.new(0, 15, 0, 10)
    NotifTitle.Size = UDim2.new(1, -30, 0, 25)
    NotifTitle.Font = Enum.Font.GothamBold
    NotifTitle.Text = title
    NotifTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    NotifTitle.TextSize = 16
    NotifTitle.TextXAlignment = Enum.TextXAlignment.Left
    
    local NotifText = Instance.new("TextLabel")
    NotifText.Parent = NotifFrame
    NotifText.BackgroundTransparency = 1
    NotifText.Position = UDim2.new(0, 15, 0, 35)
    NotifText.Size = UDim2.new(1, -30, 0, 35)
    NotifText.Font = Enum.Font.Gotham
    NotifText.Text = text
    NotifText.TextColor3 = Color3.fromRGB(200, 200, 200)
    NotifText.TextSize = 13
    NotifText.TextXAlignment = Enum.TextXAlignment.Left
    NotifText.TextWrapped = true
    
    -- Slide in animation
    TweenService:Create(NotifFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(1, -310, 0, 10)
    }):Play()
    
    -- Slide out after duration
    task.wait(duration or 3)
    
    TweenService:Create(NotifFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Position = UDim2.new(1, 10, 0, 10)
    }):Play()
    
    task.wait(0.3)
    NotifGui:Destroy()
end

CreateNotification("Blox Fruits Hub", "Script loaded! Press RightShift to toggle GUI", 5)
print("=================================")
print("Blox Fruits Hub loaded successfully!")
print("Press RightShift to toggle GUI")
print("Enable script in Options tab to start")
print("=================================")