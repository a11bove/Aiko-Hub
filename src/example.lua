-- [[ Load UI ]]
local Chloex = loadstring(game:HttpGet("https://raw.githubusercontent.com/a11bove/kdoaz/refs/heads/main/src/Library.lua"))()

-- [[ load Window ]]
local Window = Chloex:Window({
    Title   = "@aikoware |",                --- title
    Footer  = "made by untog",                   --- in right after title
    Image   = "136505615779937",           ---- rbxassetid (texture)
    Color   = Color3.fromRGB(0, 208, 255), --- colour text/ui
    Theme   = 9542022979,                  ---- background for theme ui (rbxassetid)
    Version = 1,                           --- version config set as default 1 if u remake / rewrite / big update and change name name in your hub change it to 2 and config will reset
})

--- [[ Notify ]]
if Window then
    than("Window loaded!")
end

--- Or Use Like This
Chloex:MakeNotify({
Title = "@aikoware",
Description = "Notification",
Content = "Contoh notifikasi",
Color = Color3.fromRGB(0, 208, 255),
Delay = 4
})

--- [[ Make a tab ]]
local Tabs = {
    Info = Window:AddTab({ Name = "Info", Icon = "player" }), --- rbxassetid / robloxassetid (decals - texture)
    Main = Window:AddTab({ Name = "Main", Icon = "user" }),
}

-- [[ Make A Section for tab ]]
X1 = Tabs.Info:AddSection("Chloe X | Section") -- [[ X1 = for load elements section ]] ,
-- X1 = Tabs.Info:AddSection("Chloe X Section", false) set as default open after load UI
-- X1 = Tabs.Info:AddSection("Chloe X Section", true) set as default always open (cant closed section) after load UI

--- [[ Paragraphh ]]
X1:AddParagraph({
    Title = "Chloe X | Community",
    Content = "Chloe Chloe Chloe Chloe",
    Icon = "star",
})

--- [[ Paragraph with button ]]
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

--- [[ Divider ]]
X1:AddDivider()

--- [[ Sub Section ]]
X1:AddSubSection("CHLOE CHLOE CHLOE")

PanelSection = Tabs.Main:AddSection("Chloe X | Panel")

--- [[ Panel with 2 button ]]
PanelSection:AddPanel({
    Title = "Chloe X | Discord",
    --  Content = "Sub Title", --- can use sub title here.
    ButtonText = "Copy Discord Link",
    ButtonCallback = function()
        if setclipboard then
            setclipboard("https://discord.gg/chloex")
            chloex("Link Discord telah disalin ke clipboard.")
        else
            chloex("Executor tidak mendukung setclipboard.")
        end
    end,
    SubButtonText = "Open Discord",
    SubButtonCallback = function()
        chloex("Membuka link Discord...")
        task.spawn(function()
            game:GetService("GuiService"):OpenBrowserWindow("https://discord.gg/chloex")
        end)
    end
})

-- [[ Panel with 2 Button + 1 Input ]]
PanelSection:AddPanel({
    Title = "Chloe X | Utility",
    Placeholder = "https://discord.com/api/webhooks/...",
    ButtonText = "Rejoin Server",
    ButtonCallback = function()
        chloex("Rejoining server...")
        task.wait(1)
        game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
    end
})

--= [[ Panel with 2 Button + 1 Input]]
PanelSection:AddPanel({
    Title = "Chloe X | Webhook",
    Placeholder = "https://discord.com/api/webhooks/...",
    ButtonText = "Simpan Webhook",
    ButtonCallback = function(url)
        if url == "" then
            chloex("Mohon isi URL webhook terlebih dahulu.")
            return
        end
        _G.ChloeWebhook = url
        ConfigData.WebhookURL = url
        SaveConfig()
        chloex("Webhook telah disimpan.")
    end,
    SubButtonText = "Test Webhook",
    SubButtonCallback = function()
        if not _G.ChloeWebhook or _G.ChloeWebhook == "" then
            chloex("Webhook belum diset.")
            return
        end
        chloex("Mengirim test webhook...")
        task.spawn(function()
            local HttpService = game:GetService("HttpService")
            local data = { content = "Test webhook dari Chloe X." }
            pcall(function()
                HttpService:PostAsync(_G.ChloeWebhook, HttpService:JSONEncode(data))
            end)
        end)
    end
})

-- [[ Button Section ]]
local BtnSection = Tabs.Main:AddSection("Chloe X | Button")

-- [[ Single Button ]]
BtnSection:AddButton({
    Title = "Open Discord",
    Callback = function()
        chloex("Membuka Discord...")
        task.spawn(function()
            game:GetService("GuiService"):OpenBrowserWindow("https://discord.gg/chloex")
        end)
    end
})

