if not game:IsLoaded() then
    game.Loaded:Wait()
end

local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

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

local function floatPlat(enabled)
    local character = LocalPlayer.Character
    if not character then return end

    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    if enabled then
        if not EventTeleportSettings.platform then
            EventTeleportSettings.platform = Instance.new("Part")
            EventTeleportSettings.platform.Size = Vector3.new(10, 1, 10)
            EventTeleportSettings.platform.Anchored = true
            EventTeleportSettings.platform.Transparency = 0.5
            EventTeleportSettings.platform.Parent = workspace
        end
        EventTeleportSettings.platform.Position = hrp.Position - Vector3.new(0, 4, 0)
    else
        if EventTeleportSettings.platform then
            EventTeleportSettings.platform:Destroy()
            EventTeleportSettings.platform = nil
        end
    end
end

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

local Window = WindUI:CreateWindow({
    Title = "@aikoware | Fish It",
    Author = "made by untog !",
    Folder = "AIKOWARE",
    Icon = "rbxassetid://140356301069419",
    IconSize = 22*2,
    Resizable = false,
    NewElements = true,
    Size = UDim2.fromOffset(400,420),
    HideSearchBar = false,
    OpenButton = {
        Title = "@aikoware", -- can be changed
        CornerRadius = UDim.new(1,0),
        StrokeThickness = 1, -- removing outline
        Enabled = true,
        Draggable = true,
        OnlyMobile = false,
        Color = ColorSequence.new( -- gradient
            Color3.fromHex("#000000"), 
            Color3.fromHex("#000000")
        )
    },
})

local Tabs = {
    Home = Window:Tab({Title = "Home", Icon = "house"}),
    Fishing = Window:Tab({Title = "Fishing", Icon = "fish"}),
    Shop = Window:Tab({Title = "Shop", Icon = "piggy-bank"}),
    Quest = Window:Tab({Title = "Quest", Icon = "zap"}),
    Utility = Window:Tab({Title = "Utility", Icon = "cog"}),
    Teleport = Window:Tab({Title = "Teleport", Icon = "map-pin"}),
    Trade = Window:Tab({Title = "Trade", Icon = "repeat"}),
    Misc = Window:Tab({Title = "Misc", Icon = "snowflake"}),
    Settings = Window:Tab({Title = "Settings", Icon = "settings"})
}

Tabs.Home:Section({Title = "Support", TextXAlignment = "Left", TextSize = 17})

if not ui then ui = {} end
if not ui.Creator then ui.Creator = {} end

local HttpService = game:GetService("HttpService")

local function SafeRequest(requestData)
    local success, result = pcall(function()
        if syn and syn.request then
            local response = syn.request(requestData)
            return {
                Body = response.Body,
                StatusCode = response.StatusCode,
                Success = response.Success
            }
        elseif request and type(request) == "function" then
            local response = request(requestData)
            return {
                Body = response.Body,
                StatusCode = response.StatusCode,
                Success = response.Success
            }
        elseif http and http.request then
            local response = http.request(requestData)
            return {
                Body = response.Body,
                StatusCode = response.StatusCode,
                Success = response.Success
            }
        elseif HttpService.RequestAsync then
            local response = HttpService:RequestAsync({
                Url = requestData.Url,
                Method = requestData.Method or "GET",
                Headers = requestData.Headers or {}
            })
            return {
                Body = response.Body,
                StatusCode = response.StatusCode,
                Success = response.Success
            }
        else
            local body = HttpService:GetAsync(requestData.Url)
            return {
                Body = body,
                StatusCode = 200,
                Success = true
            }
        end
    end)

    if success then
        return result
    else
        warn("HTTP Request failed:", result)
        return {
            Body = "{}",
            StatusCode = 0,
            Success = false,
            Error = tostring(result)
        }
    end
end

local function RetryRequest(requestData, retries)
    retries = retries or 2
    for i = 1, retries do
        local result = SafeRequest(requestData)
        if result.Success and result.StatusCode == 200 then
            return result
        end
        task.wait(1)
    end
    return {
        Success = false, Error = "Max retries reached"
    }
end

local function ShowError(message)
    Tabs.Home:Paragraph({
        Title = "Error fetching Discord Info",
        Image = "rbxassetid://17862288113",
        ImageSize = 60,
        Color = "Red"
    })
end

local InviteCode = "JccfFGpDNV"
local DiscordAPI = "https://discord.com/api/v10/invites/" .. InviteCode .. "?with_counts=true&with_expiration=true"

