-- Load UI Library
local Chloex = loadstring(game:HttpGet("https://raw.githubusercontent.com/a11bove/kdoaz/refs/heads/main/src/Library.lua"))()

-- Create Window
local Window = Chloex:Window({
    Title   = "@aikoware |",                -- Main title
    Footer  = "made by untog",              -- Text after title
    Image   = "136505615779937",            -- Texture ID
    Color   = Color3.fromRGB(0, 208, 255),  -- UI color
    Theme   = 9542022979,                   -- Background theme ID
    Version = 1,                            -- Config version (change to reset configs)
})

-- Notification Example
Chloex:MakeNotify({
    Title = "@aikoware",
    Description = "Notification",
    Content = "Example notification",
    Color = Color3.fromRGB(0, 208, 255),
    Delay = 4
})

-- Create Tabs
local Tabs = {
    Info = Window:AddTab({ Name = "Info", Icon = "player" }),
    Main = Window:AddTab({ Name = "Main", Icon = "user" }),
}

-- Create Section
X1 = Tabs.Info:AddSection("@aikoware | Section")
-- X1 = Tabs.Info:AddSection("Section Name", false) -- Default closed
-- X1 = Tabs.Info:AddSection("Section Name", true) -- Always open

-- Paragraph
X1:AddParagraph({
    Title = "@aikoware | UI",
    Content = "Chloe X UI Modified by @untog",
    Icon = "star",
})

-- Paragraph with Button
X1:AddParagraph({
    Title = "Join Our Discord",
    Content = "Join Us!",
    Icon = "discord",
    ButtonText = "Copy Discord Link",
    ButtonCallback = function()
        local link = "https://discord.gg/chloex"
        if setclipboard then
            setclipboard(link)
            chloex("Successfully Copied!")
        end
    end
})

-- Divider
X1:AddDivider()

-- Sub Section
X1:AddSubSection("SUB SECTION")

-- Panel Section
PanelSection = Tabs.Main:AddSection("@aikoware | Panel")

-- Panel with 2 Buttons
PanelSection:AddPanel({
    Title = "@aikoware | Discord",
    Content = "Optional Subtitle", -- Optional
    ButtonText = "Copy Discord Link",
    ButtonCallback = function()
        if setclipboard then
            setclipboard("https://discord.gg/chloex")
            chloex("Discord link copied to clipboard.")
        else
            chloex("Executor doesn't support setclipboard.")
        end
    end,
    SubButtonText = "Open Discord",
    SubButtonCallback = function()
        chloex("Opening Discord link...")
        task.spawn(function()
            game:GetService("GuiService"):OpenBrowserWindow("https://discord.gg/chloex")
        end)
    end
})

-- Panel with Input and Button
PanelSection:AddPanel({
    Title = "@aikoware | Utility",
    Placeholder = "https://discord.com/api/webhooks/...",
    ButtonText = "Rejoin Server",
    ButtonCallback = function()
        chloex("Rejoining server...")
        task.wait(1)
        game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
    end
})

-- Panel with Input and 2 Buttons
PanelSection:AddPanel({
    Title = "@aikoware | Webhook",
    Placeholder = "https://discord.com/api/webhooks/...",
    ButtonText = "Save Webhook",
    ButtonCallback = function(url)
        if url == "" then
            chloex("Please enter webhook URL first.")
            return
        end
        _G.ChloeWebhook = url
        ConfigData.WebhookURL = url
        SaveConfig()
        chloex("Webhook saved.")
    end,
    SubButtonText = "Test Webhook",
    SubButtonCallback = function()
        if not _G.ChloeWebhook or _G.ChloeWebhook == "" then
            chloex("Webhook not set.")
            return
        end
        chloex("Sending test webhook...")
        task.spawn(function()
            local HttpService = game:GetService("HttpService")
            local data = { content = "Test webhook from Chloe X." }
            pcall(function()
                HttpService:PostAsync(_G.ChloeWebhook, HttpService:JSONEncode(data))
            end)
        end)
    end
})

-- Button Section
local BtnSection = Tabs.Main:AddSection("@aikoware | Button")

-- Single Button
BtnSection:AddButton({
    Title = "Open Discord",
    Callback = function()
        chloex("Opening Discord...")
        task.spawn(function()
            game:GetService("GuiService"):OpenBrowserWindow("https://discord.gg/chloex")
        end)
    end
})

