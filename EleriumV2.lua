-- discord: @vyxonq
local EleriumV2 = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()
local Theme = {
    Primary = Color3.fromRGB(138, 43, 226),
    Secondary = Color3.fromRGB(75, 0, 130),
    Accent = Color3.fromRGB(255, 105, 180),
    Success = Color3.fromRGB(72, 187, 120),
    Minimize = Color3.fromRGB(138, 43, 226),
    Warning = Color3.fromRGB(245, 158, 11),
    Error = Color3.fromRGB(239, 68, 68),
    Background = Color3.fromRGB(15, 23, 42),
    Surface = Color3.fromRGB(30, 41, 59),
    Glass = Color3.fromRGB(51, 65, 85),
    Text = Color3.fromRGB(248, 250, 252),
    TextMuted = Color3.fromRGB(148, 163, 184),
    Border = Color3.fromRGB(71, 85, 105)
}
local Icons = {
    ChevronRight = "rbxassetid://10709759895",
    ChevronDown = "rbxassetid://10709767827",
    X = "rbxassetid://10747384394",
    Check = "rbxassetid://10709790644",
    Settings = "rbxassetid://10734950309",
    User = "rbxassetid://10747373176",
    Home = "rbxassetid://10723407389",
    Search = "rbxassetid://7733921320",
    Bell = "rbxassetid://10709775704",
    Heart = "rbxassetid://10723406885",
    Star = "rbxassetid://10734966248",
    Plus = "rbxassetid://10734924532",
    Minus = "rbxassetid://10734896206",
    Edit = "rbxassetid://10734883598",
    Trash = "rbxassetid://10747362393",
    Eye = "rbxassetid://10723346959",
    EyeOff = "rbxassetid://10723346871",
    Lock = "rbxassetid://10723434711",
    Unlock = "rbxassetid://10747366027",
    Download = "rbxassetid://10723344270",
    Upload = "rbxassetid://10747366434",
    RefreshCw = "rbxassetid://10734933056",
    Copy = "rbxassetid://10709812159",
    ExternalLink = "rbxassetid://10723346684",
    Info = "rbxassetid://10723415903",
    AlertCircle = "rbxassetid://10709752996",
    CheckCircle = "rbxassetid://10709790387",
    XCircle = "rbxassetid://10747383819"
}
local Animations = {
    Fast = TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    Normal = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    Slow = TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    Spring = TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    Bounce = TweenInfo.new(0.4, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out),
    SlideIn = TweenInfo.new(0.8, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
}
local DefaultConfig = {
    MainColor = Theme.Primary,
    MinSize = Vector2.new(420, 300),
    ToggleKey = Enum.KeyCode.RightShift,
    CanResize = true,
    BlurEnabled = true,
    SoundEnabled = true
}
local Utils = {}
local function clamp(val, lower, upper)
    if lower and val < lower then
        return lower
    end
    if upper and val > upper then
        return upper
    end
    return val
end
local function getGuiParent(config)
    config = config or {}
    -- optimized-out if statement
    if RunService:IsStudio() then
        local pl = Players.LocalPlayer
        if pl then
            local pg = pl:FindFirstChild("PlayerGui")
            if pg then
                return pg
            end
        end
        return game:GetService("StarterGui")
    end
    local pl = Players.LocalPlayer
    if pl then
        local pg = pl:FindFirstChild("PlayerGui")
        if pg then
            return pg
        end
    end
    if gethui then
        local ok, g = pcall(gethui)
        if ok and g then
            return g
        end
    end
    return CoreGui
end
local function destroyExistingElerium()
    local roots = {
        CoreGui
    }
    local pl = Players.LocalPlayer
    if pl then
        local pg = pl:FindFirstChild("PlayerGui")
        if pg then
            table.insert(roots, pg)
        end
    end
    if gethui then
        local ok, g = pcall(gethui)
        if ok and g then
            table.insert(roots, g)
        end
    end
    for _, root in ipairs(roots) do
        local existing = root:FindFirstChild("EleriumV2")
        if existing then
            existing:Destroy()
        end
    end
end
Utils.Tween = function(object, info, properties, callback)
    local tween = TweenService:Create(object, info, properties)
    if callback then
        tween.Completed:Connect(callback)
    end
    tween:Play()
    return tween
end
Utils.CreateIcon = function(parent, iconName, size, position)
    size = size or UDim2.new(0, 20, 0, 20)
    position = position or UDim2.new(0, 0, 0, 0)
    local icon = Instance.new("ImageLabel")
    icon.Size = size
    icon.Position = position
    icon.BackgroundTransparency = 1
    icon.Image = Icons[iconName] or ""
    icon.ImageColor3 = Theme.Text
    icon.ScaleType = Enum.ScaleType.Fit
    icon.Parent = parent
    return icon
end
Utils.CreateGlassEffect = function(parent, transparency)
    transparency = transparency or 0.15
    local glass = Instance.new("Frame")
    glass.Name = "GlassEffect"
    glass.Size = UDim2.new(1, 0, 1, 0)
    glass.BackgroundColor3 = Theme.Glass
    glass.BackgroundTransparency = transparency
    glass.BorderSizePixel = 0
    glass.Parent = parent
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = glass
    local stroke = Instance.new("UIStroke")
    stroke.Color = Theme.Border
    stroke.Thickness = 1
    stroke.Transparency = 0.5
    stroke.Parent = glass
    return glass
end
Utils.CreateShadow = function(parent, size, offset)
    size = size or 6
    offset = offset or 2
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "DropShadow"
    shadow.Size = UDim2.new(1, size * 2, 1, size * 2)
    shadow.Position = UDim2.new(0, -size + offset, 0, -size + offset)
    shadow.BackgroundTransparency = 1
    shadow.Image = ""
    shadow.ImageColor3 = Color3.new(0, 0, 0)
    shadow.ImageTransparency = 0.7
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10, 10, 10, 10)
    shadow.ZIndex = parent.ZIndex - 1
    shadow.Parent = parent.Parent
    return shadow
end
Utils.CreateRipple = function(button, x, y)
    spawn(function()
        button.ClipsDescendants = true
        local ripple = Instance.new("Frame")
        ripple.Size = UDim2.new(0, 0, 0, 0)
        ripple.BackgroundColor3 = Theme.Text
        ripple.BackgroundTransparency = 0.8
        ripple.BorderSizePixel = 0
        ripple.Parent = button
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(1, 0)
        corner.Parent = ripple
        local size = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 2
        ripple.Position = UDim2.new(0, x - button.AbsolutePosition.X, 0, y - button.AbsolutePosition.Y)
        Utils.Tween(ripple, Animations.Normal, {
            Size = UDim2.new(0, size, 0, size),
            Position = UDim2.new(0, x - button.AbsolutePosition.X - size / 2, 0, y - button.AbsolutePosition.Y - size / 2),
            BackgroundTransparency = 1
        }, function()
            ripple:Destroy()
        end)
    end)
