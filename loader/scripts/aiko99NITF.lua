repeat task.wait() until game:IsLoaded()

local settings = {
    playerGui = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui"),
    interface = nil,
    fishingCatchFrame = nil,
    timingBar = nil,
    successArea = nil
}

settings.interface = settings.playerGui and settings.playerGui:FindFirstChild("Interface")
settings.fishingCatchFrame = settings.interface and settings.interface:FindFirstChild("FishingCatchFrame")
settings.timingBar = settings.fishingCatchFrame and settings.fishingCatchFrame:FindFirstChild("TimingBar")
settings.successArea = settings.timingBar and settings.timingBar:FindFirstChild("SuccessArea")

if settings.successArea then
    settings.successArea:GetPropertyChangedSignal("Size"):Connect(function()
        settings.successArea.Position = UDim2.new(0.5, 0, 0, 0)
        settings.successArea.Size = UDim2.new(1, 0, 1, 0)
        end)
end

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local rs = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Lighting = game:GetService("Lighting")
local effect = Lighting:FindFirstChild("VibrantEffect")
local vibrantEffect = Lighting:FindFirstChild("VibrantEffect")
local RunService = game:GetService("RunService")

Lighting.ClockTime = 14
Lighting.GlobalShadows = false

local VirtualUser = game:GetService("VirtualUser")

local scan_map = false

local killAuraToggle = false
local chopAuraToggle = false
local auraRadius = 50
local currentammount = 0

local toolsDamageIDs = {
    ["Old Axe"] = "3_7367831688",
    ["Good Axe"] = "112_7367831688",
    ["Strong Axe"] = "116_7367831688",
    ["Ice Axe"] = "116_7367831688",
    ["Admin Axe"] = "116_7367831688",
    ["Morningstar"] = "116_7367831688",
    ["Laser Sword"] = "116_7367831688",
    ["Ice Sword"] = "116_7367831688",
    ["Infernal Sword"] = "6_7461591369",
    ["Katana"] = "116_7367831688",
    ["Trident"] = "116_7367831688",
    ["Poison Spear"] = "116_7367831688",
    ["Chainsaw"] = "647_8992824875",
    ["Spear"] = "196_8999010016",
    ["Rifle"] = "22_6180169035"
}

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

local autoCraftEnabled = false
local autoUpgradeBenchEnabled = false
local autoBuildAnvil = false


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

local function getAnyToolWithDamageID(isChopAura)
    for toolName, damageID in pairs(toolsDamageIDs) do
        if isChopAura and toolName ~= "Old Axe" and toolName ~= "Good Axe" and toolName ~= "Strong Axe" and toolName ~= "Ice Axe" and toolName ~= "Chainsaw" then
            continue
        end
        local tool = LocalPlayer:FindFirstChild("Inventory") and LocalPlayer.Inventory:FindFirstChild(toolName)
        if tool then
            return tool, damageID
        end
    end
    return nil, nil
end

local function equipTool(tool)
    if tool then
        ReplicatedStorage:WaitForChild("RemoteEvents").EquipItemHandle:FireServer("FireAllClients", tool)
    end
end

local function unequipTool(tool)
    if tool then
        ReplicatedStorage:WaitForChild("RemoteEvents").UnequipItemHandle:FireServer("FireAllClients", tool)
    end
end

local function killAuraLoop()
    while killAuraToggle do
        local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local tool, damageID = getAnyToolWithDamageID(false)
            if tool and damageID then
                equipTool(tool)
                for _, mob in ipairs(Workspace.Characters:GetChildren()) do
                    if mob:IsA("Model") then
                        local part = mob:FindFirstChildWhichIsA("BasePart")
                        if part and (part.Position - hrp.Position).Magnitude <= auraRadius then
                            pcall(function()
                                ReplicatedStorage:WaitForChild("RemoteEvents").ToolDamageObject:InvokeServer(
                                    mob,
                                    tool,
                                    damageID,
                                    CFrame.new(part.Position)
                                )
                            end)
                        end
                    end
                end
                task.wait(0.01)
            else
                task.wait(0.1)
            end
        else
            task.wait(0.5)
        end
    end
