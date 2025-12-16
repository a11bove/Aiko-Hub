if not game:IsLoaded() then
    game.Loaded:Wait()
end

local existingGui = game.CoreGui:FindFirstChild("aikoware")
if existingGui then
    existingGui:Destroy()
end

local existingHirimi = game.CoreGui:FindFirstChild("HirimiGui")
if existingHirimi then
    existingHirimi:Destroy()
end

if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- Clean up existing GUIs
local existingGui = game.CoreGui:FindFirstChild("aikoware")
if existingGui then
    existingGui:Destroy()
end

local existingHirimi = game.CoreGui:FindFirstChild("HirimiGui")
if existingHirimi then
    existingHirimi:Destroy()
end

-- Add error handling for library loading
local success, Library = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/a11bove/kdoaz/refs/heads/main/loader/src.lua"))()
end)

if not success then
    warn("Failed to load library:", Library)
    return
end

if not Library then
    warn("Library is nil after loading")
    return
end

print("Library loaded successfully:", Library)
print("Library type:", type(Library))

Library:MakeNotify({
    Title = "@aikoware",
    Description = "",
    Content = "Fish It Script Loaded!",
    Color = Color3.fromRGB(255,100,100),
    Delay = 3
})

-- Check if MakeNotify exists
if Library.MakeNotify then
    print("MakeNotify exists")
    Library:MakeNotify({
        Title = "@aikoware",
        Description = "",
        Content = "Fish It Script Loaded!",
        Color = Color3.fromRGB(255,100,100),
        Delay = 3
    })
else
    warn("MakeNotify does not exist in Library")
end

-- Check if MakeGui exists
if not Library.MakeGui then
    warn("MakeGui does not exist in Library")
    return
end

local windowSuccess, Window = pcall(function()
    return Library:MakeGui({
        NameHub = "@aikoware ",
        Description = "| made by untog !",
        Color = Color3.fromRGB(81, 40, 128),
        ["Logo Player"] = "https://www.roblox.com/headshot-thumbnail/image?userId=544503914&width=420&height=420&format=png",
        ["Name Player"] = "Protected By @aikoware"
    })
end)

if not windowSuccess then
    warn("Failed to create window:", Window)
    return
end

if not Window then
    warn("Window is nil after creation")
    return
end

print("Window created successfully:", Window)
print("Window type:", type(Window))

local gui = Instance.new("ScreenGui")
gui.Name = "aikoware"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.Parent = game.CoreGui

local button = Instance.new("ImageButton")
button.Size = UDim2.new(0, 53, 0, 53)
button.Position = UDim2.new(0, 60, 0, 60)
button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
button.BackgroundTransparency = 0.5
button.Image = "rbxassetid://140356301069419"
button.Name = "aikowaretoggle"
button.AutoButtonColor = true
button.Parent = gui

local corner = Instance.new("UICorner", button)
corner.CornerRadius = UDim.new(0, 12)

local stroke = Instance.new("UIStroke")
stroke.Thickness = 1.5
stroke.Color = Color3.fromRGB(45, 45, 45)
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
stroke.Parent = button

local gradient = Instance.new("UIGradient")
gradient.Color =
    ColorSequence.new {
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 100, 100)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 0, 0))
}
gradient.Rotation = 45
gradient.Parent = stroke

local dragging, dragInput, dragStart, startPos

button.InputBegan:Connect(
    function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                                    dragging = true
                                    dragStart = input.Position
                                    startPos = button.Position

                                    input.Changed:Connect(
                                                    function()
                                                                    if input.UserInputState == Enum.UserInputState.End then
                                                                                    dragging = false
                                                                    end
                                                    end
                                    )
                    end
    end
)

button.InputChanged:Connect(
    function(input)
                    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                                    dragInput = input
                    end
    end
)

game:GetService("UserInputService").InputChanged:Connect(
    function(input)
                    if input == dragInput and dragging then
                                    local delta = input.Position - dragStart
                                    button.Position =
                                                    UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
                    end
    end
)

button.MouseButton1Click:Connect(
    function()
                    local HirimiGui = game.CoreGui:FindFirstChild("HirimiGui")
                    if HirimiGui then
                                    local DropShadowHolder = HirimiGui:FindFirstChild("DropShadowHolder")
                                    if DropShadowHolder then
                                                    DropShadowHolder.Visible = not DropShadowHolder.Visible
                                    end
                    end
    end
)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HttpService = game:GetService("HttpService")

-- Network Remotes
local NetFolder = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net")
local ChargeFishingRod = NetFolder:WaitForChild("RF/ChargeFishingRod")
local RequestFishingMinigame = NetFolder:WaitForChild("RF/RequestFishingMinigameStarted")
local FishingCompleted = NetFolder:WaitForChild("RE/FishingCompleted")
local EquipToolFromHotbar = NetFolder:WaitForChild("RE/EquipToolFromHotbar")
local SellAllItems = NetFolder:WaitForChild("RF/SellAllItems")
local CancelFishingInputs = NetFolder:WaitForChild("RF/CancelFishingInputs")
local ActivateEnchantingAltar = NetFolder:WaitForChild("RE/ActivateEnchantingAltar")
local UpdateOxygen = NetFolder:WaitForChild("URE/UpdateOxygen")
local FishingController = require(ReplicatedStorage.Controllers.FishingController)
local Data = require(ReplicatedStorage:WaitForChild("Data"))
local TierUtility = require(ReplicatedStorage:WaitForChild("Utility"):WaitForChild("TierUtility"))
local REFavoriteItem = NetFolder:WaitForChild("RE/FavoriteItem")

-- Infinite Jump Setup
UserInputService.JumpRequest:Connect(function()
                local shouldJump = _G.InfiniteJump and (LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()):FindFirstChildOfClass("Humanoid")
                if shouldJump then
                                shouldJump:ChangeState(Enum.HumanoidStateType.Jumping)
                end
end)

LocalPlayer.CharacterAdded:Connect(function(newCharacter)
                local newHumanoid = newCharacter:WaitForChild("Humanoid")
                newHumanoid.UseJumpPower = true
                newHumanoid.JumpPower = _G.CustomJumpPower or 50
end)

local lockPositionState = {
    enabled = false,
    position = nil
}

if not Window.CreateTab then
    warn("CreateTab does not exist in Window")
    warn("Available Window methods:")
    for k, v in pairs(Window) do
        print(k, type(v))
    end
    return
end

-- Try creating tabs with error handling
local tabSuccess, main = pcall(function()
    return Window:CreateTab({
        Name = "Home",
        Icon = "rbxassetid://10723407389"
    })
end)

if not tabSuccess then
    warn("Failed to create main tab:", main)
    return
end

print("Main tab created:", main)
print("Main tab type:", type(main))

-- If main tab was created successfully, check its methods
if main then
    print("Available main tab methods:")
    for k, v in pairs(main) do
        print(k, type(v))
    end
end

-- Continue with other tabs
local fsh = Window:CreateTab({
    Name = "Fishing",
    Icon = "rbxassetid://10734966248"
})
print("Fishing tab created:", fsh)

