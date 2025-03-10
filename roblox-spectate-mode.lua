local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local CoreGui = game:GetService("CoreGui")

local searchFilter = ""

function generateRandomName()
    local charset = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local name = ""
    for i = 1, 10 do
        local rand = math.random(1, #charset)
        name = name .. charset:sub(rand, rand)
    end
    return name
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = generateRandomName()
ScreenGui.Parent = CoreGui

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 300, 0, 320)
Frame.Position = UDim2.new(0, 20, 0, 100)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Frame.BackgroundTransparency = 0.3
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 8)
frameCorner.Parent = Frame

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 18
CloseButton.Parent = Frame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = CloseButton

CloseButton.MouseButton1Click:Connect(function()
	ScreenGui:Destroy()
end)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -40, 0, 50)
Title.Position = UDim2.new(0, 5, 0, 5)
Title.Text = "👁️ Spectate Mode"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.Parent = Frame

local SearchBox = Instance.new("TextBox")
SearchBox.Size = UDim2.new(1, -10, 0, 30)
SearchBox.Position = UDim2.new(0, 5, 0, 60)
SearchBox.PlaceholderText = "Search..."
SearchBox.Text = ""
SearchBox.ClearTextOnFocus = false
SearchBox.Font = Enum.Font.Gotham
SearchBox.TextSize = 14
SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SearchBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
SearchBox.BackgroundTransparency = 0.3
SearchBox.Parent = Frame

local searchCorner = Instance.new("UICorner")
searchCorner.CornerRadius = UDim.new(0, 8)
searchCorner.Parent = SearchBox

local CreatorLabel = Instance.new("TextLabel")
CreatorLabel.Size = UDim2.new(1, 0, 0, 20)
CreatorLabel.Position = UDim2.new(0.5, 0, 1, -25)
CreatorLabel.AnchorPoint = Vector2.new(0.5, 0)
CreatorLabel.Text = "Made by bed0c (https://github.com/bed0c)"
CreatorLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
CreatorLabel.BackgroundTransparency = 1
CreatorLabel.Font = Enum.Font.Gotham
CreatorLabel.TextSize = 14
CreatorLabel.TextXAlignment = Enum.TextXAlignment.Center
CreatorLabel.Parent = Frame

local PlayerList = Instance.new("ScrollingFrame")
PlayerList.Size = UDim2.new(1, -10, 0, 180)
PlayerList.Position = UDim2.new(0, 5, 0, 95)
PlayerList.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
PlayerList.BackgroundTransparency = 0.2
PlayerList.BorderSizePixel = 0
PlayerList.Parent = Frame

local listCorner = Instance.new("UICorner")
listCorner.CornerRadius = UDim.new(0, 8)
listCorner.Parent = PlayerList

local listLayout = Instance.new("UIListLayout")
listLayout.Parent = PlayerList
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0, 5)
listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    PlayerList.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y)
end)

local StopButton = Instance.new("TextButton")
StopButton.Size = UDim2.new(1, -10, 0, 40)
StopButton.Position = UDim2.new(0, 5, 1, -70)
StopButton.Text = "❌ Stop Spectating"
StopButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
StopButton.TextColor3 = Color3.fromRGB(255, 255, 255)
StopButton.Font = Enum.Font.GothamBold
StopButton.TextSize = 16
StopButton.Parent = Frame
StopButton.Visible = false

local stopCorner = Instance.new("UICorner")
stopCorner.CornerRadius = UDim.new(0, 8)
stopCorner.Parent = StopButton

local spectating = false
local spectatedPlayer = nil

function UpdatePlayerList()
    for _, v in pairs(PlayerList:GetChildren()) do
        if v:IsA("TextButton") then
            v:Destroy()
        end
    end

    local players = Players:GetPlayers()
    table.sort(players, function(a, b)
        return a.Name < b.Name
    end)

    local order = 1
    for _, player in ipairs(players) do
        if player ~= LocalPlayer then
            local displayText = player.DisplayName .. " (@" .. player.Name .. ")"
            if searchFilter == "" or string.find(string.lower(displayText), string.lower(searchFilter)) then
                local Button = Instance.new("TextButton")
                Button.Size = UDim2.new(1, -10, 0, 40)
                Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                Button.Font = Enum.Font.Gotham
                Button.TextSize = 14
                Button.LayoutOrder = order
                order = order + 1
                Button.Parent = PlayerList

                local btnCorner = Instance.new("UICorner")
                btnCorner.CornerRadius = UDim.new(0, 8)
                btnCorner.Parent = Button

                Button.TextColor3 = Color3.fromRGB(255, 255, 255)
                Button.Text = displayText
                Button.TextXAlignment = Enum.TextXAlignment.Center
                Button.TextYAlignment = Enum.TextYAlignment.Center

                local padding = Instance.new("UIPadding")
                padding.PaddingLeft = UDim.new(0, 10)
                padding.PaddingRight = UDim.new(0, 10)
                padding.Parent = Button

                Button.MouseButton1Click:Connect(function()
                    SpectatePlayer(player)
                end)
            end
        end
    end
end

Players.PlayerAdded:Connect(UpdatePlayerList)
Players.PlayerRemoving:Connect(UpdatePlayerList)
UpdatePlayerList()

SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    searchFilter = SearchBox.Text
    UpdatePlayerList()
end)

function SpectatePlayer(player)
    if player and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
        spectating = true
        spectatedPlayer = player
        Camera.CameraSubject = player.Character:FindFirstChildOfClass("Humanoid")
        StopButton.Visible = true
    end
end

function StopSpectate()
    spectating = false
    spectatedPlayer = nil
    if LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            Camera.CameraSubject = humanoid
        end
    end
    StopButton.Visible = false
end

StopButton.MouseButton1Click:Connect(StopSpectate)

local dragging
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

Frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)
