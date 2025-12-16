if not game:IsLoaded() then
    game.Loaded:Wait()
end

local existingGui = game.CoreGui:FindFirstChild("aikoware")
if existingGui then
    existingGui:Destroy()
end

local existingHirimi = game.CoreGui:FindFirstChild("HirimiGui")
if existingHirimi then
    existingHirimi:Destroy()
end

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/a11bove/kdoaz/refs/heads/main/loader/src.lua"))()

Library:MakeNotify({
    Title = "@aikoware",
    Description = "",
    Content = "99 Nights in The Forest Script Loaded!",
    Color = Color3.fromRGB(255,100,100),
    Delay = 3
})

local Window = Library:MakeGui({
    NameHub = "@aikoware ",
    Description = "| made by untog !",
    Color = Color3.fromRGB(81, 40, 128),
    ["Logo Player"] = "https://www.roblox.com/headshot-thumbnail/image?userId=544503914&width=420&height=420&format=png",
	["Name Player"] = "Protected By @aikoware"
})

-- toggle for gui
local gui = Instance.new("ScreenGui")
gui.Name = "aikoware"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.Parent = game.CoreGui

local button = Instance.new("ImageButton")
button.Size = UDim2.new(0, 53, 0, 53)
button.Position = UDim2.new(0, 60, 0, 60)
button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
button.BackgroundTransparency = 0.5
button.Image = "rbxassetid://140356301069419"
button.Name = "aikowaretoggle"
button.AutoButtonColor = true
button.Parent = gui

local corner = Instance.new("UICorner", button)
corner.CornerRadius = UDim.new(0, 12)

local stroke = Instance.new("UIStroke")
stroke.Thickness = 1.5
stroke.Color = Color3.fromRGB(45, 45, 45)
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
stroke.Parent = button

local gradient = Instance.new("UIGradient")
gradient.Color =
    ColorSequence.new {
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 100, 100)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 0, 0))
}
gradient.Rotation = 45
gradient.Parent = stroke

local dragging, dragInput, dragStart, startPos

button.InputBegan:Connect(
    function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = button.Position

            input.Changed:Connect(
                function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end
            )
        end
    end
)

button.InputChanged:Connect(
    function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end
)

game:GetService("UserInputService").InputChanged:Connect(
    function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            button.Position =
                UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end
)

button.MouseButton1Click:Connect(
    function()
        local HirimiGui = game.CoreGui:FindFirstChild("HirimiGui")
        if HirimiGui then
            local DropShadowHolder = HirimiGui:FindFirstChild("DropShadowHolder")
            if DropShadowHolder then
                DropShadowHolder.Visible = not DropShadowHolder.Visible
            end
        end
    end
)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local player = Players.LocalPlayer

local RunService = game:GetService("RunService")

local VirtualUser = game:GetService("VirtualUser")

local Stats = game:GetService("Stats")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

local workspace = Workspace

local character = player.Character or player.CharacterAdded:Wait()
local HumanoidRootPart = character:WaitForChild("HumanoidRootPart")

local Character = character
local rs = ReplicatedStorage

-- modular yarn
local FlyModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/a11bove/kdoaz/refs/heads/main/xzc/flynitf.lua"))()

local ESPModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/a11bove/kdoaz/refs/heads/main/xzc/espmdl.lua"))()

local AutoPlantModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/a11bove/kdoaz/refs/heads/main/xzc/autoplantmdl.lua"))()

local AuraModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/a11bove/kdoaz/refs/heads/main/xzc/auramdl.lua"))()

local VisionModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/a11bove/kdoaz/refs/heads/main/xzc/envmdl.lua"))()

local FunModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/a11bove/kdoaz/refs/heads/main/xzc/funmdl.lua"))()

local AntiModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/a11bove/kdoaz/refs/heads/main/xzc/antmdl.lua"))()

local TeleportModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/a11bove/kdoaz/refs/heads/main/xzc/tpmdl.lua"))()

-- start
local currentChests, currentChestNames = TeleportModule.getChests()
local selectedChest = currentChestNames[1] or nil

local currentMobs, currentMobNames = TeleportModule.getMobs()
local selectedMob = currentMobNames[1] or nil

local function notifyNoSapling(message)
    Library:MakeNotify({
        Title = "@aikoware",
        Description = "| Auto Plant",
        Content = message,
        Delay = 3,
    })
end

local function notify(content, description)
    Library:MakeNotify({
        Title = "@aokiware",
        Description = "| " .. description,
        Content = content,
        Delay = 2
    })
end

local flyToggle = FlyModule.flyToggle
local flySpeed = FlyModule.flySpeed
local FLYING = FlyModule.FLYING
local sFLY = FlyModule.sFLY
local NOFLY = FlyModule.NOFLY
local MobileFly = FlyModule.MobileFly
local UnMobileFly = FlyModule.UnMobileFly

local autoFeedToggle = false
local selectedFood = {}
local hungerThreshold = 75
local alwaysFeedEnabledItems = {}
local alimentos = {
    "Apple",
    "Berry",
    "Carrot",
    "Cake",
    "Chili",
    "Cooked Clownfish",
    "Cooked Swordfish",
    "Cooked Jellyfish",
    "Cooked Char",
    "Cooked Eel",
    "Cooked Shark",
    "Cooked Ribs",
    "Cooked Mackerel",
    "Cooked Salmon",
    "Cooked Morsel",
    "Cooked Steak"
}

local ie = {
    "Bandage", "Bolt", "Broken Fan", "Broken Microwave", "Cake", "Apple", "Carrot", "Chair", "Coal", "Coin Stack",
    "Cooked Morsel", "Cooked Steak", "Fuel Canister", "Iron Body", "Leather Body", "Obsidiron Body", "Log", "MadKit", "Metal Chair",
    "MedKit", "Old Car Engine", "Old Flashlight", "Old Radio", "Revolver", "Revolver Ammo", "Rifle", "Rifle Ammo",
    "Morsel", "Sheet Metal", "Steak", "Tyre", "Washing Machine", "Cultist Gem", "Cultist Staff", "Gem of the Forest Fragment", "Frozen Shuriken",
    "Tactical Shotgun", "Snowball", "Kunai", "Infernal Sword", "Infernal Sack", "Infernal Crossbow", "Crossbow", "Good Axe", "Good Sack",
}

local me = {"Bunny", "Wolf", "Alpha Wolf", "Bear", "Crossbow Cultist", "Alien", "Alien Elite", "Polar Bear", "Arctic Fox", "Meteor Crab", "Mammoth", "Cultist", "Cultist Melee", "Cultist Crossbow", "Cultist Juggernaut"}

local BlueprintItems = {"Crafting Blueprint", "Defense Blueprint", "Furniture Blueprint"}
local selectedBlueprintItems = {}
local PeltsItems = {"Bunny Foot", "Wolf Pelt", "Alpha Wolf Pelt", "Bear Pelt", "Arctic Fox Pelt", "Polar Bear Pelt"}
local selectedPeltsItems = {}
local junkItems = {"Bolt", "Sheet Metal", "UFO Junk", "UFO Component", "Broken Fan", "Old Radio", "Broken Microwave", "Tyre", "Metal Chair", "Old Car Engine", "Washing Machine", "Cultist Experiment", "Cultist Prototype", "Meteor Shard", "Gold Shard", "UFO Scrap", "Cultist Gem", "Gem of the Forest Fragment", "Feather", "Old Boot"}
local selectedJunkItems = {}
local fuelItems = {"Log", "Chair", "Coal", "Fuel Canister", "Oil Barrel"}
local selectedFuelItems = {}
local foodItems = {"Cake", "Cooked Steak", "Cooked Morsel", "Ribs", "Salmon", "Cooked Salmon", "Cooked Ribs", "Mackerel", "Cooked Mackerel", "Steak", "Morsel", "Berry", "Apple", "Carrot", "Chilli", "Stew", "Hearty Stew", "Corn", "Pumpkin", "Meat? Sandwich", "Pumpkin", "Seafood Chowder", "Steak Dinner", "Pumpkin Soup", "BBQ Ribs", "Carrot Cake", "Jar of Jelly", "Mackerel", "Salmon", "Clownfish", "Swordfish", "Jellyfish", "Char", "Eel", "Shark", "Cooked Clownfish", "Cooked Swordfish", "Cooked Jellyfish", "Cooked Char", "Cooked Eel", "Cooked Shark"}
local selectedFoodItems = {}
local medicalItems = {"Bandage", "MedKit"}
local selectedMedicalItems = {}
local cultistItems = {"Cultist", "Crossbow Cultist", "Cultist Juggernaut", "Bunny", "Wolf", "Alpha Wolf", "Bear", "Snow Bear", "Deer", "Owl", "Ram"}
local selectedCultistItems = {}
local equipmentItems = {"Revolver", "Rifle", "Revolver Ammo", "Rifle Ammo", "Infernal Sack", "Giant Sack", "Good Sack", "Strong Axe", "Good Axe", "Frozen Shuriken", "Tactical Shotgun", "Crossbow", "Infernal Crossbow", "Snowball", "Kunai", "Leather Body", "Poison Armour", "Iron Body", "Thorn Body", "Obsidiron Body", "Cultist Staff", "Riot Shield", "Alien Armour", "Axe Trim Kit", "Armour Trim Kit", "Red Key", "Blue Key", "Yellow Key", "Grey Key", "Frog Key", "Chili Seeds", "Flower Seeds", "Berry Seeds", "Firefly Seeds", "Old Rod", "Good Rod", "Strong Rod"}
local selectedEquipmentItems = {}

