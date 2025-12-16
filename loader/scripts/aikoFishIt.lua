if not game:IsLoaded() then
	game.Loaded:Wait()
end

local existingGui = game.CoreGui:FindFirstChild("aikoware")
if existingGui then
	existingGui:Destroy()
end

local existingHirimi = game.CoreGui:FindFirstChild("HirimiGui")
if existingHirimi then
	existingHirimi:Destroy()
end

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/a11bove/kdoaz/refs/heads/main/loader/src.lua"))()

Library:MakeNotify({
	Title = "@aikoware",
	Description = "",
	Content = "Fish It Script Loaded!",
	Color = Color3.fromRGB(255,100,100),
	Delay = 3
})

local Window = Library:MakeGui({
	NameHub = "@aikoware ",
	Description = "| made by untog !",
	Color = Color3.fromRGB(81, 40, 128),
	["Logo Player"] = "https://www.roblox.com/headshot-thumbnail/image?userId=544503914&width=420&height=420&format=png",
["Name Player"] = "Protected By @aikoware"
})

local gui = Instance.new("ScreenGui")
gui.Name = "aikoware"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.Parent = game.CoreGui

local button = Instance.new("ImageButton")
button.Size = UDim2.new(0, 53, 0, 53)
button.Position = UDim2.new(0, 60, 0, 60)
button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
button.BackgroundTransparency = 0.5
button.Image = "rbxassetid://140356301069419"
button.Name = "aikowaretoggle"
button.AutoButtonColor = true
button.Parent = gui

local corner = Instance.new("UICorner", button)
corner.CornerRadius = UDim.new(0, 12)

local stroke = Instance.new("UIStroke")
stroke.Thickness = 1.5
stroke.Color = Color3.fromRGB(45, 45, 45)
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
stroke.Parent = button

local gradient = Instance.new("UIGradient")
gradient.Color =
	ColorSequence.new {
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 100, 100)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 0, 0))
}
gradient.Rotation = 45
gradient.Parent = stroke

local dragging, dragInput, dragStart, startPos

button.InputBegan:Connect(
	function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
									dragging = true
									dragStart = input.Position
									startPos = button.Position

									input.Changed:Connect(
													function()
																	if input.UserInputState == Enum.UserInputState.End then
																					dragging = false
																	end
													end
									)
					end
	end
)

button.InputChanged:Connect(
	function(input)
					if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
									dragInput = input
					end
	end
)

game:GetService("UserInputService").InputChanged:Connect(
	function(input)
					if input == dragInput and dragging then
									local delta = input.Position - dragStart
									button.Position =
													UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
					end
	end
)

button.MouseButton1Click:Connect(
	function()
					local HirimiGui = game.CoreGui:FindFirstChild("HirimiGui")
					if HirimiGui then
									local DropShadowHolder = HirimiGui:FindFirstChild("DropShadowHolder")
									if DropShadowHolder then
													DropShadowHolder.Visible = not DropShadowHolder.Visible
									end
					end
	end
)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HttpService = game:GetService("HttpService")

-- Network Remotes
local NetFolder = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net")
local ChargeFishingRod = NetFolder:WaitForChild("RF/ChargeFishingRod")
local RequestFishingMinigame = NetFolder:WaitForChild("RF/RequestFishingMinigameStarted")
local FishingCompleted = NetFolder:WaitForChild("RE/FishingCompleted")
local EquipToolFromHotbar = NetFolder:WaitForChild("RE/EquipToolFromHotbar")
local SellAllItems = NetFolder:WaitForChild("RF/SellAllItems")
local CancelFishingInputs = NetFolder:WaitForChild("RF/CancelFishingInputs")
local ActivateEnchantingAltar = NetFolder:WaitForChild("RE/ActivateEnchantingAltar")
local UpdateOxygen = NetFolder:WaitForChild("URE/UpdateOxygen")
local FishingController = require(ReplicatedStorage.Controllers.FishingController)

