-- Bring Module for 99 Nights in The Forest
local BringModule = {}

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- Item Lists
BringModule.BlueprintItems = {"Crafting Blueprint", "Defense Blueprint", "Furniture Blueprint"}
BringModule.PeltsItems = {"Bunny Foot", "Wolf Pelt", "Alpha Wolf Pelt", "Bear Pelt", "Arctic Fox Pelt", "Polar Bear Pelt"}
BringModule.junkItems = {"Bolt", "Sheet Metal", "UFO Junk", "UFO Component", "Broken Fan", "Old Radio", "Broken Microwave", "Tyre", "Metal Chair", "Old Car Engine", "Washing Machine", "Cultist Experiment", "Cultist Prototype", "Meteor Shard", "Gold Shard", "UFO Scrap", "Cultist Gem", "Gem of the Forest Fragment", "Feather", "Old Boot"}
BringModule.fuelItems = {"Log", "Chair", "Coal", "Fuel Canister", "Oil Barrel"}
BringModule.foodItems = {"Cake", "Cooked Steak", "Cooked Morsel", "Ribs", "Salmon", "Cooked Salmon", "Cooked Ribs", "Mackerel", "Cooked Mackerel", "Steak", "Morsel", "Berry", "Apple", "Carrot", "Chilli", "Stew", "Hearty Stew", "Corn", "Pumpkin", "Meat? Sandwich", "Pumpkin", "Seafood Chowder", "Steak Dinner", "Pumpkin Soup", "BBQ Ribs", "Carrot Cake", "Jar of Jelly", "Mackerel", "Salmon", "Clownfish", "Swordfish", "Jellyfish", "Char", "Eel", "Shark", "Cooked Clownfish", "Cooked Swordfish", "Cooked Jellyfish", "Cooked Char", "Cooked Eel", "Cooked Shark"}
BringModule.medicalItems = {"Bandage", "MedKit"}
BringModule.cultistItems = {"Cultist", "Crossbow Cultist", "Cultist Juggernaut", "Bunny", "Wolf", "Alpha Wolf", "Bear", "Snow Bear", "Deer", "Owl", "Ram"}
BringModule.equipmentItems = {"Revolver", "Rifle", "Revolver Ammo", "Rifle Ammo", "Infernal Sack", "Giant Sack", "Good Sack", "Strong Axe", "Good Axe", "Frozen Shuriken", "Tactical Shotgun", "Crossbow", "Infernal Crossbow", "Snowball", "Kunai", "Leather Body", "Poison Armour", "Iron Body", "Thorn Body", "Obsidiron Body", "Cultist Staff", "Riot Shield", "Alien Armour", "Axe Trim Kit", "Armour Trim Kit", "Red Key", "Blue Key", "Yellow Key", "Grey Key", "Frog Key", "Chili Seeds", "Flower Seeds", "Berry Seeds", "Firefly Seeds", "Old Rod", "Good Rod", "Strong Rod"}

-- State Variables
local isCollecting = false
local originalPosition = nil

BringModule.selectedBlueprintItems = {}
BringModule.selectedPeltsItems = {}
BringModule.selectedJunkItems = {}
BringModule.selectedFuelItems = {}
BringModule.selectedFoodItems = {}
BringModule.selectedMedicalItems = {}
BringModule.selectedCultistItems = {}
BringModule.selectedEquipmentItems = {}

BringModule.BlueprintToggleEnabled = false
BringModule.PeltsToggleEnabled = false
BringModule.junkToggleEnabled = false
BringModule.fuelToggleEnabled = false
BringModule.foodToggleEnabled = false
BringModule.medicalToggleEnabled = false
BringModule.cultistToggleEnabled = false
BringModule.equipmentToggleEnabled = false

local BlueprintLoopRunning = false
local PeltsLoopRunning = false
local junkLoopRunning = false
local fuelLoopRunning = false
local foodLoopRunning = false
local medicalLoopRunning = false
local cultistLoopRunning = false
local equipmentLoopRunning = false

-- Core Bring Function
function BringModule.bypassBringSystem(items, stopFlag)
    if isCollecting then 
        return 
    end

    isCollecting = true
    local player = LocalPlayer

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

        for _, item in ipairs(Workspace:GetDescendants()) do
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

-- Alternative Bring Method (Player TP)
function BringModule.bringItemsByPlayerTP(itemNames, targetPosition)
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then 
        return 
    end

    local hrp = LocalPlayer.Character.HumanoidRootPart
    local itemsFound = {}

    for _, itemName in ipairs(itemNames) do
        for _, item in ipairs(Workspace:GetDescendants()) do
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

            hrp.CFrame = CFrame.new(targetPosition)

            task.wait(0.2)

            pcall(function()
                ReplicatedStorage:WaitForChild("RemoteEvents").StopDraggingItem:FireServer(item)
            end)

            task.wait(0.5)
        end
    end

    hrp.CFrame = CFrame.new(targetPosition)
end

-- Loop Management Functions
function BringModule.StartBringLoop(itemType, selectedItems, toggleFlag, loopFlag)
    if loopFlag then return end
    
    loopFlag = true
    spawn(function()
        while loopFlag and toggleFlag do
            if #selectedItems > 0 and toggleFlag then
                BringModule.bypassBringSystem(selectedItems, function() return toggleFlag end)
            end

            local waitTime = 0
            while waitTime < 3 and toggleFlag and loopFlag do
                wait(0.1)
                waitTime = waitTime + 0.1
            end
        end
        loopFlag = false
    end)
    
    return loopFlag
end

function BringModule.StopBringLoop()
    return false
end

-- Sapling Auto Plant with Bring
BringModule.autoPlantEnabled = false
BringModule.autoPlantLoop = false

function BringModule.ToggleSaplingBring(state)
    BringModule.autoPlantEnabled = state

    if state then
        BringModule.autoPlantLoop = true
        spawn(function()
            while BringModule.autoPlantLoop and BringModule.autoPlantEnabled do
                BringModule.bypassBringSystem({"Sapling"}, function() return BringModule.autoPlantEnabled end)

                if not BringModule.autoPlantEnabled then break end

                local args = {
                    Instance.new("Model", nil)
                }
                game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("RequestPlantItem"):InvokeServer(unpack(args))

                local waitTime = 0
                while waitTime < 3 and BringModule.autoPlantEnabled and BringModule.autoPlantLoop do
                    task.wait(0.1)
                    waitTime = waitTime + 0.1
                end
            end
            BringModule.autoPlantLoop = false
        end)
    else
        BringModule.autoPlantLoop = false
    end
end

return BringModule
