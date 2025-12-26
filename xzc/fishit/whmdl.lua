-- Webhook Module for Fish It
-- Save this as a separate file and load it via loadstring

local WebhookModule = {}

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Player = Players.LocalPlayer

-- Initialize global variables
_G.httpRequest = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request

_G.WebhookFlags = _G.WebhookFlags or {
    FishCaught = {
        Enabled = false,
        URL = ""
    },
    Stats = {
        Enabled = false,
        URL = "",
        Delay = 5
    },
    Disconnect = {
        Enabled = false,
        URL = ""
    }
}

_G.WebhookCustomName = _G.WebhookCustomName or ""
_G.DiscordPingID = _G.DiscordPingID or ""
_G.DisconnectCustomName = _G.DisconnectCustomName or ""
_G.WebhookRarities = _G.WebhookRarities or {}
_G.WebhookNames = _G.WebhookNames or {}

-- Tier Names Mapping
local TierNames = {
    ["Common"] = "Common",
    ["Uncommon"] = "Uncommon", 
    ["Rare"] = "Rare",
    ["Epic"] = "Epic",
    ["Legendary"] = "Legendary",
    ["Mythic"] = "Mythic",
    ["Secret"] = "Secret",
    
    [1] = "Common",
    [2] = "Uncommon",
    [3] = "Rare",
    [4] = "Epic",
    [5] = "Legendary",
    [6] = "Mythic",
    [7] = "Secret",
    [0] = "Common"
}

-- Tier Colors for Embeds
local TierColors = {
    Common = 9807270,      
    Uncommon = 3066993,    
    Rare = 3447003,        
    Epic = 10181046,       
    Legendary = 15844367,  
    Mythic = 15158332,     
    Secret = 16777215      
}

-- Fish Database
local FishDatabase = {}

-- Send Webhook Function
function WebhookModule.SendWebhook(url, data)
    if not _G.httpRequest then
        return false
    end
    
    if not url or url == "" then
        return false
    end
    
    _G._WebhookLock = _G._WebhookLock or {}
    if _G._WebhookLock[url] then
        return false
    end
    
    _G._WebhookLock[url] = true
    task.delay(1, function()
        _G._WebhookLock[url] = nil
    end)
    
    local success, err = pcall(function()
        _G.httpRequest({
            Url = url,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = HttpService:JSONEncode(data)
        })
    end)
    
    if not success then
        return false
    end
    
    return true
end

-- Build Fish Database
function WebhookModule.BuildFishDatabase()
    local itemsFolder = ReplicatedStorage:FindFirstChild("Items")
    if not itemsFolder then
        return
    end
    
    local count = 0
    for _, item in ipairs(itemsFolder:GetChildren()) do
        if item:IsA("ModuleScript") then
            local success, data = pcall(require, item)
            if success and type(data) == "table" and data.Data then
                local fishData = data.Data
                if fishData.Type == "Fish" or fishData.Type == "Fishes" then
                    if fishData.Id and fishData.Name then
                        FishDatabase[fishData.Id] = {
                            Name = fishData.Name,
                            Tier = fishData.Tier or 0,
                            Icon = fishData.Icon or "",
                            SellPrice = data.SellPrice or 0
                        }
                        count = count + 1
                    end
                end
            end
        end
    end
    
    return count
end

-- Get Thumbnail URL
function WebhookModule.GetThumbnailURL(assetId)
    if not assetId or assetId == "" then return nil end
    
    local id = assetId:match("rbxassetid://(%d+)")
    if not id then return nil end
    
    return string.format("https://assetdelivery.roblox.com/v1/asset/?id=%s", id)
end

-- Get Tier Name
function WebhookModule.GetTierName(tier)
    if type(tier) == "string" then
        return TierNames[tier] or tier
    elseif type(tier) == "number" then
        return TierNames[tier] or "Unknown"
    else
        return "Unknown"
    end
end

-- Get Variant Name
function WebhookModule.GetVariantName(metadata, data)
    local variant = "None"
    local variantId = nil
    
    -- Try to get variant ID from metadata first
    if metadata and metadata.VariantId then
        variantId = metadata.VariantId
    elseif data and data.InventoryItem and data.InventoryItem.Metadata and data.InventoryItem.Metadata.VariantId then
        variantId = data.InventoryItem.Metadata.VariantId
    end
    
    -- If we found a variant ID, look it up
    if variantId then
        local variantFolder = ReplicatedStorage:FindFirstChild("Variants")
        if variantFolder then
            for _, v in ipairs(variantFolder:GetChildren()) do
                if v:IsA("ModuleScript") then
                    local ok, vData = pcall(require, v)
                    if ok and vData and vData.Data and vData.Data.Id == variantId then
                        variant = vData.Data.Name or "Unknown"
                        break
                    end
                end
            end
        end
    end
    
    return variant