local shp = Window:CreateTab({
    Name = "Shop",
    Icon = "rbxassetid://10734921935"
})
print("Shop tab created:", shp)

local qst = Window:CreateTab({
    Name = "Quest",
    Icon = "rbxassetid://10734965572"
})
print("Quest tab created:", qst)

local utl = Window:CreateTab({
    Name = "Utility",
    Icon = "rbxassetid://10734964600"
})
print("Utility tab created:", utl)

local tp = Window:CreateTab({
    Name = "Teleport",
    Icon = "rbxassetid://10734886004"
})
print("Teleport tab created:", tp)

local msc = Window:CreateTab({
    Name = "Misc",
    Icon = "rbxassetid://10734964600"
})
print("Misc tab created:", msc)

-- Test adding a section
if main and main.AddSection then
    print("AddSection exists on main tab")
    local testSection = main:AddSection("Test Section")
    print("Test section created:", testSection)
else
    warn("AddSection does not exist on main tab")
end

print("Script initialization complete")

local uset = main:AddSection("User Settings")

uset:AddInput({
    Title = "WalkSpeed",
    Content = "Numbers only.",
    Placeholder = "Enter numbers...",
    Callback = function(value)
                    local speed = tonumber(value)
                                    if speed and speed >= 16 then
                                                    Humanoid.WalkSpeed = speed
                                    else
                                                    Humanoid.WalkSpeed = 16
                                    end
                    end
})

uset:AddInput({
    Title = "Jumppower",
    Content = "Numbers only.",
    Placeholder = "Enter numbers...",
    Callback = function(value)
            local jumpPower = tonumber(value)
                            if jumpPower then
                                            _G.CustomJumpPower = jumpPower
                                            local char = LocalPlayer.Character
                                            local hum = char and char:FindFirstChildOfClass("Humanoid")
                                            if hum then
                                                            hum.UseJumpPower = true
                                                            hum.JumpPower = jumpPower
                                            end
                            end
            end
})

uset:AddButton({
                Title = "Reset Speed & Jump",
                Content = "Reset walkspeed and jump to default.",
                Callback = function()
                                Humanoid.WalkSpeed = 16
                                _G.CustomJumpPower = 50
                                local char = LocalPlayer.Character
                                local hum = char and char:FindFirstChildOfClass("Humanoid")
                                if hum then
                                                hum.UseJumpPower = true
                                                hum.JumpPower = 50
                                end
                end
})

uset:AddToggle({
                Title = "Inf Jump",
                Content = "Inf jump ;)",
                Default = false,
                Callback = function(enabled)
                                _G.InfiniteJump = enabled
                end
})

local infosec = main:AddSection("Info")

infosec:AddParagraph({
    Title = "Warning:",
    Content = "I made this script for testing purposes only, I am not responsible for any bans or any other consequences."
})

infosec:AddParagraph({
    Title = "Discord:",
    Content = "Join to our discord server for more updates and information."
})

infosec:AddButton({
    Title = "Copy Server Invite",
    Content = "",
    Callback = function()
                                    setclipboard("https://discord.gg/JccfFGpDNV")
                    Library:MakeNotify({
                                    Title = "@aikoware",
                                    Description = "| Discord",
                                    Content = "Link Copied!"
                    })
    end
})

local lgt = fsh:AddSection("Legit")

local AutoLegitFishEnabled = false
local LegitFishClicking = false
local LegitFishThread = nil
local OriginalGetPower = nil
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Camera = workspace.CurrentCamera
local VirtualInputManager = game:GetService("VirtualInputManager")
local LegitFishSettings = {}

local function ClickAtPosition()
                local viewportSize = Camera.ViewportSize
                local clickX = viewportSize.X * 0.95
                local clickY = viewportSize.Y * 0.95
                VirtualInputManager:SendMouseButtonEvent(clickX, clickY, 0, true, nil, 0)
                VirtualInputManager:SendMouseButtonEvent(clickX, clickY, 0, false, nil, 0)
end

local function StopLegitFish()
                LegitFishClicking = false
                if OriginalGetPower then
                                FishingController._getPower = OriginalGetPower
                end
end

local function LegitFishLoop()
                pcall(function()
                                while AutoLegitFishEnabled do
                                                if not LocalPlayer.Character then
                                                                LocalPlayer.CharacterAdded:Wait()
                                                end
                                                if not AutoLegitFishEnabled then break end

                                                if EquipToolFromHotbar then
                                                                pcall(EquipToolFromHotbar.FireServer, EquipToolFromHotbar, 1)
                                                end
                                                task.wait(0.1)

                                                if not LegitFishClicking then
                                                                ClickAtPosition()
                                                                LegitFishClicking = true
                                                end

                                                local fishingGui = PlayerGui:FindFirstChild("Fishing")
                                                fishingGui = fishingGui and fishingGui:FindFirstChild("Main")

                                                if fishingGui and fishingGui.Visible then
                                                                for _ = 1, 20 do
                                                                                if not AutoLegitFishEnabled then break end
                                                                                ClickAtPosition()
                                                                                task.wait(0.02)
                                                                end
                                                end
                                                task.wait(0.1)
                                end
                end)
                StopLegitFish()
end

local function ToggleAutoLegitFish(enabled)
    AutoLegitFishEnabled = enabled
    LegitFishSettings.AutoLegitFish = enabled

    if enabled then
        if not OriginalGetPower then
            OriginalGetPower = FishingController._getPower
        end
        function FishingController._getPower()
            return 1
        end
        LegitFishClicking = false
        if LegitFishThread then
            task.cancel(LegitFishThread)
        end
        LegitFishThread = task.spawn(LegitFishLoop)
        Library:MakeNotify({
            Title = "@aikoware",
            Description = "| Legit Fishing",
            Content = "Has Started!",
            Delay = 3
        })
    else
        StopLegitFish()
        if LegitFishThread then
            task.cancel(LegitFishThread)
            LegitFishThread = nil
        end
        Library:MakeNotify({
            Title = "@aikoware",
            Description = "| Legit Fishing",
            Content = "Has Stopped!",
            Delay = 3
        })
    end
end

lgt:AddToggle({
    Title = "Legit Fishing",
    Content = "Automatically fishes for you",
    Default = false,
    Callback = function(enabled)
        ToggleAutoLegitFish(enabled)
    end
})

local fis = fsh:AddSection("Fishing")

local InstantFishEnabled = false
local CancelDelay = 0.1
local CompleteDelay = 1

local function EquipFishingRod()
                pcall(function()
                                EquipToolFromHotbar:FireServer(1)
                end)
end

local function InstantFishCycle()
                if InstantFishEnabled then
                                pcall(function()
                                                ChargeFishingRod:InvokeServer(1756863567.217075)
                                                RequestFishingMinigame:InvokeServer(-139.63796997070312, 0.9964792798079721)
                                end)
                                task.wait(CancelDelay)

                                pcall(function()
                                                CancelFishingInputs:InvokeServer()
                                end)

                                if InstantFishEnabled then
                                                pcall(function()
                                                                ChargeFishingRod:InvokeServer(1756863567.217075)
                                                                RequestFishingMinigame:InvokeServer(-139.63796997070312, 0.9964792798079721)
                                                end)
                                                task.wait(CompleteDelay)

                                                pcall(function()
                                                                FishingCompleted:FireServer()
                                                end)
                                                task.spawn(InstantFishCycle)
                                end
                end