local function LoadDiscordInfo()
    local success, result = pcall(function()
        return HttpService:JSONDecode(RetryRequest({
            Url = DiscordAPI,
            Method = "GET",
            Headers = {
                ["User-Agent"] = "RobloxBot/1.0",
                ["Accept"] = "application/json"
            }
        }).Body)
    end)

    if success and result and result.guild then
        local DiscordInfo = Tabs.Home:Paragraph({
            Title = result.guild.name,
            Desc = ' <font color="#52525b">•</font> Members: ' .. tostring(result.approximate_member_count) ..
            '\n <font color="#16a34a">•</font> Online: ' .. tostring(result.approximate_presence_count),
            Image = "https://cdn.discordapp.com/icons/" .. result.guild.id .. "/" .. result.guild.icon .. ".png?size=1024",
            ImageSize = 42,
        })

        Tabs.Home:Button({
            Title = "Update Info",
            Callback = function()
                local updated, updatedResult = pcall(function()
                    return HttpService:JSONDecode(RetryRequest({
                        Url = DiscordAPI,
                        Method = "GET",
                    }).Body)
                end)

                if updated and updatedResult and updatedResult.guild then
                    DiscordInfo:SetDesc(
                        ' <font color="#52525b">•</font> Members: ' .. tostring(updatedResult.approximate_member_count) ..
                        '\n <font color="#16a34a">•</font> Online: ' .. tostring(updatedResult.approximate_presence_count)
                    )

                    WindUI:Notify({
                        Title = "Discord Info Updated",
                        Content = "Successfully refreshed Discord statistics",
                        Duration = 2,
                        Icon = "refresh-cw",
                    })
                else
                    WindUI:Notify({
                        Title = "Update Failed",
                        Content = "Could not refresh Discord info",
                        Duration = 3,
                        Icon = "alert-triangle",
                    })
                end
            end
        })

        Tabs.Home:Button({
            Title = "Copy Discord Invite",
            Callback = function()
                setclipboard("https://discord.gg/" .. InviteCode)
                WindUI:Notify({
                    Title = "Copied!",
                    Content = "Discord invite copied to clipboard",
                    Duration = 2,
                    Icon = "clipboard-check",
                })
            end
        })

    else
        ShowError("Failed to fetch Discord Info. " .. (result and result.Error or "Unknown error"))
    end
end

LoadDiscordInfo()

Tabs.Home:Section({Title = "User Settings", TextXAlignment = "Left", TextSize = 17})

Tabs.Home:Slider({
    Title = "Walkspeed",
    Value = {
        Min = 18,
        Max = 200,
        Default = 18
    },
    Callback = function(value)
        local player = game.Players.LocalPlayer
        local char = player.Character or player.CharacterAdded:Wait()
        local humanoid = char:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = value
        end
    end
})

Tabs.Home:Button({
    Title = "Reset Walkspeed",
    Desc = "Returns to default speed.",
    Callback = function()
        local player = game.Players.LocalPlayer
        local char = player.Character or player.CharacterAdded:Wait()
        local humanoid = char:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = 18
        end
        WindUI:Notify({
            Title = "Walkspeed Reset",
            Content = "Walkspeed back to default.",
            Duration = 2,
        })
    end
})

Tabs.Home:Toggle({
    Title = "Infinite Jump",
    Desc = "Inf jump ;)",
    Default = false,
    Callback = function(enabled)
        _G.InfiniteJump = enabled
    end
})

