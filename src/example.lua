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
local ToggleSection = Tabs.Main:AddSection("@aikoware | Toggle")

-- Single Toggle
ToggleSection:AddToggle({
    Title = "Toggle",
    Content = "Content",
    Default = false,
    Callback = function(value)
        print("Toggle set to: " .. value)
    end
})

-- Toggle with Subtitle
ToggleSection:AddToggle({
    Title = "Toggle",
    Title2 = "Wih Subtitle",
    Content = "Content",
    Default = false,
    Callback = function(v)
        print("Toggle set to: " .. v)
    end
})

-- Slider Section
local SliderSection = Tabs.Main:AddSection("@aikoware | Slider")

-- Fishing Delay Slider
SliderSection:AddSlider({
    Title = "Slider",
    Content = "Content",
    Min = 1,
    Max = 100,
    Increment = 1,
    Default = 1,
    Callback = function(value)
        print("Delay set to: " .. tostring(value) .. " seconds.")
    end
})

-- Input Section
local InputSection = Tabs.Main:AddSection("@aikoware | Input")

-- Text Input
InputSection:AddInput({
    Title = "Inpt",
    Content = "Content",
    Default = "",
    Callback = function(value)
        print("Username set to: " .. value)
    end
})

-- Dropdown Section
local DropdownSection = Tabs.Main:AddSection("@aikoware | Dropdown")

-- Basic Dropdown
DropdownSection:AddDropdown({
    Title = "Basic Dropdown",
    Content = "Content",
    Options = { "Hi", "Hello", "Sup", "Banana" },
    Default = "Hi",
    Callback = function(value)
        print("Basic Dropdown set to: " .. value)
    end
})

-- Multi-Select Dropdown
DropdownSection:AddDropdown({
    Title = "Multi Dropdown",
    Content = "",
    Multi = true,
    Options = { "Banana", "Apple", "Papaya", "Mango" },
    Default = { "Banana" },
    Callback = function(selected)
        print("Multi Dropdown set to: " .. table.concat(selected, ", "))
    end
})

-- Dynamic Dropdown
local DynamicDropdown = DropdownSection:AddDropdown({
    Title = "Dynamic Dropdown",
    Content = "Content",
    Options = {},
    Default = nil,
    Callback = function(value)
        print("Dynamic Dropdown set to: " .. value)
    end
})

-- Update dropdown options dynamically
task.spawn(function()
    task.wait(1)
    local genderList = { "Man", "Woman", "Boy", "Girl" }
    DynamicDropdown:SetValues(genderList, "Man")
end)

-- Config auto-saves/loads all elements. Use SaveConfig() if needed.
