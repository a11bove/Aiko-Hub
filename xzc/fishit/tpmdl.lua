return {
    Locations = {
        ["Esoteric Island"] = Vector3.new(1990, 5, 1398),
        ["Kohana"] = Vector3.new(-603, 3, 719),
        ["Coral Refs"] = Vector3.new(-2855, 47, 1996),
        ["Esoteric Depths"] = Vector3.new(3221, -1303, 1406),
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
        ["Fisherman Island"] = Vector3.new(95, 10, 2684),
        ["Ancient Jungle"] = Vector3.new(1488, 8, - 392),
        ["Temple Guardian"] = Vector3.new(1481.58691, 127.624985, -596.321777),
        ["Underground Cellar"] = Vector3.new(2113.85693, -91.1985855, -699.206787),
        ["Sacred Temple"] = Vector3.new(1478.45508, -21.8498955, -630.773315)
    },
    
    NPCs = {
        ["Alex"] = CFrame.new(48.0930824, 17.4960938, 2877.13379),
        ["Alien Merchant"] = CFrame.new(-132.127686, 2.71751165, 2757.46191),
        ["Aura Kid"] = CFrame.new(71.0932083, 18.5335236, 2830.35889),
        ["Billy Bob"] = CFrame.new(79.8430176, 18.659088, 2876.63379),
        ["Boat Expert"] = CFrame.new(33.3180008, 9.8, 2783.00903),
        ["Jim"] = CFrame.new(84.895195, 9.824893, 2797.39233),
        ["Joe"] = CFrame.new(144.043442, 20.4837284, 2862.38379),
        ["Ron"] = CFrame.new(-51.7067909, 17.3335247, 2859.55884),
        ["Scientist"] = CFrame.new(-8.03684139, 14.6696262, 2885.70532),
        ["Scott"] = CFrame.new(-17.1273079, 9.53158569, 2703.35889),
        ["Seth"] = CFrame.new(111.59314, 17.4086304, 2877.13379),
        ["Silly Fisherman"] = CFrame.new(101.947266, 9.53157139, 2690.21948),
        ["Temple Guardian"] = CFrame.new(1491.47729, 127.625061, -593.159485),
        ["Tour Guide"] = CFrame.new(1238.88989, 7.82286787, -238.185654)
    },
    
    Machines = {
        ["Luck Machine"] = CFrame.new(13.3431435, 22.5339203, 2846.63379),
        ["Spin Wheel"] = CFrame.new(-151.139404, 22.0784302, 2824.63379),
        ["Weather Machine"] = CFrame.new(-1488.85706, 22.25, 1875.94202)
    },
    
    GetPlayerNames = function(Players, LocalPlayer)
        local playerNames = {}
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then
                table.insert(playerNames, plr.Name)
            end
        end
        table.sort(playerNames)
        return playerNames
    end
}
