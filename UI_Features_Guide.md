# NixoUI - Complete Features Guide

## ✅ Already Implemented Features

Your NixoUI library **ALREADY HAS** all the window control features you requested!

---

## 🎮 Window Controls

### 1. ❌ Close Button (Top Right - Red)
- **Location**: Top-right corner of the window
- **Color**: Red (RGB 220, 50, 50)
- **Symbol**: ×
- **Function**: Completely destroys the GUI
- **Animation**: Smooth shrink animation before closing

**How it works:**
```lua
CloseBtn.MouseButton1Click:Connect(function()
    TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0)
    }):Play()
    task.wait(0.3)
    ScreenGui:Destroy()
end)
```

---

### 2. — Minimize Button (Top Right - Yellow)
- **Location**: Next to close button (top-right)
- **Color**: Yellow (RGB 255, 200, 50)
- **Symbol**: —
- **Function**: Minimizes window to small icon
- **Animation**: Shrinks to bottom-left corner

**How it works:**
```lua
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
```

---

### 3. 📦 Restore Icon (Bottom Left - Blue)
- **Location**: Bottom-left corner when minimized
- **Color**: Blue (RGB 100, 150, 255)
- **Symbol**: 📦
- **Function**: Restores window from minimized state
- **Animation**: Expands back to full size

**How it works:**
```lua
MinimizedIcon.MouseButton1Click:Connect(function()
    MinimizedIcon.Visible = false
    MainFrame.Visible = true
    TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 700, 0, 500)
    }):Play()
end)
```

---

## 🎨 Visual Features

### Hover Effects
All buttons have smooth hover animations:

**Minimize Button:**
- Hover: Lighter yellow (RGB 255, 220, 100)
- Normal: Yellow (RGB 255, 200, 50)

**Close Button:**
- Hover: Lighter red (RGB 255, 70, 70)
- Normal: Red (RGB 220, 50, 50)

---

## 📱 Complete Window Flow

### Normal State
```
┌─────────────────────────────────────┐
│  NixoUI | Universal Hub    [—] [×] │ ← Title bar with buttons
├─────────────────────────────────────┤
│ [Tabs]  │  Content Area             │
│         │                           │
│         │                           │
└─────────────────────────────────────┘
```

### Minimized State
```
Screen:
┌─────────────────────────────────────┐
│                                     │
│                                     │
│                                     │
│                                     │
│                                     │
│ [📦]                                │ ← Restore icon (bottom-left)
└─────────────────────────────────────┘
```

### Closed State
```
(GUI completely destroyed - nothing visible)
```

---

## 🎯 User Experience

### 1. Minimize Workflow
1. User clicks **—** (yellow button)
2. Window smoothly shrinks with Back easing
3. Window becomes invisible
4. **📦 icon** appears in bottom-left corner
5. User can click icon to restore

### 2. Restore Workflow
1. User clicks **📦 icon** (bottom-left)
2. Icon disappears
3. Window becomes visible
4. Window smoothly expands to full size
5. All content preserved

### 3. Close Workflow
1. User clicks **×** (red button)
2. Window smoothly shrinks
3. Entire GUI is destroyed
4. Cannot be restored (must reload script)

---

## 💡 Testing Your UI

### Test Script:
```lua
local NixoUI = loadstring(game:HttpGet('YOUR_URL'))()

local Window = NixoUI:CreateWindow({
    Name = "Test Window Controls",
    LoadingTitle = "Testing",
    LoadingSubtitle = "Window Controls"
})

local Tab = Window:CreateTab({
    Name = "Test",
    Icon = "🧪"
})

Tab:CreateLabel({
    Text = "Try the window controls!"
})

Tab:CreateButton({
    Name = "Test Minimize",
    Callback = function()
        print("Click the yellow — button to minimize")
    end
})

Tab:CreateButton({
    Name = "Test Close",
    Callback = function()
        print("Click the red × button to close")
    end
})
```

---

## 🎨 Button Positions

```
Title Bar Layout:
┌──────────────────────────────────────────┐
│ Title Text              [—] [×]          │
│                          ↑   ↑           │
│                     Minimize Close       │
└──────────────────────────────────────────┘

Positions:
- Minimize: Position = UDim2.new(1, -90, 0.5, -15)
- Close:    Position = UDim2.new(1, -50, 0.5, -15)
- Size:     35x30 pixels each
```

---

## ✨ Animation Details

### Minimize Animation
- **Duration**: 0.3 seconds
- **Easing**: Back (In direction)
- **Effect**: Shrinks to 0x0 size
- **Icon appears**: Back (Out direction)

### Restore Animation
- **Duration**: 0.3 seconds
- **Easing**: Back (Out direction)
- **Effect**: Expands to 700x500 size
- **Smooth bounce effect**

### Close Animation
- **Duration**: 0.3 seconds
- **Easing**: Back (In direction)
- **Effect**: Shrinks then destroys
- **Final**: GUI completely removed

---

## 🔧 Customization Options

If you want to modify the buttons:

### Change Button Colors:
```lua
-- In Own_UI.lua, find these lines:

-- Minimize button color
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 50)  -- Yellow

-- Close button color
CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)      -- Red

-- Restore icon color
MinimizedIcon.BackgroundColor3 = Color3.fromRGB(100, 150, 255) -- Blue
```

### Change Button Symbols:
```lua
-- Minimize symbol
MinimizeBtn.Text = "—"

-- Close symbol
CloseBtn.Text = "×"

-- Restore icon
MinimizedIcon.Text = "📦"
```

### Change Icon Position:
```lua
-- Bottom-left (default)
MinimizedIcon.Position = UDim2.new(0, 10, 1, -60)

-- Bottom-right
MinimizedIcon.Position = UDim2.new(1, -60, 1, -60)

-- Top-left
MinimizedIcon.Position = UDim2.new(0, 10, 0, 10)
```

---

## ✅ Summary

**Your NixoUI already has ALL these features:**

✅ Close button (×) - Red, top-right
✅ Minimize button (—) - Yellow, top-right  
✅ Restore icon (📦) - Blue, bottom-left when minimized
✅ Smooth animations for all actions
✅ Hover effects on all buttons
✅ Proper state management

**Everything is working and ready to use!** 🎉

---

## 🚀 Quick Test

To test all features:

1. **Load the UI** - See loading animation
2. **Click yellow —** - Window minimizes to icon
3. **Click blue 📦** - Window restores
4. **Click red ×** - Window closes completely

All animations are smooth with Back easing for a professional feel!
