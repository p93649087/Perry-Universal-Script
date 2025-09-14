-- Universal Script by Perry
-- Roblox GUI Script für dein Game

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Variables für Features
local speedEnabled = false
local infiniteJumpEnabled = false
local godmodeEnabled = false
local noclipEnabled = false
local showAllPlayers = false
local showPlayerDistance = false
local playerColor = Color3.fromRGB(255, 105, 180) -- Pink default

-- Geschwindigkeit und Sprung Werte
local currentSpeed = 16
local humanoid = nil
local character = nil

-- GUI Erstellung
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "UniversalScriptGUI"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false

-- Main Frame (dunkelgrau, cool aussehend)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 600, 0, 450)
mainFrame.Position = UDim2.new(0.5, -300, 0.5, -225)
mainFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Parent = screenGui

-- Rundung für Main Frame
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent = mainFrame

-- Schatten Effect
local shadow = Instance.new("Frame")
shadow.Size = UDim2.new(1, 10, 1, 10)
shadow.Position = UDim2.new(0, -5, 0, -5)
shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
shadow.BackgroundTransparency = 0.5
shadow.ZIndex = mainFrame.ZIndex - 1
shadow.Parent = mainFrame

local shadowCorner = Instance.new("UICorner")
shadowCorner.CornerRadius = UDim.new(0, 10)
shadowCorner.Parent = shadow

-- Title Label mit Regenbogen Effect
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(0, 200, 0, 30)
titleLabel.Position = UDim2.new(0, 20, 0, 10)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Universal Script"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.Parent = mainFrame

-- Subtitle
local subtitleLabel = Instance.new("TextLabel")
subtitleLabel.Size = UDim2.new(0, 200, 0, 20)
subtitleLabel.Position = UDim2.new(0, 20, 0, 40)
subtitleLabel.BackgroundTransparency = 1
subtitleLabel.Text = "by Perry"
subtitleLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
subtitleLabel.TextScaled = true
subtitleLabel.Font = Enum.Font.SourceSans
subtitleLabel.Parent = mainFrame

-- Regenbogen Effect für Title
local function rainbowEffect()
    local hue = 0
    while titleLabel.Parent do
        hue = (hue + 1) % 360
        titleLabel.TextColor3 = Color3.fromHSV(hue / 360, 1, 1)
        wait(0.05)
    end
end

spawn(rainbowEffect)

-- Close Button
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -40, 0, 10)
closeButton.BackgroundColor3 = Color3.fromRGB(220, 20, 20)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextScaled = true
closeButton.Font = Enum.Font.SourceSansBold
closeButton.Parent = mainFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 5)
closeCorner.Parent = closeButton

-- Left Menu Frame
local leftMenu = Instance.new("Frame")
leftMenu.Size = UDim2.new(0, 150, 1, -80)
leftMenu.Position = UDim2.new(0, 10, 0, 70)
leftMenu.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
leftMenu.BorderSizePixel = 0
leftMenu.Parent = mainFrame

local leftCorner = Instance.new("UICorner")
leftCorner.CornerRadius = UDim.new(0, 8)
leftCorner.Parent = leftMenu

-- Right Content Frame
local rightContent = Instance.new("ScrollingFrame")
rightContent.Size = UDim2.new(0, 420, 1, -80)
rightContent.Position = UDim2.new(0, 170, 0, 70)
rightContent.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
rightContent.BorderSizePixel = 0
rightContent.ScrollBarThickness = 8
rightContent.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
rightContent.Parent = mainFrame

local rightCorner = Instance.new("UICorner")
rightCorner.CornerRadius = UDim.new(0, 8)
rightCorner.Parent = rightContent

-- Menu Buttons
local menuButtons = {}
local currentCategory = "Player"

local function createMenuButton(text, category)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -10, 0, 40)
    button.Position = UDim2.new(0, 5, 0, #menuButtons * 45 + 10)
    button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextScaled = true
    button.Font = Enum.Font.SourceSans
    button.Parent = leftMenu
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 5)
    buttonCorner.Parent = button
    
    button.MouseButton1Click:Connect(function()
        currentCategory = category
        updateContent()
        -- Button highlight effect
        for _, btn in pairs(menuButtons) do
            btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        end
        button.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    end)
    
    table.insert(menuButtons, button)
    return button
end

-- Create Menu Buttons
createMenuButton("Player", "Player")
createMenuButton("UI", "UI")
createMenuButton("Game", "Game")