local craftableItems = {
    "Map", "Old Bed", "Bunny Trap", "Crafting Bench 2", "Sun Dial",
    "Regular Bed", "Compass", "Freezer", "Farm Plot", "Wood Rain Storage",
    "Shelf", "Log Wall", "Bear Trap", "Crock Pot", "Good Bed", "Radar",
    "Boost Pad", "Biofuel Processor", "Lighting Rod", "Torch", "Ammo Crate",
    "Giant Bed", "Oil Dril", "Teleporter", "Respawn Capsule",
    "Temporal Accelerometer", "Weather Machine"
}

local selectedCraftItems = {}

local craftingBenchItems = {
    "Crafting Bench 1",
    "Crafting Bench 2",
    "Crafting Bench 3",
    "Crafting Bench 4",
    "Crafting Bench 5"
}

local selectedBenchItems = {}

local isCollecting = false
local originalPosition = nil
local autoBringEnabled = false

local BlueprintToggleEnabled = false
local PeltsToggleEnabled = false
local junkToggleEnabled = false
local fuelToggleEnabled = false
local foodToggleEnabled = false
local medicalToggleEnabled = false
local cultistToggleEnabled = false
local equipmentToggleEnabled = false

local BlueprintLoopRunning = false
local PeltsLoopRunning = false
local junkLoopRunning = false
local fuelLoopRunning = false
local foodLoopRunning = false
local medicalLoopRunning = false
local cultistLoopRunning = false
local equipmentLoopRunning = false

local function bypassBringSystem(items, stopFlag)
    if isCollecting then 
        return 
    end

    isCollecting = true
    local player = game.Players.LocalPlayer

    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then 
        isCollecting = false
        return 
    end

    local hrp = player.Character.HumanoidRootPart
    originalPosition = hrp.CFrame

    for _, itemName in ipairs(items) do
        if stopFlag and not stopFlag() then
            break
        end

        local itemsFound = {}

        for _, item in ipairs(workspace:GetDescendants()) do
            if item.Name == itemName and (item:IsA("BasePart") or item:IsA("Model")) then
                local itemPart = item:IsA("Model") and (item.PrimaryPart or item:FindFirstChildWhichIsA("BasePart")) or item
                if itemPart and itemPart.Parent ~= player.Character then
                    table.insert(itemsFound, {item = item, part = itemPart})
                end
            end
        end

        for _, itemData in ipairs(itemsFound) do
            if stopFlag and not stopFlag() then
                break
            end

            local item = itemData.item
            local itemPart = itemData.part

            if itemPart and itemPart.Parent then
                local itemPos = itemPart.CFrame + Vector3.new(0, 5, 0)
                hrp.CFrame = itemPos

                local playerPos = hrp.Position + Vector3.new(0, -1, 0)
                pcall(function()
                    itemPart.CFrame = CFrame.new(playerPos)
                    itemPart.Velocity = Vector3.new(0, 0, 0)
                    itemPart.AngularVelocity = Vector3.new(0, 0, 0)
                end)

                hrp.CFrame = originalPosition

                pcall(function()
                    local landingPos = originalPosition.Position + Vector3.new(
                        math.random(-4, 4), 
                        2, 
                        math.random(-4, 4)
                    )
                    itemPart.CFrame = CFrame.new(landingPos)
                    itemPart.Velocity = Vector3.new(0, 0, 0)
                    itemPart.AngularVelocity = Vector3.new(0, 0, 0)
                end)
            end

            wait(0.1) 
        end
    end

    if originalPosition then
        hrp.CFrame = originalPosition
    end

    isCollecting = false
end

local campfireFuelItems = {"Log", "Coal", "Chair", "Fuel Canister", "Oil Barrel", "Biofuel"}
local campfireDropPos = Vector3.new(0, 19, 0)
local selectedCampfireItem = nil
local autoUpgradeCampfireEnabled = false

local scrapjunkItems = {"Log", "Chair", "Tyre", "Bolt", "Broken Fan", "Broken Microwave", "Sheet Metal", "Old Radio", "Washing Machine", "Old Car Engine", "Cultist Gem", "Gem of the Forest Fragment"}
local autoScrapPos = Vector3.new(21, 20, -5)
local selectedScrapItem = nil
local autoScrapItemsEnabled = false

local autocookItems = {"Morsel", "Steak", "Ribs", "Salmon", "Mackerel"}
local autoCookEnabledItems = {}
local autoCookEnabled = false

function wiki(nome)
    local c = 0
    for _, i in ipairs(Workspace.Items:GetChildren()) do
        if i.Name == nome then
            c = c + 1
        end
    end
    return c
end

function ghn()
    return math.floor(LocalPlayer.PlayerGui.Interface.StatBars.HungerBar.Bar.Size.X.Scale * 100)
end

function feed(nome)
    for _, item in ipairs(Workspace.Items:GetChildren()) do
        if item.Name == nome then
            ReplicatedStorage.RemoteEvents.RequestConsumeItem:InvokeServer(item)
            break
        end
    end
end

function notifeed(nome)
    Library:MakeNotify({
        Title = "@aikoware",
        Description = "| Auto Eat Paused",
        Content = "The food is gone!",
        Color = Color3.fromRGB(255,100,100),
        Delay = 3
    })
end

local function moveItemToPos(item, position)
    if not item or not item:IsDescendantOf(workspace) or not item:IsA("BasePart") and not item:IsA("Model") then return end
    local part = item:IsA("Model") and (item.PrimaryPart or item:FindFirstChildWhichIsA("BasePart") or item:FindFirstChild("Handle")) or item
    if not part or not part:IsA("BasePart") then return end

    if item:IsA("Model") and not item.PrimaryPart then
        pcall(function() item.PrimaryPart = part end)
    end

    pcall(function()
        game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents").RequestStartDraggingItem:FireServer(item)
        if item:IsA("Model") then
            item:SetPrimaryPartCFrame(CFrame.new(position))
        else
            part.CFrame = CFrame.new(position)
        end
        game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents").StopDraggingItem:FireServer(item)
    end)
end



local function bringItemsByPlayerTP(itemNames, originalPosition)
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then 
        return 
    end

    local hrp = LocalPlayer.Character.HumanoidRootPart
    local itemsFound = {}

    for _, itemName in ipairs(itemNames) do
        for _, item in ipairs(workspace:GetDescendants()) do
            if item.Name == itemName and (item:IsA("BasePart") or item:IsA("Model")) then
                local part = item:IsA("Model") and (item.PrimaryPart or item:FindFirstChildWhichIsA("BasePart")) or item
                if part and part:IsA("BasePart") then
                    table.insert(itemsFound, {item = item, part = part})
                end
            end
        end
    end

    for i, itemData in ipairs(itemsFound) do
        local item = itemData.item
        local part = itemData.part

        if item and item.Parent and part then
            local itemPosition = part.Position + Vector3.new(0, 3, 0)
            hrp.CFrame = CFrame.new(itemPosition)

            task.wait(0.2)

            pcall(function()
                ReplicatedStorage:WaitForChild("RemoteEvents").RequestStartDraggingItem:FireServer(item)
            end)

            task.wait(0.3)

            hrp.CFrame = CFrame.new(originalPosition)

            task.wait(0.2)

            pcall(function()
                ReplicatedStorage:WaitForChild("RemoteEvents").StopDraggingItem:FireServer(item)
            end)

            task.wait(0.5)
        end
    end

    hrp.CFrame = CFrame.new(originalPosition)
end

