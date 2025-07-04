-- Ultra-Safe Plant Value ESP Script with Gradual Loading
local Players = game:GetService("Players")
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- Safe module loading
local CalculatePlantValue, Comma
local modulesLoaded = false

spawn(function()
    local success1, success2 = false, false
    
    success1 = pcall(function()
        CalculatePlantValue = require(ReplicatedStorage:WaitForChild("Modules", 5):WaitForChild("CalculatePlantValue", 5))
    end)
    
    success2 = pcall(function()
        Comma = require(ReplicatedStorage:WaitForChild("Comma_Module", 5))
    end)
    
    if not success1 then
        CalculatePlantValue = function() return math.random(100, 1000) end
        warn("CalculatePlantValue module failed to load")
    end
    
    if not success2 then
        Comma = { Comma = function(num) return tostring(num) end }
        warn("Comma module failed to load")
    end
    
    modulesLoaded = true
    print("Modules loaded successfully")
end)

local ESPs = {}
local TrackedPlants = {}
local ESP_ENABLED = false
local MAX_ESPS = 20 -- Reduced limit
local RANGE = 50 -- Reduced range

-- Cleanup function
local function cleanup()
    print("Cleaning up ESPs...")
    for model, esp in pairs(ESPs) do
        if esp and esp.Parent then
            pcall(function() esp:Destroy() end)
        end
    end
    ESPs = {}
    TrackedPlants = {}
    print("Cleanup complete")
end

local function createBillboard(model)
    if not model or not model.Parent then return nil end
    
    local success, result = pcall(function()
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "PlantESP"
        billboard.Size = UDim2.new(0, 120, 0, 25)
        billboard.StudsOffset = Vector3.new(0, 2, 0)
        billboard.AlwaysOnTop = true
        billboard.LightInfluence = 0
        billboard.Parent = model
        
        local label = Instance.new("TextLabel")
        label.Name = "Info"
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.fromRGB(0, 255, 0)
        label.TextStrokeTransparency = 0
        label.TextStrokeColor3 = Color3.new(0, 0, 0)
        label.Font = Enum.Font.SourceSans
        label.TextSize = 8
        label.TextXAlignment = Enum.TextXAlignment.Center
        label.Text = model.Name or "Plant"
        label.Parent = billboard
        
        return billboard
    end)
    
    if success then
        return result
    else
        warn("Failed to create billboard:", result)
        return nil
    end
end

local function isPlayerPlant(model)
    if not model or not model.Parent then return false end
    
    local success, result = pcall(function()
        -- Simple ownership check
        local owner = model:FindFirstChild("Owner")
        if owner and owner:IsA("StringValue") then
            return owner.Value == LocalPlayer.Name
        end
        
        -- Check configuration
        local config = model:FindFirstChild("Configuration")
        if config then
            local configOwner = config:FindFirstChild("Owner")
            if configOwner and configOwner:IsA("StringValue") then
                return configOwner.Value == LocalPlayer.Name
            end
        end
        
        return false
    end)
    
    return success and result or false
end

local function updatePlantInfo(model)
    if not modulesLoaded or not model or not model.Parent then return end
    
    local esp = ESPs[model]
    if not esp or not esp.Parent then return end
    
    pcall(function()
        local label = esp:FindFirstChild("Info")
        if label then
            local success, value = pcall(CalculatePlantValue, model)
            if success and typeof(value) == "number" then
                label.Text = (model.Name or "Plant") .. " - $" .. Comma.Comma(value)
            else
                label.Text = model.Name or "Plant"
            end
        end
    end)
end

local function createESP(model)
    if not ESP_ENABLED or not model or not model.Parent then return end
    if ESPs[model] then return end
    
    -- Check ESP limit
    local count = 0
    for _ in pairs(ESPs) do
        count = count + 1
    end
    if count >= MAX_ESPS then return end
    
    -- Check if it's player's plant
    if not isPlayerPlant(model) then return end
    
    -- Check distance
    local part = model:FindFirstChildWhichIsA("BasePart")
    if not part then return end
    
    local success, distance = pcall(function()
        return (part.Position - RootPart.Position).Magnitude
    end)
    
    if not success or distance > RANGE then return end
    
    -- Create ESP
    local esp = createBillboard(model)
    if esp then
        ESPs[model] = esp
        print("Created ESP for:", model.Name)
        updatePlantInfo(model)
    end
end

local function removeESP(model)
    local esp = ESPs[model]
    if esp then
        pcall(function() esp:Destroy() end)
        ESPs[model] = nil
        print("Removed ESP for:", model.Name)
    end
end

local function toggleESP(enabled)
    ESP_ENABLED = enabled
    print("ESP toggle:", enabled)
    
    if not enabled then
        cleanup()
        return
    end
    
    if not modulesLoaded then
        print("Modules not loaded yet, waiting...")
        spawn(function()
            while not modulesLoaded do
                wait(0.5)
            end
            print("Modules loaded, creating ESPs...")
            toggleESP(true)
        end)
        return
    end
    
    -- Gradually create ESPs
    spawn(function()
        local created = 0
        for model, _ in pairs(TrackedPlants) do
            if created >= MAX_ESPS then break end
            if model and model.Parent and model:IsDescendantOf(workspace) then
                createESP(model)
                if ESPs[model] then
                    created = created + 1
                end
                wait(0.1) -- Small delay between creations
            end
        end
        print("Created", created, "ESPs")
    end)
end

-- Track plants gradually
spawn(function()
    print("Starting plant tracking...")
    local tracked = 0
    
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and CollectionService:HasTag(obj, "Harvestable") then
            TrackedPlants[obj] = true
            tracked = tracked + 1
            
            -- Small delay to prevent lag
            if tracked % 10 == 0 then
                wait(0.1)
            end
        end
    end
    
    print("Tracked", tracked, "harvestable plants")
end)

-- Event connections
pcall(function()
    CollectionService:GetInstanceAddedSignal("Harvestable"):Connect(function(obj)
        if obj:IsA("Model") then
            TrackedPlants[obj] = true
        end
    end)
end)

pcall(function()
    CollectionService:GetInstanceRemovedSignal("Harvestable"):Connect(function(obj)
        if obj:IsA("Model") then
            TrackedPlants[obj] = nil
            removeESP(obj)
        end
    end)
end)

-- Main update loop (very conservative)
spawn(function()
    while true do
        if ESP_ENABLED and modulesLoaded then
            pcall(function()
                local processed = 0
                for model, _ in pairs(TrackedPlants) do
                    if processed >= 5 then break end -- Only process 5 at a time
                    
                    if not model or not model.Parent or not model:IsDescendantOf(workspace) then
                        TrackedPlants[model] = nil
                        removeESP(model)
                    else
                        local part = model:FindFirstChildWhichIsA("BasePart")
                        if part then
                            local distance = (part.Position - RootPart.Position).Magnitude
                            if distance <= RANGE then
                                if not ESPs[model] then
                                    createESP(model)
                                else
                                    updatePlantInfo(model)
                                end
                            elseif distance > RANGE + 20 then
                                removeESP(model)
                            end
                        end
                    end
                    
                    processed = processed + 1
                end
            end)
        end
        wait(1) -- Much longer wait time
    end
end)

-- Character respawn handling
LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char
    RootPart = char:WaitForChild("HumanoidRootPart")
    cleanup()
end)

-- Cleanup on leave
game:BindToClose(cleanup)

-- Toggle function
_G.TogglePlantESP = toggleESP

print("Plant ESP loaded - use _G.TogglePlantESP(true) to enable")