end

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

        local function chopAuraLoop()
            while chopAuraToggle do
                local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                local hrp = character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local tool, baseDamageID = getAnyToolWithDamageID(true)
                    if tool and baseDamageID then
                        equipTool(tool)
                        currentammount = currentammount + 1
                        local trees = {}
                        local map = Workspace:FindFirstChild("Map")
                        if map then
                            if map:FindFirstChild("Foliage") then
                                for _, obj in ipairs(map.Foliage:GetChildren()) do
                                    if obj:IsA("Model") and (obj.Name == "Small Tree" or obj.Name == "Snowy Small Tree") then
                                        table.insert(trees, obj)
                                    end
                                end
                            end
                            if map:FindFirstChild("Landmarks") then
                                for _, obj in ipairs(map.Landmarks:GetChildren()) do
                                    if obj:IsA("Model") and obj.Name == "Small Tree" then
                                        table.insert(trees, obj)
                                    end
                                end
                            end
                        end
                        for _, tree in ipairs(trees) do
                            local trunk = tree:FindFirstChild("Trunk")
                            if trunk and trunk:IsA("BasePart") and (trunk.Position - hrp.Position).Magnitude <= auraRadius then
                                local alreadyammount = false
                                task.spawn(function()
                                    while chopAuraToggle and tree and tree.Parent and not alreadyammount do
                                        alreadyammount = true
                                        currentammount = currentammount + 1
                                        pcall(function()
                                            ReplicatedStorage:WaitForChild("RemoteEvents").ToolDamageObject:InvokeServer(
                                                tree,
                                                tool,
                                                tostring(currentammount) .. "_7367831688",
                                                CFrame.new(-2.962610244751, 4.5547881126404, -75.950843811035, 0.89621275663376, -1.3894891459643e-08, 0.44362446665764, -7.994568895775e-10, 1, 3.293635941759e-08, -0.44362446665764, -2.9872644802253e-08, 0.89621275663376)
                                            )
                                        end)
                                    end
                                end)
                            end
                        end
                        task.wait(0.1)
                    else
                        task.wait(1)
                    end
                else
                    task.wait(0.5)
                end
            end
        end

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
            WindUI:Notify({
                Title = "Auto Food Paused",
                Content = "The food is gone",
                Duration = 3
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

        local function getChests()
            local chests = {}
            local chestNames = {}
            local seenPositions = {}
            local index = 1

            for _, item in ipairs(workspace:WaitForChild("Items"):GetChildren()) do
                if item.Name:match("^Item Chest") and not item:GetAttribute("8721081708ed") then
                    local part = item.PrimaryPart or item:FindFirstChildWhichIsA("BasePart")
                    if part then
                        local pos = tostring(part.Position)
                        if not seenPositions[pos] then
                            seenPositions[pos] = true
                            table.insert(chests, item)
                            table.insert(chestNames, "Chest " .. index)
                            index = index + 1
                        end
                    end
                end
            end

            return chests, chestNames
        end

        local currentChests, currentChestNames = getChests()
        local selectedChest = currentChestNames[1] or nil

        local function getMobs()
            local mobs = {}
            local mobNames = {}
            local index = 1
            for _, character in ipairs(workspace:WaitForChild("Characters"):GetChildren()) do
                if character.Name:match("^Lost Child") and character:GetAttribute("Lost") == true then
                    table.insert(mobs, character)
                    table.insert(mobNames, character.Name)
                    index = index + 1
                end
            end
            return mobs, mobNames
        end

        local currentMobs, currentMobNames = getMobs()
        local selectedMob = currentMobNames[1] or nil

        function tp1()
            (game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()):WaitForChild("HumanoidRootPart").CFrame =
        CFrame.new(0.43132782, 15.77634621, -1.88620758, -0.270917892, 0.102997094, 0.957076371, 0.639657021, 0.762253821, 0.0990355015, -0.719334781, 0.639031112, -0.272391081)
        end

        local function tp2()
            local targetPart = workspace:FindFirstChild("Map")
                and workspace.Map:FindFirstChild("Landmarks")
                and workspace.Map.Landmarks:FindFirstChild("Stronghold")
                and workspace.Map.Landmarks.Stronghold:FindFirstChild("Functional")
                and workspace.Map.Landmarks.Stronghold.Functional:FindFirstChild("EntryDoors")
                and workspace.Map.Landmarks.Stronghold.Functional.EntryDoors:FindFirstChild("DoorRight")
                and workspace.Map.Landmarks.Stronghold.Functional.EntryDoors.DoorRight:FindFirstChild("Model")
            if targetPart then
                local children = targetPart:GetChildren()
                local destination = children[5]
                if destination and destination:IsA("BasePart") then
                    local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        hrp.CFrame = destination.CFrame + Vector3.new(0, 5, 0)
                    end
                end
            end
        end

        local flyToggle = false
        local flySpeed = 1
        local FLYING = false
        local flyKeyDown, flyKeyUp, mfly1, mfly2
        local IYMouse = game:GetService("UserInputService")

        local function sFLY()
            repeat task.wait() until Players.LocalPlayer and Players.LocalPlayer.Character and Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart") and Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            repeat task.wait() until IYMouse
            if flyKeyDown or flyKeyUp then flyKeyDown:Disconnect(); flyKeyUp:Disconnect() end

            local T = Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
            local CONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
            local lCONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
            local SPEED = flySpeed

            local function FLY()
                FLYING = true
                local BG = Instance.new('BodyGyro')
                local BV = Instance.new('BodyVelocity')
                BG.P = 9e4
                BG.Parent = T
                BV.Parent = T
                BG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
                BG.CFrame = T.CFrame
                BV.Velocity = Vector3.new(0, 0, 0)
                BV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
                task.spawn(function()
                    while FLYING do
                        task.wait()
                        if not flyToggle and Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid') then
                            Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').PlatformStand = true
                        end
                        if CONTROL.L + CONTROL.R ~= 0 or CONTROL.F + CONTROL.B ~= 0 or CONTROL.Q + CONTROL.E ~= 0 then
                            SPEED = flySpeed
                        elseif not (CONTROL.L + CONTROL.R ~= 0 or CONTROL.F + CONTROL.B ~= 0 or CONTROL.Q + CONTROL.E ~= 0) and SPEED ~= 0 then
                            SPEED = 0
                        end
                        if (CONTROL.L + CONTROL.R) ~= 0 or (CONTROL.F + CONTROL.B) ~= 0 or (CONTROL.Q + CONTROL.E) ~= 0 then
                            BV.Velocity = ((workspace.CurrentCamera.CoordinateFrame.lookVector * (CONTROL.F + CONTROL.B)) + ((workspace.CurrentCamera.CoordinateFrame * CFrame.new(CONTROL.L + CONTROL.R, (CONTROL.F + CONTROL.B + CONTROL.Q + CONTROL.E) * 0.2, 0).p) - workspace.CurrentCamera.CoordinateFrame.p)) * SPEED
                            lCONTROL = {F = CONTROL.F, B = CONTROL.B, L = CONTROL.L, R = CONTROL.R}
                        elseif (CONTROL.L + CONTROL.R) == 0 and (CONTROL.F + CONTROL.B) == 0 and (CONTROL.Q + CONTROL.E) == 0 and SPEED ~= 0 then
                            BV.Velocity = ((workspace.CurrentCamera.CoordinateFrame.lookVector * (lCONTROL.F + lCONTROL.B)) + ((workspace.CurrentCamera.CoordinateFrame * CFrame.new(lCONTROL.L + lCONTROL.R, (lCONTROL.F + lCONTROL.B + CONTROL.Q + CONTROL.E) * 0.2, 0).p) - workspace.CurrentCamera.CoordinateFrame.p)) * SPEED
                        else
                            BV.Velocity = Vector3.new(0, 0, 0)
                        end
                        BG.CFrame = workspace.CurrentCamera.CoordinateFrame
                    end
                    CONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
                    lCONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
                    SPEED = 0
                    BG:Destroy()
                    BV:Destroy()
                    if Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid') then
                        Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').PlatformStand = false
                    end
                end)
            end
            flyKeyDown = IYMouse.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Keyboard then
                    local KEY = input.KeyCode.Name
                    if KEY == "W" then
                        CONTROL.F = flySpeed
                    elseif KEY == "S" then
                        CONTROL.B = -flySpeed
                    elseif KEY == "A" then
                        CONTROL.L = -flySpeed
                    elseif KEY == "D" then 
                        CONTROL.R = flySpeed
                    elseif KEY == "E" then
                        CONTROL.Q = flySpeed * 2
                    elseif KEY == "Q" then
                        CONTROL.E = -flySpeed * 2
                    end
                    pcall(function() workspace.CurrentCamera.CameraType = Enum.CameraType.Track end)
                end
            end)
            flyKeyUp = IYMouse.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Keyboard then
                    local KEY = input.KeyCode.Name
                    if KEY == "W" then
                        CONTROL.F = 0
                    elseif KEY == "S" then
                        CONTROL.B = 0
                    elseif KEY == "A" then
                        CONTROL.L = 0
                    elseif KEY == "D" then
                        CONTROL.R = 0
                    elseif KEY == "E" then
                        CONTROL.Q = 0
                    elseif KEY == "Q" then
                        CONTROL.E = 0
                    end
                end
            end)
            FLY()
        end

        local function NOFLY()
            FLYING = false
            if flyKeyDown then flyKeyDown:Disconnect() end
            if flyKeyUp then flyKeyUp:Disconnect() end
            if mfly1 then mfly1:Disconnect() end
            if mfly2 then mfly2:Disconnect() end
            if Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid') then
                Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').PlatformStand = false
            end
            pcall(function() workspace.CurrentCamera.CameraType = Enum.CameraType.Custom end)
        end

        local function UnMobileFly()
            pcall(function()
                FLYING = false
                local root = Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
                if root:FindFirstChild("BodyVelocity") then root:FindFirstChild("BodyVelocity"):Destroy() end
                if root:FindFirstChild("BodyGyro") then root:FindFirstChild("BodyGyro"):Destroy() end
                if Players.LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid") then
                    Players.LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid").PlatformStand = false
                end
                if mfly1 then mfly1:Disconnect() end
                if mfly2 then mfly2:Disconnect() end
            end)
        end

        local function MobileFly()
            UnMobileFly()
            FLYING = true

            local root = Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
            local camera = workspace.CurrentCamera
            local v3none = Vector3.new()
            local v3zero = Vector3.new(0, 0, 0)
            local v3inf = Vector3.new(9e9, 9e9, 9e9)

            local controlModule = require(Players.LocalPlayer.PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("ControlModule"))
            local bv = Instance.new("BodyVelocity")
            bv.Name = "BodyVelocity"
            bv.Parent = root
            bv.MaxForce = v3zero
            bv.Velocity = v3zero

            local bg = Instance.new("BodyGyro")
            bg.Name = "BodyGyro"
            bg.Parent = root
            bg.MaxTorque = v3inf
            bg.P = 1000
            bg.D = 50

            mfly1 = Players.LocalPlayer.CharacterAdded:Connect(function()
                local newRoot = Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
                local newBv = Instance.new("BodyVelocity")
                newBv.Name = "BodyVelocity"
                newBv.Parent = newRoot
                newBv.MaxForce = v3zero
                newBv.Velocity = v3zero

                local newBg = Instance.new("BodyGyro")
                newBg.Name = "BodyGyro"
                newBg.Parent = newRoot
                newBg.MaxTorque = v3inf
                newBg.P = 1000
                newBg.D = 50
            end)

            mfly2 = game:GetService("RunService").RenderStepped:Connect(function()
                root = Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
                camera = workspace.CurrentCamera
                if Players.LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid") and root and root:FindFirstChild("BodyVelocity") and root:FindFirstChild("BodyGyro") then
                    local humanoid = Players.LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")
                    local VelocityHandler = root:FindFirstChild("BodyVelocity")
                    local GyroHandler = root:FindFirstChild("BodyGyro")

                    VelocityHandler.MaxForce = v3inf
                    GyroHandler.MaxTorque = v3inf
                    humanoid.PlatformStand = true
                    GyroHandler.CFrame = camera.CoordinateFrame
                    VelocityHandler.Velocity = v3none

                    local direction = controlModule:GetMoveVector()
                    if direction.X > 0 then
                        VelocityHandler.Velocity = VelocityHandler.Velocity + camera.CFrame.RightVector * (direction.X * (flySpeed * 50))
                    end
                    if direction.X < 0 then
                        VelocityHandler.Velocity = VelocityHandler.Velocity + camera.CFrame.RightVector * (direction.X * (flySpeed * 50))
                    end
                    if direction.Z > 0 then
                        VelocityHandler.Velocity = VelocityHandler.Velocity - camera.CFrame.LookVector * (direction.Z * (flySpeed * 50))
                    end
                    if direction.Z < 0 then
                        VelocityHandler.Velocity = VelocityHandler.Velocity - camera.CFrame.LookVector * (direction.Z * (flySpeed * 50))
                    end
                end
            end)
        end

        local workspace = game:GetService("Workspace")
        local LocalPlayer = Players.LocalPlayer

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
            label.Font = Enum.Font.Code
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

        local Stats = game:GetService("Stats")
        local Players = game:GetService("Players")
        local UserInputService = game:GetService("UserInputService")
        local Camera = workspace.CurrentCamera

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
                    fpsText.Text = string.format("FPS: %d", fpsValue)
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
                    local color, label = Color3.fromRGB(0, 255, 0), "Wifi Ping: "

                    if ping > 120 then
                        color, label = Color3.fromRGB(255, 0, 0), "Wifi Ping: "
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

        _G.AutoPlantCenter = Vector3.new(-0, 1.5, -0)
        _G.AutoSapRadius = 50
        _G.Sapling = 150
        _G.AutoPlantEnabled = false

        function StartAutoPlant()
            _G.AutoPlantEnabled = true
            spawn(function() 
                while _G.AutoPlantEnabled do
                    local selectedSapling = nil
                    for _, item in pairs(workspace.Items:GetDescendants()) do
                        if item:IsA("BasePart") or item:IsA("Model") then
                            if string.find(string.lower(item.Name), "sapling") or 
                               string.find(string.lower(item.Name), "seed") or
                               string.find(string.lower(item.Name), "plant") then
                                selectedSapling = item
                                break
                            end
                        end
                    end

                    if not selectedSapling then
                        for _, item in pairs(workspace.Items:GetDescendants()) do
                            if item:IsA("BasePart") or item:IsA("Model") then
                                selectedSapling = item
                                break
                            end
                        end
                    end

                    if selectedSapling then
                        for i = 1, _G.Sapling do
                            if not _G.AutoPlantEnabled then break end

                            local angle = ((i - 1) / _G.Sapling) * 2 * math.pi
                            local circlePosition = _G.AutoPlantCenter + Vector3.new(
                                math.cos(angle) * _G.AutoSapRadius,
                                0,
                                math.sin(angle) * _G.AutoSapRadius
                            )

                            pcall(function()
                                if selectedSapling:IsA("BasePart") then
                                    selectedSapling.CanCollide = false
                                    selectedSapling.CFrame = CFrame.new(circlePosition)
                                    selectedSapling.Anchored = true
                                elseif selectedSapling:IsA("Model") then
                                    for _, part in pairs(selectedSapling:GetDescendants()) do
                                        if part:IsA("BasePart") then
                                            part.CanCollide = false
                                            part.Anchored = true
                                        end
                                    end

                                    if selectedSapling.PrimaryPart then
                                        selectedSapling:SetPrimaryPartCFrame(CFrame.new(circlePosition))
                                    else
                                        local part = selectedSapling:FindFirstChildWhichIsA("BasePart")
                                        if part then
                                            part.CFrame = CFrame.new(circlePosition)
                                        end
                                    end
                                end
                            end)

                            local args = {
                                selectedSapling,
                                vector.create(circlePosition.X, circlePosition.Y, circlePosition.Z)
                            }

                            pcall(function()
                                game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("RequestPlantItem"):InvokeServer(unpack(args))
                            end)

                            wait(0.15)
                        end

                        wait(2)
                    end
                end
            end) 
        end

        function StopAutoPlant()
            _G.AutoPlantEnabled = false
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

        function createESPText(part, text, color)
            if part:FindFirstChild("ESPTexto") then return end

            local esp = Instance.new("BillboardGui")
            esp.Name = "ESPTexto"
            esp.Adornee = part
            esp.Size = UDim2.new(0, 100, 0, 20)
            esp.StudsOffset = Vector3.new(0, 2.5, 0)
            esp.AlwaysOnTop = true
            esp.MaxDistance = 300

            local label = Instance.new("TextLabel")
            label.Parent = esp
            label.Size = UDim2.new(1, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.Text = text
            label.TextColor3 = color or Color3.fromRGB(255,255,0)
            label.TextStrokeTransparency = 0.2
            label.TextScaled = true
            label.Font = Enum.Font.Code

            esp.Parent = part
        end

        local function Aesp(nome, tipo)
            local container
            local color
            if tipo == "item" then
                container = workspace:FindFirstChild("Items")
                color = Color3.fromRGB(0, 255, 0)
            elseif tipo == "mob" then
                container = workspace:FindFirstChild("Characters")
                color = Color3.fromRGB(255, 255, 0)
            else
                return
            end
            if not container then return end

            for _, obj in ipairs(container:GetChildren()) do
                if obj.Name == nome then
                    local part = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart")
                    if part then
                        createESPText(part, obj.Name, color)
                    end
                end
            end
        end

        local function Desp(nome, tipo)
            local container
            if tipo == "item" then
                container = workspace:FindFirstChild("Items")
            elseif tipo == "mob" then
                container = workspace:FindFirstChild("Characters")
            else
                return
            end
            if not container then return end

            for _, obj in ipairs(container:GetChildren()) do
                if obj.Name == nome then
                    local part = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart")
                    if part then
                        for _, gui in ipairs(part:GetChildren()) do
                            if gui:IsA("BillboardGui") and gui.Name == "ESPTexto" then
                                gui:Destroy()
                            end
                        end
                    end
                end
            end
        end

        local selectedItems = {}
        local selectedMobs = {}
        local espItemsEnabled = false
        local espMobsEnabled = false
        local espConnections = {}

        local Tree = workspace.Map.Landmarks
        local EspTextSize = 16

        local function createTreeESP(tree)
            local oldGui = tree:FindFirstChild("TreeHealth")
            if oldGui then oldGui:Destroy() end

            local billboardGui = Instance.new("BillboardGui")
            billboardGui.Name = "TreeHealth"
            billboardGui.Size = UDim2.new(4, 0, 2, 0) 
            billboardGui.StudsOffset = Vector3.new(0, 3, 0) 
            billboardGui.AlwaysOnTop = true
            billboardGui.Parent = tree

            local textLabel = Instance.new("TextLabel")
            textLabel.Size = UDim2.new(1, 0, 1, 0)  
            textLabel.BackgroundTransparency = 1
            textLabel.Font = Enum.Font.Code
            textLabel.TextSize = EspTextSize
            textLabel.TextColor3 = Color3.fromRGB(0, 255, 0)  
            textLabel.TextStrokeTransparency = 0.5  
            textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)  
            textLabel.Parent = billboardGui

            local function updateHealth(health)
                if not health then
                    textLabel.Text = "??"
                    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                    return
                end
                textLabel.Text = tostring(math.floor(health))
                if health < 30 then
                    textLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
                elseif health < 60 then
                    textLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
                else
                    textLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
                end
            end

            if tree:IsA("BasePart") then
                updateHealth(tree:GetAttribute("Health"))
                tree:GetAttributeChangedSignal("Health"):Connect(function()
                    updateHealth(tree:GetAttribute("Health"))
                end)
            elseif tree:IsA("Model") then
                local humanoid = tree:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    updateHealth(humanoid.Health)
                    humanoid.HealthChanged:Connect(updateHealth)
                else
                    updateHealth(tree:GetAttribute("Health"))
                    tree:GetAttributeChangedSignal("Health"):Connect(function()
                        updateHealth(tree:GetAttribute("Health"))
                    end)
                end
            end
        end

        local function enableTreeESP()
            for _, tree in pairs(Tree:GetChildren()) do
                if tree.Name == "Small Tree" then
                    createTreeESP(tree)
                end
            end

            treeAddedConnection = Tree.ChildAdded:Connect(function(tree)
                if tree.Name == "Small Tree" then
                    createTreeESP(tree)
                end
            end)
        end

        local function disableTreeESP()
            for _, tree in pairs(Tree:GetChildren()) do
                local oldGui = tree:FindFirstChild("TreeHealth")
                if oldGui then
                    oldGui:Destroy()
                end
            end

            if treeAddedConnection then
                treeAddedConnection:Disconnect()
                treeAddedConnection = nil
            end
        end

        local treeAddedConnection

-- loadstring(game:HttGet("https://raw.githubusercontent.com/a11bove/Aiko-Hub/refs/heads/main/nitf/func.lua"))()
loadstring(game:HttpGet("https://raw.githubusercontent.com/a11bove/Aiko-Hub/refs/heads/main/nitf/ui.lua"))()