_G.playerBillboards = {}
_G.EspPlayerOn = false
_G.EspSize = 18

function createPlayerNameBillboard(player)
    if not player or not player.Character then
        return nil
    end

    local character = player.Character
    local head = character:FindFirstChild("Head")

    if not head then
        return nil
    end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "PlayerNameBillboard"
    billboard.Size = UDim2.new(0, 100, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 2, 0)
    billboard.Parent = head

    local label = Instance.new("TextLabel")
    label.Name = "NameLabel"
    label.Size = UDim2.new(1, 0, 1, 0)  
    label.BackgroundTransparency = 1
    label.Text = player.Name
    label.TextColor3 = Color3.new(1, 1, 1) 
    label.TextSize = _G.EspSize  
    label.TextScaled = false  
    label.Font = Enum.Font.Cartoon
    label.Parent = billboard

    _G.playerBillboards[player.Name] = billboard

    return billboard
end

for _, player in pairs(game:GetService("Players"):GetPlayers()) do
    if player ~= game:GetService("Players").LocalPlayer then
        createPlayerNameBillboard(player)
    end
end

game:GetService("Players").PlayerAdded:Connect(function(player)
    if player ~= game:GetService("Players").LocalPlayer then
        player.CharacterAdded:Connect(function()
            createPlayerNameBillboard(player)
        end)
    end
end)

local showFPS, showPing, showPlayers = true, true, false
local fpsCounter, fpsLastUpdate, fpsValue = 0, tick(), 0

local function createText(yOffset)
    local textObj = Drawing.new("Text")
    textObj.Size = 16
    textObj.Position = Vector2.new(Camera.ViewportSize.X - 110, yOffset)
    textObj.Color = Color3.fromRGB(0, 255, 0)
    textObj.Center = false
    textObj.Outline = true
    textObj.Visible = true
    return textObj
end

local fpsText = createText(10)
local msText = createText(30)
local playersText = createText(50)

Camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
    fpsText.Position = Vector2.new(Camera.ViewportSize.X - 110, 10)
    msText.Position = Vector2.new(Camera.ViewportSize.X - 110, 30)
    playersText.Position = Vector2.new(Camera.ViewportSize.X - 110, 50)
end)

RunService.RenderStepped:Connect(function()
    fpsCounter += 1

    if tick() - fpsLastUpdate >= 1 then
        fpsValue = fpsCounter
        fpsCounter = 0
        fpsLastUpdate = tick()

        if showFPS then
            fpsText.Text = string.format("Fps: %d", fpsValue)
            fpsText.Color = fpsValue >= 50 and Color3.fromRGB(0, 255, 0)
                or fpsValue >= 30 and Color3.fromRGB(255, 165, 0)
                or Color3.fromRGB(255, 0, 0)
            fpsText.Visible = true
        else
            fpsText.Visible = false
        end

        if showPing then
            local pingStat = Stats.Network.ServerStatsItem["Data Ping"]
            local ping = pingStat and math.floor(pingStat:GetValue()) or 0
            local color, label = Color3.fromRGB(0, 255, 0), "Ping: "

            if ping > 120 then
                color, label = Color3.fromRGB(255, 0, 0), "Ping: "
            elseif ping > 60 then
                color = Color3.fromRGB(255, 165, 0)
            end

            msText.Text = string.format("%s%d ms", label, ping)
            msText.Color = color
            msText.Visible = true
        else
            msText.Visible = false
        end

        if showPlayers then
            local currentPlayers = #Players:GetPlayers()
            local maxPlayers = Players.MaxPlayers
            local color = Color3.fromRGB(0, 255, 0) 

            if currentPlayers >= maxPlayers - 1 then
                color = Color3.fromRGB(255, 0, 0) 
            elseif currentPlayers >= maxPlayers - 4 then
                color = Color3.fromRGB(255, 165, 0) 
            elseif currentPlayers <= 4 then
                color = Color3.fromRGB(135, 206, 235) 
            end

            playersText.Text = string.format("Players: %d/%d", currentPlayers, maxPlayers)
            playersText.Color = color
            playersText.Visible = true
        else
            playersText.Visible = false
        end
    end
end)

local AutoPlantToggle = false

local function autoplant()
    while AutoPlantToggle do
        local args = {
            Instance.new("Model"),
            Vector3.new(-41.2053, 1.0633, 29.2236)
        }
        game:GetService("ReplicatedStorage")
            :WaitForChild("RemoteEvents")
            :WaitForChild("RequestPlantItem")
            :InvokeServer(unpack(args))
        task.wait(1)
    end
end

local MobsFolder = workspace.Characters
local ToolDamageEvent = game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("ToolDamageObject")

local MobsList = {"Cultist", "Crossbow Cultist", "Cultist Juggernaut", "Bunny", "Wolf", "Alpha Wolf", "Bear", "Snow Bear", "Meteor Crab", "Deer", "Owl", "Ram"}
local SelectedMobs = {}
local HitBoxSize = 50
local HitboxesActive = false

local function OnHitConnect(hit, mobModel)
    if hit and hit.Parent then
        local player = game.Players:GetPlayerFromCharacter(hit.Parent)
        if player then
            ToolDamageEvent:FireServer(mobModel) 
        end
    end
end

local function CreateHitboxForMob(mob)
    local primary = mob:FindFirstChild("HumanoidRootPart") or mob.PrimaryPart
    if not primary then return end

    local old = mob:FindFirstChild("HitBoxForMob")
    if old then
        old:Destroy()
    end

    local hitbox = Instance.new("Part")
    hitbox.Name = "HitBoxForMob"
    hitbox.Size = Vector3.new(HitBoxSize, HitBoxSize, HitBoxSize)
    hitbox.Shape = Enum.PartType.Ball
    hitbox.Color = Color3.fromRGB(138, 43, 226)
    hitbox.Transparency = 1
    hitbox.CanCollide = false
    hitbox.Anchored = false
    hitbox.Massless = true
    hitbox.CFrame = primary.CFrame
    hitbox.Parent = mob

    local weld = Instance.new("WeldConstraint")
    weld.Part0 = hitbox
    weld.Part1 = primary
    weld.Parent = hitbox

    hitbox.Touched:Connect(function(hit)
        OnHitConnect(hit, mob)
    end)
end

local function RemoveHitboxFromMob(mob)
    local hitbox = mob:FindFirstChild("HitBoxForMob")
    if hitbox then
        hitbox:Destroy()
    end
end

local function UpdateHitboxes()
    if not HitboxesActive then return end

    for _, mob in ipairs(MobsFolder:GetChildren()) do
        if mob:IsA("Model") then
            local shouldHaveHitbox = table.find(SelectedMobs, mob.Name)
            local hasHitbox = mob:FindFirstChild("HitBoxForMob")

            if shouldHaveHitbox and not hasHitbox then
                CreateHitboxForMob(mob)
            elseif not shouldHaveHitbox and hasHitbox then
                RemoveHitboxFromMob(mob)
            elseif shouldHaveHitbox and hasHitbox then
                local hitbox = mob:FindFirstChild("HitBoxForMob")
                if hitbox and hitbox.Size.X ~= HitBoxSize then
                    hitbox.Size = Vector3.new(HitBoxSize, HitBoxSize, HitBoxSize)
                end
            end
        end
    end
end

local function AddAllHitboxes()
    HitboxesActive = true
    for _, mob in ipairs(MobsFolder:GetChildren()) do
        if mob:IsA("Model") and table.find(SelectedMobs, mob.Name) then
            CreateHitboxForMob(mob)
        end
    end
end

local function RemoveAllHitboxes()
    HitboxesActive = false
    for _, mob in ipairs(MobsFolder:GetChildren()) do
        if mob:IsA("Model") then
            RemoveHitboxFromMob(mob)
        end
    end
end

MobsFolder.ChildAdded:Connect(function(child)
    if HitboxesActive and child:IsA("Model") and table.find(SelectedMobs, child.Name) then
        wait(0.1)
        CreateHitboxForMob(child)
    end
end)

local TreeFold = workspace.Map.Landmarks
local TreeTypes = {"Tree Small"} 
local SelectedTrees = {}
local TreeHitBoxSize = 30
local TreeHitboxesActive = false

local function OnTreeHitConnect(hit, treeModel)
    if hit and hit.Parent then
        local player = game.Players:GetPlayerFromCharacter(hit.Parent)
        if player then
            ToolDamageEvent:FireServer(treeModel) 
        end
    end
end

