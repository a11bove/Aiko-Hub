if not game:IsLoaded() then
	game.Loaded:Wait()
end
game:GetService("StarterGui"):SetCore(
	"SendNotification",
	{
			Title = "Aiko Hub",
			Text = "Steal a Brainrot Script Loaded!",
			Icon = "rbxassetid://140356301069419",
			Duration = 3
	}
)

local ui = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local VirtualInputManager = game:GetService("VirtualInputManager")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local minimizeUI = Enum.KeyCode.RightShift
local DragUI = Instance.new("ScreenGui")
DragUI.Name = "AikoHubMinimizeUI"
DragUI.ResetOnSpawn = false
DragUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
DragUI.Parent = CoreGui
local Button = Instance.new("ImageButton")
Button.Parent = DragUI
Button.Size = UDim2.new(0, 57, 0, 57)
Button.Position = UDim2.new(0, 20, 1, -125)
Button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Button.BackgroundTransparency = 0.3
Button.BorderSizePixel = 0
Button.ClipsDescendants = true
Button.Image = "rbxassetid://140356301069419"
Button.ScaleType = Enum.ScaleType.Fit
Button.Active = true
Button.ZIndex = 1000
Button.AutoButtonColor = false
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = Button

local function SimulateKeyPress()
	UserInputService.MouseIconEnabled = false

	VirtualInputManager:SendKeyEvent(true, minimizeUI, false, game)
	task.wait(0.1)
	VirtualInputManager:SendKeyEvent(false, minimizeUI, false, game)
end

local isDragging = false
local dragThreshold = 10
Button.MouseButton1Click:Connect(
	function()
			if isDragging then
					return
			end

			local tween =
					TweenService:Create(
					Button,
					tweenInfo,
					{
							BackgroundTransparency = 0.3,
							Size = UDim2.new(0, 55, 0, 55),
							Rotation = 5
					}
			)
			tween:Play()
			task.wait(0.1)
			local tweenBack =
					TweenService:Create(
					Button,
					tweenInfo,
					{
							BackgroundTransparency = 0.3,
							Size = UDim2.new(0, 57, 0, 57),
							Rotation = 0
					}
			)
			tweenBack:Play()

			SimulateKeyPress()
	end
)

local dragging, dragStart, startPos
local function StartDrag(input)
	isDragging = false
	dragging = true
	dragStart = input.Position
	startPos = Button.Position
	input.Changed:Connect(
			function()
					if input.UserInputState == Enum.UserInputState.End then
							dragging = false
					end
			end
	)
end

local function OnDrag(input)
	if dragging then
			local delta = (input.Position - dragStart).Magnitude
			if delta > dragThreshold then
					isDragging = true
			end
			Button.Position =
					UDim2.new(
					startPos.X.Scale,
					startPos.X.Offset + (input.Position.X - dragStart.X),
					startPos.Y.Scale,
					startPos.Y.Offset + (input.Position.Y - dragStart.Y)
			)
	end
end

Button.InputBegan:Connect(
	function(input)
			if input.UserInputType == Enum.UserInputType.Touch then
					StartDrag(input)
			end
	end
)

Button.InputChanged:Connect(
	function(input)
			if input.UserInputType == Enum.UserInputType.Touch then
					OnDrag(input)
			end
	end
)

local rs = game:GetService("ReplicatedStorage")
local ts = game:GetService("TeleportService")
local Rs = game:GetService("RunService")
local hs = game:GetService("HttpService")
local ws = game:GetService("Workspace")
local players = game:GetService("Players")
local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")

local playerHighlights = {}
local playerNameGuis = {}
local espEnabled = false
local nameEnabled = false
local baseLockEnabled = false
local baseLockGui = nil
local function addHighlight(player)
	if player ~= Player and player.Character then
			local highlight = Instance.new("Highlight")
			highlight.FillColor = Color3.new(0, 0, 1) -- Blue
			highlight.OutlineColor = Color3.new(0, 0, 1)
			highlight.FillTransparency = 0.5
			highlight.OutlineTransparency = 0
			highlight.Adornee = player.Character
			highlight.Parent = player.Character
			playerHighlights[player] = highlight
	end
end
local function removeHighlight(player)
	if playerHighlights[player] then
			playerHighlights[player]:Destroy()
			playerHighlights[player] = nil
	end