end

local function StartInstantFish()
                if not InstantFishEnabled then
                                InstantFishEnabled = true
                                EquipFishingRod()
                                task.wait(0.5)
                                task.spawn(InstantFishCycle)
                end
end

local function StopInstantFish()
                InstantFishEnabled = false
end

fis:AddToggle({
                Title = "Instant Fishing",
                Content = "Blatantly Auto fishing for you.",
          Default = false,
                Callback = function(enabled)
                                if enabled then
                                                StartInstantFish()
                                else
                                                StopInstantFish()
                                end
                end
})

local CompleteDelayInput = fis:AddInput({
    Title = "Custom Complete Delay",
    Content = "Enter delay in seconds.",
    Placeholder = "Enter number...",
    Callback = function(value)
                    local delay = tonumber(value)
                                    if delay and delay > 0 then
                                                    CompleteDelay = delay
                                    elseif CompleteDelayInput then
                                                    CompleteDelayInput:Set(tostring(CompleteDelay))
                                    end
                    end
})

local CancelDelayInput = fis:AddInput({
    Title = "Custom Cancel Delay",
    Content = "Enter delay in seconds",
    Placeholder = "Enter number...",
    Callback = function(value)
        local delay = tonumber(value)
        if delay and delay > 0 then
            CancelDelay = delay
        elseif CancelDelayInput then
            CancelDelayInput:Set(tostring(CancelDelay))
        end
    end
})

-- Super Instant Fishing
local SuperInstantEnabled = false
local SuperReelDelay = 2
local SuperCompleteDelay = 1.25

local function SuperInstantCycle()
    task.spawn(function()
        CancelFishingInputs:InvokeServer()
        task.wait(SuperReelDelay)
        ChargeFishingRod:InvokeServer(1756863567.217075)
        RequestFishingMinigame:InvokeServer(-139.63796997070312, 0.9964792798079721)
        task.wait(SuperCompleteDelay)
        FishingCompleted:FireServer()
    end)
end

_G.ReelSuper = 2

local function StartSuperInstant()
    if not SuperInstantEnabled then
        SuperInstantEnabled = true
        EquipFishingRod()
        task.spawn(function()
            while SuperInstantEnabled do
                local startTime = tick()
                SuperInstantCycle()
                while SuperInstantEnabled and tick() - startTime < _G.ReelSuper do
                    task.wait()
                end
            end
        end)
    end
end

local function StopSuperInstant()
    SuperInstantEnabled = false
end

fis:AddToggle({
    Title = "Super Instant Fishing",
    Content = "Setting depends on your rod.",
          Default = false,
          Callback = function(enabled)
        if enabled then
            StartSuperInstant()
        else
            StopSuperInstant()
        end
    end
})

local SuperReelDelayInput = fis:AddInput({
    Title = "Custom Delay Reel",
    Content = "Enter delay in seconds",
    Placeholder = "Enter number...",
    Callback = function(value)
        local delay = tonumber(value)
        if delay and delay > 0 then
            SuperReelDelay = delay
        elseif SuperReelDelayInput then
            SuperReelDelayInput:Set(tostring(SuperReelDelay))
        end
    end
})

local SuperCompleteDelayInput = fis:AddInput({
    Title = "Custom Complete Delay",
    Content = "Enter delay in seconds",
    Placeholder = "Enter number...",
    Callback = function(value)
        local delay = tonumber(value)
        if delay and delay > 0 then
            SuperCompleteDelay = delay
        elseif SuperCompleteDelayInput then
            SuperCompleteDelayInput:Set(tostring(SuperCompleteDelay))
        end
    end
})

local SuperInstantV2Enabled = false
local ScytheReelDelay = 1.05
local ScytheCompleteDelay = 0.16

local function SuperInstantV2Cycle()
    task.spawn(function()
        CancelFishingInputs:InvokeServer()
        task.wait(ScytheReelDelay)
        ChargeFishingRod:InvokeServer(1756863567.217075)
        RequestFishingMinigame:InvokeServer(-139.63796997070312, 0.9964792798079721)
        task.wait(ScytheCompleteDelay)
        FishingCompleted:FireServer()
    end)
end

_G.ReelSuper = 1.05

local function StartSuperInstantV2()
    if not SuperInstantV2Enabled then
        SuperInstantV2Enabled = true
        EquipFishingRod()
        task.spawn(function()
            while SuperInstantV2Enabled do
                local startTime = tick()
                SuperInstantV2Cycle()
                while SuperInstantV2Enabled and tick() - startTime < _G.ReelSuper do
                    task.wait()
                end
            end
        end)
    end
end

local function StopSuperInstantV2()
    SuperInstantV2Enabled = false
end

fis:AddToggle({
    Title = "Super Instant Fishing V2",
    Content = "For scythe rod users.",
          Default = false,
    Callback = function(enabled)
        if enabled then
            StartSuperInstantV2()
        else
            StopSuperInstantV2()
        end
    end
})

local ScytheCompleteDelayInput = fis:AddInput({
    Title = "Custom Complete Delay",
    Content = "Enter delay in seconds",
    Placeholder = "Enter number...",
    Callback = function(value)
        local delay = tonumber(value)
        if delay and delay > 0 then
            ScytheCompleteDelay = delay
        elseif ScytheCompleteDelayInput then
            ScytheCompleteDelayInput:Set(tostring(ScytheCompleteDelay))
        end
    end
})

local ScytheReelDelayInput = fis:AddInput({
    Title = "Custom Cancel Delay",
    Content = "Enter delay in seconds",
    Placeholder = "Enter number...",
    Callback = function(value)
        local delay = tonumber(value)
        if delay and delay > 0 then
            ScytheReelDelay = delay
        elseif ScytheReelDelayInput then
            ScytheReelDelayInput:Set(tostring(ScytheReelDelay))
        end
    end
})

local ench = fsh:AddSection("Enchant")

local autoEnchant = false