local function CreateHitboxForTree(tree)
    local primary = tree:FindFirstChild("Trunk") or tree.PrimaryPart or tree:FindFirstChildOfClass("Part")
    if not primary then return end

    local old = tree:FindFirstChild("HitBoxForTree")
    if old then
        old:Destroy()
    end

    local hitbox = Instance.new("Part")
    hitbox.Name = "HitBoxForTree"
    hitbox.Size = Vector3.new(TreeHitBoxSize, TreeHitBoxSize, TreeHitBoxSize)
    hitbox.Shape = Enum.PartType.Ball
    hitbox.Color = Color3.fromRGB(34, 139, 34)
    hitbox.Transparency = 0.6
    hitbox.CanCollide = false
    hitbox.Anchored = false
    hitbox.Massless = true
    hitbox.CFrame = primary.CFrame
    hitbox.Parent = tree

    local weld = Instance.new("WeldConstraint")
    weld.Part0 = hitbox
    weld.Part1 = primary
    weld.Parent = hitbox

    hitbox.Touched:Connect(function(hit)
        OnTreeHitConnect(hit, tree)
    end)
end

local function RemoveHitboxFromTree(tree)
    local hitbox = tree:FindFirstChild("HitBoxForTree")
    if hitbox then
        hitbox:Destroy()
    end
end

local function UpdateTreeHitboxes()
    if not TreeHitboxesActive then return end

    for _, tree in ipairs(TreeFold:GetChildren()) do
        local isCorrectType = tree:IsA("Model") or tree:IsA("BasePart")
        local isSelected = table.find(SelectedTrees, tree.Name)

        if isCorrectType and isSelected then
            local hasHitbox = tree:FindFirstChild("HitBoxForTree")

            if hasHitbox then
                local hitbox = tree:FindFirstChild("HitBoxForTree")
                if hitbox and hitbox.Size.X ~= TreeHitBoxSize then
                    hitbox.Size = Vector3.new(TreeHitBoxSize, TreeHitBoxSize, TreeHitBoxSize)
                end
            else
                CreateHitboxForTree(tree)
            end
        elseif tree:FindFirstChild("HitBoxForTree") and not isSelected then
            RemoveHitboxFromTree(tree)
        end
    end
end 

local function AddAllTreeHitboxes()
    TreeHitboxesActive = true
    for _, tree in ipairs(TreeFold:GetChildren()) do
        local isCorrectType = tree:IsA("Model") or tree:IsA("BasePart")
        local isSelected = table.find(SelectedTrees, tree.Name)

        if isCorrectType and isSelected then
            CreateHitboxForTree(tree)
        end
    end
end

local function RemoveAllTreeHitboxes()
    TreeHitboxesActive = false
    for _, tree in ipairs(TreeFold:GetChildren()) do
        if tree:IsA("Model") or tree:IsA("BasePart") then
            RemoveHitboxFromTree(tree)
        end
    end
end

TreeFold.ChildAdded:Connect(function(child)
    local isCorrectType = child:IsA("Model") or child:IsA("BasePart")
    local isSelected = table.find(SelectedTrees, child.Name)

    if TreeHitboxesActive and isCorrectType and isSelected then
        wait(0.1)
        CreateHitboxForTree(child)
    end
end)

local Home = Window:CreateTab({
    Name = "Home",
    Icon = "rbxassetid://10723407389"
})

local Combat = Window:CreateTab({
    Name = "Combat",
    Icon = "rbxassetid://10734975692"
})

local Camp = Window:CreateTab({
    Name = "Auto",
    Icon = "rbxassetid://10734933826"
})

local br = Window:CreateTab({
    Name = "Bring",
    Icon = "rbxassetid://10734909540"
})

local Fly = Window:CreateTab({
    Name = "Player",
    Icon = "rbxassetid://10747373176"
})

local esp = Window:CreateTab({
    Name = "Esp",
    Icon = "rbxassetid://10723346959"
})

local Tp = Window:CreateTab({
    Name = "Teleport",
    Icon = "rbxassetid://10734886004"
})

local Vision = Window:CreateTab({
    Name = "Environment",
    Icon = "rbxassetid://10723425539"
})

local Fun = Window:CreateTab({
    Name = "Fun",
    Icon = "rbxassetid://10734966248"
})

local Misc = Window:CreateTab({
    Name = "Others",
    Icon = "rbxassetid://10734954538"
})

local infO = Home:AddSection("Anti AFK")

infO:AddToggle({
    Title = "Enable Anti AFK",
    Content = "",
    Default = false,
    Callback = function(state)
            if state then
                    task.spawn(function()
                        while state do
                            if not LocalPlayer then
                                return
                            end;
                            VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
                            VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
                            task.wait(40)
                        end
                    end)
                else
                end
            end
})

local vissettings = Home:AddSection("Visual Settings")

ShowFps = vissettings:AddToggle({
    Title = "Show Fps",
    Content = "",
    Default = true,
    Callback = function(val)
        showFPS = val
        fpsText.Visible = val
    end
})

ShowPing = vissettings:AddToggle({
    Title = "Show Ping",
    Content = "",
    Default = true,
    Callback = function(val)
        showPing = val
        msText.Visible = val
    end
})

ShowPlayers = vissettings:AddToggle({
    Title = "Show Players",
    Content = "",
    Default = false,
    Callback = function(val)
        showPlayers = val
        playersText.Visible = val
    end
})

local Grapics = Home:AddSection("Graphics")

Grapics:AddButton({
    Title = "Boost Fps",
    Content = "",
    Callback = function()
        pcall(function()
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
            local lighting = game:GetService("Lighting")
            lighting.Brightness = 1
            lighting.FogEnd = 1000000
            lighting.GlobalShadows = false
            lighting.EnvironmentDiffuseScale = 0
            lighting.EnvironmentSpecularScale = 0
            lighting.ClockTime = 14
            lighting.OutdoorAmbient = Color3.new(0, 0, 0)
            local terrain = workspace:FindFirstChildOfClass("Terrain")
            if terrain then
                terrain.WaterWaveSize = 0
                terrain.WaterWaveSpeed = 0
                terrain.WaterReflectance = 0
                terrain.WaterTransparency = 1
            end
            for _, obj in ipairs(lighting:GetDescendants()) do
                if obj:IsA("PostEffect") or obj:IsA("BloomEffect") or obj:IsA("ColorCorrectionEffect") or obj:IsA("SunRaysEffect") or obj:IsA("BlurEffect") then
                    obj.Enabled = false
                end
            end
            for _, obj in ipairs(game:GetDescendants()) do
                if obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
                    obj.Enabled = false
                elseif obj:IsA("Texture") or obj:IsA("Decal") then
                    obj.Transparency = 1
                end
            end
            for _, part in ipairs(workspace:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CastShadow = false
                end
            end
        end)
    end
})

Grapics:AddButton({
    Title = "Low GFX",
    Content = "",
    Callback = function()
        pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/a11bove/kdoaz/refs/heads/main/xzc/lowgfx.lua"))()
        end)
    end
})

local infosec = Home:AddSection("Information")

infosec:AddParagraph({
    Title = "Warning:",
    Content = "I made this script for testing purposes only, I am not responsible for any bans or any other consequences."
})

infosec:AddParagraph({
    Title = "Discord:",
    Content = "Join to our discord server for more updates and information."
})

infosec:AddButton({
    Title = "Copy Server Invite",
    Content = "",
    Callback = function()
            setclipboard("https://discord.gg/JccfFGpDNV")
        Library:MakeNotify({
            Title = "@aikoware",
            Description = "",
            Content = "Link Copied!"
        })
    end
})

local aur = Combat:AddSection("Aura")

aur:AddToggle({
    Title = "Kill Aura",
    Content = "",
    Default = false,
    Callback = function(state)
        if state then
            AuraModule.StartKillAura()
        else
            AuraModule.StopKillAura()
        end
    end
})

aur:AddToggle({
    Title = "Chop Aura",
    Content = "",
    Default = false,
    Callback = function(state)
        if state then
            AuraModule.StartChopAura()
        else
            AuraModule.StopChopAura()
        end
    end
})

aur:AddSlider({
    Title = "Aura Radius",
    Content = "",
    Min = 1,
    Max = 200,
    Default = 50,
    Callback = function(value)
        AuraModule.SetAuraRadius(value)
    end
})

local hbmob = Combat:AddSection("Hitbox Mobs")

hbmob:AddDropdown({
    Title = "Select Mobs",
    Content = "Select mobs to add hitbox.",
    Multi = true,
    Options = MobsList,
    Default = {},
    Callback = function(options)
        SelectedMobs = options
        UpdateHitboxes()
    end
})