end
Utils.AddHoverEffect = function(element, hoverProps, normalProps)
    element.MouseEnter:Connect(function()
        Utils.Tween(element, Animations.Fast, hoverProps or {
            BackgroundTransparency = math.max(0, element.BackgroundTransparency - 0.1)
        })
    end)
    element.MouseLeave:Connect(function()
        Utils.Tween(element, Animations.Fast, normalProps or {
            BackgroundTransparency = element.BackgroundTransparency + 0.1
        })
    end)
end
local NotificationSystem = {}
NotificationSystem.Notifications = {}
NotificationSystem.Container = nil
function NotificationSystem:Initialize(screenGui)
    self.Container = Instance.new("Frame")
    self.Container.Name = "NotificationContainer"
    self.Container.Size = UDim2.new(0, 300, 1, 0)
    self.Container.Position = UDim2.new(1, -320, 0, 20)
    self.Container.BackgroundTransparency = 1
    self.Container.Parent = screenGui
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 10)
    layout.Parent = self.Container
end
function NotificationSystem:CreateNotification(title, message, notificationType, duration)
    notificationType = notificationType or "Info"
    duration = duration or 5
    local notification = Instance.new("Frame")
    notification.Size = UDim2.new(1, 0, 0, 80)
    notification.BackgroundColor3 = Theme.Surface
    notification.BackgroundTransparency = 0.1
    notification.BorderSizePixel = 0
    notification.Parent = self.Container
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = notification
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 1
    stroke.Transparency = 0.3
    stroke.Parent = notification
    if notificationType == "Success" then
        stroke.Color = Theme.Success
    elseif notificationType == "Warning" then
        stroke.Color = Theme.Warning
    elseif notificationType == "Error" then
        stroke.Color = Theme.Error
    else
        stroke.Color = Theme.Primary
    end
    local iconName = "Info"
    if notificationType == "Success" then
        iconName = "CheckCircle"
    elseif notificationType == "Warning" then
        iconName = "AlertCircle"
    elseif notificationType == "Error" then
        iconName = "XCircle"
    end
    local icon = Utils.CreateIcon(notification, iconName, UDim2.new(0, 24, 0, 24), UDim2.new(0, 15, 0, 15))
    icon.ImageColor3 = stroke.Color
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -90, 0, 25)
    titleLabel.Position = UDim2.new(0, 50, 0, 10)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Theme.Text
    titleLabel.TextSize = 16
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Font = Enum.Font.GothamMedium
    titleLabel.Parent = notification
    local messageLabel = Instance.new("TextLabel")
    messageLabel.Size = UDim2.new(1, -90, 0, 20)
    messageLabel.Position = UDim2.new(0, 50, 0, 35)
    messageLabel.BackgroundTransparency = 1
    messageLabel.Text = message
    messageLabel.TextColor3 = Theme.TextMuted
    messageLabel.TextSize = 14
    messageLabel.TextXAlignment = Enum.TextXAlignment.Left
    messageLabel.Font = Enum.Font.Gotham
    messageLabel.TextWrapped = true
    messageLabel.Parent = notification
    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0, 20, 0, 20)
    closeButton.Position = UDim2.new(1, -30, 0, 10)
    closeButton.BackgroundTransparency = 1
    closeButton.Text = ""
    closeButton.Parent = notification
    local closeIcon = Utils.CreateIcon(closeButton, "X", UDim2.new(0, 16, 0, 16), UDim2.new(0, 2, 0, 2))
    closeIcon.ImageColor3 = Theme.TextMuted
    titleLabel.TextTransparency = 1
    messageLabel.TextTransparency = 1
    icon.ImageTransparency = 1
    closeIcon.ImageTransparency = 1
    notification.Position = UDim2.new(1, 50, 0, 0)
    notification.BackgroundTransparency = 1
    Utils.Tween(notification, Animations.Spring, {
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 0.1
    })
    Utils.Tween(titleLabel, Animations.Fast, {
        TextTransparency = 0
    })
    Utils.Tween(messageLabel, Animations.Fast, {
        TextTransparency = 0
    })
    Utils.Tween(icon, Animations.Fast, {
        ImageTransparency = 0
    })
    Utils.Tween(closeIcon, Animations.Fast, {
        ImageTransparency = 0
    })
    local function dismissNotification()
        Utils.Tween(titleLabel, Animations.Fast, {
            TextTransparency = 1
        })
        Utils.Tween(messageLabel, Animations.Fast, {
            TextTransparency = 1
        })
        Utils.Tween(icon, Animations.Fast, {
            ImageTransparency = 1
        })
        Utils.Tween(closeIcon, Animations.Fast, {
            ImageTransparency = 1
        })
        Utils.Tween(notification, Animations.Fast, {
            Position = UDim2.new(1, 50, 0, 0),
            BackgroundTransparency = 1
        }, function()
            notification:Destroy()
        end)
    end
    closeButton.MouseButton1Click:Connect(dismissNotification)
    spawn(function()
        wait(duration)
        -- optimized-out if statement
    end)
    table.insert(self.Notifications, notification)
    return notification
