-- Simple Plant Value ESP Script - No Farm Detection
local Players = game:GetService("Players")
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- Safe module loading
local CalculatePlantValue, Comma
pcall(function()
    CalculatePlantValue = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("CalculatePlantValue"))
end)
pcall(function()
    Comma = require(ReplicatedStorage:WaitForChild("Comma_Module"))
end)

-- Fallback functions
if not CalculatePlantValue then
    CalculatePlantValue = function() return 0 end
end
if not Comma then
    Comma = { Comma = function(num) return tostring(num) end }
end

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

local function isPlayerPlant(model)
    -- Simple ownership check - only direct Owner values
    local owner = model:FindFirstChild("Owner")
    if owner and owner:IsA("StringValue") then
        return owner.Value == LocalPlayer.Name
    end
    
    -- Check in Configuration folder
    local config = model:FindFirstChild("Configuration")
    if config then
        local configOwner = config:FindFirstChild("Owner")
        if configOwner and configOwner:IsA("StringValue") then
            return configOwner.Value == LocalPlayer.Name
        end
    end
    
    -- If no owner found, assume it's the player's (you can change this to false if needed)
    return true
end

local function updateESP(model)
    local esp = ESPs[model]
    if not esp or not model:IsDescendantOf(workspace) then return end
    
    local infoLabel = esp:FindFirstChild("plantInfo")
    if infoLabel then
        local success, value = pcall(CalculatePlantValue, model)
        if success and typeof(value) == "number" then
            -- Get weight
            local weight = "N/A"
            local weightValue = model:FindFirstChild("Weight") or model:FindFirstChild("weight")
            if weightValue and weightValue:IsA("NumberValue") then
                weight = math.floor(weightValue.Value) .. "kg"
            elseif weightValue and weightValue:IsA("IntValue") then
                weight = weightValue.Value .. "kg"
            end
            
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
    
    -- Simple ownership check
    if not isPlayerPlant(model) then
        return
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
        for model, esp in pairs(ESPs) do
            if esp then
                esp:Destroy()
            end
        end
        ESPs = {}
        print("ESPs cleared")
    else
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

-- Toggle function
_G.TogglePlantESP = toggleESP
