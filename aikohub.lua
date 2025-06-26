local ui = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local rs = game:GetService("ReplicatedStorage")
local ts = game:GetService("TeleportService")
local hs = game:GetService("HttpService")
local ws = game:GetService("Workspace")
local players = game:GetService("Players")
local player = game.Players.LocalPlayer
local leaderstats = player:FindFirstChild("leaderstats")leaderstats:FindFirstChild("Sheckles")
local plantRemote = rs:WaitForChild("GameEvents"):WaitForChild("Plant_RE")
local char = player.Character or player.CharacterAdded:Wait()
local GameEvents = rs:WaitForChild("GameEvents")

local validSeeds = {
    "Carrot", "Strawberry", "Blueberry", "Tomato", "Cauliflower", "Watermelon", "Green Apple", "Avocado", "Banana",
    "Pineapple", "Kiwi", "Bell Pepper", "Prickly Pear", "Loquat", "Feijoa", "Sugar Apple"
}

local SelectedSeeds = {
    "Carrot","Strawberry","Blueberry","Orange Tulip","Rose","Crocus","Suncoil","Manuka Flower","Lavender", "Tomato","Corn","Daffodil","Dandelion","Raspberry","Pear","Foxglove","Succulent","Nectarshade", "Watermelon","Pumpkin","Apple","Green Apple","Avocado","Bamboo","Lumira","Lilac","Violet Corn","Cranberry","Durian","Moonflower","Starfruit","Papaya", "Coconut","Cactus","Dragon Fruit","Mango","Nectarine","Peach","Pineapple","Pink Lily","Purple Dahlia","Moon Melon","Blood Banana","Eggplant","Passionfruit","Moonglow","Moon Mango", "Grape","Mushroom","Pepper","Cacao","Hive Fruit","Sunflower","Sugar Apple","Dragon Pepper","Lotus","Venus Fly Trap","Cherry Blossom","Crimson Vine","Cursed Fruit","Soul Fruit","Moon Blossom","Candy Blossom", "Beanstalk","Ember Lily","Elephant Ears", "Wild Carrot","Cantaloupe","Parasol Flower","Red Lollipop","Chocolate Carrot","Nightshade","Glowshroom","Mint","Pink Tulip","Bee Balm", "Honeysuckle","Nectar Thorn"
}


local validGears = {
    "Watering Can", "Trowel", "Recall Wrench", "Basic Sprinkler", "Advanced Sprinkler", "Godly Sprinkler", "Tanning Mirror", "Master Sprinkler", "Cleaning Spray", "Favorite Tool", "Harvest Tool", "Friendship Pot"
}

local validEggs = {
    "Common Egg", "Common Summer Egg", "Rare Summer Egg", "Mythical Egg", "Paradise Egg", "Bug Egg"
}

local byallBee = {
    "Flower Seed Pack", "Lavender", "Nectarshade", "Nectarine", "Hive Fruit", "Pollen Radar", "Nectar Staff", "Honey Sprinkler", "Bee Egg", "Bee Crate", "Honey Comb", "Bee Chair", "Honey Torch", "Honey Walkway"
}

local eggIdMap = {
    ["Common Egg"] = 1,
    ["Common Summer Egg"] = 2,
    ["Rare Summer Egg"] = 3,
    ["Mythical Egg"] = 4,
    ["Paradise Egg"] = 5,
    ["Bug Egg"] = 6
}

local buyEvent = nil
local buyGear = nil
local buyPet = nil
local buyBee = nil

if rs:FindFirstChild("GameEvents") then
    local gameEvents = rs.GameEvents
    buyEvent = gameEvents:FindFirstChild("BuySeedStock")
    buyGear = gameEvents:FindFirstChild("BuyGearStock")
    buyPet = gameEvents:FindFirstChild("BuyPetEgg")
    buyBee = gameEvents:FindFirstChild("BuyEventShopStock")
end

local antiAfkEnabled = false
local afkConnection

local selectedSeed = {}
local selectedGears = {}
local selectedEgg = {}
local selectedBees = {}
local autoBuying = false
local autoBuyingGear = false
local autoBuyingAll = false
local bpg = false
local autoBuyingEgg = false
local autoBuyingAllEggs = false
local bsb = false
local autoSubmitAll = false
local submitDelay = 0.1
local hatchAura = false
local AutoPlanting = false
local CurrentlyPlanting = false
local plantingDelay = 0.1
local plantingMode = "Player Position"
local versgame = "Unknown"

local farm = nil
if ws:FindFirstChild("Farm") then
    for _, v in next, ws.Farm:GetDescendants() do
        if v.Name == "Owner" and v:IsA("StringValue") and v.Value == player.Name then
            farm = v.Parent.Parent
            break
        end
    end
