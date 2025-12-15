local AutoPlantModule = {}

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

-- Public state variables
AutoPlantModule.AutoPlantCenter = Vector3.new(-0, 1.5, -0)
AutoPlantModule.AutoSapRadius = 50
AutoPlantModule.Sapling = 150
AutoPlantModule.AutoPlantEnabled = false

-- Vector library compatibility
local vector = {
    create = function(x, y, z)
        return Vector3.new(x, y, z)
    end
}

-- Start Auto Plant Function
function AutoPlantModule.StartAutoPlant(notifyCallback)
    AutoPlantModule.AutoPlantEnabled = true
    spawn(function() 
        while AutoPlantModule.AutoPlantEnabled do
            local selectedSapling = nil
            
            -- First, search for saplings/seeds/plants
            for _, item in pairs(Workspace.Items:GetDescendants()) do
                if item:IsA("BasePart") or item:IsA("Model") then
                    if string.find(string.lower(item.Name), "sapling") or 
                       string.find(string.lower(item.Name), "seed") or
                       string.find(string.lower(item.Name), "plant") then
                        selectedSapling = item
                        break
                    end
                end
            end

            -- If no sapling found, use any item
            if not selectedSapling then
                for _, item in pairs(Workspace.Items:GetDescendants()) do
                    if item:IsA("BasePart") or item:IsA("Model") then
                        selectedSapling = item
                        break
                    end
                end
            end

            if selectedSapling then
                for i = 1, AutoPlantModule.Sapling do
                    if not AutoPlantModule.AutoPlantEnabled then break end

                    -- Calculate circular position
                    local angle = ((i - 1) / AutoPlantModule.Sapling) * 2 * math.pi
                    local circlePosition = AutoPlantModule.AutoPlantCenter + Vector3.new(
                        math.cos(angle) * AutoPlantModule.AutoSapRadius,
                        0,
                        math.sin(angle) * AutoPlantModule.AutoSapRadius
                    )

                    -- Position the sapling
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

                    -- Plant the item
                    local args = {
                        selectedSapling,
                        vector.create(circlePosition.X, circlePosition.Y, circlePosition.Z)
                    }

                    pcall(function()
                        ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("RequestPlantItem"):InvokeServer(unpack(args))
                    end)

                    wait(0.15)
                end

                wait(2)
            else
                -- No sapling found, notify user
                if notifyCallback then
                    notifyCallback("No More Sapling Found")
                end
                wait(2)
            end
        end
    end) 
end

-- Stop Auto Plant Function
function AutoPlantModule.StopAutoPlant()
    AutoPlantModule.AutoPlantEnabled = false
end

-- Set Plant Center Function
function AutoPlantModule.SetPlantCenter(position)
    AutoPlantModule.AutoPlantCenter = position
end

-- Set Plant Radius Function
function AutoPlantModule.SetPlantRadius(radius)
    AutoPlantModule.AutoSapRadius = radius
end

-- Set Sapling Count Function
function AutoPlantModule.SetSaplingCount(count)
    AutoPlantModule.Sapling = count
end

-- Check if Auto Plant is Running
function AutoPlantModule.IsRunning()
    return AutoPlantModule.AutoPlantEnabled
end

return AutoPlantModule