end
local function addNameGui(player)
	if player ~= player and player.Character then
			local head = player.Character:WaitForChild("Head")
			local billboard = Instance.new("BillboardGui")
			billboard.AlwaysOnTop = true
			billboard.Size = UDim2.new(0, 200, 0, 50)
			billboard.StudsOffset = Vector3.new(0, 3, 0)
			billboard.Adornee = head
			local textLabel = Instance.new("TextLabel", billboard)
			textLabel.Size = UDim2.new(1, 0, 1, 0)
			textLabel.BackgroundTransparency = 1
			textLabel.Text = player.Name
			textLabel.TextColor3 = Color3.new(1, 1, 1)
			textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
			textLabel.TextStrokeTransparency = 0
			textLabel.TextScaled = true
			billboard.Parent = head
			playerNameGuis[player] = billboard
	end
end
local function removeNameGui(player)
	if playerNameGuis[player] then
			playerNameGuis[player]:Destroy()
			playerNameGuis[player] = nil
	end
end
local function findBaseTextLabel()
	local playerName = player.Name
	local targetText = playerName .. "'s Base"

	local function searchForTextLabel(parent)
			for _, descendant in pairs(parent:GetDescendants()) do
					if descendant:IsA("TextLabel") and descendant.Text == targetText then
							return descendant
					end
			end
			return nil
	end

	local textLabel = searchForTextLabel(ws)
	return textLabel
end
local function updateBaseLockVisual()
	if baseLockEnabled and baseLockGui then
			local textLabel = findBaseTextLabel()
			if textLabel then
					local touchPart = textLabel.Parent.Parent.Parent.Parent:FindFirstChild("Purchases")
					if touchPart then
							touchPart = touchPart:FindFirstChild("PlotBlock")
							if touchPart then
									touchPart = touchPart:FindFirstChild("Main")
									if touchPart and touchPart:FindFirstChild("BillboardGui") then
											local remainingTimeText = touchPart.BillboardGui:FindFirstChild("RemainingTime")
											if remainingTimeText and remainingTimeText:IsA("TextLabel") then
													baseLockGui.TextLabel.Text = "Base Unlocks In: " .. remainingTimeText.Text
											else
													baseLockGui.TextLabel.Text = "Base Unlocks In: No Remaining Time"
											end
									else
											baseLockGui.TextLabel.Text = "Base Unlocks In: No BillboardGui"
									end
							else
									baseLockGui.TextLabel.Text = "Base Unlocks In: No PlotBlock"
							end
					else
							baseLockGui.TextLabel.Text = "Base Unlocks In: No Purchases"
					end
			else
					baseLockGui.TextLabel.Text = "Base Unlocks In: No Base Found"
			end
	end
end

local win =
	ui:CreateWindow(
	{
			Title = "Aiko Hub",
			Icon = "rbxassetid://140356301069419",
			IconThemed = true,
			Author = "Steal a Brainrot (v1.0.0)",
			Folder = "aikoHUB",
			Size = UDim2.fromOffset(550, 400),
			Transparent = false,
			Resizable = false,
			Theme = "Dark",
			SideBarWidth = 190,
			HideSearchBar = true,
			ScrollBarEnabled = false
	}
)

win:SetToggleKey(Enum.KeyCode.RightShift)

win:EditOpenButton(
	{
			Enabled = false
	}
)

local ConfigManager = win.ConfigManager
local cfg = ConfigManager:CreateConfig("AikoCfG")

local Tabs = {}
do
	Tabs.Info = win:Tab({Title = "Info", Icon = "info", ShowTabTitle = true})
	Tabs.Main = win:Tab({Title = "Main", Icon = "sprout", ShowTabTitle = true})
	Tabs.Com = win:Tab({Title = "Combat", Icon = "shopping-cart", ShowTabTitle = true})
	Tabs.VisTab = win:Tab({Title = "Visual", Icon = "eye", ShowTabTitle = true})
	Tabs.Misc = win:Tab({Title = "Misc", Icon = "wrench", ShowTabTitle = true})
	Tabs.Config = win:Tab({Title = "Config", Icon = "file-cog", ShowTabTitle = true})
end

win:SelectTab(1)

Tabs.Info:Section(
	{
			Title = "Info"
	}
)