end

local function initializeAntiAFK()
    if antiAfkEnabled and not afkConnection then
        afkConnection = player.Idled:Connect(function()
            local VirtualUser = game:GetService("VirtualUser")
            VirtualUser:Button2Down(Vector2.new(0, 0), ws.CurrentCamera.CFrame)
            task.wait(1)
            VirtualUser:Button2Up(Vector2.new(0, 0), ws.CurrentCamera.CFrame)
        end)
    end
end

local function getPlayerPosition()
    local char = player.Character or player.CharacterAdded:Wait()
    local root = char:FindFirstChild("HumanoidRootPart")
    return root and root.Position or Vector3.zero
end

local function getEquippedSeedTool()
    if not player.Character then return nil end

    local equippedTool = player.Character:FindFirstChildOfClass("Tool")
    if equippedTool then
        local seedName = equippedTool.Name:match("^(.-) Seed")
        if seedName and table.find(SelectedSeeds, seedName) then
            return {Tool = equippedTool, SeedName = seedName}
        end
    end
    return nil
end

local function getRandomPosition()
    local playerPos = getPlayerPosition()
    if not playerPos or playerPos == Vector3.zero then
        return playerPos
    end

    local randomX = playerPos.X + math.random(-20, 20)
    local randomZ = playerPos.Z + math.random(-20, 20)

    local randomY = playerPos.Y + math.random(0, 5)

    return Vector3.new(randomX, randomY, randomZ)
end

local function getPlantingPosition()
    if plantingMode == "Random Position" then
        return getRandomPosition()
    else
        return getPlayerPosition()
    end
end

local function plantEquippedSeed(seedName)
    local pos = getPlantingPosition()
    if plantRemote and pos and pos ~= Vector3.zero then
        pcall(function()
            plantRemote:FireServer(pos, seedName)
        end)
    end
end

local function startAutoPlanting()
    if CurrentlyPlanting then return end
    CurrentlyPlanting = true

    task.spawn(function()
        while AutoPlanting do
            pcall(function()
                local equippedSeed = getEquippedSeedTool()

                if equippedSeed then
                    local seedName = equippedSeed.SeedName
                    local tool = equippedSeed.Tool

                    if table.find(SelectedSeeds, seedName) then
                        if player.Character and player.Character:FindFirstChild(tool.Name) then
                            plantEquippedSeed(seedName)
                        end
                    end
                end
            end)
            task.wait(plantingDelay)
        end

        CurrentlyPlanting = false
    end)
end

local function toggleAutoPlanting(state)
    AutoPlanting = state
    if AutoPlanting then
        if not plantRemote then
            return
        end

        if not player.Character then
            player.CharacterAdded:Wait()
        end

        startAutoPlanting()
    end
end

local function setPlantingDelay(delay)
    plantingDelay = math.max(0.1, delay)
end

local function setPlantingMode(mode)
    plantingMode = mode
end

local function startHatchAura()
    if not hatchAura or not farm then return end
    task.spawn(function()
        while hatchAura do
            pcall(function()
                local objectsPhysical = farm:FindFirstChild("Objects_Physical")
                if objectsPhysical and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    for _, v in next, objectsPhysical:GetChildren() do
                        if v:IsA("Model") and v:GetAttribute("TimeToHatch") == 0 and
                           (v:GetPivot().Position - player.Character:GetPivot().Position).Magnitude < 500 then
                            local model = v:FindFirstChildOfClass("Model")
                            if model then
                                for _, v2 in next, model:GetChildren() do
                                    if v2:IsA("ProximityPrompt") and v2.Name == "ProximityPrompt" then
                                        fireproximityprompt(v2)
                                        task.wait(0.00001)
                                    end
                                end
                            end
                        end
                    end
                end
            end)
            task.wait()
        end
    end)
end

function buyPetEggs()
    if not buyPet then return end
    for i = 1, 3 do
        for _, eggName in ipairs(validEggs) do
            local eggId = eggIdMap[eggName]
            if eggId then
                pcall(function()
                    buyPet:FireServer(eggId)
                end)
                task.wait(0.1)
            end
        end
    end
end

function buySelectedEgg()
    if not buyPet or not selectedEgg or selectedEgg == "" then return end
    local eggId = eggIdMap[selectedEgg]
    if eggId then
        pcall(function()
            buyPet:FireServer(eggId)
        end)
    end
end

function byallbeefc()
    if not buyBee or #selectedBees == 0 then return end

    for i = 1, 25 do
        for _, bee in ipairs(selectedBees) do
            pcall(function()
                buyBee:FireServer(bee)
            end)
            task.wait(0.1)
        end
    end
end