hbmob:AddSlider({
    Title = "Hitbox Size",
    Content = "",
    Min = 20,
    Max = 100,
    Default = 50,
    Callback = function(value)
            HitBoxSize = value
                if HitboxesActive then
                    for _, mob in ipairs(MobsFolder:GetChildren()) do
                        if mob:IsA("Model") and table.find(SelectedMobs, mob.Name) then
                            local hitbox = mob:FindFirstChild("HitBoxForMob")
                            if hitbox then
                                hitbox.Size = Vector3.new(HitBoxSize, HitBoxSize, HitBoxSize)
                            end
                        end
                    end
                end
            end
})

hbmob:AddToggle({
    Title = "Expand Hitbox",
    Content = "",
    Default = false,
    Callback = function(state) 
        if state then
            pcall(function()
                AddAllHitboxes()
            end)
        else
                RemoveAllHitboxes()
        end
    end
})

local apln = Camp:AddSection("Auto Plant")

apln:AddToggle({
    Title = "Auto Plant",
    Content = "Plant saplings around base",
    Default = false,
    Callback = function(state) 
        if state then
            pcall(function()
                AutoPlantModule.StartAutoPlant(notifyNoSapling)
            end)
        else
            AutoPlantModule.StopAutoPlant()
        end
    end
})

apln:AddSlider({
    Title = "Plant Radius",
    Content = "",
    Min = 50,
    Max = 100,
    Default = 50,
    Callback = function(value)
        AutoPlantModule.SetPlantRadius(value)
    end
})

local aucf = Camp:AddSection("Auto Upgrade Campfire")

local selectedCampfireItems = {}

aucf:AddDropdown({
    Title = "Select Item",
    Content = "Select an item to upgrade campfire.",
    Multi = true,
    Options = campfireFuelItems,
    Default = {},
    Callback = function(options)
        selectedCampfireItems = options or {}
    end
})

