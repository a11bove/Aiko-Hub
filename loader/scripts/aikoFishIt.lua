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

local LucideIcons = loadstring(game:HttpGet("https://raw.githubusercontent.com/a11bove/kdoaz/refs/heads/main/src/icons.lua"))()

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/a11bove/kdoaz/refs/heads/main/src/source.lua"))()

Library:MakeNotify({
    Title = "@aikoware",
    Description = "| Script Loaded",
    Content = "Game: Fish It",
    Color = Color3.fromRGB(255,100,100),
    Delay = 3
})

local Window = Library:MakeGui({
    NameHub = "@aikoware | made by untog!"
})

local gui = Instance.new("ScreenGui")
gui.Name = "aikoware"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.Parent = game.CoreGui

local button = Instance.new("ImageButton")
button.Size = UDim2.new(0, 47, 0, 47)
button.Position = UDim2.new(0, 60, 0, 60)
button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
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

--[[local function syncButtonVisibility()
    local HirimiGui = game.CoreGui:FindFirstChild("HirimiGui")
    if HirimiGui then
        local DropShadowHolder = HirimiGui:FindFirstChild("DropShadowHolder")
        if DropShadowHolder then
            button.Visible = not DropShadowHolder.Visible
        end
    end
end

button.MouseButton1Click:Connect(
    function()
        local HirimiGui = game.CoreGui:FindFirstChild("HirimiGui")
        if HirimiGui then
            local DropShadowHolder = HirimiGui:FindFirstChild("DropShadowHolder")
            if DropShadowHolder then
                DropShadowHolder.Visible = not DropShadowHolder.Visible
                syncButtonVisibility()
            end
        end
    end
)

--[[task.spawn(function()
    while task.wait(0.1) do
        local HirimiGui = game.CoreGui:FindFirstChild("HirimiGui")
        if HirimiGui then
            local DropShadowHolder = HirimiGui:FindFirstChild("DropShadowHolder")
            if DropShadowHolder then
                if not DropShadowHolder.Visible and not button.Visible then
                    button.Visible = true
                end
            end
        end
    end
end)]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")
local VirtualInputManager = game:GetService("VirtualInputManager")

local NetFolder = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net")

local NetIndex = ReplicatedStorage.Packages._Index and ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"]
if NetIndex then
    NetIndex = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net
end

local ChargeFishingRod = NetFolder:WaitForChild("RF/ChargeFishingRod")
local RequestFishingMinigame = NetFolder:WaitForChild("RF/RequestFishingMinigameStarted")
local FishingCompleted = NetFolder:WaitForChild("RE/FishingCompleted")
local EquipToolFromHotbar = NetFolder:WaitForChild("RE/EquipToolFromHotbar")
local SellAllItems = NetFolder:WaitForChild("RF/SellAllItems")
local CancelFishingInputs = NetFolder:WaitForChild("RF/CancelFishingInputs")
local ActivateEnchantingAltar = NetFolder:WaitForChild("RE/ActivateEnchantingAltar")
local UpdateOxygen = NetFolder:WaitForChild("URE/UpdateOxygen")
local FishingController = require(ReplicatedStorage.Controllers.FishingController)
local REFavoriteItem = NetFolder:WaitForChild("RE/FavoriteItem")

UserInputService.JumpRequest:Connect(function()
    local shouldJump = _G.InfiniteJump and (LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()):FindFirstChildOfClass("Humanoid")
    if shouldJump then
        shouldJump:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

local Replion = require(ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Replion"))
local Data = Replion.Client:WaitReplion("Data", LocalPlayer)

local lockPositionState = {
    enabled = false,
    position = nil
}

local TierUtility = {
    GetTierFromRarity = function(_, chance)
        if chance then
            if chance >= 0.0001 and chance < 0.001 then
                return {Name = "SECRET"}
            elseif chance >= 0.001 and chance < 0.01 then
                return {Name = "Mythic"}
            elseif chance >= 0.01 and chance < 0.1 then
                return {Name = "Legendary"}
            end
        end
        return nil
    end
}

local playerAddedConnection
local characterConnections = {}

local Home = Window:CreateTab({
    Name = "Home",
    Icon = "home"
})

local Fishing = Window:CreateTab({
    Name = "Fishing",
    Icon = "fish"
})

local Shop = Window:CreateTab({
    Name = "Shop",
    Icon = "piggy-bank"
})

local Favo = Window:CreateTab({
    Name = "Auto Favorite",
    Icon = "heart"
})

local Teleport = Window:CreateTab({
    Name = "Teleport",
    Icon = "map-pin"
})

local Trade = Window:CreateTab({
    Name = "Trade",
    Icon = "repeat"
})

local Misc = Window:CreateTab({
    Name = "Misc",
    Icon = "snowflake"
})

local dcsec = Home:AddSection("Support")

dcsec:AddButton({
    Title = "Copy Server Invite",
    Content = "Join our discord for more info.",
    Callback = function()
        setclipboard("https://discord.gg/JccfFGpDNV")
            Library:MakeNotify({
                    Title = "@aikoware",
                    Description = "| Discord",
                    Content = "Link Copied!",
                    Delay = 3
            })
        end
})

local srv = Home:AddSection("Server")

srv:AddToggle({
    Title = "Anti Afk",
    Content = "Anti kick when idle for 20 mins.",
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

srv:AddToggle({
    Title = "Auto Reconnect",
    Content = "",
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

local fsh = Fishing:AddSection("Legit")

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
                    task.wait(0.1)
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
        print("Auto Legit Fishing: Started")
    else
        StopLegitFish()
        if LegitFishThread then
            task.cancel(LegitFishThread)
            LegitFishThread = nil
        end
    end
end

fsh:AddToggle({
    Title = "Auto Legit Fish",
    Content = "Auto tap fast.",
    Default = false,
    Callback = ToggleAutoLegitFish
})

local fin = Fishing:AddSection("Instant")

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

fin:AddToggle({
    Title = "Auto Instant Fishing",
    Content = "Settings depends on your rod.",
    Default = false,
    Callback = function(enabled)
        if enabled then
            StartInstantFish()
        else
            StopInstantFish()
        end
    end
})

local CompleteDelayInput = fin:AddInput({
    Title = "Custom Complete Delay",
    Content = "Enter delay in seconds",
    Placeholder = "1",
    Callback = function(value)
        local delay = tonumber(value)
        if delay and delay > 0 then
            CompleteDelay = delay
        elseif CompleteDelayInput then
            CompleteDelayInput:Set(tostring(CompleteDelay))
        end
    end
})

local SuperCompleteDelayInput = fin:AddInput({
    Title = "Custom Cancel Delay",
    Content = "Enter delay in seconds",
    Placeholder = "0.1",
    Callback = function(value)
        local delay = tonumber(value)
        if delay and delay > 0 then
            CancelDelay = delay
        elseif CancelDelayInput then
            CancelDelayInput:Set(tostring(CancelDelay))
        end
    end
})

local bts = Fishing:AddSection("Blatant [5x]")

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

bts:AddToggle({
    Title = "Blatant [5x]",
    Content = "",
    Default = false,
    Callback = function(enabled)
        if enabled then
            StartSuperInstantV2()
        else
            StopSuperInstantV2()
        end
    end
})

local ScytheCompleteDelayInput = bts:AddInput({
    Title = "Custom Complete Delay",
    Content = "Enter delay in seconds",
    Placeholder = "0.16",
    Callback = function(value)
        local delay = tonumber(value)
        if delay and delay > 0 then
            ScytheCompleteDelay = delay
        elseif ScytheCompleteDelayInput then
            ScytheCompleteDelayInput:Set(tostring(ScytheCompleteDelay))
        end
    end
})

local ScytheReelDelayInput = bts:AddInput({
    Title = "Custom Cancel Delay",
    Content = "Enter delay in seconds",
    Placeholder = "1.05",
    Callback = function(value)
        local delay = tonumber(value)
        if delay and delay > 0 then
            ScytheReelDelay = delay
        elseif ScytheReelDelayInput then
            ScytheReelDelayInput:Set(tostring(ScytheReelDelay))
        end
    end
})

local SuperInstantEnabled = false
local SuperReelDelay = 2
local SuperCompleteDelay = 2

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

local bt1 = Fishing:AddSection("Blatant [BETA]")

bt1:AddToggle({
    Title = "Blatant",
    Content = "Settings depends on your rod.",
    Default = false,
    Callback = function(enabled)
        if enabled then
            StartSuperInstant()
        else
            StopSuperInstant()
        end
    end
})

local SuperReelDelayInput = bt1:AddInput({
    Title = "Custom Delay Reel",
    Content = "Enter delay in seconds",
    Placeholder = "2",
    Callback = function(value)
        local delay = tonumber(value)
        if delay and delay > 0 then
            SuperReelDelay = delay
        elseif SuperReelDelayInput then
            SuperReelDelayInput:Set(tostring(SuperReelDelay))
        end
    end
})

local SuperCompleteDelayInput = bt1:AddInput({
    Title = "Custom Complete Delay",
    Content = "Enter delay in seconds",
    Placeholder = "2",
    Callback = function(value)
        local delay = tonumber(value)
        if delay and delay > 0 then
            SuperCompleteDelay = delay
        elseif SuperCompleteDelayInput then
            SuperCompleteDelayInput:Set(tostring(SuperCompleteDelay))
        end
    end
})

local ench = Fishing:AddSection("Enchant")

ench:AddToggle({
    Title = "Auto Enchant Rod",
    Content = "Automatically enchants your equipped rod.",
    Default = false,
    Callback = function()
        local enchantPosition = Vector3.new(3231, -1303, 1402)
        local character = workspace:WaitForChild("Characters"):FindFirstChild(LocalPlayer.Name)
        local hrp = character and character:FindFirstChild("HumanoidRootPart")

        if hrp then
            task.wait(3)

            local slot5 = LocalPlayer.PlayerGui.Backpack.Display:GetChildren()[10]
            local itemName = slot5 and slot5:FindFirstChild("Inner") and slot5.Inner:FindFirstChild("Tags") and slot5.Inner.Tags:FindFirstChild("ItemName")

            if itemName and itemName.Text:lower():find("enchant") then
                local originalPosition = hrp.Position
                task.wait(1)
                hrp.CFrame = CFrame.new(enchantPosition + Vector3.new(0, 5, 0))
                task.wait(1.2)

                pcall(function()
                    EquipToolFromHotbar:FireServer(5)
                    task.wait(0.5)
                    ActivateEnchantingAltar:FireServer()
                    task.wait(7)
                end)

                task.wait(0.9)
                hrp.CFrame = CFrame.new(originalPosition + Vector3.new(0, 3, 0))
            end
        end
    end
})

local ntf = Fishing:AddSection("Fish Notification")

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

ntf:AddToggle({
    Title = "Disable Fish Notification",
    Content = "",
    Default = false,
    Callback = function(enabled)
        ToggleCaughtNotifications(not enabled)
    end
})

local rds = Shop:AddSection("Rod Shop")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RFPurchaseFishingRod = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RF/PurchaseFishingRod"]
local RFPurchaseBait = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RF/PurchaseBait"]
local RFPurchaseWeatherEvent = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RF/PurchaseWeatherEvent"]
local RFPurchaseBoat = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RF/PurchaseBoat"]

local rods = {
    ["Luck Rod"] = 79,
    ["Carbon Rod"] = 76,
    ["Grass Rod"] = 85,
    ["Demascus Rod"] = 77,
    ["Ice Rod"] = 78,
    ["Lucky Rod"] = 4,
    ["Midnight Rod"] = 80,
    ["Steampunk Rod"] = 6,
    ["Chrome Rod"] = 7,
    ["Astral Rod"] = 5,
    ["Ares Rod"] = 126,
    ["Angler Rod"] = 168
}

local rodNames = {
    "Luck Rod (350 Coins)", "Carbon Rod (900 Coins)", "Grass Rod (1.5k Coins)", "Demascus Rod (3k Coins)",
    "Ice Rod (5k Coins)", "Lucky Rod (15k Coins)", "Midnight Rod (50k Coins)", "Steampunk Rod (215k Coins)",
    "Chrome Rod (437k Coins)", "Astral Rod (1M Coins)", "Ares Rod (3M Coins)", "Angler Rod ($8M Coins)"
}

local rodKeyMap = {
    ["Luck Rod (350 Coins)"]="Luck Rod",
    ["Carbon Rod (900 Coins)"]="Carbon Rod",
    ["Grass Rod (1.5k Coins)"]="Grass Rod",
    ["Demascus Rod (3k Coins)"]="Demascus Rod",
    ["Ice Rod (5k Coins)"]="Ice Rod",
    ["Lucky Rod (15k Coins)"]="Lucky Rod",
    ["Midnight Rod (50k Coins)"]="Midnight Rod",
    ["Steampunk Rod (215k Coins)"]="Steampunk Rod",
    ["Chrome Rod (437k Coins)"]="Chrome Rod",
    ["Astral Rod (1M Coins)"]="Astral Rod",
    ["Ares Rod (3M Coins)"]="Ares Rod",
    ["Angler Rod (8M Coins)"]="Angler Rod"
}

local selectedRod = rodNames[1]

rds:AddDropdown({
    Title = "Select Rod",
    Content = "",
    Options = rodNames,
    Multi = false,
    Default = selectedRod,
    Callback = function(value)
        selectedRod = value
    end
})

rds:AddButton({
    Title = "Buy Rod",
    Content = "",
    Callback = function()
        local key = rodKeyMap[selectedRod]
        if key and rods[key] then
            local success, err = pcall(function()
                RFPurchaseFishingRod:InvokeServer(rods[key])
            end)
            if success then
                Library:MakeNotify({Title = "@aikoware",Description="| Rod Purchase", Content="Purchased "..selectedRod, Delay=3})
            else
                Library:MakeNotify({Title = "@aikoware",Description="| Rod Purchase Error", Content=tostring(err), Delay=5})
            end
        end
    end
})

local bs = Shop:AddSection("Bait Shop")

local baits = {
    ["TopWater Bait"] = 10,
    ["Lucky Bait"] = 2,
    ["Midnight Bait"] = 3,
    ["Chroma Bait"] = 6,
    ["Dark Mater Bait"] = 8,
    ["Corrupt Bait"] = 15,
    ["Aether Bait"] = 16
}

local baitNames = {
    "TopWater Bait (100 Coins)",
    "Lucky Bait (1k Coins)",
    "Midnight Bait (3k Coins)",
    "Chroma Bait (290k Coins)",
    "Dark Mater Bait (630k Coins)",
    "Corrupt Bait (1.15M Coins)",
    "Aether Bait (3.7M Coins)"
}

local baitKeyMap = {
    ["TopWater Bait (100 Coins)"] = "TopWater Bait",
    ["Lucky Bait (1k Coins)"] = "Lucky Bait",
    ["Midnight Bait (3k Coins)"] = "Midnight Bait",
    ["Chroma Bait (290k Coins)"] = "Chroma Bait",
    ["Dark Mater Bait (630k Coins)"] = "Dark Mater Bait",
    ["Corrupt Bait (1.15M Coins)"] = "Corrupt Bait",
    ["Aether Bait (3.7M Coins)"] = "Aether Bait"
}

local selectedBait = baitNames[1]

bs:AddDropdown({
    Title = "Select Bait",
    Content = "",
    Options = baitNames,
    Default = selectedBait,
    Multi = false,
    Callback = function(value)
        selectedBait = value
    end
})

bs:AddButton({
    Title = "Buy Bait",
    Content = "",
    Callback = function()
        local key = baitKeyMap[selectedBait]
        if key and baits[key] then
            local amount = baits[key]
            local success, err = pcall(function()
                RFPurchaseBait:InvokeServer(amount)
            end)
            if success then
                Library:MakeNotify({
                    Title = "@aikoware",
                    Description = "| Bait Purchase",
                    Content = "Purchased "..selectedBait.." x"..amount,
                    Delay = 3
                })
            else
                Library:MakeNotify({
                    Title = "@aikoware",
                    Description = "| Bait Purchase Error",
                    Content = tostring(err),
                    Delay = 5
                })
            end
        end
    end
})

local ws = Shop:AddSection("Weather Shop")

local weathers = {
    ["Wind"] = 10000,
    ["Snow"] = 15000,
    ["Cloudy"] = 20000,
    ["Storm"] = 35000,
    ["Radiant"] = 50000,
    ["Shark Hunt"] = 300000
}

local weatherNames = {
    "Wind (10k Coins)", "Snow (15k Coins)", "Cloudy (20k Coins)", "Storm (35k Coins)",
    "Radiant (50k Coins)", "Shark Hunt (300k Coins)"
}

local weatherKeyMap = {
    ["Wind (10k Coins)"] = "Wind",
    ["Snow (15k Coins)"] = "Snow",
    ["Cloudy (20k Coins)"] = "Cloudy",
    ["Storm (35k Coins)"] = "Storm",
    ["Radiant (50k Coins)"] = "Radiant",
    ["Shark Hunt (300k Coins)"] = "Shark Hunt"
}

local selectedWeathers = {}

ws:AddDropdown({
    Title = "Select Weather(s)",
    Content = "",
    Options = weatherNames,
    Default = {},
    Multi = true,
    Callback = function(values)
        selectedWeathers = values
    end
})

local autoBuyEnabled = false
local buyDelay = 0.

local function startAutoBuy()
    task.spawn(function()
        while autoBuyEnabled do
            for _, displayName in ipairs(selectedWeathers) do
                local key = weatherKeyMap[displayName]
                if key and weathers[key] then
                    local success, err = pcall(function()
                        RFPurchaseWeatherEvent:InvokeServer(key)
                    end)
                    if success then
                        Library:MakeNotify({
                            Title = "@aikoware",
                            Description="| Auto Buy",
                            Content="Purchased "..displayName,
                            Delay=1
                        })
                    else
                        warn("Error buying weather:", err)
                    end
                    task.wait(buyDelay)
                end
            end
            task.wait(0.1)
        end
    end)
end

local autobuyweather = ws:AddToggle({
    Title = "Auto Buy Weather",
    Content = "Automatically purchase selected weather(s).",
    Default = false,
    Callback = function(state)
        autoBuyEnabled = state
        if state then
            Library:MakeNotify({
                Title = "@aikoware",
                Description = "| Auto Buy",
                Content = "Enabled",
                Delay = 2
            })
            startAutoBuy()
        else
            Library:MakeNotify({
                Title = "@aikoware",
                Description = "| Auto Buy",
                Content = "Disabled",
                Delay = 2
            })
        end
    end
})

local bos = Shop:AddSection("Boat Shop")

local boatOrder = {
    "Small Boat",
    "Kayak",
    "Jetski",
    "Highfield",
    "Speed Boat",
    "Fishing Boat",
    "Mini Yacht",
    "Hyper Boat",
    "Frozen Boat",
    "Cruiser Boat"
}

local boats = {
    ["Small Boat"] = {Id = 1, Price = 300},
    ["Kayak"] = {Id = 2, Price = 1100},
    ["Jetski"] = {Id = 3, Price = 7500},
    ["Highfield"] = {Id = 4, Price = 25000},
    ["Speed Boat"] = {Id = 5, Price = 70000},
    ["Fishing Boat"] = {Id = 6, Price = 180000},
    ["Mini Yacht"] = {Id = 14, Price = 1200000},
    ["Hyper Boat"] = {Id = 7, Price = 999000},
    ["Frozen Boat"] = {Id = 11, Price = 0},
    ["Cruiser Boat"] = {Id = 13, Price = 0}
}

local boatNames = {}
for _, name in ipairs(boatOrder) do
    local data = boats[name]
    local priceStr
    if data.Price >= 1000000 then
        priceStr = string.format("%.2fM Coins", data.Price/1000000)
    elseif data.Price >= 1000 then
        priceStr = string.format("%.0fk Coins", data.Price/1000)
    else
        priceStr = data.Price.." Coins"
    end
    table.insert(boatNames, name.." ("..priceStr..")")
end

local boatKeyMap = {}
for _, displayName in ipairs(boatNames) do
    local nameOnly = displayName:match("^(.-) %(")
    boatKeyMap[displayName] = nameOnly
end

local selectedBoat = boatNames[1]

bos:AddDropdown({
    Title = "Select Boat",
    Content = "",
    Options = boatNames,
    Default = selectedBoat,
    Multi = false,
    Callback = function(value)
        selectedBoat = value
    end
})

bos:AddButton({
    Title = "Buy Boat",
    Content = "",
    Callback = function()
        local key = boatKeyMap[selectedBoat]
        if key and boats[key] then
            local success, err = pcall(function()
                RFPurchaseBoat:InvokeServer(boats[key].Id)
            end)
            if success then
                Library:MakeNotify({
                    Title = "@aikoware",
                    Description = "| Boat Purchase",
                    Content = "Purchased "..selectedBoat,
                    Delay = 3
                })
            else
                Library:MakeNotify({
                    Title = "@aikoware",
                    Description = "| Boat Purchase Error",
                    Content = tostring(err),
                    Delay = 5
                })
            end
        end
    end
})

local sell = Shop:AddSection("Sell")

sell:AddToggle({
    Title = "Auto Sell",
    Content = "",
    Default = false,
    Callback = function(enabled)
        _G.AutoSell = enabled
        if enabled then
            task.spawn(function()
                while _G.AutoSell do
                    task.wait(5)
                    local success, err = pcall(function()
                        SellAllItems:InvokeServer()
                    end)
                    if not success then
                        warn("Auto Sell Error:", err)
                    end
                end
            end)
        end
    end
})

local sellThreshold = 4500
sell:AddInput({
    Title = "Auto Sell Threshold",
    Content = "Fish count in backpack.",
    Placeholder = "4500",
    Callback = function(value)
        local threshold = tonumber(value)
        if threshold then
            sellThreshold = threshold
            Library:MakeNotify({
                Title = "@aikoware",
                Description = "| Threshold Updated",
                Content = "Fish will be sold automatically when catch reaches " .. sellThreshold,
                Delay = 1
            })
        else
            Library:MakeNotify({
                Title = "@aikoware",
                Description = "| Invalid Input",
                Content = "Please enter a number, not text.",
                Delay = 1
            })
        end
    end
})

sell:AddButton({
    Title = "Sell All Fish",
    Content = "Instanly sells non-favorite fish.",
    Callback = function()
        local RFSellAllItems = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RF/SellAllItems"]

        pcall(function()
            RFSellAllItems:InvokeServer()
        end)

        Library:MakeNotify({
            Title = "@aikoware",
            Description = "| Auto Sell",
            Content = "All items sold!",
            Delay = 3
        })
    end
})

local fav = Favo:AddSection("Auto Favorite")

local REFavoriteItem = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RE/FavoriteItem"]

local AutoFavoriteEnabled = false
local FavoriteTier = "Legendary"
local FavoriteTiers = {
    ["Artifact Items"] = {Ids = {265, 266, 267, 271}},
    ["Epic"] = {TierName = "Epic"},
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

fav:AddDropdown({
    Title = "Favorite Tier",
    Content = "Select which item type or rarity you want to auto-favorite.",
    Options = {"Artifact Items", "Epic", "Legendary", "Mythic", "Secret"},
    Default = {},
    Multi = true,
    Callback = function(selected)
        FavoriteTier = selected
    end
})

fav:AddToggle({
    Title = "Auto Favorite",
    Content = "Automatically favorites selected tier in your inventory.",
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

local TeleportData = loadstring(game:HttpGet("https://raw.githubusercontent.com/a11bove/kdoaz/refs/heads/main/xzc/fishit/tpmdl.lua"))()

local loc = Teleport:AddSection("Location")

local locationNames = {}
for name, _ in pairs(TeleportData.Locations) do
    table.insert(locationNames, name)
end
table.sort(locationNames)

local selectedLocation = nil

local locationDropdown = loc:AddDropdown({
    Title = "Select Location",
    Content = "",
    Multi = false,
    Options = locationNames,
    Default = {},
    Callback = function(value)
        if type(value) == "table" and #value > 0 then
            selectedLocation = value[1]
        elseif type(value) == "string" then
            selectedLocation = value
        else
            selectedLocation = nil
        end
    end
})

loc:AddButton({
    Title = "Teleport to Location",
    Content = "",
    Callback = function()
        if selectedLocation and TeleportData.Locations[selectedLocation] then
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(TeleportData.Locations[selectedLocation])
                Library:MakeNotify({
                    Title = "@aikoware",
                    Description = "| Teleported",
                    Content = "Teleported to " .. selectedLocation,
                    Delay = 3
                })
            end
        else
            Library:MakeNotify({
                Title = "@aikoware",
                Description = "| Error",
                Content = "No location selected",
                Delay = 3
            })
        end
    end
})

local npcl = Teleport:AddSection("NPC Location")

local npcNames = {}
for name, _ in pairs(TeleportData.NPCs) do
    table.insert(npcNames, name)
end
table.sort(npcNames)

local selectedNPC = nil

local npcDropdown = npcl:AddDropdown({
    Title = "Select NPC",
    Content = "",
    Options = npcNames,
    Default = {},
    Multi = false,
    Callback = function(value)
        if type(value) == "table" and #value > 0 then
            selectedNPC = value[1]
        elseif type(value) == "string" then
            selectedNPC = value
        else
            selectedNPC = nil
        end
    end
})

npcl:AddButton({
    Title = "Teleport to NPC",
    Content = "",
    Callback = function()
        if selectedNPC and TeleportData.NPCs[selectedNPC] then
            local targetCFrame = TeleportData.NPCs[selectedNPC]
            local character = LocalPlayer.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                character:PivotTo(targetCFrame)
                Library:MakeNotify({
                    Title = "@aikoware",
                    Description = "| Teleported",
                    Content = "Teleported to " .. selectedNPC,
                    Delay = 3
                })
            end
        else
            Library:MakeNotify({
                Title = "@aikoware",
                Description = "| Error",
                Content = "No NPC selected",
                Delay = 3
            })
        end
    end
})

local mach = Teleport:AddSection("Machines")

local machineNames = {}
for name, _ in pairs(TeleportData.Machines) do
    table.insert(machineNames, name)
end
table.sort(machineNames)

local selectedMachine = nil

local machineDropdown = mach:AddDropdown({
    Title = "Select Machine",
    Content = "",
    Options = machineNames,
    Default = {},
    Multi = false,
    Callback = function(value)
        if type(value) == "table" and #value > 0 then
            selectedMachine = value[1]
        elseif type(value) == "string" then
            selectedMachine = value
        else
            selectedMachine = nil
        end
    end
})

mach:AddButton({
    Title = "Teleport to Machine",
    Content = "",
    Callback = function()
        if selectedMachine and TeleportData.Machines[selectedMachine] then
            local targetCFrame = TeleportData.Machines[selectedMachine]
            local character = LocalPlayer.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                character:PivotTo(targetCFrame)
                Library:MakeNotify({
                    Title = "@aikoware",
                    Description = "| Teleported",
                    Content = "Teleported to " .. selectedMachine,
                    Delay = 3
                })
            end
        else
            Library:MakeNotify({
                Title = "@aikoware",
                Description = "| Error",
                Content = "No machine selected",
                Delay = 3
            })
        end
    end
})

local ply = Teleport:AddSection("Player")

local selectedPlayer = nil

local playerDropdown = ply:AddDropdown({
    Title = "Select Player",
    Content = "",
    Options = TeleportData.GetPlayerNames(Players, LocalPlayer),
    Default = {},
    Multi = false,
    Callback = function(value)
        if type(value) == "table" and #value > 0 then
            selectedPlayer = value[1]
        elseif type(value) == "string" then
            selectedPlayer = value
        else
            selectedPlayer = nil
        end
    end
})

ply:AddButton({
    Title = "Teleport To Player",
    Content = "",
    Callback = function()
        if selectedPlayer then
            local targetPlayer = Players:FindFirstChild(selectedPlayer)
            local myChar = LocalPlayer.Character
            local hrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
            local targetChar = targetPlayer and targetPlayer.Character
            local targetHRP = targetChar and targetChar:FindFirstChild("HumanoidRootPart")

            if hrp and targetHRP then
                hrp.CFrame = targetHRP.CFrame + Vector3.new(0,5,0)
                Library:MakeNotify({
                    Title = "@aikoware",
                    Description = "| Teleported", 
                    Content = "Teleported to " .. selectedPlayer, 
                    Delay = 3
                })
            else
                Library:MakeNotify({
                    Title = "@aikoware",
                    Description = "| Error", 
                    Content = "Player not found or not loaded", 
                    Delay = 3
                })
            end
        else
            Library:MakeNotify({
                Title = "@aikoware",
                Description = "| Error", 
                Content = "No player selected", 
                Delay = 3
            })
        end
    end
})

ply:AddButton({
    Title = "Refresh Player List",
    Content = "",
    Callback = function()
        playerDropdown:Refresh(TeleportData.GetPlayerNames(Players, LocalPlayer))
        Library:MakeNotify({
            Title = "@aikoware",
            Description = "Refreshed", 
            Content = "Player list updated", 
            Delay = 3
        })
    end
})

local autotrade = Trade:AddSection("Auto Trade")

local TradeModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/a11bove/kdoaz/refs/heads/main/xzc/fishit/autotrademdl.lua"))()
local Trade = TradeModule(Players, LocalPlayer, ReplicatedStorage, Library)

local selectedTradePlayer = nil

local tradePlayerDropdown = autotrade:AddDropdown({
    Title = "Select Player",
    Content = "",
    Options = Trade.GetPlayerNames(),
    Default = {},
    Multi = false,
    Callback = function(value)
        if type(value) == "table" and #value > 0 then
            selectedTradePlayer = value[1]
        elseif type(value) == "string" then
            selectedTradePlayer = value
        else
            selectedTradePlayer = nil
        end

        if selectedTradePlayer then
            Library:MakeNotify({
                Title = "@aikoware",
                Description = "| Player Selected", 
                Content = selectedTradePlayer, 
                Delay = 3
            })
        end
    end
})

autotrade:AddButton({
    Title = "Give Item",
    Content = "",
    Callback = function()
        if selectedTradePlayer then
            Trade.SendTradeRequest(selectedTradePlayer)
        else
            Library:MakeNotify({
                Title = "@aikoware",
                Description = "| Error",
                Content = "No player selected",
                Delay = 3
            })
        end
    end
})

autotrade:AddToggle({
    Title = "Auto Accept Trade",
    Content = "Automatically accepts incoming trade requests",
    Default = false,
    Callback = function(state)
        Trade.SetAutoAccept(state)
    end
})

autotrade:AddButton({
    Title = "Refresh Player List",
    Icon = "refresh-cw",
    Content = "",
    Callback = function()
        tradePlayerDropdown:Refresh(Trade.GetPlayerNames())
        Library:MakeNotify({
            Title = "@aikoware",
            Description = "| Refreshed", 
            Content = "Player list updated", 
            Delay = 3
        })
    end
})

local idn = Misc:AddSection("Identity")

local overhead = (Players.LocalPlayer.Character or Players.LocalPlayer.CharacterAdded:Wait()):WaitForChild("HumanoidRootPart"):WaitForChild("Overhead")

local NameLabel = overhead.Content.Header
local LevelLabel = overhead.LevelContainer.Label
local OriginalName = NameLabel.Text
local OriginalLevel = LevelLabel.Text
local CustomName = OriginalName
local CustomLevel = OriginalLevel
local HideIdentifierEnabled = true

local overhead = (Players.LocalPlayer.Character or Players.LocalPlayer.CharacterAdded:Wait()):WaitForChild("HumanoidRootPart"):WaitForChild("Overhead")
local NameLabel = overhead.Content.Header
local LevelLabel = overhead.LevelContainer.Label
local OriginalName = NameLabel.Text
local OriginalLevel = LevelLabel.Text

idn:AddToggle({
    Title = "Hide Identity",
    Content = "",
    Default = true,
    Callback = function(enabled)
        HideIdentifierEnabled = enabled
        if enabled then
            NameLabel.Text = "@aikoware"
            LevelLabel.Text = "@aikoware"
        else
            NameLabel.Text = OriginalName
            LevelLabel.Text = OriginalLevel
        end
    end
})

--[[ Rainbow text effect
coroutine.wrap(function()
    local hue = 0
    while true do
        if HideIdentifierEnabled then
            hue = (hue + 0.01) % 1
            local rainbowColor = Color3.fromHSV(hue, 1, 1)
            NameLabel.TextColor3 = rainbowColor
            LevelLabel.TextColor3 = rainbowColor
        end
        wait(0.05)
    end
end)()]]

local uset = Misc:AddSection("User Settings")

uset:AddSlider({
    Title = "Walkspeed",
    Content = "",
    Min = 18,
    Max = 200,
    Default = 18,
    Callback = function(value)
        local player = game.Players.LocalPlayer
        local char = player.Character or player.CharacterAdded:Wait()
        local humanoid = char:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = value
        end
    end
})

uset:AddButton({
    Title = "Reset Walkspeed",
    Content = "Returns to default speed.",
    Callback = function()
        local player = game.Players.LocalPlayer
        local char = player.Character or player.CharacterAdded:Wait()
        local humanoid = char:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = 18
        end
        Library:MakeNotify({
            Title = "@aikoware",
            Description = "Walkspeed Reset",
            Content = "Walkspeed back to default.",
            Delay = 2,
        })
    end
})

uset:AddToggle({
    Title = "Inf Jump",
    Content = "",
    Default = false,
    Callback = function(enabled)
        _G.InfiniteJump = enabled
            Library:MakeNotify({
                Title = "@aikoware",
                Description = "| Infinite Jump",
                Content = enabled and "Enabled" or "Disabled",
            })
    end
})

local noclipEnabled = false
uset:AddToggle({
    Title = "No clip",
    Content = "",
    Default = false,
    Callback = function(state)
        noclipEnabled = state
        local player = game.Players.LocalPlayer
        local char = player.Character or player.CharacterAdded:Wait()

        if state then
            _G.NoclipConnection = game:GetService("RunService").RenderStepped:Connect(function()
                if char then
                    for _, part in ipairs(char:GetChildren()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
                        Library:MakeNotify({Title = "@aikoware", Description="| No Clip", Content="Enabled", Delay=2,
            })
        else
            if _G.NoclipConnection then
                _G.NoclipConnection:Disconnect()
                _G.NoclipConnection = nil
            end
            if char then
                for _, part in ipairs(char:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
            Library:MakeNotify({Title = "@aikoware", Description="| No Clip", Content="Disabled", Delay=2,
                    })
        end
    end
})

local perf = Misc:AddSection("Performance")

local hidePlayersEnabled = false
local function setCharacterVisibility(character, visible)
    if character then
        for _, descendant in ipairs(character:GetDescendants()) do
            if descendant:IsA("BasePart") then
                pcall(function()
                    descendant.LocalTransparencyModifier = visible and 0 or 1
                    descendant.CanCollide = visible
                end)
            elseif descendant:IsA("Decal") then
                pcall(function()
                    descendant.Transparency = visible and 0 or 1
                end)
            end
        end
    end
end

local function hideAllPlayers()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            setCharacterVisibility(player.Character, false)
        end
    end
end

local function showAllPlayers()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            setCharacterVisibility(player.Character, true)
        end
    end
end

local function enableHidePlayers()
    if not hidePlayersEnabled then
        hidePlayersEnabled = true
        hideAllPlayers()

        playerAddedConnection = Players.PlayerAdded:Connect(function(player)
            characterConnections[player] = player.CharacterAdded:Connect(function(character)
                task.wait(0.5)
                setCharacterVisibility(character, false)
            end)

            if player.Character then
                task.wait(0.1)
                setCharacterVisibility(player.Character, false)
            end
        end)

        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and not characterConnections[player] then
                characterConnections[player] = player.CharacterAdded:Connect(function(character)
                    task.wait(0.5)
                    setCharacterVisibility(character, false)
                end)
            end
        end
    end
end

local function disableHidePlayers()
    if hidePlayersEnabled then
        hidePlayersEnabled = false
        showAllPlayers()

        if playerAddedConnection then
            playerAddedConnection:Disconnect()
            playerAddedConnection = nil
        end

        for player, connection in pairs(characterConnections) do
            if connection then
                connection:Disconnect()
            end
            characterConnections[player] = nil
        end
    end
end

perf:AddToggle({
    Title = "Hide Players",
    Content = "",
    Default = false,
    Callback = function(enabled)
            if enabled then
                    enableHidePlayers()
                else
                    disableHidePlayers()
                end
            end
})

perf:AddToggle({
    Title = "Remove Shadows",
    Content = "",
    Default = false,
    Callback = function(enabled)
            pcall(function()
                    Lighting.GlobalShadows = not enabled
                end)
            end
})

perf:AddToggle({
    Title = "Remove Water Reflections",
    Content = "",
    Default = false,
    Callback = function(enabled)
            pcall(function()
                    Lighting.EnvironmentSpecularScale = enabled and 0 or 1
                end)
            end
})

perf:AddToggle({
    Title = "Remove Particles",
    Content = "",
    Default = false,
    Callback = function(enabled)
            for _, descendant in ipairs(workspace:GetDescendants()) do
                    if descendant:IsA("ParticleEmitter") or descendant:IsA("Trail") or descendant:IsA("Beam") then
                        pcall(function()
                            descendant.Enabled = not enabled
                        end)
                    end
                end
            end
})

perf:AddToggle({
    Title = "Remove Terrain Decorations",
    Content = "",
    Default = false,
    Callback = function(enabled)
            local terrain = workspace:FindFirstChildOfClass("Terrain")
                if terrain then
                    pcall(function()
                        terrain.Decoration = not enabled
                    end)
                end
            end
})

local frc = Misc:AddSection("Freeze Character")

local originalCFrame = nil
local freezeConnection = nil

frc:AddToggle({
    Title = "Freeze Character",
    Default = false,
    Callback = function(enabled)
        _G.FreezeCharacter = enabled

        if enabled then
            local character = LocalPlayer.Character
            local hrp = character and character:FindFirstChild("HumanoidRootPart")

            if hrp then
                originalCFrame = hrp.CFrame

                if freezeConnection then
                    freezeConnection:Disconnect()
                    freezeConnection = nil
                end

                freezeConnection = RunService.Heartbeat:Connect(function()
                    if _G.FreezeCharacter and hrp and hrp.Parent then
                        hrp.CFrame = originalCFrame
                        hrp.AssemblyLinearVelocity = Vector3.zero
                        hrp.AssemblyAngularVelocity = Vector3.zero
                    end
                end)

                Library:MakeNotify({
                    Title = "@aikoware",
                    Description = "| Freeze Character",
                    Content = "Enabled",
                    Delay = 2
                })
            end
        else
            if freezeConnection then
                freezeConnection:Disconnect()
                freezeConnection = nil
            end

            Library:MakeNotify({
                Title = "@aikoware",
                Description = "| Freeze Character",
                Content = "Disabled",
                Delay = 2
            })
        end
    end
})

LocalPlayer.CharacterAdded:Connect(function()
    if freezeConnection then
        freezeConnection:Disconnect()
        freezeConnection = nil
    end
    _G.FreezeCharacter = false
end)

local oxy = Misc:AddSection("Oxygen")

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

oxy:AddToggle({
    Title = "Unlimited Oxygen",
    Content = "",
    Default = false,
    Callback = function(enabled)
        if enabled then
            StartOxygenBypass()
        else
            StopOxygenBypass()
        end
    end
})

local radsr = Misc:AddSection("Fishing Radar")

radsr:AddToggle({
    Title = "Fishing Radar",
    Content = "",
    Default = false,
    Callback = function(state)
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local Lighting = game:GetService("Lighting")

        local Replion = require(ReplicatedStorage.Packages.Replion)
        local Net = require(ReplicatedStorage.Packages.Net)
        local SPR = require(ReplicatedStorage.Packages.spr)
        local Soundbook = require(ReplicatedStorage.Shared.Soundbook)
        local ClientTime = require(ReplicatedStorage.Controllers.ClientTimeController)
        local TextNotification = require(ReplicatedStorage.Controllers.TextNotificationController)

        local UpdateFishingRadar = Net:RemoteFunction("UpdateFishingRadar")

        local function SetRadar(enable)
            local clientData = Replion.Client:GetReplion("Data")
            if not clientData then return end

            if clientData:Get("RegionsVisible") ~= enable then
                if UpdateFishingRadar:InvokeServer(enable) then
                    Soundbook.Sounds.RadarToggle:Play().PlaybackSpeed = 1 + math.random() * 0.3

                    if enable then
                        local ccEffect = Lighting:FindFirstChildWhichIsA("ColorCorrectionEffect")
                        if ccEffect then
                            SPR.stop(ccEffect)
                            local lightingProfile = ClientTime:_getLightingProfile()
                            local targetSettings = (lightingProfile and lightingProfile.ColorCorrection) or {}
                            targetSettings.Brightness = targetSettings.Brightness or 0.04
                            targetSettings.TintColor = targetSettings.TintColor or Color3.fromRGB(255, 255, 255)

                            ccEffect.TintColor = Color3.fromRGB(42, 226, 118)
                            ccEffect.Brightness = 0.4
                            SPR.target(ccEffect, 1, 1, targetSettings)
                        end

                        SPR.stop(Lighting)
                        Lighting.ExposureCompensation = 1
                        SPR.target(Lighting, 1, 2, {ExposureCompensation = 0})
                    end

                    TextNotification:DeliverNotification({
                        Type = "Text",
                        Text = "Radar: "..(enable and "Enabled" or "Disabled"),
                        TextColor = enable and {R = 9, G = 255, B = 0} or {R = 255, G = 0, B = 0}
                    })
                end
            end
        end

        -- Toggle ON/OFF
        if state then
            SetRadar(true)
        else
            SetRadar(false)
        end
    end
})