-- Infinite Jump Setup
UserInputService.JumpRequest:Connect(function()
				local shouldJump = _G.InfiniteJump and (LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()):FindFirstChildOfClass("Humanoid")
				if shouldJump then
								shouldJump:ChangeState(Enum.HumanoidStateType.Jumping)
				end
end)

LocalPlayer.CharacterAdded:Connect(function(newCharacter)
				local newHumanoid = newCharacter:WaitForChild("Humanoid")
				newHumanoid.UseJumpPower = true
				newHumanoid.JumpPower = _G.CustomJumpPower or 50
end)

local main = Window:CreateTab({
	Name = "Home",
	Icon = "rbxassetid://10723407389"
})

local fsh = Window:CreateTab({
		Name = "Fishing",
		Icon = "rbxassetid://10734966248"
})

local shp = Window:CreateTab({
		Name = "Shop",
		Icon = "rbxassetid://10734921935"
})

local qst = Window:CreateTab({
		Name = "Quest",
		Icon = "rbxassetid://10734965572"
})

local utl = Window:CreateTab({
		Name = "Utility",
		Icon = "rbxassetid://10709810948"
})

local tp = Window:CreateTab({
		Name = "Teleport",
		Icon = "rbxassetid://10734886004"
})

local msc = Window:CreateTab({
		Name = "Misc",
		Icon = "rbxassetid://10734964600"
})

local uset = main:AddSection("User Settings")

uset:AddInput({
	Title = "WalkSpeed",
	Content = "Numbers only.",
	Placeholder = "Enter numbers...",
	Callback = function(value)
					local speed = tonumber(value)
									if speed and speed >= 16 then
													Humanoid.WalkSpeed = speed
									else
													Humanoid.WalkSpeed = 16
									end
					end
})

uset:AddInput({
	Title = "Jumppower",
	Content = "Numbers only.",
	Placeholder = "Enter numbers...",
	Callback = function(value)
			local jumpPower = tonumber(value)
							if jumpPower then
											_G.CustomJumpPower = jumpPower
											local char = LocalPlayer.Character
											local hum = char and char:FindFirstChildOfClass("Humanoid")
											if hum then
															hum.UseJumpPower = true
															hum.JumpPower = jumpPower
											end
							end
			end
})

uset:AddButton({
				Title = "Reset Speed & Jump",
				Content = "Reset walkspeed and jump to default.",
				Callback = function()
								Humanoid.WalkSpeed = 16
								_G.CustomJumpPower = 50
								local char = LocalPlayer.Character
								local hum = char and char:FindFirstChildOfClass("Humanoid")
								if hum then
												hum.UseJumpPower = true
												hum.JumpPower = 50
								end
				end
})

uset:AddToggle({
				Title = "Inf Jump",
				Content = "Inf jump ;)",
				Default = false,
				Callback = function(enabled)
								_G.InfiniteJump = enabled
				end
})

local infosec = main:AddSection("Info")

infosec:AddParagraph({
	Title = "Warning:",
	Content = "I made this script for testing purposes only, I am not responsible for any bans or any other consequences."
})

infosec:AddParagraph({
	Title = "Discord:",
	Content = "Join to our discord server for more updates and information."
})

infosec:AddButton({
	Title = "Copy Server Invite",
	Content = "",
	Callback = function()
									setclipboard("https://discord.gg/JccfFGpDNV")
					Library:MakeNotify({
									Title = "@aikoware",
									Description = "| Discord",
									Content = "Link Copied!"
					})
	end
})

local lgt = fsh:AddSection("Legit")

local AutoLegitFishEnabled = false
local LegitFishClicking = false
local LegitFishThread = nil
local OriginalGetPower = nil
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Camera = workspace.CurrentCamera
local VirtualInputManager = game:GetService("VirtualInputManager")
local LegitFishSettings = {}

