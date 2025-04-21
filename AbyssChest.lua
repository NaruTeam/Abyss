--// Cat Hub Chest Farm Script for Blox Fruits
--// Created by Catdzs1vn - discord: catdzs1vn - Fb: Bùi Now Quý

--// Get World
if game.PlaceId == 2753915549 then
    World1 = true
elseif game.PlaceId == 4442272183 then
    World2 = true
elseif game.PlaceId == 7449423635 then
    World3 = true
end
--// Configuration
getgenv().mmb = {
    setting = {
        ["Select Team"] = "Marines", --// Select Pirates Or Marines
        ["TweenSpeed"] = 350, --// Movement speed
        ["Standing on the water"] = true,  --// Standing on the water
        ["Remove Notify Game"] = true, --// Turn off game notifications 
        ["Rejoin When kicked"] = true, --// Auto rejoin when you get kicked
        ["Anti-Afk"] = true  --// Anti-AFK
    },
    ChestSettings = {
        ["Esp Chest"] = true, --// ESP entire Chest        
        ["Start Farm Chest"] = {
            ["Enable"] = true, --// Turn on farm chest 
            ["lock money"] = 1000000000, --// Amount of money to stop
            ["Hop After Collected"] = "All" --// Enter the Number of Chests you want to pick up like "Number" Or "All"
        },
        ["Stop When Have God's Chalice & Fist Of Darkness"] = { 
            ["Enable"] = true, --// Stop when you have God's Chalice & Fist Of Darkness 
            ["Automatically move to safety"] = false --// When you have God's Chalice & Fist Of Darkness it will automatically move to a safe place 
        },
    },
    RaceCyborg = {
        ["Auto get race Cyborg"] = true,
        ["Upgrade Race: V2/V3"] = false
    },
    Webhook = {
        ["send Webhook"] = false, --// Send Webhook Auto Setup
        ["Url Webhook"] = "", --// Link Url Webhook
        ["UserId"] = "" --// Id Discord You
    }
}
--// Join Team 
local teamToSelect = getgenv().mmb.setting["Select Team"] or "Pirates"
while not game.Players.LocalPlayer.Team do
    local success, err = pcall(function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetTeam", teamToSelect)
    end)
    if success then print("Joined team: " .. teamToSelect) else warn("Ngu: ", err) end
    task.wait(1)
end

