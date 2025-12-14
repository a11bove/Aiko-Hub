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
                    else
                        Fluent:Notify({
                            Title = "AutoPlant",
                            Icon = "bell-ring",
                            Content = "No More Sapling Found",
                            Duration = 3,
                        })
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

local Fluent = loadstring(game:HttpGet("https://raw.githubusercontent.com/discoart/FluentPlus/refs/heads/main/Beta.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
            Title = "@aoki",
            SubTitle = "| 99 Nights in The Forest | made by @untog!",
            Icon = "home", -- optional
            TabWidth = 120,
            Size = UDim2.fromOffset(420, 320),
            Acrylic = false,
            Theme = "Dark",
            MinimizeKey = Enum.KeyCode.LeftControl,
        })

        local Tabs = {
            Main = Window:AddTab({ Title = "Home", Icon = "house" }),
            Combat = Window:AddTab({ Title = "Combat", Icon = "sword" }),
            Fun = Window:AddTab({ Title = "Fun", Icon = "star" }),
            Camp = Window:AddTab({ Title = "Auto", Icon = "repeat-2" }),
            br = Window:AddTab({ Title = "Bring", Icon = "package" }),
            Fly = Window:AddTab({ Title = "Player", Icon = "user" }),
            esp = Window:AddTab({ Title = "Esp", Icon = "eye" }),
            Tp = Window:AddTab({ Title = "Teleport", Icon = "map" }),
            Vision = Window:AddTab({ Title = "Environment", Icon = "earth" }),
            Codes = Window:AddTab({ Title = "Codes", Icon = "ticket" }),
            Information = Window:AddTab({ Title = "Info", Icon = "badge-info" }),
            Misc = Window:AddTab({ Title = "Other", Icon = "chart-bar-big" }),
            Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
        }

        local Minimizer = Fluent:CreateMinimizer({
          Icon = "home",
          Size = UDim2.fromOffset(44, 44),
          Position = UDim2.new(0, 320, 0, 24),
          Acrylic = true,
          Corner = 10,
          Transparency = 1,
          Draggable = true,
        })