end

-- Send Fish Caught Webhook
function WebhookModule.SendFishWebhook(fishId, metadata, data)
    if not _G.WebhookFlags.FishCaught.Enabled then return end
    
    local webhookUrl = _G.WebhookFlags.FishCaught.URL
    if not webhookUrl or webhookUrl == "" then
        return
    end
    
    local fishData = FishDatabase[fishId]
    if not fishData then 
        return 
    end
    
    local tierName = WebhookModule.GetTierName(fishData.Tier)
    
    -- Check rarity filter
    if _G.WebhookRarities and #_G.WebhookRarities > 0 then
        if not table.find(_G.WebhookRarities, tierName) then
            return
        end
    end
    
    -- Check name filter
    if _G.WebhookNames and #_G.WebhookNames > 0 then
        if not table.find(_G.WebhookNames, fishData.Name) then
            return
        end
    end
    
    local weight = metadata and metadata.Weight and string.format("%.2f Kg", metadata.Weight) or "N/A"
    local variant = WebhookModule.GetVariantName(metadata, data)
    local embedColor = TierColors[tierName] or 52221
    local playerName = _G.WebhookCustomName ~= "" and _G.WebhookCustomName or Player.Name
    
    local payload = {
        embeds = {{
            title = "🦈 Fish Caught!",
            description = string.format("**%s** caught a **%s** fish!", playerName, tierName),
            color = embedColor,
            fields = {
                {name = "**Fish Name:**", value = "❯ " .. fishData.Name .. "", inline = false},
                {name = "**Rarity:**", value = "❯ " .. tierName .. "", inline = false},
                {name = "**Weight:**", value = "❯ " .. weight .. "", inline = true},
                {name = "**Mutation:**", value = "❯ " .. variant .. "", inline = true}
            },
            thumbnail = {
                url = WebhookModule.GetThumbnailURL(fishData.Icon) or "https://i.imgur.com/WltO8IG.png"
            },
            footer = {
                text = "@aikoware Webhook",
                icon_url = "https://i.imgur.com/WltO8IG.png"
            },
            timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }},
        username = "AIKO",
        avatar_url = "https://cdn.discordapp.com/attachments/1387681189502124042/1453911584874168340/IMG_1130.png"
    }
    
    WebhookModule.SendWebhook(webhookUrl, payload)
end

-- Send Disconnect Webhook
local disconnectHandled = false

function WebhookModule.SendDisconnectWebhook(reason)
    if disconnectHandled then return end
    disconnectHandled = true
    
    local webhookUrl = _G.WebhookFlags.Disconnect.URL
    if not webhookUrl or webhookUrl == "" then 
        return 
    end
    
    local playerName = _G.DisconnectCustomName ~= "" and _G.DisconnectCustomName or Player.Name
    local dateTime = os.date("%m/%d/%Y %I:%M %p")
    local pingText = _G.DiscordPingID or ""
    
    local payload = {
        content = pingText .. " Your account disconnected!",
        embeds = {{
            title = "⚠️ Disconnected Alert!",
            color = 11342935,
            fields = {
                {name = "**Username:**", value = "❯ " .. playerName, inline = false},
                {name = "**Time:**", value = "❯ " .. dateTime, inline = false},
                {name = "**Reason:**", value = "❯ " .. (reason or "Unknown"), inline = false}
            },
            thumbnail = {
                url = "https://cdn.discordapp.com/attachments/1387681189502124042/1449753201044750336/banners_pinterest_654429389618926022.jpg"
            },
            timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }},
        username = "AIKO",
        avatar_url = "https://cdn.discordapp.com/attachments/1387681189502124042/1453911584874168340/IMG_1130.png"
    }
    
    WebhookModule.SendWebhook(webhookUrl, payload)
    
    task.wait(3)
    game:GetService("TeleportService"):Teleport(game.PlaceId, Player)
end

-- Setup Fish Webhook Listener
function WebhookModule.SetupFishListener()
    if _G.FishWebhookConnected then return end
    _G.FishWebhookConnected = true
    
    local NetFolder = ReplicatedStorage:WaitForChild("Packages")
        :WaitForChild("_Index")
        :WaitForChild("sleitnick_net@0.2.0")
        :WaitForChild("net")
    
    local REObtainedNewFishNotification = NetFolder:WaitForChild("RE/ObtainedNewFishNotification")
    
    REObtainedNewFishNotification.OnClientEvent:Connect(function(fishId, _, data)
        task.spawn(function()
            pcall(function()
                local metadata = data and data.InventoryItem and data.InventoryItem.Metadata
                WebhookModule.SendFishWebhook(fishId, metadata, data)
            end)
        end)
    end)
