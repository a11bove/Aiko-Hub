-- Plant Value ESP Script with Toggle Support
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
local RANGE = 50 
local ESP_ENABLED = false

local function createBillboard(model)
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "esp"
    billboard.Size = UDim2.new(0, 120, 0, 40)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.LightInfluence = 0
    billboard.ResetOnSpawn = false
    billboard.Parent = model
    
    -- Plant name label
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "plantName"
    nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
    nameLabel.Position = UDim2.new(0, 0, 0, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextStrokeTransparency = 0.5
    nameLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    nameLabel.Font = Enum.Font.Cartoon
    nameLabel.TextSize = 10
    nameLabel.Text = model.Name or "Unknown Plant"
    nameLabel.Parent = billboard
    
    -- Value label
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Name = "money"
    valueLabel.Size = UDim2.new(1, 0, 0.5, 0)
    valueLabel.Position = UDim2.new(0, 0, 0.5, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    valueLabel.TextStrokeTransparency = 0.5
    valueLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    valueLabel.Font = Enum.Font.Cartoon
    valueLabel.TextSize = 10
    valueLabel.Text = "..."
    valueLabel.Parent = billboard
    
    return billboard
end

local function updateESP(model)
    local esp = ESPs[model]
    if not esp or not model:IsDescendantOf(workspace) then return end
    
    local valueLabel = esp:FindFirstChild("money")
    if valueLabel then
        local success, value = pcall(CalculatePlantValue, model)
        if success and typeof(value) == "number" then
            valueLabel.Text = Comma.Comma(value) .. "¢"
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
    
    if not enabled then
        for model, esp in pairs(ESPs) do
            if esp then
                esp:Destroy()
            end
        end
        ESPs = {}
    else
        for model, _ in pairs(UpdateQueue) do
            if model:IsDescendantOf(workspace) then
                createesp(model)
            end
        end
    end
end

for _, obj in ipairs(workspace:GetDescendants()) do
    if obj:IsA("Model") and CollectionService:HasTag(obj, "Harvestable") then
        trackPlant(obj)
    end
end

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

_G.TogglePlantESP = toggleESP