local function ClickAtPosition()
				local viewportSize = Camera.ViewportSize
				local clickX = viewportSize.X * 0.95
				local clickY = viewportSize.Y * 0.95
				VirtualInputManager:SendMouseButtonEvent(clickX, clickY, 0, true, nil, 0)
				VirtualInputManager:SendMouseButtonEvent(clickX, clickY, 0, false, nil, 0)
end

local function StopLegitFish()
				LegitFishClicking = false
				if OriginalGetPower then
								FishingController._getPower = OriginalGetPower
				end
end

local function LegitFishLoop()
				pcall(function()
								while AutoLegitFishEnabled do
												if not LocalPlayer.Character then
																LocalPlayer.CharacterAdded:Wait()
												end
												if not AutoLegitFishEnabled then break end

												if EquipToolFromHotbar then
																pcall(EquipToolFromHotbar.FireServer, EquipToolFromHotbar, 1)
												end
												task.wait(0.1)

												if not LegitFishClicking then
																ClickAtPosition()
																LegitFishClicking = true
												end

												local fishingGui = PlayerGui:FindFirstChild("Fishing")
												fishingGui = fishingGui and fishingGui:FindFirstChild("Main")

												if fishingGui and fishingGui.Visible then
																for _ = 1, 20 do
																				if not AutoLegitFishEnabled then break end
																				ClickAtPosition()
																				task.wait(0.02)
																end
												end
												task.wait(0.1)
								end
				end)
				StopLegitFish()
end

local function ToggleAutoLegitFish(enabled)
	AutoLegitFishEnabled = enabled
	LegitFishSettings.AutoLegitFish = enabled

	if enabled then
		if not OriginalGetPower then
			OriginalGetPower = FishingController._getPower
		end
		function FishingController._getPower()
			return 1
		end
		LegitFishClicking = false
		if LegitFishThread then
			task.cancel(LegitFishThread)
		end
		LegitFishThread = task.spawn(LegitFishLoop)
		Library:MakeNotify({
			Title = "@aikoware",
			Description = "| Legit Fishing",
			Content = "Has Started!",
			Delay = 3
		})
	else
		StopLegitFish()
		if LegitFishThread then
			task.cancel(LegitFishThread)
			LegitFishThread = nil
		end
		Library:MakeNotify({
			Title = "@aikoware",
			Description = "| Legit Fishing",
			Content = "Has Stopped!",
			Delay = 3
		})
	end
end

lgt:AddToggle({
	Title = "Legit Fishing",
	Content = "Automatically fishes for you",
	Default = false,
	Callback = function(enabled)
		ToggleAutoLegitFish(enabled)
	end
})

local fis = fsh:AddSection("Fishing")

local InstantFishEnabled = false
local CancelDelay = 0.1
local CompleteDelay = 1

local function EquipFishingRod()
				pcall(function()
								EquipToolFromHotbar:FireServer(1)
				end)
end

local function InstantFishCycle()
				if InstantFishEnabled then
								pcall(function()
												ChargeFishingRod:InvokeServer(1756863567.217075)
												RequestFishingMinigame:InvokeServer(-139.63796997070312, 0.9964792798079721)
								end)
								task.wait(CancelDelay)

								pcall(function()
												CancelFishingInputs:InvokeServer()
								end)

								if InstantFishEnabled then
												pcall(function()
																ChargeFishingRod:InvokeServer(1756863567.217075)
																RequestFishingMinigame:InvokeServer(-139.63796997070312, 0.9964792798079721)
												end)
												task.wait(CompleteDelay)

												pcall(function()
																FishingCompleted:FireServer()
												end)
												task.spawn(InstantFishCycle)
								end
				end
end

local function StartInstantFish()
				if not InstantFishEnabled then
								InstantFishEnabled = true
								EquipFishingRod()
								task.wait(0.5)
								task.spawn(InstantFishCycle)
				end
end

local function StopInstantFish()
				InstantFishEnabled = false
end

