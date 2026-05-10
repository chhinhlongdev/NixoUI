-- NixoUI Library v1.0
-- Professional UI Library for Roblox Scripts
-- Usage: local NixoUI = loadstring(game:HttpGet('YOUR_URL_HERE'))()

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local NixoUI = {}
NixoUI.__index = NixoUI

-- Create Window
function NixoUI:CreateWindow(config)
    local Window = {
        Name = config.Name or "NixoUI",
        LoadingTitle = config.LoadingTitle or "Loading",
        LoadingSubtitle = config.LoadingSubtitle or "Please wait...",
        ConfigurationSaving = config.ConfigurationSaving or {Enabled = false},
        Tabs = {},
        CurrentTab = nil
    }
    
    -- Create ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "NixoUI"
    ScreenGui.Parent = game.CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    
    -- Loading Screen
    local LoadingFrame = Instance.new("Frame")
    LoadingFrame.Name = "LoadingFrame"
    LoadingFrame.Parent = ScreenGui
    LoadingFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    LoadingFrame.BorderSizePixel = 0
    LoadingFrame.Position = UDim2.new(0.5, -250, 0.5, -150)
    LoadingFrame.Size = UDim2.new(0, 500, 0, 300)
    
    local LoadingCorner = Instance.new("UICorner")
    LoadingCorner.CornerRadius = UDim.new(0, 15)
    LoadingCorner.Parent = LoadingFrame
    
    -- Animated Loader (Rotating Circle)
    local LoaderContainer = Instance.new("Frame")
    LoaderContainer.Parent = LoadingFrame
    LoaderContainer.BackgroundTransparency = 1
    LoaderContainer.Position = UDim2.new(0.5, -60, 0, 30)
    LoaderContainer.Size = UDim2.new(0, 120, 0, 120)
    
    -- Create spinning circle effect
    local LoaderCircle = Instance.new("ImageLabel")
    LoaderCircle.Parent = LoaderContainer
    LoaderCircle.BackgroundTransparency = 1
    LoaderCircle.Size = UDim2.new(1, 0, 1, 0)
    LoaderCircle.Image = "rbxassetid://129020368373872"
    LoaderCircle.ImageColor3 = Color3.fromRGB(100, 150, 255)
    
    -- Rotation animation
    local rotationAngle = 0
    local rotationConnection
    rotationConnection = RunService.RenderStepped:Connect(function()
        rotationAngle = rotationAngle + 5
        LoaderCircle.Rotation = rotationAngle
        if not LoadingFrame or not LoadingFrame.Parent then
            rotationConnection:Disconnect()
        end
    end)
    
    local LoadingTitle = Instance.new("TextLabel")
    LoadingTitle.Parent = LoadingFrame
    LoadingTitle.BackgroundTransparency = 1
    LoadingTitle.Position = UDim2.new(0, 0, 0, 160)
    LoadingTitle.Size = UDim2.new(1, 0, 0, 40)
    LoadingTitle.Font = Enum.Font.GothamBold
    LoadingTitle.Text = Window.LoadingTitle
    LoadingTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    LoadingTitle.TextSize = 24
    
    local LoadingSubtitle = Instance.new("TextLabel")
    LoadingSubtitle.Parent = LoadingFrame
    LoadingSubtitle.BackgroundTransparency = 1
    LoadingSubtitle.Position = UDim2.new(0, 0, 0, 205)
    LoadingSubtitle.Size = UDim2.new(1, 0, 0, 25)
    LoadingSubtitle.Font = Enum.Font.Gotham
    LoadingSubtitle.Text = Window.LoadingSubtitle
    LoadingSubtitle.TextColor3 = Color3.fromRGB(200, 200, 200)
    LoadingSubtitle.TextSize = 14
    
    local LoadingBar = Instance.new("Frame")
    LoadingBar.Parent = LoadingFrame
    LoadingBar.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    LoadingBar.Position = UDim2.new(0.1, 0, 0, 250)
    LoadingBar.Size = UDim2.new(0.8, 0, 0, 8)
    
    local BarCorner = Instance.new("UICorner")
    BarCorner.CornerRadius = UDim.new(1, 0)
    BarCorner.Parent = LoadingBar
    
    local LoadingFill = Instance.new("Frame")
    LoadingFill.Parent = LoadingBar
    LoadingFill.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    LoadingFill.Size = UDim2.new(0, 0, 1, 0)
    
    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(1, 0)
    FillCorner.Parent = LoadingFill
    
    -- Percentage Label
    local PercentLabel = Instance.new("TextLabel")
    PercentLabel.Parent = LoadingFrame
    PercentLabel.BackgroundTransparency = 1
    PercentLabel.Position = UDim2.new(0, 0, 0, 265)
    PercentLabel.Size = UDim2.new(1, 0, 0, 20)
    PercentLabel.Font = Enum.Font.GothamBold
    PercentLabel.Text = "0%"
    PercentLabel.TextColor3 = Color3.fromRGB(100, 150, 255)
    PercentLabel.TextSize = 13
    
    -- Animate Loading with percentage
    local loadingDuration = 5
    local startTime = tick()
    
    local loadingConnection
    loadingConnection = RunService.RenderStepped:Connect(function()
        local elapsed = tick() - startTime
        local progress = math.min(elapsed / loadingDuration, 1)
        local percentage = math.floor(progress * 100)
        
        LoadingFill.Size = UDim2.new(progress, 0, 1, 0)
        PercentLabel.Text = percentage .. "%"
        
        if progress >= 1 then
            loadingConnection:Disconnect()
        end
    end)
    
    task.wait(loadingDuration)
    
    -- Fade out loading screen
    if rotationConnection then
        rotationConnection:Disconnect()
    end
    
    TweenService:Create(LoadingFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {
        BackgroundTransparency = 1
    }):Play()
    TweenService:Create(LoaderCircle, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {
        ImageTransparency = 1
    }):Play()
    TweenService:Create(LoadingTitle, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {
        TextTransparency = 1
    }):Play()
    TweenService:Create(LoadingSubtitle, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {
        TextTransparency = 1
    }):Play()
    TweenService:Create(PercentLabel, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {
        TextTransparency = 1
    }):Play()
    
    task.wait(0.5)
    LoadingFrame:Destroy()
    
    -- Welcome Notification
    local WelcomeNotification = Instance.new("Frame")
    WelcomeNotification.Name = "WelcomeNotification"
    WelcomeNotification.Parent = ScreenGui
    WelcomeNotification.BackgroundColor3 = Color3.fromRGB(45, 120, 255)
    WelcomeNotification.BorderSizePixel = 0
    WelcomeNotification.Position = UDim2.new(1, 20, 0, 20)
    WelcomeNotification.Size = UDim2.new(0, 350, 0, 100)
    WelcomeNotification.AnchorPoint = Vector2.new(1, 0)
    
    local NotifCorner = Instance.new("UICorner")
    NotifCorner.CornerRadius = UDim.new(0, 10)
    NotifCorner.Parent = WelcomeNotification
    
    local NotifStroke = Instance.new("UIStroke")
    NotifStroke.Color = Color3.fromRGB(65, 140, 255)
    NotifStroke.Thickness = 2
    NotifStroke.Parent = WelcomeNotification
    
    local NotifIcon = Instance.new("TextLabel")
    NotifIcon.Parent = WelcomeNotification
    NotifIcon.BackgroundTransparency = 1
    NotifIcon.Position = UDim2.new(0, 15, 0, 15)
    NotifIcon.Size = UDim2.new(0, 40, 0, 40)
    NotifIcon.Font = Enum.Font.GothamBold
    NotifIcon.Text = "👋"
    NotifIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
    NotifIcon.TextSize = 32
    
    local NotifTitle = Instance.new("TextLabel")
    NotifTitle.Parent = WelcomeNotification
    NotifTitle.BackgroundTransparency = 1
    NotifTitle.Position = UDim2.new(0, 65, 0, 15)
    NotifTitle.Size = UDim2.new(1, -80, 0, 25)
    NotifTitle.Font = Enum.Font.GothamBold
    NotifTitle.Text = "Welcome to " .. Window.Name
    NotifTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    NotifTitle.TextSize = 16
    NotifTitle.TextXAlignment = Enum.TextXAlignment.Left
    
    local NotifMessage = Instance.new("TextLabel")
    NotifMessage.Parent = WelcomeNotification
    NotifMessage.BackgroundTransparency = 1
    NotifMessage.Position = UDim2.new(0, 65, 0, 42)
    NotifMessage.Size = UDim2.new(1, -80, 0, 45)
    NotifMessage.Font = Enum.Font.Gotham
    NotifMessage.Text = "Script loaded successfully!\nEnjoy using the features."
    NotifMessage.TextColor3 = Color3.fromRGB(220, 220, 220)
    NotifMessage.TextSize = 13
    NotifMessage.TextXAlignment = Enum.TextXAlignment.Left
    NotifMessage.TextYAlignment = Enum.TextYAlignment.Top
    NotifMessage.TextWrapped = true
    
    local NotifProgress = Instance.new("Frame")
    NotifProgress.Parent = WelcomeNotification
    NotifProgress.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NotifProgress.BackgroundTransparency = 0.7
    NotifProgress.BorderSizePixel = 0
    NotifProgress.Position = UDim2.new(0, 0, 1, -3)
    NotifProgress.Size = UDim2.new(1, 0, 0, 3)
    
    -- Slide in animation
    WelcomeNotification.Position = UDim2.new(1, 20, 0, 20)
    TweenService:Create(WelcomeNotification, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(1, -20, 0, 20)
    }):Play()
    
    -- Progress bar animation
    task.spawn(function()
        task.wait(0.5)
        TweenService:Create(NotifProgress, TweenInfo.new(4, Enum.EasingStyle.Linear), {
            Size = UDim2.new(0, 0, 0, 3)
        }):Play()
    end)
    
    -- Auto dismiss after 4.5 seconds
    task.spawn(function()
        task.wait(4.5)
        TweenService:Create(WelcomeNotification, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Position = UDim2.new(1, 20, 0, 20)
        }):Play()
        task.wait(0.3)
        WelcomeNotification:Destroy()
    end)
    
    -- Main Window
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(0.5, -450, 0.5, -300)
    MainFrame.Size = UDim2.new(0, 900, 0, 600)
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.ClipsDescendants = true
    
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 10)
    MainCorner.Parent = MainFrame

    
    -- Title Bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Parent = MainFrame
    TitleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    TitleBar.BorderSizePixel = 0
    TitleBar.Size = UDim2.new(1, 0, 0, 60)
    
    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 10)
    TitleCorner.Parent = TitleBar
    
    -- Title Container
    local TitleContainer = Instance.new("Frame")
    TitleContainer.Parent = TitleBar
    TitleContainer.BackgroundTransparency = 1
    TitleContainer.Position = UDim2.new(0, 260, 0, 0)
    TitleContainer.Size = UDim2.new(1, -380, 1, 0)
    
    local Title = Instance.new("TextLabel")
    Title.Parent = TitleContainer
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 0, 0, 8)
    Title.Size = UDim2.new(1, 0, 0, 22)
    Title.Font = Enum.Font.GothamBold
    Title.Text = Window.Name
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 16
    Title.TextXAlignment = Enum.TextXAlignment.Left
    
    local Subtitle = Instance.new("TextLabel")
    Subtitle.Parent = TitleContainer
    Subtitle.BackgroundTransparency = 1
    Subtitle.Position = UDim2.new(0, 0, 0, 32)
    Subtitle.Size = UDim2.new(1, 0, 0, 18)
    Subtitle.Font = Enum.Font.Gotham
    Subtitle.Text = "Made by vitasit"
    Subtitle.TextColor3 = Color3.fromRGB(150, 150, 150)
    Subtitle.TextSize = 12
    Subtitle.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Window Control Buttons (macOS style)
    local ControlsFrame = Instance.new("Frame")
    ControlsFrame.Parent = TitleBar
    ControlsFrame.BackgroundTransparency = 1
    ControlsFrame.Position = UDim2.new(0, 20, 0, 20)
    ControlsFrame.Size = UDim2.new(0, 60, 0, 20)
    
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Parent = ControlsFrame
    CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 95, 87)
    CloseBtn.Position = UDim2.new(0, 0, 0, 0)
    CloseBtn.Size = UDim2.new(0, 12, 0, 12)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.Text = ""
    CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.TextSize = 10
    CloseBtn.AutoButtonColor = false
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(1, 0)
    CloseCorner.Parent = CloseBtn
    
    local MinimizeBtn = Instance.new("TextButton")
    MinimizeBtn.Parent = ControlsFrame
    MinimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 189, 46)
    MinimizeBtn.Position = UDim2.new(0, 24, 0, 0)
    MinimizeBtn.Size = UDim2.new(0, 12, 0, 12)
    MinimizeBtn.Font = Enum.Font.GothamBold
    MinimizeBtn.Text = ""
    MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinimizeBtn.TextSize = 10
    MinimizeBtn.AutoButtonColor = false
    
    local MinCorner = Instance.new("UICorner")
    MinCorner.CornerRadius = UDim.new(1, 0)
    MinCorner.Parent = MinimizeBtn
    
    local MaximizeBtn = Instance.new("TextButton")
    MaximizeBtn.Parent = ControlsFrame
    MaximizeBtn.BackgroundColor3 = Color3.fromRGB(40, 201, 64)
    MaximizeBtn.Position = UDim2.new(0, 48, 0, 0)
    MaximizeBtn.Size = UDim2.new(0, 12, 0, 12)
    MaximizeBtn.Font = Enum.Font.GothamBold
    MaximizeBtn.Text = ""
    MaximizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    MaximizeBtn.TextSize = 10
    MaximizeBtn.AutoButtonColor = false
    
    local MaxCorner = Instance.new("UICorner")
    MaxCorner.CornerRadius = UDim.new(1, 0)
    MaxCorner.Parent = MaximizeBtn
    
    -- Search Bar
    local SearchFrame = Instance.new("Frame")
    SearchFrame.Parent = TitleBar
    SearchFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    SearchFrame.Position = UDim2.new(1, -280, 0.5, -15)
    SearchFrame.Size = UDim2.new(0, 250, 0, 30)
    
    local SearchCorner = Instance.new("UICorner")
    SearchCorner.CornerRadius = UDim.new(0, 6)
    SearchCorner.Parent = SearchFrame
    
    local SearchIcon = Instance.new("TextLabel")
    SearchIcon.Parent = SearchFrame
    SearchIcon.BackgroundTransparency = 1
    SearchIcon.Position = UDim2.new(0, 10, 0, 0)
    SearchIcon.Size = UDim2.new(0, 30, 1, 0)
    SearchIcon.Font = Enum.Font.GothamBold
    SearchIcon.Text = "🔍"
    SearchIcon.TextColor3 = Color3.fromRGB(150, 150, 150)
    SearchIcon.TextSize = 14
    
    local SearchBox = Instance.new("TextBox")
    SearchBox.Parent = SearchFrame
    SearchBox.BackgroundTransparency = 1
    SearchBox.Position = UDim2.new(0, 40, 0, 0)
    SearchBox.Size = UDim2.new(1, -50, 1, 0)
    SearchBox.Font = Enum.Font.Gotham
    SearchBox.PlaceholderText = "Search"
    SearchBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
    SearchBox.Text = ""
    SearchBox.TextColor3 = Color3.fromRGB(200, 200, 200)
    SearchBox.TextSize = 13
    SearchBox.TextXAlignment = Enum.TextXAlignment.Left

    
    -- Minimized Icon
    local MinimizedIcon = Instance.new("ImageButton")
    MinimizedIcon.Parent = ScreenGui
    MinimizedIcon.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    MinimizedIcon.Position = UDim2.new(0, 10, 1, -60)
    MinimizedIcon.Size = UDim2.new(0, 50, 0, 50)
    MinimizedIcon.Image = "rbxassetid://132707178183356"
    MinimizedIcon.ScaleType = Enum.ScaleType.Fit
    MinimizedIcon.Visible = false
    MinimizedIcon.AutoButtonColor = false
    
    local IconCorner = Instance.new("UICorner")
    IconCorner.CornerRadius = UDim.new(0, 12)
    IconCorner.Parent = MinimizedIcon
    
    -- Icon hover effect
    MinimizedIcon.MouseEnter:Connect(function()
        TweenService:Create(MinimizedIcon, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0, 55, 0, 55),
            BackgroundColor3 = Color3.fromRGB(120, 170, 255)
        }):Play()
    end)
    
    MinimizedIcon.MouseLeave:Connect(function()
        TweenService:Create(MinimizedIcon, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0, 50, 0, 50),
            BackgroundColor3 = Color3.fromRGB(100, 150, 255)
        }):Play()
    end)
    
    -- Sidebar Navigation
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Parent = MainFrame
    Sidebar.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
    Sidebar.BorderSizePixel = 0
    Sidebar.Position = UDim2.new(0, 0, 0, 60)
    Sidebar.Size = UDim2.new(0, 240, 1, -60)
    
    local SidebarCorner = Instance.new("UICorner")
    SidebarCorner.CornerRadius = UDim.new(0, 0)
    SidebarCorner.Parent = Sidebar
    
    local SidebarScroll = Instance.new("ScrollingFrame")
    SidebarScroll.Parent = Sidebar
    SidebarScroll.BackgroundTransparency = 1
    SidebarScroll.BorderSizePixel = 0
    SidebarScroll.Size = UDim2.new(1, 0, 1, 0)
    SidebarScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    SidebarScroll.ScrollBarThickness = 4
    SidebarScroll.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 60)
    SidebarScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    
    local SidebarLayout = Instance.new("UIListLayout")
    SidebarLayout.Parent = SidebarScroll
    SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SidebarLayout.Padding = UDim.new(0, 2)
    
    local SidebarPadding = Instance.new("UIPadding")
    SidebarPadding.Parent = SidebarScroll
    SidebarPadding.PaddingTop = UDim.new(0, 10)
    SidebarPadding.PaddingBottom = UDim.new(0, 10)
    SidebarPadding.PaddingLeft = UDim.new(0, 10)
    SidebarPadding.PaddingRight = UDim.new(0, 10)
    
    -- Content Container
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Parent = MainFrame
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Position = UDim2.new(0, 240, 0, 60)
    ContentContainer.Size = UDim2.new(1, -240, 1, -60)

    
    -- Button Interactions
    local isMinimized = false
    local isMaximized = false
    local originalSize = UDim2.new(0, 900, 0, 600)
    local originalPosition = UDim2.new(0.5, -450, 0.5, -300)
    
    MinimizeBtn.MouseButton1Click:Connect(function()
        if not isMinimized then
            -- Minimize window
            isMinimized = true
            TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                Size = UDim2.new(0, 0, 0, 0)
            }):Play()
            task.wait(0.3)
            MainFrame.Visible = false
            MinimizedIcon.Visible = true
            TweenService:Create(MinimizedIcon, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 50, 0, 50)
            }):Play()
        end
    end)
    
    MinimizedIcon.MouseButton1Click:Connect(function()
        if isMinimized then
            -- Restore from minimize
            isMinimized = false
            MinimizedIcon.Visible = false
            MainFrame.Visible = true
            MainFrame.Size = UDim2.new(0, 0, 0, 0)
            TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = isMaximized and UDim2.new(0, 1200, 0, 700) or originalSize
            }):Play()
        end
    end)
    
    MaximizeBtn.MouseButton1Click:Connect(function()
        if not isMaximized then
            -- Maximize window
            isMaximized = true
            TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 1200, 0, 700),
                Position = UDim2.new(0.5, -600, 0.5, -350)
            }):Play()
        else
            -- Restore to original size
            isMaximized = false
            TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = originalSize,
                Position = originalPosition
            }):Play()
        end
    end)
    
    CloseBtn.MouseButton1Click:Connect(function()
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0)
        }):Play()
        TweenService:Create(MinimizedIcon, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0)
        }):Play()
        task.wait(0.3)
        ScreenGui:Destroy()
    end)
    
    -- Hover Effects
    CloseBtn.MouseEnter:Connect(function()
        TweenService:Create(CloseBtn, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(255, 115, 107),
            Size = UDim2.new(0, 13, 0, 13)
        }):Play()
        CloseBtn.Text = "×"
        CloseBtn.TextSize = 12
    end)
    CloseBtn.MouseLeave:Connect(function()
        TweenService:Create(CloseBtn, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(255, 95, 87),
            Size = UDim2.new(0, 12, 0, 12)
        }):Play()
        CloseBtn.Text = ""
    end)
    
    MinimizeBtn.MouseEnter:Connect(function()
        TweenService:Create(MinimizeBtn, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(255, 209, 66),
            Size = UDim2.new(0, 13, 0, 13)
        }):Play()
        MinimizeBtn.Text = "−"
        MinimizeBtn.TextSize = 12
    end)
    MinimizeBtn.MouseLeave:Connect(function()
        TweenService:Create(MinimizeBtn, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(255, 189, 46),
            Size = UDim2.new(0, 12, 0, 12)
        }):Play()
        MinimizeBtn.Text = ""
    end)
    
    MaximizeBtn.MouseEnter:Connect(function()
        TweenService:Create(MaximizeBtn, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(60, 221, 84),
            Size = UDim2.new(0, 13, 0, 13)
        }):Play()
        MaximizeBtn.Text = isMaximized and "◱" or "◻"
        MaximizeBtn.TextSize = 10
    end)
    MaximizeBtn.MouseLeave:Connect(function()
        TweenService:Create(MaximizeBtn, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(40, 201, 64),
            Size = UDim2.new(0, 12, 0, 12)
        }):Play()
        MaximizeBtn.Text = ""
    end)
    
    -- Create Tab Function
    function Window:CreateTab(config)
        local Tab = {
            Name = config.Name or "Tab",
            Icon = config.Icon or "📄",
            Elements = {}
        }
        
        local TabButton = Instance.new("TextButton")
        TabButton.Name = Tab.Name
        TabButton.Parent = SidebarScroll
        TabButton.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
        TabButton.Size = UDim2.new(1, 0, 0, 42)
        TabButton.Font = Enum.Font.Gotham
        TabButton.Text = ""
        TabButton.TextColor3 = Color3.fromRGB(180, 180, 180)
        TabButton.TextSize = 14
        TabButton.AutoButtonColor = false
        
        local TabBtnCorner = Instance.new("UICorner")
        TabBtnCorner.CornerRadius = UDim.new(0, 6)
        TabBtnCorner.Parent = TabButton
        
        local IconLabel = Instance.new("TextLabel")
        IconLabel.Parent = TabButton
        IconLabel.BackgroundTransparency = 1
        IconLabel.Position = UDim2.new(0, 12, 0, 0)
        IconLabel.Size = UDim2.new(0, 30, 1, 0)
        IconLabel.Font = Enum.Font.GothamBold
        IconLabel.Text = Tab.Icon
        IconLabel.TextColor3 = Color3.fromRGB(100, 150, 255)
        IconLabel.TextSize = 16
        IconLabel.TextXAlignment = Enum.TextXAlignment.Left
        
        local TextLabel = Instance.new("TextLabel")
        TextLabel.Parent = TabButton
        TextLabel.BackgroundTransparency = 1
        TextLabel.Position = UDim2.new(0, 45, 0, 0)
        TextLabel.Size = UDim2.new(1, -50, 1, 0)
        TextLabel.Font = Enum.Font.Gotham
        TextLabel.Text = Tab.Name
        TextLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
        TextLabel.TextSize = 14
        TextLabel.TextXAlignment = Enum.TextXAlignment.Left

        
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = Tab.Name .. "Content"
        TabContent.Parent = ContentContainer
        TabContent.BackgroundTransparency = 1
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabContent.ScrollBarThickness = 6
        TabContent.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 60)
        TabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
        TabContent.Visible = false
        TabContent.BorderSizePixel = 0
        
        local ContentLayout = Instance.new("UIListLayout")
        ContentLayout.Parent = TabContent
        ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ContentLayout.Padding = UDim.new(0, 12)
        
        local ContentPadding = Instance.new("UIPadding")
        ContentPadding.Parent = TabContent
        ContentPadding.PaddingLeft = UDim.new(0, 20)
        ContentPadding.PaddingRight = UDim.new(0, 20)
        ContentPadding.PaddingTop = UDim.new(0, 20)
        ContentPadding.PaddingBottom = UDim.new(0, 20)
        
        TabButton.MouseButton1Click:Connect(function()
            for _, tab in pairs(Window.Tabs) do
                tab.Content.Visible = false
                TweenService:Create(tab.Button, TweenInfo.new(0.2), {
                    BackgroundColor3 = Color3.fromRGB(28, 28, 28)
                }):Play()
                tab.Button:FindFirstChild("TextLabel").TextColor3 = Color3.fromRGB(180, 180, 180)
                tab.Button:FindFirstChild("IconLabel").TextColor3 = Color3.fromRGB(100, 150, 255)
            end
            TabContent.Visible = true
            TweenService:Create(TabButton, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(45, 120, 255)
            }):Play()
            TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            IconLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            Window.CurrentTab = Tab
        end)
        
        TabButton.MouseEnter:Connect(function()
            if TabContent.Visible == false then
                TweenService:Create(TabButton, TweenInfo.new(0.15), {
                    BackgroundColor3 = Color3.fromRGB(38, 38, 38)
                }):Play()
            end
        end)
        
        TabButton.MouseLeave:Connect(function()
            if TabContent.Visible == false then
                TweenService:Create(TabButton, TweenInfo.new(0.15), {
                    BackgroundColor3 = Color3.fromRGB(28, 28, 28)
                }):Play()
            end
        end)
        
        Tab.Button = TabButton
        Tab.Content = TabContent
        Tab.IconLabel = IconLabel
        Tab.TextLabel = TextLabel
        table.insert(Window.Tabs, Tab)
        
        if #Window.Tabs == 1 then
            TabButton.BackgroundColor3 = Color3.fromRGB(45, 120, 255)
            TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            IconLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            TabContent.Visible = true
            Window.CurrentTab = Tab
        end

        
        -- Create Toggle
        function Tab:CreateToggle(config)
            local Toggle = Instance.new("Frame")
            Toggle.Parent = TabContent
            Toggle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            Toggle.Size = UDim2.new(1, 0, 0, 55)
            
            local ToggleCorner = Instance.new("UICorner")
            ToggleCorner.CornerRadius = UDim.new(0, 8)
            ToggleCorner.Parent = Toggle
            
            local TitleLabel = Instance.new("TextLabel")
            TitleLabel.Parent = Toggle
            TitleLabel.BackgroundTransparency = 1
            TitleLabel.Position = UDim2.new(0, 15, 0, 8)
            TitleLabel.Size = UDim2.new(1, -80, 0, 18)
            TitleLabel.Font = Enum.Font.GothamMedium
            TitleLabel.Text = config.Name or "Toggle"
            TitleLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
            TitleLabel.TextSize = 14
            TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
            
            local DescLabel = Instance.new("TextLabel")
            DescLabel.Parent = Toggle
            DescLabel.BackgroundTransparency = 1
            DescLabel.Position = UDim2.new(0, 15, 0, 28)
            DescLabel.Size = UDim2.new(1, -80, 0, 16)
            DescLabel.Font = Enum.Font.Gotham
            DescLabel.Text = config.Description or ""
            DescLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
            DescLabel.TextSize = 11
            DescLabel.TextXAlignment = Enum.TextXAlignment.Left
            
            local ToggleBtn = Instance.new("TextButton")
            ToggleBtn.Parent = Toggle
            ToggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            ToggleBtn.Position = UDim2.new(1, -55, 0.5, -12)
            ToggleBtn.Size = UDim2.new(0, 45, 0, 24)
            ToggleBtn.Text = ""
            ToggleBtn.AutoButtonColor = false
            
            local BtnCorner = Instance.new("UICorner")
            BtnCorner.CornerRadius = UDim.new(1, 0)
            BtnCorner.Parent = ToggleBtn
            
            local Indicator = Instance.new("Frame")
            Indicator.Parent = ToggleBtn
            Indicator.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
            Indicator.Position = UDim2.new(0, 3, 0.5, -9)
            Indicator.Size = UDim2.new(0, 18, 0, 18)
            
            local IndCorner = Instance.new("UICorner")
            IndCorner.CornerRadius = UDim.new(1, 0)
            IndCorner.Parent = Indicator
            
            local state = config.Default or false
            if state then
                ToggleBtn.BackgroundColor3 = Color3.fromRGB(45, 120, 255)
                Indicator.Position = UDim2.new(1, -21, 0.5, -9)
            end
            
            ToggleBtn.MouseButton1Click:Connect(function()
                state = not state
                TweenService:Create(ToggleBtn, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
                    BackgroundColor3 = state and Color3.fromRGB(45, 120, 255) or Color3.fromRGB(60, 60, 60)
                }):Play()
                TweenService:Create(Indicator, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
                    Position = state and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
                }):Play()
                if config.Callback then
                    config.Callback(state)
                end
            end)
            
            return Toggle
        end

        
        -- Create Button
        function Tab:CreateButton(config)
            local Button = Instance.new("TextButton")
            Button.Parent = TabContent
            Button.BackgroundColor3 = Color3.fromRGB(45, 120, 255)
            Button.Size = UDim2.new(1, 0, 0, 45)
            Button.Font = Enum.Font.GothamBold
            Button.Text = config.Name or "Button"
            Button.TextColor3 = Color3.fromRGB(255, 255, 255)
            Button.TextSize = 14
            Button.AutoButtonColor = false
            
            local BtnCorner = Instance.new("UICorner")
            BtnCorner.CornerRadius = UDim.new(0, 8)
            BtnCorner.Parent = Button
            
            Button.MouseButton1Click:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.1), {Size = UDim2.new(1, 0, 0, 42)}):Play()
                task.wait(0.1)
                TweenService:Create(Button, TweenInfo.new(0.1), {Size = UDim2.new(1, 0, 0, 45)}):Play()
                if config.Callback then
                    config.Callback()
                end
            end)
            
            Button.MouseEnter:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(65, 140, 255)}):Play()
            end)
            
            Button.MouseLeave:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 120, 255)}):Play()
            end)
            
            return Button
        end
        
        -- Create Slider
        function Tab:CreateSlider(config)
            local Slider = Instance.new("Frame")
            Slider.Parent = TabContent
            Slider.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            Slider.Size = UDim2.new(1, 0, 0, 70)
            
            local SliderCorner = Instance.new("UICorner")
            SliderCorner.CornerRadius = UDim.new(0, 8)
            SliderCorner.Parent = Slider
            
            local TitleLabel = Instance.new("TextLabel")
            TitleLabel.Parent = Slider
            TitleLabel.BackgroundTransparency = 1
            TitleLabel.Position = UDim2.new(0, 15, 0, 8)
            TitleLabel.Size = UDim2.new(1, -80, 0, 18)
            TitleLabel.Font = Enum.Font.GothamMedium
            TitleLabel.Text = config.Name or "Slider"
            TitleLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
            TitleLabel.TextSize = 14
            TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
            
            local DescLabel = Instance.new("TextLabel")
            DescLabel.Parent = Slider
            DescLabel.BackgroundTransparency = 1
            DescLabel.Position = UDim2.new(0, 15, 0, 28)
            DescLabel.Size = UDim2.new(1, -80, 0, 16)
            DescLabel.Font = Enum.Font.Gotham
            DescLabel.Text = config.Description or ""
            DescLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
            DescLabel.TextSize = 11
            DescLabel.TextXAlignment = Enum.TextXAlignment.Left
            
            local ValueLabel = Instance.new("TextLabel")
            ValueLabel.Parent = Slider
            ValueLabel.BackgroundTransparency = 1
            ValueLabel.Position = UDim2.new(1, -70, 0, 8)
            ValueLabel.Size = UDim2.new(0, 60, 0, 18)
            ValueLabel.Font = Enum.Font.GothamBold
            ValueLabel.Text = tostring(config.Default or 0)
            ValueLabel.TextColor3 = Color3.fromRGB(45, 120, 255)
            ValueLabel.TextSize = 14
            ValueLabel.TextXAlignment = Enum.TextXAlignment.Right

            
            local SliderBar = Instance.new("Frame")
            SliderBar.Parent = Slider
            SliderBar.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
            SliderBar.Position = UDim2.new(0, 15, 1, -18)
            SliderBar.Size = UDim2.new(1, -30, 0, 6)
            
            local BarCorner = Instance.new("UICorner")
            BarCorner.CornerRadius = UDim.new(1, 0)
            BarCorner.Parent = SliderBar
            
            local Fill = Instance.new("Frame")
            Fill.Parent = SliderBar
            Fill.BackgroundColor3 = Color3.fromRGB(45, 120, 255)
            local percent = ((config.Default or 0) - (config.Min or 0)) / ((config.Max or 100) - (config.Min or 0))
            Fill.Size = UDim2.new(percent, 0, 1, 0)
            
            local FillCorner = Instance.new("UICorner")
            FillCorner.CornerRadius = UDim.new(1, 0)
            FillCorner.Parent = Fill
            
            local SliderBtn = Instance.new("TextButton")
            SliderBtn.Parent = SliderBar
            SliderBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            SliderBtn.Position = UDim2.new(percent, -8, 0.5, -8)
            SliderBtn.Size = UDim2.new(0, 16, 0, 16)
            SliderBtn.Text = ""
            SliderBtn.AutoButtonColor = false
            
            local BtnCorner = Instance.new("UICorner")
            BtnCorner.CornerRadius = UDim.new(1, 0)
            BtnCorner.Parent = SliderBtn
            
            local dragging = false
            
            SliderBtn.MouseButton1Down:Connect(function()
                dragging = true
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            
            RunService.RenderStepped:Connect(function()
                if dragging then
                    local mouse = game.Players.LocalPlayer:GetMouse()
                    local percent = math.clamp((mouse.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
                    local value = math.floor((config.Min or 0) + ((config.Max or 100) - (config.Min or 0)) * percent)
                    
                    ValueLabel.Text = tostring(value)
                    TweenService:Create(Fill, TweenInfo.new(0.1), {Size = UDim2.new(percent, 0, 1, 0)}):Play()
                    TweenService:Create(SliderBtn, TweenInfo.new(0.1), {Position = UDim2.new(percent, -8, 0.5, -8)}):Play()
                    
                    if config.Callback then
                        config.Callback(value)
                    end
                end
            end)
            
            return Slider
        end

        
        -- Create Dropdown
        function Tab:CreateDropdown(config)
            local Dropdown = Instance.new("Frame")
            Dropdown.Parent = TabContent
            Dropdown.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            Dropdown.Size = UDim2.new(1, 0, 0, 55)
            
            local DropCorner = Instance.new("UICorner")
            DropCorner.CornerRadius = UDim.new(0, 8)
            DropCorner.Parent = Dropdown
            
            local TitleLabel = Instance.new("TextLabel")
            TitleLabel.Parent = Dropdown
            TitleLabel.BackgroundTransparency = 1
            TitleLabel.Position = UDim2.new(0, 15, 0, 8)
            TitleLabel.Size = UDim2.new(0.4, 0, 0, 18)
            TitleLabel.Font = Enum.Font.GothamMedium
            TitleLabel.Text = config.Name or "Dropdown"
            TitleLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
            TitleLabel.TextSize = 14
            TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
            
            local DescLabel = Instance.new("TextLabel")
            DescLabel.Parent = Dropdown
            DescLabel.BackgroundTransparency = 1
            DescLabel.Position = UDim2.new(0, 15, 0, 28)
            DescLabel.Size = UDim2.new(0.4, 0, 0, 16)
            DescLabel.Font = Enum.Font.Gotham
            DescLabel.Text = config.Description or ""
            DescLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
            DescLabel.TextSize = 11
            DescLabel.TextXAlignment = Enum.TextXAlignment.Left
            
            local DropBtn = Instance.new("TextButton")
            DropBtn.Parent = Dropdown
            DropBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            DropBtn.Position = UDim2.new(0.5, 5, 0.5, -15)
            DropBtn.Size = UDim2.new(0.5, -20, 0, 32)
            DropBtn.Font = Enum.Font.Gotham
            DropBtn.Text = (config.Options and config.Options[1]) or "Select"
            DropBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
            DropBtn.TextSize = 13
            DropBtn.AutoButtonColor = false
            
            local BtnCorner = Instance.new("UICorner")
            BtnCorner.CornerRadius = UDim.new(0, 6)
            BtnCorner.Parent = DropBtn
            
            local DropIcon = Instance.new("TextLabel")
            DropIcon.Parent = DropBtn
            DropIcon.BackgroundTransparency = 1
            DropIcon.Position = UDim2.new(1, -25, 0, 0)
            DropIcon.Size = UDim2.new(0, 20, 1, 0)
            DropIcon.Font = Enum.Font.GothamBold
            DropIcon.Text = "▼"
            DropIcon.TextColor3 = Color3.fromRGB(150, 150, 150)
            DropIcon.TextSize = 10
            
            local currentIndex = 1
            
            DropBtn.MouseButton1Click:Connect(function()
                if config.Options then
                    currentIndex = currentIndex + 1
                    if currentIndex > #config.Options then
                        currentIndex = 1
                    end
                    DropBtn.Text = config.Options[currentIndex]
                    
                    TweenService:Create(DropBtn, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                        BackgroundColor3 = Color3.fromRGB(70, 70, 70)
                    }):Play()
                    task.wait(0.1)
                    TweenService:Create(DropBtn, TweenInfo.new(0.2), {
                        BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                    }):Play()
                    
                    if config.Callback then
                        config.Callback(config.Options[currentIndex])
                    end
                end
            end)
            
            DropBtn.MouseEnter:Connect(function()
                TweenService:Create(DropBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
            end)
            
            DropBtn.MouseLeave:Connect(function()
                TweenService:Create(DropBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}):Play()
            end)
            
            return Dropdown
        end

        
        -- Create Label
        function Tab:CreateLabel(config)
            local Label = Instance.new("TextLabel")
            Label.Parent = TabContent
            Label.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            Label.Size = UDim2.new(1, 0, 0, 40)
            Label.Font = Enum.Font.Gotham
            Label.Text = config.Text or "Label"
            Label.TextColor3 = Color3.fromRGB(200, 200, 200)
            Label.TextSize = 13
            
            local LabelCorner = Instance.new("UICorner")
            LabelCorner.CornerRadius = UDim.new(0, 8)
            LabelCorner.Parent = Label
            
            return Label
        end
        
        -- Create Section
        function Tab:CreateSection(config)
            local Section = Instance.new("Frame")
            Section.Parent = TabContent
            Section.BackgroundTransparency = 1
            Section.Size = UDim2.new(1, 0, 0, 35)
            
            local SectionLabel = Instance.new("TextLabel")
            SectionLabel.Parent = Section
            SectionLabel.BackgroundTransparency = 1
            SectionLabel.Size = UDim2.new(1, 0, 1, 0)
            SectionLabel.Font = Enum.Font.GothamBold
            SectionLabel.Text = config.Name or "Section"
            SectionLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            SectionLabel.TextSize = 16
            SectionLabel.TextXAlignment = Enum.TextXAlignment.Left
            
            return Section
        end
        
        -- Create Discord Button
        function Tab:CreateDiscord(config)
            local DiscordBtn = Instance.new("TextButton")
            DiscordBtn.Parent = TabContent
            DiscordBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
            DiscordBtn.Size = UDim2.new(1, 0, 0, 50)
            DiscordBtn.Font = Enum.Font.GothamBold
            DiscordBtn.Text = ""
            DiscordBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            DiscordBtn.TextSize = 14
            DiscordBtn.AutoButtonColor = false
            
            local BtnCorner = Instance.new("UICorner")
            BtnCorner.CornerRadius = UDim.new(0, 8)
            BtnCorner.Parent = DiscordBtn
            
            local IconLabel = Instance.new("TextLabel")
            IconLabel.Parent = DiscordBtn
            IconLabel.BackgroundTransparency = 1
            IconLabel.Position = UDim2.new(0, 15, 0, 0)
            IconLabel.Size = UDim2.new(0, 30, 1, 0)
            IconLabel.Font = Enum.Font.GothamBold
            IconLabel.Text = "🔗"
            IconLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            IconLabel.TextSize = 18
            
            local TitleLabel = Instance.new("TextLabel")
            TitleLabel.Parent = DiscordBtn
            TitleLabel.BackgroundTransparency = 1
            TitleLabel.Position = UDim2.new(0, 50, 0, 8)
            TitleLabel.Size = UDim2.new(1, -60, 0, 18)
            TitleLabel.Font = Enum.Font.GothamBold
            TitleLabel.Text = config.Name or "Join Discord Server"
            TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            TitleLabel.TextSize = 14
            TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
            
            local SubLabel = Instance.new("TextLabel")
            SubLabel.Parent = DiscordBtn
            SubLabel.BackgroundTransparency = 1
            SubLabel.Position = UDim2.new(0, 50, 0, 28)
            SubLabel.Size = UDim2.new(1, -60, 0, 15)
            SubLabel.Font = Enum.Font.Gotham
            SubLabel.Text = config.Invite or "discord.gg/invite"
            SubLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
            SubLabel.TextSize = 11
            SubLabel.TextXAlignment = Enum.TextXAlignment.Left
            
            DiscordBtn.MouseButton1Click:Connect(function()
                -- Copy to clipboard
                if setclipboard then
                    setclipboard(config.Invite or "")
                    
                    -- Visual feedback
                    local originalText = TitleLabel.Text
                    TitleLabel.Text = "✅ Copied to Clipboard!"
                    
                    TweenService:Create(DiscordBtn, TweenInfo.new(0.2), {
                        BackgroundColor3 = Color3.fromRGB(67, 181, 129)
                    }):Play()
                    
                    task.wait(2)
                    
                    TitleLabel.Text = originalText
                    TweenService:Create(DiscordBtn, TweenInfo.new(0.2), {
                        BackgroundColor3 = Color3.fromRGB(88, 101, 242)
                    }):Play()
                else
                    -- Fallback if setclipboard not available
                    TitleLabel.Text = "⚠️ Clipboard not supported"
                    task.wait(2)
                    TitleLabel.Text = config.Name or "Join Discord Server"
                end
                
                if config.Callback then
                    config.Callback()
                end
            end)
            
            DiscordBtn.MouseEnter:Connect(function()
                TweenService:Create(DiscordBtn, TweenInfo.new(0.2), {
                    BackgroundColor3 = Color3.fromRGB(108, 121, 255)
                }):Play()
            end)
            
            DiscordBtn.MouseLeave:Connect(function()
                TweenService:Create(DiscordBtn, TweenInfo.new(0.2), {
                    BackgroundColor3 = Color3.fromRGB(88, 101, 242)
                }):Play()
            end)
            
            return DiscordBtn
        end
        
        return Tab
    end
    
    Window.ScreenGui = ScreenGui
    Window.MainFrame = MainFrame
    Window.MinimizedIcon = MinimizedIcon
    
    return Window
end

return NixoUI