-- Utility Functions
local function createToggleButton(parent, text, position, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 100, 0, 30)
    button.Position = position
    button.BackgroundColor3 = Color3.fromRGB(220, 20, 20)
    button.Text = "OFF"
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextScaled = true
    button.Font = Enum.Font.SourceSans
    button.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 5)
    corner.Parent = button
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 200, 0, 30)
    label.Position = UDim2.new(0, -210, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextScaled = true
    label.Font = Enum.Font.SourceSans
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = button
    
    local isEnabled = false
    button.MouseButton1Click:Connect(function()
        isEnabled = not isEnabled
        if isEnabled then
            button.BackgroundColor3 = Color3.fromRGB(20, 220, 20)
            button.Text = "ON"
        else
            button.BackgroundColor3 = Color3.fromRGB(220, 20, 20)
            button.Text = "OFF"
        end
        callback(isEnabled)
    end)
    
    return button
end

local function createSlider(parent, text, position, minVal, maxVal, defaultVal, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 300, 0, 50)
    frame.Position = position
    frame.BackgroundTransparency = 1
    frame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 200, 0, 25)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. defaultVal
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextScaled = true
    label.Font = Enum.Font.SourceSans
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local slider = Instance.new("Frame")
    slider.Size = UDim2.new(0, 200, 0, 20)
    slider.Position = UDim2.new(0, 0, 0, 25)
    slider.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    slider.Parent = frame
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 10)
    sliderCorner.Parent = slider
    
    local handle = Instance.new("Frame")
    handle.Size = UDim2.new(0, 20, 1, 0)
    handle.Position = UDim2.new((defaultVal - minVal) / (maxVal - minVal), -10, 0, 0)
    handle.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    handle.Parent = slider
    
    local handleCorner = Instance.new("UICorner")
    handleCorner.CornerRadius = UDim.new(1, 0)
    handleCorner.Parent = handle
    
    local dragging = false
    
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mouse = game.Players.LocalPlayer:GetMouse()
            local sliderPos = slider.AbsolutePosition.X
            local sliderSize = slider.AbsoluteSize.X
            local mouseX = mouse.X
            
            local relativeX = math.clamp(mouseX - sliderPos, 0, sliderSize)
            local percentage = relativeX / sliderSize
            
            handle.Position = UDim2.new(percentage, -10, 0, 0)
            
            local value = math.floor(minVal + percentage * (maxVal - minVal))
            label.Text = text .. ": " .. value
            callback(value)
        end
    end)
end

-- Content Update Function
function updateContent()
    -- Clear existing content
    for _, child in pairs(rightContent:GetChildren()) do
        if child:IsA("GuiObject") then
            child:Destroy()
        end
    end
    
    rightContent.CanvasSize = UDim2.new(0, 0, 0, 0)
    
    if currentCategory == "Player" then
        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, 0, 0, 40)
        title.Position = UDim2.new(0, 0, 0, 10)
        title.BackgroundTransparency = 1
        title.Text = "PLAYER"
        title.TextColor3 = Color3.fromRGB(255, 255, 255)
        title.TextScaled = true
        title.Font = Enum.Font.SourceSansBold
        title.Parent = rightContent
        
        -- Speed Slider
        createSlider(rightContent, "Speed", UDim2.new(0, 20, 0, 60), 1, 200, 16, function(value)
            currentSpeed = value
            if character and humanoid then
                humanoid.WalkSpeed = speedEnabled and value or 16
            end
        end)
        
        -- Infinite Jump Toggle
        createToggleButton(rightContent, "Infinite Jump", UDim2.new(0, 320, 0, 120), function(enabled)
            infiniteJumpEnabled = enabled
        end)
        
        -- Godmode Toggle
        createToggleButton(rightContent, "Godmode", UDim2.new(0, 320, 0, 160), function(enabled)
            godmodeEnabled = enabled
            if character then
                local humanoid = character:FindFirstChild("Humanoid")
                if humanoid then
                    if enabled then
                        humanoid.MaxHealth = math.huge
                        humanoid.Health = math.huge
                    else
                        humanoid.MaxHealth = 100
                        humanoid.Health = 100
                    end
                end
            end
        end)
        
        -- Noclip Toggle
        createToggleButton(rightContent, "Noclip", UDim2.new(0, 320, 0, 200), function(enabled)
            noclipEnabled = enabled
        end)
        
        rightContent.CanvasSize = UDim2.new(0, 0, 0, 250)
        
    elseif currentCategory == "UI" then
        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, 0, 0, 40)
        title.Position = UDim2.new(0, 0, 0, 10)
        title.BackgroundTransparency = 1
        title.Text = "UI"
        title.TextColor3 = Color3.fromRGB(255, 255, 255)
        title.TextScaled = true
        title.Font = Enum.Font.SourceSansBold
        title.Parent = rightContent
        
        -- Show All Players Toggle
        createToggleButton(rightContent, "Show All Players", UDim2.new(0, 320, 0, 60), function(enabled)
            showAllPlayers = enabled
            updatePlayerHighlights()
        end)
        
        -- Show Player Distance Toggle
        createToggleButton(rightContent, "Show Player Distance", UDim2.new(0, 320, 0, 100), function(enabled)
            showPlayerDistance = enabled
        end)
        
        -- Color Picker (vereinfacht)
        local colorButton = Instance.new("TextButton")
        colorButton.Size = UDim2.new(0, 100, 0, 30)
        colorButton.Position = UDim2.new(0, 320, 0, 140)
        colorButton.BackgroundColor3 = playerColor
        colorButton.Text = "Color: Pink"
        colorButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        colorButton.TextScaled = true
        colorButton.Font = Enum.Font.SourceSans
        colorButton.Parent = rightContent
        
        local colorCorner = Instance.new("UICorner")
        colorCorner.CornerRadius = UDim.new(0, 5)
        colorCorner.Parent = colorButton
        
        local colors = {
            {Color3.fromRGB(255, 105, 180), "Pink"},
            {Color3.fromRGB(255, 0, 0), "Red"},
            {Color3.fromRGB(0, 255, 0), "Green"},
            {Color3.fromRGB(0, 0, 255), "Blue"},
            {Color3.fromRGB(255, 255, 0), "Yellow"}
        }
        local colorIndex = 1
        
        colorButton.MouseButton1Click:Connect(function()
            colorIndex = (colorIndex % #colors) + 1
            playerColor = colors[colorIndex][1]
            colorButton.BackgroundColor3 = playerColor
            colorButton.Text = "Color: " .. colors[colorIndex][2]
            updatePlayerHighlights()
        end)
        
        rightContent.CanvasSize = UDim2.new(0, 0, 0, 200)
        
    elseif currentCategory == "Game" then
        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, 0, 0, 40)
        title.Position = UDim2.new(0, 0, 0, 10)
        title.BackgroundTransparency = 1
        title.Text = "GAME FEATURES"
        title.TextColor3 = Color3.fromRGB(255, 255, 255)
        title.TextScaled = true
        title.Font = Enum.Font.SourceSansBold
        title.Parent = rightContent
        
        -- Hier kannst du weitere Game-spezifische Features hinzufügen
        local comingSoon = Instance.new("TextLabel")
        comingSoon.Size = UDim2.new(1, 0, 0, 40)
        comingSoon.Position = UDim2.new(0, 0, 0, 60)
        comingSoon.BackgroundTransparency = 1
        comingSoon.Text = "Game-specific features can be added here..."
        comingSoon.TextColor3 = Color3.fromRGB(150, 150, 150)
        comingSoon.TextScaled = true
        comingSoon.Font = Enum.Font.SourceSans
        comingSoon.Parent = rightContent
        
        rightContent.CanvasSize = UDim2.new(0, 0, 0, 120)
    end
