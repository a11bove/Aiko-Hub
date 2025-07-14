local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local ws = Workspace
local Rs = RunService

if _G.MutationESPLoaded then
    return
end
_G.MutationESPLoaded = true

local config = {
    espEnabled = false,
    mutations = {
        ["Wet"] = false,
        ["Chilled"] = false,
        ["Moonlit"] = false,
        ["Windstruck"] = false,
        ["Bloodlit"] = false,
        ["Drenched"] = false,
        ["Twisted"] = false,
        ["Frozen"] = false,
        ["Shocked"] = false,
        ["Sundried"] = false,
        ["Aurora"] = false,
        ["Celestial"] = false,
        ["Meteoric"] = false,
        ["Molten"] = false,
        ["Voidtouched"] = false,
        ["Dawnbound"] = false,
        ["Alienlike"] = false,
        ["Galactic"] = false,
        ["Plasma"] = false,
        ["Heavenly"] = false,
        ["Disco"] = false,
        ["Pollinated"] = false,
        ["HoneyGlazed"] = false,
        ["Verdant"] = false,
        ["Choc"] = false,
        ["Burnt"] = false,
        ["Cooked"] = false,
        ["Zombified"] = false,
        ["Gold"] = false,
        ["Rainbow"] = false,
        ["Ripe"] = false,
        ["Paradisal"] = false,
        ["Fried"] = false,
        ["Cloudtouched"] = false,
        ["Clay"] = false,
        ["Amber"] = false,
        ["OldAmber"] = false,
        ["Sandy"] = false,
        ["AncientAmber"] = false,
        ["Ceramic"] = false,
        ["Tempestuous"] = false,
        ["Wiltproof"] = false,
        ["Infected"] = false,
        ["Friendbound"] = false
    },
    showTextLabels = true,
    showGlowEffects = true
}

local espObjects = {}
local processedFruits = {}

local mutationOptions = {
    "Wet",
    "Chilled",
    "Moonlit",
    "Windstruck",
    "Bloodlit",
    "Drenched",
    "Twisted",
    "Frozen",
    "Shocked",
    "Sundried",
    "Aurora",
    "Celestial",
    "Meteoric",
    "Molten",
    "Voidtouched",
    "Dawnbound",
    "Alienlike",
    "Galactic",
    "Plasma",
    "Heavenly",
    "Disco",
    "Pollinated",
    "HoneyGlazed",
    "Verdant",
    "Choc",
    "Burnt",
    "Cooked",
    "Zombified",
    "Gold",
    "Rainbow",
    "Ripe",
    "Paradisal",
    "Fried",
    "Clay",
    "Amber",
    "OldAmber",
    "Sandy",
    "AncientAmber",
    "Ceramic",
    "Tempestuous",
    "Wiltproof",
    "Infected",
    "Friendbound",
    "Cloudtouched"
}

local rarityTiers = {
    {mutations = {"Wet", "Ripe"}, tier = 1},
    {
        mutations = {
            "Gold",
            "Frozen",
            "Choc",
            "Chilled",
            "Shocked",
            "Burnt",
            "Cooked",
            "Pollinated",
            "HoneyGlazed",
            "Cloudtouched"
        },
        tier = 2
    },
    {
        mutations = {
            "Rainbow",
            "Moonlit",
            "Bloodlit",
            "Plasma",
            "Disco",
            "Windstruck",
            "Drenched",
            "Twisted",
            "Aurora",
            "Molten",
            "Alienlike",
            "Heavenly",
            "Friendbound",
            "Verdant",
            "Sundried",
            "Tempestuous",
            "Wiltproof"
        },
        tier = 3
    },
    {
        mutations = {
            "Celestial",
            "Zombified",
            "Meteoric",
            "Voidtouched",
            "Dawnbound",
            "Galactic",
            "Paradisal",
            "Fried",
            "Clay",
            "Amber",
            "Sandy",
            "OldAmber",
            "AncientAmber",
            "Ceramic",
            "Infected"
        },
        tier = 4
    }
}