--// Setup 
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CollectionService = game:GetService("CollectionService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local CoreGui = game:GetService("CoreGui")
local PathfindingService = game:GetService("PathfindingService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

local oldBeli = player.Data.Beli.Value or 0
local earnedBeli = 0
local chestCount = 0
local startTime = os.time()
local isHopping = false
local activeTweens = {}
local activeESPs = {}

-- Utility functions
local function FormatNumber(number)
    return tostring(number):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
end

local function FormatTime(seconds)
    local hours = math.floor(seconds / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    local secs = seconds % 60
    return string.format("%02d:%02d:%02d", hours, minutes, secs)
end
--//Idk
--// ESP
local espFolder = Instance.new("Folder")
espFolder.Name = "ChestESP"
espFolder.Parent = game:GetService("CoreGui")

local colorModes = {
    Rainbow = function(t) return Color3.fromRGB(math.sin(t * 2) * 127 + 128, math.sin(t * 2 + 2 * math.pi / 3) * 127 + 128, math.sin(t * 2 + 4 * math.pi / 3) * 127 + 128) end,
    Fire = function(t) return Color3.fromRGB(math.min(255, math.sin(t * 2) * 200 + 155), math.min(255, math.sin(t * 2 + 2) * 100 + 55), math.sin(t * 2 + 4) * 50) end,
    Ocean = function(t) return Color3.fromRGB(math.sin(t * 2 + 2) * 50 + 50, math.sin(t * 2 + 4) * 100 + 100, math.min(255, math.sin(t * 2) * 155 + 100)) end,
    Galaxy = function(t) return Color3.fromRGB(math.sin(t * 2) * 100 + 155, math.sin(t * 2 + 2) * 50 + 100, math.min(255, math.sin(t * 2 + 4) * 150 + 105)) end
}

local spinStyles = {
    Spin = function(box, basePosition, time) box.CFrame = CFrame.new(basePosition + Vector3.new(0, math.sin(time * 2) * 0.3, 0)) * CFrame.Angles(0, math.rad(time * 50), 0) end,
    Wobble = function(box, basePosition, time) box.CFrame = CFrame.new(basePosition + Vector3.new(math.cos(time * 2) * 0.1, math.sin(time * 1.5) * 0.2, 0)) * CFrame.Angles(math.sin(time * 1.5) * 0.3, math.cos(time * 2) * 0.2, math.sin(time * 1.8) * 0.25) end,
    Wave = function(box, basePosition, time) box.CFrame = CFrame.new(basePosition + Vector3.new(0, math.sin(time * 3) * 0.25, 0)) * CFrame.Angles(math.sin(time * 2) * 0.4, 0, math.cos(time * 2) * 0.4) end,
    Chaos = function(box, basePosition, time) box.CFrame = CFrame.new(basePosition + Vector3.new(math.sin(time * 2) * 0.15, math.cos(time * 1.5) * 0.2, math.sin(time * 1.8) * 0.1)) * CFrame.Angles(math.noise(time * 0.8, basePosition.X) * math.pi, math.noise(time * 0.8, basePosition.Y) * math.pi, math.noise(time * 0.8, basePosition.Z) * math.pi) end
}

local activeESPs = {}
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")
local CollectionService = game:GetService("CollectionService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local function getRandomColorMode()
    local modes = {"Rainbow", "Fire", "Ocean", "Galaxy"}
    return colorModes[modes[math.random(1, #modes)]]
end

local function getRandomSpinStyle()
    local styles = {"Spin", "Wobble", "Wave", "Chaos"}
    return spinStyles[styles[math.random(1, #styles)]]
end

local function createAdvanced3DBox(chest)
    local container = Instance.new("Model")
    container.Parent = espFolder
    
    local box = Instance.new("Part")
    box.Anchored = true
    box.CanCollide = false
    box.Transparency = 0.4
    box.Material = Enum.Material.Neon
    box.Size = chest.Size + Vector3.new(0.6, 0.6, 0.6)
    box.Position = chest.Position
    box.Parent = container

    local outline = Instance.new("SelectionBox")
    outline.Adornee = box
    outline.LineThickness = 0.05
    outline.Transparency = 0
    outline.Parent = box

    local particle = Instance.new("ParticleEmitter")
    particle.Texture = "rbxassetid://287137913"
    particle.Size = NumberSequence.new(0.2)
    particle.Transparency = NumberSequence.new(0.5)
    particle.Lifetime = NumberRange.new(0.5, 1)
    particle.Rate = 5
    particle.Speed = NumberRange.new(1, 2)
    particle.Parent = box

    local spinStyle = getRandomSpinStyle()
    local basePosition = chest.Position

    local connection = RunService.Heartbeat:Connect(function()
        if box.Parent then 
            spinStyle(box, basePosition, tick())
        else
            connection:Disconnect()
        end
    end)

    return container, box, outline, particle, connection
end

local function findClosestChest()
    if not character or not humanoidRootPart then return nil end
    
    local playerPos = humanoidRootPart.Position
    local closestChest, minDist = nil, math.huge

    for _, chest in ipairs(CollectionService:GetTagged("_ChestTagged")) do
        if chest and chest.Parent and not chest:GetAttribute("IsDisabled") then
            local dist = (chest:GetPivot().Position - playerPos).Magnitude
            if dist < minDist then
                minDist = dist
                closestChest = chest
            end
        end
    end
    return closestChest, minDist
end

local function updateOrCreateESP(chest)
    if not chest then return end
    
    local espID = chest:FindFirstChild("ESP_ID")
    local id = espID and espID.Value or HttpService:GenerateGUID(false)
    local espData = activeESPs[id]

    if not espData then
        if not espID then
            espID = Instance.new("StringValue")
            espID.Name = "ESP_ID"
            espID.Value = id
            espID.Parent = chest
        end

        local billboard = Instance.new("BillboardGui")
        billboard.Name = "ChestESP_" .. id
        billboard.Adornee = chest
        billboard.Size = UDim2.new(0, 50, 0, 20)
        billboard.StudsOffset = Vector3.new(0, 2.5, 0)
        billboard.AlwaysOnTop = true
        billboard.Parent = espFolder

        local label = Instance.new("TextLabel")
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(1, 0, 1, 0)
        label.Font = Enum.Font.GothamBold
        label.TextSize = 14
        label.TextStrokeTransparency = 0.5
        label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        label.Parent = billboard

        local highlight = Instance.new("Highlight")
        highlight.Name = "ChestHighlight_" .. id
        highlight.Adornee = chest
        highlight.FillTransparency = 0.7
        highlight.OutlineTransparency = 0
        highlight.Parent = espFolder

        local container, box, outline, particle, connection = createAdvanced3DBox(chest)
        local colorMode = getRandomColorMode()

        activeESPs[id] = {
            ID = id,
            Billboard = billboard,
            Container = container,
            Box = box,
            Outline = outline,
            Particle = particle,
            Label = label,
            Highlight = highlight,
            ColorMode = colorMode,
            LastColorUpdate = tick(),
            LastDistanceUpdate = tick(),
            Connection = connection
        }
    end
    
    local espData = activeESPs[id]
    local currentTime = tick()
    local chestPos = chest:GetPivot().Position
    local playerPos = character and humanoidRootPart and humanoidRootPart.Position or Vector3.new()
    local distance = (chestPos - playerPos).Magnitude / 3
    local closestChest = findClosestChest()

    espData.Label.Text = math.floor(distance) .. "m" .. (chest == closestChest and " ↓" or "")
    local color = espData.ColorMode(currentTime)
    espData.Label.TextColor3 = color
    espData.Box.Color = color
    espData.Outline.Color3 = color
    espData.Particle.Color = ColorSequence.new(color)
    espData.Highlight.OutlineColor = color

    return id
end

local function cleanupESP(id)
    local espData = activeESPs[id]
    if espData then
        if espData.Connection then espData.Connection:Disconnect() end
        if espData.Billboard then espData.Billboard:Destroy() end
        if espData.Container then espData.Container:Destroy() end
        if espData.Highlight then espData.Highlight:Destroy() end
        activeESPs[id] = nil
    end
end

spawn(function()
    local lastFullUpdate = tick()
    while task.wait(0.1) do
        if not getgenv().mmb.ChestSettings["Esp Chest"] then
            for id in pairs(activeESPs) do cleanupESP(id) end
            break
        end

        local currentTime = tick()
        if currentTime - lastFullUpdate >= 0.5 then
            local success, err = pcall(function()
                local chests = CollectionService:GetTagged("_ChestTagged")
                local processedIDs = {}

                for _, chest in ipairs(chests) do
                    if chest and chest.Parent and not chest:GetAttribute("IsDisabled") then
                        local id = updateOrCreateESP(chest)
                        if id then processedIDs[id] = true end
                    end
                end

                for id in pairs(activeESPs) do
                    if not processedIDs[id] then cleanupESP(id) end
                end
            end)
            
            if not success then warn("ESP Error: " .. tostring(err)) end
            lastFullUpdate = currentTime
        end
    end
end)

player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoidRootPart = newChar:WaitForChild("HumanoidRootPart")
    humanoid = newChar:WaitForChild("Humanoid")
end)

--// Chat
local ChatService = game:GetService("Chat")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local messages = {
    "Abyss Chest Farm On Top",
    "Easy Beli",
    "Abyss Hub So 1 VN"
}

local function localChat()
    while true do
        for i = 1, 3 do
            local message = messages[i]
            ChatService:Chat(player.Character and player.Character:FindFirstChild("Head") or nil, message, Enum.ChatColor.White)
            wait(5)
        end
        wait(5)
    end
end

spawn(localChat)
--// GuiHop +100 real soucre Gui + Ui by: Catdzs1vn 100%
local function CreateHopUI()
    local HopGui = Instance.new("ScreenGui")
    HopGui.Name = "HopGui"
    HopGui.DisplayOrder = 20
    HopGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    HopGui.Parent = CoreGui

    local Blur = Instance.new("BlurEffect")
    Blur.Name = "HopBlur"
    Blur.Size = 0
    Blur.Parent = game.Lighting

    local HopFrame = Instance.new("Frame")
    HopFrame.Name = "HopFrame"
    HopFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    HopFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    HopFrame.BorderSizePixel = 0
    HopFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    HopFrame.Size = UDim2.new(0, 320, 0, 220)
    HopFrame.BackgroundTransparency = 1
    HopFrame.Rotation = 0
    HopFrame.Parent = HopGui

    local HopCorner = Instance.new("UICorner")
    HopCorner.CornerRadius = UDim.new(0, 15)
    HopCorner.Parent = HopFrame

    local Glow = Instance.new("ImageLabel")
    Glow.Name = "Glow"
    Glow.Image = "rbxassetid://5028857084"
    Glow.ImageColor3 = Color3.fromRGB(0, 255, 255)
    Glow.ImageTransparency = 0.7
    Glow.BackgroundTransparency = 1
    Glow.Size = UDim2.new(1, 60, 1, 60)
    Glow.Position = UDim2.new(0.5, 0, 0.5, 0)
    Glow.AnchorPoint = Vector2.new(0.5, 0.5)
    Glow.ZIndex = 0
    Glow.Parent = HopFrame

    local ShadowHolder = Instance.new("Frame")
    ShadowHolder.Name = "ShadowHolder"
    ShadowHolder.BackgroundTransparency = 1
    ShadowHolder.Size = UDim2.new(1, 0, 1, 0)
    ShadowHolder.ZIndex = -1
    ShadowHolder.Parent = HopFrame

    local Shadow = Instance.new("ImageLabel")
    Shadow.Name = "Shadow"
    Shadow.Image = "rbxassetid://6015897843"
    Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.ImageTransparency = 0.4
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(49, 49, 450, 450)
    Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    Shadow.BackgroundTransparency = 1
    Shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    Shadow.Size = UDim2.new(1, 70, 1, 70)
    Shadow.Parent = ShadowHolder

    local ParticleEmitter = Instance.new("ParticleEmitter")
    ParticleEmitter.Texture = "rbxassetid://243098098"
    ParticleEmitter.Color = ColorSequence.new(Color3.fromRGB(0, 255, 255))
    ParticleEmitter.Size = NumberSequence.new(0.2, 0)
    ParticleEmitter.Transparency = NumberSequence.new(0.5, 1)
    ParticleEmitter.Lifetime = NumberRange.new(1, 2)
    ParticleEmitter.Rate = 20
    ParticleEmitter.Speed = NumberRange.new(2, 5)
    ParticleEmitter.SpreadAngle = Vector2.new(360, 360)
    ParticleEmitter.Parent = HopFrame

    local HopTitle = Instance.new("TextLabel")
    HopTitle.Name = "HopTitle"
    HopTitle.Text = "Server Hop"
    HopTitle.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Heavy)
    HopTitle.TextColor3 = Color3.fromRGB(0, 255, 255)
    HopTitle.TextSize = 24
    HopTitle.BackgroundTransparency = 1
    HopTitle.Position = UDim2.new(0, 10, 0, 10)
    HopTitle.Size = UDim2.new(1, -20, 0, 40)
    HopTitle.TextXAlignment = Enum.TextXAlignment.Center
    HopTitle.Parent = HopFrame

    local ProgressBarFrame = Instance.new("Frame")
    ProgressBarFrame.Name = "ProgressBarFrame"
    ProgressBarFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    ProgressBarFrame.BorderSizePixel = 0
    ProgressBarFrame.Position = UDim2.new(0, 20, 0, 60)
    ProgressBarFrame.Size = UDim2.new(1, -40, 0, 25)
    ProgressBarFrame.Parent = HopFrame

    local ProgressBarCorner = Instance.new("UICorner")
    ProgressBarCorner.CornerRadius = UDim.new(0, 12)
    ProgressBarCorner.Parent = ProgressBarFrame

    local ProgressBar = Instance.new("Frame")
    ProgressBar.Name = "ProgressBar"
    ProgressBar.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
    ProgressBar.BorderSizePixel = 0
    ProgressBar.Position = UDim2.new(0, 0, 0, 0)
    ProgressBar.Size = UDim2.new(0, 0, 1, 0)
    ProgressBar.Parent = ProgressBarFrame

    local ProgressGradient = Instance.new("UIGradient")
    ProgressGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 191, 255))
    })
    ProgressGradient.Rotation = 45
    ProgressGradient.Parent = ProgressBar

    local ProgressCorner = Instance.new("UICorner")
    ProgressCorner.CornerRadius = UDim.new(0, 12)
    ProgressCorner.Parent = ProgressBar

    local InfoLabel = Instance.new("TextLabel")
    InfoLabel.Name = "InfoLabel"
    InfoLabel.Text = "Scanning servers..."
    InfoLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium)
    InfoLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    InfoLabel.TextSize = 16
    InfoLabel.BackgroundTransparency = 1
    InfoLabel.Position = UDim2.new(0, 10, 0, 95)
    InfoLabel.Size = UDim2.new(1, -20, 0, 20)
    InfoLabel.TextXAlignment = Enum.TextXAlignment.Center
    InfoLabel.Parent = HopFrame

    local TimeLabel = Instance.new("TextLabel")
    TimeLabel.Name = "TimeLabel"
    TimeLabel.Text = "Time: 3s"
    TimeLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium)
    TimeLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    TimeLabel.TextSize = 16
    TimeLabel.BackgroundTransparency = 1
    TimeLabel.Position = UDim2.new(0, 10, 0, 125)
    TimeLabel.Size = UDim2.new(1, -20, 0, 20)
    TimeLabel.TextXAlignment = Enum.TextXAlignment.Center
    TimeLabel.Parent = HopFrame

    local CancelButton = Instance.new("TextButton")
    CancelButton.Name = "CancelButton"
    CancelButton.Text = "Cancel"
    CancelButton.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
    CancelButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CancelButton.TextSize = 16
    CancelButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    CancelButton.BorderSizePixel = 0
    CancelButton.Position = UDim2.new(0.5, -60, 0, 160)
    CancelButton.Size = UDim2.new(0, 120, 0, 35)
    CancelButton.Parent = HopFrame

    local CancelCorner = Instance.new("UICorner")
    CancelCorner.CornerRadius = UDim.new(0, 10)
    CancelCorner.Parent = CancelButton

    local function fadeIn()
        TweenService:Create(Blur, TweenInfo.new(0.7, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = 25}):Play()
        TweenService:Create(HopFrame, TweenInfo.new(0.7, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundTransparency = 0, Size = UDim2.new(0, 320, 0, 220)}):Play()
        TweenService:Create(HopFrame, TweenInfo.new(0.7, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Rotation = 0}):Play()
        ParticleEmitter.Enabled = true
    end

    local function fadeOut()
        ParticleEmitter.Enabled = false
        TweenService:Create(Blur, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Size = 0}):Play()
        TweenService:Create(HopFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {BackgroundTransparency = 1, Size = UDim2.new(0, 300, 0, 200)}):Play()
        TweenService:Create(HopFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Rotation = 10}):Play()
        wait(0.5)
        HopGui:Destroy()
        Blur:Destroy()
    end

    CancelButton.MouseEnter:Connect(function()
        TweenService:Create(CancelButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(255, 80, 80), Size = UDim2.new(0, 130, 0, 40)}):Play()
    end)
    CancelButton.MouseLeave:Connect(function()
        TweenService:Create(CancelButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(255, 50, 50), Size = UDim2.new(0, 120, 0, 35)}):Play()
    end)

    local isHopping = true
    spawn(function()
        fadeIn()
        local timeLeft = 3
        while timeLeft >= 0 and isHopping do
            TimeLabel.Text = "Time: " .. timeLeft .. "s"
            local progress = (3 - timeLeft) / 3
            TweenService:Create(ProgressBar, TweenInfo.new(1, Enum.EasingStyle.Linear), {Size = UDim2.new(progress, 0, 1, 0)}):Play()
            wait(1)
            timeLeft = timeLeft - 1
        end
        
        if isHopping then
            InfoLabel.Text = "Hopping To New Server..."
            local PlaceID = game.PlaceId
            local AllIDs = {}
            local foundAnything = ""

            local function TPReturner()
                local Site
                if foundAnything == "" then
                    Site = HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100'))
                else
                    Site = HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100&cursor=' .. foundAnything))
                end
                
                if Site.nextPageCursor and Site.nextPageCursor ~= "null" and Site.nextPageCursor ~= nil then
                    foundAnything = Site.nextPageCursor
                end
                
                for i, v in pairs(Site.data) do
                    local Possible = true
                    local ID = tostring(v.id)
                    
                    for _, Existing in pairs(AllIDs) do
                        if ID == tostring(Existing) then
                            Possible = false
                        end
                    end
                    
                    if Possible and tonumber(v.playing) < 12 then
                        table.insert(AllIDs, ID)
                        wait(0.5)
                        pcall(function()
                            TeleportService:TeleportToPlaceInstance(PlaceID, ID, player)
                        end)
                        wait(2)
                    end
                end
            end
            
            TPReturner()
            fadeOut()
        end
    end)

    CancelButton.MouseButton1Click:Connect(function()
        isHopping = false
        InfoLabel.Text = "Hop cancelled!"
        TimeLabel.Text = "Time: N/A"
        ProgressBar.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        ProgressGradient.Enabled = false
        TweenService:Create(ProgressBar, TweenInfo.new(0.3), {Size = UDim2.new(0, 0, 1, 0)}):Play()
        wait(1)
        fadeOut()
    end)

    spawn(function()
        while HopFrame.Parent do
            TweenService:Create(Glow, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {ImageTransparency = 0.4}):Play()
            wait(1)
            TweenService:Create(Glow, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {ImageTransparency = 0.7}):Play()
            wait(1)
        end
    end)

    spawn(function()
        while HopFrame.Parent do
            TweenService:Create(HopTitle, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Position = UDim2.new(0, 10, 0, 15)}):Play()
            wait(1)
            TweenService:Create(HopTitle, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Position = UDim2.new(0, 10, 0, 10)}):Play()
            wait(1)
        end
    end)

    spawn(function()
        while HopFrame.Parent do
            TweenService:Create(HopFrame, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Rotation = 2}):Play()
            wait(2)
            TweenService:Create(HopFrame, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Rotation = -2}):Play()
            wait(2)
        end
    end)

    return { GUI = HopGui, Blur = Blur }