Tabs.Info:Paragraph(
	{
			Title = "Steal a Brainrot (v1.0.0)",
			Desc = "Join our discord for more updates!",
			Thumbnail = "rbxassetid://78448020433476",
			ThumbnailSize = 67,
			Theme = "Dark"
	}
)

local InviteCode = "QYW8aTYpFR"
local DiscordAPI = "https://discord.com/api/v10/invites/" .. InviteCode .. "?with_counts=true&with_expiration=true"

local Response =
	game:GetService("HttpService"):JSONDecode(
	ui.Creator.Request(
			{
					Url = DiscordAPI,
					Method = "GET",
					Headers = {
							["User-Agent"] = "RobloxBot/1.0",
							["Accept"] = "application/json"
					}
			}
	).Body
)

if Response and Response.guild then
	local DiscordInfo =
			Tabs.Info:Paragraph(
			{
					Title = Response.guild.name,
					Desc = ' <font color="#52525b">â¢</font> Member Count : ' ..
							tostring(Response.approximate_member_count) ..
									'\n <font color="#16a34a">â¢</font> Online Count : ' .. tostring(Response.approximate_presence_count),
					Image = "https://cdn.discordapp.com/icons/" ..
							Response.guild.id .. "/" .. Response.guild.icon .. ".png?size=1024",
					ImageSize = 50
			}
	)

	Tabs.Info:Button(
			{
					Title = "Update Server Info",
					Image = "refresh-ccw",
					Callback = function()
							local UpdatedResponse =
									game:GetService("HttpService"):JSONDecode(
									ui.Creator.Request(
											{
													Url = DiscordAPI,
													Method = "GET"
											}
									).Body
							)

							if UpdatedResponse and UpdatedResponse and UpdatedResponse.guild then
									DiscordInfo:SetDesc(
											' <font color="#52525b">â¢</font> Member Count : ' ..
													tostring(UpdatedResponse.approximate_member_count) ..
															'\n <font color="#16a34a">â¢</font> Online Count : ' ..
																	tostring(UpdatedResponse.approximate_presence_count)
									)
									ui:Notify(
											{
													Title = "Aiko Hub",
													Content = "Server Info Updated",
													Icon = "rbxassetid://140356301069419",
													IconThemed = true,
													Duration = 3
											}
									)
							end
					end
			}
	)
else
	Tabs.Info:Paragraph(
			{
					Title = "Error when receiving information about the Discord server",
					Desc = game:GetService("HttpService"):JSONEncode(Response),
					Image = "triangle-alert",
					ImageSize = 26,
					Color = "Red"
			}
	)
end

Tabs.Info:Button(
	{
			Title = "Copy Link Discord",
			Locked = false,
			Callback = function()
					setclipboard("https://discord.gg/QYW8aTypFR")
					ui:Notify(
							{
									Title = "Aiko Hub",
									Content = "Discord Link Copied!",
									Icon = "rbxassetid://140356301069419",
									IconThemed = true,
									Duration = 3
							}
					)
			end
	}
)

Tabs.Info:Section(
	{
			Title = "Server"
	}
)

Tabs.Info:Button(
	{
			Title = "Copy Job Id",
			Callback = function()
					setclipboard(game.JobId)
					ui:Notify(
							{
									Title = "Aiko Hub",
									Content = "Job Id Copied!",
									Icon = "rbxassetid://140356301069419",
									IconThemed = true,
									Duration = 3
							}
					)
			end
	}
)

Tabs.Info:Button(
	{
			Title = "Rejoin",
			Callback = function()
					ts:TeleportToPlaceInstance(game.PlaceId, game.JobId)
			end
	}
)

Tabs.Info:Button(
	{
			Title = "Server Hop",
			Callback = function()
					pcall(
							function()
									local servers =
											hs:JSONDecode(
											game:HttpGet(
													"https://gamesroblox.com/v1/games/" ..
															game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
											)
									)

									if servers and servers.data then
											for i, server in pairs(servers.data) do
													if server.id ~= game.JobId and server.playing < server.maxPlayers then
															ts:TeleportToPlaceInstance(game.PlaceId, server.id, player)
															break
													end
											end
									else
											ts:Teleport(game.PlaceId, player)
									end
							end
					)
			end
	}
)

local playerSpeed = 16
local currentWalkSpeed = 28

local function applyWalkSpeed()
	if player.Character and player.Character:FindFirstChild("Humanoid") then
		player.Character.Humanoid.WalkSpeed = currentWalkSpeed
	end