fis:AddToggle({
				Title = "Instant Fishing",
				Content = "Blatantly Auto fishing for you.",
		  Default = false,
				Callback = function(enabled)
								if enabled then
												StartInstantFish()
								else
												StopInstantFish()
								end
				end
})

local CompleteDelayInput = fis:AddInput({
	Title = "Custom Complete Delay",
	Content = "Enter delay in seconds.",
	Placeholder = "Enter number...",
	Callback = function(value)
					local delay = tonumber(value)
									if delay and delay > 0 then
													CompleteDelay = delay
									elseif CompleteDelayInput then
													CompleteDelayInput:Set(tostring(CompleteDelay))
									end
					end
})

local CancelDelayInput = fis:AddInput({
    Title = "Custom Cancel Delay",
    Content = "Enter delay in seconds",
    Placeholder = "Enter number...",
    Callback = function(value)
        local delay = tonumber(value)
        if delay and delay > 0 then
            CancelDelay = delay
        elseif CancelDelayInput then
            CancelDelayInput:Set(tostring(CancelDelay))
        end
    end
})

-- Super Instant Fishing
local SuperInstantEnabled = false
local SuperReelDelay = 2
local SuperCompleteDelay = 1.25

local function SuperInstantCycle()
    task.spawn(function()
        CancelFishingInputs:InvokeServer()
        task.wait(SuperReelDelay)
        ChargeFishingRod:InvokeServer(1756863567.217075)
        RequestFishingMinigame:InvokeServer(-139.63796997070312, 0.9964792798079721)
        task.wait(SuperCompleteDelay)
        FishingCompleted:FireServer()
    end)
end

_G.ReelSuper = 2

local function StartSuperInstant()
    if not SuperInstantEnabled then
        SuperInstantEnabled = true
        EquipFishingRod()
        task.spawn(function()
            while SuperInstantEnabled do
                local startTime = tick()
                SuperInstantCycle()
                while SuperInstantEnabled and tick() - startTime < _G.ReelSuper do
                    task.wait()
                end
            end
        end)
    end
end

local function StopSuperInstant()
    SuperInstantEnabled = false
end

fis:AddToggle({
    Title = "Super Instant Fishing",
    Content = "Setting depends on your rod.",
		  Default = false,
		  Callback = function(enabled)
        if enabled then
            StartSuperInstant()
        else
            StopSuperInstant()
        end
    end
})

local SuperReelDelayInput = fis:AddInput({
    Title = "Custom Delay Reel",
    Content = "Enter delay in seconds",
    Placeholder = "Enter number...",
    Callback = function(value)
        local delay = tonumber(value)
        if delay and delay > 0 then
            SuperReelDelay = delay
        elseif SuperReelDelayInput then
            SuperReelDelayInput:Set(tostring(SuperReelDelay))
        end
    end
})

local SuperCompleteDelayInput = fis:AddInput({
    Title = "Custom Complete Delay",
    Content = "Enter delay in seconds",
    Placeholder = "Enter number...",
    Callback = function(value)
        local delay = tonumber(value)
        if delay and delay > 0 then
            SuperCompleteDelay = delay
        elseif SuperCompleteDelayInput then
            SuperCompleteDelayInput:Set(tostring(SuperCompleteDelay))
        end
    end
})

local SuperInstantV2Enabled = false
local ScytheReelDelay = 1.05
local ScytheCompleteDelay = 0.16

local function SuperInstantV2Cycle()
    task.spawn(function()
        CancelFishingInputs:InvokeServer()
        task.wait(ScytheReelDelay)
        ChargeFishingRod:InvokeServer(1756863567.217075)
        RequestFishingMinigame:InvokeServer(-139.63796997070312, 0.9964792798079721)
        task.wait(ScytheCompleteDelay)
        FishingCompleted:FireServer()
    end)
end

_G.ReelSuper = 1.05

