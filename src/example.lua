-- [[ Load UI ]]
local Library = loadstring(game:HttpGet("RAW"))()

-- [[ Load Window ]]
local Window = Library:Window({
    Title   = "Fluriore |",                --- title
    Footer  = "Example",                   --- in right after title
    Image   = "136505615779937",           ---- rbxassetid (texture)
    Color   = Color3.fromRGB(138, 43, 226), --- dark purple colour text/ui
    Theme   = 9542022979,                  ---- background for theme ui (rbxassetid)
    Version = 1,                           --- version config set as default 1 if u remake / rewrite / big update and change name in your hub change it to 2 and config will reset
})

--- [[ Notify ]]
if Window then
    fluriore("Window loaded!")
end

--- Or Use Like This
--- Library:MakeNotify({
--- Title = "Fluriore", -- change to your hub name
--- Description = "Notification",
--- Content = "Example notification",
--- Color = Color3.fromRGB(138, 43, 226),
--- Delay = 4
--- })

--- [[ Make a tab ]]
local Tabs = {
    Info = Window:AddTab({ Name = "Info", Icon = "player" }), --- rbxassetid / robloxassetid (decals - texture)
    Main = Window:AddTab({ Name = "Main", Icon = "user" }),
}

-- [[ Make A Section for tab ]]
X1 = Tabs.Info:AddSection("Fluriore | Section") -- [[ X1 = for load elements section ]] ,
-- X1 = Tabs.Info:AddSection("Fluriore Section", false) set as default open after load UI
-- X1 = Tabs.Info:AddSection("Fluriore Section", true) set as default always open (cant closed section) after load UI

--- [[ Paragraph ]]
X1:AddParagraph({
    Title = "Fluriore | Community",
    Content = "Fluriore Library System",
    Icon = "star",
})

--- [[ Paragraph with button ]]
X1:AddParagraph({
    Title = "Join Our Discord",
    Content = "Join Us!",
    Icon = "discord",
    ButtonText = "Copy Discord Link",
    ButtonCallback = function()
        local link = "https://discord.gg/fluriore"
        if setclipboard then
            setclipboard(link)
            fluriore("Successfully Copied!")
        end
    end
})

--- [[ Divider ]]
X1:AddDivider()

--- [[ Sub Section ]]
X1:AddSubSection("FLURIORE LIBRARY")

PanelSection = Tabs.Main:AddSection("Fluriore | Panel")

--- [[ Panel with 2 buttons ]]
PanelSection:AddPanel({
    Title = "Fluriore | Discord",
    --  Content = "Sub Title", --- can use sub title here.
    ButtonText = "Copy Discord Link",
    ButtonCallback = function()
        if setclipboard then
            setclipboard("https://discord.gg/fluriore")
            fluriore("Discord link has been copied to clipboard.")
        else
            fluriore("Executor does not support setclipboard.")
        end
    end,
    SubButtonText = "Open Discord",
    SubButtonCallback = function()
        fluriore("Opening Discord link...")
        task.spawn(function()
            game:GetService("GuiService"):OpenBrowserWindow("https://discord.gg/fluriore")
        end)
    end
})

-- [[ Panel with 2 Buttons + 1 Input ]]
PanelSection:AddPanel({
    Title = "Fluriore | Utility",
    Placeholder = "https://discord.com/api/webhooks/...",
    ButtonText = "Rejoin Server",
    ButtonCallback = function()
        fluriore("Rejoining server...")
        task.wait(1)
        game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
    end
})

--= [[ Panel with 2 Buttons + 1 Input]]
PanelSection:AddPanel({
    Title = "Fluriore | Webhook",
    Placeholder = "https://discord.com/api/webhooks/...",
    ButtonText = "Save Webhook",
    ButtonCallback = function(url)
        if url == "" then
            fluriore("Please enter a webhook URL first.")
            return
        end
        _G.FlurioreWebhook = url
        ConfigData.WebhookURL = url
        SaveConfig()
        fluriore("Webhook has been saved.")
    end,
    SubButtonText = "Test Webhook",
    SubButtonCallback = function()
        if not _G.FlurioreWebhook or _G.FlurioreWebhook == "" then
            fluriore("Webhook has not been set.")
            return
        end
        fluriore("Sending test webhook...")
        task.spawn(function()
            local HttpService = game:GetService("HttpService")
            local data = { content = "Test webhook from Fluriore." }
            pcall(function()
                HttpService:PostAsync(_G.FlurioreWebhook, HttpService:JSONEncode(data))
            end)
        end)
    end
})

-- [[ Button Section ]]
local BtnSection = Tabs.Main:AddSection("Fluriore | Button")

-- [[ Single Button ]]
BtnSection:AddButton({
    Title = "Open Discord",
    Callback = function()
        fluriore("Opening Discord...")
        task.spawn(function()
            game:GetService("GuiService"):OpenBrowserWindow("https://discord.gg/fluriore")
        end)
    end
})