ench:AddToggle({
    Title = "Auto Enchant Rod",
    Content = "Automatically enchant your equipped rod",
    Default = false,
    Callback = function(Value)
        autoEnchant = Value

        task.spawn(function()
            while autoEnchant do
                local enchantPosition = Vector3.new(3231, -1303, 1402)

                local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                local hrp = character:FindFirstChild("HumanoidRootPart")

                if not hrp then
                    NotifyError("Auto Enchant Rod", "HumanoidRootPart not found.")
                    return
                end

                NotifyInfo(
                    "Preparing Enchant...",
                    "Place Enchant Stone in hotbar slot 5",
                    4
                )

                task.wait(3)

                local backpackGui = LocalPlayer.PlayerGui:FindFirstChild("Backpack")
                if not backpackGui then return end

                local display = backpackGui:FindFirstChild("Display")
                if not display then return end

                local slots = display:GetChildren()
                local slot5 = slots[5]

                if not slot5 then
                    NotifyError("Auto Enchant Rod", "Slot 5 not found.")
                    return
                end

                local itemName =
                    slot5:FindFirstChild("Inner")
                    and slot5.Inner:FindFirstChild("Tags")
                    and slot5.Inner.Tags:FindFirstChild("ItemName")

                if not (itemName and itemName.Text:lower():find("enchant")) then
                    NotifyError("Auto Enchant Rod", "Slot 5 does not contain an Enchant Stone.")
                    return
                end

                NotifyInfo("Enchanting...", "Please wait...", 6)

                local originalCFrame = hrp.CFrame

                hrp.CFrame = CFrame.new(enchantPosition + Vector3.new(0, 5, 0))
                task.wait(1)

                pcall(function()
                    EquipToolFromHotbar:FireServer(5)
                    task.wait(0.4)
                    ActivateEnchantingAltar:FireServer()
                end)

                task.wait(7)

                hrp.CFrame = originalCFrame

                -- delay before next enchant attempt
                task.wait(2)
            end
        end)
    end
})

local notf = fsh:AddSection("Notification")

local function ToggleCaughtNotifications(visible)
    local notificationGui = LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("Small Notification")
    if notificationGui then
        local display = notificationGui:FindFirstChild("Display")
        if display then
            for _, child in ipairs(display:GetChildren()) do
                if child:IsA("GuiObject") then
                    child.Visible = visible
                end
            end
        end
    end
end

notf:AddToggle({
    Title = "Caught Notification",
    Content = "Use this For Disable ur Notification caught",
    Default = true,
    Callback = function(enabled)
        ToggleCaughtNotifications(not enabled)
    end
})

local sell = shp:AddSection("Auto Sell")

sell:AddToggle({
    Title = "Enable Auto Sell",
    Content = "Automatically sell fish.",
    Default = false,
    Callback = function(enabled)
        _G.AutoSell = enabled
        task.spawn(function()
            while _G.AutoSell do
                task.wait(5)
                pcall(function()
                    SellAllItems:InvokeServer()
                end)
            end
        end)
    end
})

local sellThreshold = 30
sell:AddInput({
    Title = "Auto Sell Input Amount",
    Content = "Set the number of fish to catch before auto-selling.",
    Placeholder = "Default: 30",
    Callback = function(value)
        local threshold = tonumber(value)
        if threshold then
            sellThreshold = threshold
            Library:MakeNotify({
                Title = "@aikoware",
                Description = "| Threshold Updated",
                        Content = "Fish will be sold automatically when catch reaches " .. sellThreshold,
                Delay = 2
            })
        else
            Library:MakeNotify({
                Title = "@aikoware",
                Description = "| Invalid Input",
                Content = "Please enter a number, not text.",
                Delay = 2
            })
        end
    end
})

local dsq = qst:AddSection("Deep Sea")

local QuestSettings = {player = Players.LocalPlayer}
local DeepSeaParagraph = dsq:AddParagraph({
        Title = "Deep Sea Panel",
        Content = ""
})

dsq:AddToggle({
    Title = "Auto Deep Sea Quest",
        Content = "Automatically complete the Deep Sea Quest.",
    Default = false,
    Callback = function(enabled)
        QuestSettings.autoDeepSea = enabled
        task.spawn(function()
            while QuestSettings.autoDeepSea do
                local menuRings = workspace:FindFirstChild("!!! MENU RINGS")
                local deepSeaTracker = menuRings and menuRings:FindFirstChild("Deep Sea Tracker")

                if deepSeaTracker then
                    local content = deepSeaTracker:FindFirstChild("Board") and deepSeaTracker.Board:FindFirstChild("Gui") and deepSeaTracker.Board.Gui:FindFirstChild("Content")

                    if content then
                        local progressLabel
                        for _, child in ipairs(content:GetChildren()) do
                            if child:IsA("TextLabel") and child.Name ~= "Header" then
                                progressLabel = child
                                break
                            end
                        end

                        if progressLabel then
                            local progressText = string.lower(progressLabel.Text)
                            local hrp = QuestSettings.player.Character and QuestSettings.player.Character:FindFirstChild("HumanoidRootPart")

                            if hrp then
                                if string.find(progressText, "100%%") then
                                    hrp.CFrame = CFrame.new(-3763, -135, -995) * CFrame.Angles(0, math.rad(180), 0)
                                else
                                    hrp.CFrame = CFrame.new(-3599, -276, -1641)
                                end
                            end
                        end
                    end
                end
                task.wait(1)
            end
        end)
    end
})

local ele = qst:AddSection("Element")

local ElementParagraph = ele:AddParagraph({
    Title = "Element Panel",
    Content = ""
})

ele:AddToggle({
    Title = "Auto Element Quest",
    Content = "Automatically complete the Element Quest.",
    Default = false,
    Callback = function(enabled)
        QuestSettings.autoElement = enabled
        task.spawn(function()
            local questCompleted = false
            while QuestSettings.autoElement and not questCompleted do
                local menuRings = workspace:FindFirstChild("!!! MENU RINGS")
                local elementTracker = menuRings and menuRings:FindFirstChild("Element Tracker")

                if elementTracker then
                    local content = elementTracker:FindFirstChild("Board") and elementTracker.Board:FindFirstChild("Gui") and elementTracker.Board.Gui:FindFirstChild("Content")

                    if content then
                        local progressTexts = {}
                        for _, child in ipairs(content:GetChildren()) do
                            if child:IsA("TextLabel") and child.Name ~= "Header" then
                                table.insert(progressTexts, string.lower(child.Text))
                            end
                        end

                        local hrp = QuestSettings.player.Character and QuestSettings.player.Character:FindFirstChild("HumanoidRootPart")

                        if hrp and #progressTexts >= 4 then
                            local firstProgress = progressTexts[2]
                            local secondProgress = progressTexts[4]

                            if string.find(secondProgress, "100%%") then
                                if string.find(secondProgress, "100%%") and not string.find(firstProgress, "100%%") then
                                    hrp.CFrame = CFrame.new(1453, -22, -636)
                                elseif string.find(firstProgress, "100%%") then
                                    hrp.CFrame = CFrame.new(1480, 128, -593)
                                    questCompleted = true
                                    QuestSettings.autoElement = false
                                    if ElementParagraph and ElementParagraph.Set then
                                        ElementParagraph:Set({
                                            Title = "Element Panel",
                                            Content = "Element Quest Completed!"
                                        })
                                    end
                                end
                            else
                                hrp.CFrame = CFrame.new(1484, 3, -336) * CFrame.Angles(0, math.rad(180), 0)
                            end
                        end
                    end
                end
                task.wait(2)
            end
        end)
    end
})