local function StartSuperInstantV2()
    if not SuperInstantV2Enabled then
        SuperInstantV2Enabled = true
        EquipFishingRod()
        task.spawn(function()
            while SuperInstantV2Enabled do
                local startTime = tick()
                SuperInstantV2Cycle()
                while SuperInstantV2Enabled and tick() - startTime < _G.ReelSuper do
                    task.wait()
                end
            end
        end)
    end
end

local function StopSuperInstantV2()
    SuperInstantV2Enabled = false
end

fis:AddToggle({
    Title = "Super Instant Fishing V2",
    Content = "For scythe rod users.",
		  Default = false,
    Callback = function(enabled)
        if enabled then
            StartSuperInstantV2()
        else
            StopSuperInstantV2()
        end
    end
})

local ScytheCompleteDelayInput = fis:AddInput({
    Title = "Custom Complete Delay",
    Content = "Enter delay in seconds",
    Placeholder = "Enter number...",
    Callback = function(value)
        local delay = tonumber(value)
        if delay and delay > 0 then
            ScytheCompleteDelay = delay
        elseif ScytheCompleteDelayInput then
            ScytheCompleteDelayInput:Set(tostring(ScytheCompleteDelay))
        end
    end
})

local ScytheReelDelayInput = fis:AddInput({
    Title = "Custom Cancel Delay",
    Content = "Enter delay in seconds",
    Placeholder = "Enter number...",
    Callback = function(value)
        local delay = tonumber(value)
        if delay and delay > 0 then
            ScytheReelDelay = delay
        elseif ScytheReelDelayInput then
            ScytheReelDelayInput:Set(tostring(ScytheReelDelay))
        end
    end
})

local ench = fsh:AddSection("Enchant")

ench:AddToggle({
    Title = "Auto Enchant Rod",
    Content = "Automatically enchant your equipped rod",
    Default = false,
    Callback = function()
        local enchantPosition = Vector3.new(3231, -1303, 1402)
        local character = workspace:WaitForChild("Characters"):FindFirstChild(LocalPlayer.Name)
        local hrp = character and character:FindFirstChild("HumanoidRootPart")
        
        if hrp then
            NotifyInfo("Preparing Enchant...", "Please manually place Enchant Stone into slot 5 before we begin...", 5)
            task.wait(3)
            
            local slot5 = LocalPlayer.PlayerGui.Backpack.Display:GetChildren()[10]
            local itemName = slot5 and slot5:FindFirstChild("Inner") and slot5.Inner:FindFirstChild("Tags") and slot5.Inner.Tags:FindFirstChild("ItemName")
            
            if itemName and itemName.Text:lower():find("enchant") then
                NotifyInfo("Enchanting...", "Enchanting in progress, please wait...", 7)
                local originalPosition = hrp.Position
                task.wait(1)
                hrp.CFrame = CFrame.new(enchantPosition + Vector3.new(0, 5, 0))
                task.wait(1.2)
                
                pcall(function()
                    EquipToolFromHotbar:FireServer(5)
                    task.wait(0.5)
                    ActivateEnchantingAltar:FireServer()
                    task.wait(7)
                end)
                
                task.wait(0.9)
                hrp.CFrame = CFrame.new(originalPosition + Vector3.new(0, 3, 0))
            else
                NotifyError("Auto Enchant Rod", "Slot 5 does not contain an Enchant Stone.")
            end
        else
            NotifyError("Auto Enchant Rod", "Failed to get character HRP.")
        end
    end
})

local notf = fsh:AddSection("Notification")

local function ToggleCaughtNotifications(visible)
    local notificationGui = LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("Small Notification")
    if notificationGui then
        local display = notificationGui:FindFirstChild("Display")
        if display then
            for _, child in ipairs(display:GetChildren()) do
                if child:IsA("GuiObject") then
                    child.Visible = visible
                end
            end
        end
    end
end

notf:AddToggle({
    Title = "Caught Notification",
    Content = "Use this For Disable ur Notification caught",
    Default = true,
    Callback = function(enabled)
        ToggleCaughtNotifications(not enabled)
    end
})