-- [[ Double Button ]]
BtnSection:AddButton({
    Title = "Rejoin",
    SubTitle = "Server Hop",
    Callback = function()
        fluriore("Rejoining server...")
        task.wait(1)
        game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
    end,
    SubCallback = function()
        fluriore("Looking for new server...")
        local Http = game:GetService("HttpService")
        local TPS = game:GetService("TeleportService")
        local Servers = Http:JSONDecode(game:HttpGetAsync("https://games.roblox.com/v1/games/" ..
            game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
        for _, v in pairs(Servers.data) do
            if v.playing < v.maxPlayers then
                TPS:TeleportToPlaceInstance(game.PlaceId, v.id, game.Players.LocalPlayer)
                return
            end
        end
        fluriore("No empty servers found.")
    end
})

-- [[ Toggle Section ]]
local ToggleSection = Tabs.Main:AddSection("Fluriore | Toggle")

-- [[ Single Toggle ]]
ToggleSection:AddToggle({
    Title = "Auto Fishing",
    Content = "Enable auto fishing using Fluriore System.",
    Default = false,
    Callback = function(state)
        if state then
            fluriore("Auto Fishing enabled.")
            _G.AutoFish = true
        else
            fluriore("Auto Fishing disabled.")
            _G.AutoFish = false
        end
    end
})

-- [[ Toggle with Sub Title ]]
ToggleSection:AddToggle({
    Title = "Auto Sell",
    Title2 = "Sell All Fish Automatically",
    Content = "Sell all fish after catching them.",
    Default = false,
    Callback = function(state)
        if state then
            fluriore("Auto Sell enabled.")
            _G.AutoSell = true
        else
            fluriore("Auto Sell disabled.")
            _G.AutoSell = false
        end
    end
})

-- [[ Slider Section ]]
local SliderSection = Tabs.Main:AddSection("Fluriore | Slider")

-- [[ Slider for Fishing Delay ]]
SliderSection:AddSlider({
    Title = "Fishing Delay",
    Content = "Adjust auto fishing delay time.",
    Min = 0.1,
    Max = 5,
    Increment = 0.1,
    Default = 1,
    Callback = function(value)
        _G.Delay = value
        fluriore("Delay set to: " .. tostring(value) .. " seconds.")
    end
})

-- [[ Slider for Volume Control ]]
SliderSection:AddSlider({
    Title = "Sound Volume",
    Content = "Adjust Fluriore sound effects volume.",
    Min = 0,
    Max = 100,
    Increment = 5,
    Default = 50,
    Callback = function(value)
        fluriore("Volume changed to: " .. tostring(value) .. "%")
    end
})

-- [[ Slider for Animation Speed ]]
SliderSection:AddSlider({
    Title = "Animation Speed",
    Content = "Adjust Fluriore interface animation speed.",
    Min = 0.5,
    Max = 2,
    Increment = 0.1,
    Default = 1,
    Callback = function(value)
        _G.AnimationSpeed = value
        fluriore("Animation speed set to: " .. tostring(value) .. "x")
    end
})

-- [[ Input Section ]]
local InputSection = Tabs.Main:AddSection("Fluriore | Input")

-- [[ Input ]]
InputSection:AddInput({
    Title = "Username",
    Content = "Enter your username to save in configuration.",
    Default = "",
    Callback = function(value)
        _G.FlurioreUsername = value
        fluriore("Username set to: " .. value)
    end
})

-- [[ Dropdown Section ]]
local DropdownSection = Tabs.Main:AddSection("Fluriore | Dropdown")

-- [[ Basic Dropdown ]]
DropdownSection:AddDropdown({
    Title = "Select Theme",
    Content = "Choose interface theme for Fluriore.",
    Options = { "Celestial", "Seraphin", "Nebula", "Luna" },
    Default = "Celestial",
    Callback = function(value)
        _G.SelectedTheme = value
        fluriore("Theme changed to: " .. value)
    end
})

-- [[ Multi Select Dropdown ]]
DropdownSection:AddDropdown({
    Title = "Select Features",
    Content = "Choose multiple Fluriore features to enable.",
    Multi = true,
    Options = { "Auto Fishing", "Auto Sell", "Auto Quest", "Webhook Notification" },
    Default = { "Auto Fishing" },
    Callback = function(selected)
        _G.ActiveFeatures = selected
        fluriore("Active features: " .. table.concat(selected, ", "))
    end
})

-- [[ Dynamic Dropdown ]]
local DynamicDropdown = DropdownSection:AddDropdown({
    Title = "Select Bait",
    Content = "Choose bait to use.",
    Options = {},
    Default = nil,
    Callback = function(value)
        _G.SelectedBait = value
        fluriore("Bait selected: " .. value)
    end
})

--- refresh dropdown values using SetValues
task.spawn(function()
    task.wait(1)
    local baitList = { "Common Bait", "Rare Bait", "Mythic Bait", "Divine Bait" }
    DynamicDropdown:SetValues(baitList, "Common Bait")
end)
