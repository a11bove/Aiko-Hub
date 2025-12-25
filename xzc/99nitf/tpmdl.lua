local TeleportModule = {}

-- Services
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local Debris = game:GetService("Debris")

-- Get LocalPlayer
local LocalPlayer = Players.LocalPlayer

-- Public state variables
TeleportModule.scan_map = false
TeleportModule.scan_map_was_on = false

-- Get Chests Function
function TeleportModule.getChests()
    local chests = {}
    local chestNames = {}
    local seenPositions = {}
    local index = 1

    for _, item in ipairs(Workspace:WaitForChild("Items"):GetChildren()) do
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

-- Get Mobs (Lost Children) Function
function TeleportModule.getMobs()
    local mobs = {}
    local mobNames = {}
    local index = 1
    
    for _, character in ipairs(Workspace:WaitForChild("Characters"):GetChildren()) do
        if character.Name:match("^Lost Child") and character:GetAttribute("Lost") == true then
            table.insert(mobs, character)
            table.insert(mobNames, character.Name)
            index = index + 1
        end
    end
    
    return mobs, mobNames
end

-- Teleport to Campfire
function TeleportModule.TeleportToCampfire()
    local hrp = (LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()):WaitForChild("HumanoidRootPart")
    hrp.CFrame = CFrame.new(0.43132782, 15.77634621, -1.88620758, -0.270917892, 0.102997094, 0.957076371, 0.639657021, 0.762253821, 0.0990355015, -0.719334781, 0.639031112, -0.272391081)
end

-- Teleport to Stronghold
function TeleportModule.TeleportToStronghold()
    local targetPart = Workspace:FindFirstChild("Map")
        and Workspace.Map:FindFirstChild("Landmarks")
        and Workspace.Map.Landmarks:FindFirstChild("Stronghold")
        and Workspace.Map.Landmarks.Stronghold:FindFirstChild("Functional")
        and Workspace.Map.Landmarks.Stronghold.Functional:FindFirstChild("EntryDoors")
        and Workspace.Map.Landmarks.Stronghold.Functional.EntryDoors:FindFirstChild("DoorRight")
        and Workspace.Map.Landmarks.Stronghold.Functional.EntryDoors.DoorRight:FindFirstChild("Model")
        
    if targetPart then
        local children = targetPart:GetChildren()
        local destination = children[5]
        if destination and destination:IsA("BasePart") then
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = destination.CFrame + Vector3.new(0, 5, 0)
            end
        end
    end
end

-- Teleport to Safe Zone
function TeleportModule.TeleportToSafeZone()
    if not Workspace:FindFirstChild("SafeZonePart") then
        local createpart = Instance.new("Part")
        createpart.Name = "SafeZonePart"
        createpart.Size = Vector3.new(30, 3, 30)
        createpart.Position = Vector3.new(0, 350, 0)
        createpart.Anchored = true
        createpart.CanCollide = true
        createpart.Transparency = 0.8
        createpart.Color = Color3.fromRGB(255, 0, 0)
        createpart.Parent = Workspace
    end
    
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hrp = character:WaitForChild("HumanoidRootPart")
    hrp.CFrame = CFrame.new(0, 360, 0)
end

-- Teleport to Trader
function TeleportModule.TeleportToTrader()
    local pos = Vector3.new(-37.08, 3.98, -16.33)
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hrp = character:WaitForChild("HumanoidRootPart")
    hrp.CFrame = CFrame.new(pos)
end

-- Teleport to Random Tree
function TeleportModule.TeleportToRandomTree()
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hrp = character:FindFirstChild("HumanoidRootPart", 3)
    if not hrp then return end

    local map = Workspace:FindFirstChild("Map")
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

-- Teleport to Chest
function TeleportModule.TeleportToChest(chest)
    if chest then
        local part = chest.PrimaryPart or chest:FindFirstChildWhichIsA("BasePart")
        if part and LocalPlayer.Character then
            local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = part.CFrame + Vector3.new(0, 5, 0)
            end
        end
    end
end

-- Teleport to Mob
function TeleportModule.TeleportToMob(mob)
    if mob then
        local part = mob.PrimaryPart or mob:FindFirstChildWhichIsA("BasePart")
        if part and LocalPlayer.Character then
            local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = part.CFrame + Vector3.new(0, 5, 0)
            end
        end
    end
end

-- Reveal Whole Map
function TeleportModule.RevealWholeMap()
    local boundaries = Workspace:FindFirstChild("Map") and Workspace.Map:FindFirstChild("Boundaries")
    if boundaries then
        for _, obj in pairs(boundaries:GetChildren()) do
            obj:Destroy()
        end
    end
end

-- Scan Map Function
local scanMapTask = nil
function TeleportModule.ToggleScanMap(state)
    TeleportModule.scan_map = state

    if not state then
        if scanMapTask then
            task.cancel(scanMapTask)
            scanMapTask = nil
        end
        if TeleportModule.scan_map_was_on then
            TeleportModule.TeleportToCampfire()
        end
        TeleportModule.scan_map_was_on = false
        return
    else
        TeleportModule.scan_map_was_on = true
    end

    scanMapTask = task.spawn(function()
        local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hrp = character:WaitForChild("HumanoidRootPart", 3)
        if not hrp then return end

        local map = Workspace:FindFirstChild("Map")
        if not map then return end

        local foliage = map:FindFirstChild("Foliage") or map:FindFirstChild("Landmarks")
        if not foliage then return end

        while TeleportModule.scan_map do
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
                if not TeleportModule.scan_map then break end
                if trunk and trunk.Parent then
                    local treeCFrame = trunk.CFrame
                    local rightVector = treeCFrame.RightVector
                    local targetPosition = treeCFrame.Position + rightVector * 69 + Vector3.new(0, 15, 69)

                    LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(targetPosition)

                    local footPart = Instance.new("Part")
                    footPart.Size = Vector3.new(10, 1, 10)
                    footPart.Anchored = true
                    footPart.CanCollide = true
                    footPart.Transparency = 1
                    footPart.BrickColor = BrickColor.new("Bright yellow")
                    footPart.CFrame = CFrame.new(targetPosition - Vector3.new(0, 3, 0))
                    footPart.Parent = Workspace

                    Debris:AddItem(footPart, 1)

                    task.wait(0.01)
                end
            end
            task.wait(0.25)
        end
    end)
end

-- Cleanup Function
function TeleportModule.Cleanup()
    TeleportModule.ToggleScanMap(false)
    
    -- Clean up safe zone part
    local safeZonePart = Workspace:FindFirstChild("SafeZonePart")
    if safeZonePart then
        safeZonePart:Destroy()
    end
end

return TeleportModule