end
EleriumV2.new = function(config)
    config = config or {}
    for k, v in pairs(DefaultConfig) do
        if config[k] == nil then
            config[k] = v
        end
    end
    destroyExistingElerium()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "EleriumV2"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = getGuiParent(config)
    NotificationSystem:Initialize(screenGui)
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == config.ToggleKey then
            screenGui.Enabled = true
        end
    end)
    local UI = {
        ScreenGui = screenGui,
        Config = config,
        Windows = {},
        NotificationSystem = NotificationSystem
    }
    function UI:Notify(title, message, notificationType, duration)
        return self.NotificationSystem:CreateNotification(title, message, notificationType, duration)
    end
    local ThemePresets = {
        Default = {
            Primary = Theme.Primary,
            Minimize = Theme.Minimize,
            Accent = Theme.Accent,
            Background = Theme.Background,
            Surface = Theme.Surface,
            Glass = Theme.Glass,
            Text = Theme.Text,
            TextMuted = Theme.TextMuted,
            Border = Theme.Border,
            Error = Theme.Error,
            Success = Theme.Success,
            Warning = Theme.Warning
        },
        Dark = {
            Primary = Color3.fromRGB(98, 0, 238),
            Minimize = Color3.fromRGB(98, 0, 238),
            Accent = Color3.fromRGB(255, 105, 180),
            Background = Color3.fromRGB(10, 12, 16),
            Surface = Color3.fromRGB(20, 24, 30),
            Glass = Color3.fromRGB(14, 18, 24),
            Text = Color3.fromRGB(235, 235, 240),
            TextMuted = Color3.fromRGB(140, 150, 170),
            Border = Color3.fromRGB(40, 45, 55),
            Error = Color3.fromRGB(239, 68, 68),
            Success = Color3.fromRGB(72, 187, 120),
            Warning = Color3.fromRGB(245, 158, 11)
        },
        Light = {
            Primary = Color3.fromRGB(99, 102, 241),
            Minimize = Color3.fromRGB(99, 102, 241),
            Accent = Color3.fromRGB(236, 72, 153),
            Background = Color3.fromRGB(250, 250, 253),
            Surface = Color3.fromRGB(255, 255, 255),
            Glass = Color3.fromRGB(245, 245, 250),
            Text = Color3.fromRGB(17, 24, 39),
            TextMuted = Color3.fromRGB(107, 114, 128),
            Border = Color3.fromRGB(228, 232, 240),
            Error = Color3.fromRGB(220, 38, 38),
            Success = Color3.fromRGB(16, 185, 129),
            Warning = Color3.fromRGB(245, 158, 11)
        },
        Purple = {
            Primary = Color3.fromRGB(138, 43, 226),
            Minimize = Color3.fromRGB(138, 43, 226),
            Accent = Color3.fromRGB(255, 105, 180),
            Background = Color3.fromRGB(18, 6, 44),
            Surface = Color3.fromRGB(32, 14, 56),
            Glass = Color3.fromRGB(26, 8, 46),
            Text = Color3.fromRGB(248, 250, 252),
            TextMuted = Color3.fromRGB(168, 162, 190),
            Border = Color3.fromRGB(94, 65, 140)
        },
        Blue = {
            Primary = Color3.fromRGB(59, 130, 246),
            Minimize = Color3.fromRGB(59, 130, 246),
            Accent = Color3.fromRGB(99, 102, 241),
            Background = Color3.fromRGB(8, 14, 22),
            Surface = Color3.fromRGB(16, 24, 34),
            Glass = Color3.fromRGB(12, 20, 30),
            Text = Color3.fromRGB(248, 250, 252),
            TextMuted = Color3.fromRGB(148, 163, 184),
            Border = Color3.fromRGB(40, 50, 65)
        },
        Sunset = {
            Primary = Color3.fromRGB(249, 115, 22),
            Minimize = Color3.fromRGB(249, 115, 22),
            Accent = Color3.fromRGB(236, 72, 153),
            Background = Color3.fromRGB(25, 18, 35),
            Surface = Color3.fromRGB(40, 25, 45),
            Glass = Color3.fromRGB(34, 22, 38),
            Text = Color3.fromRGB(250, 245, 240),
            TextMuted = Color3.fromRGB(170, 150, 140),
            Border = Color3.fromRGB(80, 60, 70)
        },
        Forest = {
            Primary = Color3.fromRGB(16, 185, 129),
            Minimize = Color3.fromRGB(16, 185, 129),
            Accent = Color3.fromRGB(59, 130, 246),
            Background = Color3.fromRGB(8, 20, 14),
            Surface = Color3.fromRGB(14, 30, 20),
            Glass = Color3.fromRGB(12, 26, 18),
            Text = Color3.fromRGB(240, 250, 240),
            TextMuted = Color3.fromRGB(150, 170, 150),
            Border = Color3.fromRGB(30, 50, 35)
        },
        Monochrome = {
            Primary = Color3.fromRGB(120, 120, 120),
            Minimize = Color3.fromRGB(120, 120, 120),
            Accent = Color3.fromRGB(160, 160, 160),
            Background = Color3.fromRGB(18, 18, 18),
            Surface = Color3.fromRGB(30, 30, 30),
            Glass = Color3.fromRGB(24, 24, 24),
            Text = Color3.fromRGB(230, 230, 230),
            TextMuted = Color3.fromRGB(150, 150, 150),
            Border = Color3.fromRGB(50, 50, 50)
        },
        Ocean = {
            Primary = Color3.fromRGB(20, 184, 166),
            Minimize = Color3.fromRGB(20, 184, 166),
            Accent = Color3.fromRGB(59, 130, 246),
            Background = Color3.fromRGB(6, 22, 29),
            Surface = Color3.fromRGB(12, 30, 36),
            Glass = Color3.fromRGB(10, 26, 32),
            Text = Color3.fromRGB(240, 250, 250),
            TextMuted = Color3.fromRGB(140, 160, 160),
            Border = Color3.fromRGB(28, 46, 50)
        },
        Solarized = {
            Primary = Color3.fromRGB(38, 139, 210),
            Minimize = Color3.fromRGB(38, 139, 210),
            Accent = Color3.fromRGB(211, 54, 130),
            Background = Color3.fromRGB(0, 43, 54),
            Surface = Color3.fromRGB(7, 54, 66),
            Glass = Color3.fromRGB(10, 60, 70),
            Text = Color3.fromRGB(253, 246, 227),
            TextMuted = Color3.fromRGB(147, 161, 161),
            Border = Color3.fromRGB(88, 110, 117)
        }
    }
    function UI:SetTheme(presetName)
        local preset = ThemePresets[presetName]
        if not preset then
            return
        end
        for k, v in pairs(preset) do
            Theme[k] = v
        end
        self.Config.MainColor = self.Config.MainColor
        for _, w in ipairs(self.Windows) do
            if w and w.Window and w.Window.Parent then
                local win = w.Window
                win.BackgroundTransparency = 1
                local glass = win:FindFirstChild("GlassEffect")
                if glass then
                    glass.BackgroundColor3 = Theme.Background
                else
                    for _, child in ipairs(win:GetChildren()) do
                        if child:IsA("Frame") and true then
                            child.BackgroundColor3 = Theme.Surface
                        end
                    end
                end
                local titleBar = win:FindFirstChild("TitleBar")
                if titleBar then
                    titleBar.BackgroundColor3 = Theme.Primary
                    local titleBottomCover = titleBar:FindFirstChild("TitleBottomCover")
                    if titleBottomCover then
                        titleBottomCover.BackgroundColor3 = Theme.Primary
                    end
                    local minBtn = titleBar:FindFirstChild("Minimize")
                    if minBtn then
                        minBtn.BackgroundColor3 = Theme.Minimize
                    end
                    local closeBtn = titleBar:FindFirstChild("Close")
                    if closeBtn then
                        closeBtn.BackgroundColor3 = Theme.Error
                    end
                    local titleLbl = titleBar:FindFirstChild("Title")
                    if titleLbl then
                        titleLbl.TextColor3 = Theme.Text
                    end
                end
                for _, desc in ipairs(win:GetDescendants()) do
                    if desc:IsA("TextButton") and desc.Name:match("^Tab_%d+") then
                        desc.BackgroundColor3 = Theme.Surface
                        for _, inner in ipairs(desc:GetChildren()) do
                            if inner:IsA("TextLabel") then
                                inner.TextColor3 = Theme.TextMuted
                            elseif inner:IsA("ImageLabel") then
                                inner.ImageColor3 = Theme.TextMuted
                            end
                        end
                    elseif desc:IsA("Frame") and true and true then
                        desc.BackgroundColor3 = Theme.Surface
                    end
                end
            end
        end
        -- optimized-out if statement
    end
    function UI:CreateWindow(title, options)
        title = title or "New Window"
        options = options or {}
        local windowIndex = #self.Windows + 1
        local window = Instance.new("Frame")
        window.Name = "Window_" .. windowIndex
        window.Size = UDim2.new(0, config.MinSize.X, 0, config.MinSize.Y)
        window.Position = UDim2.new(0, 50 + (windowIndex - 1) * 30, 0, 50 + (windowIndex - 1) * 30)
        window.BackgroundTransparency = 1
        window.BorderSizePixel = 0
        window.Active = true
        window.Parent = screenGui
        local glassBackground = Utils.CreateGlassEffect(window, 0.3)
        Utils.CreateShadow(window, 8, 4)
        local titleBar = Instance.new("Frame")
        titleBar.Name = "TitleBar"
        titleBar.Size = UDim2.new(1, 0, 0, 50)
        titleBar.BackgroundColor3 = Theme.Primary
        titleBar.BackgroundTransparency = 0.2
        titleBar.BorderSizePixel = 0
        titleBar.Parent = window
        local titleCorner = Instance.new("UICorner")
        titleCorner.CornerRadius = UDim.new(0, 12)
        titleCorner.Parent = titleBar
        local titleBottomCover = Instance.new("Frame")
        titleBottomCover.Name = "TitleBottomCover"
        titleBottomCover.Size = UDim2.new(1, 0, 0, 12)
        titleBottomCover.Position = UDim2.new(0, 0, 1, -12)
        titleBottomCover.BackgroundColor3 = Theme.Primary
        titleBottomCover.BackgroundTransparency = 0.2
        titleBottomCover.BorderSizePixel = 0
        titleBottomCover.Parent = titleBar
        local titleLabel = Instance.new("TextLabel")
        titleLabel.Name = "Title"
        titleLabel.Size = UDim2.new(1, -100, 1, 0)
        titleLabel.Position = UDim2.new(0, 20, 0, 0)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Text = title
        titleLabel.TextColor3 = Theme.Text
        titleLabel.TextSize = 18
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.Font = Enum.Font.GothamMedium
        titleLabel.Parent = titleBar
        local minimizeButton = Instance.new("TextButton")
        minimizeButton.Name = "Minimize"
        minimizeButton.Size = UDim2.new(0, 30, 0, 30)
        minimizeButton.Position = UDim2.new(1, -75, 0, 10)
        minimizeButton.BackgroundColor3 = Theme.Minimize
        minimizeButton.BackgroundTransparency = 0.3
        minimizeButton.BorderSizePixel = 0
        minimizeButton.Text = ""
        minimizeButton.Parent = titleBar
        local minimizeCorner = Instance.new("UICorner")
        minimizeCorner.CornerRadius = UDim.new(0, 8)
        minimizeCorner.Parent = minimizeButton
        local contentFrame
        local minimizeIcon = Utils.CreateIcon(minimizeButton, "Minus", UDim2.new(0, 16, 0, 16), UDim2.new(0.5, -8, 0.5, -8))
        Utils.AddHoverEffect(minimizeButton, {
            BackgroundTransparency = 0.1
        }, {
            BackgroundTransparency = 0.3
        })
        local closeButton = Instance.new("TextButton")
        closeButton.Name = "Close"
        closeButton.Size = UDim2.new(0, 30, 0, 30)
        closeButton.Position = UDim2.new(1, -40, 0, 10)
        closeButton.BackgroundColor3 = Theme.Error
        closeButton.BackgroundTransparency = 0.3
        closeButton.BorderSizePixel = 0
        closeButton.Text = ""
        closeButton.Parent = titleBar
        local closeCorner = Instance.new("UICorner")
        closeCorner.CornerRadius = UDim.new(0, 8)
        closeCorner.Parent = closeButton
        local closeIcon = Utils.CreateIcon(closeButton, "X", UDim2.new(0, 16, 0, 16), UDim2.new(0.5, -8, 0.5, -8))
        closeIcon.ImageColor3 = Theme.Text
        Utils.AddHoverEffect(closeButton, {
            BackgroundTransparency = 0.1
        }, {
            BackgroundTransparency = 0.3
        })
        local isMinimized = false
        local originalSize = window.Size
        minimizeButton.MouseButton1Click:Connect(function()
            Utils.CreateRipple(minimizeButton, Mouse.X, Mouse.Y)
            isMinimized = not isMinimized
            if isMinimized then
                originalSize = originalSize or window.Size
                if contentFrame then
                    contentFrame.Visible = false
                end
                Utils.Tween(window, Animations.Spring, {
                    Size = UDim2.new(0, config.MinSize.X, 0, 50)
                })
                if minimizeIcon then
                    Utils.Tween(minimizeIcon, Animations.Fast, {
                        Rotation = 180
                    })
                end
            else
                Utils.Tween(window, Animations.Spring, {
                    Size = originalSize
                })
                if contentFrame then
                    contentFrame.Visible = true
                end
                if minimizeIcon then
                    Utils.Tween(minimizeIcon, Animations.Fast, {
                        Rotation = 0
                    })
                end
            end
        end)
        closeButton.MouseButton1Click:Connect(function()
            Utils.CreateRipple(closeButton, Mouse.X, Mouse.Y)
            Utils.Tween(window, Animations.SlideIn, {
                Position = UDim2.new(window.Position.X.Scale, window.Position.X.Offset, 0, -config.MinSize.Y),
                BackgroundTransparency = 1
            }, function()
                pcall(function()
                    for i, w in ipairs(UI.Windows) do
                        if w and w.Window then
                            pcall(function()
                                Utils.DestroyGlassEffect(w.Window)
                            end)
                        end
                    end
                end)
                if UI and UI.ScreenGui then
                    pcall(function()
                        UI.ScreenGui:Destroy()
                    end)
                end
                UI.Windows = {}
            end)
        end)
        local dragging = false
        local dragStart = nil
        local startPos = nil
        titleBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = window.Position
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and dragging then
                local delta = input.Position - dragStart
                window.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)
        contentFrame = Instance.new("Frame")
        contentFrame.Name = "Content"
        contentFrame.Size = UDim2.new(1, -20, 1, -70)
        contentFrame.Position = UDim2.new(0, 10, 0, 60)
        contentFrame.BackgroundTransparency = 1
        contentFrame.ClipsDescendants = true
        contentFrame.Parent = window
        local contentLayout = Instance.new("UIListLayout")
        contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        contentLayout.Padding = UDim.new(0, 10)
        contentLayout.Parent = contentFrame
        local tabContainer = Instance.new("ScrollingFrame")
        tabContainer.Name = "TabContainer"
        tabContainer.Size = UDim2.new(1, 0, 0, 35)
        tabContainer.BackgroundTransparency = 1
        tabContainer.LayoutOrder = 1
        tabContainer.Parent = contentFrame
        tabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
        tabContainer.ScrollBarThickness = 6
        tabContainer.HorizontalScrollBarInset = Enum.ScrollBarInset.Always
        tabContainer.ScrollBarImageColor3 = Theme.Border
        tabContainer.ClipsDescendants = true
        tabContainer.ScrollingDirection = Enum.ScrollingDirection.X
        local tabList = Instance.new("UIListLayout")
        tabList.FillDirection = Enum.FillDirection.Horizontal
        tabList.SortOrder = Enum.SortOrder.LayoutOrder
        tabList.Padding = UDim.new(0, 5)
        tabList.Parent = tabContainer
        tabList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            tabContainer.CanvasSize = UDim2.new(0, tabList.AbsoluteContentSize.X + 8, 0, 0)
        end)
        local tabContentFrame = Instance.new("Frame")
        tabContentFrame.Name = "TabContent"
        tabContentFrame.Size = UDim2.new(1, 0, 1, -45)
        tabContentFrame.BackgroundTransparency = 1
        tabContentFrame.LayoutOrder = 2
        tabContentFrame.Parent = contentFrame
        local WindowAPI = {
            Window = window,
            Content = tabContentFrame,
            Tabs = {},
            ActiveTab = nil,
            IsMinimized = function()
                return isMinimized
            end
        }
        function WindowAPI:CreateTab(tabName, iconName)
            tabName = tabName or "New Tab"
            local tabIndex = #self.Tabs + 1
            local tabButton = Instance.new("TextButton")
            tabButton.Name = "Tab_" .. tabIndex
            tabButton.Size = UDim2.new(0, 120, 1, 0)
            tabButton.BackgroundColor3 = Theme.Surface
            tabButton.BackgroundTransparency = 0.3
            tabButton.BorderSizePixel = 0
            tabButton.Text = ""
            tabButton.LayoutOrder = tabIndex
            tabButton.Parent = tabContainer
            local tabCorner = Instance.new("UICorner")
            tabCorner.CornerRadius = UDim.new(0, 8)
            tabCorner.Parent = tabButton
            local tabLabel = Instance.new("TextLabel")
            tabLabel.Size = UDim2.new(1, -30, 1, 0)
            tabLabel.Position = UDim2.new(0, iconName and 25 or 10, 0, 0)
            tabLabel.BackgroundTransparency = 1
            tabLabel.Text = tabName
            tabLabel.TextColor3 = Theme.TextMuted
            tabLabel.TextSize = 14
            tabLabel.TextXAlignment = Enum.TextXAlignment.Left
            tabLabel.Font = Enum.Font.Gotham
            tabLabel.Parent = tabButton
            local tabIcon = nil
            if iconName then
                tabIcon = Utils.CreateIcon(tabButton, iconName, UDim2.new(0, 16, 0, 16), UDim2.new(0, 5, 0.5, -8))
                tabIcon.ImageColor3 = Theme.TextMuted
            end
            local tabContent = Instance.new("ScrollingFrame")
            tabContent.Name = "TabContent_" .. tabIndex
            tabContent.Size = UDim2.new(1, 0, 1, 0)
            tabContent.BackgroundTransparency = 1
            tabContent.BorderSizePixel = 0
            tabContent.ScrollBarThickness = 4
            tabContent.ScrollBarImageColor3 = Theme.Border
            tabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
            tabContent.Visible = false
            tabContent.Parent = tabContentFrame
            local tabLayout = Instance.new("UIListLayout")
            tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
            tabLayout.Padding = UDim.new(0, 8)
            tabLayout.Parent = tabContent
            tabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                tabContent.CanvasSize = UDim2.new(0, 0, 0, tabLayout.AbsoluteContentSize.Y + 10)
            end)
            local tab = {
                Button = tabButton,
                Content = tabContent,
                Label = tabLabel,
                Icon = tabIcon,
                Active = false,
                Index = tabIndex
            }
            Utils.AddHoverEffect(tabButton, {
                BackgroundTransparency = 0.1
            }, {
                BackgroundTransparency = 0.3
            })
            tabButton.MouseButton1Click:Connect(function()
                Utils.CreateRipple(tabButton, Mouse.X, Mouse.Y)
                self:SelectTab(tabIndex)
            end)
            table.insert(self.Tabs, tab)
            if #self.Tabs == 1 then
                self:SelectTab(1)
            end
            return self:CreateTabAPI(tab)
        end
        function WindowAPI:SelectTab(index)
            if not self.Tabs[index] then
                return
            end
            for i, tab in ipairs(self.Tabs) do
                if i == index then
                    tab.Active = true
                    tab.Content.Visible = true
                    Utils.Tween(tab.Button, Animations.Fast, {
                        BackgroundTransparency = 0.1
                    })
                    Utils.Tween(tab.Label, Animations.Fast, {
                        TextColor3 = Theme.Text
                    })
                    -- optimized-out if statement
                else
                    tab.Active = false
                    tab.Content.Visible = false
                    Utils.Tween(tab.Button, Animations.Fast, {
                        BackgroundTransparency = 0.3
                    })
                    Utils.Tween(tab.Label, Animations.Fast, {
                        TextColor3 = Theme.TextMuted
                    })
                    -- optimized-out if statement
                end
            end
            self.ActiveTab = self.Tabs[index]
        end
        function WindowAPI:CreateTabAPI(tab)
            local TabAPI = {
                Tab = tab,
                Elements = {}
            }
            function TabAPI:AddLabel(text)
                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, 0, 0, 25)
                label.BackgroundTransparency = 1
                label.Text = text or "Label"
                label.TextColor3 = Theme.Text
                label.TextSize = 16
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.Font = Enum.Font.Gotham
                label.Parent = tab.Content
                table.insert(self.Elements, label)
                return label
            end
            function TabAPI:AddButton(text, callback)
                local button = Instance.new("TextButton")
                button.Size = UDim2.new(1, 0, 0, 35)
                button.BackgroundColor3 = Theme.Primary
                button.BackgroundTransparency = 0.2
                button.BorderSizePixel = 0
                button.Text = text or "Button"
                button.TextColor3 = Theme.Text
                button.TextSize = 16
                button.Font = Enum.Font.GothamMedium
                button.Parent = tab.Content
                local buttonCorner = Instance.new("UICorner")
                buttonCorner.CornerRadius = UDim.new(0, 8)
                buttonCorner.Parent = button
                Utils.AddHoverEffect(button, {
                    BackgroundTransparency = 0.1
                }, {
                    BackgroundTransparency = 0.2
                })
                button.MouseButton1Click:Connect(function()
                    Utils.CreateRipple(button, Mouse.X, Mouse.Y)
                    if callback then
                        callback()
                    end
                end)
                table.insert(self.Elements, button)
                return button
            end
            function TabAPI:AddToggle(text, default, callback)
                local toggleFrame = Instance.new("Frame")
                toggleFrame.Size = UDim2.new(1, 0, 0, 35)
                toggleFrame.BackgroundColor3 = Theme.Surface
                toggleFrame.BackgroundTransparency = 0.3
                toggleFrame.BorderSizePixel = 0
                toggleFrame.Parent = tab.Content
                local toggleCorner = Instance.new("UICorner")
                toggleCorner.CornerRadius = UDim.new(0, 8)
                toggleCorner.Parent = toggleFrame
                local toggleLabel = Instance.new("TextLabel")
                toggleLabel.Size = UDim2.new(1, -50, 1, 0)
                toggleLabel.Position = UDim2.new(0, 15, 0, 0)
                toggleLabel.BackgroundTransparency = 1
                toggleLabel.Text = text or "Toggle"
                toggleLabel.TextColor3 = Theme.Text
                toggleLabel.TextSize = 16
                toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
                toggleLabel.Font = Enum.Font.Gotham
                toggleLabel.Parent = toggleFrame
                local toggleButton = Instance.new("TextButton")
                toggleButton.Size = UDim2.new(0, 30, 0, 18)
                toggleButton.Position = UDim2.new(1, -40, 0.5, -9)
                toggleButton.BackgroundColor3 = default and Theme.Primary or Theme.Border
                toggleButton.BackgroundTransparency = 0.2
                toggleButton.BorderSizePixel = 0
                toggleButton.Text = ""
                toggleButton.Parent = toggleFrame
                local toggleButtonCorner = Instance.new("UICorner")
                toggleButtonCorner.CornerRadius = UDim.new(1, 0)
                toggleButtonCorner.Parent = toggleButton
                local toggleKnob = Instance.new("Frame")
                toggleKnob.Size = UDim2.new(0, 14, 0, 14)
                toggleKnob.Position = default and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
                toggleKnob.BackgroundColor3 = Theme.Text
                toggleKnob.BorderSizePixel = 0
                toggleKnob.Parent = toggleButton
                local knobCorner = Instance.new("UICorner")
                knobCorner.CornerRadius = UDim.new(1, 0)
                knobCorner.Parent = toggleKnob
                local enabled = default or false
                local function updateToggle(state)
                    enabled = state
                    Utils.Tween(toggleButton, Animations.Fast, {
                        BackgroundColor3 = enabled and Theme.Primary or Theme.Border
                    })
                    Utils.Tween(toggleKnob, Animations.Spring, {
                        Position = enabled and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
                    })
                    if callback then
                        callback(enabled)
                    end
                end
                toggleButton.MouseButton1Click:Connect(function()
                    updateToggle(not enabled)
                end)
                table.insert(self.Elements, toggleFrame)
                return {
                    Set = updateToggle,
                    Get = function()
                        return enabled
                    end
                }
            end
            function TabAPI:AddSlider(text, min, max, default, callback)
                min = min or 0
                max = max or 100
                default = default or min
                local sliderFrame = Instance.new("Frame")
                sliderFrame.Size = UDim2.new(1, 0, 0, 50)
                sliderFrame.BackgroundColor3 = Theme.Surface
                sliderFrame.BackgroundTransparency = 0.3
                sliderFrame.BorderSizePixel = 0
                sliderFrame.Parent = tab.Content
                local sliderCorner = Instance.new("UICorner")
                sliderCorner.CornerRadius = UDim.new(0, 8)
                sliderCorner.Parent = sliderFrame
                local sliderLabel = Instance.new("TextLabel")
                sliderLabel.Size = UDim2.new(1, -60, 0, 25)
                sliderLabel.Position = UDim2.new(0, 15, 0, 0)
                sliderLabel.BackgroundTransparency = 1
                sliderLabel.Text = text or "Slider"
                sliderLabel.TextColor3 = Theme.Text
                sliderLabel.TextSize = 16
                sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
                sliderLabel.Font = Enum.Font.Gotham
                sliderLabel.Parent = sliderFrame
                local valueLabel = Instance.new("TextLabel")
                valueLabel.Size = UDim2.new(0, 50, 0, 25)
                valueLabel.Position = UDim2.new(1, -60, 0, 0)
                valueLabel.BackgroundTransparency = 1
                valueLabel.Text = tostring(default)
                valueLabel.TextColor3 = Theme.Primary
                valueLabel.TextSize = 14
                valueLabel.TextXAlignment = Enum.TextXAlignment.Right
                valueLabel.Font = Enum.Font.GothamMedium
                valueLabel.Parent = sliderFrame
                local sliderTrack = Instance.new("Frame")
                sliderTrack.Size = UDim2.new(1, -30, 0, 4)
                sliderTrack.Position = UDim2.new(0, 15, 1, -15)
                sliderTrack.BackgroundColor3 = Theme.Border
                sliderTrack.BorderSizePixel = 0
                sliderTrack.Parent = sliderFrame
                local trackCorner = Instance.new("UICorner")
                trackCorner.CornerRadius = UDim.new(1, 0)
                trackCorner.Parent = sliderTrack
                local sliderFill = Instance.new("Frame")
                sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
                sliderFill.BackgroundColor3 = Theme.Primary
                sliderFill.BorderSizePixel = 0
                sliderFill.Parent = sliderTrack
                local fillCorner = Instance.new("UICorner")
                fillCorner.CornerRadius = UDim.new(1, 0)
                fillCorner.Parent = sliderFill
                local sliderKnob = Instance.new("Frame")
                sliderKnob.Size = UDim2.new(0, 16, 0, 16)
                sliderKnob.Position = UDim2.new((default - min) / (max - min), -8, 0.5, -8)
                sliderKnob.BackgroundColor3 = Theme.Text
                sliderKnob.BorderSizePixel = 0
                sliderKnob.Parent = sliderTrack
                local knobCorner = Instance.new("UICorner")
                knobCorner.CornerRadius = UDim.new(1, 0)
                knobCorner.Parent = sliderKnob
                local knobStroke = Instance.new("UIStroke")
                knobStroke.Color = Theme.Primary
                knobStroke.Thickness = 2
                knobStroke.Parent = sliderKnob
                local currentValue = default
                local dragging = false
                local function updateSlider(value)
                    value = clamp(value, min, max)
                    currentValue = value
                    local percent = (value - min) / (max - min)
                    Utils.Tween(sliderFill, Animations.Fast, {
                        Size = UDim2.new(percent, 0, 1, 0)
                    })
                    Utils.Tween(sliderKnob, Animations.Fast, {
                        Position = UDim2.new(percent, -8, 0.5, -8)
                    })
                    valueLabel.Text = tostring(math.floor(value))
                    if callback then
                        callback(value)
                    end
                end
                sliderTrack.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = true
                        local percent = clamp((Mouse.X - sliderTrack.AbsolutePosition.X) / sliderTrack.AbsoluteSize.X, 0, 1)
                        updateSlider(min + (max - min) * percent)
                    end
                end)
                UserInputService.InputChanged:Connect(function(input)
                    if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and dragging then
                        local percent = clamp((Mouse.X - sliderTrack.AbsolutePosition.X) / sliderTrack.AbsoluteSize.X, 0, 1)
                        updateSlider(min + (max - min) * percent)
                    end
                end)
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = false
                    end
                end)
                table.insert(self.Elements, sliderFrame)
                return {
                    Set = updateSlider,
                    Get = function()
                        return currentValue
                    end
                }
            end
            function TabAPI:AddTextBox(text, placeholder, callback)
                local textboxFrame = Instance.new("Frame")
                textboxFrame.Size = UDim2.new(1, 0, 0, 35)
                textboxFrame.BackgroundColor3 = Theme.Surface
                textboxFrame.BackgroundTransparency = 0.3
                textboxFrame.BorderSizePixel = 0
                textboxFrame.Parent = tab.Content
                local textboxCorner = Instance.new("UICorner")
                textboxCorner.CornerRadius = UDim.new(0, 8)
                textboxCorner.Parent = textboxFrame
                local textbox = Instance.new("TextBox")
                textbox.Size = UDim2.new(1, -20, 1, 0)
                textbox.Position = UDim2.new(0, 10, 0, 0)
                textbox.BackgroundTransparency = 1
                textbox.Text = text or ""
                textbox.PlaceholderText = placeholder or "Enter text..."
                textbox.TextColor3 = Theme.Text
                textbox.PlaceholderColor3 = Theme.TextMuted
                textbox.TextSize = 16
                textbox.TextXAlignment = Enum.TextXAlignment.Left
                textbox.Font = Enum.Font.Gotham
                textbox.ClearTextOnFocus = false
                textbox.Parent = textboxFrame
                local stroke = Instance.new("UIStroke")
                stroke.Color = Theme.Border
                stroke.Thickness = 1
                stroke.Transparency = 0.5
                stroke.Parent = textboxFrame
                textbox.Focused:Connect(function()
                    Utils.Tween(stroke, Animations.Fast, {
                        Color = Theme.Primary,
                        Transparency = 0
                    })
                end)
                textbox.FocusLost:Connect(function(enterPressed)
                    Utils.Tween(stroke, Animations.Fast, {
                        Color = Theme.Border,
                        Transparency = 0.5
                    })
                    if enterPressed and callback then
                        callback(textbox.Text)
                    end
                end)
                table.insert(self.Elements, textboxFrame)
                return textbox
            end
            function TabAPI:AddDropdown(text, options, callback)
                options = options or {}
                local dropdownFrame = Instance.new("Frame")
                dropdownFrame.Size = UDim2.new(1, 0, 0, 35)
                dropdownFrame.BackgroundColor3 = Theme.Surface
                dropdownFrame.BackgroundTransparency = 0.3
                dropdownFrame.BorderSizePixel = 0
                dropdownFrame.ClipsDescendants = false
                dropdownFrame.Parent = tab.Content
                local dropdownCorner = Instance.new("UICorner")
                dropdownCorner.CornerRadius = UDim.new(0, 8)
                dropdownCorner.Parent = dropdownFrame
                local dropdownButton = Instance.new("TextButton")
                dropdownButton.Size = UDim2.new(1, 0, 1, 0)
                dropdownButton.BackgroundTransparency = 1
                dropdownButton.Text = ""
                dropdownButton.Parent = dropdownFrame
                local dropdownLabel = Instance.new("TextLabel")
                dropdownLabel.Size = UDim2.new(1, -40, 1, 0)
                dropdownLabel.Position = UDim2.new(0, 15, 0, 0)
                dropdownLabel.BackgroundTransparency = 1
                dropdownLabel.Text = text or "Select option..."
                dropdownLabel.TextColor3 = Theme.Text
                dropdownLabel.TextSize = 16
                dropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
                dropdownLabel.Font = Enum.Font.Gotham
                dropdownLabel.Parent = dropdownFrame
                local dropdownIcon = Utils.CreateIcon(dropdownFrame, "ChevronDown", UDim2.new(0, 16, 0, 16), UDim2.new(1, -30, 0.5, -8))
                local dropdownContainer = Instance.new("Frame")
                dropdownContainer.Name = "DropdownContainer"
                dropdownContainer.Size = UDim2.new(0, dropdownFrame.AbsoluteSize.X, 0, math.min(#options * 35, 140))
                dropdownContainer.BackgroundTransparency = 1
                dropdownContainer.Visible = false
                dropdownContainer.ZIndex = 9999
                dropdownContainer.Parent = screenGui
                dropdownContainer.ClipsDescendants = false
                local dropdownList = Instance.new("Frame")
                dropdownList.Size = UDim2.new(1, 0, 1, 0)
                dropdownList.BackgroundColor3 = Theme.Background
                dropdownList.BackgroundTransparency = 0.05
                dropdownList.BorderSizePixel = 0
                dropdownList.Parent = dropdownContainer
                dropdownList.ZIndex = 10000
                local shadowFrame = Instance.new("Frame")
                shadowFrame.Size = UDim2.new(1, 8, 1, 8)
                shadowFrame.Position = UDim2.new(0, -4, 0, -4)
                shadowFrame.BackgroundColor3 = Color3.new(0, 0, 0)
                shadowFrame.BackgroundTransparency = 0.8
                shadowFrame.ZIndex = dropdownList.ZIndex - 1
                shadowFrame.Parent = dropdownContainer
                local shadowCorner = Instance.new("UICorner")
                shadowCorner.CornerRadius = UDim.new(0, 12)
                shadowCorner.Parent = shadowFrame
                local scrollFrame = Instance.new("ScrollingFrame")
                scrollFrame.Size = UDim2.new(1, 0, 1, 0)
                scrollFrame.BackgroundTransparency = 1
                scrollFrame.BorderSizePixel = 0
                scrollFrame.ScrollBarThickness = 4
                scrollFrame.ScrollBarImageColor3 = Theme.Border
                scrollFrame.CanvasSize = UDim2.new(0, 0, 0, #options * 35)
                scrollFrame.ScrollingDirection = Enum.ScrollingDirection.Y
                scrollFrame.Parent = dropdownList
                scrollFrame.ZIndex = 10001
                local scrollLayout = Instance.new("UIListLayout")
                scrollLayout.SortOrder = Enum.SortOrder.LayoutOrder
                scrollLayout.Parent = scrollFrame
                local isOpen = false
                local selectedOption = nil
                local function updateDropdownPos()
                    local absPos = dropdownFrame.AbsolutePosition
                    local absSize = dropdownFrame.AbsoluteSize
                    local targetX = absPos.X
                    local targetY = absPos.Y + absSize.Y + 5
                    dropdownContainer.Position = UDim2.new(0, targetX, 0, targetY)
                    dropdownContainer.Size = UDim2.new(0, dropdownFrame.AbsoluteSize.X, 0, math.min(#options * 35, 140))
                end
                RunService.RenderStepped:Connect(function()
                    -- optimized-out if statement
                end)
                for i, option in ipairs(options) do
                    local optionButton = Instance.new("TextButton")
                    optionButton.Size = UDim2.new(1, 0, 0, 35)
                    optionButton.BackgroundColor3 = Theme.Surface
                    optionButton.BackgroundTransparency = 0.9
                    optionButton.Text = option
                    optionButton.TextColor3 = Theme.Text
                    optionButton.TextSize = 14
                    optionButton.TextXAlignment = Enum.TextXAlignment.Left
                    optionButton.Font = Enum.Font.Gotham
                    optionButton.LayoutOrder = i
                    optionButton.BorderSizePixel = 0
                    optionButton.Parent = scrollFrame
                    optionButton.ZIndex = 10002
                    local optionCorner = Instance.new("UICorner")
                    optionCorner.CornerRadius = UDim.new(0, 6)
                    optionCorner.Parent = optionButton
                    local optionPadding = Instance.new("UIPadding")
                    optionPadding.PaddingLeft = UDim.new(0, 15)
                    optionPadding.PaddingRight = UDim.new(0, 15)
                    optionPadding.Parent = optionButton
                    Utils.AddHoverEffect(optionButton, {
                        BackgroundColor3 = Theme.Primary,
                        BackgroundTransparency = 0.7,
                        TextColor3 = Theme.Text
                    }, {
                        BackgroundColor3 = Theme.Surface,
                        BackgroundTransparency = 0.9,
                        TextColor3 = Theme.Text
                    })
                    optionButton.MouseButton1Click:Connect(function()
                        selectedOption = option
                        dropdownLabel.Text = option
                        isOpen = false
                        dropdownContainer.Visible = false
                        Utils.Tween(dropdownIcon, Animations.Fast, {
                            Rotation = 0
                        })
                        if callback then
                            callback(option)
                        end
                    end)
                end
                dropdownButton.MouseButton1Click:Connect(function()
                    isOpen = not isOpen
                    dropdownContainer.Visible = isOpen
                    Utils.Tween(dropdownIcon, Animations.Fast, {
                        Rotation = isOpen and 180 or 0
                    })
                    if isOpen then
                        updateDropdownPos()
                        dropdownContainer.Size = UDim2.new(0, dropdownFrame.AbsoluteSize.X, 0, 0)
                        Utils.Tween(dropdownContainer, Animations.Spring, {
                            Size = UDim2.new(0, dropdownFrame.AbsoluteSize.X, 0, math.min(#options * 35, 140))
                        })
                    end
                end)
                local function closeDropdown()
                    if isOpen then
                        isOpen = false
                        dropdownContainer.Visible = false
                        Utils.Tween(dropdownIcon, Animations.Fast, {
                            Rotation = 0
                        })
                    end
                end
                UserInputService.InputBegan:Connect(function(input, gameProcessed)
                    if not gameProcessed and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
                        if isOpen then
                            local mousePos = Vector2.new(Mouse.X, Mouse.Y)
                            local framePos = dropdownFrame.AbsolutePosition
                            local frameSize = dropdownFrame.AbsoluteSize
                            local containerPos = dropdownContainer.AbsolutePosition
                            local containerSize = dropdownContainer.AbsoluteSize
                            local outsideFrame = mousePos.X < framePos.X or mousePos.X > framePos.X + frameSize.X or mousePos.Y < framePos.Y or mousePos.Y > framePos.Y + frameSize.Y
                            local outsideContainer = mousePos.X < containerPos.X or mousePos.X > containerPos.X + containerSize.X or mousePos.Y < containerPos.Y or mousePos.Y > containerPos.Y + containerSize.Y
                            if outsideFrame and outsideContainer then
                                closeDropdown()
                            end
                        end
                    end
                end)
                table.insert(self.Elements, dropdownFrame)
                return {
                    Set = function(option)
                        selectedOption = option
                        dropdownLabel.Text = option
                    end,
                    Get = function()
                        return selectedOption
                    end,
                    Close = closeDropdown
                }
            end
            return TabAPI
        end
        window.Position = UDim2.new(0, 50 + (windowIndex - 1) * 30, 0, -config.MinSize.Y)
        Utils.Tween(window, Animations.SlideIn, {
            Position = UDim2.new(0, 50 + (windowIndex - 1) * 30, 0, 50 + (windowIndex - 1) * 30)
        })
        table.insert(self.Windows, WindowAPI)
        return WindowAPI
    end
    return UI
end
local ui = EleriumV2.new({
    MainColor = Color3.fromRGB(138, 43, 226),
    ToggleKey = Enum.KeyCode.Insert,
    MinSize = Vector2.new(400, 350)
})
local window = ui:CreateWindow("Elerium V2", {})
local homeTab = window:CreateTab("Home", "Home")
local exampleTab = window:CreateTab("Example", "Puzzle")
local misctab = window:CreateTab("Misc", "Settings")
local settingsTab = window:CreateTab("Settings", "Settings")
homeTab:AddLabel("Welcome to Elerium V2!")
local button = homeTab:AddButton("Test Notification", function()
    ui:Notify("Success!", "Button clicked successfully!", "Success", 3)
end)
local dropdown = homeTab:AddDropdown("Choose theme...", {
    "Dark",
    "Light",
    "Auto",
    "Purple",
    "Blue"
}, function(selected)
    ui:Notify("Theme", "Selected theme: " .. selected, "Info", 2)
end)
local toggle = homeTab:AddToggle("toggle example", false, function(state)
    ui:Notify("Toggle", "Feature " .. (state and "enabled" or "disabled"), state and "Success" or "Warning", 2)
end)
local slider = homeTab:AddSlider("Slider example", 0, 100, 50, function(value)
    print("Slider value set to:", value)
end)
local textbox = homeTab:AddTextBox("", "Enter txt...", function(text)
    if text ~= "" then
        ui:Notify("Hello!", "Nice to meet you, " .. text .. "!", "Info", 4)
    end
end)
settingsTab:AddLabel("Settings Panel")
settingsTab:AddButton("Reset All", function()
    ui:Notify("Reset", "All settings have been reset!", "Warning", 3)
end)
local autoSave = settingsTab:AddToggle("Auto Save", true, function(state)
    print("Auto save:", state)
end)
return EleriumV2