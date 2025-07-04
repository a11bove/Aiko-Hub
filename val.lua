-- Plant Value ESP Script with Toggle Support (Fixed Ownership Detection)
local Players = game:GetService("Players")
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local CalculatePlantValue = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("CalculatePlantValue"))
local Comma = require(ReplicatedStorage:WaitForChild("Comma_Module"))

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local RootPart = Character:WaitForChild("HumanoidRootPart")

local ESPs = {}
local UpdateQueue = {}
local RANGE = 70
local ESP_ENABLED = false

local function createBillboard(model)
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "esp"
    billboard.Size = UDim2.new(0, 160, 0, 30)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.LightInfluence = 0
    billboard.ResetOnSpawn = false
    billboard.Parent = model
    
    -- Single label for name | weight | price
    local infoLabel = Instance.new("TextLabel")
    infoLabel.Name = "plantInfo"
    infoLabel.Size = UDim2.new(1, 0, 1, 0)
    infoLabel.Position = UDim2.new(0, 0, 0, 0)
    infoLabel.BackgroundTransparency = 1
    infoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    infoLabel.TextStrokeTransparency = 0
    infoLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    infoLabel.Font = Enum.Font.SourceSans
    infoLabel.TextSize = 10
    infoLabel.TextXAlignment = Enum.TextXAlignment.Center
    infoLabel.Text = (model.Name or "Unknown") .. " | ... | ..."
    infoLabel.Parent = billboard
    
    return billboard
end

local function isPlantOwnedByPlayer(model)
    -- Method 1: Check direct Owner value
    local owner = model:FindFirstChild("Owner") or model:FindFirstChild("owner")
    if owner then
        if owner:IsA("StringValue") then
            return owner.Value == LocalPlayer.Name
        elseif owner:IsA("ObjectValue") then
            return owner.Value == LocalPlayer
        end
    end
    
    -- Method 2: Check Configuration folder
    local config = model:FindFirstChild("Configuration")
    if config then
        local ownerConfig = config:FindFirstChild("Owner") or config:FindFirstChild("owner")
        if ownerConfig then
            if ownerConfig:IsA("StringValue") then
                return ownerConfig.Value == LocalPlayer.Name
            elseif ownerConfig:IsA("ObjectValue") then
                return ownerConfig.Value == LocalPlayer
            end
        end
    end
    
    -- Method 3: Check if plant is in player's farm area
    local farm = nil
    local ws = workspace
    if ws:FindFirstChild("Farm") then
        for _, v in next, ws.Farm:GetDescendants() do
            if v.Name == "Owner" and v:IsA("StringValue") and v.Value == LocalPlayer.Name then
                farm = v.Parent.Parent
                break
            end
        end
    end
    
    if farm then
        -- Check if the plant is a descendant of the player's farm
        return model:IsDescendantOf(farm)
    end
    
    -- Method 4: Check parent hierarchy for ownership
    local parent = model.Parent
    while parent and parent ~= workspace do
        local parentOwner = parent:FindFirstChild("Owner") or parent:FindFirstChild("owner")
        if parentOwner then
            if parentOwner:IsA("StringValue") then
                return parentOwner.Value == LocalPlayer.Name
            elseif parentOwner:IsA("ObjectValue") then
                return parentOwner.Value == LocalPlayer
            end
        end
        parent = parent.Parent
    end
    
    -- If no ownership found, don't show ESP (safer approach)
    return false
end