end
--// Notify
local NotifyConfig = {
    Title = "Abyss Chest",
    Description = "",
    Content = "",
    Color = Color3.fromRGB(131, 181, 255),
    Time = 0.7,
    Delay = 5
}

if not CoreGui:FindFirstChild("EnhancedNotifyGui") then
    local NotifyGui = Instance.new("ScreenGui")
    NotifyGui.Name = "EnhancedNotifyGui"
    NotifyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    NotifyGui.Parent = CoreGui

    local NotifyLayout = Instance.new("Frame")
    NotifyLayout.Name = "NotifyLayout"
    NotifyLayout.AnchorPoint = Vector2.new(1, 1)
    NotifyLayout.BackgroundTransparency = 1
    NotifyLayout.Position = UDim2.new(1, -30, 1, -30)
    NotifyLayout.Size = UDim2.new(0, 300, 1, -30)
    NotifyLayout.Parent = NotifyGui

    local Count = 0
    NotifyLayout.ChildRemoved:Connect(function()
        Count = 0
        for _, v in NotifyLayout:GetChildren() do
            TweenService:Create(v, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Position = UDim2.new(0, 0, 1, -((v.Size.Y.Offset + 12) * Count))}):Play()
            Count = Count + 1
        end
    end)
end

local function CreateNotify(config)
    local NotifyFunc = {}
    local NotifyPosHeight = 0
    for _, v in CoreGui.EnhancedNotifyGui.NotifyLayout:GetChildren() do
        NotifyPosHeight = -(v.Position.Y.Offset) + v.Size.Y.Offset + 12
    end

    local NotifyFrame = Instance.new("Frame")
    NotifyFrame.Name = "NotifyFrame"
    NotifyFrame.AnchorPoint = Vector2.new(0, 1)
    NotifyFrame.BackgroundTransparency = 1
    NotifyFrame.Position = UDim2.new(0, 0, 1, -NotifyPosHeight)
    NotifyFrame.Size = UDim2.new(1, 0, 0, 65)
    NotifyFrame.Parent = CoreGui.EnhancedNotifyGui.NotifyLayout

    local NotifyFrameReal = Instance.new("Frame")
    NotifyFrameReal.Name = "NotifyFrameReal"
    NotifyFrameReal.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    NotifyFrameReal.Position = UDim2.new(0, 330, 0, 0)
    NotifyFrameReal.Size = UDim2.new(1, 0, 1, 0)
    NotifyFrameReal.Parent = NotifyFrame

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = NotifyFrameReal

    local Gradient = Instance.new("UIGradient")
    Gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(45, 45, 50)),
        ColorSequenceKeypoint.new(1, config.Color)
    })
    Gradient.Rotation = 45
    Gradient.Parent = NotifyFrameReal

    local Glow = Instance.new("ImageLabel")
    Glow.Name = "Glow"
    Glow.Image = "rbxassetid://5028857084"
    Glow.ImageColor3 = config.Color
    Glow.ImageTransparency = 0.6
    Glow.BackgroundTransparency = 1
    Glow.Size = UDim2.new(1, 40, 1, 40)
    Glow.Position = UDim2.new(0.5, 0, 0.5, 0)
    Glow.AnchorPoint = Vector2.new(0.5, 0.5)
    Glow.ZIndex = 0
    Glow.Parent = NotifyFrameReal

    local DropShadowHolder = Instance.new("Frame")
    DropShadowHolder.Name = "DropShadowHolder"
    DropShadowHolder.BackgroundTransparency = 1
    DropShadowHolder.Size = UDim2.new(1, 0, 1, 0)
    DropShadowHolder.ZIndex = -1
    DropShadowHolder.Parent = NotifyFrameReal

    local DropShadow = Instance.new("ImageLabel")
    DropShadow.Name = "DropShadow"
    DropShadow.Image = "rbxassetid://6015897843"
    DropShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    DropShadow.ImageTransparency = 0.4
    DropShadow.ScaleType = Enum.ScaleType.Slice
    DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)
    DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
    DropShadow.BackgroundTransparency = 1
    DropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    DropShadow.Size = UDim2.new(1, 60, 1, 60)
    DropShadow.Parent = DropShadowHolder

    local ParticleEmitter = Instance.new("ParticleEmitter")
    ParticleEmitter.Texture = "rbxassetid://243098098"
    ParticleEmitter.Color = ColorSequence.new(config.Color)
    ParticleEmitter.Size = NumberSequence.new(0.3, 0)
    ParticleEmitter.Transparency = NumberSequence.new(0.4, 1)
    ParticleEmitter.Lifetime = NumberRange.new(0.8, 1.2)
    ParticleEmitter.Rate = 15
    ParticleEmitter.Speed = NumberRange.new(2, 4)
    ParticleEmitter.SpreadAngle = Vector2.new(360, 360)
    ParticleEmitter.Parent = NotifyFrameReal

    local NotifyContent = Instance.new("TextLabel")
    NotifyContent.Name = "NotifyContent"
    NotifyContent.Font = Enum.Font.GothamBold
    NotifyContent.Text = config.Content
    NotifyContent.TextColor3 = Color3.fromRGB(200, 200, 200)
    NotifyContent.TextSize = 13
    NotifyContent.TextXAlignment = Enum.TextXAlignment.Left
    NotifyContent.TextYAlignment = Enum.TextYAlignment.Top
    NotifyContent.TextWrapped = true
    NotifyContent.BackgroundTransparency = 1
    NotifyContent.Position = UDim2.new(0, 12, 0, 27)
    NotifyContent.Size = UDim2.new(1, -24, 0, 13)
    NotifyContent.Parent = NotifyFrameReal

    local Top = Instance.new("Frame")
    Top.Name = "Top"
    Top.BackgroundTransparency = 1
    Top.Size = UDim2.new(1, 0, 0, 34)
    Top.Parent = NotifyFrameReal

    local NotifyTitle = Instance.new("TextLabel")
    NotifyTitle.Name = "NotifyTitle"
    NotifyTitle.Font = Enum.Font.GothamBold
    NotifyTitle.Text = config.Title
    NotifyTitle.TextColor3 = config.Color
    NotifyTitle.TextSize = 16
    NotifyTitle.TextXAlignment = Enum.TextXAlignment.Left
    NotifyTitle.BackgroundTransparency = 1
    NotifyTitle.Position = UDim2.new(0, 12, 0, 8)
    NotifyTitle.Size = UDim2.new(0, 0, 0, 16)
    NotifyTitle.Parent = Top

    local NotifyDescription = Instance.new("TextLabel")
    NotifyDescription.Name = "NotifyDescription"
    NotifyDescription.Font = Enum.Font.Gotham
    NotifyDescription.Text = config.Description
    NotifyDescription.TextColor3 = Color3.fromRGB(230, 230, 230)
    NotifyDescription.TextSize = 12
    NotifyDescription.TextXAlignment = Enum.TextXAlignment.Left
    NotifyDescription.BackgroundTransparency = 1
    NotifyDescription.Position = UDim2.new(0, 12 + NotifyTitle.TextBounds.X + 5, 0, 10)
    NotifyDescription.Size = UDim2.new(0, 0, 0, 12)
    NotifyDescription.Parent = Top

    local NotifyClose = Instance.new("TextButton")
    NotifyClose.Name = "NotifyClose"
    NotifyClose.Text = ""
    NotifyClose.AnchorPoint = Vector2.new(1, 0)
    NotifyClose.BackgroundTransparency = 1
    NotifyClose.Position = UDim2.new(1, 0, 0, 0)
    NotifyClose.Size = UDim2.new(0, 34, 0, 34)
    NotifyClose.Parent = Top

    local NotifyCloseImage = Instance.new("ImageLabel")
    NotifyCloseImage.Name = "NotifyCloseImage"
    NotifyCloseImage.Image = "rbxassetid://18328658828"
    NotifyCloseImage.AnchorPoint = Vector2.new(0.5, 0.5)
    NotifyCloseImage.BackgroundTransparency = 1
    NotifyCloseImage.Position = UDim2.new(0.5, 0, 0.5, 0)
    NotifyCloseImage.Size = UDim2.new(0, 18, 0, 18)
    NotifyCloseImage.Parent = NotifyClose

    NotifyContent.Size = UDim2.new(1, -24, 0, 13 + (13 * math.ceil(NotifyContent.TextBounds.X / NotifyContent.AbsoluteSize.X)))
    NotifyFrame.Size = NotifyContent.AbsoluteSize.Y < 27 and UDim2.new(1, 0, 0, 65) or UDim2.new(1, 0, 0, NotifyContent.AbsoluteSize.Y + 40)
    if NotifyContent.Text == "" then
        NotifyFrame.Size = UDim2.new(1, 0, 0, 35)
        DropShadow.Size = UDim2.new(1, 30, 1, 30)
    end

    spawn(function()
        while NotifyFrameReal.Parent do
            TweenService:Create(Glow, TweenInfo.new(1.2, Enum.EasingStyle.Sine), {ImageTransparency = 0.4}):Play()
            task.wait(1.2)
            TweenService:Create(Glow, TweenInfo.new(1.2, Enum.EasingStyle.Sine), {ImageTransparency = 0.6}):Play()
            task.wait(1.2)
        end
    end)

    local isClosing = false
    function NotifyFunc:Close()
        if isClosing then return end
        isClosing = true
        ParticleEmitter.Enabled = false
        TweenService:Create(NotifyFrameReal, TweenInfo.new(config.Time, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Position = UDim2.new(0, 330, 0, 0), Size = UDim2.new(1, 0, 0, 0)}):Play()
        task.wait(config.Time)
        NotifyFrame:Destroy()
    end

    NotifyClose.Activated:Connect(function() NotifyFunc:Close() end)

    ParticleEmitter.Enabled = true
    TweenService:Create(NotifyFrameReal, TweenInfo.new(config.Time, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0)}):Play()

    spawn(function()
        task.wait(config.Delay)
        NotifyFunc:Close()
    end)

    return NotifyFunc