local noclipEnabled = false
Tabs.Home:Toggle({
    Title = "No clip",
    Desc = "No clip ;)",
    Value = false,
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
            WindUI:Notify({Title="Noclip", Content="Enabled", Duration=2,
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
            WindUI:Notify({Title="Noclip", Content="Disabled", Duration=2,
                    })
        end
    end
})

local walkOnWaterEnabled = false
local floatHeight = 3
local player = game.Players.LocalPlayer
local runService = game:GetService("RunService")

local bp, floatConnection

local function setupFloat()
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")

    bp = Instance.new("BodyPosition")
    bp.MaxForce = Vector3.new(0, math.huge, 0)
    bp.D = 15
    bp.P = 2000
    bp.Position = hrp.Position
    bp.Parent = hrp

    floatConnection = runService.RenderStepped:Connect(function(delta)
        if walkOnWaterEnabled and hrp and hrp.Parent then
            local ray = Ray.new(hrp.Position, Vector3.new(0, -50, 0))
            local part, pos = workspace:FindPartOnRay(ray, char)
            if part and (part.Material == Enum.Material.Water or part.Name:lower():find("lava")) then
                bp.Position = Vector3.new(hrp.Position.X, pos.Y + floatHeight, hrp.Position.Z)
            else
                bp.Position = hrp.Position
            end
        end
    end)
end

Tabs.Home:Toggle({
    Title = "Float Player",
    Desc = "Raise your character a little and make your character float.",
    Value = false,
    Callback = function(state)
        walkOnWaterEnabled = state
        local char = player.Character or player.CharacterAdded:Wait()
        local hrp = char:WaitForChild("HumanoidRootPart")

        if state then
            setupFloat()
            WindUI:Notify({
                Title = "Float Player",
                Content = "Enabled",
                Duration = 2,
            })
        else
            if floatConnection then
                floatConnection:Disconnect()
                floatConnection = nil
            end
            if bp then
                bp:Destroy()
                bp = nil
            end
            WindUI:Notify({
                Title = "Float Player", 
                Content = "Disabled", 
                Duration = 2,
            })
        end
    end
})

Tabs.Home:Section({Title = "Performance", TextXAlignment = "Left", TextSize = 17})

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

local hideplayerz = Tabs.Home:Toggle({
    Title = "Hide Players",
    Default = false,
    Callback = function(enabled)
            if enabled then
                    enableHidePlayers()
                else
                    disableHidePlayers()
                end
            end
})

local remoshadow = Tabs.Home:Toggle({
    Title = "Remove Shadows",
    Default = false,
    Callback = function(enabled)
            pcall(function()
                    Lighting.GlobalShadows = not enabled
                end)
            end
})

local remwater = Tabs.Home:Toggle({
    Title = "Remove Water Reflections",
    Default = false,
    Callback = function(enabled)
            pcall(function()
                    Lighting.EnvironmentSpecularScale = enabled and 0 or 1
                end)
            end
})

local remparticle = Tabs.Home:Toggle({
    Title = "Remove Particles",
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

local remterr = Tabs.Home:Toggle({
    Title = "Remove Terrain Decorations",
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

Tabs.Fishing:Section({Title = "Legit", TextXAlignment = "Left", TextSize = 17})

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

Tabs.Fishing:Toggle({
    Title = "Legit Fishing (Auto Perfect)",
    Desc = "Much better if you have ”Perfect“ enchant.",
    Default = false,
    Callback = ToggleAutoLegitFish
})

Tabs.Fishing:Section({Title = "Utility", TextXAlignment = "Left", TextSize = 17})

local originalCFrame
local freezeConnection

Tabs.Fishing:Toggle({
    Title = "Freeze Character",
    Desc = "For blatants fishing.",
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

Tabs.Fishing:Section({Title = "Instant", TextXAlignment = "Left", TextSize = 17})

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

Tabs.Fishing:Toggle({
    Title = "Auto Instant Fishing",
    Desc = "Settings depends on your rod.",
    Callback = function(enabled)
        if enabled then
            StartInstantFish()
        else
            StopInstantFish()
        end
    end
})

local CompleteDelayInput = Tabs.Fishing:Input({
    Title = "Custom Complete Delay",
    Desc = "Enter delay in seconds",
    Value = tostring(CompleteDelay),
    InputIcon = "timer",
    Type = "Input",
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

local CancelDelayInput = Tabs.Fishing:Input({
    Title = "Custom Cancel Delay",
    Desc = "Enter delay in seconds",
    Value = tostring(CancelDelay),
    InputIcon = "timer",
    Type = "Input",
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

Tabs.Fishing:Section({Title = "Blatant V2", TextXAlignment = "Left", TextSize = 17})

Tabs.Fishing:Toggle({
    Title = "Blatant V2",
    Desc = "Settings depends on your rod.",
    Callback = function(enabled)
        if enabled then
            StartSuperInstant()
        else
            StopSuperInstant()
        end
    end
})

local SuperReelDelayInput = Tabs.Fishing:Input({
    Title = "Custom Delay Reel",
    Desc = "Enter delay in seconds",
    Value = tostring(SuperReelDelay),
    InputIcon = "timer",
    Type = "Input",
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

local SuperCompleteDelayInput = Tabs.Fishing:Input({
    Title = "Custom Complete Delay",
    Desc = "Enter delay in seconds",
    Value = tostring(SuperCompleteDelay),
    InputIcon = "timer",
    Type = "Input",
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

Tabs.Fishing:Section({Title = "Blatant For Scythe", TextXAlignment = "Left", TextSize = 17})

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

Tabs.Fishing:Toggle({
    Title = "Blatant V3",
    Desc = "For scythe rod users.",
    Callback = function(enabled)
        if enabled then
            StartSuperInstantV2()
        else
            StopSuperInstantV2()
        end
    end
})

local ScytheCompleteDelayInput = Tabs.Fishing:Input({
    Title = "Custom Complete Delay",
    Desc = "Enter delay in seconds",
    Value = tostring(ScytheCompleteDelay),
    InputIcon = "timer",
    Type = "Input",
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

local ScytheReelDelayInput = Tabs.Fishing:Input({
    Title = "Custom Cancel Delay",
    Desc = "Enter delay in seconds",
    Value = tostring(ScytheReelDelay),
    InputIcon = "timer",
    Type = "Input",
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

Tabs.Fishing:Section({Title = "Enchant", TextXAlignment = "Left", TextSize = 17})
Tabs.Fishing:Toggle({
    Title = "Auto Enchant Rod",
    Desc = "Automatically enchants your equipped rod.",
    Callback = function()
        local enchantPosition = Vector3.new(3231, -1303, 1402)
        local character = workspace:WaitForChild("Characters"):FindFirstChild(LocalPlayer.Name)
        local hrp = character and character:FindFirstChild("HumanoidRootPart")

        if hrp then
            NotifyInfo("Preparing Enchant...", "Please manually place Enchant Stone into slot 5 before we begin...", 5)
            task.wait(3)

            local slot5 = LocalPlayer.PlayerGui.Backpack.Display:GetChildren()[10]
            local itemName = slot5 and slot5:FindFirstChild("Inner") and slot5.Inner:FindFirstChild("Tags") and slot5.Inner.Tags:FindFirstChild("ItemName")

            if itemName and itemName.Text:lower():find("enchant") then
                NotifyInfo("Enchanting...", "Enchanting in progress, please wait...", 7)
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
            else
                NotifyError("Auto Enchant Rod", "Slot 5 does not contain an Enchant Stone.")
            end
        else
            NotifyError("Auto Enchant Rod", "Failed to get character HRP.")
        end
    end
})

Tabs.Fishing:Section({Title = "Notification", TextXAlignment = "Left", TextSize = 17})

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

local caughtnotif = Tabs.Fishing:Toggle({
    Title = "Caught Notification",
    Desc = "Use this For Disable ur Notification caught",
    Default = true,
    Callback = function(enabled)
        ToggleCaughtNotifications(not enabled)
    end
})

local radsr = Tabs.Fishing:Section({Title = "Fishing Radar", TextSize = 17, TextXAlignment = "Left"})

local fishrad = Tabs.Fishing:Toggle({
    Title = "Fishing Radar",
    Desc = "Bypass Fishing Radar",
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

                    WindUI:Notify({
                        Title = "Fishing Radar",
                        Desc = "Radar: "..(enable and "Enabled" or "Disabled"),
                        Icon = "radar",
                        Duration =2
                    })
                end
            end
        end

        if state then
            SetRadar(true)
        else
            SetRadar(false)
        end
    end
})

Tabs.Shop:Section({Title = "Buy", TextXAlignment = "Left", TextSize = 17})

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

Tabs.Shop:Dropdown({
    Title = "Select Rod",
    Values = rodNames,
    Value = selectedRod,
    Callback = function(value)
        selectedRod = value
        WindUI:Notify({Title="Rod Selected", Content=value, Duration=3})
    end
})

Tabs.Shop:Space()

Tabs.Shop:Button({
    Title = "Buy Rod",
    Justify = "Center",
    Callback = function()
        local key = rodKeyMap[selectedRod]
        if key and rods[key] then
            local success, err = pcall(function()
                RFPurchaseFishingRod:InvokeServer(rods[key])
            end)
            if success then
                WindUI:Notify({Title="Rod Purchase", Content="Purchased "..selectedRod, Duration=3})
            else
                WindUI:Notify({Title="Rod Purchase Error", Content=tostring(err), Duration=5})
            end
        end
    end
})

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

Tabs.Shop:Space()

Tabs.Shop:Dropdown({
    Title="Select Bait",
    Values=baitNames,
    Value=selectedBait,
    Callback=function(value)
        selectedBait = value
        WindUI:Notify({
            Title="Bait Selected",
            Content=value,
            Duration=3
        })
    end
})

Tabs.Shop:Space()

Tabs.Shop:Button({
    Title="Buy Bait",
    Justify = "Center",
    Callback=function()
        local key = baitKeyMap[selectedBait]
        if key and baits[key] then
            local amount = baits[key]
            local success, err = pcall(function()
                RFPurchaseBait:InvokeServer(amount)
            end)
            if success then
                WindUI:Notify({
                    Title="Bait Purchase",
                    Content="Purchased "..selectedBait.." x"..amount,
                    Duration=3
                })
            else
                WindUI:Notify({
                    Title="Bait Purchase Error",
                    Content=tostring(err),
                    Duration=5
                })
            end
        end
    end
})

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

local selectedWeathers = {weatherNames[1]}

Tabs.Shop:Space()

local weatheroptions = Tabs.Shop:Dropdown({
    Title="Select Weather(s)",
    Values=weatherNames,
    Multi=true,
    Value=selectedWeathers,
    Callback=function(values)
        selectedWeathers = values
        WindUI:Notify({
            Title="Weather Selected",
            Content="Selected "..#values.." weather(s)",
            Duration=2
        })
    end
})

local autoBuyEnabled = false
local buyDelay = 0.5 -- delay antar pembelian

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
                        WindUI:Notify({
                            Title="Auto Buy",
                            Content="Purchased "..displayName,
                            Duration=1
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

local autobuyweather = Tabs.Shop:Toggle({
    Title = "Auto Buy Weather",
    Desc = "Automatically purchase selected weather(s).",
    Value = false,
    Callback = function(state)
        autoBuyEnabled = state
        if state then
            WindUI:Notify({
                Title = "Auto Buy",
                Content = "Enabled",
                Duration = 2
            })
            startAutoBuy()
        else
            WindUI:Notify({
                Title = "Auto Buy",
                Content = "Disabled",
                Duration = 2
            })
        end
    end
})

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

Tabs.Shop:Space()

Tabs.Shop:Dropdown({
    Title = "Select Boat",
    Values = boatNames,
    Value = selectedBoat,
    Callback = function(value)
        selectedBoat = value
        WindUI:Notify({
            Title = "Boat Selected",
            Content = value,
            Duration = 3
        })
    end
})

Tabs.Shop:Space()

Tabs.Shop:Button({
    Title = "Buy Boat",
    Justify = "Center",
    Callback = function()
        local key = boatKeyMap[selectedBoat]
        if key and boats[key] then
            local success, err = pcall(function()
                RFPurchaseBoat:InvokeServer(boats[key].Id)
            end)
            if success then
                WindUI:Notify({
                    Title = "Boat Purchase",
                    Content = "Purchased "..selectedBoat,
                    Duration = 3
                })
            else
                WindUI:Notify({
                    Title = "Boat Purchase Error",
                    Content = tostring(err),
                    Duration = 5
                })
            end
        end
    end
})

Tabs.Shop:Section({Title = "Sell", TextXAlignment = "Left", TextSize = 17})

local autosellfish = Tabs.Shop:Toggle({
    Title = "Auto Sell",
    Desc = "Automatically sells fish.",
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
local autosellin = Tabs.Shop:Input({
    Title = "Auto Sell Threshold",
    Desc = "Set the number of fish to catch before auto-selling.",
    Placeholder = "Default: 30",
    Type = "Input",
    Value = tostring(sellThreshold),
    InputIcon = "timer",
    Callback = function(value)
        local threshold = tonumber(value)
        if threshold then
            sellThreshold = threshold
            WindUI:Notify({
                Title = "Threshold Updated",
                Description = "Fish will be sold automatically when catch reaches " .. sellThreshold,
                Duration = 1
            })
        else
            WindUI:Notify({
                Title = "Invalid Input",
                Description = "Please enter a number, not text.",
                Duration = 1
            })
        end
    end
})

Tabs.Shop:Space()

Tabs.Shop:Button({
    Title = "Sell All Fish",
    Justify = "Center",
    Desc = "Instanly sells non-favorite fish.",
    Callback = function()
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local RFSellAllItems = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RF/SellAllItems"]

        pcall(function()
            RFSellAllItems:InvokeServer()
        end)

        WindUI:Notify({
            Title = "Auto Sell",
            Content = "All items sold!",
            Duration = 3
        })
    end
})

Tabs.Quest:Section({Title = "Deep Sea Quest", TextXAlignment = "Left", TextSize = 17})

local QuestSettings = {player = Players.LocalPlayer}
local DeepSeaParagraph = Tabs.Quest:Paragraph({Title = "Deep Sea Panel", Desc = ""})

Tabs.Quest:Toggle({
    Title = "Auto Deep Sea Quest",
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

-- Element Quest
Tabs.Quest:Section({Title = "Element Quest", TextXAlignment = "Left", TextSize = 17})

local ElementParagraph = Tabs.Quest:Paragraph({Title = "Element Panel", Desc = ""})

Tabs.Quest:Toggle({
    Title = "Auto Element Quest",
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
                                    if ElementParagraph and ElementParagraph.SetDesc then
                                        ElementParagraph:SetDesc("Element Quest Completed!")
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
        ElementParagraph:SetDesc(GetQuestProgress("Element Tracker"))
        DeepSeaParagraph:SetDesc(GetQuestProgress("Deep Sea Tracker"))
    end
end)

Tabs.Quest:Section({Title = "Artifact", TextXAlignment = "Left", TextSize = 17})

local ArtifactModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/a11bove/kdoaz/refs/heads/main/xzc/fishit/artifactmdl.lua"))()
local Artifact = ArtifactModule(LocalPlayer, PlayerGui, ReplicatedStorage, VirtualInputManager, FishingController, workspace)

local ArtifactOverlay, OverlayTitle, OverlayMessage, OverlayLink, OverlayIcon = Artifact.CreateOverlay()

local function UpdateOverlay(visible, title, message, link, iconId)
    ArtifactOverlay.Enabled = visible
    if title then OverlayTitle.Text = title end
    if message then OverlayMessage.Text = message end
    if link then OverlayLink.Text = link end
    if iconId then OverlayIcon.Image = "rbxassetid://" .. tostring(iconId) end
end

local ArtifactProgressParagraph = Tabs.Quest:Paragraph({
    Title = "Temple Artifact Progress",
    Desc = Artifact.GetArtifactProgressText()
})

local AutoFarmArtifactsRunning = false

local function AutoFarmArtifactsCycle()
    if not AutoFarmArtifactsRunning then return end

    local leverData, ownedArtifacts = Artifact.GetPlayerData()
    local remotesFolder = ReplicatedStorage:FindFirstChild("Remotes")

    for artifactName, _ in pairs(Artifact.Ids) do
        if not leverData[artifactName] then
            if not ownedArtifacts[artifactName] then
                Artifact.TeleportToArtifact(artifactName)
                Artifact.ToggleArtifactFishing(true)

                while true do
                    task.wait(Artifact.Config.FishingCheckDelay)
                    local fishingGui = PlayerGui:FindFirstChild("Fishing")
                    fishingGui = fishingGui and fishingGui:FindFirstChild("Main")
                    if not (fishingGui and fishingGui.Visible and AutoFarmArtifactsRunning) then
                        Artifact.ToggleArtifactFishing(false)
                        break
                    end
                end
            end

            local placeLeverRemote = remotesFolder and remotesFolder:FindFirstChild("RE_PlaceLeverItem")
            if placeLeverRemote then
                placeLeverRemote:FireServer(artifactName)
            end
            task.wait(Artifact.Config.PlaceLeverDelay)
        end
    end

    ArtifactProgressParagraph:SetDesc(Artifact.GetArtifactProgressText())
    task.wait(Artifact.Config.CycleDelay)
end

Tabs.Quest:Toggle({
    Title = "Auto Farm Artifact",
    Desc = "Automatically farms artifacts and place levers.",
    Default = false,
    Callback = function(enabled)
        AutoFarmArtifactsRunning = enabled
        if enabled then
            UpdateOverlay(true)
            task.spawn(AutoFarmArtifactsCycle)
        else
            Artifact.ToggleArtifactFishing(false)
            UpdateOverlay(false)
        end
    end
})

local TeleportData = loadstring(game:HttpGet("https://raw.githubusercontent.com/a11bove/kdoaz/refs/heads/main/xzc/fishit/tpmdl.lua"))()

Tabs.Teleport:Section({Title = "Location", TextXAlignment = "Left", TextSize = 17})

local locationNames = {}
for name, _ in pairs(TeleportData.Locations) do
    table.insert(locationNames, name)
end
table.sort(locationNames)

Tabs.Teleport:Dropdown({
    Title = "Select Location",
    Values = locationNames,
    Callback = function(locationName)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(TeleportData.Locations[locationName])
        end
    end
})

Tabs.Teleport:Section({Title = "NPC Location", TextXAlignment = "Left", TextSize = 17})

local npcNames = {}
for name, _ in pairs(TeleportData.NPCs) do
    table.insert(npcNames, name)
end
table.sort(npcNames)

Tabs.Teleport:Dropdown({
    Title = "Teleport to NPC",
    Values = npcNames,
    AllowNone = true,
    Multi = false,
    Callback = function(selectedNPC)
        local targetCFrame = TeleportData.NPCs[selectedNPC]
        if targetCFrame then
            local character = LocalPlayer.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                character:PivotTo(targetCFrame)
            end
        end
    end
})

Tabs.Teleport:Section({Title = "Machines Location", TextXAlignment = "Left", TextSize = 17})

local machineNames = {}
for name, _ in pairs(TeleportData.Machines) do
    table.insert(machineNames, name)
end
table.sort(machineNames)

Tabs.Teleport:Dropdown({
    Title = "Select Machine",
    Values = machineNames,
    AllowNone = true,
    Multi = false,
    Callback = function(selectedMachine)
        local targetCFrame = TeleportData.Machines[selectedMachine]
        if targetCFrame then
            local character = LocalPlayer.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                character:PivotTo(targetCFrame)
            end
        end
    end
})

Tabs.Teleport:Section({Title = "Event", TextXAlignment = "Left", TextSize = 17})

local EventTeleportSettings = {
    enabled = false,
    selectedEvent = nil,
    originalPosition = nil,
    platform = nil,
    isAtEvent = false
}

Tabs.Teleport:Dropdown({
    Title = "Select Event",
    Values = TeleportData.Events,
    AllowNone = true,
    Multi = true,
    Callback = function(selected)
        EventTeleportSettings.selectedEvent = selected
    end
})

local FloatPlayer

Tabs.Teleport:Toggle({
    Title = "Auto Teleport Selected Event",
    Desc = "Automatically teleports you to the chosen spawned event.",
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
                    FloatPlayer:Set(true)
                    characterHRP.Velocity = Vector3.zero
                    characterHRP.CFrame = foundEvent.CFrame * CFrame.new(20, 30, 0)
                    if lockPositionState.enabled then
                        lockPositionState.position = characterHRP.CFrame
                    end
                elseif not foundEvent and EventTeleportSettings.isAtEvent then
                    floatPlat(false)
                    FloatPlayer:Set(false)
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

Tabs.Teleport:Section({Title = "Player", TextXAlignment = "Left", TextSize = 17})

local selectedPlayer = nil

local playerDropdown = Tabs.Teleport:Dropdown({
    Title = "Select Player",
    Values = TeleportData.GetPlayerNames(Players, LocalPlayer),
    AllowNone = true,
    Multi = false,
    Callback = function(value)
        selectedPlayer = value
        WindUI:Notify({Title="Player Selected", Content=value, Duration=3})
    end
})

Tabs.Teleport:Button({
    Title = "Teleport To Player",
    Icon = "user",
    Justify = "Center",
    Callback = function()
        if selectedPlayer then
            local targetPlayer = Players:FindFirstChild(selectedPlayer)
            local myChar = LocalPlayer.Character
            local hrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
            local targetChar = targetPlayer and targetPlayer.Character
            local targetHRP = targetChar and targetChar:FindFirstChild("HumanoidRootPart")

            if hrp and targetHRP then
                hrp.CFrame = targetHRP.CFrame + Vector3.new(0,5,0)
                WindUI:Notify({Title="Teleported", Content="Teleported to "..selectedPlayer, Duration=3})
            else
                WindUI:Notify({Title="Error", Content="Player not found or not loaded", Duration=3})
            end
        else
            WindUI:Notify({Title="Error", Content="No player selected", Duration=3})
        end
    end
})

Tabs.Teleport:Space()

Tabs.Teleport:Button({
    Title = "Refresh Player List",
    Icon = "refresh-cw",
    Justify = "Center",
    Callback = function()
        playerDropdown:Refresh(TeleportData.GetPlayerNames(Players, LocalPlayer))
        WindUI:Notify({Title="Refreshed", Content="Player list updated", Duration=3})
    end
})

local autotrade = Tabs.Trade:Section({Title = "Auto Trade", TextXAlignment = "Left", TextSize = 17})

local TradeModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/a11bove/kdoaz/refs/heads/main/xzc/fishit/autotrademdl.lua"))()
local Trade = TradeModule(Players, LocalPlayer, ReplicatedStorage, WindUI)

local selectedTradePlayer = nil

local tradePlayerDropdown = Tabs.Trade:Dropdown({
    Title = "Select Player",
    Values = Trade.GetPlayerNames(),
    AllowNone = true,
    Multi = false,
    Callback = function(value)
        selectedTradePlayer = value
        WindUI:Notify({
            Title = "Player Selected", 
            Content = value, 
            Duration = 3
        })
    end
})

Tabs.Trade:Button({
    Title = "Give Item",
    Icon = "gift",
    Justify = "Center",
    Callback = function()
        Trade.SendTradeRequest(selectedTradePlayer)
    end
})

Tabs.Trade:Toggle({
    Title = "Auto Accept Trade",
    Desc = "Automatically accepts incoming trade requests",
    Default = false,
    Callback = function(state)
        Trade.SetAutoAccept(state)
    end
})

Tabs.Trade:Space()

Tabs.Trade:Button({
    Title = "Refresh Player List",
    Icon = "refresh-cw",
    Justify = "Center",
    Callback = function()
        tradePlayerDropdown:Refresh(Trade.GetPlayerNames())
        WindUI:Notify({
            Title = "Refreshed", 
            Content = "Player list updated", 
            Duration = 3
        })
    end
})

Tabs.Utility:Section({Title = "Utility", TextXAlignment = "Left", TextSize = 17})

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

local favtier = Tabs.Utility:Dropdown({
    Title = "Favorite Tier",
    Desc = "Select which item type or rarity you want to auto-favorite.",
    Values = {"Artifact Items", "Epic", "Legendary", "Mythic", "Secret"},
    Default = {},
    Multi = true,
    Callback = function(selected)
        FavoriteTier = selected
        WindUI:Notify({
            Title = "Favorite Tier Selected",
            Description = "Now set to favorite: " .. FavoriteTier,
            Duration = 2
        })
    end
})

local autofav = Tabs.Utility:Toggle({
    Title = "Auto Favorite",
    Desc = "Automatically favorites selected tier in your inventory.",
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

local oxyby = Tabs.Utility:Toggle({
    Title = "Oxygen Bypass",
    Desc = "Not dying underwater.",
    Default = false,
    Callback = function(enabled)
        if enabled then
            StartOxygenBypass()
        else
            StopOxygenBypass()
        end
    end
})

Tabs.Misc:Section({Title = "Identity", TextXAlignment = "Left", TextSize = 17})

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

local hideiden = Tabs.Misc:Toggle({
    Title = "Hide Identity",
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

Tabs.Misc:Section({Title = "Other", TextXAlignment = "Left", TextSize = 17})

local antiafk = Tabs.Misc:Toggle({
    Title = "Anti AFK",
    Desc = "Prevents Roblox from kicking you when idle for 20 minutes.",
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

local recon = Tabs.Misc:Toggle({
    Title = "Auto Reconnect",
    Desc = "Automatically reconnects when you got disconnected.",
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

    local themes = {}
    for themeName,_ in pairs(WindUI:GetThemes()) do
        table.insert(themes, themeName)
    end
    table.sort(themes)

    local savedConfig
    if Window.ConfigManager then
        savedConfig = Window.ConfigManager:CreateConfig("@aokiware!"):Load()
    end

    local defaultTheme = (savedConfig and savedConfig.Theme) or WindUI:GetCurrentTheme()
    local defaultTransparency = (savedConfig and savedConfig.TransparentMode ~= nil) and savedConfig.TransparentMode or true

    local themeDropdown = Tabs.Settings:Dropdown({
        Title = "Select Theme",
        Values = themes,
        Value = defaultTheme,
        Callback = function(theme)
            WindUI:SetTheme(theme)
            WindUI:Notify({
                Title = "Theme Applied",
                Content = theme,
                Icon = "palette",
                Duration = 2
            })

            if Window.ConfigManager then
                local config = Window.ConfigManager:CreateConfig("@aokiware!")
                config:Set("Theme", theme)
                config:Set("TransparentMode", Window.TransparencyEnabled) 
                config:Save()
            end
        end
    })

    local transparentToggle = Tabs.Settings:Toggle({
        Title = "Transparency",
        Desc = "Makes the interface slightly transparent.",
        Value = defaultTransparency,
        Callback = function(state)
            Window:ToggleTransparency(state)
            WindUI.TransparencyValue = state and 0.1 or 0.1
            WindUI:Notify({
                Title = "Transparency",
                Content = state and "Transparency ON" or "Transparency OFF",
                Duration = 2
            })

            if Window.ConfigManager then
                local config = Window.ConfigManager:CreateConfig("Walvy Community")
                config:Set("Theme", WindUI:GetCurrentTheme())
                config:Set("TransparentMode", state)
                config:Save()
            end
        end
    })

    WindUI:SetTheme(defaultTheme)
    Window:ToggleTransparency(defaultTransparency)
    WindUI.TransparencyValue = defaultTransparency and 0.1 or 0.1

Tabs.Settings:Keybind({
        Title = "Toggle UI",
        Desc = "Press a key to toggle the UI",
        Value = "G",
        Callback = function(keyName)
            Window:SetToggleKey(Enum.KeyCode[keyName])
        end
    })

    local configName = ""

Tabs.Settings:Input({
        Title = "Config Name",
        Placeholder = "Enter config name",
        Callback = function(text)
            configName = text
        end
    })

    local filesDropdown
    local function listConfigFiles()
        local files = {}
        local path = "WindUI/" .. Window.Folder .. "/config"
        if not isfolder(path) then
            makefolder(path)
        end
        for _, file in ipairs(listfiles(path)) do
            local name = file:match("([^/]+)%.json$")
            if name then table.insert(files, name) end
        end
        return files
    end

    filesDropdown = Tabs.Settings:Dropdown({
        Title = "Select Config",
        Values = listConfigFiles(),
        Multi = false,
        AllowNone = true,
        Callback = function(selection)
            configName = selection
        end
    })

Tabs.Settings:Button({
        Title = "Refresh List",
        Callback = function()
            filesDropdown:Refresh(listConfigFiles())
        end
    })

Tabs.Settings:Button({
        Title = "Save Config",
        Desc = "Save current theme and transparency",
        Callback = function()
            if configName ~= "" then
                local config = Window.ConfigManager:CreateConfig(configName)
                config:Register("Theme", themeDropdown)
                config:Register("Transparency", transparentToggle)
                config:Save()
                WindUI:Notify({
                    Title = "Config Saved",
                    Content = configName,
                    Duration = 3
                })
            end
        end
    })

Tabs.Settings:Button({
        Title = "Load Config",
        Desc = "Load saved configuration",
        Callback = function()
            if configName ~= "" then
                local config = Window.ConfigManager:CreateConfig(configName)
                local data = config:Load()
                if data then
                    if data.Theme and table.find(themes, data.Theme) then
                        themeDropdown:Select(data.Theme)
                        WindUI:SetTheme(data.Theme)
                    end
                    if data.Transparency ~= nil then
                        transparentToggle:Set(data.Transparency)
                        Window:ToggleTransparency(data.Transparency)
                        WindUI.TransparencyValue = data.Transparency and 0.1 or 1
                    end
                    WindUI:Notify({
                        Title = "Config Loaded",
                        Content = configName,
                        Duration = 3
                    })
                else
                    WindUI:Notify({
                        Title = "Config Error",
                        Content = "Config file not found",
                        Duration = 3
                    })
                end
            end
        end
    })

WindUI:Notify({
    Title = "@aikoware | Fish It",
    Content = "Script Loaded!",
    Duration = 3,
})

Window:SelectTab(1)