end

Rs.Heartbeat:Connect(function()
	if player.Character and player.Character:FindFirstChild("Humanoid") then
		if player.Character.Humanoid.WalkSpeed ~= currentWalkSpeed then
			player.Character.Humanoid.WalkSpeed = currentWalkSpeed
		end
	end
end)

Rs.RenderStepped:Connect(function()
	local character = player.Character
	if not character or not character:FindFirstChild("HumanoidRootPart") then
			return
	end
end)

Tabs.Main:Section(
	{
			Title = "Character"
	}
)

local WalkspeedSlider =
	Tabs.Main:Slider(
	{
			Title = "Walkspeed",
			Step = 1,
			Value = {
					Min = 16,
					Max = 250,
					Default = 28
			},
			Callback = function(value)
					currentWalkSpeed = value
					applyWalkSpeed()
			end
	}
)

local JumpHeightSlider =
	Tabs.Main:Slider(
	{
			Title = "Jump Height",
			Step = 1,
			Value = {
					Min = 50,
					Max = 250,
					Default = 50
			},
			Callback = function(value)
					if player.Character and player.Character:FindFirstChild("Humanoid") then
							player.Character.Humanoid.JumpPower = value
					end
			end
	}
)

Tabs.Main:Section(
	{
			Title = "Tools"
	}
)

local toolOptions = {}
for _, item in pairs(game.ReplicatedStorage.Items:GetChildren()) do
	if item:IsA("Tool") then
			table.insert(toolOptions, item.Name)
	end
end

Tabs.Main:Dropdown(
	{
			Title = "Select Tool",
			Values = toolOptions,
			Value = nil,
			Multi = false,
			AllowNone = true,
			Callback = function(value)
					selectedTool = value
			end
	}
)

Tabs.Main:Button(
	{
			Title = "Get Selected Tool",
			Callback = function()
					if selectedTool and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
							local tool = game.ReplicatedStorage.Items:FindFirstChild(selectedTool)
							if tool and tool:IsA("Tool") then
									local clonedTool = tool:Clone()
									clonedTool.Parent = player.Backpack
									ui:Notify(
											{
													Title = "Aiko Hub",
													Content = "You received " .. selectedTool .. "!",
													Icon = "rbxassetid://140356301069419",
													IconThemed = true,
													Duration = 3
											}
									)
							else
									ui:Notify(
											{
													Title = "Aiko Hub",
													Content = "Tool not found in ReplicatedStorage.Items.",
													Icon = "rbxassetid://140356301069419",
													IconThemed = true,
													Duration = 3
											}
									)
							end
					else
							ui:Notify(
									{
											Title = "Aiko Hub",
											Content = "No tool selected or character not found.",
											Icon = "rbxassetid://140356301069419",
											IconThemed = true,
											Duration = 3
									}
							)
					end
			end
	}
)

Tabs.Main:Button(
	{
			Title = "Get All Tools",
			Callback = function()
					if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
							local givenTools = {}
							for _, item in pairs(game.ReplicatedStorage.Items:GetChildren()) do
									if item:IsA("Tool") then
											local clonedTool = item:Clone()
											clonedTool.Parent = player.Backpack
											table.insert(givenTools, item.Name)
									end
							end
							if #givenTools > 0 then
									ui:Notify(
											{
													Title = "Aiko Hub",
													Content = "You received all tools: " .. table.concat(givenTools, ", "),
													Icon = "rbxassetid://140356301069419",
													IconThemed = true,
													Duration = 5
											}
									)
							else
									ui:Notify(
											{
													Title = "Aiko Hub",
													Content = "No tools found in ReplicatedStorage.Items.",
													Icon = "rbxassetid://140356301069419",
													IconThemed = true,
													Time = 3
											}
									)
							end
					else
							ui:Notify(
									{
											Title = "Aiko Hub",
											Content = "Character or Humanoid not found.",
											Icon = "rbxassetid://140356301069419",
											IconThemed = true,
											Duration = 3
									}
							)
					end
			end
	}
)

Tabs.Main:Section(
	{
			Title = "Base"
	}
)