end

getgenv().Notify = function(config)
    local mergedConfig = {}
    for k, v in pairs(NotifyConfig) do mergedConfig[k] = v end
    for k, v in pairs(config or {}) do mergedConfig[k] = v end
    pcall(function() CreateNotify(mergedConfig) end)
end

--// Gui Farm 
local FarmGui = Instance.new("ScreenGui")
FarmGui.Name = "FarmGui"
FarmGui.DisplayOrder = 10
FarmGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
FarmGui.Parent = game.CoreGui

local FarmFrame = Instance.new("Frame")
FarmFrame.Name = "FarmFrame"
FarmFrame.AnchorPoint = Vector2.new(0.5, 0.5)
FarmFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
FarmFrame.BorderSizePixel = 0
FarmFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
FarmFrame.Size = UDim2.new(0, 250, 0, 340)
FarmFrame.Active = true
FarmFrame.Draggable = true
FarmFrame.Parent = FarmGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = FarmFrame

local Glow = Instance.new("ImageLabel")
Glow.Name = "Glow"
Glow.Image = "rbxassetid://5028857084"
Glow.ImageColor3 = Color3.fromRGB(131, 181, 255)
Glow.ImageTransparency = 0.5
Glow.BackgroundTransparency = 1
Glow.Size = UDim2.new(1, 40, 1, 40)
Glow.Position = UDim2.new(0.5, 0, 0.5, 0)
Glow.AnchorPoint = Vector2.new(0.5, 0.5)
Glow.ZIndex = -1
Glow.Parent = FarmFrame

local DropShadowHolder = Instance.new("Frame")
DropShadowHolder.Name = "DropShadowHolder"
DropShadowHolder.BackgroundTransparency = 1
DropShadowHolder.Size = UDim2.new(1, 0, 1, 0)
DropShadowHolder.ZIndex = 0
DropShadowHolder.Parent = FarmFrame

local DropShadow = Instance.new("ImageLabel")
DropShadow.Name = "DropShadow"
DropShadow.Image = "rbxassetid://6015897843"
DropShadow.ImageColor3 = Color3.fromRGB(30, 30, 30)
DropShadow.ImageTransparency = 0.5
DropShadow.ScaleType = Enum.ScaleType.Slice
DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)
DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
DropShadow.BackgroundTransparency = 1
DropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
DropShadow.Size = UDim2.new(1, 47, 1, 47)
DropShadow.Parent = DropShadowHolder

local UIGradient = Instance.new("UIGradient")
UIGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 40)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 20))
})
UIGradient.Rotation = 45
UIGradient.Parent = FarmFrame

local FarmImage = Instance.new("ImageLabel")
FarmImage.Name = "FarmImage"
FarmImage.Image = "rbxassetid://132232892453051"
FarmImage.BackgroundTransparency = 1
FarmImage.Position = UDim2.new(0, 10, 0, 10)
FarmImage.Size = UDim2.new(0, 40, 0, 40)
FarmImage.Parent = FarmFrame

local FarmTitle = Instance.new("TextLabel")
FarmTitle.Name = "FarmTitle"
FarmTitle.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.ExtraBold)
FarmTitle.Text = "Abyss Chest"
FarmTitle.TextColor3 = Color3.fromRGB(131, 181, 255)
FarmTitle.TextSize = 16
FarmTitle.TextXAlignment = Enum.TextXAlignment.Left
FarmTitle.BackgroundTransparency = 1
FarmTitle.Position = UDim2.new(0, 55, 0, 12)
FarmTitle.Size = UDim2.new(0, 150, 0, 25)
FarmTitle.Parent = FarmFrame

local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Text = "−"
MinimizeButton.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.TextSize = 18
MinimizeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
MinimizeButton.BorderSizePixel = 0
MinimizeButton.Position = UDim2.new(1, -60, 0, 10)
MinimizeButton.Size = UDim2.new(0, 20, 0, 20)
MinimizeButton.Parent = FarmFrame

local MinimizeCorner = Instance.new("UICorner")
MinimizeCorner.CornerRadius = UDim.new(0, 5)
MinimizeCorner.Parent = MinimizeButton

local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Text = "×"
CloseButton.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 18
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.BorderSizePixel = 0
CloseButton.Position = UDim2.new(1, -30, 0, 10)
CloseButton.Size = UDim2.new(0, 20, 0, 20)
CloseButton.Parent = FarmFrame

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 5)
CloseCorner.Parent = CloseButton

local DiscordButton = Instance.new("TextButton")
DiscordButton.Name = "DiscordButton"
DiscordButton.Text = "Discord"
DiscordButton.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
DiscordButton.TextColor3 = Color3.fromRGB(255, 255, 255)
DiscordButton.TextSize = 14
DiscordButton.TextXAlignment = Enum.TextXAlignment.Center
DiscordButton.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
DiscordButton.BorderSizePixel = 0
DiscordButton.Position = UDim2.new(0, 10, 0, 10)
DiscordButton.Size = UDim2.new(0, 80, 0, 30)
DiscordButton.ZIndex = 10
DiscordButton.Parent = FarmGui