function buySelectedItems()
    if not buyBee or #selectedBees == 0 then return end

    for _, item in ipairs(selectedBees) do
        pcall(function()
            buyBee:FireServer(item)
        end)
        task.wait(0.1)
    end
end

local function submitAllSummerWithDelay()
    task.spawn(function()
        while autoSubmitAll do
            pcall(function()
                game:GetService("ReplicatedStorage")
                    :WaitForChild("GameEvents")
                    :WaitForChild("SummerHarvestRemoteEvent")
                    :FireServer("SubmitAllPlants")
            end)
            task.wait(summerSubmitDelay)
        end
    end)
end

local function getGameVersion()
    local success, result = pcall(function()
        if player and player.PlayerGui and player.PlayerGui:FindFirstChild("Version_UI") then
            local versionUI = player.PlayerGui.Version_UI
            if versionUI:FindFirstChild("Version") then
                return (versionUI.Version.Text):gsub("^v", "")
            end
        end
        return "Unknown"
    end)

    return success and result or "Unknown"
end

initializeAntiAFK()
versgame = getGameVersion()

local win = ui:CreateWindow({
    Title = "WreakHub",
    Author = "Made by: @a11bove",
    Folder = "WREAKHUB",
    Size = UDim2.fromOffset(580, 400),
    Transparent = true,
    Theme = "Dark",
    SideBarWidth = 200,
    HideSearchBar = true,
    ScrollBarEnabled = false,
    User = {
        Enabled = true,
        Anonymous = false,
    },
})

win:EditOpenButton({
    Title = "Open UI",
    CornerRadius = UDim.new(0, 26),
    StrokeThickness = 2,
    Color = ColorSequence.new(
        Color3.fromHex("010101"),
        Color3.fromHex("010101")
    ),
    OnlyMobile = true,
    Enabled = true,
    Draggable = true,
})

win:DisableTopbarButtons({
    "Fullscreen",
})

local Info = win:Tab({
    Title = "Main",
    Icon = "house",
    Locked = false,
})

local Main = win:Tab({
    Title = "Farm",
    Icon = "sprout",
    Locked = false,
})

local Shop = win:Tab({
    Title = "Shop",
    Icon = "shopping-cart",
    Locked = false,
})

local Pet = win:Tab({
    Title = "Pet",
    Icon = "paw-print",
    Locked = false,
})

local Events = win:Tab({
    Title = "Events",
    Icon = "star",
    Locked = false,
})

local VisTab = win:Tab({
    Title = "Visual",
    Icon = "eye",
    Locked = false,
})

win:SelectTab(1)

local Paragraph = Info:Paragraph({
    Title = "Author: @a11bove\nCurrent Server Version: " .. versgame,
    Desc = "Join our discord for more updates!",
    Color = "Grey",
    Locked = false,
})

local Button = Info:Button({
    Title = "Copy Discord Link",
    Locked = false,
    Callback = function()
        pcall(function()
            setclipboard("https://discord.gg/6BXx4GdQ")
            game.StarterGui:SetCore("SendNotification", {
                    Title = "WreakHub",
                    Text = "Link Copied!",
                    Duration = 2
                })
                end)
        end,
})

local Section = Info:Section({
    Title = "Utility",
    TextXAlignment = "Left",
})

local toggle = Info:Toggle({
    Title = "Anti-AFK",
    Desc = "Anti idle 20 minutes.",
    Default = true,
    Type = "Checkbox",
    Callback = function(val)
        antiAfkEnabled = val
        if antiAfkEnabled then
            afkConnection = player.Idled:Connect(function()
                local VirtualUser = game:GetService("VirtualUser")
                VirtualUser:Button2Down(Vector2.new(0, 0), ws.CurrentCamera.CFrame)
                task.wait(1)
                VirtualUser:Button2Up(Vector2.new(0, 0), ws.CurrentCamera.CFrame)
            end)
        else
            if afkConnection then
                afkConnection:Disconnect()
                afkConnection = nil
            end
        end
    end
})

local Button = Info:Button({
    Title = "Rejoin",
    Locked = false,
    Callback = function()
        pcall(function()
            ts:TeleportToPlaceInstance(game.PlaceId, game.JobId, player)
        end)
    end
})

