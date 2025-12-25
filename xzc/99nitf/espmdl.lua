local ESPModule = {}

-- Services
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

-- State variables
ESPModule.selectedItems = {}
ESPModule.selectedMobs = {}
ESPModule.espItemsEnabled = false
ESPModule.espMobsEnabled = false
ESPModule.espConnections = {}
ESPModule.treeAddedConnection = nil
ESPModule.EspPlayerOn = false
ESPModule.EspTextSize = 16

-- Create ESP Text Function
function ESPModule.createESPText(part, text, color)
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
    label.TextColor3 = color or Color3.fromRGB(255, 255, 0)
    label.TextStrokeTransparency = 0.2
    label.TextScaled = true
    label.Font = Enum.Font.Cartoon

    esp.Parent = part
end

-- Add ESP Function
function ESPModule.Aesp(nome, tipo)
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
                ESPModule.createESPText(part, obj.Name, color)
            end
        end
    end
end

-- Remove ESP Function
function ESPModule.Desp(nome, tipo)
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

-- Create Tree ESP Function
function ESPModule.createTreeESP(tree)
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
    textLabel.TextSize = ESPModule.EspTextSize
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

-- Enable Tree ESP Function
function ESPModule.enableTreeESP()
    local Tree = workspace.Map.Landmarks
    for _, tree in pairs(Tree:GetChildren()) do
        if tree.Name == "Small Tree" then
            ESPModule.createTreeESP(tree)
        end
    end

    ESPModule.treeAddedConnection = Tree.ChildAdded:Connect(function(tree)
        if tree.Name == "Small Tree" then
            ESPModule.createTreeESP(tree)
        end
    end)
end

-- Disable Tree ESP Function
function ESPModule.disableTreeESP()
    local Tree = workspace.Map.Landmarks
    for _, tree in pairs(Tree:GetChildren()) do
        local oldGui = tree:FindFirstChild("TreeHealth")
        if oldGui then
            oldGui:Destroy()
        end
    end

    if ESPModule.treeAddedConnection then
        ESPModule.treeAddedConnection:Disconnect()
        ESPModule.treeAddedConnection = nil
    end
end

-- Update Items ESP Function
function ESPModule.UpdateItemsESP(itemsList)
    if ESPModule.espItemsEnabled then
        for _, name in ipairs(itemsList) do
            if table.find(ESPModule.selectedItems, name) then
                ESPModule.Aesp(name, "item")
            else
                ESPModule.Desp(name, "item")
            end
        end
    else
        for _, name in ipairs(itemsList) do
            ESPModule.Desp(name, "item")
        end
    end
end

-- Update Mobs ESP Function
function ESPModule.UpdateMobsESP(mobsList)
    if ESPModule.espMobsEnabled then
        for _, name in ipairs(mobsList) do
            if table.find(ESPModule.selectedMobs, name) then
                ESPModule.Aesp(name, "mob")
            else
                ESPModule.Desp(name, "mob")
            end
        end
    else
        for _, name in ipairs(mobsList) do
            ESPModule.Desp(name, "mob")
        end
    end
end

-- Toggle Items ESP Function
function ESPModule.ToggleItemsESP(state, itemsList)
    ESPModule.espItemsEnabled = state
    for _, name in ipairs(itemsList) do
        if state and table.find(ESPModule.selectedItems, name) then
            ESPModule.Aesp(name, "item")
        else
            ESPModule.Desp(name, "item")
        end
    end

    if state then
        if not ESPModule.espConnections["Items"] then
            local container = workspace:FindFirstChild("Items")
            if container then
                ESPModule.espConnections["Items"] = container.ChildAdded:Connect(function(obj)
                    if table.find(ESPModule.selectedItems, obj.Name) then
                        local part = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart")
                        if part then
                            ESPModule.createESPText(part, obj.Name, Color3.fromRGB(0, 255, 0))
                        end
                    end
                end)
            end
        end
    else
        if ESPModule.espConnections["Items"] then
            ESPModule.espConnections["Items"]:Disconnect()
            ESPModule.espConnections["Items"] = nil
        end
    end
end

-- Toggle Mobs ESP Function
function ESPModule.ToggleMobsESP(state, mobsList)
    ESPModule.espMobsEnabled = state
    for _, name in ipairs(mobsList) do
        if state and table.find(ESPModule.selectedMobs, name) then
            ESPModule.Aesp(name, "mob")
        else
            ESPModule.Desp(name, "mob")
        end
    end

    if state then
        if not ESPModule.espConnections["Mobs"] then
            local container = workspace:FindFirstChild("Characters")
            if container then
                ESPModule.espConnections["Mobs"] = container.ChildAdded:Connect(function(obj)
                    if table.find(ESPModule.selectedMobs, obj.Name) then
                        local part = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart")
                        if part then
                            ESPModule.createESPText(part, obj.Name, Color3.fromRGB(255, 255, 0))
                        end
                    end
                end)
            end
        end
    else
        if ESPModule.espConnections["Mobs"] then
            ESPModule.espConnections["Mobs"]:Disconnect()
            ESPModule.espConnections["Mobs"] = nil
        end
    end
end

-- Cleanup Function
function ESPModule.Cleanup()
    ESPModule.disableTreeESP()
    for name, connection in pairs(ESPModule.espConnections) do
        if connection then
            connection:Disconnect()
        end
    end
    ESPModule.espConnections = {}
end

return ESPModule