local DiscordCorner = Instance.new("UICorner")
DiscordCorner.CornerRadius = UDim.new(0, 5)
DiscordCorner.Parent = DiscordButton

local StatusFrame = Instance.new("Frame")
StatusFrame.Name = "StatusFrame"
StatusFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
StatusFrame.BorderSizePixel = 0
StatusFrame.Position = UDim2.new(0, 10, 0, 60)
StatusFrame.Size = UDim2.new(1, -20, 0.8, 0)
StatusFrame.Parent = FarmFrame

local StatusCorner = Instance.new("UICorner")
StatusCorner.CornerRadius = UDim.new(0, 6)
StatusCorner.Parent = StatusFrame

local StatusHeader = Instance.new("Frame")
StatusHeader.Name = "StatusHeader"
StatusHeader.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
StatusHeader.BorderSizePixel = 0
StatusHeader.Position = UDim2.new(0, 0, 0, 0)
StatusHeader.Size = UDim2.new(1, 0, 0, 30)
StatusHeader.Parent = StatusFrame

local StatusHeaderCorner = Instance.new("UICorner")
StatusHeaderCorner.CornerRadius = UDim.new(0, 6)
StatusHeaderCorner.Parent = StatusHeader

local StatusFixFrame = Instance.new("Frame")
StatusFixFrame.Name = "StatusFixFrame"
StatusFixFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
StatusFixFrame.BorderSizePixel = 0
StatusFixFrame.Position = UDim2.new(0, 0, 0.5, 0)
StatusFixFrame.Size = UDim2.new(1, 0, 0.5, 0)
StatusFixFrame.Parent = StatusHeader

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Name = "StatusLabel"
StatusLabel.Text = "Status: Waiting..."
StatusLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
StatusLabel.TextSize = 14
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.BackgroundTransparency = 1
StatusLabel.Position = UDim2.new(0, 10, 0, 0)
StatusLabel.Size = UDim2.new(1, -20, 1, 0)
StatusLabel.Parent = StatusHeader

local TimeLabel = Instance.new("TextLabel")
TimeLabel.Name = "TimeLabel"
TimeLabel.Text = "Time: 00:00:00"
TimeLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
TimeLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
TimeLabel.TextSize = 16
TimeLabel.TextXAlignment = Enum.TextXAlignment.Center
TimeLabel.BackgroundTransparency = 1
TimeLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
TimeLabel.Size = UDim2.new(0, 120, 0, 25)
TimeLabel.AnchorPoint = Vector2.new(0.5, 0.5)
TimeLabel.Parent = FarmFrame
TimeLabel.Visible = false

local function createStatCard(title, iconId, value, position, accentColor)
    local CardFrame = Instance.new("Frame")
    CardFrame.Name = title.."Card"
    CardFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    CardFrame.BorderSizePixel = 0
    CardFrame.Position = position
    CardFrame.Size = UDim2.new(0.5, -18, 0, 50)
    CardFrame.Parent = StatusFrame
    
    local CardCorner = Instance.new("UICorner")
    CardCorner.CornerRadius = UDim.new(0, 6)
    CardCorner.Parent = CardFrame
    
    local IconImage = Instance.new("ImageLabel")
    IconImage.Name = "Icon"
    IconImage.Image = iconId
    IconImage.BackgroundTransparency = 1
    IconImage.Position = UDim2.new(0, 8, 0.5, -12)
    IconImage.Size = UDim2.new(0, 24, 0, 24)
    IconImage.ImageColor3 = accentColor
    IconImage.Parent = CardFrame
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "Title"
    TitleLabel.Text = title
    TitleLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium)
    TitleLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    TitleLabel.TextSize = 11
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position = UDim2.new(0, 38, 0, 8)
    TitleLabel.Size = UDim2.new(1, -45, 0, 12)
    TitleLabel.Parent = CardFrame
    
    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Name = "Value"
    ValueLabel.Text = value
    ValueLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
    ValueLabel.TextColor3 = accentColor
    ValueLabel.TextSize = 16
    ValueLabel.TextXAlignment = Enum.TextXAlignment.Left
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.Position = UDim2.new(0, 38, 0, 22)
    ValueLabel.Size = UDim2.new(1, -45, 0, 20)
    ValueLabel.Parent = CardFrame
    
    return ValueLabel
end

local EarnedValue = createStatCard("Earned", "rbxassetid://7072717958", "0", UDim2.new(0, 12, 0, 40), Color3.fromRGB(100, 200, 100))
local ChestsValue = createStatCard("Chests", "rbxassetid://7072724538", "0", UDim2.new(0.5, 6, 0, 40), Color3.fromRGB(131, 181, 255))
local DistanceValue = createStatCard("Distance", "rbxassetid://7072719338", "N/A", UDim2.new(0.2, 6, 0, 95), Color3.fromRGB(255, 100, 100))

local LogFrame = Instance.new("Frame")
LogFrame.Name = "LogFrame"
LogFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
LogFrame.BorderSizePixel = 0
LogFrame.Position = UDim2.new(0, 12, 0, 150)
LogFrame.Size = UDim2.new(1, -24, 0, 110)
LogFrame.Parent = StatusFrame

local LogCorner = Instance.new("UICorner")
LogCorner.CornerRadius = UDim.new(0, 6)
LogCorner.Parent = LogFrame

local LogTitle = Instance.new("TextLabel")
LogTitle.Name = "LogTitle"
LogTitle.Text = "Activity Log"
LogTitle.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
LogTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
LogTitle.TextSize = 14
LogTitle.TextXAlignment = Enum.TextXAlignment.Left
LogTitle.BackgroundTransparency = 1
LogTitle.Position = UDim2.new(0, 10, 0, 5)
LogTitle.Size = UDim2.new(1, -20, 0, 20)
LogTitle.Parent = LogFrame

local LogScrollFrame = Instance.new("ScrollingFrame")
LogScrollFrame.Name = "LogScrollFrame"
LogScrollFrame.BackgroundTransparency = 1
LogScrollFrame.BorderSizePixel = 0
LogScrollFrame.Position = UDim2.new(0, 5, 0, 25)
LogScrollFrame.Size = UDim2.new(1, -10, 0, 70)
LogScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
LogScrollFrame.ScrollBarThickness = 4
LogScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(131, 181, 255)
LogScrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
LogScrollFrame.Parent = LogFrame

local LogLayout = Instance.new("UIListLayout")
LogLayout.SortOrder = Enum.SortOrder.LayoutOrder
LogLayout.Padding = UDim.new(0, 2)
LogLayout.Parent = LogScrollFrame

local isMinimized = false

MinimizeButton.MouseButton1Click:Connect(function()
    if isMinimized then
        TweenService:Create(FarmFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = UDim2.new(0, 250, 0, 340), Position = UDim2.new(0.5, 0, 0.5, 0)}):Play()
        TweenService:Create(StatusFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Position = UDim2.new(0, 10, 0, 60), Size = UDim2.new(1, -20, 0.8, 0)}):Play()
        TweenService:Create(FarmFrame, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
        MinimizeButton.Text = "−"
        StatusLabel.Position = UDim2.new(0, 10, 0, 0)
        StatusLabel.Size = UDim2.new(1, -20, 1, 0)
        
        LogFrame.Visible = true
        EarnedValue.Parent.Parent.Visible = true
        ChestsValue.Parent.Parent.Visible = true
        DistanceValue.Parent.Parent.Visible = true
        TimeLabel.Visible = false
    else
        TweenService:Create(FarmFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = UDim2.new(0, 250, 0, 70), Position = UDim2.new(0.5, 0, 0.5, 0)}):Play()
        TweenService:Create(StatusFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Position = UDim2.new(0, 10, 0, 50), Size = UDim2.new(1, -20, 0, 0)}):Play()
        TweenService:Create(FarmFrame, TweenInfo.new(0.3), {BackgroundTransparency = 0.2}):Play()
        MinimizeButton.Text = "+"
        StatusLabel.Position = UDim2.new(0, 10, 0, 0)
        StatusLabel.Size = UDim2.new(1, -20, 1, 0)
        
        LogFrame.Visible = false
        EarnedValue.Parent.Parent.Visible = false
        ChestsValue.Parent.Parent.Visible = false
        DistanceValue.Parent.Parent.Visible = false
        TimeLabel.Visible = true
    end
    isMinimized = not isMinimized
end)

CloseButton.MouseButton1Click:Connect(function()
    TweenService:Create(Glow, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 2, true), {ImageTransparency = 0}):Play()
    local closeTween1 = TweenService:Create(
        FarmFrame,
        TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In),
        {Size = UDim2.new(0, 150, 0, 180), BackgroundTransparency = 0.3}
    )
    local closeTween2 = TweenService:Create(
        FarmFrame,
        TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
        {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0), BackgroundTransparency = 1}
    )
    closeTween1:Play()
    closeTween1.Completed:Connect(function()
        closeTween2:Play()
        closeTween2.Completed:Connect(function()
            FarmGui:Destroy()
        end)
    end)
end)

local discordLink = "https://discord.gg/cKxGF9vxVt"
DiscordButton.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard(discordLink)
        DiscordButton.Text = "Copied!"
        TweenService:Create(DiscordButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(25, 99, 78)}):Play()
        task.wait(2)
        DiscordButton.Text = "Discord"
        TweenService:Create(DiscordButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = Color3.fromRGB(25, 99, 78)}):Play()
    end