local sell = shp:AddSection("Auto Sell")

sell:AddToggle({
    Title = "Enable Auto Sell",
    Content = "Automatically sell fish.",
    Default = false,
    Callback = function(enabled)
        _G.AutoSell = enabled
        task.spawn(function()
            while _G.AutoSell do
                task.wait(5)
                pcall(function()
                    SellAllItems:InvokeServer()
                end)
            end
        end)
    end
})

local sellThreshold = 30
sell:AddInput({
    Title = "Auto Sell Input Amount",
    Content = "Set the number of fish to catch before auto-selling.",
    Placeholder = "Default: 30",
    Callback = function(value)
        local threshold = tonumber(value)
        if threshold then
            sellThreshold = threshold
            Library:MakeNotify({
                Title = "@aikoware",
                Description = "| Threshold Updated",
						Content = "Fish will be sold automatically when catch reaches " .. sellThreshold,
                Delay = 2
            })
        else
            Library:MakeNotify({
                Title = "@aikoware",
						Description = "| Invalid Input"
                Content = "Please enter a number, not text.",
                Delay = 2
            })
        end
    end
})

local dsq = qst:AddSection("Deep Sea")

local QuestSettings = {player = Players.LocalPlayer}
local DeepSeaParagraph = dsq:AddParagraph({
		Title = "Deep Sea Panel",
		Content = ""
})

dsq:AddToggle({
    Title = "Auto Deep Sea Quest",
		Content = "Automatically complete the Deep Sea Quest.",
    Default = false,
    Callback = function(enabled)
        QuestSettings.autoDeepSea = enabled
        task.spawn(function()
            while QuestSettings.autoDeepSea do
                local menuRings = workspace:FindFirstChild("!!! MENU RINGS")
                local deepSeaTracker = menuRings and menuRings:FindFirstChild("Deep Sea Tracker")
                
                if deepSeaTracker then
                    local content = deepSeaTracker:FindFirstChild("Board") and deepSeaTracker.Board:FindFirstChild("Gui") and deepSeaTracker.Board.Gui:FindFirstChild("Content")
                    
                    if content then
                        local progressLabel
                        for _, child in ipairs(content:GetChildren()) do
                            if child:IsA("TextLabel") and child.Name ~= "Header" then
                                progressLabel = child
                                break
                            end
                        end
                        
                        if progressLabel then
                            local progressText = string.lower(progressLabel.Text)
                            local hrp = QuestSettings.player.Character and QuestSettings.player.Character:FindFirstChild("HumanoidRootPart")
                            
                            if hrp then
                                if string.find(progressText, "100%%") then
                                    hrp.CFrame = CFrame.new(-3763, -135, -995) * CFrame.Angles(0, math.rad(180), 0)
                                else
                                    hrp.CFrame = CFrame.new(-3599, -276, -1641)
                                end
                            end
                        end
                    end
                end
                task.wait(1)
            end
        end)
    end
})

local ele = qst:AddSection("Element")

local ElementParagraph = ele:AddParagraph({
    Title = "Element Panel",
    Content = ""
})

