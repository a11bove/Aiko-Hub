return function(LocalPlayer, PlayerGui, ReplicatedStorage, VirtualInputManager, FishingController, workspace)
    
    local Module = {}
    
    -- data
    Module.Locations = {
        ["Hourglass Diamond Artifact"] = {
            Koordinat = Vector3.new(1478.0726, 5.7806, -847.1714),
            ArahHadap = Vector3.new(-0.1844, 0, 0.9828)
        },
        ["Diamond Artifact"] = {
            Koordinat = Vector3.new(1837.9366, 4.3452, -306.2985),
            ArahHadap = Vector3.new(0.8314, 0, -0.5556)
        },
        ["Arrow Artifact"] = {
            Koordinat = Vector3.new(877.6763, 3.0565, -333.3725),
            ArahHadap = Vector3.new(-0.9714, 0, 0.2372)
        },
        ["Crescent Artifact"] = {
            Koordinat = Vector3.new(1402.8289, 3.3359, 122.6733),
            ArahHadap = Vector3.new(-0.2753, 0, 0.9613)
        }
    }
    
    Module.Ids = {
        ["Arrow Artifact"] = 265,
        ["Crescent Artifact"] = 266,
        ["Diamond Artifact"] = 267,
        ["Hourglass Diamond Artifact"] = 271
    }
    
    Module.Config = {
        OverlayIcon = "rbxassetid://140356301069419",
        OverlayTitle = "@aikoware",
        OverlayMessage = "Do not interrupt farming enabled!",
        OverlayLink = "dc ; https://discord.gg/JccfFGpDNV",
        ClickPositionX = 0.95,
        ClickPositionY = 0.95,
        ClickDelay = 0.02,
        ClickAttempts = 20,
        EquipDelay = 0.1,
        LoopDelay = 0.1,
        PlaceLeverDelay = 1,
        CycleDelay = 5,
        FishingCheckDelay = 0.5
    }
    
    -- state
    local AutoFarmArtifactEnabled = false
    local ArtifactFishing = false
    local ArtifactFishThread = nil
    local ArtifactOriginalPower = nil
    local ArtifactEquipRemote = nil
    
    -- func
    function Module.ClickForArtifact()
        local viewportSize = workspace.CurrentCamera.ViewportSize
        local clickX = viewportSize.X * Module.Config.ClickPositionX
        local clickY = viewportSize.Y * Module.Config.ClickPositionY
        VirtualInputManager:SendMouseButtonEvent(clickX, clickY, 0, true, nil, 0)
        VirtualInputManager:SendMouseButtonEvent(clickX, clickY, 0, false, nil, 0)
    end
    
    function Module.StopArtifactFishing()
        ArtifactFishing = false
        if ArtifactOriginalPower then
            FishingController._getPower = ArtifactOriginalPower
            ArtifactOriginalPower = nil
        end
    end
    
    function Module.ArtifactFishingLoop()
        pcall(function()
            while AutoFarmArtifactEnabled do
                if not LocalPlayer.Character then
                    LocalPlayer.CharacterAdded:Wait()
                end
                if not AutoFarmArtifactEnabled then break end

                if ArtifactEquipRemote then
                    pcall(ArtifactEquipRemote.FireServer, ArtifactEquipRemote, 1)
                end
                task.wait(Module.Config.EquipDelay)

                if not ArtifactFishing then
                    Module.ClickForArtifact()
                    ArtifactFishing = true
                end

                local fishingGui = PlayerGui:FindFirstChild("Fishing")
                fishingGui = fishingGui and fishingGui:FindFirstChild("Main")

                if fishingGui and fishingGui.Visible then
                    for _ = 1, Module.Config.ClickAttempts do
                        if not AutoFarmArtifactEnabled then break end
                        Module.ClickForArtifact()
                        task.wait(Module.Config.ClickDelay)
                    end
                end
                task.wait(Module.Config.LoopDelay)
            end
        end)
        Module.StopArtifactFishing()
    end
    
    function Module.ToggleArtifactFishing(enabled)
        AutoFarmArtifactEnabled = enabled
        if enabled then
            if not ArtifactOriginalPower then
                ArtifactOriginalPower = FishingController._getPower
            end
            function FishingController._getPower()
                return 1
            end
            ArtifactFishing = false
            if ArtifactFishThread then
                task.cancel(ArtifactFishThread)
            end
            ArtifactFishThread = task.spawn(Module.ArtifactFishingLoop)
        else
            Module.StopArtifactFishing()
            if ArtifactFishThread then
                task.cancel(ArtifactFishThread)
                ArtifactFishThread = nil
            end
        end
    end
    
    function Module.GetPlayerData()
        local Replion = require(ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Replion"))
        local dataReplion = Replion.Client:WaitReplion("Data", LocalPlayer)
        if not dataReplion then
            return {}, {}
        end

        local templeLeverData = dataReplion:Get("TempleLevers") or {}
        local inventoryItems = dataReplion:Get({"Inventory", "Items"}) or {}

        local ownedArtifacts = {}
        for _, item in ipairs(inventoryItems) do
            for artifactName, artifactId in pairs(Module.Ids) do
                if item.Id == artifactId then
                    ownedArtifacts[artifactName] = true
                end
            end
        end

        return templeLeverData, ownedArtifacts
    end
    
    function Module.GetArtifactProgressText()
        local leverData, _ = Module.GetPlayerData()
        local progressLines = {}

        for artifactName, _ in pairs(Module.Ids) do
            table.insert(progressLines, (leverData[artifactName] and "Lever Placed: " or "Not Placed: ") .. artifactName)
        end

        local progressText = table.concat(progressLines, "\n")

        local allPlaced = true
        for artifactName, _ in pairs(Module.Ids) do
            if not leverData[artifactName] then
                allPlaced = false
                break
            end
        end

        if allPlaced then
            progressText = progressText .. "\n\nAll levers have been placed!"
        end
        return progressText
    end
    
    function Module.GetPlayerHRP()
        return (LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()):WaitForChild("HumanoidRootPart")
    end
    
    function Module.TeleportToArtifact(artifactName)
        local hrp = Module.GetPlayerHRP()
        local location = Module.Locations[artifactName]
        if hrp and location then
            local position = location.Koordinat
            local lookDirection = location.ArahHadap
            hrp.CFrame = CFrame.new(position, position + lookDirection)
        end
    end
    
    function Module.CreateOverlay()
        local ArtifactOverlay = Instance.new("ScreenGui")
        ArtifactOverlay.Name = "ArtifactOverlay"
        ArtifactOverlay.ResetOnSpawn = false
        ArtifactOverlay.IgnoreGuiInset = true
        ArtifactOverlay.Parent = PlayerGui
        ArtifactOverlay.Enabled = false

        local OverlayBackground = Instance.new("Frame")
        OverlayBackground.Size = UDim2.new(1, 0, 1, 0)
        OverlayBackground.BackgroundColor3 = Color3.new(0, 0, 0)
        OverlayBackground.BackgroundTransparency = 0.6
        OverlayBackground.Parent = ArtifactOverlay

        local OverlayContent = Instance.new("Frame")
        OverlayContent.AnchorPoint = Vector2.new(0.5, 0.5)
        OverlayContent.Position = UDim2.new(0.5, 0, 0.5, 0)
        OverlayContent.Size = UDim2.new(0, 400, 0, 320)
        OverlayContent.BackgroundTransparency = 1
        OverlayContent.Parent = ArtifactOverlay

        local OverlayIcon = Instance.new("ImageLabel")
        OverlayIcon.Size = UDim2.new(0, 120, 0, 120)
        OverlayIcon.Position = UDim2.new(0.5, 0, 0, 0)
        OverlayIcon.AnchorPoint = Vector2.new(0.5, 0)
        OverlayIcon.BackgroundTransparency = 1
        OverlayIcon.Image = Module.Config.OverlayIcon
        OverlayIcon.Parent = OverlayContent

        local OverlayTitle = Instance.new("TextLabel")
        OverlayTitle.Size = UDim2.new(1, 0, 0, 35)
        OverlayTitle.Position = UDim2.new(0.5, 0, 0, 120)
        OverlayTitle.AnchorPoint = Vector2.new(0.5, 0)
        OverlayTitle.BackgroundTransparency = 1
        OverlayTitle.Text = Module.Config.OverlayTitle
        OverlayTitle.Font = Enum.Font.GothamBold
        OverlayTitle.TextSize = 30
        OverlayTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
        OverlayTitle.TextStrokeTransparency = 0.3
        OverlayTitle.Parent = OverlayContent

        local OverlayMessage = Instance.new("TextLabel")
        OverlayMessage.Size = UDim2.new(0.9, 0, 0, 60)
        OverlayMessage.Position = UDim2.new(0.5, 0, 0, 160)
        OverlayMessage.AnchorPoint = Vector2.new(0.5, 0)
        OverlayMessage.BackgroundTransparency = 1
        OverlayMessage.Text = Module.Config.OverlayMessage
        OverlayMessage.Font = Enum.Font.Gotham
        OverlayMessage.TextSize = 18
        OverlayMessage.TextWrapped = true
        OverlayMessage.TextColor3 = Color3.fromRGB(255, 255, 255)
        OverlayMessage.TextStrokeTransparency = 0.5
        OverlayMessage.Parent = OverlayContent

        local OverlayLink = Instance.new("TextLabel")
        OverlayLink.Size = UDim2.new(1, 0, 0, 25)
        OverlayLink.Position = UDim2.new(0.5, 0, 0, 220)
        OverlayLink.AnchorPoint = Vector2.new(0.5, 0)
        OverlayLink.BackgroundTransparency = 1
        OverlayLink.Text = Module.Config.OverlayLink
        OverlayLink.Font = Enum.Font.GothamSemibold
        OverlayLink.TextSize = 16
        OverlayLink.TextColor3 = Color3.fromRGB(220, 170, 255)
        OverlayLink.TextStrokeTransparency = 0.6
        OverlayLink.Parent = OverlayContent
        
        return ArtifactOverlay, OverlayTitle, OverlayMessage, OverlayLink, OverlayIcon
    end
    
    return Module
end