end)

local function addLogEntry(text, beliGained, isSpecial)
    local LogEntry = Instance.new("TextLabel")
    LogEntry.Name = "LogEntry"
    LogEntry.Text = "• " .. text
    LogEntry.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium)
    LogEntry.TextColor3 = isSpecial and Color3.fromRGB(255, 215, 0) or Color3.fromRGB(200, 200, 200)
    LogEntry.TextSize = 12
    LogEntry.TextXAlignment = Enum.TextXAlignment.Left
    LogEntry.TextWrapped = true
    LogEntry.BackgroundTransparency = 1
    LogEntry.Size = UDim2.new(1, -10, 0, 0)
    LogEntry.AutomaticSize = Enum.AutomaticSize.Y
    LogEntry.Parent = LogScrollFrame
    LogEntry.LayoutOrder = #LogScrollFrame:GetChildren()
    
    LogEntry.TextTransparency = 1
    TweenService:Create(LogEntry, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
    
    if isSpecial then
        spawn(function()
            for i = 1, 3 do
                TweenService:Create(LogEntry, TweenInfo.new(0.5, Enum.EasingStyle.Sine), {TextTransparency = 0.3}):Play()
                task.wait(0.5)
                TweenService:Create(LogEntry, TweenInfo.new(0.5, Enum.EasingStyle.Sine), {TextTransparency = 0}):Play()
                task.wait(0.5)
            end
        end)
    end
    
    LogScrollFrame.CanvasPosition = Vector2.new(0, LogScrollFrame.CanvasSize.Y.Offset)
    
    if #LogScrollFrame:GetChildren() > 50 then
        for _, child in ipairs(LogScrollFrame:GetChildren()) do
            if child:IsA("TextLabel") and child.LayoutOrder == 1 then
                child:Destroy()
                break
            end
        end
        for i, child in ipairs(LogScrollFrame:GetChildren()) do
            if child:IsA("TextLabel") then
                child.LayoutOrder = i
            end
        end
    end
    
    if beliGained then
        local ChestEntry = Instance.new("TextLabel")
        ChestEntry.Name = "ChestEntry"
        ChestEntry.Text = "• Amount received Chest " .. FormatNumber(beliGained) .. " "
        ChestEntry.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium)
        ChestEntry.TextColor3 = Color3.fromRGB(255, 215, 0)
        ChestEntry.TextSize = 12
        ChestEntry.TextXAlignment = Enum.TextXAlignment.Left
        ChestEntry.TextWrapped = true
        ChestEntry.BackgroundTransparency = 1
        ChestEntry.Size = UDim2.new(1, -10, 0, 0)
        ChestEntry.AutomaticSize = Enum.AutomaticSize.Y
        ChestEntry.Parent = LogScrollFrame
        ChestEntry.LayoutOrder = #LogScrollFrame:GetChildren()
        
        ChestEntry.TextTransparency = 1
        TweenService:Create(ChestEntry, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
        
        LogScrollFrame.CanvasPosition = Vector2.new(0, LogScrollFrame.CanvasSize.Y.Offset)
    end
end

local function UpdateUI(status, time, earned, chests, distance)
    pcall(function()
        StatusLabel.Text = "Status: " .. (status or "Waiting...")
        TimeLabel.Text = "Time: " .. (time or "00:00:00")
        EarnedValue.Text = earned or "0"
        ChestsValue.Text = chests or "0"
        DistanceValue.Text = (distance and distance .. "m") or "N/A"
        if isMinimized then StatusLabel.Text = "Status: " .. (status or "Waiting...") end
    end)
end

local function addPulseEffect(label)
    spawn(function()
        while label and label.Parent do
            TweenService:Create(label, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {TextTransparency = 0.2}):Play()
            task.wait(1)
            if not label or not label.Parent then break end
            TweenService:Create(label, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {TextTransparency = 0}):Play()
            task.wait(1)
        end
    end)
end

addPulseEffect(StatusLabel)
addPulseEffect(TimeLabel)
addPulseEffect(BeliValue)
addPulseEffect(EarnedValue)
addPulseEffect(ChestsValue)
addPulseEffect(DistanceValue)

FarmFrame.Size = UDim2.new(0, 0, 0, 0)
FarmFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
FarmFrame.BackgroundTransparency = 1
local appearTween = TweenService:Create(
    FarmFrame,
    TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    {Size = UDim2.new(0, 250, 0, 340), Position = UDim2.new(0.5, 0, 0.5, 0), BackgroundTransparency = 0}
)
local glowTween = TweenService:Create(Glow, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 1, true), {ImageTransparency = 0})
appearTween:Play()
glowTween:Play()

addLogEntry("Abyss Chest Loaded!")
addLogEntry("Abyss Combined With Server")
UpdateUI("Waiting for player...", "00:00:00", "0", "0", "0", "N/A")

--// Webhook
local AllRequest = http_request or request or HttpPost or syn.request or nil
local HttpService = game:GetService("HttpService")


local function sendWebhook(title, description, chestCount, elapsedTime, isSpecial, beliGained)
    local webhookConfig = getgenv().mmb and getgenv().mmb.Webhook or {}
    if not webhookConfig["send Webhook"] or not webhookConfig["Url Webhook"] or webhookConfig["Url Webhook"] == "" then 
        warn("Idk")
        return 
    end
    
    local player = game.Players.LocalPlayer
    local pingUserId = webhookConfig["UserId"]
    local payload = {
        username = "Abyss Chest Logs",
        avatar_url = "https://cdn.discordapp.com/attachments/1309548624669311078/1363893967296659676/ChatGPT_Image_Apr_21_2025_08_13_11_PM.png?ex=6807b0bd&is=68065f3d&hm=862437965c0a398af21357d353e63811d164d80363f6dee86df93b02d1760f70&",
        content = pingUserId and pingUserId ~= "" and "<@" .. pingUserId .. ">" or "",
        embeds = {{
            title = title or "Abyss Chest Notify",
            description = description or "No description provided",
            color = isSpecial and 16776960 or 3447003,
            timestamp = DateTime.now():ToIsoDate(),
            footer = {text = "Abyss Auto Farm Chest"},
            fields = {
                {name = "Current Beli", value = FormatNumber(player and player.Data and player.Data.Beli and player.Data.Beli.Value or 0), inline = true},
                {name = "Chests Collected", value = tostring(chestCount or 0), inline = true},
                {name = "Time Elapsed", value = FormatTime(elapsedTime or 0), inline = true}
            }
        }}
    }
    
    if beliGained and beliGained > 0 then
        table.insert(payload.embeds[1].fields, {name = "Beli Gained", value = FormatNumber(beliGained), inline = true})
    end

    local webhookUrl = webhookConfig["Url Webhook"]
    local success, err = pcall(function()
        if syn and syn.request then
            syn.request({
                Url = webhookUrl,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = HttpService:JSONEncode(payload)
            })
        elseif http_request then
            http_request({
                Url = webhookUrl,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = HttpService:JSONEncode(payload)
            })
        elseif request then
            request({
                Url = webhookUrl,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = HttpService:JSONEncode(payload)
            })
        elseif HttpPost then
            HttpPost(webhookUrl, HttpService:JSONEncode(payload))
        else
            HttpService:PostAsync(webhookUrl, HttpService:JSONEncode(payload), Enum.HttpContentType.ApplicationJson)
        end
        print("kid v2: " .. webhookUrl:sub(1, 40) .. "...")
    end)
    
    if not success then
        warn("kid: " .. tostring(err))
    end
    
    return success
end

--// Noclip handling
spawn(function()
    while task.wait(0.1) do
        pcall(function()
            if getgenv().mmb.ChestSettings["Start Farm Chest"]["Enable"]  then
                if character and humanoidRootPart then
                    if not humanoidRootPart:FindFirstChild("BodyClip") then
                        local Noclip = Instance.new("BodyVelocity")
                        Noclip.Name = "BodyClip"
                        Noclip.MaxForce = Vector3.new(100000, 100000, 100000)
                        Noclip.Velocity = Vector3.new(0, 0, 0)
                        Noclip.Parent = humanoidRootPart
                    end
                    for _, v in pairs(character:GetDescendants()) do
                        if v:IsA("BasePart") then v.CanCollide = false end
                    end
                end
            elseif character and humanoidRootPart then
                local bodyClip = humanoidRootPart:FindFirstChild("BodyClip")
                if bodyClip then bodyClip:Destroy() end
            end
        end)
    end
end)

