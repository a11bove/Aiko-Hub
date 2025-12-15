local AuraModule = {}

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

-- Get LocalPlayer
local LocalPlayer = Players.LocalPlayer

-- Public state variables
AuraModule.killAuraToggle = false
AuraModule.chopAuraToggle = false
AuraModule.auraRadius = 50
AuraModule.currentammount = 0

-- Tools Damage IDs
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

-- Get Any Tool With Damage ID
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

-- Equip Tool Function
local function equipTool(tool)
    if tool then
        ReplicatedStorage:WaitForChild("RemoteEvents").EquipItemHandle:FireServer("FireAllClients", tool)
    end
end

-- Unequip Tool Function
local function unequipTool(tool)
    if tool then
        ReplicatedStorage:WaitForChild("RemoteEvents").UnequipItemHandle:FireServer("FireAllClients", tool)
    end
end

-- Kill Aura Loop
local function killAuraLoop()
    while AuraModule.killAuraToggle do
        local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local tool, damageID = getAnyToolWithDamageID(false)
            if tool and damageID then
                equipTool(tool)
                for _, mob in ipairs(Workspace.Characters:GetChildren()) do
                    if mob:IsA("Model") then
                        local part = mob:FindFirstChildWhichIsA("BasePart")
                        if part and (part.Position - hrp.Position).Magnitude <= AuraModule.auraRadius then
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

-- Chop Aura Loop
local function chopAuraLoop()
    while AuraModule.chopAuraToggle do
        local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local tool, baseDamageID = getAnyToolWithDamageID(true)
            if tool and baseDamageID then
                equipTool(tool)
                AuraModule.currentammount = AuraModule.currentammount + 1
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
                    if trunk and trunk:IsA("BasePart") and (trunk.Position - hrp.Position).Magnitude <= AuraModule.auraRadius then
                        local alreadyammount = false
                        task.spawn(function()
                            while AuraModule.chopAuraToggle and tree and tree.Parent and not alreadyammount do
                                alreadyammount = true
                                AuraModule.currentammount = AuraModule.currentammount + 1
                                pcall(function()
                                    ReplicatedStorage:WaitForChild("RemoteEvents").ToolDamageObject:InvokeServer(
                                        tree,
                                        tool,
                                        tostring(AuraModule.currentammount) .. "_7367831688",
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

-- Start Kill Aura Function
function AuraModule.StartKillAura()
    AuraModule.killAuraToggle = true
    task.spawn(killAuraLoop)
end

-- Stop Kill Aura Function
function AuraModule.StopKillAura()
    AuraModule.killAuraToggle = false
    local tool, _ = getAnyToolWithDamageID(false)
    unequipTool(tool)
end

-- Start Chop Aura Function
function AuraModule.StartChopAura()
    AuraModule.chopAuraToggle = true
    task.spawn(chopAuraLoop)
end

-- Stop Chop Aura Function
function AuraModule.StopChopAura()
    AuraModule.chopAuraToggle = false
    local tool, _ = getAnyToolWithDamageID(true)
    unequipTool(tool)
end

-- Set Aura Radius Function
function AuraModule.SetAuraRadius(radius)
    AuraModule.auraRadius = math.clamp(radius, 1, 100)
end

-- Check if Kill Aura is Active
function AuraModule.IsKillAuraActive()
    return AuraModule.killAuraToggle
end

-- Check if Chop Aura is Active
function AuraModule.IsChopAuraActive()
    return AuraModule.chopAuraToggle
end

-- Stop All Auras
function AuraModule.StopAllAuras()
    AuraModule.StopKillAura()
    AuraModule.StopChopAura()
end

-- Expose tool functions for advanced usage
AuraModule.equipTool = equipTool
AuraModule.unequipTool = unequipTool
AuraModule.getAnyToolWithDamageID = getAnyToolWithDamageID

return AuraModule
