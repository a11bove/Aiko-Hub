local MiscModule = {}

-- Auto Open Chests
MiscModule.AutoChestData = {running = false, originalCFrame = nil}

function MiscModule.getChests()
    local chests = {}
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and string.find(obj.Name, "Item Chest") then
            table.insert(chests, obj)
        end
    end
    return chests
end

function MiscModule.getPrompt(model)
    local prompts = {}
    for _, obj in ipairs(model:GetDescendants()) do
        if obj:IsA("ProximityPrompt") then
            table.insert(prompts, obj)
        end
    end
    return prompts
end

function MiscModule.ToggleAutoOpenChests(state)
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    if state then
        if MiscModule.AutoChestData.running then return end
        MiscModule.AutoChestData.running = true
        MiscModule.AutoChestData.originalCFrame = humanoidRootPart.CFrame
        task.spawn(function()
            while MiscModule.AutoChestData.running do
                local chests = MiscModule.getChests()
                for _, chest in ipairs(chests) do
                    if not MiscModule.AutoChestData.running then break end
                    local part = chest.PrimaryPart or chest:FindFirstChildWhichIsA("BasePart")
                    if part then
                        humanoidRootPart.CFrame = part.CFrame + Vector3.new(0, 6, 0)
                        local prompts = MiscModule.getPrompt(chest)
                        for _, prompt in ipairs(prompts) do
                            fireproximityprompt(prompt, math.huge)
                        end
                        local t = tick()
                        while MiscModule.AutoChestData.running and tick() - t < 4 do task.wait() end
                    end
                end
                task.wait(0.1)
            end
        end)
    else
        MiscModule.AutoChestData.running = false
        if MiscModule.AutoChestData.originalCFrame then
            humanoidRootPart.CFrame = MiscModule.AutoChestData.originalCFrame
        end
    end
end

-- Auto Eat
MiscModule.autoFeedToggle = false
MiscModule.selectedFood = {}
MiscModule.hungerThreshold = 75

function MiscModule.ghn()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    return math.floor(LocalPlayer.PlayerGui.Interface.StatBars.HungerBar.Bar.Size.X.Scale * 100)
end

function MiscModule.SetSelectedFood(food)
    MiscModule.selectedFood = food
end

function MiscModule.SetHungerThreshold(value)
    MiscModule.hungerThreshold = math.clamp(value, 0, 100)
end

function MiscModule.ToggleAutoEat(state)
    MiscModule.autoFeedToggle = state
    if state then
        task.spawn(function()
            local ReplicatedStorage = game:GetService("ReplicatedStorage")
            local Workspace = game:GetService("Workspace")
            
            while MiscModule.autoFeedToggle do
                task.wait(0.05)

                local currentHunger = MiscModule.ghn()
                if currentHunger <= MiscModule.hungerThreshold and #MiscModule.selectedFood > 0 then
                    while currentHunger < 100 and MiscModule.autoFeedToggle do
                        local ateSomething = false

                        for _, foodName in ipairs(MiscModule.selectedFood) do
                            for _, item in ipairs(Workspace.Items:GetChildren()) do
                                if item.Name == foodName and item.Parent then
                                    pcall(function()
                                        ReplicatedStorage.RemoteEvents.RequestConsumeItem:InvokeServer(item)
                                    end)
                                    ateSomething = true
                                    task.wait(0.05)
                                    currentHunger = MiscModule.ghn()
                                    if currentHunger >= 100 then
                                        break
                                    end
                                end
                            end
                            if currentHunger >= 100 then
                                break
                            end
                        end

                        if not ateSomething then
                            break
                        end
                    end
                end
            end
        end)
    end
end

-- Instant Interact
MiscModule.instantInteractEnabled = false
MiscModule.instantInteractConnection = nil
MiscModule.originalHoldDurations = {}

function MiscModule.ToggleInstantInteract(state)
    MiscModule.instantInteractEnabled = state

    if state then
        MiscModule.originalHoldDurations = {}
        MiscModule.instantInteractConnection = task.spawn(function()
            while MiscModule.instantInteractEnabled do
                for _, obj in ipairs(workspace:GetDescendants()) do
                    if obj:IsA("ProximityPrompt") then
                        if MiscModule.originalHoldDurations[obj] == nil then
                            MiscModule.originalHoldDurations[obj] = obj.HoldDuration
                        end
                        obj.HoldDuration = 0
                    end
                end
                task.wait(5)
            end
        end)
    else
        if MiscModule.instantInteractConnection then
            MiscModule.instantInteractEnabled = false
        end
        for obj, value in pairs(MiscModule.originalHoldDurations) do
            if obj and obj:IsA("ProximityPrompt") then
                obj.HoldDuration = value
            end
        end
        MiscModule.originalHoldDurations = {}
    end
end

-- Auto Collect Coins
function MiscModule.ToggleAutoCollectCoins(state)
    if state then
        _G.AutoCollectCoins = true
        coroutine.wrap(function()
            while _G.AutoCollectCoins do
                for _, item in pairs(workspace.Items:GetChildren()) do
                    if item.Name == "Coin Stack" and item:FindFirstChild("HumanoidRootPart") then
                        local args = {item}
                        game:GetService("ReplicatedStorage").RemoteEvents.RequestCollectCoints:InvokeServer(unpack(args))
                        warn("Collected a Coin Stack")
                    end
                end
                task.wait(0.2)
            end
        end)()
    else
        _G.AutoCollectCoins = false
    end
end

return MiscModule
