local ShopModule = {}

-- Rod Data
ShopModule.Rods = {
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

ShopModule.RodNames = {
    "Luck Rod (350 Coins)", 
    "Carbon Rod (900 Coins)", 
    "Grass Rod (1.5k Coins)", 
    "Demascus Rod (3k Coins)",
    "Ice Rod (5k Coins)", 
    "Lucky Rod (15k Coins)", 
    "Midnight Rod (50k Coins)", 
    "Steampunk Rod (215k Coins)",
    "Chrome Rod (437k Coins)", 
    "Astral Rod (1M Coins)", 
    "Ares Rod (3M Coins)", 
    "Angler Rod (8M Coins)"
}

ShopModule.RodKeyMap = {
    ["Luck Rod (350 Coins)"] = "Luck Rod",
    ["Carbon Rod (900 Coins)"] = "Carbon Rod",
    ["Grass Rod (1.5k Coins)"] = "Grass Rod",
    ["Demascus Rod (3k Coins)"] = "Demascus Rod",
    ["Ice Rod (5k Coins)"] = "Ice Rod",
    ["Lucky Rod (15k Coins)"] = "Lucky Rod",
    ["Midnight Rod (50k Coins)"] = "Midnight Rod",
    ["Steampunk Rod (215k Coins)"] = "Steampunk Rod",
    ["Chrome Rod (437k Coins)"] = "Chrome Rod",
    ["Astral Rod (1M Coins)"] = "Astral Rod",
    ["Ares Rod (3M Coins)"] = "Ares Rod",
    ["Angler Rod (8M Coins)"] = "Angler Rod"
}

-- Bait Data
ShopModule.Baits = {
    ["TopWater Bait"] = 10,
    ["Lucky Bait"] = 2,
    ["Midnight Bait"] = 3,
    ["Chroma Bait"] = 6,
    ["Dark Mater Bait"] = 8,
    ["Corrupt Bait"] = 15,
    ["Aether Bait"] = 16
}

ShopModule.BaitNames = {
    "TopWater Bait (100 Coins)",
    "Lucky Bait (1k Coins)",
    "Midnight Bait (3k Coins)",
    "Chroma Bait (290k Coins)",
    "Dark Mater Bait (630k Coins)",
    "Corrupt Bait (1.15M Coins)",
    "Aether Bait (3.7M Coins)"
}

ShopModule.BaitKeyMap = {
    ["TopWater Bait (100 Coins)"] = "TopWater Bait",
    ["Lucky Bait (1k Coins)"] = "Lucky Bait",
    ["Midnight Bait (3k Coins)"] = "Midnight Bait",
    ["Chroma Bait (290k Coins)"] = "Chroma Bait",
    ["Dark Mater Bait (630k Coins)"] = "Dark Mater Bait",
    ["Corrupt Bait (1.15M Coins)"] = "Corrupt Bait",
    ["Aether Bait (3.7M Coins)"] = "Aether Bait"
}

-- Weather Data
ShopModule.Weathers = {
    ["Wind"] = 10000,
    ["Snow"] = 15000,
    ["Cloudy"] = 20000,
    ["Storm"] = 35000,
    ["Radiant"] = 50000,
    ["Shark Hunt"] = 300000
}

ShopModule.WeatherNames = {
    "Wind (10k Coins)", 
    "Snow (15k Coins)", 
    "Cloudy (20k Coins)", 
    "Storm (35k Coins)",
    "Radiant (50k Coins)", 
    "Shark Hunt (300k Coins)"
}

ShopModule.WeatherKeyMap = {
    ["Wind (10k Coins)"] = "Wind",
    ["Snow (15k Coins)"] = "Snow",
    ["Cloudy (20k Coins)"] = "Cloudy",
    ["Storm (35k Coins)"] = "Storm",
    ["Radiant (50k Coins)"] = "Radiant",
    ["Shark Hunt (300k Coins)"] = "Shark Hunt"
}

-- Boat Data
ShopModule.BoatOrder = {
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

ShopModule.Boats = {
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

-- Generate Boat Names with Prices
function ShopModule.GetBoatNames()
    local boatNames = {}
    for _, name in ipairs(ShopModule.BoatOrder) do
        local data = ShopModule.Boats[name]
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
    return boatNames
end

-- Generate Boat Key Map
function ShopModule.GetBoatKeyMap()
    local boatKeyMap = {}
    local boatNames = ShopModule.GetBoatNames()
    for _, displayName in ipairs(boatNames) do
        local nameOnly = displayName:match("^(.-) %(")
        boatKeyMap[displayName] = nameOnly
    end
    return boatKeyMap
end

-- Purchase Functions
function ShopModule.PurchaseRod(rodName, RFPurchaseFishingRod, Library)
    local key = ShopModule.RodKeyMap[rodName]
    if key and ShopModule.Rods[key] then
        local success, err = pcall(function()
            RFPurchaseFishingRod:InvokeServer(ShopModule.Rods[key])
        end)
        if success then
            Library:MakeNotify({
                Title = "@aikoware", 
                Description = "| Rod Purchase", 
                Content = "Purchased "..rodName, 
                Delay = 3
            })
        else
            Library:MakeNotify({
                Title = "@aikoware", 
                Description = "| Rod Purchase Error", 
                Content = tostring(err), 
                Delay = 4
            })
        end
    end
end

function ShopModule.PurchaseBait(baitName, RFPurchaseBait, Library)
    local key = ShopModule.BaitKeyMap[baitName]
    if key and ShopModule.Baits[key] then
        local amount = ShopModule.Baits[key]
        local success, err = pcall(function()
            RFPurchaseBait:InvokeServer(amount)
        end)
        if success then
            Library:MakeNotify({
                Title = "@aikoware",
                Description = "| Bait Purchase",
                Content = "Purchased "..baitName.." x"..amount,
                Delay = 3
            })
        else
            Library:MakeNotify({
                Title = "@aikoware",
                Description = "| Bait Purchase Error",
                Content = tostring(err),
                Delay = 4
            })
        end
    end
end

function ShopModule.PurchaseBoat(boatName, RFPurchaseBoat, Library)
    local boatKeyMap = ShopModule.GetBoatKeyMap()
    local key = boatKeyMap[boatName]
    if key and ShopModule.Boats[key] then
        local success, err = pcall(function()
            RFPurchaseBoat:InvokeServer(ShopModule.Boats[key].Id)
        end)
        if success then
            Library:MakeNotify({
                Title = "@aikoware",
                Description = "| Boat Purchase",
                Content = "Purchased "..boatName,
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

-- Auto Buy Weather System Variables
ShopModule.AutoBuyEnabled = false
ShopModule.BuyDelay = 0.5
ShopModule.SelectedWeathers = {}

-- Auto Buy Weather Function
function ShopModule.StartAutoBuy(ReplicatedStorage, Library)
    task.spawn(function()
        while ShopModule.AutoBuyEnabled do
            for _, displayName in ipairs(ShopModule.SelectedWeathers) do
                if not ShopModule.AutoBuyEnabled then break end

                local key = ShopModule.WeatherKeyMap[displayName]
                if key and ShopModule.Weathers[key] then
                    local success, err = pcall(function()
                        local RFPurchaseWeatherEvent = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RF/PurchaseWeatherEvent"]
                        RFPurchaseWeatherEvent:InvokeServer(key)
                    end)
                    if success then
                        Library:MakeNotify({
                            Title = "@aikoware",
                            Description = "| Auto Buy",
                            Content = "Purchased "..displayName,
                            Delay = 1
                        })
                    else
                        warn("Error buying weather:", err)
                    end
                    task.wait(ShopModule.BuyDelay)
                end
            end
            task.wait(0.1)
        end
    end)
end

return ShopModule