ele:AddToggle({
    Title = "Auto Element Quest",
    Content = "Automatically complete the Element Quest.",
    Default = false,
    Callback = function(enabled)
        QuestSettings.autoElement = enabled
        task.spawn(function()
            local questCompleted = false
            while QuestSettings.autoElement and not questCompleted do
                local menuRings = workspace:FindFirstChild("!!! MENU RINGS")
                local elementTracker = menuRings and menuRings:FindFirstChild("Element Tracker")

                if elementTracker then
                    local content = elementTracker:FindFirstChild("Board") and elementTracker.Board:FindFirstChild("Gui") and elementTracker.Board.Gui:FindFirstChild("Content")

                    if content then
                        local progressTexts = {}
                        for _, child in ipairs(content:GetChildren()) do
                            if child:IsA("TextLabel") and child.Name ~= "Header" then
                                table.insert(progressTexts, string.lower(child.Text))
                            end
                        end

                        local hrp = QuestSettings.player.Character and QuestSettings.player.Character:FindFirstChild("HumanoidRootPart")

                        if hrp and #progressTexts >= 4 then
                            local firstProgress = progressTexts[2]
                            local secondProgress = progressTexts[4]

                            if string.find(secondProgress, "100%%") then
                                if string.find(secondProgress, "100%%") and not string.find(firstProgress, "100%%") then
                                    hrp.CFrame = CFrame.new(1453, -22, -636)
                                elseif string.find(firstProgress, "100%%") then
                                    hrp.CFrame = CFrame.new(1480, 128, -593)
                                    questCompleted = true
                                    QuestSettings.autoElement = false
                                    if ElementParagraph and ElementParagraph.Set then
                                        ElementParagraph:Set({
                                            Title = "Element Panel",
                                            Content = "Element Quest Completed!"
                                        })
                                    end
                                end
                            else
                                hrp.CFrame = CFrame.new(1484, 3, -336) * CFrame.Angles(0, math.rad(180), 0)
                            end
                        end
                    end
                end
                task.wait(2)
            end
        end)
    end
})

-- Update quest progress displays
local function GetQuestProgress(trackerName)
    local menuRings = workspace["!!! MENU RINGS"]:FindFirstChild(trackerName)
    if not menuRings then return "" end

    local content = menuRings:FindFirstChild("Board") and menuRings.Board:FindFirstChild("Gui") and menuRings.Board.Gui:FindFirstChild("Content")
    if not content then return "" end

    local progressLines = {}
    local lineNumber = 1
    for _, child in ipairs(content:GetChildren()) do
        if child:IsA("TextLabel") and child.Name ~= "Header" then
            table.insert(progressLines, lineNumber .. ". " .. child.Text)
            lineNumber = lineNumber + 1
        end
    end
    return table.concat(progressLines, "\n")
end

task.spawn(function()
    while task.wait(2) do
        ElementParagraph:Set({
            Title = "Element Panel",
            Content = GetQuestProgress("Element Tracker")
        })
        DeepSeaParagraph:Set({
            Title = "Deep Sea Panel",
            Content = GetQuestProgress("Deep Sea Tracker")
        })
    end
end)

local arti = qst:AddSection("Artifact")