local function getMutationTier(mutation)
    for _, tier in ipairs(rarityTiers) do
        if table.find(tier.mutations, mutation) then
            return tier.tier
        end
    end
    return 1
end

local function cleanupESP()
    for fruitModel, objList in pairs(espObjects) do
        if objList and typeof(objList) == "table" then
            for _, obj in pairs(objList) do
                if obj and obj.Parent then
                    pcall(function()
                        obj:Destroy()
                    end)
                end
            end
        end
    end
    espObjects = {}
    processedFruits = {}
end

local function createGlowEffect(parent)
    if not parent or not parent.Parent then
        return nil
    end
    
    local glow = Instance.new("BillboardGui")
    glow.Name = "GlowEffect"
    glow.Size = UDim2.fromOffset(6, 6)
    glow.Adornee = parent
    glow.AlwaysOnTop = true

    local image = Instance.new("ImageLabel")
    image.Size = UDim2.fromScale(1, 1)
    image.BackgroundTransparency = 1
    image.Image = "rbxassetid://1316045217"
    image.ImageColor3 = Color3.fromRGB(255, 255, 255)
    image.ImageTransparency = 0.2
    image.Parent = glow

    return glow
end

local function createESP(fruitModel)
    if not config.espEnabled or not fruitModel or not fruitModel:IsA("Model") or processedFruits[fruitModel] then
        return
    end

    -- Check if fruitModel still exists and has a parent
    if not fruitModel.Parent then
        return
    end

    local activeMutations = {}
    for _, mutation in ipairs(mutationOptions) do
        if config.mutations[mutation] and fruitModel:GetAttribute(mutation) then
            table.insert(activeMutations, mutation)
        end
    end

    if #activeMutations == 0 then
        return
    end

    processedFruits[fruitModel] = true

    local highestTier = 0
    local primaryMutation = activeMutations[1]

    for _, mutation in ipairs(activeMutations) do
        local tier = getMutationTier(mutation)
        if tier > highestTier then
            highestTier = tier
            primaryMutation = mutation
        end
    end

    local espColor = Color3.fromRGB(255, 255, 255)
    local espObjects_current = {}

    -- Create highlight with error handling
    pcall(function()
        local highlight = Instance.new("Highlight")
        highlight.Name = "MutationESP_Highlight"
        highlight.FillTransparency = 0.7
        highlight.OutlineColor = espColor
        highlight.FillColor = espColor
        highlight.OutlineTransparency = 0
        highlight.DepthMode = Enum.HighlightDepthMode.Occluded
        highlight.Adornee = fruitModel
        highlight.Parent = fruitModel
        table.insert(espObjects_current, highlight)

        if config.showGlowEffects and highestTier >= 3 then
            local tweenInfo = TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
            local pulseUp = TweenService:Create(
                highlight,
                tweenInfo,
                {
                    OutlineTransparency = 0.5,
                    FillTransparency = 0.9
                }
            )
            pulseUp:Play()
        end
    end)

    local primaryPart = fruitModel.PrimaryPart or fruitModel:FindFirstChildWhichIsA("BasePart")
    if primaryPart and primaryPart.Parent then
        if config.showTextLabels then
            pcall(function()
                local billboard = Instance.new("BillboardGui")
                billboard.Name = "MutationESP_Billboard"
                billboard.Adornee = primaryPart
                billboard.Size = UDim2.fromOffset(150, 30)
                billboard.StudsOffset = Vector3.new(0, 2, 0)
                billboard.AlwaysOnTop = true
                billboard.MaxDistance = 70

                local frame = Instance.new("Frame")
                frame.Size = UDim2.fromScale(1, 1)
                frame.BackgroundTransparency = 1

                local nameLabel = Instance.new("TextLabel")
                nameLabel.Size = UDim2.new(1, 0, 0.4, 0)
                nameLabel.Position = UDim2.new(0, 0, 0, 2)
                nameLabel.BackgroundTransparency = 1
                nameLabel.Text = fruitModel.Name or "Unknown"
                nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                nameLabel.TextSize = 13
                nameLabel.Font = Enum.Font.SourceSans
                nameLabel.TextStrokeTransparency = 0
                nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                nameLabel.Parent = frame

                local mutationText = table.concat(activeMutations, " + ")
                local mutationLabel = Instance.new("TextLabel")
                mutationLabel.Size = UDim2.new(1, 0, 0.6, 0)
                mutationLabel.Position = UDim2.new(0, 0, 0.4, 0)
                mutationLabel.BackgroundTransparency = 1
                mutationLabel.Text = mutationText
                mutationLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                mutationLabel.TextSize = 13
                mutationLabel.Font = Enum.Font.SourceSans
                mutationLabel.TextStrokeTransparency = 0
                mutationLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                mutationLabel.Parent = frame

                frame.Parent = billboard
                billboard.Parent = fruitModel
                table.insert(espObjects_current, billboard)
            end)
        end

        if config.showGlowEffects and highestTier >= 2 then
            local glow = createGlowEffect(primaryPart)
            if glow then
                glow.Parent = fruitModel
                table.insert(espObjects_current, glow)
            end

            if highestTier >= 4 then
                for i = 1, 3 do
                    pcall(function()
                        local orb = Instance.new("Part")
                        orb.Name = "MutationOrb_" .. i
                        orb.Shape = Enum.PartType.Ball
                        orb.Size = Vector3.new(0.3, 0.3, 0.3)
                        orb.Material = Enum.Material.Neon
                        orb.Color = Color3.fromRGB(255, 255, 255)
                        orb.CanCollide = false
                        orb.Anchored = true
                        orb.Transparency = 0.3
                        orb.Parent = fruitModel

                        spawn(function()
                            local offset = (i - 1) * (2 * math.pi / 3)
                            while orb and orb.Parent and primaryPart and primaryPart.Parent do
                                pcall(function()
                                    local t = tick() * 2 + offset
                                    local radius = 2
                                    local height = math.sin(t) * 0.5
                                    local pos = primaryPart.Position + Vector3.new(math.cos(t) * radius, height + 1, math.sin(t) * radius)
                                    orb.Position = pos
                                end)
                                Rs.Heartbeat:Wait()
                            end
                        end)

                        table.insert(espObjects_current, orb)
                    end)
                end
            end
        end
    end

    espObjects[fruitModel] = espObjects_current

    -- Safe connection handling
    local connection
    connection = fruitModel.AncestryChanged:Connect(function(_, parent)
        if not parent then
            pcall(function()
                connection:Disconnect()
            end)
            
            if espObjects[fruitModel] then
                for _, obj in pairs(espObjects[fruitModel]) do
                    if obj and obj.Parent then
                        pcall(function()
                            obj:Destroy()
                        end)
                    end
                end
                espObjects[fruitModel] = nil
                processedFruits[fruitModel] = nil
            end
        end
    end)