local Options = Fluent.Options

        do
            local Section = Tabs.Main:AddSection("Info", "info")

            local Toggle = Tabs.Main:AddToggle("antiAfk", {Title = "Anti AFK", Default = false })

            Toggle:OnChanged(function(state)
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
                end)

        local Section = Tabs.Main:AddSection("Visual Settings", "settings-2")

        local Toggle2 = Tabs.Main:AddToggle("showFps", {Title = "Show FPS", Default = false })

        Toggle2:OnChanged(function(val)
        showFPS = val
        fpsText.Visible = val
        end)

        local Toggle3 = Tabs.Main:AddToggle("showPing", {Title = "Show Ping", Default = false })

        Toggle3:OnChanged(function(val)
        showPing = val
        msText.Visible = val
        end)

        local Toggle4 = Tabs.Main:AddToggle("showPlayers", {Title = "Show Players", Default = false })

        Toggle4:OnChanged(function(val)
        showPlayers = val
        playersText.Visible = val
        end)

        local Section = Tabs.Combat:AddSection("Aura", "star")

        local Toggle5 = Tabs.Combat:AddToggle("killAura", {Title = "Kill Aura", Default = false })

            Toggle5:OnChanged(function(state)
                killAuraToggle = state
                if state then
                    task.spawn(killAuraLoop)
                else
                    local tool, _ = getAnyToolWithDamageID(false)
                    unequipTool(tool)
                end
            end)

        local Toggle6 = Tabs.Combat:AddToggle("chopAura", {Title = "Chop Aura", Default = false })

        Toggle6:OnChanged(function(state)
        chopAuraToggle = state
                if state then
                    task.spawn(chopAuraLoop)
                else
                    local tool, _ = getAnyToolWithDamageID(true)
                    unequipTool(tool)
                end
        end)

        local Section = Tabs.Combat:AddSection("Settings", "settings")

        local Slider = Tabs.Combat:AddSlider("auraRadius", {
                Title = "Aura Radius",
                Default = 50,
                Min = 1,
                Max = 100,
                Rounding = 1,
                Callback = function(value)
                   auraRadius = math.clamp(value, 1, 100)
                end
            })

        local Section = Tabs.Combat:AddSection("Hitbox Mobs", "swords")

        local Dropdown1 = Tabs.Combat:AddDropdown("selectMobs", {
                Title = "Select Mobs to Add Hitbox",
                Values = MobsList,
                Multi = true,
                Search = true,
            })

            Dropdown1:OnChanged(function(options)
                SelectedMobs = options
                UpdateHitboxes()
        end)

        local Slider2 = Tabs.Combat:AddSlider("hbSize", {
                Title = "Hitbox Size",
                Default = 50,
                Min = 20,
                Max = 100,
                Rounding = 1,
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

        local Toggle7 = Tabs.Combat:AddToggle("addHb", {Title = "Add Hitbox", Default = false })

        Toggle7:OnChanged(function(state)
        if state then
                    pcall(function()
                        AddAllHitboxes()
                    end)
                else
                        RemoveAllHitboxes()
                end
        end)

        local Section = Tabs.Misc:AddSection("Chests", "package-2")

        local Toggle8 = Tabs.Misc:AddToggle("autoOpenChest", {Title = "Auto Open Chests", Default = false })

        Toggle8:OnChanged(function(v)
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
        end)

        local Section = Tabs.Misc:AddSection("Auto Feed", "utensils")

        local Dropdown2 = Tabs.Misc:AddDropdown("selectFood", {
                Title = "Select Food",
                Values = alimentos,
                Multi = true,
                Search = true,
                Default = selectedFood,
            })

            Dropdown2:OnChanged(function(value)
                selectedFood = value
        end)

        local Input = Tabs.Misc:AddInput("eatAmount", {
                Title = "Eat Amount",
                Default = tostring(hungerThreshold),
                Placeholder = "...",
                Numeric = true, -- Only allows numbers
                Finished = true,
                Callback = function(value)
                    local n = tonumber(value)
                if n then
                    hungerThreshold = math.clamp(n, 0, 100)
                end
        end
            })

        local Toggle9 = Tabs.Misc:AddToggle("autoEat", {Title = "Auto Eat", Default = false })

        Toggle9:OnChanged(function(state)
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
        end)

        local Section = Tabs.Camp:AddSection("Auto Plant", "sprout")

        local Toggle10 = Tabs.Camp:AddToggle("autoPlant", {Title = "Auto Plant", Default = false })

        Toggle10:OnChanged(function(state)
        if state then
                    pcall(function()
                        StartAutoPlant()
                    end)
                else
                    StopAutoPlant()
                end
        end)

        local Section = Tabs.Combat:AddSection("Hitbox Mobs", "swords")

        local Dropdown3 = Tabs.Combat:AddDropdown("selectMobs", {
                Title = "Select Mobs to Add Hitbox",
                Values = MobsList,
                Multi = true,
                Search = true,
            })

            Dropdown3:OnChanged(function(options)
                SelectedMobs = options
                UpdateHitboxes()
        end)

        local Slider2 = Tabs.Combat:AddSlider("plantRadius", {
                Title = "Plant Radius",
                Default = 50,
                Min = 50,
                Max = 100,
                Rounding = 1,
                Callback = function(value)
                   _G.AutoSapRadius = value
        end
        })

        local Section = Tabs.Camp:AddSection("Auto Upgrade Campfire", "flame")

        local selectedCampfireItems = {}

        local Dropdown4 = Tabs.Camp:AddDropdown("selectMobs", {
                Title = "Select Mobs to Add Hitbox",
                Values = campfireFuelItems,
                Multi = true,
                Search = true,
            })

            Dropdown4:OnChanged(function(options)
                selectedCampfireItems = options or {}
        end)

        local Toggle11 = Tabs.Main:AddToggle("autoUpgCf", {Title = "Auto Upgrade Campfire", Default = false })

        Toggle11:OnChanged(function(checked)
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
        end)

        local Section = Tabs.Camp:AddSection("Auto Scrap", "cog")

        local Dropdown5 = Tabs.Camp:AddDropdown("chooseItemAS", {
                Title = "Choose Item to Auto Scrap",
                Values = scrapjunkItems,
                Multi = false,
                Search = true,
            })

            Dropdown5:OnChanged(function(option)
                selectedScrapItem = option
        end)

        local Toggle12 = Tabs.Camp:AddToggle("autoScrap", {Title = "Auto Scrap", Default = false })

        Toggle12:OnChanged(function(checked)
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
        end)

        local Section = Tabs.Camp:AddSection("Auto Cook", "flame")

        local Dropdown6 = Tabs.Camp:AddDropdown("listOfFood", {
                Title = "Food List",
                Values = autocookItems,
                Multi = true,
                Search = true,
            })

            Dropdown6:OnChanged(function(options)
                for _, itemName in ipairs(autocookItems) do
                    autoCookEnabledItems[itemName] = table.find(options, itemName) ~= nil
                end
        end)

        local Toggle13 = Tabs.Camp:AddToggle("autoCookFood", {Title = "Auto Cook", Default = false })

        Toggle13:OnChanged(function(state)
        autoCookEnabled = state
        end)

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

        local Section = Tabs.Camp:AddSection("Auto Craft Items", "hammer")

        local Dropdown7 = Tabs.Camp:AddDropdown("chooseCraft", {
                Title = "Choose Items to Craft",
                Values = craftableItems,
                Multi = true,
                Search = true,
            })

            Dropdown7:OnChanged(function(options)
                selectedCraftItems = options or {}
        end)

        local Toggle14 = Tabs.Camp:AddToggle("autoCraftIT", {Title = "Auto Craft Items", Default = false })

        Toggle14:OnChanged(function(checked)
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
        end)

        local Section = Tabs.Camp:AddSection("Crafting Bench", "wrench")

        local Dropdown8 = Tabs.Camp:AddDropdown("choosebench", {
                Title = "Choose Which Bench to Upgrade",
                Values = craftingBenchItems,
                Multi = true,
                Search = true,
            })

            Dropdown8:OnChanged(function(options)
                selectedBenchItems = options or {}
        end)

        local Toggle14 = Tabs.Camp:AddToggle("autoupgradebench", {Title = "Auto Upgrade Bench", Default = false })

        Toggle14:OnChanged(function(checked)
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
        end)

  local Section = Tabs.Tp:AddSection("Scan Map", "map")

        local Toggle15 = Tabs.Tp:AddToggle("scanmap", {Title = "Scan Map", Desc = "Might not work for some executors.", Default = false })

        Toggle15:OnChanged(function(state)
        scan_map = state

            if not state then
                if type(tp1) == "function" and scan_map_was_on then
                    tp1()
                end
                scan_map_was_on = false
                return
            else
                scan_map_was_on = true
            end

            task.spawn(function()
                local character = player.Character or player.CharacterAdded:Wait()
                local hrp = character:WaitForChild("HumanoidRootPart", 3)
                if not hrp then return end

                local map = workspace:FindFirstChild("Map")
                if not map then return end

                local foliage = map:FindFirstChild("Foliage") or map:FindFirstChild("Landmarks")
                if not foliage then return end

                while scan_map do
                    local trees = {}
                    for _, obj in ipairs(foliage:GetChildren()) do
                        if obj.Name == "Small Tree" and obj:IsA("Model") then
                            local trunk = obj:FindFirstChild("Trunk") or obj.PrimaryPart
                            if trunk then
                                table.insert(trees, trunk)
                            end
                        end
                    end

                    for _, trunk in ipairs(trees) do
                        if not scan_map then break end
                        if trunk and trunk.Parent then
                            local treeCFrame = trunk.CFrame
                            local rightVector = treeCFrame.RightVector
                            local targetPosition = treeCFrame.Position + rightVector * 69 + Vector3.new(0, 15, 69)

                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(targetPosition)

                            local footPart = Instance.new("Part")
                            footPart.Size = Vector3.new(10, 1, 10)
                            footPart.Anchored = true
                            footPart.CanCollide = true
                            footPart.Transparency = 1
                            footPart.BrickColor = BrickColor.new("Bright yellow")
                            footPart.CFrame = CFrame.new(targetPosition - Vector3.new(0, 3, 0))
                            footPart.Parent = workspace

                            game.Debris:AddItem(footPart, 1)

                            task.wait(0.01)
                        end
                    end
                    task.wait(0.25)
                end
            end)
        end)

        local Section = Tabs.Tp:AddSection("Teleport", "map-pin")

        Tabs.Tp:AddButton({
            Title = "Teleport to Campfire",
            Callback = function()
                tp1()
            end
        })

        Tabs.Tp:AddButton({
            Title = "Teleport to Stronghold",
            Callback = function()
                tp2()
            end
        })

        Tabs.Tp:AddButton({
            Title = "Teleport to Safe Zone",
            Callback = function()
                if not workspace:FindFirstChild("SafeZonePart") then
                    local createpart = Instance.new("Part")
                    createpart.Name = "SafeZonePart"
                    createpart.Size = Vector3.new(30, 3, 30)
                    createpart.Position = Vector3.new(0, 350, 0)
                    createpart.Anchored = true
                    createpart.CanCollide = true
                    createpart.Transparency = 0.8
                    createpart.Color = Color3.fromRGB(255, 0, 0)
                    createpart.Parent = workspace
                end
                local player = game:GetService("Players").LocalPlayer
                local character = player.Character or player.CharacterAdded:Wait()
                local hrp = character:WaitForChild("HumanoidRootPart")
                hrp.CFrame = CFrame.new(0, 360, 0)
            end
        })

        Tabs.Tp:AddButton({
            Title = "Teleport to Trader",
            Callback = function()
                local pos = Vector3.new(-37.08, 3.98, -16.33)
                local player = game:GetService("Players").LocalPlayer
                local character = player.Character or player.CharacterAdded:Wait()
                local hrp = character:WaitForChild("HumanoidRootPart")
                hrp.CFrame = CFrame.new(pos)
            end
        })

        local Section = Tabs.Tp:AddSection("Tree", "tree-deciduous")

        Tabs.Tp:AddButton({
            Title = "Teleport to Random Tree",
            Callback = function()
                local player = Players.LocalPlayer
                local character = player.Character or player.CharacterAdded:Wait()
                local hrp = character:FindFirstChild("HumanoidRootPart", 3)
                if not hrp then return end

                local map = workspace:FindFirstChild("Map")
                if not map then return end

                local foliage = map:FindFirstChild("Foliage") or map:FindFirstChild("Landmarks")
                if not foliage then return end

                local trees = {}
                for _, obj in ipairs(foliage:GetChildren()) do
                    if obj.Name == "Small Tree" and obj:IsA("Model") then
                        local trunk = obj:FindFirstChild("Trunk") or obj.PrimaryPart
                        if trunk then
                            table.insert(trees, trunk)
                        end
                    end
                end

                if #trees > 0 then
                    local trunk = trees[math.random(1, #trees)]
                    local treeCFrame = trunk.CFrame
                    local rightVector = treeCFrame.RightVector
                    local targetPosition = treeCFrame.Position + rightVector * 3
                    hrp.CFrame = CFrame.new(targetPosition)
                end
            end
        })

        local Section = Tabs.Tp:AddSection("Children", "eye")

        local Dropdown9 = Tabs.Tp:AddDropdown("selectchild", {
                Title = "Select Child",
                Values = currentMobNames,
                Multi = false,
                Search = true,
            })

            Dropdown9:OnChanged(function(options)
        selectedMob = options[#options] or currentMobNames[1] or nil
        end)

        Tabs.Tp:AddButton({
            Title = "Refresh List",
            Callback = function()
                currentMobs, currentMobNames = getMobs()
                if #currentMobNames > 0 then
                    selectedMob = currentMobNames[1]
                    MobDropdown:Refresh(currentMobNames)
                else
                    selectedMob = nil
                    MobDropdown:Refresh({ "No child found" })
                end
            end
        })

        Tabs.Tp:AddButton({
            Title = "Teleport to Child",
            Callback = function()
                if selectedMob and currentMobs then
                    for i, name in ipairs(currentMobNames) do
                        if name == selectedMob then
                            local targetMob = currentMobs[i]
                            if targetMob then
                                local part = targetMob.PrimaryPart or targetMob:FindFirstChildWhichIsA("BasePart")
                                if part and game.Players.LocalPlayer.Character then
                                    local hrp = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                                    if hrp then
                                        hrp.CFrame = part.CFrame + Vector3.new(0, 5, 0)
                                    end
                                end
                            end
                            break
                        end
                    end
                end
            end
        })

        local Section = Tabs.Tp:AddSection("Chest", "box")

        local Dropdown10 = Tabs.Tp:AddDropdown("selectchest", {
            Title = "Select Chest",
            Values = currentChestNames,
            Multi = false,
            Search = true,
        })

        Dropdown10:OnChanged(function(options)
        selectedChest = options[#options] or currentChestNames[1] or nil
        end)

        Tabs.Tp:AddButton({
            Title = "Refresh List",
            Callback = function()
                currentChests, currentChestNames = getChests()
                if #currentChestNames > 0 then
                    selectedChest = currentChestNames[1]
                    Dropdown10:Refresh(currentChestNames)
                else
                    selectedChest = nil
                    Dropdown10:Refresh({ "No chests found" })
                end
            end
        })

        Tabs.Tp:AddButton({
            Title = "Teleport to Chest",
            Callback = function()
                if selectedChest and currentChests then
                    local chestIndex = 1
                    for i, name in ipairs(currentChestNames) do
                        if name == selectedChest then
                            chestIndex = i
                            break
                        end
                    end
                    local targetChest = currentChests[chestIndex]
                    if targetChest then
                        local part = targetChest.PrimaryPart or targetChest:FindFirstChildWhichIsA("BasePart")
                        if part and game.Players.LocalPlayer.Character then
                            local hrp = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                            if hrp then
                                hrp.CFrame = part.CFrame + Vector3.new(0, 5, 0)
                            end
                        end
                    end
                end
            end
        })

        local Toggle16 = Tabs.br:AddToggle("scanmap2", {Title = "Scan Map", Default = false })

        Toggle16:OnChanged(function(state)
        scan_map = state

            if not state then
                if type(tp1) == "function" and scan_map_was_on then
                    tp1()
                end
                scan_map_was_on = false
                return
            else
                scan_map_was_on = true
            end

            task.spawn(function()
                local player = Players.LocalPlayer
                local character = player.Character or player.CharacterAdded:Wait()
                local hrp = character:WaitForChild("HumanoidRootPart", 3)
                if not hrp then return end

                local map = workspace:FindFirstChild("Map")
                if not map then return end

                local foliage = map:FindFirstChild("Foliage") or map:FindFirstChild("Landmarks")
                if not foliage then return end

                while scan_map do
                    local trees = {}
                    for _, obj in ipairs(foliage:GetChildren()) do
                        if obj.Name == "Small Tree" and obj:IsA("Model") then
                            local trunk = obj:FindFirstChild("Trunk") or obj.PrimaryPart
                            if trunk then
                                table.insert(trees, trunk)
                            end
                        end
                    end

                    for _, trunk in ipairs(trees) do
                        if not scan_map then break end
                        if trunk and trunk.Parent then
                            local treeCFrame = trunk.CFrame
                            local rightVector = treeCFrame.RightVector
                            local targetPosition = treeCFrame.Position + rightVector * 69 + Vector3.new(0, 15, 69)

                            hrp.CFrame = CFrame.new(targetPosition)

                            local footPart = Instance.new("Part")
                            footPart.Size = Vector3.new(10, 1, 10)
                            footPart.Anchored = true
                            footPart.CanCollide = true
                            footPart.Transparency = 1
                            footPart.BrickColor = BrickColor.new("Bright yellow")
                            footPart.CFrame = CFrame.new(targetPosition - Vector3.new(0, 3, 0))
                            footPart.Parent = workspace

                            game.Debris:AddItem(footPart, 1)

                            task.wait(0.01)
                        end
                    end
                    task.wait(0.25)
                end
            end)
        end)

        Tabs.br:AddButton({
            Title = "Reveal Whole Map",
            Desc = "Visually reveals the whole map",
            Callback = function()
                local boundaries = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Boundaries")
                if boundaries then
                    for _, obj in pairs(boundaries:GetChildren()) do
                        obj:Destroy()
                    end
                end
            end
        })

        local Section = Tabs.br:Section("Blue Print", "hammer")

        local Dropdown12 = Tabs.br:AddDropdown("selectBp", {
            Title = "Select Blueprint Items",
            Values = selectedBlueprintItems,
            Multi = true,
            Search = true,
        })

        Dropdown12:OnChanged(function(options)
        selectedBlueprintItems = options
        end)

        local Toggle17 = Tabs.br:AddToggle("bringBps", {Title = "Bring Blueprints", Default = false })

        Toggle17:OnChanged(function(value)
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
        end)

        local Section = Tabs.br:AddSection("Pelts", "shirt")

        local Dropdown13 = Tabs.br:AddDropdown("selectPelts", {
            Title = "Select Pelts Items",
            Values = PeltsItems,
            Multi = true,
            Search = true,
        })

        Dropdown13:OnChanged(function(options)
        selectedPeltsItems = options
        end)

        local Toggle18 = Tabs.br:AddToggle("bringPelts", {Title = "Bring Pelts", Default = false })

        Toggle18:OnChanged(function(value)
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
        end)

        local Section = Tabs.br:AddSection("Junk", "box")

        local Dropdown14 = Tabs.br:AddDropdown("selectJunkz", {
            Title = "Select Junk Items",
            Values = junkItems,
            Multi = true,
            Search = true,
        })

        Dropdown14:OnChanged(function(options)
        selectedJunkItems = options
        end)

        local Toggle19 = Tabs.br:AddToggle("bringJunkz", {Title = "Bring Junks", Default = false })

        Toggle19:OnChanged(function(value)
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
        end)

        local Section = Tabs.br:AddSection("Fuel", "flame")

        local Dropdown15 = Tabs.br:AddDropdown("selectFuelz", {
            Title = "Select Fuel Items",
            Values = fuelItems,
            Multi = true,
            Search = true,
        })

        Dropdown15:OnChanged(function(options)
        selectedFuelItems = options
        end)

        local Toggle20 = Tabs.br:AddToggle("bringFuelz", {Title = "Bring Fuels", Default = false })

        Toggle20:OnChanged(function(value)
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
        end)

        local Section = Tabs.br:AddSection("Food", "utensils")

        local Dropdown16 = Tabs.br:AddDropdown("selectfooditemz", {
            Title = "Select Food Items",
            Values = foodItems,
            Multi = true,
            Search = true,
        })

        Dropdown16:OnChanged(function(options)
        selectedFoodItems = options
        end)

        local Toggle20 = Tabs.br:AddToggle("bringFoodz", {Title = "Bring Foods", Default = false })

        Toggle20:OnChanged(function(value)
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
        end)

        local Section = Tabs.br:AddSection("Medicine", "bandage")

        local Dropdown17 = Tabs.br:AddDropdown("selectmeditemz", {
            Title = "Select Medical Items",
            Values = medicalItems,
            Multi = true,
            Search = true,
        })

        Dropdown17:OnChanged(function(options)
        selectedMedicalItems = options
        end)

        local Toggle21= Tabs.br:AddToggle("bringMedz", {Title = "Bring Medical Items", Default = false })

        Toggle21:OnChanged(function(value)
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
        end)

        local Section = Tabs.br:AddSection("Mobs", "bow-arrow")

        local Dropdown18 = Tabs.br:AddDropdown("selectMobz", {
            Title = "Select Mobs to Bring",
            Values = cultistItems,
            Multi = true,
            Search = true,
        })

        Dropdown18:OnChanged(function(options)
        selectedCultistItems = options
        end)

        local Toggle21 = Tabs.br:AddToggle("bringmobz", {Title = "Bring Mobs", Default = false })

        Toggle21:OnChanged(function(value)
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
        end)

        local Section = Tabs.br:AddSection("Equipment", "sword")

        local Dropdown19 = Tabs.br:AddDropdown("selectequipments", {
            Title = "Select Equipments",
            Values = equipmentItems,
            Multi = true,
            Search = true,
        })

        Dropdown19:OnChanged(function(options)
        selectedEquipmentItems = options
        end)

        local Toggle22 = Tabs.br:AddToggle("bringequipments", {Title = "Bring Equiments", Default = false })

        Toggle22:OnChanged(function(value)
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
        end)

        local Section = Tabs.br:AddSection("Sapling", "sprout")

        local Toggle23 = Tabs.br:AddToggle("bringsap", {Title = "Bring Saplings", Default = false })

        Toggle23:OnChanged(function(value)
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
        end)

        local Section = Tabs.Fly:AddSection("Player", "user")

        local hipheight = Tabs.Fly:AddSlider("hipHeight", {
            Title = "Hip Height",
            Default = 2,
            Min = 1,
            Max = 50,
            Rounding = 1,
            Callback = function(v)
        _G.HipHeight = v
        if _G.HipHeightOn then
        game.Players.LocalPlayer.Character.Humanoid.HipHeight = v
        end
        end
        })

        local flyspeed 
        = Tabs.Fly:AddSlider("flySpeed", {
            Title = "Fly Speed",
            Default = 1,
            Min = 1,
            Max = 20,
            Rounding = 1,
            Callback = function(value)
        flySpeed = value
        if FLYING then
        task.spawn(function()
        while FLYING do
        task.wait(0.1)
        if game:GetService("UserInputService").TouchEnabled then
        local root = Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if root and root:FindFirstChild("BodyVelocity") then
        local bv = root:FindFirstChild("BodyVelocity")
        bv.Velocity = bv.Velocity.Unit * (flySpeed * 50)
        end
        end
        end
        end)
        end
        end
        })

        local speed = 16

        local function setSpeed(val)
            local humanoid = Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then humanoid.WalkSpeed = val end
        end

        local ishowspeed 
        = Tabs.Fly:AddSlider("iShowNigga", {
            Title = "Walkspeed",
            Default = 16,
            Min = 16,
            Max = 150,
            Rounding = 1,
            Callback = function(value)
        speed = value
            end
        })

        local enablerHh = Tabs.Fly:AddToggle("HHenabler", {Title = "Enable Hip Height", Default = false })

        enablerHh:OnChanged(function(PH)
        _G.HipHeightOn = PH
        if PH then
        game.Players.LocalPlayer.Character.Humanoid.HipHeight = _G.HipHeight or 2
        end
        end)

        local enablerfly = Tabs.Fly:AddToggle("flyenabler", {Title = "Enable Fly", Default = false })

        enablerfly:OnChanged(function(state)
        flyToggle = state
        if flyToggle then
        if game:GetService("UserInputService").TouchEnabled then
        MobileFly()
        else
        sFLY()
        end
        else
        NOFLY()
        UnMobileFly()
        end
        end)

        local enablernigga = Tabs.Fly:AddToggle("niggaenabler", {Title = "Enable Walkspeed", Default = false })

        enablernigga:OnChanged(function(state)
        setSpeed(state and speed or 16)
        end)

        local Section = Tabs.Fly:AddSection("Misc", "flame")

        local RunService = game:GetService("RunService")
        local noclipConnection

        local noclipz = Tabs.Fly:AddToggle("clipnoz", {Title = "No Clip", Default = false })

        noclipz:OnChanged(function(state)
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
        end)

        local UserInputService = game:GetService("UserInputService")
        local infJumpConnection

        local infj = Tabs.Fly:AddToggle("Infj", {Title = "Inf Jump", Default = false })

        infj:OnChanged(function(state)
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
        end)

  local esplay = Tabs.esp:AddToggle("espPlayer", {Title = "Esp Players", Default = false })

esplay:OnChanged(function(enable)
        _G.EspPlayerOn = enable
        if enable then
            pcall(function()
                createPlayerNameBillboard(player)
                end)
                else
                    _G.EspPlayerOn = false
        end
        end)

  local esptrre = Tabs.esp:AddToggle("espTree", {Title = "Esp Tree Health", Default = false })

esptogol:OnChanged(function(enable)
        if enable then
                enableTreeESP()
            else
                disableTreeESP()
            end
        end)

        local Section = Tabs.esp:AddSection("Esp Items", "package")

        local espItemz = Tabs.esp:AddDropdown("espItem", {
            Title = "Esp Items",
            Values = ie,
            Multi = true,
            Search = true,
            Default = {},
        })

        espItemz:OnChanged(function(options)
        selectedItems = options
        if espItemsEnabled then
        for _, name in ipairs(ie) do
        if table.find(selectedItems, name) then
        Aesp(name, "item")
        else
        Desp(name, "item")
        end
        end
        else
        for _, name in ipairs(ie) do
        Desp(name, "item")
        end
        end
        end)

        local esptogol = Tabs.esp:AddToggle("espToggle", {Title = "Enable Esp", Default = false })

        esptogol:OnChanged(function(state)
        espItemsEnabled = state
        for _, name in ipairs(ie) do
        if state and table.find(selectedItems, name) then
        Aesp(name, "item")
        else
        Desp(name, "item")
        end
        end

        if state then
        if not espConnections["Items"] then
        local container = workspace:FindFirstChild("Items")
        if container then
        espConnections["Items"] = container.ChildAdded:Connect(function(obj)
        if table.find(selectedItems, obj.Name) then
        local part = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart")
        if part then
        createESP(part, obj.Name, Color3.fromRGB(0, 255, 0))
        end
        end
        end)
        end
        end
        else
        if espConnections["Items"] then
        espConnections["Items"]:Disconnect()
        espConnections["Items"] = nil
        end
        end
        end)

        local Section = Tabs.esp:AddSection("Esp Entity", "user")

        local espentite = Tabs.esp:AddDropdown("esptite", {
            Title = "Esp Entity",
            Values = me,
            Multi = true,
            Search = true,
            Default = {},
        })

        espItemz:OnChanged(function(options)
        selectedMobs = options
            if espMobsEnabled then
                for _, name in ipairs(me) do
                    if table.find(selectedMobs, name) then
                        Aesp(name, "mob")
                    else
                        Desp(name, "mob")
                    end
                end
            else
                for _, name in ipairs(me) do
                    Desp(name, "mob")
                end
            end
        end)

        local esptogol2 = Tabs.esp:AddToggle("esptoggle2", {Title = "Enable Esp", Default = false })

        esptogol:OnChanged(function(state)
        espMobsEnabled = state
            for _, name in ipairs(me) do
                if state and table.find(selectedMobs, name) then
                    Aesp(name, "mob")
                else
                    Desp(name, "mob")
                end
            end

            if state then
                if not espConnections["Mobs"] then
                    local container = workspace:FindFirstChild("Characters")
                    if container then
                        espConnections["Mobs"] = container.ChildAdded:Connect(function(obj)
                            if table.find(selectedMobs, obj.Name) then
                                local part = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart")
                                if part then
                                    createESP(part, obj.Name, Color3.fromRGB(255, 255, 0))
                                end
                            end
                        end)
                    end
                end
            else
                if espConnections["Mobs"] then
                    espConnections["Mobs"]:Disconnect()
                    espConnections["Mobs"] = nil
                end
            end
        end)

        local Section = Tabs.Misc:AddSection("Miscellaneous", "settings")

        local instantInteractEnabled = false
        local instantInteractConnection
        local originalHoldDurations = {}

        local instantin = Tabs.Misc:AddToggle("intantIn", {Title = "Instant Interact", Default = false })

        instantin:OnChanged(function(state)
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
        end)

        local autocoins = Tabs.Misc:AddToggle("autoCollectCoins", {Title = "Auto Collect Coin Stacks", Default = false })

        autocoins:OnChanged(function(value)
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
        end)

        local autoanvil = Tabs.Misc:AddToggle("autoAnvil", {Title = "Auto Build Anvil", Default = false })

        autoanvil:OnChanged(function(state)
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
        end)

        local Section = Tabs.Misc:AddSection("Anti's", "skull")

        local RunService = game:GetService("RunService")
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local torchLoop = nil

        local stunder = Tabs.Misc:AddToggle("stunDeer", {Title = "Auto Stun Deer", Default = false })

        stunder:OnChanged(function(state)
        if state then
            torchLoop = RunService.RenderStepped:Connect(function()
                pcall(function()
                    local remote = ReplicatedStorage:FindFirstChild("RemoteEvents")
                        and ReplicatedStorage.RemoteEvents:FindFirstChild("DeerHitByTorch")
                    local deer = workspace:FindFirstChild("Characters")
                        and workspace.Characters:FindFirstChild("Deer")
                    if remote and deer then
                        remote:InvokeServer(deer)
                    end
                end)
                task.wait(0.1)
            end)
        else
            if torchLoop then
                torchLoop:Disconnect()
                torchLoop = nil
            end
        end
        end)

        local RunService = game:GetService("RunService")
        local player = Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local HumanoidRootPart = character:WaitForChild("HumanoidRootPart")

        local ESCAPE_DISTANCE_OWL = 80
        local ESCAPE_SPEED_OWL = 5

        local ESCAPE_DISTANCE_DEER = 60
        local ESCAPE_SPEED_DEER = 4

        local ESCAPE_DISTANCE_RAM = 65
        local ESCAPE_SPEED_RAM = 4.5

        local escapeLoopOwl
        local escapeLoopDeer
        local escapeLoopRam

        local escowl = Tabs.Misc:AddToggle("escOwl", {Title = "Auto Escape From Owl", Default = false })

        escowl:OnChanged(function(state)
        if state then
            escapeLoopOwl = RunService.RenderStepped:Connect(function()
                pcall(function()
                    local owl = workspace:FindFirstChild("Characters") and workspace.Characters:FindFirstChild("Owl")
                    if owl and owl:FindFirstChild("HumanoidRootPart") then
                        local myPos = HumanoidRootPart.Position
                        local owlPos = owl.HumanoidRootPart.Position
                        local distance = (myPos - owlPos).Magnitude

                        if distance < ESCAPE_DISTANCE_OWL then
                            local direction = (myPos - owlPos).Unit
                            HumanoidRootPart.CFrame = HumanoidRootPart.CFrame + direction * ESCAPE_SPEED_OWL
                        end
                    end
                end)
            end)
        else
            if escapeLoopOwl then
                escapeLoopOwl:Disconnect()
                escapeLoopOwl = nil
            end
        end
        end)

        local esder = Tabs.Misc:AddToggle("esDer", {Title = "Auto Escape From Deer", Default = false })

        esder:OnChanged(function(state)
        if state then
            escapeLoopDeer = RunService.RenderStepped:Connect(function()
                pcall(function()
                    local deer = workspace:FindFirstChild("Characters") and workspace.Characters:FindFirstChild("Deer")
                    if deer and deer:FindFirstChild("HumanoidRootPart") then
                        local myPos = HumanoidRootPart.Position
                        local deerPos = deer.HumanoidRootPart.Position
                        local distance = (myPos - deerPos).Magnitude

                        if distance < ESCAPE_DISTANCE_DEER then
                            local direction = (myPos - deerPos).Unit
                            HumanoidRootPart.CFrame = HumanoidRootPart.CFrame + direction * ESCAPE_SPEED_DEER
                        end
                    end
                end)
            end)
        else
            if escapeLoopDeer then
                escapeLoopDeer:Disconnect()
                escapeLoopDeer = nil
            end
        end
        end)

        local esrm = Tabs.Misc:AddToggle("esRm", {Title = "Auto Escape From Ram", Default = false })

        esrm:OnChanged(function(state)
        if state then
            escapeLoopRam = RunService.RenderStepped:Connect(function()
                pcall(function()
                    local ram = workspace:FindFirstChild("Characters") and workspace.Characters:FindFirstChild("Ram")
                    if ram and ram:FindFirstChild("HumanoidRootPart") then
                        local myPos = HumanoidRootPart.Position
                        local ramPos = ram.HumanoidRootPart.Position
                        local distance = (myPos - ramPos).Magnitude

                        if distance < ESCAPE_DISTANCE_RAM then
                            local direction = (myPos - ramPos).Unit
                            HumanoidRootPart.CFrame = HumanoidRootPart.CFrame + direction * ESCAPE_SPEED_RAM
                        end
                    end
                end)
            end)
        else
            if escapeLoopRam then
                escapeLoopRam:Disconnect()
                escapeLoopRam = nil
            end
        end
        end)

        local Section = Tabs.Fun:AddSection("Fun", "star")

        deleteSettings = {
            Owl = false,
            Deer = false,
            Ram = false
        }

        function autoDelete()
            for name, enabled in pairs(deleteSettings) do
                if enabled then
                    for _, obj in pairs(workspace.Characters:GetChildren()) do
                        if obj.Name == name then
                            obj:Destroy()
                        end
                    end
                end
            end
        end

        RunService.Heartbeat:Connect(autoDelete)

        local deowl = Tabs.Fun:AddToggle("deOwl", {Title = "Auto Delete Owl", Default = false })

        deowl:OnChanged(function(state)
            deleteSettings.Owl = state
        end)

        local dedr = Tabs.Fun:AddToggle("deDr", {Title = "Auto Delete Deer", Default = false })

        dedr:OnChanged(function(state)
            deleteSettings.Deer = state
        end)

        local drm = Tabs.Fun:AddToggle("dRm", {Title = "Auto Delete Ram", Default = false })

        drm:OnChanged(function(state)
            deleteSettings.Ram = state
        end)

        local sldier = Tabs.Main:AddSlider("grvSl", {
            Title = "Gravity",
            Default = 196,
            Min = 0,
            Max = 500,
            Rounding = 1,
            Callback = function(value)
        workspace.Gravity = value
        end
        })

        _G.GodModeEnabled = false

        function _G.ApplyGodMode(state)
            if character then
                for i, part in ipairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = not state
                    end
                end

                hum = character:FindFirstChildOfClass("Humanoid")
                if state and hum then
                    if _G.GodModeHumConnection then _G.GodModeHumConnection:Disconnect() _G.GodModeHumConnection = nil end
                    if _G.GodModeHeartbeat then _G.GodModeHeartbeat:Disconnect() _G.GodModeHeartbeat = nil end

                    _G.GodModeHumConnection = hum.HealthChanged:Connect(function(hp)
                        if _G.GodModeEnabled and hum and hum.Health < hum.MaxHealth then
                            hum.Health = hum.MaxHealth
                        end
                    end)

                    _G.GodModeHeartbeat = game:GetService("RunService").Heartbeat:Connect(function()
                        if _G.GodModeEnabled and hum and hum.Health < hum.MaxHealth then
                            hum.Health = hum.MaxHealth
                        end
                    end)
                else
                    if _G.GodModeHumConnection then _G.GodModeHumConnection:Disconnect() _G.GodModeHumConnection = nil end
                    if _G.GodModeHeartbeat then _G.GodModeHeartbeat:Disconnect() _G.GodModeHeartbeat = nil end
                end
            end
        end

        player.CharacterAdded:Connect(function(char)
            character = char
            wait(0.1)
            if _G.GodModeEnabled then
                _G.ApplyGodMode(true)
            end
        end)

        local hbar = Tabs.Fun:AddToggle("hbae", {Title = "No Health Bar", Default = false })

        hbar:OnChanged(function(state)
        _G.GodModeEnabled = state
        _G.ApplyGodMode(state)
        if state then
                    Fluent:Notify({
                        Title = "@aiko",
                        Content = "[AIKO]: Health bar diabled.",
                            Duration = 2,
                    })
        else
                    Fluent:Notify({
                        Title = "@aiko",
                        Content = "[AIKO]: Heath bar enabled.",
                        Duration = 2,
                    })
        end
        end)

        local gmd = Tabs.Fun:AddToggle("gMd", {Title = "God Mode", Default = false })

        gmd:OnChanged(function(value)
        if value then
            _G.GodModeToggle = true
            spawn(function()
                while _G.GodModeToggle do
                    local dmgEvent = rs:FindFirstChild("RemoteEvents") and rs.RemoteEvents:FindFirstChild("DamagePlayer")
                    if dmgEvent then
                        dmgEvent:FireServer(-9999)
                    else
        Fluent:Notify({
        Title = "@aiko",
        Content = "[AIKO]: God mode failed, rejoin and try again.",
        Duration = 2,
        })
                    end
                    RunService.Stepped:Wait()
                end
            end)
        else
            _G.GodModeToggle = false
        end
        end)

        Tabs.Fun:AddButton({
            Title = "Auto Days Farm GUI",
            Desc = "Just AFK and let the script handle it.",
            Callback = function()
                loadstring(game:HttpGet("https://paste.rs/Gc9QX",true))()
            end
        })

        local Section = Tabs.Vision:AddSection("Environment", "eye")

        local originalParents = {
            Sky = nil,
            Bloom = nil,
            CampfireEffect = nil
        }

        local function storeOriginalParents()
            local Lighting = game:GetService("Lighting")

            local sky = Lighting:FindFirstChild("Sky")
            local bloom = Lighting:FindFirstChild("Bloom")
            local campfireEffect = Lighting:FindFirstChild("CampfireEffect")

            if sky and not originalParents.Sky then
                originalParents.Sky = sky.Parent
            end
            if bloom and not originalParents.Bloom then
                originalParents.Bloom = bloom.Parent
            end
            if campfireEffect and not originalParents.CampfireEffect then
                originalParents.CampfireEffect = campfireEffect.Parent
            end
        end

        storeOriginalParents()

        local originalColorCorrectionParent = nil

        local function storeColorCorrectionParent()
            local Lighting = game:GetService("Lighting")
            local colorCorrection = Lighting:FindFirstChild("ColorCorrection")

            if colorCorrection and not originalColorCorrectionParent then
                originalColorCorrectionParent = colorCorrection.Parent
            end
        end

        storeColorCorrectionParent()

        local nfog = Tabs.Vision:AddToggle("nflg", {Title = "Disable Fog", Default = false })

        nfog:OnChanged(function(state)
            local Lighting = game:GetService("Lighting")

            if state then
                local sky = Lighting:FindFirstChild("Sky")
                local bloom = Lighting:FindFirstChild("Bloom")
                local campfireEffect = Lighting:FindFirstChild("CampfireEffect")

                if sky then
                    sky.Parent = nil
                end
                if bloom then
                    bloom.Parent = nil
                end
                if campfireEffect then
                    campfireEffect.Parent = nil
                end


            else
                local sky = game:FindFirstChild("Sky", true)
                local bloom = game:FindFirstChild("Bloom", true) 
                local campfireEffect = game:FindFirstChild("CampfireEffect", true)

                if not sky then sky = Lighting:FindFirstChild("Sky") end
                if not bloom then bloom = Lighting:FindFirstChild("Bloom") end
                if not campfireEffect then campfireEffect = Lighting:FindFirstChild("CampfireEffect") end

                if sky then
                    sky.Parent = originalParents.Sky or Lighting
                end
                if bloom then
                    bloom.Parent = originalParents.Bloom or Lighting
                end
                if campfireEffect then
                    campfireEffect. you  = originalParents.CampfireEffect or Lighting
                end


            end
        end)

        local originalLightingValues = {
            Brightness = nil,
            Ambient = nil,
            OutdoorAmbient = nil,
            ShadowSoftness = nil,
            GlobalShadows = nil,
            Technology = nil
        }

        local function storeOriginalLighting()
            local Lighting = game:GetService("Lighting")

            if not originalLightingValues.Brightness then
                originalLightingValues.Brightness = Lighting.Brightness
                originalLightingValues.Ambient = Lighting.Ambient
                originalLightingValues.OutdoorAmbient = Lighting.OutdoorAmbient
                originalLightingValues.ShadowSoftness = Lighting.ShadowSoftness
                originalLightingValues.GlobalShadows = Lighting.GlobalShadows
                originalLightingValues.Technology = Lighting.Technology
            end
        end

        storeOriginalLighting()

        local nfre = Tabs.Vision:AddToggle("nfrr", {Title = "Disable Night Campfire Effect", Default = false })

        nfre:OnChanged(function(state)
            local Lighting = game:GetService("Lighting")

            if state then
                local colorCorrection = Lighting:FindFirstChild("ColorCorrection")

                if colorCorrection then
                    if not originalColorCorrectionParent then
                        originalColorCorrectionParent = colorCorrection.Parent
                    end
                    colorCorrection.Parent = nil
                end
            else
                local colorCorrection = nil

                colorCorrection = Lighting:FindFirstChild("ColorCorrection")

                if not colorCorrection then
                    colorCorrection = game:FindFirstChild("ColorCorrection", true)
                end

                if colorCorrection then
                    colorCorrection.Parent = Lighting
                end
            end
        end)

        local fbr = Tabs.Vision:AddToggle("fbrr", {Title = "Full Bright", Default = false })

        fbr:OnChanged(function(state)
        if state then
            Lighting.ClockTime = 14
            Lighting.Brightness = 2.2
            Lighting.Ambient = Color3.new(1, 1, 1)
            Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
            Lighting.ShadowSoftness = 0
            Lighting.GlobalShadows = false
            Lighting.Technology = Enum.Technology.Compatibility
        else
            Lighting.Brightness = originalLightingValues.Brightness
            Lighting.Ambient = originalLightingValues.Ambient
            Lighting.OutdoorAmbient = originalLightingValues.OutdoorAmbient
            Lighting.ShadowSoftness = originalLightingValues.ShadowSoftness
            Lighting.GlobalShadows = originalLightingValues.GlobalShadows
            Lighting.Technology = originalLightingValues.Technology
        end
        end)


        local NoFogToggle = false
        local OriginalFogStart = Lighting.FogStart
        local OriginalFogEnd = Lighting.FogEnd

        local rfog = Tabs.Vision:AddToggle("rfg", {Title = "Remove Fog", Default = false })

        rfog:OnChanged(function(state)
            NoFogToggle = state

            if not state then
                Lighting.ClockTime = 14
                Lighting.GlobalShadows = false
                Lighting.FogStart = OriginalFogStart
                Lighting.FogEnd = OriginalFogEnd
            end
        end)

        RunService.Heartbeat:Connect(function()
            if NoFogToggle then
                if Lighting.FogStart ~= 100000 or Lighting.FogEnd ~= 100000 then
                    Lighting.ClockTime = 14
                    Lighting.GlobalShadows = false
                    Lighting.FogStart = 100000
                    Lighting.FogEnd = 100000
                    print("[] hi 3")
                end
            end
        end)

        if not vibrantEffect then
            Lighting.ClockTime = 14
            Lighting.GlobalShadows = false
            vibrantEffect = Instance.new("ColorCorrectionEffect")
            vibrantEffect.Name = "VibrantEffect"
            vibrantEffect.Saturation = 0.5
            vibrantEffect.Contrast = 0.2
            vibrantEffect.Brightness = 0.1
            vibrantEffect.Enabled = false 
            vibrantEffect.Parent = Lighting
        end

        local vibr = Tabs.Vision:AddToggle("vclr", {Title = "Vibrant Colors", Default = false })

        vibr:OnChanged(function(state)
        if state then
            Lighting.ClockTime = 14
            Lighting.GlobalShadows = false
            Lighting.Ambient = Color3.fromRGB(180, 180, 180)
            Lighting.OutdoorAmbient = Color3.fromRGB(170, 170, 170)
            Lighting.ColorShift_Top = Color3.fromRGB(255, 230, 200)
            Lighting.ColorShift_Bottom = Color3.fromRGB(200, 240, 255)
            if effect then
                effect.Enabled = true
            end
        else
            if effect then
                effect.Enabled = false
            end
            Lighting.ClockTime = 14
            Lighting.GlobalShadows = false
            Lighting.Ambient = Color3.new(0, 0, 0)
            Lighting.OutdoorAmbient = Color3.new(0, 0, 0)
            Lighting.ColorShift_Top = Color3.new(0, 0, 0)
            Lighting.ColorShift_Bottom = Color3.new(0, 0, 0)
        end
        end)

        Tabs.Vision:AddButton({
            Title = "Remove Gameplay Paused",
            Callback = function()
                game:GetService("CoreGui").RobloxGui["CoreScripts/NetworkPause"]:Destroy()
            end
        })

        Tabs.Vision:AddButton({
            Title = "Boost Fps",
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

        Tabs.Vision:AddButton({
            Title = "Super Boost Fps",
            Callback = function()
                pcall(function()
                    loadstring(game:HttpGet("https://raw.githubusercontent.com/SuperHackerYT/skibidi/refs/heads/main/performanceboost.lua"))()
                end)
            end
        })

        UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
            if gameProcessedEvent then return end

            if input.KeyCode == Enum.KeyCode.V then
                showPlayers = not showPlayers
                playersText.Visible = showPlayers
            end
        end)

        local Section = Tabs.Codes:AddSection("Lobby", "eye")

        local cod = Tabs.Codes:AddToggle("codez", {Title = "Redeem All Codes", Default = false })

        cod:OnChanged(function(value)
        if value then
            local codes = {
                "AFTERPARTY",
                "THEWOKENRAM"
            }

            for _, code in ipairs(codes) do
                local args = { code }
                game:GetService("ReplicatedStorage")
                    :WaitForChild("RemoteEvents")
                    :WaitForChild("RequestInputCode")
                    :InvokeServer(unpack(args))
                task.wait(0.25)
            end
        end
        end)

        end


        SaveManager:SetLibrary(Fluent)
        InterfaceManager:SetLibrary(Fluent)
        SaveManager:IgnoreThemeSettings()
        SaveManager:SetIgnoreIndexes({})
        InterfaceManager:SetFolder("AikoHub")
        SaveManager:SetFolder("AikoHub/99NITF")
        InterfaceManager:BuildInterfaceSection(Tabs.Settings)
        SaveManager:BuildConfigSection(Tabs.Settings)
        Window:SelectTab(1)
        SaveManager:LoadAutoloadConfig()