-- Update quest progress displays
local function GetQuestProgress(trackerName)
    local menuRings = workspace["!!! MENU RINGS"]:FindFirstChild(trackerName)
    if not menuRings then return "" end

    local content = menuRings:FindFirstChild("Board") and menuRings.Board:FindFirstChild("Gui") and menuRings.Board.Gui:FindFirstChild("Content")
    if not content then return "" end

    local progressLines = {}
    local lineNumber = 1
    for _, child in ipairs(content:GetChildren()) do
        if child:IsA("TextLabel") and child.Name ~= "Header" then
            table.insert(progressLines, lineNumber .. ". " .. child.Text)
            lineNumber = lineNumber + 1
        end
    end
    return table.concat(progressLines, "\n")
end

task.spawn(function()
    while task.wait(2) do
        ElementParagraph:Set({
            Title = "Element Panel",
            Content = GetQuestProgress("Element Tracker")
        })
        DeepSeaParagraph:Set({
            Title = "Deep Sea Panel",
            Content = GetQuestProgress("Deep Sea Tracker")
        })
    end
end)

local arti = qst:AddSection("Artifact")

local ArtifactLocations = {
    ["Hourglass Diamond Artifact"] = {
        Koordinat = Vector3.new(1478.0726, 5.7806, -847.1714),
        ArahHadap = Vector3.new(-0.1844, 0, 0.9828)
    },
    ["Diamond Artifact"] = {
        Koordinat = Vector3.new(1837.9366, 4.3452, -306.2985),
        ArahHadap = Vector3.new(0.8314, 0, -0.5556)
    },
    ["Arrow Artifact"] = {
        Koordinat = Vector3.new(877.6763, 3.0565, -333.3725),
        ArahHadap = Vector3.new(-0.9714, 0, 0.2372)
    },
    ["Crescent Artifact"] = {
        Koordinat = Vector3.new(1402.8289, 3.3359, 122.6733),
        ArahHadap = Vector3.new(-0.2753, 0, 0.9613)
    }
}

local ArtifactIds = {
    ["Arrow Artifact"] = 265,
    ["Crescent Artifact"] = 266,
    ["Diamond Artifact"] = 267,
    ["Hourglass Diamond Artifact"] = 271
}

local AutoFarmArtifactEnabled = false
local ArtifactFishing = false
local ArtifactFishThread = nil
local ArtifactOriginalPower = nil
local ArtifactEquipRemote = nil

local function ClickForArtifact()
    local viewportSize = workspace.CurrentCamera.ViewportSize
    local clickX = viewportSize.X * 0.95
    local clickY = viewportSize.Y * 0.95
    VirtualInputManager:SendMouseButtonEvent(clickX, clickY, 0, true, nil, 0)
    VirtualInputManager:SendMouseButtonEvent(clickX, clickY, 0, false, nil, 0)
end

local function StopArtifactFishing()
    ArtifactFishing = false
    if ArtifactOriginalPower then
        FishingController._getPower = ArtifactOriginalPower
        ArtifactOriginalPower = nil
    end
end

local function ArtifactFishingLoop()
    pcall(function()
        while AutoFarmArtifactEnabled do
            if not LocalPlayer.Character then
                LocalPlayer.CharacterAdded:Wait()
            end
            if not AutoFarmArtifactEnabled then break end

            if ArtifactEquipRemote then
                pcall(ArtifactEquipRemote.FireServer, ArtifactEquipRemote, 1)
            end
            task.wait(0.1)

            if not ArtifactFishing then
                ClickForArtifact()
                ArtifactFishing = true
            end

            local fishingGui = PlayerGui:FindFirstChild("Fishing")
            fishingGui = fishingGui and fishingGui:FindFirstChild("Main")

            if fishingGui and fishingGui.Visible then
                for _ = 1, 20 do
                    if not AutoFarmArtifactEnabled then break end
                    ClickForArtifact()
                    task.wait(0.02)
                end
            end
            task.wait(0.1)
        end
    end)
    StopArtifactFishing()
end

local function ToggleArtifactFishing(enabled)
    AutoFarmArtifactEnabled = enabled
    if enabled then
        if not ArtifactOriginalPower then
            ArtifactOriginalPower = FishingController._getPower
        end
        function FishingController._getPower()
            return 1
        end
        ArtifactFishing = false
        if ArtifactFishThread then
            task.cancel(ArtifactFishThread)
        end
        ArtifactFishThread = task.spawn(ArtifactFishingLoop)
    else
        StopArtifactFishing()
        if ArtifactFishThread then
            task.cancel(ArtifactFishThread)
            ArtifactFishThread = nil
        end
    end
end

