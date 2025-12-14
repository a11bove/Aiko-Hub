repeat task.wait() until game:IsLoaded()

local settings = {
    playerGui = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui"),
    interface = nil,
    fishingCatchFrame = nil,
    timingBar = nil,
    successArea = nil
}

settings.interface = settings.playerGui and settings.playerGui:FindFirstChild("Interface")
settings.fishingCatchFrame = settings.interface and settings.interface:FindFirstChild("FishingCatchFrame")
settings.timingBar = settings.fishingCatchFrame and settings.fishingCatchFrame:FindFirstChild("TimingBar")
settings.successArea = settings.timingBar and settings.timingBar:FindFirstChild("SuccessArea")

if settings.successArea then
    settings.successArea:GetPropertyChangedSignal("Size"):Connect(function()
        settings.successArea.Position = UDim2.new(0.5, 0, 0, 0)
        settings.successArea.Size = UDim2.new(1, 0, 1, 0)
    end)
end

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "@aiko",
    Text = "99 Nights in The Forest Script Loaded!",
    Icon = "rbxassetid://140356301069419",
    Duration = 2
})

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

WindUI:AddTheme({
    Name = "Aurora",
    Accent = WindUI:Gradient({
    ["0"] = { Color = Color3.fromHex("#1C446E"), Transparency = 0 },
    ["100"] = { Color = Color3.fromHex("#521C6E"), Transparency = 0 },
}, {
    Rotation = 67,
}),
    Dialog = Color3.fromHex("#0E0E1A"),
    Outline = Color3.fromHex("#00C3FF"),
    Text = Color3.fromHex("#FFFFFF"),
    Placeholder = Color3.fromHex("#9AA0A6"),
    Button = WindUI:Gradient({
        ["0"] = { Color = Color3.fromHex("#2B2B47"), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#005CFF"), Transparency = 0 }
    }, { Rotation = 45 }),
    Icon = WindUI:Gradient({
        ["0"] = { Color = Color3.fromHex("#D200FF"), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#00A1FF"), Transparency = 0 }
    }, { Rotation = 45 })
})

WindUI:AddTheme({
    Name = "Royal Void",
    Accent = WindUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#FF3366"), Transparency = 0 },
        ["50"]  = { Color = Color3.fromHex("#1E90FF"), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#9B30FF"), Transparency = 0 },
    }, {
        Rotation = 45,
    }),

    Dialog = Color3.fromHex("#0A0011"),
    Outline = Color3.fromHex("#1E90FF"),
    Text = Color3.fromHex("#FFE6FF"),
    Placeholder = Color3.fromHex("#B34A7F"),
    Background = Color3.fromHex("#050008"),
    Button = Color3.fromHex("#FF00AA"),
    Icon = Color3.fromHex("#0066CC")
})

local Confirmed = false

repeat task.wait() until Confirmed

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local rs = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Lighting = game:GetService("Lighting")
local effect = Lighting:FindFirstChild("VibrantEffect")
local vibrantEffect = Lighting:FindFirstChild("VibrantEffect")
local RunService = game:GetService("RunService")

Lighting.ClockTime = 14
Lighting.GlobalShadows = false

WindUI:AddTheme({
    Name = "Dark",
    Accent = "#18181b",
    Dialog = "#18181b", 
    Outline = "#FFFFFF",
    Text = "#FFFFFF",
    Placeholder = "#999999",
    Background = "#0e0e10",
    Button = "#52525b",
    Icon = "#a1a1aa"
})

WindUI:AddTheme({
    Name = "Light",
    Accent = "#f4f4f5",
    Dialog = "#f4f4f5",
    Outline = "#000000", 
    Text = "#000000",
    Placeholder = "#666666",
    Background = "#ffffff",
    Button = "#e4e4e7",
    Icon = "#52525b"
})

WindUI:AddTheme({
    Name = "Gray",
    Accent = "#374151",
    Dialog = "#374151",
    Outline = "#d1d5db", 
    Text = "#f9fafb",
    Placeholder = "#9ca3af",
    Background = "#1f2937",
    Button = "#4b5563",
    Icon = "#d1d5db"
})

WindUI:AddTheme({
    Name = "Blue",
    Accent = "#1e40af",
    Dialog = "#1e3a8a",
    Outline = "#93c5fd", 
    Text = "#f0f9ff",
    Placeholder = "#60a5fa",
    Background = "#1e293b",
    Button = "#3b82f6",
    Icon = "#93c5fd"
})

WindUI:AddTheme({
    Name = "Green",
    Accent = "#059669",
    Dialog = "#047857",
    Outline = "#6ee7b7", 
    Text = "#ecfdf5",
    Placeholder = "#34d399",
    Background = "#064e3b",
    Button = "#10b981",
    Icon = "#6ee7b7"
})

WindUI:AddTheme({
    Name = "Purple",
    Accent = "#7c3aed",
    Dialog = "#6d28d9",
    Outline = "#c4b5fd", 
    Text = "#faf5ff",
    Placeholder = "#a78bfa",
    Background = "#581c87",
    Button = "#8b5cf6",
    Icon = "#c4b5fd"
})

WindUI:AddTheme({
    Name = "Sunset Orange",
    Accent = "#ea580c",
    Dialog = "#c2410c",
    Outline = "#fdba74",
    Text = "#fff7ed",
    Placeholder = "#fb923c",
    Background = "#341a00",
    Button = "#f97316",
    Icon = "#fed7aa",
})

WindUI:AddTheme({
    Name = "Forest Green",
    Accent = "#166534",
    Dialog = "#14532d",
    Outline = "#86efac",
    Text = "#f0fdf4",
    Placeholder = "#4ade80",
    Background = "#052e16",
    Button = "#16a34a",
    Icon = "#bbf7d0",
})

WindUI:SetNotificationLower(true)

local themes = {"Dark", "Light", "Gray", "Blue", "Green", "Purple", "Sunset Orange", "Forest Green", "Aurora", "Royal Void"}
local currentThemeIndex = 1

if not getgenv().TransparencyEnabled then
    getgenv().TransparencyEnabled = true
end

local VirtualUser = game:GetService("VirtualUser")

loadstring(game:HttpGet("https://raw.githubusercontent.com/a11bove/Aiko-Hub/refs/heads/main/nitf/func.lua"))()

function gradient(text, startColor, endColor)
    local result = ""
    local length = #text
    for i = 1, length do
        local t = (i - 1) / math.max(length - 1, 1)
        local r = math.floor((startColor.R + ((endColor.R - startColor.R) * t)) * 255)
        local g = math.floor((startColor.G + ((endColor.G - startColor.G) * t)) * 255)
        local b = math.floor((startColor.B + ((endColor.B - startColor.B) * t)) * 255)
        local char = text:sub(i, i)
        result = result .. '<font color="rgb(' .. r .. "," .. g .. "," .. b .. ')">' .. char .. "</font>"
    end
    return result
end

local Window = WindUI:CreateWindow({
    Title = "@aiko | 99 Nights in The Forest",
    Icon = "rbxassetid://140356301069419", 
    Author = gradient("made by untog !", Color3.fromHex("#d5eff9"), Color3.fromHex("#87cefa")),
    -- Folder = "",
    Size = UDim2.fromOffset(500, 350),
    Theme = "Aurora",
    Transparent = getgenv().TransparencyEnabled,
    Resizable = true,
    SideBarWidth = 150,
    HideSearchBar = false,
    ScrollBarEnabled = true,
})

Window:SetToggleKey(Enum.KeyCode.V)

pcall(function()
    Window:CreateTopbarButton("TransparencyToggle", "eye", function()
        if getgenv().TransparencyEnabled then
            getgenv().TransparencyEnabled = false
            pcall(function() Window:ToggleTransparency(false) end)

            WindUI:Notify({
                Title = "Transparency", 
                Content = "Transparency disabled",
                Duration = 3,
                Icon = "eye"
            })
        else
            getgenv().TransparencyEnabled = true
            pcall(function() Window:ToggleTransparency(true) end)

            WindUI:Notify({
                Title = "Transparency",
                Content = "Transparency enabled", 
                Duration = 3,
                Icon = "eye-off"
            })
        end

    end, 990)
end)

Window:EditOpenButton({
    Title = "@aiko",
    Icon = "rbxassetid://140356301069419",
    CornerRadius = UDim.new(0, 16),
    StrokeThickness = 2,
    Color = ColorSequence.new(Color3.fromRGB(255, 0, 255), Color3.fromRGB(0, 0, 255)),
    Draggable = true
})

local Tabs = {}

Tabs.Home = Window:Tab({
    Title = "Home",
    Icon = "house",
    Desc = ""
})
Tabs.Combat = Window:Tab({
    Title = "Combat",
    Icon = "sword",
    Desc = ""
})
Tabs.Fun = Window:Tab({
    Title = "Fun",
    Icon = "star",
    Desc = ""
})
Tabs.Camp = Window:Tab({
    Title = "Auto",
    Icon = "repeat-2",
    Desc = ""
})
Tabs.br = Window:Tab({
    Title = "Bring",
    Icon = "package",
    Desc = ""
})
Tabs.Fly = Window:Tab({
    Title = "Player",
    Icon = "user",
    Desc = ""
})
Tabs.esp = Window:Tab({
    Title = "Esp",
    Icon = "eye",
    Desc = ""
})
Tabs.Tp = Window:Tab({
    Title = "Teleport",
    Icon = "map",
    Desc = ""
})

Tabs.Vision = Window:Tab({
    Title = "Environment",
    Icon = "earth",
    Desc = ""
})
Tabs.Codes = Window:Tab({
    Title = "Codes",
    Icon = "ticket",
    Desc = ""
})

Tabs.Info = Window:Tab({
    Title = "Information",
    Icon = "badge-info",
    Desc = ""
})
Tabs.Misc = Window:Tab({
    Title = "Other",
    Icon = "chart-bar-big",
    Desc = ""
})

Window:SelectTab(1)

Tabs.Home:Section({
    Title = "Info",
    Icon = "info",
})
Tabs.Home:Toggle({
    Title = "Anti AFK",
    Icon = "activity",
    Default = true,
    Callback = function(state)
        if state then
            task.spawn(function()
                while state do
                    if not LocalPlayer then
                        return
                    end;
                    VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
                    VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
                    task.wait(40)
                end
            end)
        else
        end
    end
})
Tabs.Home:Divider()

Tabs.Home:Keybind({
    Title = "Keybind",
    Desc = "Keybind to open and close ui",
    Value = "F",
    Callback = function(v)
        Window:SetToggleKey(Enum.KeyCode[v])
    end
})

VisualSettings = Tabs.Home:Section({ Title = "Visual Setting", Icon = "settings-2" })

ShowFps = VisualSettings:Toggle({
    Title = "Show Fps",
    Default = true,
    Callback = function(val)
        showFPS = val
        fpsText.Visible = val
    end
})

ShowPing = VisualSettings:Toggle({
    Title = "Show Ping",
    Default = true,
    Callback = function(val)
        showPing = val
        msText.Visible = val
    end
})

ShowPlayers = VisualSettings:Toggle({
    Title = "Show Players",
    Default = false,
    Callback = function(val)
        showPlayers = val
        playersText.Visible = val
    end
})
ShowFps:Set(true)
ShowPing:Set(true)
Grapics = Tabs.Home:Section({
    Title = "Grapics",
    Icon = "gpu"
})

Tabs.Home:Paragraph({
    Title = "Warning:",
    Desc = "I'm not responsible for any bans or other punishments you may receive for using this script.",
})

Tabs.Combat:Section({ Title = "Aura", Icon = "star" })

Tabs.Combat:Toggle({
    Title = "Kill Aura",
    Value = false,
    Callback = function(state)
        killAuraToggle = state
        if state then
            task.spawn(killAuraLoop)
         else
            local tool, _ = getAnyToolWithDamageID(false)
            unequipTool(tool)
        end
    end
})

Tabs.Combat:Toggle({
    Title = "Chop Aura",
    Value = false,
    Callback = function(state)
        chopAuraToggle = state
        if state then
            task.spawn(chopAuraLoop)
        else
            local tool, _ = getAnyToolWithDamageID(true)
            unequipTool(tool)
        end
    end
})

Tabs.Combat:Section({ Title = "Settings", Icon = "settings" })

Tabs.Combat:Slider({
    Title = "Aura Radius",
    Value = { Min = 1, Max = 100, Default = 50 },
    Callback = function(value)
        auraRadius = math.clamp(value, 1, 100)
    end
})

Tabs.Combat:Section({
    Title = "HitBox Mobs",
    Icon = "swords",
})
Tabs.Combat:Dropdown({
    Title = "Select Mobs to add Hitbox",
    Values = MobsList,
    Multi = true,
    AllowNone = false,
    Callback = function(options) 
        SelectedMobs = options
        UpdateHitboxes()
    end
})

Tabs.Combat:Slider({
    Title = "Hitbox Size",
    Step = 1,
    Value = {
        Min = 20,
        Max = 100,
        Default = 50,
    },
    Callback = function(value)
        HitBoxSize = value
        if HitboxesActive then
            for _, mob in ipairs(MobsFolder:GetChildren()) do
                if mob:IsA("Model") and table.find(SelectedMobs, mob.Name) then
                    local hitbox = mob:FindFirstChild("HitBoxForMob")
                    if hitbox then
                        hitbox.Size = Vector3.new(HitBoxSize, HitBoxSize, HitBoxSize)
                    end
                end
            end
        end
    end
})

Tabs.Combat:Toggle({
    Title = "Add Hitbox",
    Icon = "sword",
    Type = "Toggle",
    Default = false,
    Callback = function(state) 
        if state then
            pcall(function()
                AddAllHitboxes()
            end)
        else
                RemoveAllHitboxes()
        end
    end
})

Tabs.Misc:Section({ Title = "Chests", Icon = "package-2" })

Tabs.Misc:Toggle({
    Title = "Auto Open Chests",
    Locked = false,
    Value = false,
    Callback = function(v)
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
        if not _G.AutoChestData then
            _G.AutoChestData = {running = false, originalCFrame = nil}
        end

        local function getChests()
            local chests = {}
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("Model") and string.find(obj.Name, "Item Chest") then
                    table.insert(chests, obj)
                end
            end
            return chests
        end

        local function getPrompt(model)
            local prompts = {}
            for _, obj in ipairs(model:GetDescendants()) do
                if obj:IsA("ProximityPrompt") then
                    table.insert(prompts, obj)
                end
            end
            return prompts
        end

        if v then
            if _G.AutoChestData.running then return end
            _G.AutoChestData.running = true
            _G.AutoChestData.originalCFrame = humanoidRootPart.CFrame
            task.spawn(function()
                while _G.AutoChestData.running do
                    local chests = getChests()
                    for _, chest in ipairs(chests) do
                        if not _G.AutoChestData.running then break end
                        local part = chest.PrimaryPart or chest:FindFirstChildWhichIsA("BasePart")
                        if part then
                            humanoidRootPart.CFrame = part.CFrame + Vector3.new(0, 6, 0)
                            local prompts = getPrompt(chest)
                            for _, prompt in ipairs(prompts) do
                                fireproximityprompt(prompt, math.huge)
                            end
                            local t = tick()
                            while _G.AutoChestData.running and tick() - t < 4 do task.wait() end
                        end
                    end
                    task.wait(0.1)
                end
            end)
        else
            _G.AutoChestData.running = false
            if _G.AutoChestData.originalCFrame then
                humanoidRootPart.CFrame = _G.AutoChestData.originalCFrame
            end
        end
    end
})

Tabs.Misc:Section({ Title = "Auto Feed", Icon = "utensils" })

Tabs.Misc:Dropdown({
    Title = "Select Food to eat",
    Values = alimentos,
    Value = selectedFood,
    Multi = true,
    Callback = function(value)
        selectedFood = value
    end
})

Tabs.Misc:Input({
    Title = "Eat Amount",
    Desc = "Eat when hunger reaches this %",
    Value = tostring(hungerThreshold),
    Placeholder = "Ex 50",
    Numeric = true,
    Callback = function(value)
        local n = tonumber(value)
        if n then
            hungerThreshold = math.clamp(n, 0, 100)
        end
    end
})

Tabs.Misc:Toggle({
    Title = "Auto Eat",
    Desc = "",
    Value = false,
    Callback = function(state)
        autoFeedToggle = state
        if state then
            task.spawn(function()
                while autoFeedToggle do
                    task.wait(0.05)

                    local currentHunger = ghn()
                    if currentHunger <= hungerThreshold and #selectedFood > 0 then
                        while currentHunger < 100 and autoFeedToggle do
                            local ateSomething = false

                            for _, foodName in ipairs(selectedFood) do
                                for _, item in ipairs(Workspace.Items:GetChildren()) do
                                    if item.Name == foodName and item.Parent then
                                        pcall(function()
                                            ReplicatedStorage.RemoteEvents.RequestConsumeItem:InvokeServer(item)
                                        end)
                                        ateSomething = true
                                        task.wait(0.05)
                                        currentHunger = ghn()
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
})

Tabs.Camp:Section({
    Title = "Auto Plant",
    Icon = "sprout",
})
Tabs.Camp:Toggle({
    Title = "AutoPlant",
    Desc = "Plant Sapling for base",
    Type = "Toggle",
    Default = false,
    Callback = function(state) 
        if state then
            pcall(function()
                StartAutoPlant()
            end)
        else
            StopAutoPlant()
        end
    end
})

Tabs.Camp:Slider({
    Title = "Plant Radius",
    Step = 1,
    Value = {
        Min = 50,
        Max = 100,
        Default = 50,
    },
    Callback = function(value)
        _G.AutoSapRadius = value
    end
})


Tabs.Camp:Section({ Title = "Auto Upgrade Campfire", Icon = "flame" })

local selectedCampfireItems = {}

Tabs.Camp:Dropdown({
    Title = "Choose items to Upgrade Campfire",
    Values = campfireFuelItems,
    Multi = true,
    AllowNone = true,
    Callback = function(options)
        selectedCampfireItems = options or {}
    end
})

Tabs.Camp:Toggle({
    Title = "Auto Upgrade Campfire",
    Value = false,
    Callback = function(checked)
        autoUpgradeCampfireEnabled = checked
        if checked then
            task.spawn(function()
                while autoUpgradeCampfireEnabled do
                    if #selectedCampfireItems > 0 then
                        for _, selectedItem in ipairs(selectedCampfireItems) do
                            local items = {}

                            for _, item in ipairs(workspace:WaitForChild("Items"):GetChildren()) do
                                if item.Name == selectedItem then
                                    table.insert(items, item)
                                end
                            end

                            local count = math.min(10, #items)
                            for i = 1, count do
                                moveItemToPos(items[i], campfireDropPos)
                            end
                        end
                    end
                    task.wait(1)
                end
            end)
        end
    end
})

Tabs.Camp:Section({ Title = "Auto Scrap", Icon = "cog" })

Tabs.Camp:Dropdown({
    Title = "Choose items to Auto Scrap",
    Values = scrapjunkItems,
    Multi = false,
    AllowNone = true,
    Callback = function(option)
        selectedScrapItem = option
    end
})

Tabs.Camp:Toggle({
    Title = "Auto Scrap",
    Value = false,
    Callback = function(checked)
        autoScrapItemsEnabled = checked
        if checked then
            task.spawn(function()
                while autoScrapItemsEnabled do
                    if selectedScrapItem then
                        local items = {}

                        for _, item in ipairs(workspace:WaitForChild("Items"):GetChildren()) do
                            if item.Name == selectedScrapItem then
                                table.insert(items, item)
                            end
                        end

                        local count = math.min(10, #items)
                        for i = 1, count do
                            moveItemToPos(items[i], autoScrapPos)
                        end
                    end

                    task.wait(1)
                end
            end)
        end
    end
})


Tabs.Camp:Section({ Title = "Auto Cook Food", Icon = "flame" })

Tabs.Camp:Dropdown({
    Title = "Food List",
    Values = autocookItems,
    Multi = true,
    AllowNone = true,
    Callback = function(options)
        for _, itemName in ipairs(autocookItems) do
            autoCookEnabledItems[itemName] = table.find(options, itemName) ~= nil
        end
    end
})

Tabs.Camp:Toggle({
    Title = "Auto Cook Food",
    Value = false,
    Callback = function(state)
        autoCookEnabled = state
    end
})

coroutine.wrap(function()
    while true do
        if autoCookEnabled then
            for itemName, enabled in pairs(autoCookEnabledItems) do
                if enabled then
                    for _, item in ipairs(Workspace:WaitForChild("Items"):GetChildren()) do
                        if item.Name == itemName then
                            moveItemToPos(item, campfireDropPos)
                        end
                    end
                end
            end
        end
        task.wait(0.5)
    end
end)()

Tabs.Camp:Section({ Title = "Auto Craft Items", Icon = "hammer" })

Tabs.Camp:Dropdown({
    Title = "Choose items to craft",
    Values = craftableItems,
    Multi = true,
    AllowNone = true,
    Callback = function(options)
        selectedCraftItems = options or {}
    end
})

Tabs.Camp:Toggle({
    Title = "Auto Craft Items",
    Value = false,
    Callback = function(checked)
        autoCraftEnabled = checked
        if checked then
            task.spawn(function()
                while autoCraftEnabled do
                    if #selectedCraftItems > 0 then
                        for _, itemName in ipairs(selectedCraftItems) do
                            local args = { itemName }
                            game:GetService("ReplicatedStorage")
                                :WaitForChild("RemoteEvents")
                                :WaitForChild("CraftItem")
                                :InvokeServer(unpack(args))
                        end
                    end
                    task.wait(0.5)
                end
            end)
        end
    end
})

Tabs.Camp:Section({ Title = "Crafting Bench", Icon = "wrench" })

Tabs.Camp:Dropdown({
    Title = "Choose Bench to upgrade",
    Values = craftingBenchItems,
    Multi = true,
    AllowNone = true,
    Callback = function(options)
        selectedBenchItems = options or {}
    end
})

Tabs.Camp:Toggle({
    Title = "Auto Upgrade Bench",
    Value = false,
    Callback = function(checked)
        autoUpgradeBenchEnabled = checked
        if checked then
            task.spawn(function()
                while autoUpgradeBenchEnabled do
                    if #selectedBenchItems > 0 then
                        for _, bench in ipairs(selectedBenchItems) do
                            local args = { bench }
                            game:GetService("ReplicatedStorage")
                                :WaitForChild("RemoteEvents")
                                :WaitForChild("CraftItem")
                                :InvokeServer(unpack(args))
                        end
                    end
                    task.wait(0.5)
                end
            end)
        end
    end
})

Tabs.Tp:Section({ Title = "Scan Map", Icon = "map" })

Tabs.Tp:Toggle({
    Title = "Scan Map",
    Desc = "Might not work for some executors",
    Default = false,
    Callback = function(state)
        scan_map = state

        if not state then
            if type(tp1) == "function" and scan_map_was_on then
                tp1()
            end
            scan_map_was_on = false
            return
        else
            scan_map_was_on = true
        end

        task.spawn(function()
            local character = player.Character or player.CharacterAdded:Wait()
            local hrp = character:WaitForChild("HumanoidRootPart", 3)
            if not hrp then return end

            local map = workspace:FindFirstChild("Map")
            if not map then return end

            local foliage = map:FindFirstChild("Foliage") or map:FindFirstChild("Landmarks")
            if not foliage then return end

            while scan_map do
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
                    if not scan_map then break end
                    if trunk and trunk.Parent then
                        local treeCFrame = trunk.CFrame
                        local rightVector = treeCFrame.RightVector
                        local targetPosition = treeCFrame.Position + rightVector * 69 + Vector3.new(0, 15, 69)

                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(targetPosition)

                        local footPart = Instance.new("Part")
                        footPart.Size = Vector3.new(10, 1, 10)
                        footPart.Anchored = true
                        footPart.CanCollide = true
                        footPart.Transparency = 1
                        footPart.BrickColor = BrickColor.new("Bright yellow")
                        footPart.CFrame = CFrame.new(targetPosition - Vector3.new(0, 3, 0))
                        footPart.Parent = workspace

                        game.Debris:AddItem(footPart, 1)

                        task.wait(0.01)
                    end
                end
                task.wait(0.25)
            end
        end)
    end
})

Tabs.Tp:Section({ Title = "Teleport", Icon = "map-pin" })

Tabs.Tp:Button({
    Title = "Teleport to Campfire",
    Locked = false,
    Callback = function()
        tp1()
    end
})

Tabs.Tp:Button({
    Title = "Teleport to Stronghold",
    Locked = false,
    Callback = function()
        tp2()
    end
})

Tabs.Tp:Button({
    Title = "Teleport to Safe Zone",
    Callback = function()
        if not workspace:FindFirstChild("SafeZonePart") then
            local createpart = Instance.new("Part")
            createpart.Name = "SafeZonePart"
            createpart.Size = Vector3.new(30, 3, 30)
            createpart.Position = Vector3.new(0, 350, 0)
            createpart.Anchored = true
            createpart.CanCollide = true
            createpart.Transparency = 0.8
            createpart.Color = Color3.fromRGB(255, 0, 0)
            createpart.Parent = workspace
        end
        local player = game:GetService("Players").LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local hrp = character:WaitForChild("HumanoidRootPart")
        hrp.CFrame = CFrame.new(0, 360, 0)
    end
})

Tabs.Tp:Button({
    Title = "Teleport to Trader",
    Callback = function()
        local pos = Vector3.new(-37.08, 3.98, -16.33)
        local player = game:GetService("Players").LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local hrp = character:WaitForChild("HumanoidRootPart")
        hrp.CFrame = CFrame.new(pos)
    end
})

Tabs.Tp:Section({ Title = "Tree", Icon = "tree-deciduous" })

Tabs.Tp:Button({
    Title = "Teleport to Random Tree",
    Callback = function()
        local player = Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local hrp = character:FindFirstChild("HumanoidRootPart", 3)
        if not hrp then return end

        local map = workspace:FindFirstChild("Map")
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
})

Tabs.Tp:Section({ Title = "Children", Icon = "eye" })

local MobDropdown = Tabs.Tp:Dropdown({
    Title = "Select Child",
    Values = currentMobNames,
    Multi = false,
    AllowNone = true,
    Callback = function(options)
        selectedMob = options[#options] or currentMobNames[1] or nil
    end
})

Tabs.Tp:Button({
    Title = "Refresh List",
    Locked = false,
    Callback = function()
        currentMobs, currentMobNames = getMobs()
        if #currentMobNames > 0 then
            selectedMob = currentMobNames[1]
            MobDropdown:Refresh(currentMobNames)
        else
            selectedMob = nil
            MobDropdown:Refresh({ "No child found" })
        end
    end
})

Tabs.Tp:Button({
    Title = "Teleport to Child",
    Locked = false,
    Callback = function()
        if selectedMob and currentMobs then
            for i, name in ipairs(currentMobNames) do
                if name == selectedMob then
                    local targetMob = currentMobs[i]
                    if targetMob then
                        local part = targetMob.PrimaryPart or targetMob:FindFirstChildWhichIsA("BasePart")
                        if part and game.Players.LocalPlayer.Character then
                            local hrp = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                            if hrp then
                                hrp.CFrame = part.CFrame + Vector3.new(0, 5, 0)
                            end
                        end
                    end
                    break
                end
            end
        end
    end
})


Tabs.Tp:Section({ Title = "Chest", Icon = "box" })

local ChestDropdown = Tabs.Tp:Dropdown({
    Title = "Select Chest",
    Values = currentChestNames,
    Multi = false,
    AllowNone = true,
    Callback = function(options)
        selectedChest = options[#options] or currentChestNames[1] or nil
    end
})

Tabs.Tp:Button({
    Title = "Refresh List",
    Locked = false,
    Callback = function()
        currentChests, currentChestNames = getChests()
        if #currentChestNames > 0 then
            selectedChest = currentChestNames[1]
            ChestDropdown:Refresh(currentChestNames)
        else
            selectedChest = nil
            ChestDropdown:Refresh({ "No chests found" })
        end
    end
})

Tabs.Tp:Button({
    Title = "Teleport to Chest",
    Locked = false,
    Callback = function()
        if selectedChest and currentChests then
            local chestIndex = 1
            for i, name in ipairs(currentChestNames) do
                if name == selectedChest then
                    chestIndex = i
                    break
                end
            end
            local targetChest = currentChests[chestIndex]
            if targetChest then
                local part = targetChest.PrimaryPart or targetChest:FindFirstChildWhichIsA("BasePart")
                if part and game.Players.LocalPlayer.Character then
                    local hrp = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        hrp.CFrame = part.CFrame + Vector3.new(0, 5, 0)
                    end
                end
            end
        end
    end
})

Tabs.br:Toggle({
    Title = "Scan Map",
    Default = false,
    Callback = function(state)
        scan_map = state

        if not state then
            if type(tp1) == "function" and scan_map_was_on then
                tp1()
            end
            scan_map_was_on = false
            return
        else
            scan_map_was_on = true
        end

        task.spawn(function()
            local player = Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            local hrp = character:WaitForChild("HumanoidRootPart", 3)
            if not hrp then return end

            local map = workspace:FindFirstChild("Map")
            if not map then return end

            local foliage = map:FindFirstChild("Foliage") or map:FindFirstChild("Landmarks")
            if not foliage then return end

            while scan_map do
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
                    if not scan_map then break end
                    if trunk and trunk.Parent then
                        local treeCFrame = trunk.CFrame
                        local rightVector = treeCFrame.RightVector
                        local targetPosition = treeCFrame.Position + rightVector * 69 + Vector3.new(0, 15, 69)

                        hrp.CFrame = CFrame.new(targetPosition)

                        local footPart = Instance.new("Part")
                        footPart.Size = Vector3.new(10, 1, 10)
                        footPart.Anchored = true
                        footPart.CanCollide = true
                        footPart.Transparency = 1
                        footPart.BrickColor = BrickColor.new("Bright yellow")
                        footPart.CFrame = CFrame.new(targetPosition - Vector3.new(0, 3, 0))
                        footPart.Parent = workspace

                        game.Debris:AddItem(footPart, 1)

                        task.wait(0.01)
                    end
                end
                task.wait(0.25)
            end
        end)
    end
})

Tabs.br:Button({
    Title = "Reveal Whole Map",
    Locked = false,
    Callback = function()
        local boundaries = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Boundaries")
        if boundaries then
            for _, obj in pairs(boundaries:GetChildren()) do
                obj:Destroy()
            end
        end
    end
})

Tabs.br:Section({ Title = "Blue Print", Icon = "hammer" })

Tabs.br:Dropdown({
    Title = "Select Blueprints to bring",
    Values = selectedBlueprintItems,
    Multi = true,
    AllowNone = true,
    Callback = function(options)
        selectedBlueprintItems = options
    end
})

Tabs.br:Toggle({
    Title = "Bring Blueprints",
    Default = false,
    Callback = function(value)
        BlueprintToggleEnabled = value

        if value then
            if #selectedBlueprintItems > 0 then
                BlueprintLoopRunning = true
                spawn(function()
                    while BlueprintLoopRunning and BlueprintToggleEnabled do
                        if #selectedBlueprintItems > 0 and BlueprintToggleEnabled then
                            bypassBringSystem(selectedBlueprintItems, function() return BlueprintToggleEnabled end)
                        end

                        local waitTime = 0
                        while waitTime < 3 and BlueprintToggleEnabled and BlueprintLoopRunning do
                            wait(0.1)
                            waitTime = waitTime + 0.1
                        end
                    end
                    BlueprintLoopRunning = false
                end)
            else
                BlueprintToggleEnabled = false
            end
        else
            BlueprintLoopRunning = false
        end
    end
})

Tabs.br:Section({ Title = "Pelts", Icon = "shirt" })

Tabs.br:Dropdown({
    Title = "Select Pelts to bring",
    Values = PeltsItems,
    Multi = true,
    AllowNone = true,
    Callback = function(options)
        selectedPeltsItems = options
    end
})

Tabs.br:Toggle({
    Title = "Bring Pelts Items",
    Default = false,
    Callback = function(value)
        PeltsToggleEnabled = value

        if value then
            if #selectedPeltsItems > 0 then
                PeltsLoopRunning = true
                spawn(function()
                    while PeltsLoopRunning and PeltsToggleEnabled do
                        if #selectedPeltsItems > 0 and PeltsToggleEnabled then
                            bypassBringSystem(selectedPeltsItems, function() return PeltsToggleEnabled end)
                        end

                        local waitTime = 0
                        while waitTime < 3 and PeltsToggleEnabled and PeltsLoopRunning do
                            wait(0.1)
                            waitTime = waitTime + 0.1
                        end
                    end
                    PeltsLoopRunning = false
                end)
            else
                PeltsToggleEnabled = false
            end
        else
            PeltsLoopRunning = false
        end
    end
})

Tabs.br:Section({ Title = "Junk", Icon = "box" })

Tabs.br:Dropdown({
    Title = "Select Junk Items to bring",
    Values = junkItems,
    Multi = true,
    AllowNone = true,
    Callback = function(options)
        selectedJunkItems = options
    end
})

Tabs.br:Toggle({
    Title = "Bring Junk Items",
    Default = false,
    Callback = function(value)
        junkToggleEnabled = value

        if value then
            if #selectedJunkItems > 0 then
                junkLoopRunning = true
                spawn(function()
                    while junkLoopRunning and junkToggleEnabled do
                        if #selectedJunkItems > 0 and junkToggleEnabled then
                            bypassBringSystem(selectedJunkItems, function() return junkToggleEnabled end)
                        end

                        local waitTime = 0
                        while waitTime < 3 and junkToggleEnabled and junkLoopRunning do
                            wait(0.1)
                            waitTime = waitTime + 0.1
                        end
                    end
                    junkLoopRunning = false
                end)
            else
                junkToggleEnabled = false
            end
        else
            junkLoopRunning = false
        end
    end
})

Tabs.br:Section({ Title = "Fuel", Icon = "flame" })

Tabs.br:Dropdown({
    Title = "Select Fuels to bring",
    Values = fuelItems,
    Multi = true,
    AllowNone = true,
    Callback = function(options)
        selectedFuelItems = options
    end
})

Tabs.br:Toggle({
    Title = "Bring Fuel Items",
    Default = false,
    Callback = function(value)
        fuelToggleEnabled = value

        if value then
            if #selectedFuelItems > 0 then
                fuelLoopRunning = true
                spawn(function()
                    while fuelLoopRunning and fuelToggleEnabled do
                        if #selectedFuelItems > 0 and fuelToggleEnabled then
                            bypassBringSystem(selectedFuelItems, function() return fuelToggleEnabled end)
                        end

                        local waitTime = 0
                        while waitTime < 3 and fuelToggleEnabled and fuelLoopRunning do
                            wait(0.1)
                            waitTime = waitTime + 0.1
                        end
                    end
                    fuelLoopRunning = false
                end)
            else
                fuelToggleEnabled = false
            end
        else
            fuelLoopRunning = false
        end
    end
})

Tabs.br:Section({ Title = "Food", Icon = "utensils" })

Tabs.br:Dropdown({
    Title = "Select Foods to bring",
    Values = foodItems,
    Multi = true,
    AllowNone = true,
    Callback = function(options)
        selectedFoodItems = options
    end
})

Tabs.br:Toggle({
    Title = "Bring Food items",
    Default = false,
    Callback = function(value)
        foodToggleEnabled = value

        if value then
            if #selectedFoodItems > 0 then
                foodLoopRunning = true
                spawn(function()
                    while foodLoopRunning and foodToggleEnabled do
                        if #selectedFoodItems > 0 and foodToggleEnabled then
                            bypassBringSystem(selectedFoodItems, function() return foodToggleEnabled end)
                        end


                        local waitTime = 0
                        while waitTime < 3 and foodToggleEnabled and foodLoopRunning do
                            wait(0.1)
                            waitTime = waitTime + 0.1
                        end
                    end
                    foodLoopRunning = false                 
                end)
            else                
                foodToggleEnabled = false
            end
        else
            foodLoopRunning = false          
        end
    end
})

Tabs.br:Section({ Title = "Medicine", Icon = "bandage" })

Tabs.br:Dropdown({
    Title = "Select Medical Items to bring",
    Values = medicalItems,
    Multi = true,
    AllowNone = true,
    Callback = function(options)
        selectedMedicalItems = options
    end
})

Tabs.br:Toggle({
    Title = "Bring Medical Items",
    Default = false,
    Callback = function(value)
        medicalToggleEnabled = value

        if value then
            if #selectedMedicalItems > 0 then
                medicalLoopRunning = true
                spawn(function()
                    while medicalLoopRunning and medicalToggleEnabled do
                        if #selectedMedicalItems > 0 and medicalToggleEnabled then
                            bypassBringSystem(selectedMedicalItems, function() return medicalToggleEnabled end)
                        end


                        local waitTime = 0
                        while waitTime < 3 and medicalToggleEnabled and medicalLoopRunning do
                            wait(0.1)
                            waitTime = waitTime + 0.1
                        end
                    end
                    medicalLoopRunning = false
                end)
            else
                medicalToggleEnabled = false
            end
        else
            medicalLoopRunning = false
        end
    end
})

Tabs.br:Section({ Title = "Mobs", Icon = "bow-arrow" })

Tabs.br:Dropdown({
    Title = "Select Mobs to bring",
    Values = cultistItems,
    Multi = true,
    AllowNone = true,
    Callback = function(options)
        selectedCultistItems = options
    end
})

Tabs.br:Toggle({
    Title = "Bring Mob",
    Default = false,
    Callback = function(value)
        cultistToggleEnabled = value

        if value then
            if #selectedCultistItems > 0 then
                cultistLoopRunning = true
                spawn(function()
                    while cultistLoopRunning and cultistToggleEnabled do
                        if #selectedCultistItems > 0 and cultistToggleEnabled then
                            bypassBringSystem(selectedCultistItems, function() return cultistToggleEnabled end)
                        end


                        local waitTime = 0
                        while waitTime < 3 and cultistToggleEnabled and cultistLoopRunning do
                            wait(0.1)
                            waitTime = waitTime + 0.1
                        end
                    end
                    cultistLoopRunning = false
                end)
            else
                cultistToggleEnabled = false
            end
        else
            cultistLoopRunning = false
        end
    end
})

Tabs.br:Section({ Title = "Equipment", Icon = "sword" })

Tabs.br:Dropdown({
    Title = "Select Equipments to bring",
    Values = equipmentItems,
    Multi = true,
    AllowNone = true,
    Callback = function(options)
        selectedEquipmentItems = options
    end
})

Tabs.br:Toggle({
    Title = "Bring Equipment Items",
    Default = false,
    Callback = function(value)
        equipmentToggleEnabled = value

        if value then
            if #selectedEquipmentItems > 0 then
                equipmentLoopRunning = true
                spawn(function()
                    while equipmentLoopRunning and equipmentToggleEnabled do
                        if #selectedEquipmentItems > 0 and equipmentToggleEnabled then
                            bypassBringSystem(selectedEquipmentItems, function() return equipmentToggleEnabled end)
                        end


                        local waitTime = 0
                        while waitTime < 3 and equipmentToggleEnabled and equipmentLoopRunning do
                            wait(0.1)
                            waitTime = waitTime + 0.1
                        end
                    end
                    equipmentLoopRunning = false
                end)
            else
                equipmentToggleEnabled = false
            end
        else
            equipmentLoopRunning = false
        end
    end
})

Tabs.br:Section({ Title = "Sapling", Icon = "sprout" })

Tabs.br:Toggle({
    Title = "Bring Saplings",
    Default = false,
    Callback = function(value)
        autoPlantEnabled = value

        if value then
            autoPlantLoop = true
            spawn(function()
                while autoPlantLoop and autoPlantEnabled do
                    bypassBringSystem({"Sapling"}, function() return autoPlantEnabled end)

                    if not autoPlantEnabled then break end

                    local args = {
                        Instance.new("Model", nil)
                    }
                    game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("RequestPlantItem"):InvokeServer(unpack(args))

                    local waitTime = 0
                    while waitTime < 3 and autoPlantEnabled and autoPlantLoop do
                        task.wait(0.1)
                        waitTime = waitTime + 0.1
                    end
                end
                autoPlantLoop = false
            end)
        else
            autoPlantLoop = false
        end
    end
})

Tabs.Fly:Section({ Title = "Player", Icon = "user" })

Tabs.Fly:Slider({
    Title = "Hip Height",
    Step = 1,
    Value = {
        Min = 1,
        Max = 50,
        Default = 2,
    },
    Callback = function(v)
        _G.HipHeight = v
        if _G.HipHeightOn then
            game.Players.LocalPlayer.Character.Humanoid.HipHeight = v
        end
    end
})

Tabs.Fly:Slider({
    Title = "Fly Speed",
    Value = { Min = 1, Max = 20, Default = 1 },
    Callback = function(value)
        flySpeed = value
        if FLYING then
            task.spawn(function()
                while FLYING do
                    task.wait(0.1)
                    if game:GetService("UserInputService").TouchEnabled then
                        local root = Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        if root and root:FindFirstChild("BodyVelocity") then
                            local bv = root:FindFirstChild("BodyVelocity")
                            bv.Velocity = bv.Velocity.Unit * (flySpeed * 50)
                        end
                    end
                end
            end)
        end
    end
})

local speed = 16

local function setSpeed(val)
    local humanoid = Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then humanoid.WalkSpeed = val end
end


Tabs.Fly:Slider({
    Title = "Speed",
    Value = { Min = 16, Max = 150, Default = 16 },
    Callback = function(value)
        speed = value
    end
})

Tabs.Fly:Divider()
Tabs.Fly:Toggle({
    Title = "Enable Hip Height",
    Icon = "user",
    Type = "Toggle",
    Default = false,
    Callback = function(PH)
        _G.HipHeightOn = PH
        if PH then
            game.Players.LocalPlayer.Character.Humanoid.HipHeight = _G.HipHeight or 2
        end
    end
})

Tabs.Fly:Toggle({
    Title = "Enable Fly",
    Value = false,
    Callback = function(state)
        flyToggle = state
        if flyToggle then
            if game:GetService("UserInputService").TouchEnabled then
                MobileFly()
            else
                sFLY()
            end
        else
            NOFLY()
            UnMobileFly()
        end
    end
})
Tabs.Fly:Toggle({
    Title = "Enable Speed",
    Value = false,
    Callback = function(state)
        setSpeed(state and speed or 16)
    end
})
Tabs.Fly:Section({ Title = "Misc", Icon = "flame" })

local RunService = game:GetService("RunService")
local noclipConnection

Tabs.Fly:Toggle({
    Title = "No Clip",
    Value = false,
    Callback = function(state)
        if state then
            noclipConnection = RunService.Stepped:Connect(function()
                local char = Players.LocalPlayer.Character
                if char then
                    for _, part in ipairs(char:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        else
            if noclipConnection then
                noclipConnection:Disconnect()
                noclipConnection = nil
            end
        end
    end
})

local UserInputService = game:GetService("UserInputService")
local infJumpConnection

Tabs.Fly:Toggle({
    Title = "Inf Jump",
    Value = false,
    Callback = function(state)
        if state then
            infJumpConnection = UserInputService.JumpRequest:Connect(function()
                local char = Players.LocalPlayer.Character
                local humanoid = char and char:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
        else
            if infJumpConnection then
                infJumpConnection:Disconnect()
                infJumpConnection = nil
            end
        end
    end
})

function createESPText(part, text, color)
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
    label.TextColor3 = color or Color3.fromRGB(255,255,0)
    label.TextStrokeTransparency = 0.2
    label.TextScaled = true
    label.Font = Enum.Font.Code

    esp.Parent = part
end

local function Aesp(nome, tipo)
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
                createESPText(part, obj.Name, color)
            end
        end
    end
end

local function Desp(nome, tipo)
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

local selectedItems = {}
local selectedMobs = {}
local espItemsEnabled = false
local espMobsEnabled = false
local espConnections = {}

Tabs.esp:Toggle({
    Title = "Esp Players",
    Icon = "eye",
    Callback = function(enable)
        _G.EspPlayerOn = enable
        if enable then
            pcall(function()
                createPlayerNameBillboard(player)
                end)
                else
                    _G.EspPlayerOn = false
        end
   end
})

local Tree = workspace.Map.Landmarks
local EspTextSize = 16

local function createTreeESP(tree)
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
    textLabel.TextSize = EspTextSize
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

local function enableTreeESP()
    for _, tree in pairs(Tree:GetChildren()) do
        if tree.Name == "Small Tree" then
            createTreeESP(tree)
        end
    end

    treeAddedConnection = Tree.ChildAdded:Connect(function(tree)
        if tree.Name == "Small Tree" then
            createTreeESP(tree)
        end
    end)
end

local function disableTreeESP()
    for _, tree in pairs(Tree:GetChildren()) do
        local oldGui = tree:FindFirstChild("TreeHealth")
        if oldGui then
            oldGui:Destroy()
        end
    end

    if treeAddedConnection then
        treeAddedConnection:Disconnect()
        treeAddedConnection = nil
    end
end

local treeAddedConnection

Tabs.esp:Toggle({
    Title = "Esp Tree Healths",
    Icon = "eye",
    Callback = function(enable)
        if enable then
            enableTreeESP()
        else
            disableTreeESP()
        end
    end
})

Tabs.esp:Section({ Title = "Esp Items", Icon = "package" })

Tabs.esp:Dropdown({
    Title = "Esp Items",
    Values = ie,
    Value = {},
    Multi = true,
    AllowNone = true,
    Callback = function(options)
        selectedItems = options
        if espItemsEnabled then
            for _, name in ipairs(ie) do
                if table.find(selectedItems, name) then
                    Aesp(name, "item")
                else
                    Desp(name, "item")
                end
            end
        else
            for _, name in ipairs(ie) do
                Desp(name, "item")
            end
        end
    end
})

Tabs.esp:Toggle({
    Title = "Enable Esp",
    Value = false,
    Callback = function(state)
        espItemsEnabled = state
        for _, name in ipairs(ie) do
            if state and table.find(selectedItems, name) then
                Aesp(name, "item")
            else
                Desp(name, "item")
            end
        end

        if state then
            if not espConnections["Items"] then
                local container = workspace:FindFirstChild("Items")
                if container then
                    espConnections["Items"] = container.ChildAdded:Connect(function(obj)
                        if table.find(selectedItems, obj.Name) then
                            local part = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart")
                            if part then
                                createESP(part, obj.Name, Color3.fromRGB(0, 255, 0))
                            end
                        end
                    end)
                end
            end
        else
            if espConnections["Items"] then
                espConnections["Items"]:Disconnect()
                espConnections["Items"] = nil
            end
        end
    end
})

Tabs.esp:Section({ Title = "Esp Entity", Icon = "user" })

Tabs.esp:Dropdown({
    Title = "Esp Entity",
    Values = me,
    Value = {},
    Multi = true,
    AllowNone = true,
    Callback = function(options)
        selectedMobs = options
        if espMobsEnabled then
            for _, name in ipairs(me) do
                if table.find(selectedMobs, name) then
                    Aesp(name, "mob")
                else
                    Desp(name, "mob")
                end
            end
        else
            for _, name in ipairs(me) do
                Desp(name, "mob")
            end
        end
    end
})

Tabs.esp:Toggle({
    Title = "Enable Esp",
    Value = false,
    Callback = function(state)
        espMobsEnabled = state
        for _, name in ipairs(me) do
            if state and table.find(selectedMobs, name) then
                Aesp(name, "mob")
            else
                Desp(name, "mob")
            end
        end

        if state then
            if not espConnections["Mobs"] then
                local container = workspace:FindFirstChild("Characters")
                if container then
                    espConnections["Mobs"] = container.ChildAdded:Connect(function(obj)
                        if table.find(selectedMobs, obj.Name) then
                            local part = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart")
                            if part then
                                createESP(part, obj.Name, Color3.fromRGB(255, 255, 0))
                            end
                        end
                    end)
                end
            end
        else
            if espConnections["Mobs"] then
                espConnections["Mobs"]:Disconnect()
                espConnections["Mobs"] = nil
            end
        end
    end
})

Tabs.Misc:Section({ Title = "Miscellaneous", Icon = "settings" })

local instantInteractEnabled = false
local instantInteractConnection
local originalHoldDurations = {}

Tabs.Misc:Toggle({
    Title = "Instant Interact",
    Value = false,
    Callback = function(state)
        instantInteractEnabled = state

        if state then
            originalHoldDurations = {}
            instantInteractConnection = task.spawn(function()
                while instantInteractEnabled do
                    for _, obj in ipairs(workspace:GetDescendants()) do
                        if obj:IsA("ProximityPrompt") then
                            if originalHoldDurations[obj] == nil then
                                originalHoldDurations[obj] = obj.HoldDuration
                            end
                            obj.HoldDuration = 0
                        end
                    end
                    task.wait(5)
                end
            end)
        else
            if instantInteractConnection then
                instantInteractEnabled = false
            end
            for obj, value in pairs(originalHoldDurations) do
                if obj and obj:IsA("ProximityPrompt") then
                    obj.HoldDuration = value
                end
            end
            originalHoldDurations = {}
        end
    end
})

Tabs.Misc:Toggle({
    Title = "Auto Collect All Coin Stacks",
    Default = false,
    Callback = function(value)
        if value then
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
})

Tabs.Misc:Toggle({
    Title = "Auto Build Anvil",
    Value = false,
    Callback = function(state)
        autoBuildAnvil = state
        task.spawn(function()
            while autoBuildAnvil do
                for _, partName in ipairs({"Anvil Base", "Anvil Front", "Anvil Back"}) do
                    if workspace:WaitForChild("Items"):FindFirstChild(partName) then
                        game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("RequestBuildAnvilPiece"):InvokeServer(
                            workspace:WaitForChild("Map"):WaitForChild("Landmarks"):WaitForChild("ToolWorkshop_MeteorShower"),
                            workspace:WaitForChild("Items")[partName]
                        )
                    end
                end
            end
        end)
    end
})

Tabs.Misc:Section({ Title = "Antis", Icon = "skull" })

local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local torchLoop = nil

Tabs.Misc:Toggle({
    Title = "Auto Stun Deer",
    Desc = "Needs a Flashlight",
    Value = false,
    Callback = function(state)
        if state then
            torchLoop = RunService.RenderStepped:Connect(function()
                pcall(function()
                    local remote = ReplicatedStorage:FindFirstChild("RemoteEvents")
                        and ReplicatedStorage.RemoteEvents:FindFirstChild("DeerHitByTorch")
                    local deer = workspace:FindFirstChild("Characters")
                        and workspace.Characters:FindFirstChild("Deer")
                    if remote and deer then
                        remote:InvokeServer(deer)
                    end
                end)
                task.wait(0.1)
            end)
        else
            if torchLoop then
                torchLoop:Disconnect()
                torchLoop = nil
            end
        end
    end
})

local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local HumanoidRootPart = character:WaitForChild("HumanoidRootPart")

local ESCAPE_DISTANCE_OWL = 80
local ESCAPE_SPEED_OWL = 5

local ESCAPE_DISTANCE_DEER = 60
local ESCAPE_SPEED_DEER = 4

local ESCAPE_DISTANCE_RAM = 65
local ESCAPE_SPEED_RAM = 4.5

local escapeLoopOwl
local escapeLoopDeer
local escapeLoopRam

Tabs.Misc:Divider()

Tabs.Misc:Toggle({
    Title = "Auto Escape From Owl", 
    Value = false,
    Callback = function(state)
        if state then
            escapeLoopOwl = RunService.RenderStepped:Connect(function()
                pcall(function()
                    local owl = workspace:FindFirstChild("Characters") and workspace.Characters:FindFirstChild("Owl")
                    if owl and owl:FindFirstChild("HumanoidRootPart") then
                        local myPos = HumanoidRootPart.Position
                        local owlPos = owl.HumanoidRootPart.Position
                        local distance = (myPos - owlPos).Magnitude

                        if distance < ESCAPE_DISTANCE_OWL then
                            local direction = (myPos - owlPos).Unit
                            HumanoidRootPart.CFrame = HumanoidRootPart.CFrame + direction * ESCAPE_SPEED_OWL
                        end
                    end
                end)
            end)
        else
            if escapeLoopOwl then
                escapeLoopOwl:Disconnect()
                escapeLoopOwl = nil
            end
        end
    end
})

Tabs.Misc:Toggle({
    Title = "Auto Escape From Deer", 
    Value = false,
    Callback = function(state)
        if state then
            escapeLoopDeer = RunService.RenderStepped:Connect(function()
                pcall(function()
                    local deer = workspace:FindFirstChild("Characters") and workspace.Characters:FindFirstChild("Deer")
                    if deer and deer:FindFirstChild("HumanoidRootPart") then
                        local myPos = HumanoidRootPart.Position
                        local deerPos = deer.HumanoidRootPart.Position
                        local distance = (myPos - deerPos).Magnitude

                        if distance < ESCAPE_DISTANCE_DEER then
                            local direction = (myPos - deerPos).Unit
                            HumanoidRootPart.CFrame = HumanoidRootPart.CFrame + direction * ESCAPE_SPEED_DEER
                        end
                    end
                end)
            end)
        else
            if escapeLoopDeer then
                escapeLoopDeer:Disconnect()
                escapeLoopDeer = nil
            end
        end
    end
})

Tabs.Misc:Toggle({
    Title = "Auto Escape From Ram", 
    Value = false,
    Callback = function(state)
        if state then
            escapeLoopRam = RunService.RenderStepped:Connect(function()
                pcall(function()
                    local ram = workspace:FindFirstChild("Characters") and workspace.Characters:FindFirstChild("Ram")
                    if ram and ram:FindFirstChild("HumanoidRootPart") then
                        local myPos = HumanoidRootPart.Position
                        local ramPos = ram.HumanoidRootPart.Position
                        local distance = (myPos - ramPos).Magnitude

                        if distance < ESCAPE_DISTANCE_RAM then
                            local direction = (myPos - ramPos).Unit
                            HumanoidRootPart.CFrame = HumanoidRootPart.CFrame + direction * ESCAPE_SPEED_RAM
                        end
                    end
                end)
            end)
        else
            if escapeLoopRam then
                escapeLoopRam:Disconnect()
                escapeLoopRam = nil
            end
        end
    end
})

Tabs.Fun:Section({ Title = "Fun", Icon = "star" })

deleteSettings = {
    Owl = false,
    Deer = false,
    Ram = false
}

function autoDelete()
    for name, enabled in pairs(deleteSettings) do
        if enabled then
            for _, obj in pairs(workspace.Characters:GetChildren()) do
                if obj.Name == name then
                    obj:Destroy()
                end
            end
        end
    end
end

RunService.Heartbeat:Connect(autoDelete)

Tabs.Fun:Toggle({
    Title = "Auto Delete Owl",
    Default = false,
    Callback = function(state) 
        deleteSettings.Owl = state
    end
})

Tabs.Fun:Toggle({
    Title = "Auto Delete Deer",
    Default = false,
    Callback = function(state) 
        deleteSettings.Deer = state
    end
})

Tabs.Fun:Toggle({
    Title = "Auto Delete Ram",
    Default = false,
    Callback = function(state) 
        deleteSettings.Ram = state
    end
})

Tabs.Fun:Slider({
    Title = "Gravity",
    Step = 1,
    Value = {
        Min = 0,
        Max = 500,
        Default = 196,
    },
    Callback = function(value)
        workspace.Gravity = value
        print("Gravity set to:", value)
    end
})

_G.GodModeEnabled = false

function _G.ApplyGodMode(state)
    if character then
        for i, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = not state
            end
        end

        hum = character:FindFirstChildOfClass("Humanoid")
        if state and hum then
            if _G.GodModeHumConnection then _G.GodModeHumConnection:Disconnect() _G.GodModeHumConnection = nil end
            if _G.GodModeHeartbeat then _G.GodModeHeartbeat:Disconnect() _G.GodModeHeartbeat = nil end

            _G.GodModeHumConnection = hum.HealthChanged:Connect(function(hp)
                if _G.GodModeEnabled and hum and hum.Health < hum.MaxHealth then
                    hum.Health = hum.MaxHealth
                end
            end)

            _G.GodModeHeartbeat = game:GetService("RunService").Heartbeat:Connect(function()
                if _G.GodModeEnabled and hum and hum.Health < hum.MaxHealth then
                    hum.Health = hum.MaxHealth
                end
            end)
        else
            if _G.GodModeHumConnection then _G.GodModeHumConnection:Disconnect() _G.GodModeHumConnection = nil end
            if _G.GodModeHeartbeat then _G.GodModeHeartbeat:Disconnect() _G.GodModeHeartbeat = nil end
        end
    end
end

player.CharacterAdded:Connect(function(char)
    character = char
    wait(0.1)
    if _G.GodModeEnabled then
        _G.ApplyGodMode(true)
    end
end)

Tabs.Fun:Toggle({
    Title = "No health bar",
    Default = false,
    Callback = function(state)
        _G.GodModeEnabled = state
        _G.ApplyGodMode(state)
        if state then
            print("You cant see your health anymore lol")
        else
            print("Disable health OFF")
        end
    end
})

Tabs.Fun:Toggle({
    Title = "God Mode",
    Default = false,
    Callback = function(value)
        if value then
            _G.GodModeToggle = true
            spawn(function()
                while _G.GodModeToggle do
                    local dmgEvent = rs:FindFirstChild("RemoteEvents") and rs.RemoteEvents:FindFirstChild("DamagePlayer")
                    if dmgEvent then
                        dmgEvent:FireServer(-9999)
                    else
                        warn("God Mode failed, rejoin game and try again")
                    end
                    RunService.Stepped:Wait()
                end
            end)
        else
            _G.GodModeToggle = false
        end
    end
})

Tabs.Fun:Button({
    Title = "Auto Farm Days",
    Color = Color3.fromHex("#89cff0"),
    Desc = "Just afk and let the script do everything.",
    Callback = function()
        loadstring(game:HttpGet("https://paste.rs/Gc9QX",true))()
    end
})

Tabs.Vision:Section({ Title = "Environment", Icon = "eye" })

local originalParents = {
    Sky = nil,
    Bloom = nil,
    CampfireEffect = nil
}

local function storeOriginalParents()
    local Lighting = game:GetService("Lighting")

    local sky = Lighting:FindFirstChild("Sky")
    local bloom = Lighting:FindFirstChild("Bloom")
    local campfireEffect = Lighting:FindFirstChild("CampfireEffect")

    if sky and not originalParents.Sky then
        originalParents.Sky = sky.Parent
    end
    if bloom and not originalParents.Bloom then
        originalParents.Bloom = bloom.Parent
    end
    if campfireEffect and not originalParents.CampfireEffect then
        originalParents.CampfireEffect = campfireEffect.Parent
    end
end

storeOriginalParents()

local originalColorCorrectionParent = nil

local function storeColorCorrectionParent()
    local Lighting = game:GetService("Lighting")
    local colorCorrection = Lighting:FindFirstChild("ColorCorrection")

    if colorCorrection and not originalColorCorrectionParent then
        originalColorCorrectionParent = colorCorrection.Parent
    end
end

storeColorCorrectionParent()

Tabs.Vision:Toggle({
    Title = "Disable Fog",
    Desc = "",
    Value = false,
    Callback = function(state)
        local Lighting = game:GetService("Lighting")

        if state then
            local sky = Lighting:FindFirstChild("Sky")
            local bloom = Lighting:FindFirstChild("Bloom")
            local campfireEffect = Lighting:FindFirstChild("CampfireEffect")

            if sky then
                sky.Parent = nil
            end
            if bloom then
                bloom.Parent = nil
            end
            if campfireEffect then
                campfireEffect.Parent = nil
            end


        else
            local sky = game:FindFirstChild("Sky", true)
            local bloom = game:FindFirstChild("Bloom", true) 
            local campfireEffect = game:FindFirstChild("CampfireEffect", true)

            if not sky then sky = Lighting:FindFirstChild("Sky") end
            if not bloom then bloom = Lighting:FindFirstChild("Bloom") end
            if not campfireEffect then campfireEffect = Lighting:FindFirstChild("CampfireEffect") end

            if sky then
                sky.Parent = originalParents.Sky or Lighting
            end
            if bloom then
                bloom.Parent = originalParents.Bloom or Lighting
            end
            if campfireEffect then
                campfireEffect.Parent = originalParents.CampfireEffect or Lighting
            end


        end
    end
})

local originalLightingValues = {
    Brightness = nil,
    Ambient = nil,
    OutdoorAmbient = nil,
    ShadowSoftness = nil,
    GlobalShadows = nil,
    Technology = nil
}

local function storeOriginalLighting()
    local Lighting = game:GetService("Lighting")

    if not originalLightingValues.Brightness then
        originalLightingValues.Brightness = Lighting.Brightness
        originalLightingValues.Ambient = Lighting.Ambient
        originalLightingValues.OutdoorAmbient = Lighting.OutdoorAmbient
        originalLightingValues.ShadowSoftness = Lighting.ShadowSoftness
        originalLightingValues.GlobalShadows = Lighting.GlobalShadows
        originalLightingValues.Technology = Lighting.Technology
    end
end

storeOriginalLighting()

Tabs.Vision:Toggle({
    Title = "Disable NightCampFire Effect",
    Desc = "",
    Value = false,
    Callback = function(state)
        local Lighting = game:GetService("Lighting")

        if state then
            local colorCorrection = Lighting:FindFirstChild("ColorCorrection")

            if colorCorrection then
                if not originalColorCorrectionParent then
                    originalColorCorrectionParent = colorCorrection.Parent
                end
                colorCorrection.Parent = nil
            end
        else
            local colorCorrection = nil

            colorCorrection = Lighting:FindFirstChild("ColorCorrection")

            if not colorCorrection then
                colorCorrection = game:FindFirstChild("ColorCorrection", true)
            end

            if colorCorrection then
                colorCorrection.Parent = Lighting
            end
        end
    end
})

Tabs.Vision:Toggle({
    Title = "Full Bright",
    Desc = "",
    Value = false,
    Callback = function(state)
        if state then
            Lighting.ClockTime = 14
            Lighting.Brightness = 2.2
            Lighting.Ambient = Color3.new(1, 1, 1)
            Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
            Lighting.ShadowSoftness = 0
            Lighting.GlobalShadows = false
            Lighting.Technology = Enum.Technology.Compatibility
        else
            Lighting.Brightness = originalLightingValues.Brightness
            Lighting.Ambient = originalLightingValues.Ambient
            Lighting.OutdoorAmbient = originalLightingValues.OutdoorAmbient
            Lighting.ShadowSoftness = originalLightingValues.ShadowSoftness
            Lighting.GlobalShadows = originalLightingValues.GlobalShadows
            Lighting.Technology = originalLightingValues.Technology
        end
    end
})


local NoFogToggle = false
local OriginalFogStart = Lighting.FogStart
local OriginalFogEnd = Lighting.FogEnd

Tabs.Vision:Toggle({
    Title = "No Fog",
    Desc = "",
    Value = false,
    Callback = function(state)
        NoFogToggle = state

        if not state then
            Lighting.ClockTime = 14
            Lighting.GlobalShadows = false
            Lighting.FogStart = OriginalFogStart
            Lighting.FogEnd = OriginalFogEnd
        end
    end
})

RunService.Heartbeat:Connect(function()
    if NoFogToggle then
        if Lighting.FogStart ~= 100000 or Lighting.FogEnd ~= 100000 then
            Lighting.ClockTime = 14
            Lighting.GlobalShadows = false
            Lighting.FogStart = 100000
            Lighting.FogEnd = 100000
        end
    end
end)

if not vibrantEffect then
    Lighting.ClockTime = 14
    Lighting.GlobalShadows = false
    vibrantEffect = Instance.new("ColorCorrectionEffect")
    vibrantEffect.Name = "VibrantEffect"
    vibrantEffect.Saturation = 0.5
    vibrantEffect.Contrast = 0.2
    vibrantEffect.Brightness = 0.1
    vibrantEffect.Enabled = false 
    vibrantEffect.Parent = Lighting
end

Tabs.Vision:Toggle({
    Title = "Vibrant Colors",
    Value = false,
    Callback = function(state)
        if state then
            Lighting.ClockTime = 14
            Lighting.GlobalShadows = false
            Lighting.Ambient = Color3.fromRGB(180, 180, 180)
            Lighting.OutdoorAmbient = Color3.fromRGB(170, 170, 170)
            Lighting.ColorShift_Top = Color3.fromRGB(255, 230, 200)
            Lighting.ColorShift_Bottom = Color3.fromRGB(200, 240, 255)
            if effect then
                effect.Enabled = true
            end
        else
            if effect then
                effect.Enabled = false
            end
            Lighting.ClockTime = 14
            Lighting.GlobalShadows = false
            Lighting.Ambient = Color3.new(0, 0, 0)
            Lighting.OutdoorAmbient = Color3.new(0, 0, 0)
            Lighting.ColorShift_Top = Color3.new(0, 0, 0)
            Lighting.ColorShift_Bottom = Color3.new(0, 0, 0)
        end
    end
})
Tabs.Vision:Button({
    Title = "Remove Gameplay Paused",
    Locked = false,
    Callback = function()
        game:GetService("CoreGui").RobloxGui["CoreScripts/NetworkPause"]:Destroy()
    end
})
Grapics:Button({
    Title = "Boost Fps",
    Callback = function()
        pcall(function()
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
            local lighting = game:GetService("Lighting")
            lighting.Brightness = 1
            lighting.FogEnd = 1000000
            lighting.GlobalShadows = false
            lighting.EnvironmentDiffuseScale = 0
            lighting.EnvironmentSpecularScale = 0
            lighting.ClockTime = 14
            lighting.OutdoorAmbient = Color3.new(0, 0, 0)
            local terrain = workspace:FindFirstChildOfClass("Terrain")
            if terrain then
                terrain.WaterWaveSize = 0
                terrain.WaterWaveSpeed = 0
                terrain.WaterReflectance = 0
                terrain.WaterTransparency = 1
            end
            for _, obj in ipairs(lighting:GetDescendants()) do
                if obj:IsA("PostEffect") or obj:IsA("BloomEffect") or obj:IsA("ColorCorrectionEffect") or obj:IsA("SunRaysEffect") or obj:IsA("BlurEffect") then
                    obj.Enabled = false
                end
            end
            for _, obj in ipairs(game:GetDescendants()) do
                if obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
                    obj.Enabled = false
                elseif obj:IsA("Texture") or obj:IsA("Decal") then
                    obj.Transparency = 1
                end
            end
            for _, part in ipairs(workspace:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CastShadow = false
                end
            end
        end)
    end
})

Grapics:Button({
    Title = "Super Boost Fps",
    Callback = function()
        pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/SuperHackerYT/skibidi/refs/heads/main/performanceboost.lua"))()
        end)
    end
})

UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if gameProcessedEvent then return end

    if input.KeyCode == Enum.KeyCode.V then
        showPlayers = not showPlayers
        playersText.Visible = showPlayers
    end
end)

Tabs.Codes:Section({ Title = "Lobby", Icon = "eye" })

Tabs.Codes:Toggle({
    Title = "Redeem All Codes",
    Default = false,
    Callback = function(value)
        if value then
            local codes = {
                "AFTERPARTY",
                "THEWOKENRAM"
            }

            for _, code in ipairs(codes) do
                local args = { code }
                game:GetService("ReplicatedStorage")
                    :WaitForChild("RemoteEvents")
                    :WaitForChild("RequestInputCode")
                    :InvokeServer(unpack(args))
                task.wait(0.25)
            end
        end
    end
})

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
    Tabs.Info:Paragraph({
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
        local DiscordInfo = Tabs.Info:Paragraph({
            Title = result.guild.name,
            Desc = ' <font color="#52525b">•</font> Members: ' .. tostring(result.approximate_member_count) ..
            '\n <font color="#16a34a">•</font> Online: ' .. tostring(result.approximate_presence_count),
            Image = "https://cdn.discordapp.com/icons/" .. result.guild.id .. "/" .. result.guild.icon .. ".png?size=1024",
            ImageSize = 42,
        })

        Tabs.Info:Button({
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

        Tabs.Info:Button({
            Title = "Copy Server Link",
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

Tabs.Info:Divider()

game:GetService("Players").PlayerRemoving:Connect(function(removedPlayer)
    if _G.playerBillboards[removedPlayer.Name] then
        _G.playerBillboards[removedPlayer.Name]:Destroy()
        _G.playerBillboards[removedPlayer.Name] = nil
    end
end)

                end)
            end
        }
    }
})
