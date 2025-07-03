local Players = game:GetService("Players")
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local workspace = game:GetService("Workspace")

local CalculatePlantValue = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("CalculatePlantValue"))
local Comma = require(ReplicatedStorage:WaitForChild("Comma_Module"))

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- ESP Module
local ESP = {}
ESP.ESPs = {}
ESP.UpdateQueue = {}
ESP.RANGE = 50
ESP.Enabled = false
ESP.UpdateLoop = nil
ESP.Connections = {}

local function createBillboard(model)
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "esp"
    billboard.Size = UDim2.new(0, 100, 0, 20)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.LightInfluence = 0
    billboard.ResetOnSpawn = false
    billboard.Parent = model

    local label = Instance.new("TextLabel")
    label.Name = "money"
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255, 255, 0)
    label.TextStrokeTransparency = 0.5
    label.TextStrokeColor3 = Color3.new(0, 0, 0)
    label.Font = Enum.Font.GothamBold
    label.TextScaled = true
    label.Text = "..."
    label.Parent = billboard

    return billboard
end

local function updateESP(model)
    local esp = ESP.ESPs[model]
    if not esp or not model:IsDescendantOf(workspace) then return end
    local label = esp:FindFirstChild("money")
    if label then
        local success, value = pcall(CalculatePlantValue, model)
        if success and typeof(value) == "number" then
            label.Text = Comma.Comma(value) .. "¢"
        end
    end
end

local function trackPlant(model)
    if ESP.ESPs[model] then return end
    ESP.UpdateQueue[model] = tick() + math.random()
end

local function untrackPlant(model)
    if ESP.ESPs[model] then
        ESP.ESPs[model]:Destroy()
        ESP.ESPs[model] = nil
    end
    ESP.UpdateQueue[model] = nil
end

local function createesp(model)
    if not ESP.Enabled then return end
    if ESP.ESPs[model] then return end
    if not model:IsDescendantOf(workspace) then return end
    local part = model:FindFirstChildWhichIsA("BasePart")
    if not part then return end
    if (part.Position - RootPart.Position).Magnitude <= ESP.RANGE then
        local esp = createBillboard(model)
        ESP.ESPs[model] = esp
        updateESP(model)
    end
end

local function removeesp(model)
    local esp = ESP.ESPs[model]
    if esp and model:IsDescendantOf(workspace) then
        local part = model:FindFirstChildWhichIsA("BasePart")
        if part and (part.Position - RootPart.Position).Magnitude > ESP.RANGE + 10 then
            esp:Destroy()
            ESP.ESPs[model] = nil
        end
    end
end

function ESP:Enable()
    if self.Enabled then return end
    self.Enabled = true
    
    -- Initialize ESP for existing plants
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and CollectionService:HasTag(obj, "Harvestable") then
            trackPlant(obj)
        end
    end
    
    -- Track new plants
    self.Connections[#self.Connections + 1] = CollectionService:GetInstanceAddedSignal("Harvestable"):Connect(function(obj)
        if obj:IsA("Model") then
            trackPlant(obj)
        end
    end)
    
    -- Untrack removed plants
    self.Connections[#self.Connections + 1] = CollectionService:GetInstanceRemovedSignal("Harvestable"):Connect(function(obj)
        if obj:IsA("Model") then
            untrackPlant(obj)
        end
    end)
    
    -- Handle character respawning
    self.Connections[#self.Connections + 1] = LocalPlayer.CharacterAdded:Connect(function(char)
        Character = char
        RootPart = char:WaitForChild("HumanoidRootPart")
    end)
    
    -- Main ESP update loop
    self.UpdateLoop = task.spawn(function()
        while self.Enabled do
            local now = tick()
            for model, _ in pairs(self.UpdateQueue) do
                if not model:IsDescendantOf(workspace) then
                    untrackPlant(model)
                else
                    createesp(model)
                    removeesp(model)
                    if self.ESPs[model] and now >= self.UpdateQueue[model] then
                        updateESP(model)
                        self.UpdateQueue[model] = now + 3 + math.random()
                    end
                end
            end
            task.wait(0.3)
        end
    end)
end

function ESP:Disable()
    if not self.Enabled then return end
    self.Enabled = false
    
    -- Destroy all ESPs
    for model, esp in pairs(self.ESPs) do
        if esp then
            esp:Destroy()
        end
    end
    self.ESPs = {}
    self.UpdateQueue = {}
    
    -- Disconnect all connections
    for _, connection in pairs(self.Connections) do
        connection:Disconnect()
    end
    self.Connections = {}
    
    -- Stop update loop
    if self.UpdateLoop then
        task.cancel(self.UpdateLoop)
        self.UpdateLoop = nil
    end
end

function ESP:Toggle(state)
    if state then
        self:Enable()
    else
        self:Disable()
    end
end

return ESP