-- [[ Double Button ]]
BtnSection:AddButton({
    Title = "Rejoin",
    SubTitle = "Server Hop",
    Callback = function()
        chloex("Rejoining server...")
        task.wait(1)
        game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
    end,
    SubCallback = function()
        chloex("Mencari server baru...")
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
        chloex("Tidak ada server kosong ditemukan.")
    end
})

-- [[ Toggle Section ]]
local ToggleSection = Tabs.Main:AddSection("Chloe X | Toggle")

-- [[ Single Toggle ]]
ToggleSection:AddToggle({
    Title = "Auto Fishing",
    Content = "Aktifkan auto fishing menggunakan Chloe X System.",
    Default = false,
    Callback = function(state)
        if state then
            chloex("Auto Fishing diaktifkan.")
            _G.AutoFish = true
        else
            chloex("Auto Fishing dimatikan.")
            _G.AutoFish = false
        end
    end
})

-- [[ Toggle with Sub Title ]]
ToggleSection:AddToggle({
    Title = "Auto Sell",
    Title2 = "Sell All Fish Automatically",
    Content = "Menjual semua ikan setelah menangkapnya.",
    Default = false,
    Callback = function(state)
        if state then
            chloex("Auto Sell aktif.")
            _G.AutoSell = true
        else
            chloex("Auto Sell nonaktif.")
            _G.AutoSell = false
        end
    end
})

-- [[ Slider Section ]]
local SliderSection = Tabs.Main:AddSection("Chloe X | Slider")

-- [[ Slider for Fishing Delay ]]
SliderSection:AddSlider({
    Title = "Fishing Delay",
    Content = "Atur jeda waktu auto fishing.",
    Min = 0.1,
    Max = 5,
    Increment = 0.1,
    Default = 1,
    Callback = function(value)
        _G.Delay = value
        chloex("Delay diset ke: " .. tostring(value) .. " detik.")
    end
})

-- [[ Slider for Volume Control ]]
SliderSection:AddSlider({
    Title = "Sound Volume",
    Content = "Sesuaikan volume efek suara Chloe X.",
    Min = 0,
    Max = 100,
    Increment = 5,
    Default = 50,
    Callback = function(value)
        chloex("Volume diubah ke: " .. tostring(value) .. "%")
    end
})

-- [[ Slider for Animation Speed ]]
SliderSection:AddSlider({
    Title = "Animation Speed",
    Content = "Atur kecepatan animasi antarmuka Chloe X.",
    Min = 0.5,
    Max = 2,
    Increment = 0.1,
    Default = 1,
    Callback = function(value)
        _G.AnimationSpeed = value
        chloex("Kecepatan animasi diset ke: " .. tostring(value) .. "x")
    end
})

-- [[ Input Section ]]
local InputSection = Tabs.Main:AddSection("Chloe X | Input")

-- [[ Input ]]
InputSection:AddInput({
    Title = "Username",
    Content = "Masukkan nama pengguna kamu untuk disimpan di konfigurasi.",
    Default = "",
    Callback = function(value)
        _G.ChloeUsername = value
        chloex("Username diset ke: " .. value)
    end
})

-- [[ Dropdown Section ]]
local DropdownSection = Tabs.Main:AddSection("Chloe X | Dropdown")

-- [[ Basic Dropdown ]]
DropdownSection:AddDropdown({
    Title = "Select Theme",
    Content = "Pilih tema antarmuka untuk Chloe X.",
    Options = { "Celestial", "Seraphin", "Nebula", "Luna" },
    Default = "Celestial",
    Callback = function(value)
        _G.SelectedTheme = value
        chloex("Tema diubah ke: " .. value)
    end
})

-- [[ Multi Select Dropdown ]]
DropdownSection:AddDropdown({
    Title = "Select Features",
    Content = "Pilih beberapa fitur Chloe X yang ingin diaktifkan.",
    Multi = true,
    Options = { "Auto Fishing", "Auto Sell", "Auto Quest", "Webhook Notification" },
    Default = { "Auto Fishing" },
    Callback = function(selected)
        _G.ActiveFeatures = selected
        chloex("Fitur aktif: " .. table.concat(selected, ", "))
    end
})

-- [[ Dynamic Dropdown ]]
local DynamicDropdown = DropdownSection:AddDropdown({
    Title = "Select Bait",
    Content = "Pilih umpan yang akan digunakan.",
    Options = {},
    Default = nil,
    Callback = function(value)
        _G.SelectedBait = value
        chloex("Umpan dipilih: " .. value)
    end
})

--- refresh value dropdown use SetValues
task.spawn(function()
    task.wait(1)
    local baitList = { "Common Bait", "Rare Bait", "Mythic Bait", "Divine Bait" }
    DynamicDropdown:SetValues(baitList, "Common Bait")
end)

-- [[ Config ]]
-- This library is auto save / load all element without any if u got bug in saved in you ui use SaveConfig()