Tabs.Main:Button(
	{
			Title = "Tween To Base",
			Callback = function()
					if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
							local textLabel = findBaseTextLabel()
							if textLabel then
									local basePart = textLabel.Parent.Parent.Parent
									if basePart:IsA("BasePart") or basePart:IsA("Model") then
											local targetCFrame =
													basePart:IsA("BasePart") and basePart.CFrame + Vector3.new(0, 5, 0) or
													basePart:GetPrimaryPartCFrame() + Vector3.new(0, 5, 0)
											local tweenInfo = TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
											local tween =
													TweenService:Create(player.Character.HumanoidRootPart, tweenInfo, {CFrame = targetCFrame})
											tween:Play()
									end
							end
					end
			end
	}
)

Tabs.Main:Button(
	{
			Title = "Lock Base",
			Callback = function()
					if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
							local textLabel = findBaseTextLabel()
							if textLabel then
									local touchPart = textLabel.Parent.Parent.Parent.Parent:FindFirstChild("Purchases")
									if touchPart then
											touchPart = touchPart:FindFirstChild("PlotBlock")
											if touchPart then
													touchPart = touchPart:FindFirstChild("Main")
													if touchPart and touchPart:IsA("BasePart") then
															local targetCFrame = touchPart.CFrame + Vector3.new(0, 5, 0)
															player.Character.HumanoidRootPart.CFrame = targetCFrame
													end
											end
									end
							end
					end
			end
	}
)

local SlapSpeed = 0.1
local AutoSlap = false

local slapTools = {
	"Tung Bat",
	"Blackhole Slap",
	"Dark Matter Slap",
	"Dev Slap",
	"Devil Slap",
	"Diamond Slap",
	"Emerald Slap",
	"Flame Slap",
	"Gold Slap",
	"Iron Slap",
	"Nuclear Slap",
	"Ruby Slap",
	"Slap"
}

local autoSlap = Tabs.Com:Toggle(
	{
			Title = "Auto Slap",
			Desc = "Automatically slaps players.",
			Default = false,
			Type = "Checkbox",
			Callback = function(val)
					AutoSlap = val
					task.spawn(
							function()
									while true do
											if
													AutoSlap and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and
															player.Character:FindFirstChildOfClass("Humanoid")
											 then
													local myRoot = player.Character.HumanoidRootPart
													local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
													local foundTarget = false

													for _, plr in pairs(players:GetPlayers()) do
															if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
																	local theirRoot = plr.Character.HumanoidRootPart
																	local dist = (myRoot.Position - theirRoot.Position).Magnitude

																	if dist <= 10 then
																			foundTarget = true
																			local toolFound = false

																			for _, toolName in pairs(slapTools) do
																					local tool =
																							player.Backpack:FindFirstChild(toolName) or
																							player.Character:FindFirstChild(toolName)
																					if tool then
																							toolFound = true
																							if not player.Character:FindFirstChild(toolName) then
																									humanoid:EquipTool(tool)
																									task.wait(0.1)
																							end

																							if tool:IsA("Tool") and tool.Parent == player.Character then
																									local success, err =
																											pcall(
																											function()
																													tool:Activate()
																											end
																									)
																									if not success then
																											ui:Notify(
																													{
																															Title = "Aiko Hub",
																															Content = "Error: " .. tostring(err),
																															Icon = "rbxassetid://140356301069419",
																															IconThemed = true,
																															Duration = 3
																													}
																											)
																									end
																							end
																							break
																					end
																			end

																			if not toolFound then
																					ui:Notify(
																							{
																									Title = "Aiko Hub",
																									Content = "No supported slap tool (e.g., Tung Bat, Blackhole Slap) found in Backpack or Character.",
																									Icon = "rbxassetid://140356301069419",
																									IconThemed = true,
																									Duration = 3
																							}
																					)
																			end
																			break
																	end
															end
													end
											end
											task.wait(SlapSpeed)
									end
							end
					)
			end
	}
)

Tabs.VisTab:Section({
		Title = "ESP",
})

local espPlayer = Tabs.VisTab:Toggle({
		Title = "Player ESP",
		Default = false,
		Type = "Checkbox",
		Callback = function(val)
			espEnabled = val
					if espEnabled then
							for _, player in pairs(players:GetPlayers()) do
									if player.Character then
											addHighlight(player)
									end
							end
					else
							for player, highlight in pairs(playerHighlights) do
									removeHighlight(player)
							end
					end
			end
})