end

local function updateESP()
    if not config.espEnabled then
        return
    end

    local farms = {}
    local farmFolder = ws:FindFirstChild("Farm")
    
    if not farmFolder then
        return
    end

    for _, farm in ipairs(farmFolder:GetChildren()) do
        if farm and farm:IsA("Model") then
            local important = farm:FindFirstChild("Important")
            if important then
                local data = important:FindFirstChild("Data")
                if data then
                    local owner = data:FindFirstChild("Owner")
                    if owner and owner.Value == player.Name then
                        table.insert(farms, farm)
                    end
                end
            end
        end
    end

    for _, farm in ipairs(farms) do
        if farm and farm.Parent then
            local important = farm:FindFirstChild("Important")
            if important then
                local plantsFolder = important:FindFirstChild("Plants_Physical")
                if plantsFolder then
                    for _, plantModel in ipairs(plantsFolder:GetChildren()) do
                        if plantModel and plantModel:IsA("Model") and plantModel.Parent then
                            local fruitsFolder = plantModel:FindFirstChild("Fruits")
                            if fruitsFolder then
                                for _, fruitModel in ipairs(fruitsFolder:GetChildren()) do
                                    if fruitModel and fruitModel:IsA("Model") and fruitModel.Parent then
                                        createESP(fruitModel)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