aucf:AddToggle({
    Title = "Enable Auto Upgrade Campfire",
    Content = "",
    Default = false,
    Callback = function(checked)
        autoUpgradeCampfireEnabled = checked
        if checked then
            task.spawn(function()
                while autoUpgradeCampfireEnabled do
                    if #selectedCampfireItems > 0 then
                        for _, selectedItem in ipairs(selectedCampfireItems) do
                            local items = {}

                            for _, item in ipairs(workspace:WaitForChild("Items"):GetChildren()) do
                                if item.Name == selectedItem then
                                    table.insert(items, item)
                                end
                            end

                            local count = math.min(10, #items)
                            for i = 1, count do
                                moveItemToPos(items[i], campfireDropPos)
                            end
                        end
                    end
                    task.wait(1)
                end
            end)
        end
    end
})

local ascr = Camp:AddSection("Auto Scrap")

ascr:AddDropdown({
    Title = "Select Item",
    Content = "Select an item for auto scrap.",
    Multi = true,
    Options = scrapjunkItems,
    Default = {},
    Callback = function(option)
        selectedScrapItem = option
    end
})

ascr:AddToggle({
    Title = "Enable Auto Scrap",
    Content = "",
    Default = false,
    Callback = function(checked)
        autoScrapItemsEnabled = checked
        if checked then
            task.spawn(function()
                while autoScrapItemsEnabled do
                    if selectedScrapItem then
                        local items = {}

                        for _, item in ipairs(workspace:WaitForChild("Items"):GetChildren()) do
                            if item.Name == selectedScrapItem then
                                table.insert(items, item)
                            end
                        end

                        local count = math.min(10, #items)
                        for i = 1, count do
                            moveItemToPos(items[i], autoScrapPos)
                        end
                    end

                    task.wait(1)
                end
            end)
        end
    end
})

local acok = Camp:AddSection("Auto Cook")

acok:AddDropdown({
    Title = "Select Food",
    Content = "Select a food to cook.",
    Multi = true,
    Options = autocookItems,
    Default = {},
    Callback = function(options)
            for _, itemName in ipairs(autocookItems) do
                    autoCookEnabledItems[itemName] = table.find(options, itemName) ~= nil
                end
            end
})

acok:AddToggle({
    Title = "Enable Auto Cook",
    Content = "",
    Default = false,
    Callback = function(state)
        autoCookEnabled = state
    end
})

coroutine.wrap(function()
    while true do
        if autoCookEnabled then
            for itemName, enabled in pairs(autoCookEnabledItems) do
                if enabled then
                    for _, item in ipairs(Workspace:WaitForChild("Items"):GetChildren()) do
                        if item.Name == itemName then
                            moveItemToPos(item, campfireDropPos)
                        end
                    end
                end
            end
        end
        task.wait(0.5)
    end
end)()

local acft = Camp:AddSection("Auto Craft")

acft:AddDropdown({
    Title = "Select Item",
    Content = "Select an items to craft.",
    Multi = true,
    Options = craftableItems,
    Default = {},
    Callback = function(options)
            selectedCraftItems = options or {}
            end
})

acft:AddToggle({
    Title = "Enable Auto Craft",
    Content = "",
    Default = false,
    Callback = function(checked)
        autoCraftEnabled = checked
        if checked then
            task.spawn(function()
                while autoCraftEnabled do
                    if #selectedCraftItems > 0 then
                        for _, itemName in ipairs(selectedCraftItems) do
                            local args = { itemName }
                            game:GetService("ReplicatedStorage")
                                :WaitForChild("RemoteEvents")
                                :WaitForChild("CraftItem")
                                :InvokeServer(unpack(args))
                        end
                    end
                    task.wait(0.5)
                end
            end)
        end
    end
})

local bnch = Camp:AddSection("Auto Upgrade Crafting Bench")

bnch:AddDropdown({
    Title = "Select Bench",
    Content = "Select a bench to upgrade.",
    Multi = true,
    Options = craftingBenchItems,
    Default = {},
    Callback = function(options)
            selectedBenchItems = options or {}
            end
})

bnch:AddToggle({
    Title = "Enable Auto Upgrade Bench",
    Content = "",
    Default = false,
    Callback = function(checked)
        autoUpgradeBenchEnabled = checked
        if checked then
            task.spawn(function()
                while autoUpgradeBenchEnabled do
                    if #selectedBenchItems > 0 then
                        for _, bench in ipairs(selectedBenchItems) do
                            local args = { bench }
                            game:GetService("ReplicatedStorage")
                                :WaitForChild("RemoteEvents")
                                :WaitForChild("CraftItem")
                                :InvokeServer(unpack(args))
                        end
                    end
                    task.wait(0.5)
                end
            end)
        end
    end
})

local bpr =br:AddSection("Blueprint")

bpr:AddDropdown({
    Title = "Select Blueprint",
    Content = "Select blueprints to bring",
    Multi = true,
    Options = selectedBlueprintItems,
    Default = {},
    Callback = function(options)
            selectedBlueprintItems = options
            end
})

bpr:AddToggle({
    Title = "Bring Blueprints",
    Content = "",
    Default = false,
    Callback = function(value)
        BlueprintToggleEnabled = value

        if value then
            if #selectedBlueprintItems > 0 then
                BlueprintLoopRunning = true
                spawn(function()
                    while BlueprintLoopRunning and BlueprintToggleEnabled do
                        if #selectedBlueprintItems > 0 and BlueprintToggleEnabled then
                            bypassBringSystem(selectedBlueprintItems, function() return BlueprintToggleEnabled end)
                        end

                        local waitTime = 0
                        while waitTime < 3 and BlueprintToggleEnabled and BlueprintLoopRunning do
                            wait(0.1)
                            waitTime = waitTime + 0.1
                        end
                    end
                    BlueprintLoopRunning = false
                end)
            else
                BlueprintToggleEnabled = false
            end
        else
            BlueprintLoopRunning = false
        end
    end
})

local plt = br:AddSection("Pelts")

plt:AddDropdown({
    Title = "Select Pelt",
    Content = "Select pelts to bring.",
    Multi = true,
    Options = PeltsItems,
    Default = {},
    Callback = function(options)
        selectedPeltsItems = options
    end
})

plt:AddToggle({
    Title = "Bring Pelts",
    Content = "",
    Default = false,
    Callback = function(value)
        PeltsToggleEnabled = value

        if value then
            if #selectedPeltsItems > 0 then
                PeltsLoopRunning = true
                spawn(function()
                    while PeltsLoopRunning and PeltsToggleEnabled do
                        if #selectedPeltsItems > 0 and PeltsToggleEnabled then
                            bypassBringSystem(selectedPeltsItems, function() return PeltsToggleEnabled end)
                        end

                        local waitTime = 0
                        while waitTime < 3 and PeltsToggleEnabled and PeltsLoopRunning do
                            wait(0.1)
                            waitTime = waitTime + 0.1
                        end
                    end
                    PeltsLoopRunning = false
                end)
            else
                PeltsToggleEnabled = false
            end
        else
            PeltsLoopRunning = false
        end
    end
})

local scr = br:AddSection("Scrap")

scr:AddDropdown({
    Title = "Select Scrap",
    Content = "Select scraps to bring",
    Multi = true,
    Options = junkItems,
    Default = {},
    Callback = function(options)
    selectedJunkItems = options
    end
})

scr:AddToggle({
    Title = "Bring Scraps",
    Content = "",
    Default = false,
    Callback = function(value)
        junkToggleEnabled = value

        if value then
            if #selectedJunkItems > 0 then
                junkLoopRunning = true
                spawn(function()
                    while junkLoopRunning and junkToggleEnabled do
                        if #selectedJunkItems > 0 and junkToggleEnabled then
                            bypassBringSystem(selectedJunkItems, function() return junkToggleEnabled end)
                        end

                        local waitTime = 0
                        while waitTime < 3 and junkToggleEnabled and junkLoopRunning do
                            wait(0.1)
                            waitTime = waitTime + 0.1
                        end
                    end
                    junkLoopRunning = false
                end)
            else
                junkToggleEnabled = false
            end
        else
            junkLoopRunning = false
        end
    end
})

local ful = br:AddSection("Fuel")

ful:AddDropdown({
    Title = "Select Fuel",
    Content = "Select fuel to bring.",
    Multi = true,
    Options = fuelItems,
    Default = {},
    Callback = function(options)
    selectedFuelItems = options
    end
})

ful:AddToggle({
    Title = "Bring Fuels",
    Content = "",
    Default = false,
    Callback = function(value)
        fuelToggleEnabled = value

        if value then
            if #selectedFuelItems > 0 then
                fuelLoopRunning = true
                spawn(function()
                    while fuelLoopRunning and fuelToggleEnabled do
                        if #selectedFuelItems > 0 and fuelToggleEnabled then
                            bypassBringSystem(selectedFuelItems, function() return fuelToggleEnabled end)
                        end

                        local waitTime = 0
                        while waitTime < 3 and fuelToggleEnabled and fuelLoopRunning do
                            wait(0.1)
                            waitTime = waitTime + 0.1
                        end
                    end
                    fuelLoopRunning = false
                end)
            else
                fuelToggleEnabled = false
            end
        else
            fuelLoopRunning = false
        end
    end
})

local fod = br:AddSection("Food")

fod:AddDropdown({
    Title = "Select Food",
    Content = "Select food to bring.",
    Multi = true,
    Options = foodItems,
    Default = {},
    Callback = function(options)
    selectedFoodItems = options
    end
})

fod:AddToggle({
    Title = "Bring Foods",
    Content = "",
    Default = false,
    Callback = function(value)
        foodToggleEnabled = value

        if value then
            if #selectedFoodItems > 0 then
                foodLoopRunning = true
                spawn(function()
                    while foodLoopRunning and foodToggleEnabled do
                        if #selectedFoodItems > 0 and foodToggleEnabled then
                            bypassBringSystem(selectedFoodItems, function() return foodToggleEnabled end)
                        end


                        local waitTime = 0
                        while waitTime < 3 and foodToggleEnabled and foodLoopRunning do
                            wait(0.1)
                            waitTime = waitTime + 0.1
                        end
                    end
                    foodLoopRunning = false                 
                end)
            else                
                foodToggleEnabled = false
            end
        else
            foodLoopRunning = false          
        end
    end
})

local med = br:AddSection("Medical Items")

med:AddDropdown({
    Title = "Select Medical Items",
    Content = "Select medical items to bring.",
    Multi = true,
    Options = medicalItems,
    Default = {},
    Callback = function(options)
    selectedMedicalItems = options
    end
})

med:AddToggle({
    Title = "Bring Medical Items",
    Content = "",
    Default = false,
    Callback = function(value)
        medicalToggleEnabled = value

        if value then
            if #selectedMedicalItems > 0 then
                medicalLoopRunning = true
                spawn(function()
                    while medicalLoopRunning and medicalToggleEnabled do
                        if #selectedMedicalItems > 0 and medicalToggleEnabled then
                            bypassBringSystem(selectedMedicalItems, function() return medicalToggleEnabled end)
                        end


                        local waitTime = 0
                        while waitTime < 3 and medicalToggleEnabled and medicalLoopRunning do
                            wait(0.1)
                            waitTime = waitTime + 0.1
                        end
                    end
                    medicalLoopRunning = false
                end)
            else
                medicalToggleEnabled = false
            end
        else
            medicalLoopRunning = false
        end
    end
})

local mobz = br:AddSection("Mobs")

mobz:AddDropdown({
    Title = "Select Mobs",
    Content = "Select mobs to bring.",
    Multi = true,
    Options = cultistItems,
    Default = {},
    Callback = function(options)
            selectedCultistItems = options
                end
})

mobz:AddToggle({
    Title = "Bring Mobs",
    Content = "",
    Default = false,
    Callback = function(value)
        cultistToggleEnabled = value

        if value then
            if #selectedCultistItems > 0 then
                cultistLoopRunning = true
                spawn(function()
                    while cultistLoopRunning and cultistToggleEnabled do
                        if #selectedCultistItems > 0 and cultistToggleEnabled then
                            bypassBringSystem(selectedCultistItems, function() return cultistToggleEnabled end)
                        end


                        local waitTime = 0
                        while waitTime < 3 and cultistToggleEnabled and cultistLoopRunning do
                            wait(0.1)
                            waitTime = waitTime + 0.1
                        end
                    end
                    cultistLoopRunning = false
                end)
            else
                cultistToggleEnabled = false
            end
        else
            cultistLoopRunning = false
        end
    end
})

local eqp = br:AddSection("Equipment")

eqp:AddDropdown({
    Title = "Select Equipments",
    Content = "Select an equipments to bring.",
    Multi = true,
    Options = equipmentItems,
    Default = {},
    Callback = function(options)
    selectedEquipmentItems = options
    end
})

eqp:AddToggle({
    Title = "Bring Equipments",
    Content = "",
    Default = false,
    Callback = function(value)
        equipmentToggleEnabled = value

        if value then
            if #selectedEquipmentItems > 0 then
                equipmentLoopRunning = true
                spawn(function()
                    while equipmentLoopRunning and equipmentToggleEnabled do
                        if #selectedEquipmentItems > 0 and equipmentToggleEnabled then
                            bypassBringSystem(selectedEquipmentItems, function() return equipmentToggleEnabled end)
                        end


                        local waitTime = 0
                        while waitTime < 3 and equipmentToggleEnabled and equipmentLoopRunning do
                            wait(0.1)
                            waitTime = waitTime + 0.1
                        end
                    end
                    equipmentLoopRunning = false
                end)
            else
                equipmentToggleEnabled = false
            end
        else
            equipmentLoopRunning = false
        end
    end
})

local saps = br:AddSection("Sapling")

saps:AddToggle({
    Title = "Bring Saplings",
    Content = "",
    Default = false,
    Callback = function(value)
        autoPlantEnabled = value

        if value then
            autoPlantLoop = true
            spawn(function()
                while autoPlantLoop and autoPlantEnabled do
                    bypassBringSystem({"Sapling"}, function() return autoPlantEnabled end)

                    if not autoPlantEnabled then break end

                    local args = {
                        Instance.new("Model", nil)
                    }
                    game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("RequestPlantItem"):InvokeServer(unpack(args))

                    local waitTime = 0
                    while waitTime < 3 and autoPlantEnabled and autoPlantLoop do
                        task.wait(0.1)
                        waitTime = waitTime + 0.1
                    end
                end
                autoPlantLoop = false
            end)
        else
            autoPlantLoop = false
        end
    end
})

local vis = esp:AddSection("Players")

vis:AddToggle({
    Title = "Enable Esp Players",
    Content = "",
    Default = false,
    Callback = function(enable)
        ESPModule.EspPlayerOn = enable
        if enable then
            pcall(function()
                createPlayerNameBillboard(player)
            end)
        else
            ESPModule.EspPlayerOn = false
        end
    end
})

--[[ local trevis = esp:AddSection("Tree Health")

trevis:AddToggle({
    Title = "Enable Esp Tree Health",
    Content = "",
    Default = false,
    Callback = function(enable)
        if enable then
            ESPModule.enableTreeESP()
        else
            ESPModule.disableTreeESP()
        end
    end
}) ]]

local itemvis = esp:AddSection("Items")

itemvis:AddDropdown({
    Title = "Esp Items",
    Content = "",
    Multi = true,
    Options = ie,
    Default = {},
    Callback = function(options)
        ESPModule.selectedItems = options
        ESPModule.UpdateItemsESP(ie)
    end
})

itemvis:AddToggle({
    Title = "Enable Esp Items",
    Content = "",
    Default = false,
    Callback = function(state)
        ESPModule.ToggleItemsESP(state, ie)
    end
})

local envis = esp:AddSection("Entity")

envis:AddDropdown({
    Title = "Esp Entity",
    Content = "",
    Multi = true,
    Options = me,
    Default = {},
    Callback = function(options)
        ESPModule.selectedMobs = options
        ESPModule.UpdateMobsESP(me)
    end
})

envis:AddToggle({
    Title = "Enable Esp Entity",
    Content = "",
    Default = false,
    Callback = function(state)
        ESPModule.ToggleMobsESP(state, me)
    end
})

local smp = Tp:AddSection("Map")

smp:AddButton({
    Title = "Reveal Whole Map",
    Content = "",
    Callback = function()
        TeleportModule.RevealWholeMap()
    end
})

smp:AddToggle({
    Title = "Scan Map",
    Content = "Might not work for some executors.",
    Default = false,
    Callback = function(state)
        TeleportModule.ToggleScanMap(state)
    end
})

local tpt = Tp:AddSection("Teleport to")

tpt:AddButton({
    Title = "Teleport to Campfire",
    Content = "",
    Callback = function()
        TeleportModule.TeleportToCampfire()
    end
})

tpt:AddButton({
    Title = "Teleport to Stronghold",
    Content = "",
    Callback = function()
        TeleportModule.TeleportToStronghold()
    end
})

tpt:AddButton({
    Title = "Teleport to Safe Zone",
    Content = "",
    Callback = function()
        TeleportModule.TeleportToSafeZone()
    end
})

tpt:AddButton({
    Title = "Teleport to Trader",
    Content = "",
    Callback = function()
        TeleportModule.TeleportToTrader()
    end
})

tpt:AddButton({
    Title = "Teleport to Random Tree",
    Content = "",
    Callback = function()
        TeleportModule.TeleportToRandomTree()
    end
})

local tpc = Tp:AddSection("Children")

local MobDropdown = tpc:AddDropdown({
    Title = "Select Child",
    Content = "",
    Multi = false,
    Options = currentMobNames,
    Default = {},
    Callback = function(options)
        selectedMob = options[#options] or currentMobNames[1] or nil
    end
})

tpc:AddButton({
    Title = "Refresh List",
    Content = "",
    Callback = function()
        currentMobs, currentMobNames = TeleportModule.getMobs()
        if #currentMobNames > 0 then
            selectedMob = currentMobNames[1]
            MobDropdown:Refresh(currentMobNames)
        else
            selectedMob = nil
            MobDropdown:Refresh({ "No child found" })
        end
    end
})

tpc:AddButton({
    Title = "Teleport to Child",
    Content = "",
    Callback = function()
        if selectedMob and currentMobs then
            for i, name in ipairs(currentMobNames) do
                if name == selectedMob then
                    TeleportModule.TeleportToMob(currentMobs[i])
                    break
                end
            end
        end
    end
})

local tpch = Tp:AddSection("Chest")

local ChestDropdown = tpch:AddDropdown({
    Title = "Select Chest",
    Content = "",
    Multi = false,
    Options = currentChestNames,
    Default = {},
    Callback = function(options)
        selectedChest = options[#options] or currentChestNames[1] or nil
    end
})

tpch:AddButton({
    Title = "Refresh List",
    Content = "",
    Callback = function()
        currentChests, currentChestNames = TeleportModule.getChests()
        if #currentChestNames > 0 then
            selectedChest = currentChestNames[1]
            ChestDropdown:Refresh(currentChestNames)
        else
            selectedChest = nil
            ChestDropdown:Refresh({ "No chests found" })
        end
    end
})

tpch:AddButton({
    Title = "Teleport to Chest",
    Content = "",
    Callback = function()
        if selectedChest and currentChests then
            local chestIndex = 1
            for i, name in ipairs(currentChestNames) do
                if name == selectedChest then
                    chestIndex = i
                    break
                end
            end
            TeleportModule.TeleportToChest(currentChests[chestIndex])
        end
    end
})

local chs = Misc:AddSection("Chest")

chs:AddToggle({
    Title = "Auto Open Chests",
    Content = "",
    Default = false,
    Callback = function(v)
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
        if not _G.AutoChestData then
            _G.AutoChestData = {running = false, originalCFrame = nil}
        end

        local function getChests()
            local chests = {}
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("Model") and string.find(obj.Name, "Item Chest") then
                    table.insert(chests, obj)
                end
            end
            return chests
        end

        local function getPrompt(model)
            local prompts = {}
            for _, obj in ipairs(model:GetDescendants()) do
                if obj:IsA("ProximityPrompt") then
                    table.insert(prompts, obj)
                end
            end
            return prompts
        end

        if v then
            if _G.AutoChestData.running then return end
            _G.AutoChestData.running = true
            _G.AutoChestData.originalCFrame = humanoidRootPart.CFrame
            task.spawn(function()
                while _G.AutoChestData.running do
                    local chests = getChests()
                    for _, chest in ipairs(chests) do
                        if not _G.AutoChestData.running then break end
                        local part = chest.PrimaryPart or chest:FindFirstChildWhichIsA("BasePart")
                        if part then
                            humanoidRootPart.CFrame = part.CFrame + Vector3.new(0, 6, 0)
                            local prompts = getPrompt(chest)
                            for _, prompt in ipairs(prompts) do
                                fireproximityprompt(prompt, math.huge)
                            end
                            local t = tick()
                            while _G.AutoChestData.running and tick() - t < 4 do task.wait() end
                        end
                    end
                    task.wait(0.1)
                end
            end)
        else
            _G.AutoChestData.running = false
            if _G.AutoChestData.originalCFrame then
                humanoidRootPart.CFrame = _G.AutoChestData.originalCFrame
            end
        end
    end
})

local afed = Misc:AddSection("Auto Eat")

afed:AddDropdown({
    Title = "Select Food",
    Content = "Select food to eat.",
    Multi = false,
    Options = alimentos,
    Default = selectedFood,
    Callback = function(value)
        selectedFood = value
    end
})

afed:AddInput({
    Title = "Eat Amount",
    Content = "Eat when hunger reaches this %",
    Placeholder = "ex: 20 (numbers)",
    Callback = function(value)
    local n = tonumber(value)
        if n then
            hungerThreshold = math.clamp(n, 0, 100)
        end
    end
})

afed:AddToggle({
    Title = "Enable Auto Eat",
    Content = "",
    Default = false,
    Callback = function(state)
        autoFeedToggle = state
        if state then
            task.spawn(function()
                while autoFeedToggle do
                    task.wait(0.05)

                    local currentHunger = ghn()
                    if currentHunger <= hungerThreshold and #selectedFood > 0 then
                        while currentHunger < 100 and autoFeedToggle do
                            local ateSomething = false

                            for _, foodName in ipairs(selectedFood) do
                                for _, item in ipairs(Workspace.Items:GetChildren()) do
                                    if item.Name == foodName and item.Parent then
                                        pcall(function()
                                            ReplicatedStorage.RemoteEvents.RequestConsumeItem:InvokeServer(item)
                                        end)
                                        ateSomething = true
                                        task.wait(0.05)
                                        currentHunger = ghn()
                                        if currentHunger >= 100 then
                                            break
                                        end
                                    end
                                end
                                if currentHunger >= 100 then
                                    break
                                end
                            end

                            if not ateSomething then
                                break
                            end
                        end
                    end
                end
            end)
        end
    end
})

local hh = Fly:AddSection("LocalPlayer")

hh:AddSlider({
    Title = "Hip Height",
    Content = "",
    Min = 1,
    Max = 50,
    Default = 2,
    Callback = function(v)
        _G.HipHeight = v
        if _G.HipHeightOn then
            game.Players.LocalPlayer.Character.Humanoid.HipHeight = v
        end
    end
})

hh:AddSlider({
    Title = "Fly Speed",
    Content = "",
    Min = 1,
    Max = 20,
    Default = 1,
    Callback = function(value)
        FlyModule.flySpeed = value
        if FlyModule.FLYING then
            task.spawn(function()
                while FlyModule.FLYING do
                    task.wait(0.1)
                    if game:GetService("UserInputService").TouchEnabled then
                        local root = Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        if root and root:FindFirstChild("BodyVelocity") then
                            local bv = root:FindFirstChild("BodyVelocity")
                            bv.Velocity = bv.Velocity.Unit * (FlyModule.flySpeed * 50)
                        end
                    end
                end
            end)
        end
    end
})

local humanoid = Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
hh:AddSlider({
    Title = "Walkspeed",
    Content = "",
    Min = 16,
    Max = 150,
    Default = 16,
    Callback = function(val)
        humanoid.WalkSpeed = val
	end
})

hh:AddToggle({
    Title = "Enable HipHeight",
    Content = "",
    Default = false,
    Callback = function(PH)
        _G.HipHeightOn = PH
        if PH then
            game.Players.LocalPlayer.Character.Humanoid.HipHeight = _G.HipHeight or 2
        end
    end
})

hh:AddToggle({
    Title = "Enable Fly",
    Content = "",
    Default = false,
    Callback = function(state)
        FlyModule.flyToggle = state
        if FlyModule.flyToggle then
            if game:GetService("UserInputService").TouchEnabled then
                FlyModule.MobileFly()
            else
                FlyModule.sFLY()
            end
        else
            FlyModule.NOFLY()
            FlyModule.UnMobileFly()
        end
    end
})

local noclipConnection
hh:AddToggle({
    Title = "No Clip",
    Content = "",
    Default = false,
    Callback = function(state)
        if state then
            noclipConnection = RunService.Stepped:Connect(function()
                local char = Players.LocalPlayer.Character
                if char then
                    for _, part in ipairs(char:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        else
            if noclipConnection then
                noclipConnection:Disconnect()
                noclipConnection = nil
            end
        end
    end
})

local infJumpConnection
hh:AddToggle({
    Title = "Inf Jump",
    Content = "Inf jump :)",
    Default = false,
    Callback = function(state)
        if state then
            infJumpConnection = UserInputService.JumpRequest:Connect(function()
                local char = Players.LocalPlayer.Character
                local humanoid = char and char:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
        else
            if infJumpConnection then
                infJumpConnection:Disconnect()
                infJumpConnection = nil
            end
        end
    end
})

local mxc = Misc:AddSection("Misc")

local instantInteractEnabled = false
local instantInteractConnection
local originalHoldDurations = {}

mxc:AddToggle({
    Title = "Instant Interact",
    Content = "Instantly open chests, gates, etc.",
    Default = false,
    Callback = function(state)
        instantInteractEnabled = state

        if state then
            originalHoldDurations = {}
            instantInteractConnection = task.spawn(function()
                while instantInteractEnabled do
                    for _, obj in ipairs(workspace:GetDescendants()) do
                        if obj:IsA("ProximityPrompt") then
                            if originalHoldDurations[obj] == nil then
                                originalHoldDurations[obj] = obj.HoldDuration
                            end
                            obj.HoldDuration = 0
                        end
                    end
                    task.wait(5)
                end
            end)
        else
            if instantInteractConnection then
                instantInteractEnabled = false
            end
            for obj, value in pairs(originalHoldDurations) do
                if obj and obj:IsA("ProximityPrompt") then
                    obj.HoldDuration = value
                end
            end
            originalHoldDurations = {}
        end
    end
})

mxc:AddToggle({
    Title = "Auto Collect Coin Stacks",
    Content = "Automatically collects all Coin Stacks",
    Default = false,
    Callback = function(value)
        if value then
            _G.AutoCollectCoins = true
            coroutine.wrap(function()
                while _G.AutoCollectCoins do
                    for _, item in pairs(workspace.Items:GetChildren()) do
                        if item.Name == "Coin Stack" and item:FindFirstChild("HumanoidRootPart") then
                            local args = {item}
                            game:GetService("ReplicatedStorage").RemoteEvents.RequestCollectCoints:InvokeServer(unpack(args))
                            warn("Collected a Coin Stack")
                        end
                    end
                    task.wait(0.2)
                end
            end)()
        else
            _G.AutoCollectCoins = false
        end
    end
})

--[[ mxc:AddToggle({
    Title = "Auto Build Anvil",
    Content = "Puts anvil front, back, and base together",
    Default = false,
    Callback = function(state)
        autoBuildAnvil = state
        task.spawn(function()
            while autoBuildAnvil do
                for _, partName in ipairs({"Anvil Base", "Anvil Front", "Anvil Back"}) do
                    if workspace:WaitForChild("Items"):FindFirstChild(partName) then
                        game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("RequestBuildAnvilPiece"):InvokeServer(
                            workspace:WaitForChild("Map"):WaitForChild("Landmarks"):WaitForChild("ToolWorkshop_MeteorShower"),
                            workspace:WaitForChild("Items")[partName]
                        )
                    end
                end
            end
        end)
    end
}) ]]

local ant = Misc:AddSection("Anti's")

ant:AddToggle({
    Title = "Auto Stun Deer",
    Content = "Need Flashlight",
    Default = false,
    Callback = function(state)
        AntiModule.ToggleAutoStunDeer(state)
    end
})

ant:AddToggle({
    Title = "Auto Escape From Owl",
    Content = "",
    Default = false,
    Callback = function(state)
        AntiModule.ToggleAutoEscapeOwl(state)
    end
})

ant:AddToggle({
    Title = "Auto Escape From Deer",
    Content = "",
    Default = false,
    Callback = function(state)
        AntiModule.ToggleAutoEscapeDeer(state)
    end
})

ant:AddToggle({
    Title = "Auto Escape From Ram",
    Content = "",
    Default = false,
    Callback = function(state)
        AntiModule.ToggleAutoEscapeRam(state)
    end
})

local fun = Fun:AddSection("Fun")

fun:AddToggle({
    Title = "Auto Delete Owl",
    Content = "",
    Default = false,
    Callback = function(state) 
        FunModule.ToggleAutoDelete("Owl", state)
    end
})

fun:AddToggle({
    Title = "Auto Delete Deer",
    Content = "",
    Default = false,
    Callback = function(state) 
        FunModule.ToggleAutoDelete("Deer", state)
    end
})

fun:AddToggle({
    Title = "Auto Delete Ram",
    Content = "",
    Default = false,
    Callback = function(state) 
        FunModule.ToggleAutoDelete("Ram", state)
    end
})

fun:AddSlider({
    Title = "Game Gravity",
    Content = "",
    Min = 0,
    Max = 500,
    Default = 196,
    Callback = function(value)
        FunModule.SetGravity(value)
    end
})

fun:AddToggle({
    Title = "No Health Bar",
    Content = "Invisible health bar",
    Default = false,
    Callback = function(state)
        FunModule.ToggleNoHealthBar(state, notify)
    end
})

fun:AddToggle({
    Title = "God Mode",
    Content = "Immune to physical and hunger damage",
    Default = false,
    Callback = function(value)
        FunModule.ToggleGodMode(value, notify)
    end
})

fun:AddButton({
    Title = "Auto Days Farm",
    Content = "Just afk and let the script do everything.",
    Callback = function()
        FunModule.LoadAutoDaysFarm()
    end
})

local env = Vision:AddSection("Environment")

env:AddToggle({
    Title = "Disable Fog",
    Content = "",
    Default = false,
    Callback = function(state)
        VisionModule.ToggleDisableFog(state)
    end
})

env:AddToggle({
    Title = "Disable Night Campfire Effect",
    Content = "",
    Default = false,
    Callback = function(state)
        VisionModule.ToggleDisableNightCampfire(state)
    end
})

env:AddToggle({
    Title = "Full Bright",
    Content = "",
    Default = false,
    Callback = function(state)
        VisionModule.ToggleFullBright(state)
    end
})

env:AddToggle({
    Title = "No Fog",
    Content = "",
    Default = false,
    Callback = function(state)
        VisionModule.ToggleNoFog(state)
    end
})

env:AddToggle({
    Title = "Vibrant Colors",
    Content = "",
    Default = false,
    Callback = function(state)
        VisionModule.ToggleVibrantColors(state)
    end
})

env:AddButton({
    Title = "Remove Gameplay Paused",
    Content = "",
    Callback = function()
        VisionModule.RemoveGameplayPaused()
    end
})

UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if gameProcessedEvent then return end

    if input.KeyCode == Enum.KeyCode.V then
        showPlayers = not showPlayers
        playersText.Visible = showPlayers
    end
end)