local function updateESP(model)
    local esp = ESPs[model]
    if not esp or not model:IsDescendantOf(workspace) then return end
    
    local infoLabel = esp:FindFirstChild("plantInfo")
    
    if infoLabel then
        local success, value = pcall(CalculatePlantValue, model)
        if success and typeof(value) == "number" then
            -- Get weight from the model
            local weight = "N/A"
            local weightValue = model:FindFirstChild("Weight") or model:FindFirstChild("weight")
            if weightValue and weightValue:IsA("NumberValue") then
                weight = math.floor(weightValue.Value) .. "kg"
            elseif weightValue and weightValue:IsA("IntValue") then
                weight = weightValue.Value .. "kg"
            elseif model:FindFirstChild("Configuration") then
                local config = model:FindFirstChild("Configuration")
                local weightConfig = config:FindFirstChild("Weight") or config:FindFirstChild("weight")
                if weightConfig and weightConfig:IsA("NumberValue") then
                    weight = math.floor(weightConfig.Value) .. "kg"
                elseif weightConfig and weightConfig:IsA("IntValue") then
                    weight = weightConfig.Value .. "kg"
                end
            end
            
            -- Update label with name | weight | price format
            infoLabel.Text = (model.Name or "Unknown") .. " | " .. weight .. " | $" .. Comma.Comma(value)
        end
    end
end

local function trackPlant(model)
    if ESPs[model] then return end
    UpdateQueue[model] = tick() + math.random()
end

local function untrackPlant(model)
    if ESPs[model] then
        ESPs[model]:Destroy()
        ESPs[model] = nil
    end
    UpdateQueue[model] = nil
end

local function createesp(model)
    if not ESP_ENABLED then return end
    if ESPs[model] then return end
    if not model:IsDescendantOf(workspace) then return end
    
    -- Use the improved ownership check
    if not isPlantOwnedByPlayer(model) then
        return -- Don't create ESP for other players' plants
    end
    
    local part = model:FindFirstChildWhichIsA("BasePart")
    if not part then return end
    
    if (part.Position - RootPart.Position).Magnitude <= RANGE then
        local esp = createBillboard(model)
        ESPs[model] = esp
        updateESP(model)
    end
end

local function removeesp(model)
    local esp = ESPs[model]
    if esp and model:IsDescendantOf(workspace) then
        local part = model:FindFirstChildWhichIsA("BasePart")
        if part and (part.Position - RootPart.Position).Magnitude > RANGE + 10 then
            esp:Destroy()
            ESPs[model] = nil
        end
    end
end

local function toggleESP(enabled)
    ESP_ENABLED = enabled
    print("ESP toggled:", enabled)
    
    if not enabled then
        -- Remove all existing ESPs
        for model, esp in pairs(ESPs) do
            if esp then
                esp:Destroy()
            end
        end
        ESPs = {}
        print("ESPs cleared")
    else
        -- Create ESPs for plants in range
        local count = 0
        for model, _ in pairs(UpdateQueue) do
            if model:IsDescendantOf(workspace) then
                createesp(model)
                if ESPs[model] then
                    count = count + 1
                end
            end
        end
        print("ESPs created:", count)
    end
end

-- Initialize plant tracking
local plantCount = 0
for _, obj in ipairs(workspace:GetDescendants()) do
    if obj:IsA("Model") and CollectionService:HasTag(obj, "Harvestable") then
        trackPlant(obj)
        plantCount = plantCount + 1
    end
end
print("Found", plantCount, "harvestable plants")

CollectionService:GetInstanceAddedSignal("Harvestable"):Connect(function(obj)
    if obj:IsA("Model") then
        trackPlant(obj)
    end
end)

CollectionService:GetInstanceRemovedSignal("Harvestable"):Connect(function(obj)
    if obj:IsA("Model") then
        untrackPlant(obj)
    end
end)

-- Main update loop
task.spawn(function()
    while true do
        local now = tick()
        for model, _ in pairs(UpdateQueue) do
            if not model:IsDescendantOf(workspace) then
                untrackPlant(model)
            else
                if ESP_ENABLED then
                    createesp(model)
                    removeesp(model)
                    if ESPs[model] and now >= UpdateQueue[model] then
                        updateESP(model)
                        UpdateQueue[model] = now + 3 + math.random()
                    end
                end
            end
        end
        task.wait(0.3)
    end
end)

LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char
    RootPart = char:WaitForChild("HumanoidRootPart")
end)

-- Toggle function for external use
_G.TogglePlantESP = toggleESP