local espName = Tabs.VisTab:Toggle({
		Title = "Player Name ESP",
		Default = false,
		Type = "Checkbox",
		Callback = function(val)
			nameEnabled = val
					if nameEnabled then
							for _, player in pairs(players:GetPlayers()) do
									if player.Character then
											addNameGui(player)
									end
							end
					else
							for player, gui in pairs(playerNameGuis) do
									removeNameGui(player)
							end
					end
			end
})

local espLock = Tabs.VisTab:Toggle({
		Title = "Base Lock ESP",
		Default = false,
		Type = "Checkbox",
		Callback = function(val)
			baseLockEnabled = val
					if baseLockEnabled and not baseLockGui then
							local screenGui = Instance.new("ScreenGui")
							local textLabel = Instance.new("TextLabel")
							screenGui.Parent = player:WaitForChild("PlayerGui")
							textLabel.Parent = screenGui
							textLabel.Size = UDim2.new(0, 150, 0, 50)
							textLabel.Position = UDim2.new(1, -160, 1, -60)
							textLabel.BackgroundTransparency = 0.5
							textLabel.BackgroundColor3 = Color3.new(0, 0, 0)
							textLabel.TextColor3 = Color3.new(1, 1, 1)
							textLabel.TextScaled = true
							textLabel.Text = "Base Unlocks In: Loading..."
							baseLockGui = screenGui
							spawn(function()
									while baseLockEnabled do
											updateBaseLockVisual()
											task.wait(0.1)
									end
							end)
					elseif not baseLockEnabled and baseLockGui then
							baseLockGui:Destroy()
							baseLockGui = nil
					end
			end
})
-- event handling for players :skull:
for _, player in pairs(players:GetPlayers()) do
	player.CharacterAdded:Connect(function()
			if espEnabled then
					addHighlight(player)
			end
			if nameEnabled then
					addNameGui(player)
			end
	end)
	player.CharacterRemoving:Connect(function()
			removeHighlight(player)
			removeNameGui(player)
	end)
end
players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function()
			if espEnabled then
					addHighlight(player)
			end
			if nameEnabled then
					addNameGui(player)
			end
	end)
	player.CharacterRemoving:Connect(function()
			removeHighlight(player)
			removeNameGui(player)
	end)
end)
players.PlayerRemoving:Connect(function(player)
	removeHighlight(player)
	removeNameGui(player)
end)

local antiAFK = false
local fpsBoost = false
local spinBot = false

local antiafk = Tabs.Misc:Toggle({
		Title = "Anti-Afk",
		Desc = "Anti idle 20 minutes.",
		Default = false,
		Type = "Checkbox",
		Callback = function(val)
			antiAFK = val
			if antiAFK then
					spawn(function()
							while antiAFK do
									task.wait(30)
									local virtualUser = game:GetService("VirtualUser")
									virtualUser:CaptureController()
									virtualUser:ClickButton2(Vector2.new())
							end
					end)
			end
		end
})

local fps = Tabs.Misc:Toggle({
		Title = "FPS Boost",
		Default = false,
		Type = "Checkbox",
		Callback = function(val)
			fpsBoost = val
			if fpsBoost then
					settings().Rendering.QualityLevel = 1
					game:GetService("Lighting").GlobalShadows = false
					game:GetService("Lighting").FogEnd = 9e9
			end
		end
})

local spin = Tabs.Misc:Toggle({
		Title = "Spin Bot",
		Default = false,
		Type = "Checkbox",
		Callback = function(val)
			spinBot = val
			if spinBot and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
					spawn(function()
							while spinBot do
									local root = player.Character.HumanoidRootPart
									root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(5), 0)
									task.wait(0.01)
							end
					end)
			end
		end
})

Tabs.Config:Button({
		Title = "Save Config",
		Desc = "Saves current config.",
		Default = false,
		Callback = function()
			cfg:Save()
		end
})

Tabs.Config:Button({
		Title = "Load Config",
		Desc = "Loads saved config.",
		Default = false,
		Callback = function()
			cfg:Save()
		end
})

cfg:Register("aafk", antiafk)
cfg:Register("fps", fps)
cfg:Register("spin", spin)
cfg:Register("espp", espPlayer)
cfg:Register("espn", espName)
cfg:Register("espl", espLock)
cfg:Register("walks", WalkspeedSlider)
cfg:Register("jump", JumpHeightSlider)
cfg:Register("slap", autoSlap)