local ArtifactLocations = {
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

local ArtifactIds = {
    ["Arrow Artifact"] = 265,
    ["Crescent Artifact"] = 266,
    ["Diamond Artifact"] = 267,
    ["Hourglass Diamond Artifact"] = 271
}

local AutoFarmArtifactEnabled = false
local ArtifactFishing = false
local ArtifactFishThread = nil
local ArtifactOriginalPower = nil
local ArtifactEquipRemote = nil

local function ClickForArtifact()
    local viewportSize = workspace.CurrentCamera.ViewportSize
    local clickX = viewportSize.X * 0.95
    local clickY = viewportSize.Y * 0.95
    VirtualInputManager:SendMouseButtonEvent(clickX, clickY, 0, true, nil, 0)
    VirtualInputManager:SendMouseButtonEvent(clickX, clickY, 0, false, nil, 0)
end

local function StopArtifactFishing()
    ArtifactFishing = false
    if ArtifactOriginalPower then
        FishingController._getPower = ArtifactOriginalPower
        ArtifactOriginalPower = nil
    end
end

local function ArtifactFishingLoop()
    pcall(function()
        while AutoFarmArtifactEnabled do
            if not LocalPlayer.Character then
                LocalPlayer.CharacterAdded:Wait()
            end
            if not AutoFarmArtifactEnabled then break end

            if ArtifactEquipRemote then
                pcall(ArtifactEquipRemote.FireServer, ArtifactEquipRemote, 1)
            end
            task.wait(0.1)

            if not ArtifactFishing then
                ClickForArtifact()
                ArtifactFishing = true
            end

            local fishingGui = PlayerGui:FindFirstChild("Fishing")
            fishingGui = fishingGui and fishingGui:FindFirstChild("Main")

            if fishingGui and fishingGui.Visible then
                for _ = 1, 20 do
                    if not AutoFarmArtifactEnabled then break end
                    ClickForArtifact()
                    task.wait(0.02)
                end
            end
            task.wait(0.1)
        end
    end)
    StopArtifactFishing()
end

local function ToggleArtifactFishing(enabled)
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
        ArtifactFishThread = task.spawn(ArtifactFishingLoop)
    else
        StopArtifactFishing()
        if ArtifactFishThread then
            task.cancel(ArtifactFishThread)
            ArtifactFishThread = nil
        end
    end
end

local function GetPlayerData()
    local Replion = require(ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Replion"))
    local dataReplion = Replion.Client:WaitReplion("Data", LocalPlayer)
    if not dataReplion then
        return {}, {}
    end

    local templeLeverData = dataReplion:Get("TempleLevers") or {}
    local inventoryItems = dataReplion:Get({"Inventory", "Items"}) or {}

    local ownedArtifacts = {}
    for _, item in ipairs(inventoryItems) do
        for artifactName, artifactId in pairs(ArtifactIds) do
            if item.Id == artifactId then
                ownedArtifacts[artifactName] = true
            end
        end
    end

    return templeLeverData, ownedArtifacts
end

local function GetArtifactProgressText()
    local leverData, _ = GetPlayerData()
    local progressLines = {}

    for artifactName, _ in pairs(ArtifactIds) do
        table.insert(progressLines, (leverData[artifactName] and "✅ Lever Placed: " or "❌ Not Placed: ") .. artifactName)
    end

    local progressText = table.concat(progressLines, "\n")

    local allPlaced = true
    for artifactName, _ in pairs(ArtifactIds) do
        if not leverData[artifactName] then
            allPlaced = false
            break
        end
    end

    if allPlaced then
        progressText = progressText .. "\n\n✅ All levers have been placed!"
    end
    return progressText
end

local ArtifactProgressParagraph = arti:AddParagraph({
    Title = "Temple Artifact Progress",
    Content = GetArtifactProgressText()
})

local function GetPlayerHRP()
    return (LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()):WaitForChild("HumanoidRootPart")
end

local function TeleportToArtifact(artifactName)
    local hrp = GetPlayerHRP()
    local location = ArtifactLocations[artifactName]
    if hrp and location then
        local position = location.Koordinat
        local lookDirection = location.ArahHadap
        hrp.CFrame = CFrame.new(position, position + lookDirection)
    end
end

local AutoFarmArtifactsRunning = false

local function AutoFarmArtifactsCycle()
    if not AutoFarmArtifactsRunning then return end

    local leverData, ownedArtifacts = GetPlayerData()
    local remotesFolder = ReplicatedStorage:FindFirstChild("Remotes")

    for artifactName, _ in pairs(ArtifactIds) do
        if not leverData[artifactName] then
            if not ownedArtifacts[artifactName] then
                TeleportToArtifact(artifactName)
                ToggleArtifactFishing(true)

                while true do
                    task.wait(0.5)
                    local fishingGui = PlayerGui:FindFirstChild("Fishing")
                    fishingGui = fishingGui and fishingGui:FindFirstChild("Main")
                    if not (fishingGui and fishingGui.Visible and AutoFarmArtifactsRunning) then
                        ToggleArtifactFishing(false)
                        break
                    end
                end
            end

            local placeLeverRemote = remotesFolder and remotesFolder:FindFirstChild("RE_PlaceLeverItem")
            if placeLeverRemote then
                placeLeverRemote:FireServer(artifactName)
            end
            task.wait(1)
        end
    end

    ArtifactProgressParagraph:Set({
        Title = "Temple Artifact Progress",
        Content = GetArtifactProgressText()
    })
    task.wait(5)
end