--// TweenSpeed
function CheckNearestTeleporter(aI)
    local MyLevel = game.Players.LocalPlayer.Data.Level.Value
    local vcspos = aI.Position
    local min = math.huge
    local min2 = math.huge
    local y = game.PlaceId
    local World1, World2, World3
    if y == 2753915549 then
        World1 = true
    elseif y == 4442272183 then
        World2 = true
    elseif y == 7449423635 then
        World3 = true
    end
    local TableLocations = {}
    if World3 then
        TableLocations = {
            ["Mansion"] = Vector3.new(-12471, 374, -7551),
            ["Hydra"] = Vector3.new(5659, 1013, -341),
            ["Caslte On The Sea"] = Vector3.new(-5092, 315, -3130),
            ["Floating Turtle"] = Vector3.new(-12001, 332, -8861),
            ["Beautiful Pirate"] = Vector3.new(5319, 23, -93),
            ["Temple Of Time"] = Vector3.new(28286, 14897, 103)
        }
    elseif World2 then
        TableLocations = {
            ["Flamingo Mansion"] = Vector3.new(-317, 331, 597),
            ["Flamingo Room"] = Vector3.new(2283, 15, 867),
            ["Cursed Ship"] = Vector3.new(923, 125, 32853),
            ["Zombie Island"] = Vector3.new(-6509, 83, -133)
        }
    elseif World1 then
        TableLocations = {
            ["Sky Island 1"] = Vector3.new(-4652, 873, -1754),
            ["Sky Island 2"] = Vector3.new(-7895, 5547, -380),
            ["Under Water Island"] = Vector3.new(61164, 5, 1820),
            ["Under Water Island Entrace"] = Vector3.new(3865, 5, -1926)
        }
    end
    local TableLocations2 = {}
    for r, v in pairs(TableLocations) do
        TableLocations2[r] = (v - vcspos).Magnitude
    end
    for r, v in pairs(TableLocations2) do
        if v < min then
            min = v
            min2 = v
        end
    end
    local choose
    for r, v in pairs(TableLocations2) do
        if v <= min then
            choose = TableLocations[r]
        end
    end
    local min3 = (vcspos - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
    if min2 <= min3 then
        return choose
    end
end    

function requestEntrance(aJ)
    local args = {"requestEntrance", aJ}
    game.ReplicatedStorage.Remotes.CommF_:InvokeServer(unpack(args))    
    local oldcframe = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
    local char = game.Players.LocalPlayer.Character.HumanoidRootPart
    char.CFrame = CFrame.new(oldcframe.X, oldcframe.Y + 50, oldcframe.Z)    
    task.wait(0.5)
end   
function topos(Tween_Pos)
    pcall(function()
        if game:GetService("Players").LocalPlayer 
            and game:GetService("Players").LocalPlayer.Character 
            and game:GetService("Players").LocalPlayer.Character:FindFirstChild("Humanoid") 
            and game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") 
            and game:GetService("Players").LocalPlayer.Character.Humanoid.Health > 0 
            and game:GetService("Players").LocalPlayer.Character.HumanoidRootPart then
            if not TweenSpeed then
                TweenSpeed = 200
            end
            DefualtY = Tween_Pos.Y
            TargetY = Tween_Pos.Y
            targetCFrameWithDefualtY = CFrame.new(Tween_Pos.X, DefualtY, Tween_Pos.Z)
            targetPos = Tween_Pos.Position
            oldcframe = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
            Distance = (targetPos - game:GetService("Players").LocalPlayer.Character:WaitForChild("HumanoidRootPart").Position).Magnitude
            if Distance <= 300 then
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Tween_Pos
            end
            local aM = CheckNearestTeleporter(Tween_Pos)
            if aM then
                pcall(function()
                    tween:Cancel()
                end)
                requestEntrance(aM)
            end
            b1 = CFrame.new(
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.X,
                DefualtY,
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.Z
            )
            IngoreY = true
            if IngoreY and (b1.Position - targetCFrameWithDefualtY.Position).Magnitude > 5 then
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.X,
                    DefualtY,
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.Z
                )
                local tweenfunc = {}
                local aN = game:GetService("TweenService")
                local aO = TweenInfo.new(
                    (targetPos - game:GetService("Players").LocalPlayer.Character:WaitForChild("HumanoidRootPart").Position).Magnitude / TweenSpeed,
                    Enum.EasingStyle.Linear
                )
                tween = aN:Create(
                    game:GetService("Players").LocalPlayer.Character["HumanoidRootPart"],
                    aO,
                    {CFrame = targetCFrameWithDefualtY}
                )
                tween:Play()
                function tweenfunc:Stop()
                    tween:Cancel()
                end
                tween.Completed:Wait()
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.X,
                    TargetY,
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.Z
                )
            else
                local tweenfunc = {}
                local aN = game:GetService("TweenService")
                local aO = TweenInfo.new(
                    (targetPos - game:GetService("Players").LocalPlayer.Character:WaitForChild("HumanoidRootPart").Position).Magnitude / TweenSpeed,
                    Enum.EasingStyle.Linear
                )
                tween = aN:Create(
                    game:GetService("Players").LocalPlayer.Character["HumanoidRootPart"],
                    aO,
                    {CFrame = Tween_Pos}
                )
                tween:Play()
                function tweenfunc:Stop()
                    tween:Cancel()
                end
                tween.Completed:Wait()
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.X,
                    TargetY,
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.Z
                )
            end
            if not tween then
                return tween
            end
            return tweenfunc
        end
    end)
end
function StopTween(target)
    pcall(function()
        if not target then
            getgenv().StopTween = true            
            if tween then
                tween:Cancel()
                tween = nil
            end            
            local player = game:GetService("Players").LocalPlayer
            local character = player and player.Character
            local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                humanoidRootPart.Anchored = true
                task.wait(0.1)
                humanoidRootPart.CFrame = humanoidRootPart.CFrame
                humanoidRootPart.Anchored = false
            end
            local bodyClip = humanoidRootPart and humanoidRootPart:FindFirstChild("BodyClip")
            if bodyClip then
                bodyClip:Destroy()
            end
            getgenv().StopTween = false
            getgenv().Clip = false
        end
    end)
end
--//Coder
--// Anti-Afk
local Value = game:GetService("VirtualUser")
repeat wait() until game:IsLoaded()

spawn(function()
    if getgenv().mmb.setting["Anti-Afk"] then
        game:GetService("Players").LocalPlayer.Idled:connect(function()
            Value:ClickButton2(Vector2.new())
            Value:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            wait(1)
            Value:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        end)
    end
end)
--// Remove Notify Game
spawn(function()
   while wait() do
      if getgenv().mmb.setting["Remove Notify Game"] then
         game.Players.LocalPlayer.PlayerGui.Notifications.Enabled = false
      else
         game.Players.LocalPlayer.PlayerGui.Notifications.Enabled = true
      end
   end
end)
--// Rejoin 
task.spawn(function()
    if getgenv().mmb.setting["Rejoin When kicked"] then
        local promptOverlay = game:GetService("CoreGui").RobloxPromptGui.promptOverlay
        
        promptOverlay.ChildAdded:Connect(function(child)
            if child.Name == "ErrorPrompt" and child:FindFirstChild("MessageArea") and
                child.MessageArea:FindFirstChild("ErrorFrame") then
                game:GetService("TeleportService"):Teleport(game.PlaceId)
            end
        end)
    end
end)