local function GetPlayerData()
    local Replion = require(ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Replion"))
    local dataReplion = Replion.Client:WaitReplion("Data", LocalPlayer)
    if not dataReplion then
        return {}, {}
    end

    local templeLeverData = dataReplion:Get("TempleLevers") or {}
    local inventoryItems = dataReplion:Get({"Inventory", "Items"}) or {}

    local ownedArtifacts = {}
    for _, item in ipairs(inventoryItems) do
        for artifactName, artifactId in pairs(ArtifactIds) do
            if item.Id == artifactId then
                ownedArtifacts[artifactName] = true
            end
        end
    end

    return templeLeverData, ownedArtifacts
end

local function GetArtifactProgressText()
    local leverData, _ = GetPlayerData()
    local progressLines = {}

    for artifactName, _ in pairs(ArtifactIds) do
        table.insert(progressLines, (leverData[artifactName] and "✅ Lever Placed: " or "❌ Not Placed: ") .. artifactName)
    end

    local progressText = table.concat(progressLines, "\n")

    local allPlaced = true
    for artifactName, _ in pairs(ArtifactIds) do
        if not leverData[artifactName] then
            allPlaced = false
            break
        end
    end

    if allPlaced then
        progressText = progressText .. "\n\n✅ All levers have been placed!"
    end
    return progressText
end

local ArtifactProgressParagraph = arti:AddParagraph({
    Title = "Temple Artifact Progress",
    Content = GetArtifactProgressText()
})

local function GetPlayerHRP()
    return (LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()):WaitForChild("HumanoidRootPart")
end

local function TeleportToArtifact(artifactName)
    local hrp = GetPlayerHRP()
    local location = ArtifactLocations[artifactName]
    if hrp and location then
        local position = location.Koordinat
        local lookDirection = location.ArahHadap
        hrp.CFrame = CFrame.new(position, position + lookDirection)
    end
end

local AutoFarmArtifactsRunning = false

local function AutoFarmArtifactsCycle()
    if not AutoFarmArtifactsRunning then return end

    local leverData, ownedArtifacts = GetPlayerData()
    local remotesFolder = ReplicatedStorage:FindFirstChild("Remotes")

    for artifactName, _ in pairs(ArtifactIds) do
        if not leverData[artifactName] then
            if not ownedArtifacts[artifactName] then
                TeleportToArtifact(artifactName)
                ToggleArtifactFishing(true)

                while true do
                    task.wait(0.5)
                    local fishingGui = PlayerGui:FindFirstChild("Fishing")
                    fishingGui = fishingGui and fishingGui:FindFirstChild("Main")
                    if not (fishingGui and fishingGui.Visible and AutoFarmArtifactsRunning) then
                        ToggleArtifactFishing(false)
                        break
                    end
                end
            end

            local placeLeverRemote = remotesFolder and remotesFolder:FindFirstChild("RE_PlaceLeverItem")
            if placeLeverRemote then
                placeLeverRemote:FireServer(artifactName)
            end
            task.wait(1)
        end
    end

    ArtifactProgressParagraph:Set({
        Title = "Temple Artifact Progress",
        Content = GetArtifactProgressText()
    })
    task.wait(5)
end

local ArtifactOverlay = Instance.new("ScreenGui")
ArtifactOverlay.Name = "ArtifactOverlay"
ArtifactOverlay.ResetOnSpawn = false
ArtifactOverlay.IgnoreGuiInset = true
ArtifactOverlay.Parent = PlayerGui
ArtifactOverlay.Enabled = false

local OverlayBackground = Instance.new("Frame")
OverlayBackground.Size = UDim2.new(1, 0, 1, 0)
OverlayBackground.BackgroundColor3 = Color3.new(0, 0, 0)
OverlayBackground.BackgroundTransparency = 0.6
OverlayBackground.Parent = ArtifactOverlay

local OverlayContent = Instance.new("Frame")
OverlayContent.AnchorPoint = Vector2.new(0.5, 0.5)
OverlayContent.Position = UDim2.new(0.5, 0, 0.5, 0)
OverlayContent.Size = UDim2.new(0, 400, 0, 320)
OverlayContent.BackgroundTransparency = 1
OverlayContent.Parent = ArtifactOverlay

local OverlayIcon = Instance.new("ImageLabel")
OverlayIcon.Size = UDim2.new(0, 120, 0, 120)
OverlayIcon.Position = UDim2.new(0.5, 0, 0, 0)
OverlayIcon.AnchorPoint = Vector2.new(0.5, 0)
OverlayIcon.BackgroundTransparency = 1
OverlayIcon.Image = "rbxassetid://99464676738903"
OverlayIcon.Parent = OverlayContent

local OverlayTitle = Instance.new("TextLabel")
OverlayTitle.Size = UDim2.new(1, 0, 0, 35)
OverlayTitle.Position = UDim2.new(0.5, 0, 0, 120)
OverlayTitle.AnchorPoint = Vector2.new(0.5, 0)
OverlayTitle.BackgroundTransparency = 1
OverlayTitle.Text = "@aikoware"
OverlayTitle.Font = Enum.Font.GothamBold
OverlayTitle.TextSize = 30
OverlayTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
OverlayTitle.TextStrokeTransparency = 0.3
OverlayTitle.Parent = OverlayContent

local OverlayMessage = Instance.new("TextLabel")
OverlayMessage.Size = UDim2.new(0.9, 0, 0, 60)
OverlayMessage.Position = UDim2.new(0.5, 0, 0, 160)
OverlayMessage.AnchorPoint = Vector2.new(0.5, 0)
OverlayMessage.BackgroundTransparency = 1
OverlayMessage.Text = "Do not interrupt!"
OverlayMessage.Font = Enum.Font.Gotham
OverlayMessage.TextSize = 18
OverlayMessage.TextWrapped = true
OverlayMessage.TextColor3 = Color3.fromRGB(255, 255, 255)
OverlayMessage.TextStrokeTransparency = 0.5
OverlayMessage.Parent = OverlayContent

local OverlayLink = Instance.new("TextLabel")
OverlayLink.Size = UDim2.new(1, 0, 0, 25)
OverlayLink.Position = UDim2.new(0.5, 0, 0, 220)
OverlayLink.AnchorPoint = Vector2.new(0.5, 0)
OverlayLink.BackgroundTransparency = 1
OverlayLink.Text = "https://discord.gg/JccfFGpDNV"
OverlayLink.Font = Enum.Font.GothamSemibold
OverlayLink.TextSize = 16
OverlayLink.TextColor3 = Color3.fromRGB(220, 170, 255)
OverlayLink.TextStrokeTransparency = 0.6
OverlayLink.Parent = OverlayContent

local function UpdateOverlay(visible, title, message, link, iconId)
    ArtifactOverlay.Enabled = visible
    if title then OverlayTitle.Text = title end
    if message then OverlayMessage.Text = message end
    if link then OverlayLink.Text = link end
    if iconId then OverlayIcon.Image = "rbxassetid://" .. tostring(iconId) end
end

arti:AddToggle({
    Title = "Auto Farm Artifact",
    Content = "Automatically farm artifacts and place levers.",
    Default = false,
    Callback = function(enabled)
        AutoFarmArtifactsRunning = enabled
        if enabled then
            UpdateOverlay(true)
            task.spawn(AutoFarmArtifactsCycle)
        else
            ToggleArtifactFishing(false)
            UpdateOverlay(false)
        end
    end
})

local loc = tp:AddSection("Location")

local function floatPlat(enabled)
    local character = LocalPlayer.Character
    if not character then return end
    
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    if enabled then
        -- Create invisible platform beneath player
        if not EventTeleportSettings.platform then
            local platform = Instance.new("Part")
            platform.Size = Vector3.new(10, 1, 10)
            platform.Transparency = 1
            platform.Anchored = true
            platform.CanCollide = true
            platform.Parent = workspace
            EventTeleportSettings.platform = platform
        end
        
        local platform = EventTeleportSettings.platform
        platform.CFrame = hrp.CFrame - Vector3.new(0, 3, 0)
        hrp.Anchored = true
    else
        if EventTeleportSettings.platform then
            EventTeleportSettings.platform:Destroy()
            EventTeleportSettings.platform = nil
        end
        
        if hrp then
            hrp.Anchored = false
        end
    end
end

loc:AddDropdown({
    Title = "Select Location",
    Content = "Select a location to teleport.",
    Multi = false,
    Options = {"Esoteric Island", "Kohana", "Kohana Volcano", "Kohana 1", "Kohana 2",
        "Coral Refs", "Enchant Room", "Tropical Grove", "Weather Machine", "Spawn",
        "Coral Refs 1", "Coral Reefs 2", "Coral Reefs 3", "Volcano", "Sisyphus Statue",
        "Treasure Room", "Crater Island Top", "Crater Island Ground", "Lost Shore",
        "Stingray Shores", "Ice Sea", "Tropical Grove Cave 1",
        "Tropical Grove Cave 2", "Tropical Grove Highground", "Fisherman Island Underground",
        "Fisherman Island Mid", "Fisherman Island Left", "Fisherman Island Right",
        "Jungle", "Temple Guardian", "Underground Cellar", "Sacred Temple"},
    Default = {},
    Callback = function(selected)
        -- Handle both single selection (string) and multi-selection (table)
        local locationName = type(selected) == "table" and selected[1] or selected
        
        if not locationName or locationName == "" then return end
        
        local TeleportLocations = {
            ["Esoteric Island"] = Vector3.new(1990, 5, 1398),
            ["Kohana"] = Vector3.new(-603, 3, 719),
            ["Coral Refs"] = Vector3.new(-2855, 47, 1996),
            ["Enchant Room"] = Vector3.new(3221, -1303, 1406),
            ["Spawn"] = Vector3.new(33, 9, 2810),
            ["Volcano"] = Vector3.new(-632, 55, 197),
            ["Treasure Room"] = Vector3.new(-3602.01, -266.57, -1577.18),
            ["Sisyphus Statue"] = Vector3.new(-3703.69, -135.57, -1017.17),
            ["Crater Island Top"] = Vector3.new(1011.29, 22.68, 5076.27),
            ["Crater Island Ground"] = Vector3.new(1079.57, 3.64, 5080.35),
            ["Coral Reefs 1"] = Vector3.new(-3031.88, 2.52, 2276.36),
            ["Coral Reefs 2"] = Vector3.new(-3270.86, 2.5, 2228.1),
            ["Coral Reefs 3"] = Vector3.new(-3136.1, 2.61, 2126.11),
            ["Lost Shore"] = Vector3.new(-3737.97, 5.43, -854.68),
            ["Weather Machine"] = Vector3.new(-1524.88, 2.87, 1915.56),
            ["Kohana Volcano"] = Vector3.new(-561.81, 21.24, 156.72),
            ["Kohana 1"] = Vector3.new(-367.77, 6.75, 521.91),
            ["Kohana 2"] = Vector3.new(-623.96, 19.25, 419.36),
            ["Stingray Shores"] = Vector3.new(44.41, 28.83, 3048.93),
            ["Tropical Grove"] = Vector3.new(-2018.91, 9.04, 3750.59),
            ["Ice Sea"] = Vector3.new(2164, 7, 3269),
            ["Tropical Grove Cave 1"] = Vector3.new(-2151, 3, 3671),
            ["Tropical Grove Cave 2"] = Vector3.new(-2018, 5, 3756),
            ["Tropical Grove Highground"] = Vector3.new(-2139, 53, 3624),
            ["Fisherman Island Underground"] = Vector3.new(-62, 3, 2846),
            ["Fisherman Island Mid"] = Vector3.new(33, 3, 2764),
            ["Fisherman Island Left"] = Vector3.new(-26, 10, 2686),
            ["Fisherman Island Right"] = Vector3.new(95, 10, 2684),
            ["Jungle"] = Vector3.new(1491.21667, 6.35540199, -848.057617),
            ["Temple Guardian"] = Vector3.new(1481.58691, 127.624985, -596.321777),
            ["Underground Cellar"] = Vector3.new(2113.85693, -91.1985855, -699.206787),
            ["Sacred Temple"] = Vector3.new(1478.45508, -21.8498955, -630.773315)
        }
        
        local targetPosition = TeleportLocations[locationName]
        if targetPosition and LocalPlayer.Character then
            local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = CFrame.new(targetPosition)
            end
        end
    end
})

local event = tp:AddSection("Event")

local EventTeleportSettings = {
    enabled = false,
    selectedEvent = nil,
    originalPosition = nil,
    platform = nil,
    isAtEvent = false
}

event:AddDropdown({
    Title = "Select Event",
    Content = "Select an event to teleport to.",
    Options = {"Megalodon Hunt", "Admin Event", "Ghost Worm", "Worm Hunt", "Shark Hunt", "Ghost Shark Hunt", "Shocked", "Black Hole", "Meteor Rain"},
    Multi = true,
    Callback = function(selected)
        EventTeleportSettings.selectedEvent = selected
    end
})

local FloatPlayer

event:AddToggle({
    Title = "Auto Teleport Spawned Event",
    Content = "Automatically teleports to selected event.",
    Default = false,
    Callback = function(enabled)
        EventTeleportSettings.enabled = enabled
        if not enabled and EventTeleportSettings.isAtEvent and EventTeleportSettings.originalPosition then
            if LocalPlayer and LocalPlayer.Character and LocalPlayer.Character.PrimaryPart then
                local hrp = LocalPlayer.Character.PrimaryPart
                if hrp.Anchored then
                    hrp.Anchored = false
                    task.wait(0.1)
                end
                hrp.CFrame = EventTeleportSettings.originalPosition
                if lockPositionState.enabled then
                    lockPositionState.position = hrp.CFrame
                end
            end
            EventTeleportSettings.isAtEvent = false
        end
    end
})

local function FindEventInWorkspace(eventName)
    local menuRings = workspace:FindFirstChild("!!! MENU RINGS")
    if not menuRings then return nil end
    
    local eventNameLower = eventName:lower()
    for _, child in ipairs(menuRings:GetChildren()) do
        if child.Name == "Props" then
            for _, prop in ipairs(child:GetChildren()) do
                if prop.Name:lower() == eventNameLower then
                    if prop:IsA("Model") then
                        local primaryPart = prop.PrimaryPart or prop:FindFirstChildWhichIsA("BasePart")
                        if primaryPart then return primaryPart end
                    elseif prop:IsA("BasePart") then
                        return prop
                    end
                end
                
                for _, descendant in ipairs(prop:GetDescendants()) do
                    if descendant:IsA("TextLabel") and descendant.Text:lower() == eventNameLower then
                        local parent = descendant
                        while parent and parent ~= child do
                            if parent:IsA("BasePart") then return parent end
                            parent = parent.Parent
                        end
                    end
                end
            end
        end
    end
    return nil
end

task.spawn(function()
    while task.wait(5) do
        local shouldBreak = false
        
        if EventTeleportSettings.enabled and EventTeleportSettings.selectedEvent and LocalPlayer.Character and LocalPlayer.Character.PrimaryPart then
            local characterHRP = workspace.Characters:FindFirstChild(LocalPlayer.Name)
            characterHRP = characterHRP and characterHRP:FindFirstChild("HumanoidRootPart")
            
            if characterHRP then
                local foundEvent = nil
                for _, eventName in ipairs(EventTeleportSettings.selectedEvent) do
                    local eventPart = FindEventInWorkspace(eventName)
                    if eventPart then
                        shouldBreak = true
                        foundEvent = eventPart
                        break
                    end
                end
                
                if foundEvent and not EventTeleportSettings.isAtEvent then
                    EventTeleportSettings.isAtEvent = true
                    EventTeleportSettings.originalPosition = characterHRP.CFrame
                    floatPlat(true)
                    characterHRP.Velocity = Vector3.zero
                    characterHRP.CFrame = foundEvent.CFrame * CFrame.new(20, 30, 0)
                    if lockPositionState.enabled then
                        lockPositionState.position = characterHRP.CFrame
                    end
                elseif not foundEvent and EventTeleportSettings.isAtEvent then
                    floatPlat(false)
                    if EventTeleportSettings.originalPosition then
                        characterHRP.CFrame = EventTeleportSettings.originalPosition
                        if lockPositionState.enabled then
                            lockPositionState.position = characterHRP.CFrame
                        end
                    end
                    EventTeleportSettings.isAtEvent = false
                end
            end
        end
        
        if shouldBreak then break end
    end
end)

local util = utl:AddSection("Utilities")

local AutoFavoriteEnabled = false
local FavoriteTier = "Legendary"
local FavoriteTiers = {
    ["Artifact Items"] = {Ids = {265, 266, 267, 271}},
    ["Legendary"] = {TierName = "Legendary"},
    ["Mythic"] = {TierName = "Mythic"},
    ["Secret"] = {TierName = "SECRET"}
}

local function AutoFavoriteItems(tierSelection)
    local inventoryData = Data:Get("Inventory")
    if inventoryData and inventoryData.Items then
        for _, item in pairs(inventoryData.Items) do
            local itemId = item.Id
            if itemId then
                if tierSelection == "Artifact Items" then
                    for _, artifactId in ipairs(FavoriteTiers["Artifact Items"].Ids) do
                        if item.Id == artifactId and item.UUID and not item.Favorited then
                            REFavoriteItem:FireServer(item.UUID)
                        end
                    end
                elseif itemId.Data.Type == "Fishes" and itemId.Probability then
                    local tier = TierUtility.GetTierFromRarity(nil, itemId.Probability.Chance)
                    if tier and tier.Name == FavoriteTiers[tierSelection].TierName and item.UUID and not item.Favorited then
                        REFavoriteItem:FireServer(item.UUID)
                    end
                end
            end
        end
    end
end

util:AddDropdown({
    Title = "Favorite Tier",
    Content = "Select which item type or rarity you want to auto-favorite.",
    Options = {"Artifact Items", "Legendary", "Mythic", "Secret"},
    Default = "Legendary",
    Multi = false,
    Callback = function(selected)
        FavoriteTier = selected
        Library:MakeNotify({
            Title = "@aikoware",
            Description = "| Favorite Tier",
            Content = "Now set to favorite: " .. FavoriteTier,
            Delay = 2
        })
    end
})

util:AddToggle({
    Title = "Auto Favorite",
    Content = "Automatically favorites selected tier.",
    Default = false,
    Callback = function(enabled)
        AutoFavoriteEnabled = enabled
        if enabled then
            task.spawn(function()
                while AutoFavoriteEnabled do
                    AutoFavoriteItems(FavoriteTier)
                    task.wait(10)
                end
            end)
        end
    end
})

-- Oxygen Bypass
local OxygenBypassEnabled = false
local OxygenBypassThread = nil

local function StartOxygenBypass()
    if not OxygenBypassThread then
        OxygenBypassEnabled = true
        OxygenBypassThread = coroutine.create(function()
            while OxygenBypassEnabled do
                UpdateOxygen:FireServer(-9999)
                wait(0.5)
            end
        end)
        coroutine.resume(OxygenBypassThread)
    end
end

local function StopOxygenBypass()
    OxygenBypassEnabled = false
    OxygenBypassThread = nil
end

util:AddToggle({
    Title = "Oxygen Bypass",
    Content = "Similar to god mode obviously.",
    Default = false,
    Callback = function(enabled)
        if enabled then
            StartOxygenBypass()
        else
            StopOxygenBypass()
        end
    end
})

-- Freeze Character
local originalCFrame
local freezeConnection

util:AddToggle({
    Title = "Freeze Character",
    Content = "A help for instant fishing.",
    Default = false,
    Callback = function(enabled)
            _G.FreezeCharacter = enabled
        if enabled then
            local character = Players.LocalPlayer.Character
            local hrp = character and character:FindFirstChild("HumanoidRootPart")
            if hrp then
                originalCFrame = hrp.CFrame
                freezeConnection = RunService.Heartbeat:Connect(function()
                    if _G.FreezeCharacter and hrp then
                        hrp.CFrame = originalCFrame
                    end
                end)
            end
        elseif freezeConnection then
            freezeConnection:Disconnect()
            freezeConnection = nil
        end
        end
})

local misc = msc:AddSection("Misc")

local overhead = (Players.LocalPlayer.Character or Players.LocalPlayer.CharacterAdded:Wait()):WaitForChild("HumanoidRootPart"):WaitForChild("Overhead")
local NameLabel = overhead.Content.Header
local LevelLabel = overhead.LevelContainer.Label
local OriginalName = NameLabel.Text
local OriginalLevel = LevelLabel.Text
local CustomName = OriginalName
local CustomLevel = OriginalLevel
local HideIdentifierEnabled = false

misc:AddInput({
    Title = "Hide Name",
    Placeholder = "@aikoware",
    Content = "",
    Callback = function(value)
        CustomName = value
        if HideIdentifierEnabled then
            NameLabel.Text = CustomName
        end
    end
})

misc:AddInput({
    Title = "Hide Level",
    Placeholder = "@aikoware",
    Content = "",
    Callback = function(value)
        CustomLevel = value
        if HideIdentifierEnabled then
            LevelLabel.Text = CustomLevel
        end
    end
})

misc:AddToggle({
    Title = "Start Hide Identifier",
    Content = "Hides your name and level.",
    Default = false,
    Callback = function(enabled)
        HideIdentifierEnabled = enabled
        if enabled then
            NameLabel.Text = CustomName
            LevelLabel.Text = CustomLevel
        else
            NameLabel.Text = OriginalName
            LevelLabel.Text = OriginalLevel
            NameLabel.TextColor3 = Color3.new(1, 1, 1)
            LevelLabel.TextColor3 = Color3.new(1, 1, 1)
        end
    end
})

-- Rainbow text effect
coroutine.wrap(function()
    local hue = 0
    while true do
        if HideIdentifierEnabled then
            hue = (hue + 0.01) % 1
            local rainbowColor = Color3.fromHSV(hue, 1, 1)
            NameLabel.TextColor3 = rainbowColor
            LevelLabel.TextColor3 = rainbowColor
        else
            NameLabel.TextColor3 = Color3.new(1, 1, 1)
            LevelLabel.TextColor3 = Color3.new(1, 1, 1)
        end
        wait(0.05)
    end
end)()

local other = msc:AddSection("Other")

other:AddToggle({
    Title = "Anti Afk",
    Content = "Prevent Roblox from kicking you when idle for 20 mins.",
    Default = false,
    Callback = function(enabled)
        _G.AntiAFK = enabled
        local VirtualUser = game:GetService("VirtualUser")
        task.spawn(function()
            while _G.AntiAFK do
                task.wait(60)
                pcall(function()
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton2(Vector2.new())
                end)
            end
        end)
    end
})

other:AddToggle({
    Title = "Auto Reconnect",
    Content = "Automatically reconnects if you got disconnected.",
    Default = false,
    Callback = function(enabled)
        _G.AutoReconnect = enabled
        if enabled then
            task.spawn(function()
                while _G.AutoReconnect do
                    task.wait(2)
                    local promptGui = game:GetService("CoreGui"):FindFirstChild("RobloxPromptGui")
                    local promptOverlay = promptGui and promptGui:FindFirstChild("promptOverlay")
                    if promptOverlay then
                        local reconnectButton = promptOverlay:FindFirstChild("ButtonPrimary")
                        if reconnectButton and reconnectButton.Visible then
                            firesignal(reconnectButton.MouseButton1Click)
                        end
                    end
                end
            end)
        end
    end
})