-- Double Button
BtnSection:AddButton({
    Title = "Rejoin",
    SubTitle = "Server Hop",
    Callback = function()
        chloex("Rejoining server...")
        task.wait(1)
        game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
    end,
    SubCallback = function()
        chloex("Finding new server...")
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
        chloex("No available servers found.")
    end
})

-- Toggle Section
local ToggleSection = Tabs.Main:AddSection("Chloe X | Toggle")

-- Single Toggle
ToggleSection:AddToggle({
    Title = "Auto Fishing",
    Content = "Enable auto fishing using Chloe X System.",
    Default = false,
    Callback = function(state)
        if state then
            chloex("Auto Fishing enabled.")
            _G.AutoFish = true
        else
            chloex("Auto Fishing disabled.")
            _G.AutoFish = false
        end
    end
})

-- Toggle with Subtitle
ToggleSection:AddToggle({
    Title = "Auto Sell",
    Title2 = "Sell All Fish Automatically",
    Content = "Sells all fish after catching them.",
    Default = false,
    Callback = function(state)
        if state then
            chloex("Auto Sell active.")
            _G.AutoSell = true
        else
            chloex("Auto Sell inactive.")
            _G.AutoSell = false
        end
    end
})

-- Slider Section
local SliderSection = Tabs.Main:AddSection("Chloe X | Slider")

-- Fishing Delay Slider
SliderSection:AddSlider({
    Title = "Fishing Delay",
    Content = "Set auto fishing delay time.",
    Min = 0.1,
    Max = 5,
    Increment = 0.1,
    Default = 1,
    Callback = function(value)
        _G.Delay = value
        chloex("Delay set to: " .. tostring(value) .. " seconds.")
    end
})

-- Volume Slider
SliderSection:AddSlider({
    Title = "Sound Volume",
    Content = "Adjust Chloe X sound effects volume.",
    Min = 0,
    Max = 100,
    Increment = 5,
    Default = 50,
    Callback = function(value)
        chloex("Volume changed to: " .. tostring(value) .. "%")
    end
})

-- Animation Speed Slider
SliderSection:AddSlider({
    Title = "Animation Speed",
    Content = "Set Chloe X interface animation speed.",
    Min = 0.5,
    Max = 2,
    Increment = 0.1,
    Default = 1,
    Callback = function(value)
        _G.AnimationSpeed = value
        chloex("Animation speed set to: " .. tostring(value) .. "x")
    end
})

-- Input Section
local InputSection = Tabs.Main:AddSection("Chloe X | Input")

-- Text Input
InputSection:AddInput({
    Title = "Username",
    Content = "Enter your username to save in config.",
    Default = "",
    Callback = function(value)
        _G.ChloeUsername = value
        chloex("Username set to: " .. value)
    end
})

-- Dropdown Section
local DropdownSection = Tabs.Main:AddSection("Chloe X | Dropdown")

-- Basic Dropdown
DropdownSection:AddDropdown({
    Title = "Select Theme",
    Content = "Choose interface theme for Chloe X.",
    Options = { "Celestial", "Seraphin", "Nebula", "Luna" },
    Default = "Celestial",
    Callback = function(value)
        _G.SelectedTheme = value
        chloex("Theme changed to: " .. value)
    end
})

-- Multi-Select Dropdown
DropdownSection:AddDropdown({
    Title = "Select Features",
    Content = "Select multiple Chloe X features to enable.",
    Multi = true,
    Options = { "Auto Fishing", "Auto Sell", "Auto Quest", "Webhook Notification" },
    Default = { "Auto Fishing" },
    Callback = function(selected)
        _G.ActiveFeatures = selected
        chloex("Active features: " .. table.concat(selected, ", "))
    end
})

-- Dynamic Dropdown
local DynamicDropdown = DropdownSection:AddDropdown({
    Title = "Select Bait",
    Content = "Choose bait to use.",
    Options = {},
    Default = nil,
    Callback = function(value)
        _G.SelectedBait = value
        chloex("Bait selected: " .. value)
    end
})

-- Update dropdown options dynamically
task.spawn(function()
    task.wait(1)
    local baitList = { "Common Bait", "Rare Bait", "Mythic Bait", "Divine Bait" }
    DynamicDropdown:SetValues(baitList, "Common Bait")
end)

-- Config auto-saves/loads all elements. Use SaveConfig() if needed.