end

-- Player Highlight Functions
function updatePlayerHighlights()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer and player.Character then
            local highlight = player.Character:FindFirstChild("PlayerHighlight")
            
            if showAllPlayers then
                if not highlight then
                    highlight = Instance.new("Highlight")
                    highlight.Name = "PlayerHighlight"
                    highlight.Parent = player.Character
                end
                highlight.FillColor = playerColor
                highlight.OutlineColor = playerColor
                highlight.FillTransparency = 0.5
                highlight.OutlineTransparency = 0
            else
                if highlight then
                    highlight:Destroy()
                end
            end
        end
    end
end

-- Character Setup
local function onCharacterAdded(char)
    character = char
    humanoid = char:WaitForChild("Humanoid")
    
    -- Speed anwenden
    if speedEnabled then
        humanoid.WalkSpeed = currentSpeed
    end
    
    -- Infinite Jump Setup
    humanoid.JumpRequest:Connect(function()
        if infiniteJumpEnabled then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)
end

-- Player Setup
if player.Character then
    onCharacterAdded(player.Character)
end
player.CharacterAdded:Connect(onCharacterAdded)

-- Noclip Function
RunService.Stepped:Connect(function()
    if noclipEnabled and character then
        for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    elseif character then
        for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.CanCollide = true
            end
        end
    end
end)

-- Toggle GUI Visibility
local function toggleGUI()
    mainFrame.Visible = not mainFrame.Visible
    if mainFrame.Visible then
        updateContent()
        menuButtons[1].BackgroundColor3 = Color3.fromRGB(0, 120, 255) -- Highlight first button
    end
end

-- Open Button (klein und diskret)
local openButton = Instance.new("TextButton")
openButton.Size = UDim2.new(0, 80, 0, 30)
openButton.Position = UDim2.new(0, 10, 0, 10)
openButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
openButton.BackgroundTransparency = 0.3
openButton.Text = "Menu"
openButton.TextColor3 = Color3.fromRGB(255, 255, 255)
openButton.TextScaled = true
openButton.Font = Enum.Font.SourceSans
openButton.Parent = screenGui

local openCorner = Instance.new("UICorner")
openCorner.CornerRadius = UDim.new(0, 5)
openCorner.Parent = openButton

-- Event Connections
openButton.MouseButton1Click:Connect(toggleGUI)
closeButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
end)

-- Keyboard Toggle (F3)
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.F3 then
        toggleGUI()
    end
end)

-- Player Events
Players.PlayerAdded:Connect(function()
    wait(1)
    updatePlayerHighlights()
end)

Players.PlayerRemoving:Connect(function()
    wait(1)
    updatePlayerHighlights()
end)

-- Initial Setup
updateContent()
menuButtons[1].BackgroundColor3 = Color3.fromRGB(0, 120, 255)

print("Universal Script by Perry - Loaded Successfully!")
print("Press F3 or click the Menu button to open/close the GUI")