local function setupFruitMonitoring()
    local farms = ws:FindFirstChild("Farm")
    if not farms then
        return
    end

    for _, farm in ipairs(farms:GetChildren()) do
        if farm and farm:IsA("Model") then
            local important = farm:FindFirstChild("Important")
            if important then
                local data = important:FindFirstChild("Data")
                if data then
                    local owner = data:FindFirstChild("Owner")
                    if owner and owner.Value == player.Name then
                        local plantsFolder = important:FindFirstChild("Plants_Physical")
                        if plantsFolder then
                            plantsFolder.ChildAdded:Connect(function(plantModel)
                                if plantModel and plantModel:IsA("Model") then
                                    task.spawn(function()
                                        local fruitsFolder = plantModel:FindFirstChild("Fruits") or plantModel:WaitForChild("Fruits", 10)
                                        if fruitsFolder then
                                            fruitsFolder.ChildAdded:Connect(function(fruitModel)
                                                if fruitModel and fruitModel:IsA("Model") then
                                                    task.wait(0.2)
                                                    createESP(fruitModel)
                                                end
                                            end)

                                            for _, fruitModel in ipairs(fruitsFolder:GetChildren()) do
                                                if fruitModel and fruitModel:IsA("Model") then
                                                    createESP(fruitModel)
                                                end
                                            end
                                        end
                                    end)
                                end
                            end)
                        end
                    end
                end
            end
        end
    end
end

local function initializeMutationESP()
    setupFruitMonitoring()

    spawn(function()
        while config.espEnabled do
            pcall(function()
                updateESP()
            end)
            wait(2)
        end
    end)
end

_G.MutationESP = {
    config = config,
    enable = function()
        config.espEnabled = true
        for mutation, _ in pairs(config.mutations) do
            config.mutations[mutation] = true
        end
        initializeMutationESP()
        updateESP()
    end,
    disable = function()
        config.espEnabled = false
        cleanupESP()
    end,
    toggle = function()
        if config.espEnabled then
            _G.MutationESP.disable()
        else
            _G.MutationESP.enable()
        end
        return config.espEnabled
    end,
    updateESP = updateESP,
    cleanupESP = cleanupESP,
    enableMutation = function(mutation)
        if config.mutations[mutation] ~= nil then
            config.mutations[mutation] = true
            if config.espEnabled then
                updateESP()
            end
        end
    end,
    disableMutation = function(mutation)
        if config.mutations[mutation] ~= nil then
            config.mutations[mutation] = false
            if config.espEnabled then
                updateESP()
            end
        end
    end,
    enableAllMutations = function()
        for mutation, _ in pairs(config.mutations) do
            config.mutations[mutation] = true
        end
        if config.espEnabled then
            updateESP()
        end
    end,
    disableAllMutations = function()
        for mutation, _ in pairs(config.mutations) do
            config.mutations[mutation] = false
        end
        cleanupESP()
    end,
    setTextLabels = function(enabled)
        config.showTextLabels = enabled
        if config.espEnabled then
            cleanupESP()
            updateESP()
        end
    end,
    setGlowEffects = function(enabled)
        config.showGlowEffects = enabled
        if config.espEnabled then
            cleanupESP()
            updateESP()
        end
    end,
    getStatus = function()
        return {
            enabled = config.espEnabled,
            activeMutations = {},
            totalFruits = 0
        }
    end
}