end

-- Setup Disconnect Detection
function WebhookModule.SetupDisconnectDetection()
    if _G.DisconnectDetectionSetup then return end
    _G.DisconnectDetectionSetup = true
    
    pcall(function()
        game:GetService("GuiService").ErrorMessageChanged:Connect(function(msg)
            if msg and msg ~= "" and _G.WebhookFlags.Disconnect.Enabled then
                WebhookModule.SendDisconnectWebhook(msg)
            end
        end)
    end)
    
    pcall(function()
        local coreGui = game:GetService("CoreGui")
        local promptGui = coreGui:FindFirstChild("RobloxPromptGui")
        if promptGui then
            local promptOverlay = promptGui:FindFirstChild("promptOverlay")
            if promptOverlay then
                promptOverlay.ChildAdded:Connect(function(prompt)
                    if prompt.Name == "ErrorPrompt" and _G.WebhookFlags.Disconnect.Enabled then
                        task.wait(0.5)
                        local label = prompt:FindFirstChildWhichIsA("TextLabel", true)
                        local reason = label and label.Text or "Disconnected"
                        WebhookModule.SendDisconnectWebhook(reason)
                    end
                end)
            end
        end
    end)
end

-- Send Test Webhook
function WebhookModule.SendTestWebhook()
    local webhookUrl = _G.WebhookFlags.FishCaught.URL
    if not webhookUrl or webhookUrl == "" then
        return false, "No webhook URL set"
    end
    
    local payload = {
        embeds = {{
            color = 11342935,
            author = {
                name = "✅ Webhook Connection Test!"
            },
            description = "If you see this message, your webhook is working correctly!",
            image = {
                url = "https://cdn.discordapp.com/attachments/1387681189502124042/1449753201044750336/banners_pinterest_654429389618926022.jpg"
            },
            timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }},
        username = "AIKO",
        avatar_url = "https://cdn.discordapp.com/attachments/1387681189502124042/1453911584874168340/IMG_1130.png"
    }
    
    if WebhookModule.SendWebhook(webhookUrl, payload) then
        return true, "Test sent successfully!"
    else
        return false, "Failed to send test!"
    end
end

-- Send Test Disconnect Webhook
function WebhookModule.SendTestDisconnectWebhook()
    local webhookUrl = _G.WebhookFlags.Disconnect.URL
    if not webhookUrl or webhookUrl == "" then
        return false, "No webhook URL set"
    end
    
    local payload = {
        content = "🧪 Test Disconnect - Working!",
        embeds = {{
            title = "✅ Test Successful!",
            color = 11342935,
            fields = {
                {name = "Status", value = "Webhook is working correctly!", inline = false},
                {name = "Action", value = "Rejoining server now...", inline = false}
            },
            timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }},
        username = "AIKO",
        avatar_url = "https://cdn.discordapp.com/attachments/1387681189502124042/1453911584874168340/IMG_1130.png"
    }
    
    WebhookModule.SendWebhook(webhookUrl, payload)
    task.wait(2)
    game:GetService("TeleportService"):Teleport(game.PlaceId, Player)
    
    return true, "Test webhook sent, rejoining..."
end

-- Clean URL Function
function WebhookModule.CleanWebhookURL(url)
    if url and url:match("discord.com/api/webhooks") then
        return url:gsub("discordapp%.com", "discord.com")
                  :gsub("canary%.discord%.com", "discord.com")
                  :gsub("ptb%.discord%.com", "discord.com")
    end
    return url
end

-- Initialize Module
function WebhookModule.Initialize()
    -- Build fish database
    local count = WebhookModule.BuildFishDatabase()
    print("[Webhook System] Initialized successfully!")
    print("[Webhook] Fish Database: " .. count .. " entries")
    print("[Webhook] HTTP Request: " .. (_G.httpRequest and "✅ Available" or "❌ NOT AVAILABLE"))
    
    -- Setup listeners
    WebhookModule.SetupFishListener()
    print("[Webhook] Fish Listener: ✅ Connected")
    
    WebhookModule.SetupDisconnectDetection()
    print("[Webhook] Disconnect Detection: ✅ Setup")
    
    return WebhookModule
end

-- Get Fish Database (for external access)
function WebhookModule.GetFishDatabase()
    return FishDatabase
end

-- Get Tier Colors (for external access)
function WebhookModule.GetTierColors()
    return TierColors
end

-- Get Tier Names (for external access)
function WebhookModule.GetTierNames()
    return TierNames
end

return WebhookModule
