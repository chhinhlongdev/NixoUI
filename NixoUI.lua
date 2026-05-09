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
    
    -- Animated GIF Loader
    local LoaderImage = Instance.new("ImageLabel")
    LoaderImage.Parent = LoadingFrame
    LoaderImage.BackgroundTransparency = 1
    LoaderImage.Position = UDim2.new(0.5, -60, 0, 30)
    LoaderImage.Size = UDim2.new(0, 120, 0, 120)
    LoaderImage.Image = "https://raw.githubusercontent.com/chhinhlongdev/NixoUI/refs/heads/main/assets/loader.gif"
    LoaderImage.ScaleType = Enum.ScaleType.Fit
    
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
    TweenService:Create(LoadingFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {
        BackgroundTransparency = 1
    }):Play()
    TweenService:Create(LoaderImage, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {
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
    
    -- Main Window
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(0.5, -350, 0.5, -250)
    MainFrame.Size = UDim2.new(0, 700, 0, 500)
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.ClipsDescendants = true
    
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 12)
    MainCorner.Parent = MainFrame

    
    -- Title Bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Parent = MainFrame
    TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    TitleBar.BorderSizePixel = 0
    TitleBar.Size = UDim2.new(1, 0, 0, 50)
    
    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 12)
    TitleCorner.Parent = TitleBar
    
    local Title = Instance.new("TextLabel")
    Title.Parent = TitleBar
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.Size = UDim2.new(1, -120, 1, 0)
    Title.Font = Enum.Font.GothamBold
    Title.Text = Window.Name
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 18
    Title.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Minimize Button
    local MinimizeBtn = Instance.new("TextButton")
    MinimizeBtn.Parent = TitleBar
    MinimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
    MinimizeBtn.Position = UDim2.new(1, -90, 0.5, -15)
    MinimizeBtn.Size = UDim2.new(0, 35, 0, 30)
    MinimizeBtn.Font = Enum.Font.GothamBold
    MinimizeBtn.Text = "—"
    MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinimizeBtn.TextSize = 16
    MinimizeBtn.AutoButtonColor = false
    
    local MinCorner = Instance.new("UICorner")
    MinCorner.CornerRadius = UDim.new(0, 8)
    MinCorner.Parent = MinimizeBtn
    
    -- Close Button
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Parent = TitleBar
    CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
    CloseBtn.Position = UDim2.new(1, -50, 0.5, -15)
    CloseBtn.Size = UDim2.new(0, 35, 0, 30)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.Text = "×"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.TextSize = 20
    CloseBtn.AutoButtonColor = false
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 8)
    CloseCorner.Parent = CloseBtn

    
    -- Minimized Icon
    local MinimizedIcon = Instance.new("ImageButton")
    MinimizedIcon.Parent = ScreenGui
    MinimizedIcon.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    MinimizedIcon.Position = UDim2.new(0, 10, 1, -60)
    MinimizedIcon.Size = UDim2.new(0, 50, 0, 50)
    MinimizedIcon.Image = "https://raw.githubusercontent.com/chhinhlongdev/NixoUI/refs/heads/main/assets/icon.png"
    MinimizedIcon.ScaleType = Enum.ScaleType.Fit
    MinimizedIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
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
    
    -- Tab Container
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.Parent = MainFrame
    TabContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    TabContainer.BorderSizePixel = 0
    TabContainer.Position = UDim2.new(0, 10, 0, 60)
    TabContainer.Size = UDim2.new(0, 160, 1, -70)
    
    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 10)
    TabCorner.Parent = TabContainer
    
    local TabScroll = Instance.new("ScrollingFrame")
    TabScroll.Parent = TabContainer
    TabScroll.BackgroundTransparency = 1
    TabScroll.Size = UDim2.new(1, 0, 1, 0)
    TabScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabScroll.ScrollBarThickness = 4
    TabScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    
    local TabLayout = Instance.new("UIListLayout")
    TabLayout.Parent = TabScroll
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabLayout.Padding = UDim.new(0, 8)
    TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    
    local TabPadding = Instance.new("UIPadding")
    TabPadding.Parent = TabScroll
    TabPadding.PaddingTop = UDim.new(0, 8)
    TabPadding.PaddingBottom = UDim.new(0, 8)
    
    -- Content Container
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Parent = MainFrame
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Position = UDim2.new(0, 180, 0, 60)
    ContentContainer.Size = UDim2.new(1, -190, 1, -70)

    
    -- Button Interactions
    MinimizeBtn.MouseButton1Click:Connect(function()
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0)
        }):Play()
        task.wait(0.3)
        MainFrame.Visible = false
        MinimizedIcon.Visible = true
        TweenService:Create(MinimizedIcon, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 50, 0, 50)
        }):Play()
    end)
    
    MinimizedIcon.MouseButton1Click:Connect(function()
        MinimizedIcon.Visible = false
        MainFrame.Visible = true
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 700, 0, 500)
        }):Play()
    end)
    
    CloseBtn.MouseButton1Click:Connect(function()
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0)
        }):Play()
        task.wait(0.3)
        ScreenGui:Destroy()
    end)
    
    -- Hover Effects
    MinimizeBtn.MouseEnter:Connect(function()
        TweenService:Create(MinimizeBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 220, 100)}):Play()
    end)
    MinimizeBtn.MouseLeave:Connect(function()
        TweenService:Create(MinimizeBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 200, 50)}):Play()
    end)
    
    CloseBtn.MouseEnter:Connect(function()
        TweenService:Create(CloseBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 70, 70)}):Play()
    end)
    CloseBtn.MouseLeave:Connect(function()
        TweenService:Create(CloseBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(220, 50, 50)}):Play()
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
        TabButton.Parent = TabScroll
        TabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
        TabButton.Size = UDim2.new(1, -10, 0, 40)
        TabButton.Font = Enum.Font.Gotham
        TabButton.Text = Tab.Icon .. "  " .. Tab.Name
        TabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
        TabButton.TextSize = 14
        TabButton.AutoButtonColor = false
        
        local TabBtnCorner = Instance.new("UICorner")
        TabBtnCorner.CornerRadius = UDim.new(0, 8)
        TabBtnCorner.Parent = TabButton

        
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = Tab.Name .. "Content"
        TabContent.Parent = ContentContainer
        TabContent.BackgroundTransparency = 1
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabContent.ScrollBarThickness = 6
        TabContent.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 120)
        TabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
        TabContent.Visible = false
        
        local ContentLayout = Instance.new("UIListLayout")
        ContentLayout.Parent = TabContent
        ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ContentLayout.Padding = UDim.new(0, 10)
        
        local ContentPadding = Instance.new("UIPadding")
        ContentPadding.Parent = TabContent
        ContentPadding.PaddingLeft = UDim.new(0, 8)
        ContentPadding.PaddingRight = UDim.new(0, 8)
        ContentPadding.PaddingTop = UDim.new(0, 8)
        ContentPadding.PaddingBottom = UDim.new(0, 8)
        
        TabButton.MouseButton1Click:Connect(function()
            for _, tab in pairs(Window.Tabs) do
                tab.Content.Visible = false
                TweenService:Create(tab.Button, TweenInfo.new(0.2), {
                    BackgroundColor3 = Color3.fromRGB(30, 30, 45),
                    TextColor3 = Color3.fromRGB(200, 200, 200)
                }):Play()
            end
            TabContent.Visible = true
            TweenService:Create(TabButton, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(100, 150, 255),
                TextColor3 = Color3.fromRGB(255, 255, 255)
            }):Play()
            Window.CurrentTab = Tab
        end)
        
        TabButton.MouseEnter:Connect(function()
            if TabContent.Visible == false then
                TweenService:Create(TabButton, TweenInfo.new(0.15), {
                    BackgroundColor3 = Color3.fromRGB(40, 40, 55)
                }):Play()
            end
        end)
        
        TabButton.MouseLeave:Connect(function()
            if TabContent.Visible == false then
                TweenService:Create(TabButton, TweenInfo.new(0.15), {
                    BackgroundColor3 = Color3.fromRGB(30, 30, 45)
                }):Play()
            end
        end)
        
        Tab.Button = TabButton
        Tab.Content = TabContent
        table.insert(Window.Tabs, Tab)
        
        if #Window.Tabs == 1 then
            TabButton.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
            TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            TabContent.Visible = true
            Window.CurrentTab = Tab
        end

        
        -- Create Toggle
        function Tab:CreateToggle(config)
            local Toggle = Instance.new("Frame")
            Toggle.Parent = TabContent
            Toggle.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
            Toggle.Size = UDim2.new(1, 0, 0, 40)
            
            local ToggleCorner = Instance.new("UICorner")
            ToggleCorner.CornerRadius = UDim.new(0, 8)
            ToggleCorner.Parent = Toggle
            
            local Label = Instance.new("TextLabel")
            Label.Parent = Toggle
            Label.BackgroundTransparency = 1
            Label.Position = UDim2.new(0, 12, 0, 0)
            Label.Size = UDim2.new(1, -60, 1, 0)
            Label.Font = Enum.Font.Gotham
            Label.Text = config.Name or "Toggle"
            Label.TextColor3 = Color3.fromRGB(255, 255, 255)
            Label.TextSize = 14
            Label.TextXAlignment = Enum.TextXAlignment.Left
            
            local ToggleBtn = Instance.new("TextButton")
            ToggleBtn.Parent = Toggle
            ToggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            ToggleBtn.Position = UDim2.new(1, -45, 0.5, -12)
            ToggleBtn.Size = UDim2.new(0, 40, 0, 24)
            ToggleBtn.Text = ""
            ToggleBtn.AutoButtonColor = false
            
            local BtnCorner = Instance.new("UICorner")
            BtnCorner.CornerRadius = UDim.new(1, 0)
            BtnCorner.Parent = ToggleBtn
            
            local Indicator = Instance.new("Frame")
            Indicator.Parent = ToggleBtn
            Indicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Indicator.Position = UDim2.new(0, 2, 0.5, -10)
            Indicator.Size = UDim2.new(0, 20, 0, 20)
            
            local IndCorner = Instance.new("UICorner")
            IndCorner.CornerRadius = UDim.new(1, 0)
            IndCorner.Parent = Indicator
            
            local state = config.Default or false
            if state then
                ToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
                Indicator.Position = UDim2.new(1, -22, 0.5, -10)
            end
            
            ToggleBtn.MouseButton1Click:Connect(function()
                state = not state
                TweenService:Create(ToggleBtn, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                    BackgroundColor3 = state and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
                }):Play()
                TweenService:Create(Indicator, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                    Position = state and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
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
            Button.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
            Button.Size = UDim2.new(1, 0, 0, 40)
            Button.Font = Enum.Font.GothamBold
            Button.Text = config.Name or "Button"
            Button.TextColor3 = Color3.fromRGB(255, 255, 255)
            Button.TextSize = 14
            Button.AutoButtonColor = false
            
            local BtnCorner = Instance.new("UICorner")
            BtnCorner.CornerRadius = UDim.new(0, 8)
            BtnCorner.Parent = Button
            
            Button.MouseButton1Click:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.1), {Size = UDim2.new(1, 0, 0, 37)}):Play()
                task.wait(0.1)
                TweenService:Create(Button, TweenInfo.new(0.1), {Size = UDim2.new(1, 0, 0, 40)}):Play()
                if config.Callback then
                    config.Callback()
                end
            end)
            
            Button.MouseEnter:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(120, 170, 255)}):Play()
            end)
            
            Button.MouseLeave:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(100, 150, 255)}):Play()
            end)
            
            return Button
        end
        
        -- Create Slider
        function Tab:CreateSlider(config)
            local Slider = Instance.new("Frame")
            Slider.Parent = TabContent
            Slider.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
            Slider.Size = UDim2.new(1, 0, 0, 60)
            
            local SliderCorner = Instance.new("UICorner")
            SliderCorner.CornerRadius = UDim.new(0, 8)
            SliderCorner.Parent = Slider
            
            local Label = Instance.new("TextLabel")
            Label.Parent = Slider
            Label.BackgroundTransparency = 1
            Label.Position = UDim2.new(0, 12, 0, 8)
            Label.Size = UDim2.new(1, -70, 0, 20)
            Label.Font = Enum.Font.Gotham
            Label.Text = config.Name or "Slider"
            Label.TextColor3 = Color3.fromRGB(255, 255, 255)
            Label.TextSize = 14
            Label.TextXAlignment = Enum.TextXAlignment.Left
            
            local ValueLabel = Instance.new("TextLabel")
            ValueLabel.Parent = Slider
            ValueLabel.BackgroundTransparency = 1
            ValueLabel.Position = UDim2.new(1, -60, 0, 8)
            ValueLabel.Size = UDim2.new(0, 50, 0, 20)
            ValueLabel.Font = Enum.Font.GothamBold
            ValueLabel.Text = tostring(config.Default or 0)
            ValueLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
            ValueLabel.TextSize = 14

            
            local SliderBar = Instance.new("Frame")
            SliderBar.Parent = Slider
            SliderBar.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
            SliderBar.Position = UDim2.new(0, 12, 0, 38)
            SliderBar.Size = UDim2.new(1, -24, 0, 10)
            
            local BarCorner = Instance.new("UICorner")
            BarCorner.CornerRadius = UDim.new(1, 0)
            BarCorner.Parent = SliderBar
            
            local Fill = Instance.new("Frame")
            Fill.Parent = SliderBar
            Fill.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
            local percent = ((config.Default or 0) - (config.Min or 0)) / ((config.Max or 100) - (config.Min or 0))
            Fill.Size = UDim2.new(percent, 0, 1, 0)
            
            local FillCorner = Instance.new("UICorner")
            FillCorner.CornerRadius = UDim.new(1, 0)
            FillCorner.Parent = Fill
            
            local SliderBtn = Instance.new("TextButton")
            SliderBtn.Parent = SliderBar
            SliderBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            SliderBtn.Position = UDim2.new(percent, -6, 0.5, -6)
            SliderBtn.Size = UDim2.new(0, 12, 0, 12)
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
                    TweenService:Create(SliderBtn, TweenInfo.new(0.1), {Position = UDim2.new(percent, -6, 0.5, -6)}):Play()
                    
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
            Dropdown.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
            Dropdown.Size = UDim2.new(1, 0, 0, 40)
            
            local DropCorner = Instance.new("UICorner")
            DropCorner.CornerRadius = UDim.new(0, 8)
            DropCorner.Parent = Dropdown
            
            local Label = Instance.new("TextLabel")
            Label.Parent = Dropdown
            Label.BackgroundTransparency = 1
            Label.Position = UDim2.new(0, 12, 0, 0)
            Label.Size = UDim2.new(0.4, 0, 1, 0)
            Label.Font = Enum.Font.Gotham
            Label.Text = config.Name or "Dropdown"
            Label.TextColor3 = Color3.fromRGB(255, 255, 255)
            Label.TextSize = 14
            Label.TextXAlignment = Enum.TextXAlignment.Left
            
            local DropBtn = Instance.new("TextButton")
            DropBtn.Parent = Dropdown
            DropBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
            DropBtn.Position = UDim2.new(0.4, 5, 0.5, -15)
            DropBtn.Size = UDim2.new(0.6, -17, 0, 30)
            DropBtn.Font = Enum.Font.Gotham
            DropBtn.Text = (config.Options and config.Options[1]) or "Select"
            DropBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            DropBtn.TextSize = 13
            DropBtn.AutoButtonColor = false
            
            local BtnCorner = Instance.new("UICorner")
            BtnCorner.CornerRadius = UDim.new(0, 6)
            BtnCorner.Parent = DropBtn
            
            local currentIndex = 1
            
            DropBtn.MouseButton1Click:Connect(function()
                if config.Options then
                    currentIndex = currentIndex + 1
                    if currentIndex > #config.Options then
                        currentIndex = 1
                    end
                    DropBtn.Text = config.Options[currentIndex]
                    
                    TweenService:Create(DropBtn, TweenInfo.new(0.2, Enum.EasingStyle.Back), {
                        BackgroundColor3 = Color3.fromRGB(60, 60, 80)
                    }):Play()
                    task.wait(0.1)
                    TweenService:Create(DropBtn, TweenInfo.new(0.2), {
                        BackgroundColor3 = Color3.fromRGB(40, 40, 55)
                    }):Play()
                    
                    if config.Callback then
                        config.Callback(config.Options[currentIndex])
                    end
                end
            end)
            
            DropBtn.MouseEnter:Connect(function()
                TweenService:Create(DropBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(50, 50, 65)}):Play()
            end)
            
            DropBtn.MouseLeave:Connect(function()
                TweenService:Create(DropBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(40, 40, 55)}):Play()
            end)
            
            return Dropdown
        end

        
        -- Create Label
        function Tab:CreateLabel(config)
            local Label = Instance.new("TextLabel")
            Label.Parent = TabContent
            Label.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
            Label.Size = UDim2.new(1, 0, 0, 35)
            Label.Font = Enum.Font.Gotham
            Label.Text = config.Text or "Label"
            Label.TextColor3 = Color3.fromRGB(200, 200, 200)
            Label.TextSize = 14
            
            local LabelCorner = Instance.new("UICorner")
            LabelCorner.CornerRadius = UDim.new(0, 8)
            LabelCorner.Parent = Label
            
            return Label
        end
        
        -- Create Section
        function Tab:CreateSection(config)
            local Section = Instance.new("Frame")
            Section.Parent = TabContent
            Section.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
            Section.Size = UDim2.new(1, 0, 0, 30)
            
            local SectionCorner = Instance.new("UICorner")
            SectionCorner.CornerRadius = UDim.new(0, 8)
            SectionCorner.Parent = Section
            
            local SectionLabel = Instance.new("TextLabel")
            SectionLabel.Parent = Section
            SectionLabel.BackgroundTransparency = 1
            SectionLabel.Size = UDim2.new(1, 0, 1, 0)
            SectionLabel.Font = Enum.Font.GothamBold
            SectionLabel.Text = config.Name or "Section"
            SectionLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            SectionLabel.TextSize = 15
            
            return Section
        end
        
        return Tab
    end
    
    Window.ScreenGui = ScreenGui
    Window.MainFrame = MainFrame
    Window.MinimizedIcon = MinimizedIcon
    
    return Window
end

return NixoUI
