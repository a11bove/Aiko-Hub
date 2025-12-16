
return {
    Locations = {
        ["Esoteric Island"] = Vector3.new(1990, 5, 1398),
        ["Kohana"] = Vector3.new(-603, 3, 719),
        ["Coral Refs"] = Vector3.new(-2855, 47, 1996),
        ["Enchant Room"] = Vector3.new(3221, -1303, 1406),
        ["Spawn"] = Vector3.new(33, 9, 2810),
        ["Volcano"] = Vector3.new(-632, 55, 197),
        ["Treasure Room"] = Vector3.new(-3602.01, -266.57, -1577.18),
        ["Sisyphus Statue"] = Vector3.new(-3703.69, -135.57, -1017.17),
        ["Crater Island Top"] = Vector3.new(1011.29, 22.68, 5076.27),
        ["Crater Island Ground"] = Vector3.new(1079.57, 3.64, 5080.35),
        ["Coral Reefs 1"] = Vector3.new(-3031.88, 2.52, 2276.36),
        ["Coral Reefs 2"] = Vector3.new(-3270.86, 2.5, 2228.1),
        ["Coral Reefs 3"] = Vector3.new(-3136.1, 2.61, 2126.11),
        ["Lost Shore"] = Vector3.new(-3737.97, 5.43, -854.68),
        ["Weather Machine"] = Vector3.new(-1524.88, 2.87, 1915.56),
        ["Kohana Volcano"] = Vector3.new(-561.81, 21.24, 156.72),
        ["Kohana 1"] = Vector3.new(-367.77, 6.75, 521.91),
        ["Kohana 2"] = Vector3.new(-623.96, 19.25, 419.36),
        ["Stingray Shores"] = Vector3.new(44.41, 28.83, 3048.93),
        ["Tropical Grove"] = Vector3.new(-2018.91, 9.04, 3750.59),
        ["Ice Sea"] = Vector3.new(2164, 7, 3269),
        ["Tropical Grove Cave 1"] = Vector3.new(-2151, 3, 3671),
        ["Tropical Grove Cave 2"] = Vector3.new(-2018, 5, 3756),
        ["Tropical Grove Highground"] = Vector3.new(-2139, 53, 3624),
        ["Fisherman Island Underground"] = Vector3.new(-62, 3, 2846),
        ["Fisherman Island Mid"] = Vector3.new(33, 3, 2764),
        ["Fisherman Island Left"] = Vector3.new(-26, 10, 2686),
        ["Fisherman Island Right"] = Vector3.new(95, 10, 2684),
        ["Jungle"] = Vector3.new(1491.21667, 6.35540199, -848.057617),
        ["Temple Guardian"] = Vector3.new(1481.58691, 127.624985, -596.321777),
        ["Underground Cellar"] = Vector3.new(2113.85693, -91.1985855, -699.206787),
        ["Sacred Temple"] = Vector3.new(1478.45508, -21.8498955, -630.773315)
    },
    
    Events = {
        "Megalodon Hunt",
        "Admin Event",
        "Ghost Worm",
        "Worm Hunt",
        "Shark Hunt",
        "Ghost Shark Hunt",
        "Shocked",
        "Black Hole",
        "Meteor Rain"
    },
    
    floatPlat = function(enabled, LocalPlayer, EventTeleportSettings)
        local character = LocalPlayer.Character
        if not character then return end
        
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        
        if enabled then
            -- Create invisible platform beneath player
            if not EventTeleportSettings.platform then
                local platform = Instance.new("Part")
                platform.Size = Vector3.new(10, 1, 10)
                platform.Transparency = 1
                platform.Anchored = true
                platform.CanCollide = true
                platform.Parent = workspace
                EventTeleportSettings.platform = platform
            end
            
            local platform = EventTeleportSettings.platform
            platform.CFrame = hrp.CFrame - Vector3.new(0, 3, 0)
            hrp.Anchored = true
        else
            if EventTeleportSettings.platform then
                EventTeleportSettings.platform:Destroy()
                EventTeleportSettings.platform = nil
            end
            
            if hrp then
                hrp.Anchored = false
            end
        end
    end,
    
    FindEventInWorkspace = function(eventName)
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
}