--// Farm Chest
local chestService = game:GetService("CollectionService")
task.spawn(function()
    local trackedChests = {}
    local lastTarget = nil
    local chestCache = {}
    local player = game.Players.LocalPlayer
    local startTime = os.time()
    local earnedBeli = 0
    local chestCount = 0
    local character, humanoidRootPart, humanoid
    local isHopping = false

    local function findClosestChest()
        if not character or not humanoidRootPart then return nil, math.huge end
        local playerPos = humanoidRootPart.Position
        local chests = chestService:GetTagged("_ChestTagged")
        local closestChest, minDist = nil, math.huge

        for _, chest in ipairs(chests) do
            if not chest:GetAttribute("IsDisabled") then
                local dist = (chest:GetPivot().Position - playerPos).Magnitude
                if dist < minDist then
                    minDist, closestChest = dist, chest
                end
            end
        end
        chestCache.closest = closestChest
        chestCache.distance = minDist
        return closestChest, minDist
    end

    while task.wait(0.05) do
        local success, err = pcall(function()
            if not getgenv().mmb.ChestSettings["Start Farm Chest"]["Enable"] or isHopping then
                UpdateUI("Idle", FormatTime(os.time() - startTime), FormatNumber(earnedBeli), tostring(chestCount), "N/A")
                return
            end

            character = player.Character
            if not character or not character:FindFirstChild("HumanoidRootPart") or character.Humanoid.Health <= 0 then return end
            humanoidRootPart = character.HumanoidRootPart
            humanoid = character.Humanoid

            local closestChest, distance = findClosestChest()
            local elapsedTime = os.time() - startTime

            if closestChest then
                local chestId = tostring(closestChest)
                if trackedChests[chestId] and trackedChests[chestId] >= 2 then
                    closestChest, distance = findClosestChest()
                    if not closestChest then return end
                    chestId = tostring(closestChest)
                end

                if closestChest ~= lastTarget then
                    lastTarget = closestChest
                    topos(closestChest:GetPivot())
                end

                UpdateUI("Farming Chest", FormatTime(elapsedTime), FormatNumber(earnedBeli), tostring(chestCount), tostring(math.floor(distance / 3)))

                distance = (humanoidRootPart.Position - closestChest:GetPivot().Position).Magnitude
                if distance <= 10 then
                    local beliBefore = player.Data.Beli.Value
                    for i = 1, 2 do
                        game:GetService("VirtualInputManager"):SendKeyEvent(true, "Space", false, game)
                        task.wait(0.1)
                        game:GetService("VirtualInputManager"):SendKeyEvent(false, "Space", false, game)
                        task.wait(0.2)
                    end

                    trackedChests[chestId] = (trackedChests[chestId] or 0) + 1
                    closestChest:SetAttribute("IsDisabled", true)
                    task.wait(0.5)

                    local beliGained = player.Data.Beli.Value - beliBefore
                    if beliGained > 0 then
                        earnedBeli = earnedBeli + beliGained
                        chestCount = chestCount + 1
                        addLogEntry("+1", beliGained, false)
                        getgenv().Notify({
                            Title = "Chest Collected",
                            Description = "Done",
                            Content = "Gained " .. FormatNumber(beliGained) .. " Beli From Chest!",
                            Color = Color3.fromRGB(0, 255, 128),
                            Time = 0.5,
                            Delay = 2
                        })
                    end
                end

                -- Check Beli goal
                if player.Data.Beli.Value >= (getgenv().mmb.ChestSettings["Start Farm Chest"]["lock money"] or math.huge) then
                    getgenv().mmb.ChestSettings["Start Farm Chest"]["Enable"] = false
                    UpdateUI("Completed", FormatTime(elapsedTime), FormatNumber(player.Data.Beli.Value), tostring(chestCount), "N/A")
                    getgenv().Notify({
                        Title = "Abyss Chest",
                        Description = "Done",
                        Content = "Reached Beli goal of " .. FormatNumber(getgenv().mmb.ChestSettings["lock money"]) .. "!",
                        Color = Color3.fromRGB(0, 255, 0),
                        Time = 0.7,
                        Delay = 5
                    })
                    sendWebhook(
                        "Money Limit Reached",
                        "Farm stopped due to reaching Beli limit: " .. FormatNumber(getgenv().mmb.ChestSettings["Start Farm Chest"]["lock money"]),
                        chestCount,
                        elapsedTime,
                        true,
                        earnedBeli
                    )
                    return
                end

                -- Check server hop settings
                local hopSetting = getgenv().mmb.ChestSettings["Start Farm Chest"]["Hop After Collected"]
                if hopSetting and hopSetting ~= "" then
                    if hopSetting == "All" then
                        return
                    elseif tonumber(hopSetting) and chestCount >= tonumber(hopSetting) then
                        getgenv().mmb.ChestSettings["Start Farm Chest"]["Enable"] = false
                        isHopping = true
                        UpdateUI("Hopping", FormatTime(elapsedTime), FormatNumber(earnedBeli), tostring(chestCount), "N/A")                     
                        sendWebhook(
                            "Abyss Chest",
                            "Collected " .. chestCount .. " chests. Hopping Server!",
                            chestCount,
                            elapsedTime,
                            false,
                            earnedBeli
                        )
                        task.wait(1)               
                        CreateHopUI()
                        return
                    end
                end
            else
                local hopSetting = getgenv().mmb.ChestSettings["Start Farm Chest"]["Hop After Collected"]
                if hopSetting == "All" or not hopSetting or hopSetting == "" then
                    getgenv().mmb.ChestSettings["Start Farm Chest"]["Enable"] = false
                    isHopping = true
                    UpdateUI("Hopping", FormatTime(elapsedTime), FormatNumber(earnedBeli), tostring(chestCount), "N/A")
                                        sendWebhook(
                        "Abyss Chest",
                        "Hopping Server",
                        chestCount,
                        elapsedTime,
                        false,
                        earnedBeli
                    )
                    task.wait(1)
                    CreateHopUI()
                    return
                end
            end
        end)

        if not success then
            warn("Farming Error: " .. tostring(err))
        end
    end
end)
local WORLD2_PLACE_ID = 4442272183 -- Second Sea
local WORLD3_PLACE_ID = 7449423635 -- Third Sea
local hasSentWebhook = false

spawn(function()
    while task.wait(1) do
        if getgenv().mmb.ChestSettings["Stop When Have God's Chalice & Fist Of Darkness"]["Enable"] then
            local player = game.Players.LocalPlayer
            local character = player.Character
            local backpack = player:FindFirstChild("Backpack")
            
            if backpack and character then
                local hasFist = backpack:FindFirstChild("Fist of Darkness") or character:FindFirstChild("Fist of Darkness")
                local hasChalice = backpack:FindFirstChild("God's Chalice") or character:FindFirstChild("God's Chalice")
                
                if (hasFist or hasChalice) and not hasSentWebhook then -- Chỉ chạy nếu chưa gửi webhook
                    getgenv().mmb.ChestSettings["Start Farm Chest"]["Enable"] = false
                    isHopping = false
                    
                    local itemFound = hasFist and "Fist of Darkness" or "God's Chalice"
                    local worldName = game.PlaceId == WORLD2_PLACE_ID and "Second Sea" or 
                                    game.PlaceId == WORLD3_PLACE_ID and "Third Sea" or "Unknown World"
                    
                    local elapsedTime = os.time() - (startTime or os.time()) -- Tránh lỗi nếu startTime chưa định nghĩa
                    UpdateUI("Completed", FormatTime(elapsedTime), FormatNumber(earnedBeli or 0), tostring(chestCount or 0), "N/A")
                    
                    addLogEntry("Obtained " .. itemFound .. " in " .. worldName .. "!", nil, true)
                    getgenv().Notify({
                        Title = "Abyss Chest",
                        Description = "Item Found - Stopped All Operations",
                        Content = "Obtained " .. itemFound .. " in " .. worldName .. "!\nFarming and Hopping stopped.",
                        Color = Color3.fromRGB(255, 215, 0),
                        Time = 0.7,
                        Delay = 5
                    })
                    
                    -- Gửi webhook với 2 tham số như bạn yêu cầu
                    sendWebhook(
                        "Special Item",
                        "Found " .. itemFound .. " in " .. worldName .. "!"
                    )
                    hasSentWebhook = true -- Đánh dấu là đã gửi webhook
                    
                    local CoreGui = game:GetService("CoreGui")
                    local hopGui = CoreGui:FindFirstChild("HopGui")
                    if hopGui then
                        hopGui:Destroy()
                        local blur = game.Lighting:FindFirstChild("HopBlur")
                        if blur then blur:Destroy() end
                    end
                end
            end
        end
    end
end)
--//Automatically move to safety
spawn(function()
    while task.wait(1) do
        if getgenv().mmb.ChestSettings["Stop When Have God's Chalice & Fist Of Darkness"]["Automatically move to safety"] then
            local character = player.Character
            local backpack = player:FindFirstChild("Backpack")

            if backpack and character then
                local hasFist = backpack:FindFirstChild("Fist of Darkness") or character:FindFirstChild("Fist of Darkness")
                local hasChalice = backpack:FindFirstChild("God's Chalice") or character:FindFirstChild("God's Chalice")

                if hasFist or hasChalice then
                    local itemFound = hasFist and "Fist of Darkness" or "God's Chalice"
                    local worldName = hasFist and game.PlaceId == WORLD2_PLACE_ID and "Second Sea" or 
                                    hasChalice and game.PlaceId == WORLD3_PLACE_ID and "Third Sea" or "Unknown World"
                    
                    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                    if humanoidRootPart then
                        -- Define target position based on item
                        local targetCFrame
                        if itemFound == "God's Chalice" then
                            targetCFrame = CFrame.new(-5074.45556640625, 314.5155334472656, -2991.054443359375)
                        elseif itemFound == "Fist of Darkness" then
                            targetCFrame = CFrame.new(-380.47927856445, 77.220390319824, 255.82550048828)
                        end

                        -- Teleport to the target position
                        if targetCFrame then
                            topos(targetCFrame)
                        end

                        local elapsedTime = os.time() - startTime                   
                        UpdateUI("Move to a safe location", FormatTime(elapsedTime), FormatNumber(earnedBeli), tostring(chestCount), "N/A")
                        
                        local currentPosition = humanoidRootPart.CFrame.Position
                        local targetPos = targetCFrame.Position
                        local distance = (currentPosition - targetPos).Magnitude
                        
                        if distance < 5 then
                            getgenv().mmb.ChestSettings["Start Farm Chest"]["Stop When Have God's Chalice & Fist Of Darkness"]["Automatically move to safety when God's Chalice & Fist Of Darkness are present"] = false
                            break
                        end
                    end
                end
            end
        end
    end
end)
--// Skid 
--// 30k
--// Anti admin + Hop
local targetPlayers = {
    ["red_game43"] = true,
    ["rip_indra"] = true,
    ["Axiore"] = true,
    ["Polkster"] = true,
    ["wenlocktoad"] = true,
    ["Daigrock"] = true,
    ["toilamvidamme"] = true,
    ["oofficialnoobie"] = true,
    ["Uzoth"] = true,
    ["Azarth"] = true,
    ["arlthmetic"] = true,
    ["Death_King"] = true,
    ["Lunoven"] = true,
    ["TheGreateAced"] = true,
    ["rip_fud"] = true,
    ["drip_mama"] = true,
    ["layandikit12"] = true,
    ["Hingoi"] = true
}
spawn(function()
    while true do
        -- Use task.wait instead of wait for better performance
        task.wait(1)
        
        -- Error handling with pcall
        local success, err = pcall(function()
            for _, player in pairs(game.Players:GetPlayers()) do
                if targetPlayers[player.Name] and not isHopping then
                    isHopping = true        
                    -- Check if CreateHopUI exists before calling
                    if typeof(CreateHopUI) == "function" then
                        CreateHopUI()
                    else
                        warn("CreateHopUI function not found!")
                    end
                    break
                end
            end
        end)
        
        if not success then
            warn("Error in player detection loop: " .. err)
            isHopping = false -- Reset hopping status on error
            task.wait(2) -- Brief pause before retrying
        end
    end
end)

--// Get Notify Loaded
getgenv().Notify({
    Title = "Abyss Chest",
    Description = "Abyss Chest On Top",
    Content = "Script Stat: 🟢",
    Color = Color3.fromRGB(25, 99, 78),
    Time = 0.7,
    Delay = 5
})