local Button = Info:Button({
    Title = "Server Hop",
    Locked = false,
    Callback = function()
        pcall(function()
            local servers = hs:JSONDecode(game:HttpGet("https://gamesroblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))

            if servers and servers.data then
                for i, server in pairs(servers.data) do
                    if server.id ~= game.JobId and server.playing < server.maxPlayers then
                        ts:TeleportToPlaceInstance(game.PlaceId, server.id, player)
                        break
                    end
                end
            else
                ts:Teleport(game.PlaceId, player)
            end
        end)
    end
})

local Section = Info:Section({
    Title = "Player Settings",
    TextXAlignment = "Left",
})

local WalkspeedSlider = Info:Slider({
    Title = "Walkspeed",
    Step = 1,
    Value = {
        Min = 16,
        Max = 200,
        Default = 16,
    },
    Callback = function(value)
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = value
        end
    end
})

local JumpHeightSlider = Info:Slider({
    Title = "Jump Height",
    Step = 1,
    Value = {
        Min = 50,
        Max = 200,
        Default = 50,
    },
    Callback = function(value)
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.JumpPower = value
        end
    end
})

local Section = Main:Section({
    Title = "Auto",
    TextXAlignment = "Left",
})

local cTogglee = Main:Toggle({
    Title = "Auto Collect",
    Desc = "Auto harvest nearby crops.",
    Default = false,
    Type = "Checkbox",
    Callback = function()
        end
})

local PlantingDelaySlider = Main:Slider({
    Title = "Auto Plant Delay",
    Step = 0.1,
    Value = {
        Min = 0.1,
        Max = 2.0,
        Default = 0.1,
    },
    Callback = function(value)
        setPlantingDelay(value)
    end
})

local PlantingModeDropdown = Main:Dropdown({
    Title = "Auto Plant Position",
    Values = {"Player Position", "Random Position"},
    Value = "Player Position",
    Multi = false,
    AllowNone = false,
    Callback = function(value)
        setPlantingMode(value)
    end
})

local pToggle = Main:Toggle({
    Title = "Auto Plant",
    Desc = "Automatically plants any seed.",
    Default = false,
    Type = "Checkbox",
    Callback = function(state)
        toggleAutoPlanting(state)
    end
})

local HToggle = Main:Toggle({
    Title = "Auto Hatch",
    Desc = "Automatically hatches any egg.",
    Default = false,
    Type = "Checkbox",
    Callback = function(state)
        hatchAura = state
        if state then
            startHatchAura()
        end
    end
})

local Section = Shop:Section({
    Title = "Auto Buy Seeds",
    TextXAlignment = "Left",
})

local Dropdown = Shop:Dropdown({
    Title = "Select Seeds",
    Values = validSeeds,
    Value = {},
    Multi = true,
    AllowNone = true,
    Callback = function(Options)
        selectedSeed = Options or {}
    end
})

local Toggle = Shop:Toggle({
    Title = "Auto Buy Selected Seed",
    Default = false,
    Type = "Checkbox",
    Callback = function(val)
        autoBuying = val
        task.spawn(function()
            while autoBuying do
                if buyEvent and selectedSeed and type(selectedSeed) == "table" and #selectedSeed > 0 then
                    for _, seed in ipairs(selectedSeed) do
                        pcall(function()
                            buyEvent:FireServer(seed)
                        end)
                        task.wait(0.1)
                    end
                elseif buyEvent and selectedSeed and type(selectedSeed) == "string" and selectedSeed ~= "" then
                    pcall(function()
                        buyEvent:FireServer(selectedSeed)
                    end)
                end
                task.wait(0.1)
            end
        end)
    end
})

local ToggleAll = Shop:Toggle({
    Title = "Auto Buy All Seeds",
    Default = false,
    Type = "Checkbox",
    Callback = function(val)
        autoBuyingAll = val
        task.spawn(function()
            while autoBuyingAll do
                if buyEvent then
                    for _, seed in ipairs(validSeeds) do
                        pcall(function()
                            buyEvent:FireServer(seed)
                        end)
                        task.wait(0.1)
                    end
                end
            end
        end)
    end
})

local Section = Shop:Section({
    Title = "Auto Buy Gears",
    TextXAlignment = "Left",
})

local Dropdown = Shop:Dropdown({
    Title = "Select Gears",
    Values = validGears,
    Value = {},
    Multi = true,
    AllowNone = true,
    Callback = function(Options)
        selectedGears = Options or {}
    end
})

local Toggle = Shop:Toggle({
    Title = "Auto Buy Selected Gear",
    Locked = false,
    Type = "Checkbox",
    Callback = function(val)
        autoBuyingGear = val
        task.spawn(function()
            while autoBuyingGear do
                if buyGear and #selectedGears > 0 then
                            for _, gear in ipairs(selectedGears) do
                                pcall(function()
                                    buyGear:FireServer(gear)
                                    end)
                                task.wait(0.1)
                            end
                        end
                        task.wait(0.1)
                    end
                end)
        end
})

local Toggle = Shop:Toggle({
    Title = "Auto Buy All Gear",
    Locked = false,
    Type = "Checkbox",
    Callback = function(val)
        autoBuyingAll = val
        task.spawn(function()
            while autoBuyingAll do
                if buyGear then
                    for _, gear in ipairs(validGears) do
                        pcall(function()
                            buyGear:FireServer(gear)
                        end)
                        task.wait(0.1)
                    end
                end
            end
        end)
    end
})

local Section = Shop:Section({
    Title = "Auto Buy Eggs",
    TextXAlignment = "Left",
})

local EggDropdown = Shop:Dropdown({
    Title = "Select Eggs",
    Values = validEggs,
    Value = {},
    Multi = true,
    AllowNone = true,
    Callback = function(Options)
        selectedEgg = Options or {}
    end
})

local ToggleEgg = Shop:Toggle({
    Title = "Auto Buy Selected Egg",
    Default = false,
    Type = "Checkbox",
    Callback = function(val)
        autoBuyingEgg = val
        task.spawn(function()
            while autoBuyingEgg do
                if buyPet and selectedEgg and type(selectedEgg) == "table" and #selectedEgg > 0 then
                    for _, eggName in ipairs(selectedEgg) do
                        local eggId = eggIdMap[eggName]
                        if eggId then
                            pcall(function()
                                buyPet:FireServer(eggId)
                            end)
                        end
                        task.wait(0.1)
                    end
                elseif buyPet and selectedEgg and type(selectedEgg) == "string" and selectedEgg ~= "" then
                    local eggId = eggIdMap[selectedEgg]
                    if eggId then
                        pcall(function()
                            buyPet:FireServer(eggId)
                        end)
                    end
                end
                task.wait(0.1)
            end
        end)
    end
})

local Toggle = Shop:Toggle({
    Title = "Auto Buy All Eggs",
    Default = false,
    Type = "Checkbox",
    Callback = function(val)
        autoBuyingAllEggs = val
        task.spawn(function()
            while autoBuyingAllEggs do
                if buyPet then
                    for _, eggName in ipairs(validEggs) do
                        local eggId = eggIdMap[eggName]
                        if eggId then
                            pcall(function()
                                buyPet:FireServer(eggId)
                            end)
                        end
                        task.wait(0.1)
                    end
                end
            end
        end)
    end
})

local Section = Shop:Section({
    Title = "Sell Items",
    TextXAlignment = "Left",
})

local Button = Shop:Button({
    Title = "Sell Inventory",
    Locked = false,
    Callback = function()
        local sellPos = CFrame.new(86.57965850830078, 2.999999761581421, 0.4267919063568115)
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")

        if hrp and rs:FindFirstChild("GameEvents") and rs.GameEvents:FindFirstChild("Sell_Inventory") then
            pcall(function()
                local orig = hrp.CFrame
                hrp.CFrame = sellPos
                task.wait(0.3)
                rs.GameEvents.Sell_Inventory:FireServer()
                task.wait(0.3)
                hrp.CFrame = orig
            end)
        end
    end
})

local Button = Shop:Button({
    Title = "Sell Fruit In Hand",
    Locked = false,
    Callback = function()
        local sellPos = CFrame.new(86.57965850830078, 2.999999761581421, 0.4267919063568115)
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")

        if hrp and rs:FindFirstChild("GameEvents") and rs.GameEvents:FindFirstChild("Sell_Item") then
            pcall(function()
                local orig = hrp.CFrame
                hrp.CFrame = sellPos
                task.wait(0.3)
                rs.GameEvents.Sell_Item:FireServer()
                task.wait(0.3)
                hrp.CFrame = orig
            end)
        end
    end
})

local Button = Shop:Button({
    Title = "Sell A Pet",
    Locked = false,
    Callback = function()
        local sellPos = CFrame.new(86.57965850830078, 2.999999761581421, 0.4267919063568115)
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if hrp and rs:FindFirstChild("GameEvents") and rs.GameEvents:FindFirstChild("SellPet_RE") then
            pcall(function()
                local orig = hrp.CFrame
                hrp.CFrame = sellPos
                task.wait(0.3)

                local character = player.Character
                local heldTool = character:FindFirstChildOfClass("Tool")

                if heldTool and 
                   heldTool:FindFirstChild("PetToolLocal") and 
                   string.match(heldTool.Name, "%[Age%s%d+%]") then
                    rs.GameEvents.SellPet_RE:FireServer(heldTool)
                end

                task.wait(0.3)
                hrp.CFrame = orig
            end)
        end
    end
})

local EvSection = Events:Section({
    Title = "Summer Harvest Event",
    TextXAlignment = "Left",
})

local SummerDelaySlider = Events:Slider({
    Title = "Auto Submit Delay",
    Step = 0.1,
    Value = {
        Min = 0.1,
        Max = 10.0,
        Default = 0.1,
    },
    Callback = function(value)
        summerSubmitDelay = value
    end
})

local EvToggleAutoAll = Events:Toggle({
    Title = "Auto Submit All Summer Plants",
    Default = false,
    Type = "Checkbox",
    Callback = function(val)
        autoSubmitAll = val
        if autoSubmitAll then
            submitAllSummerWithDelay()
        end
    end
})

local EvButtonInstant = Events:Button({
    Title = "Instant Submit Summer Plants",
    Locked = false,
    Callback = function()
        pcall(function()
            game:GetService("ReplicatedStorage")
                :WaitForChild("GameEvents")
                :WaitForChild("SummerHarvestRemoteEvent")
                :FireServer("SubmitAllPlants")
        end)
    end
})

local EventSection = Events:Section({
    Title = "Bizzy Bee's Event",
    TextXAlignment = "Left",
})

local EventDropdown = Events:Dropdown({
    Title = "Select Items",
    Values = byallBee,
    Value = {},
    Multi = true,
    AllowNone = true,
    Callback = function(Options)
        selectedBees = Options or {}
    end
})

local BuySelectedButton = Events:Button({
    Title = "Buy Selected Items",
    Callback = function()
        buySelectedItems()
    end
})

local EventToggle = Events:Toggle({
    Title = "Auto Buy Selected Items",
    Default = false,
    Type = "Checkbox",
    Callback = function(val)
        bsb = val
    end
})

local espEnabled = false
local espCache = {}
local activeEggs = {}

local function setEspEnabled(state)
    espEnabled = state
    if not espEnabled then
        for objectId, labelData in pairs(espCache) do
            if labelData then
                if labelData.timeLabel then
                    labelData.timeLabel.Visible = false
                end
                if labelData.nameLabel then
                    labelData.nameLabel.Visible = false
                end
            end
        end
    end
end

local function checkDrawingSupport()
    if not Drawing then
        warn("Drawing API not available - ESP features disabled")
        return false
    end
    return true
end

local function initializeEggData()
    local eggModels, eggPets

    pcall(function()
        if game:GetService("ReplicatedStorage"):FindFirstChild("GameEvents") and 
           game:GetService("ReplicatedStorage").GameEvents:FindFirstChild("PetEggService") then

            local connections = getconnections(game:GetService("ReplicatedStorage").GameEvents.PetEggService.OnClientEvent)
            if connections and #connections > 0 and connections[1] and connections[1].Function then
                local mainFunc = connections[1].Function

                if getupvalue then
                    local upvalue1 = getupvalue(mainFunc, 1)
                    if upvalue1 then
                        local hatchFunction = getupvalue(upvalue1, 2)
                        if hatchFunction then
                            eggModels = getupvalue(hatchFunction, 1)
                            eggPets = getupvalue(hatchFunction, 2)
                        end
                    end
                end
            end
        end
    end)

    return eggModels, eggPets
end

local eggModels, eggPets
pcall(function()
    eggModels, eggPets = initializeEggData()
end)

local function getObjectFromId(objectId)
    if not eggModels or not objectId then return nil end

    local foundObject = nil
    pcall(function()
        for eggModel in pairs(eggModels) do
            if eggModel and eggModel:GetAttribute("OBJECT_UUID") == objectId then
                foundObject = eggModel
                break
            end
        end
    end)

    return foundObject
end

local function formatTime(seconds)
    if seconds <= 0 then
        return "Ready!"
    end

    local hours = math.floor(seconds / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    local secs = math.floor(seconds % 60)

    if hours > 0 then
        return string.format("%dh %dm %ds", hours, minutes, secs)
    elseif minutes > 0 then
        return string.format("%dm %ds", minutes, secs)
    else
        return string.format("%ds", secs)
    end
end

local function addEsp(object)
    pcall(function()
        if not object or not object.Parent then return end
        if object:GetAttribute("OWNER") ~= game.Players.LocalPlayer.Name then return end

        local objectId = object:GetAttribute("OBJECT_UUID")
        if not objectId then return end

        local eggName = object:GetAttribute("EggName") or "Egg"
        local petName = "?"

        if eggPets and eggPets[objectId] then
            petName = eggPets[objectId]
        end

        if Drawing then
            local timeLabel = Drawing.new("Text")
            timeLabel.Text = "Calculating..."
            timeLabel.Size = 12
            timeLabel.Color = Color3.fromRGB(61, 168, 255)
            timeLabel.Outline = true
            timeLabel.OutlineColor = Color3.new(0, 0, 0)
            timeLabel.Center = true
            timeLabel.Visible = false

            local nameLabel = Drawing.new("Text")
            nameLabel.Text = eggName .. " | " .. petName
            nameLabel.Size = 12
            nameLabel.Color = Color3.new(1, 1, 1)
            nameLabel.Outline = true
            nameLabel.OutlineColor = Color3.new(0, 0, 0)
            nameLabel.Center = true
            nameLabel.Visible = false

            espCache[objectId] = {
                timeLabel = timeLabel,
                nameLabel = nameLabel
            }
            activeEggs[objectId] = object
        end
    end)
end

local function removeEsp(object)
    pcall(function()
        if not object then return end
        if object:GetAttribute("OWNER") ~= game.Players.LocalPlayer.Name then return end

        local objectId = object:GetAttribute("OBJECT_UUID")
        if objectId and espCache[objectId] then
            if espCache[objectId].timeLabel then
                espCache[objectId].timeLabel:Remove()
            end
            if espCache[objectId].nameLabel then
                espCache[objectId].nameLabel:Remove()
            end
            espCache[objectId] = nil
        end
        if objectId then
            activeEggs[objectId] = nil
        end
    end)
end

local function updateEsp(objectId, petName)
    pcall(function()
        local object = getObjectFromId(objectId)
        if object and espCache[objectId] and espCache[objectId].nameLabel then
            local eggName = object:GetAttribute("EggName") or "Egg"
            espCache[objectId].nameLabel.Text = eggName .. " | " .. (petName or "?")
        end
    end)
end

local function updateAllEsp()
    if not espEnabled then return end

    for objectId, object in pairs(activeEggs) do
        if not object or not object:IsDescendantOf(workspace) then
            activeEggs[objectId] = nil
            if espCache[objectId] then
                if espCache[objectId].timeLabel then
                    espCache[objectId].timeLabel.Visible = false
                end
                if espCache[objectId].nameLabel then
                    espCache[objectId].nameLabel.Visible = false
                end
            end
            continue
        end

        local labelData = espCache[objectId]
        if labelData and labelData.timeLabel and labelData.nameLabel then
            local pos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(object:GetPivot().Position)
            if onScreen then
                local timeToHatch = object:GetAttribute("TimeToHatch") or 0
                local timeText = formatTime(timeToHatch)

                if timeToHatch <= 0 then
                    labelData.timeLabel.Color = Color3.fromRGB(0, 255, 0) -- Green for ready
                    labelData.timeLabel.Text = "Ready to Hatch!"
                elseif timeToHatch <= 60 then
                    labelData.timeLabel.Color = Color3.fromRGB(255, 255, 0) -- Yellow for soon
                    labelData.timeLabel.Text = "" .. timeText
                else
                    labelData.timeLabel.Color = Color3.fromRGB(61, 168, 255) -- Blue for waiting
                    labelData.timeLabel.Text = "" .. timeText
                end

                labelData.timeLabel.Position = Vector2.new(pos.X, pos.Y - 20)
                labelData.timeLabel.Visible = true

                labelData.nameLabel.Position = Vector2.new(pos.X, pos.Y)
                labelData.nameLabel.Visible = true
            else
                labelData.timeLabel.Visible = false
                labelData.nameLabel.Visible = false
            end
        end
    end
end

pcall(function()
    for _, object in pairs(game:GetService("CollectionService"):GetTagged("PetEggServer")) do
        addEsp(object)
    end

    game:GetService("CollectionService"):GetInstanceAddedSignal("PetEggServer"):Connect(addEsp)
    game:GetService("CollectionService"):GetInstanceRemovedSignal("PetEggServer"):Connect(removeEsp)
end)

pcall(function()
    if game:GetService("ReplicatedStorage"):FindFirstChild("GameEvents") and
       game:GetService("ReplicatedStorage").GameEvents:FindFirstChild("EggReadyToHatch_RE") then

        local connections = getconnections(game:GetService("ReplicatedStorage").GameEvents.EggReadyToHatch_RE.OnClientEvent)
        if connections and #connections > 0 and connections[1] and connections[1].Function then
            local old = hookfunction(connections[1].Function, newcclosure(function(objectId, petName)
                updateEsp(objectId, petName)
                return old(objectId, petName)
            end))
        end
    end
end)

game:GetService("RunService").PreRender:Connect(updateAllEsp)

local ESPSection = VisTab:Section({
    Title = "ESP",
    TextXAlignment = "Left",
})

local EggESPToggle = VisTab:Toggle({
    Title = "Egg ESP",
    Default = false,
    Type = "Checkbox",
    Callback = function(state)
        if state and not checkDrawingSupport() then
            pcall(function()
                EggESPToggle:Set(false)
            end)
            pcall(function()
                game.StarterGui:SetCore("SendNotification", {
                    Title = "WreakHub",
                    Text = "ESP not supported on this executor",
                    Duration = 3
                })
            end)
            return
        end
        setEspEnabled(state)
    end
})

local Section = VisTab:Section({
    Title = "Shop Ui's",
    TextXAlignment = "Left",
})

local Button = VisTab:Button({
    Title = "Seed Shop",
    Locked = false,
    Callback = function()
        local gui = player.PlayerGui
        if gui:FindFirstChild("Seed_Shop") then
            local seedShop = gui.Seed_Shop
            seedShop.Enabled = not seedShop.Enabled

            if seedShop.Enabled then
                if gui:FindFirstChild("DailyQuests_UI") then gui.DailyQuests_UI.Enabled = false end
                if gui:FindFirstChild("Gear_Shop") then gui.Gear_Shop.Enabled = false end
                if gui:FindFirstChild("HoneyEventShop_UI") then gui.HoneyEventShop_UI.Enabled = false end
                if gui:FindFirstChild("CosmeticShop_UI") then gui.CosmeticShop_UI.Enabled = false end
            end
        end
    end
})

local Button = VisTab:Button({
    Title = "Gear Shop",
    Locked = false,
    Callback = function()
        local gui = player.PlayerGui
        if gui:FindFirstChild("Gear_Shop") then
            local gearShop = gui.Gear_Shop
            gearShop.Enabled = not gearShop.Enabled

            if gearShop.Enabled then
                if gui:FindFirstChild("DailyQuests_UI") then gui.DailyQuests_UI.Enabled = false end
                if gui:FindFirstChild("Seed_Shop") then gui.Seed_Shop.Enabled = false end
                if gui:FindFirstChild("HoneyEventShop_UI") then gui.HoneyEventShop_UI.Enabled = false end
                if gui:FindFirstChild("CosmeticShop_UI") then gui.CosmeticShop_UI.Enabled = false end
            end
        end
    end
})

local Button = VisTab:Button({
    Title = "Daily Quest",
    Locked = false,
    Callback = function()
        local gui = player.PlayerGui
        if gui:FindFirstChild("DailyQuests_UI") then
            local dailyQuest = gui.DailyQuests_UI
            dailyQuest.Enabled = not dailyQuest.Enabled

            if dailyQuest.Enabled then
                if gui:FindFirstChild("Seed_Shop") then gui.Seed_Shop.Enabled = false end
                if gui:FindFirstChild("Gear_Shop") then gui.Gear_Shop.Enabled = false end
                if gui:FindFirstChild("HoneyEventShop_UI") then gui.HoneyEventShop_UI.Enabled = false end
                if gui:FindFirstChild("CosmeticShop_UI") then gui.CosmeticShop_UI.Enabled = false end
            end
        end
    end
})

local Button = VisTab:Button({
    Title = "Honey Shop",
    Locked = false,
    Callback = function()
        local gui = player.PlayerGui
        if gui:FindFirstChild("HoneyEventShop_UI") then
            local honeyShop = gui.HoneyEventShop_UI
            honeyShop.Enabled = not honeyShop.Enabled

            if honeyShop.Enabled then
                if gui:FindFirstChild("Seed_Shop") then gui.Seed_Shop.Enabled = false end
                if gui:FindFirstChild("DailyQuests_UI") then gui.DailyQuests_UI.Enabled = false end
                if gui:FindFirstChild("Gear_Shop") then gui.Gear_Shop.Enabled = false end
                if gui:FindFirstChild("CosmeticShop_UI") then gui.CosmeticShop_UI.Enabled = false end
            end
        end
    end
})

local Button = VisTab:Button({
    Title = "Cosmetic Shop",
    Locked = false,
    Callback = function()
        local gui = player.PlayerGui
        if gui:FindFirstChild("CosmeticShop_UI") then
            local cosmeticShop = gui.CosmeticShop_UI
            cosmeticShop.Enabled = not cosmeticShop.Enabled

            if cosmeticShop.Enabled then
                if gui:FindFirstChild("Seed_Shop") then gui.Seed_Shop.Enabled = false end
                if gui:FindFirstChild("DailyQuests_UI") then gui.DailyQuests_UI.Enabled = false end
                if gui:FindFirstChild("Gear_Shop") then gui.Gear_Shop.Enabled = false end
                if gui:FindFirstChild("HoneyEventShop_UI") then gui.HoneyEventShop_UI.Enabled = false end
            end
        end
    end
})

task.spawn(function()
    while true do
        pcall(function()
            if bpg then
                task.spawn(buyPetEggs)
            end
            if bsb then
                task.spawn(byallbeefc)
            end
        end)
        task.wait(1)
    end
end)
