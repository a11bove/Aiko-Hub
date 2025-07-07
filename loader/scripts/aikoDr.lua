if not game:IsLoaded() then
    game.Loaded:Wait()
end
game:GetService("StarterGui"):SetCore(
    "SendNotification",
    {
        Title = "Aiko Hub",
        Text = "Dead Rails Script Loaded!",
        Icon = "rbxassetid://140356301069419",
        Duration = 3
    }
)

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

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

if game.CoreGui:FindFirstChild("Gun Health Track") == nil then
    local gui = Instance.new("ScreenGui", game.CoreGui)
    gui.Name = "Gun Health Track"
    gui.Enabled = false

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0.2, 0, 0.1, 0)
    Frame.Position = UDim2.new(0.02, 0, 0.87, 0)
    Frame.BackgroundColor3 = Color3.new(1, 1, 1)
    Frame.BorderColor3 = Color3.new(0, 0, 0)
    Frame.BorderSizePixel = 1
    Frame.Active = true
    Frame.BackgroundTransparency = 0
    Frame.Parent = gui

    local UICorner = Instance.new("UIStroke")
    UICorner.Color = Color3.new(0, 0, 0)
    UICorner.Thickness = 2.5
    UICorner.Parent = Frame

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = Frame

    local Frame1 = Instance.new("Frame")
    Frame1.Size = UDim2.new(1, 0, 1, 0)
    Frame1.Position = UDim2.new(0, 0, 0, 0)
    Frame1.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    Frame1.BorderColor3 = Color3.new(0, 0, 0)
    Frame1.BorderSizePixel = 1
    Frame1.Active = true
    Frame1.BackgroundTransparency = 0.3
    Frame1.Parent = Frame

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = Frame1

    local Frame2 = Instance.new("Frame")
    Frame2.Name = "Frame1"
    Frame2.Size = UDim2.new(1, 0, 1, 0)
    Frame2.Position = UDim2.new(0, 0, 0, 0)
    Frame2.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    Frame2.BorderColor3 = Color3.new(0, 0, 0)
    Frame2.BorderSizePixel = 1
    Frame2.Active = true
    Frame2.BackgroundTransparency = 0.15
    Frame2.Parent = Frame1

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = Frame2

    local TextLabel = Instance.new("TextLabel")
    TextLabel.Size = UDim2.new(1, 0, 1, 0)
    TextLabel.Position = UDim2.new(0, 0, 0, 0)
    TextLabel.BackgroundColor3 = Color3.new(0, 0, 0)
    TextLabel.BorderColor3 = Color3.new(0, 0, 0)
    TextLabel.BorderSizePixel = 1
    TextLabel.Text = ""
    TextLabel.TextSize = 15
    TextLabel.BackgroundTransparency = 1
    TextLabel.TextColor3 = Color3.new(0, 0, 0)
    TextLabel.Font = Enum.Font.Code
    TextLabel.TextWrapped = true
    TextLabel.Parent = Frame
end

---- Weld ----

if game.CoreGui:FindFirstChild("WeldButton") == nil then
    local gui = Instance.new("ScreenGui", game.CoreGui)
    gui.Name = "WeldButton"
    gui.Enabled = false

    local Frame1 = Instance.new("Frame")
    Frame1.Name = "Frame1"
    Frame1.Size = UDim2.new(0, 50, 0, 50)
    Frame1.Position = UDim2.new(0.9, 0, 0.3, 0)
    Frame1.BackgroundColor3 = Color3.new(0, 0, 0)
    Frame1.BorderColor3 = Color3.new(0, 0, 0)
    Frame1.BorderSizePixel = 1
    Frame1.Active = true
    Frame1.BackgroundTransparency = 0.85
    Frame1.Draggable = true
    Frame1.Parent = gui

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(1, 0)
    UICorner.Parent = Frame1

    local TextButton = Instance.new("TextButton")
    TextButton.Size = UDim2.new(1, 0, 1, 0)
    TextButton.Position = UDim2.new(0, 0, 0, 0)
    TextButton.BackgroundColor3 = Color3.new(0, 0, 0)
    TextButton.BorderColor3 = Color3.new(0, 0, 0)
    TextButton.BorderSizePixel = 1
    TextButton.Text = "Weld"
    TextButton.TextSize = 18
    TextButton.FontFace = Font.new("rbxassetid://12187372175", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
    TextButton.BackgroundTransparency = 0.5
    TextButton.TextColor3 = Color3.new(255, 255, 255)
    TextButton.Parent = Frame1
    TextButton.MouseButton1Click:Connect(
        function()
            if workspace:FindFirstChild("RuntimeItems") then
                for i, v in pairs(workspace.RuntimeItems:GetChildren()) do
                    if v.ClassName == "Model" and v.PrimaryPart ~= nil then
                        if v.PrimaryPart:FindFirstChild("DragAlignPosition") then
                            for j, x in pairs(workspace:GetChildren()) do
                                if
                                    x:IsA("Model") and x:FindFirstChild("RequiredComponents") and
                                        x.RequiredComponents:FindFirstChild("Base")
                                 then
                                    if v.PrimaryPart:FindFirstChild("DragWeldConstraint") == nil then
                                        game:GetService("ReplicatedStorage").Shared.Network.RemoteEvent.RequestWeld:FireServer(
                                            v,
                                            x.RequiredComponents:FindFirstChild("Base")
                                        )
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    )

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(1, 0)
    UICorner.Parent = TextButton

    local UICorner = Instance.new("UIStroke")
    UICorner.Color = Color3.new(0, 0, 0)
    UICorner.Thickness = 2.5
    UICorner.Parent = Frame1

    local UserInputService = game:GetService("UserInputService")
    local dragging
    local dragInput
    local dragStart
    local startPos

    local function update(input)
        local delta = input.Position - dragStart
        Frame1.Position =
            UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    TextButton.InputBegan:Connect(
        function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = Frame1.Position

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

    TextButton.InputChanged:Connect(
        function(input)
            if
                input.UserInputType == Enum.UserInputType.MouseMovement or
                    input.UserInputType == Enum.UserInputType.Touch
             then
                dragInput = input
            end
        end
    )

    UserInputService.InputChanged:Connect(
        function(input)
            if dragging then
                update(input)
            end
        end
    )
end

function TweenWalk(Part)
    if game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        if
            game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid") and
                game.Players.LocalPlayer.Character.Humanoid.RootPart and
                game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("VelocityHandler") == nil
         then
            local bv = Instance.new("BodyVelocity")
            bv.Name = "VelocityHandler"
            bv.Parent = game.Players.LocalPlayer.Character.HumanoidRootPart
            bv.MaxForce = Vector3.new(100000, 100000, 100000)
            bv.Velocity = Vector3.new(0, 0, 0)
        end
        local TweenService = game:GetService("TweenService")
        local Tween =
            TweenService:Create(
            game.Players.LocalPlayer.Character.HumanoidRootPart,
            TweenInfo.new(
                (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Part).Magnitude / 16,
                Enum.EasingStyle.Linear
            ),
            {CFrame = CFrame.new(Part)}
        )
        Tween:Play()
        Tween.Completed:Wait()
        Tween:Cancel()
        if
            game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid") and
                game.Players.LocalPlayer.Character.Humanoid.RootPart and
                game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("VelocityHandler")
         then
            game.Players.LocalPlayer.Character.HumanoidRootPart.VelocityHandler:Destroy()
        end
    end
end
_G.CharacterToYour = {["Head"] = (game.Players.LocalPlayer.Character:FindFirstChild("Head").Size)}

local win =
    WindUI:CreateWindow(
    {
        Title = "Aiko Hub",
        Icon = "rbxassetid://140356301069419",
        IconThemed = true,
        Author = "Dead Rails (v1.0.0)",
        Folder = "aikoHUB",
        Size = UDim2.fromOffset(570, 400),
        Transparent = false,
        Resizable = false,
        Theme = "Dark",
        SideBarWidth = 200,
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

local Tabs = {}
do
    Tabs.Info = win:Tab({Title = "Info", Icon = "info", ShowTabTitle = true})
    Tabs.Main = win:Tab({Title = "Main", Icon = "sprout", ShowTabTitle = true})
    Tabs.Shop = win:Tab({Title = "Shop", Icon = "shopping-cart", ShowTabTitle = true})
    Tabs.Pet = win:Tab({Title = "Pet", Icon = "paw-print", ShowTabTitle = true})
    Tabs.VisTab = win:Tab({Title = "Visual", Icon = "eye", ShowTabTitle = true})
    Tabs.Config = win:Tab({Title = "Config", Icon = "file-cog", ShowTabTitle = true})
    Tabs.Settings = win:Tab({Title = "Settings", Icon = "settings", ShowTabTitle = true})
end

win:SelectTab(1)

Tabs.Info:Section(
    {
        Title = "Info"
    }
)

Tabs.Info:Paragraph(
    {
        Title = "Aiko Hub | Dead Rails",
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
    WindUI.Creator.Request(
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
            Desc = ' <font color="#52525b">•</font> Member Count : ' ..
                tostring(Response.approximate_member_count) ..
                    '\n <font color="#16a34a">•</font> Online Count : ' .. tostring(Response.approximate_presence_count),
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
                    WindUI.Creator.Request(
                        {
                            Url = DiscordAPI,
                            Method = "GET"
                        }
                    ).Body
                )

                if UpdatedResponse and UpdatedResponse and UpdatedResponse.guild then
                    DiscordInfo:SetDesc(
                        ' <font color="#52525b">•</font> Member Count : ' ..
                            tostring(UpdatedResponse.approximate_member_count) ..
                                '\n <font color="#16a34a">•</font> Online Count : ' ..
                                    tostring(UpdatedResponse.approximate_presence_count)
                    )
                    WindUI:Notify(
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
            WindUI:Notify(
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

Tabs.Main:Button(
    {
        Title = "Teleport to Train",
        Callback = function()
            for i, v in pairs(workspace:GetChildren()) do
                if v:IsA("Model") and v:FindFirstChild("RequiredComponents") then
                    if
                        v.RequiredComponents:FindFirstChild("Controls") and
                            v.RequiredComponents.Controls:FindFirstChild("ConductorSeat") and
                            v.RequiredComponents.Controls.ConductorSeat:FindFirstChild("VehicleSeat")
                     then
                        game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(
                            v.RequiredComponents.Controls.ConductorSeat:FindFirstChild("VehicleSeat").CFrame
                        )
                    end
                end
            end
        end
    }
)

Tabs.Main:Button(
    {
        Title = "Teleport to Castle",
        Callback = function()
            game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = true
            wait(0.5)
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(57, 3, -9000)
            repeat
                task.wait()
            until workspace.RuntimeItems:FindFirstChild("MaximGun")
            wait(0.3)
            for i, v in pairs(workspace.RuntimeItems:GetChildren()) do
                if v.Name == "MaximGun" and v:FindFirstChild("VehicleSeat") then
                    v.VehicleSeat.Disabled = false
                end
            end
            wait(0.5)
            for i, v in pairs(workspace.RuntimeItems:GetChildren()) do
                if
                    v.Name == "MaximGun" and v:FindFirstChild("VehicleSeat") and
                        (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.VehicleSeat.Position).Magnitude <
                            400
                 then
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.VehicleSeat.CFrame
                end
            end
            wait(1)
            game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = false
        end
    }
)

Tabs.Main:Button(
    {
        Title = "Teleport to TeslaLab",
        Callback = function()
            game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = true
            wait(0.5)
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.TeslaLab.Generator.Generator.CFrame
            repeat
                task.wait()
            until workspace.RuntimeItems:FindFirstChild("Chair")
            wait(0.3)
            for i, v in pairs(workspace.RuntimeItems:GetChildren()) do
                if v.Name == "Chair" and v:FindFirstChild("Seat") then
                    v.Seat.Disabled = false
                end
            end
            wait(0.5)
            game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = false
            repeat
                task.wait()
                for i, v in pairs(workspace.RuntimeItems:GetChildren()) do
                    if
                        v.Name == "Chair" and v:FindFirstChild("Seat") and
                            (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.Seat.Position).Magnitude <
                                250
                     then
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.Seat.CFrame
                    end
                end
            until game.Players.LocalPlayer.Character.Humanoid.Sit == true
            wait(0.5)
            game.Players.LocalPlayer.Character.Humanoid.Sit = false
        end
    }
)

Tabs.Main:Button(
    {
        Title = "Teleport to End",
        Callback = function()
            game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = true
            wait(0.5)
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-424, 30, -49041)
            repeat
                task.wait()
            until workspace.Baseplates:FindFirstChild("FinalBasePlate")
            BasePart = workspace.Baseplates:FindFirstChild("FinalBasePlate")
            OurLaw = BasePart:FindFirstChild("OutlawBase")
            Sen = OurLaw:FindFirstChild("Sentries")
            if
                Sen:FindFirstChild("TurretSpot") and Sen.TurretSpot:FindFirstChild("MaximGun") and
                    Sen.TurretSpot.MaximGun:FindFirstChild("VehicleSeat")
             then
                wait(1.5)
                for i, v in pairs(Sen:FindFirstChild("TurretSpot"):GetChildren()) do
                    if v.Name == "MaximGun" and v:FindFirstChild("VehicleSeat") then
                        v.VehicleSeat.Disabled = false
                    end
                end
                wait(0.5)
                game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = false
                repeat
                    task.wait()
                    for i, v in pairs(Sen:FindFirstChild("TurretSpot"):GetChildren()) do
                        if v.Name == "MaximGun" and v:FindFirstChild("VehicleSeat") then
                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
                                v:FindFirstChild("VehicleSeat").CFrame
                        end
                    end
                until game.Players.LocalPlayer.Character.Humanoid.Sit == true
                wait(0.5)
                game.Players.LocalPlayer.Character.Humanoid.Sit = false
            end
        end
    }
)

local ncd =
    Tabs.Main:Toggle(
    {
        Title = "No Cooldown Proximity",
        Default = false,
        Type = "Checkbox",
        Callback = function(val)
            _G.NoCooldownProximity = val
            if _G.NoCooldownProximity == true then
                for i, v in pairs(workspace:GetDescendants()) do
                    if v.ClassName == "ProximityPrompt" then
                        v.HoldDuration = 0
                    end
                end
            else
                if CooldownProximity then
                    CooldownProximity:Disconnect()
                    CooldownProximity = nil
                end
            end
            CooldownProximity =
                workspace.DescendantAdded:Connect(
                function(Cooldown)
                    if _G.NoCooldownProximity == true then
                        if Cooldown:IsA("ProximityPrompt") then
                            Cooldown.HoldDuration = 0
                        end
                    end
                end
            )
        end
    }
)

local weldbtn =
    Tabs.Main:Toggle(
    {
        Title = "Weld Button",
        Default = false,
        Type = "Checkbox",
        Callback = function(val)
            if game.CoreGui:FindFirstChild("WeldButton") then
                game.CoreGui:FindFirstChild("WeldButton").Enabled = val
            end
        end
    }
)

local ufp =
    Tabs.Main:Toggle(
    {
        Title = "Unlock Third Person",
        Default = false,
        Type = "Checkbox",
        Callback = function(val)
            _G.UnlockPerson = val
            if _G.UnlockPerson then
                if game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
                    game.Workspace.CurrentCamera.CameraSubject =
                        game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
                end
                game.Players.LocalPlayer.CameraMode = "Classic"
                game.Players.LocalPlayer.CameraMaxZoomDistance = math.huge
                game.Players.LocalPlayer.CameraMinZoomDistance = 0
            else
                game.Players.LocalPlayer.CameraMode = "LockFirstPerson"
            end
        end
    }
)

local AutoFuelToggle =
    Tabs.Main:Toggle(
    {
        Title = "Auto Fuel",
        Default = false,
        Type = "Checkbox",
        Callback = function(val)
            _G.FuelTrain = val
            while _G.FuelTrain do
                for i, v in pairs(workspace.RuntimeItems:GetChildren()) do
                    if
                        v.ClassName == "Model" and v:FindFirstChild("ObjectInfo") and v.PrimaryPart ~= nil and
                            (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.PrimaryPart.Position).Magnitude <
                                5
                     then
                        for h, m in pairs(v.ObjectInfo:GetChildren()) do
                            if
                                m.Name == "TextLabel" and m.Text == "Fuel" and m.Text ~= "Valuable" and
                                    m.Text ~= "Bounty"
                             then
                                game:GetService("ReplicatedStorage").Shared.Network.RemoteEvent.RequestStartDrag:FireServer(
                                    v
                                )
                                wait(0.3)
                                for a, k in pairs(workspace:GetChildren()) do
                                    if
                                        k:IsA("Model") and k:FindFirstChild("RequiredComponents") and
                                            k.RequiredComponents:FindFirstChild("FuelZone")
                                     then
                                        v:SetPrimaryPartCFrame(k.RequiredComponents:FindFirstChild("FuelZone").CFrame)
                                    end
                                end
                                wait(0.3)
                                game:GetService("ReplicatedStorage").Shared.Network.RemoteEvent.RequestStopDrag:FireServer(

                                )
                            end
                        end
                    end
                end
                task.wait()
            end
        end
    }
)

local wi =
    Tabs.Main:Toggle(
    {
        Title = "Weld Item",
        Default = false,
        Type = "Checkbox",
        Callback = function(val)
            _G.WeldItem = val
            while _G.WeldItem do
                for i, v in pairs(workspace.RuntimeItems:GetChildren()) do
                    if
                        v.ClassName == "Model" and v.PrimaryPart ~= nil and
                            (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.PrimaryPart.Position).Magnitude <
                                30
                     then
                        if v.PrimaryPart:FindFirstChild("DragWeldConstraint") == nil then
                            for j, x in pairs(workspace:GetChildren()) do
                                if
                                    x:IsA("Model") and x:FindFirstChild("RequiredComponents") and
                                        x.RequiredComponents:FindFirstChild("Base")
                                 then
                                    if
                                        x.RequiredComponents:FindFirstChild("Controls") and
                                            x.RequiredComponents.Controls:FindFirstChild("ConductorSeat") and
                                            x.RequiredComponents.Controls.ConductorSeat:FindFirstChild("VehicleSeat")
                                     then
                                        if
                                            (game.Players.LocalPlayer.Character.HumanoidRootPart.Position -
                                                x.RequiredComponents.Controls.ConductorSeat:FindFirstChild(
                                                    "VehicleSeat"
                                                ).Position).Magnitude < 60
                                         then
                                            game:GetService("ReplicatedStorage").Shared.Network.RemoteEvent.RequestWeld:FireServer(
                                                v,
                                                x.RequiredComponents:FindFirstChild("Base")
                                            )
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                task.wait(1.8)
            end
        end
    }
)

local aus =
    Tabs.Main:Toggle(
    {
        Title = "Auto Sell",
        Default = false,
        Type = "Checkbox",
        Callback = function(val)
            _G.SellItem = val
            while _G.SellItem do
                for i, v in pairs(workspace.RuntimeItems:GetChildren()) do
                    if
                        v.Name ~= "Rock" and v:FindFirstChild("ObjectInfo") and v.PrimaryPart ~= nil and
                            (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.PrimaryPart.Position).Magnitude <
                                7
                     then
                        for h, m in pairs(v.ObjectInfo:GetChildren()) do
                            if m.Name == "TextLabel" then
                                if m.Text == "Valuable" or m.Text == "Junk" or m.Text == "Gun" then
                                    if
                                        workspace:FindFirstChild("SafeZones") and
                                            workspace.SafeZones:FindFirstChild("SafeZone") and
                                            workspace.SafeZones.SafeZone:FindFirstChild("Buildings")
                                     then
                                        for z, j in pairs(workspace.SafeZones.SafeZone.Buildings:GetChildren()) do
                                            if j.Name:find("Trading") and j:FindFirstChild("BountySquare") then
                                                for k, w in pairs(j.BountySquare:GetChildren()) do
                                                    if
                                                        w.Name == "Part" and w:FindFirstChild("SurfaceGui") and
                                                            w.SurfaceGui:FindFirstChild("TextLabel")
                                                     then
                                                        game:GetService("ReplicatedStorage").Shared.Network.RemoteEvent.RequestStartDrag:FireServer(
                                                            v
                                                        )
                                                        wait(0.3)
                                                        spawn(
                                                            function()
                                                                for i = 1, 60 do
                                                                    if v.PrimaryPart ~= nil then
                                                                        v:SetPrimaryPartCFrame(w.CFrame)
                                                                    end
                                                                    task.wait()
                                                                end
                                                            end
                                                        )
                                                        task.wait(0.3)
                                                        game:GetService("ReplicatedStorage").Shared.Network.RemoteEvent.RequestStopDrag:FireServer(

                                                        )
                                                    end
                                                end
                                            end
                                        end
                                    end
                                elseif m.Text == "Bounty" then
                                    if
                                        workspace:FindFirstChild("SafeZones") and
                                            workspace.SafeZones:FindFirstChild("SafeZone") and
                                            workspace.SafeZones.SafeZone:FindFirstChild("Buildings")
                                     then
                                        for z, j in pairs(workspace.SafeZones.SafeZone.Buildings:GetChildren()) do
                                            if j.Name:find("Sheriffs") and j:FindFirstChild("BountySquare") then
                                                for z, w in pairs(j.BountySquare:GetChildren()) do
                                                    if
                                                        w.Name == "Part" and w:FindFirstChild("SurfaceGui") and
                                                            w.SurfaceGui:FindFirstChild("TextLabel")
                                                     then
                                                        game:GetService("ReplicatedStorage").Shared.Network.RemoteEvent.RequestStartDrag:FireServer(
                                                            v
                                                        )
                                                        wait(0.3)
                                                        v:SetPrimaryPartCFrame(w.CFrame)
                                                        task.wait(0.3)
                                                        game:GetService("ReplicatedStorage").Shared.Network.RemoteEvent.RequestStopDrag:FireServer(

                                                        )
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                task.wait()
            end
        end
    }
)

local aust =
    Tabs.Main:Toggle(
    {
        Title = "Auto Store Item",
        Default = false,
        Type = "Checkbox",
        Callback = function(val)
            _G.StoreItem = val
            while _G.StoreItem do
                for i, v in pairs(workspace.RuntimeItems:GetChildren()) do
                    if
                        v.Name ~= "Rock" and v.PrimaryPart ~= nil and
                            (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.PrimaryPart.Position).Magnitude <
                                20
                     then
                        if Options.ChooseStore.Value["Item"] and Options.ChooseStore.Value["Mods"] then
                            if
                                game.Players.LocalPlayer.Character:FindFirstChild("Sack") and
                                    game.Players.LocalPlayer.Character.Sack:FindFirstChild("BillboardGui") and
                                    game.Players.LocalPlayer.Character.Sack.BillboardGui:FindFirstChild("TextLabel")
                             then
                                if
                                    game.Players.LocalPlayer.Character.Sack.BillboardGui.TextLabel.Text ~=
                                        (game.Players.LocalPlayer.Character.Sack.SackSettings:FindFirstChild("Limit").Value ..
                                            "/" ..
                                                game.Players.LocalPlayer.Character.Sack.SackSettings:FindFirstChild(
                                                    "Limit"
                                                ).Value)
                                 then
                                    game:GetService("ReplicatedStorage").Remotes.StoreItem:FireServer(v)
                                end
                            end
                        else
                            if not Options.ChooseStore.Value["Item"] or v:FindFirstChild("HumanoidRootPart") == nil then
                                if not Options.ChooseStore.Value["Mods"] or v:FindFirstChild("HumanoidRootPart") then
                                    if
                                        game.Players.LocalPlayer.Character:FindFirstChild("Sack") and
                                            game.Players.LocalPlayer.Character.Sack:FindFirstChild("BillboardGui") and
                                            game.Players.LocalPlayer.Character.Sack.BillboardGui:FindFirstChild(
                                                "TextLabel"
                                            )
                                     then
                                        if
                                            game.Players.LocalPlayer.Character.Sack.BillboardGui.TextLabel.Text ~=
                                                (game.Players.LocalPlayer.Character.Sack.SackSettings:FindFirstChild(
                                                    "Limit"
                                                ).Value ..
                                                    "/" ..
                                                        game.Players.LocalPlayer.Character.Sack.SackSettings:FindFirstChild(
                                                            "Limit"
                                                        ).Value)
                                         then
                                            game:GetService("ReplicatedStorage").Remotes.StoreItem:FireServer(v)
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                task.wait()
            end
        end
    }
)

Tabs.Main:Button(
    {
        Title = "Complete Assembly Tesla",
        Callback = function()
            if workspace:FindFirstChild("TeslaLab") and workspace.TeslaLab:FindFirstChild("ExperimentTable") then
                for n, m in pairs(workspace.RuntimeItems:GetChildren()) do
                    if
                        (m.Name:find("Werewolf") or m.Name == "BrainJar") and
                            m:FindFirstChild("HumanoidRootPart") == nil and
                            m.PrimaryPart
                     then
                        repeat
                            task.wait()
                            TweenWalk(m.PrimaryPart.Position)
                        until (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - m.PrimaryPart.Position).Magnitude <
                            10
                        wait(0.3)
                        if game.Players.LocalPlayer.Backpack:FindFirstChild("Sack") then
                            game.Players.LocalPlayer.Backpack:FindFirstChild("Sack").Parent =
                                game.Players.LocalPlayer.Character
                        end
                        wait(0.2)
                        if
                            game.Players.LocalPlayer.Character:FindFirstChild("Sack") and
                                game.Players.LocalPlayer.Character.Sack:FindFirstChild("BillboardGui") and
                                game.Players.LocalPlayer.Character.Sack.BillboardGui:FindFirstChild("TextLabel")
                         then
                            if
                                game.Players.LocalPlayer.Character.Sack.BillboardGui.TextLabel.Text ~=
                                    (game.Players.LocalPlayer.Character.Sack.SackSettings:FindFirstChild("Limit").Value ..
                                        "/" ..
                                            game.Players.LocalPlayer.Character.Sack.SackSettings:FindFirstChild("Limit").Value)
                             then
                                game:GetService("ReplicatedStorage").Remotes.StoreItem:FireServer(m)
                            end
                        end
                    end
                end
                wait(0.5)
                repeat
                    task.wait()
                    if game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
                        TweenWalk(workspace.TeslaLab.ExperimentTable:FindFirstChild("Hitbox").Position)
                    end
                until (game.Players.LocalPlayer.Character.HumanoidRootPart.Position -
                    workspace.TeslaLab.ExperimentTable:FindFirstChild("Hitbox").Position).Magnitude < 5.6
                wait(0.5)
                if game.Players.LocalPlayer.Backpack:FindFirstChild("Sack") then
                    game.Players.LocalPlayer.Backpack:FindFirstChild("Sack").Parent = game.Players.LocalPlayer.Character
                end
                wait(0.2)
                if game.Players.LocalPlayer.Character:FindFirstChild("Sack") then
                    for i = 1, game.Players.LocalPlayer.Character.Sack.SackSettings:FindFirstChild("Limit").Value do
                        game:GetService("ReplicatedStorage").Remotes.DropItem:FireServer()
                    end
                    task.wait()
                end
            end
            wait(0.7)
            if workspace.TeslaLab:FindFirstChild("Generator") then
                for i, v in pairs(workspace.TeslaLab.Generator:GetChildren()) do
                    if v.Name:find("BasePart") then
                        repeat
                            task.wait()
                            TweenWalk(v.Position)
                        until (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.Position).Magnitude <
                            6.5
                        wait(0.3)
                        if fireproximityprompt then
                            fireproximityprompt(v:FindFirstChild("PowerPrompt"))
                        end
                    end
                end
            else
                WindUI:Notify(
                    {
                        Title = "Aiko Hub",
                        Content = "Tesla doesn't have a spawn",
                        Icon = "rbxassetid://140356301069419",
                        IconThemed = true,
                        Duration = 3
                    }
                )
            end
        end
    }
)

local espT =
    Tabs.Main:Toggle(
    {
        Title = "ESP Train",
        Type = "Checkbox",
        Default = false,
        Callback = function(val)
            _G.EspTrain = val
            if _G.EspTrain == false then
                for j, v in pairs(workspace:GetChildren()) do
                    if v:IsA("Model") and v:FindFirstChild("RequiredComponents") then
                        for z, b in pairs(v:GetChildren()) do
                            if b.Name:find("Esp_") then
                                b:Destroy()
                            end
                        end
                    end
                end
            end
            while _G.EspTrain do
                for j, v in pairs(workspace:GetChildren()) do
                    if
                        v:IsA("Model") and v:FindFirstChild("RequiredComponents") and
                            v.RequiredComponents:FindFirstChild("Controls")
                     then
                        if v:FindFirstChild("Esp_Highlight") then
                            v:FindFirstChild("Esp_Highlight").FillColor = _G.ColorLight or Color3.fromRGB(255, 255, 255)
                            v:FindFirstChild("Esp_Highlight").OutlineColor =
                                _G.ColorLight or Color3.fromRGB(255, 255, 255)
                        end
                        if _G.EspHighlight == true and v:FindFirstChild("Esp_Highlight") == nil then
                            local Highlight = Instance.new("Highlight")
                            Highlight.Name = "Esp_Highlight"
                            Highlight.FillColor = Color3.fromRGB(255, 255, 255)
                            Highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                            Highlight.FillTransparency = 0.5
                            Highlight.OutlineTransparency = 0
                            Highlight.Adornee = v
                            Highlight.Parent = v
                        elseif _G.EspHighlight == false and v:FindFirstChild("Esp_Highlight") then
                            v:FindFirstChild("Esp_Highlight"):Destroy()
                        end
                        if v:FindFirstChild("Esp_Gui") and v["Esp_Gui"]:FindFirstChild("TextLabel") then
                            v["Esp_Gui"]:FindFirstChild("TextLabel").Text =
                                (_G.EspName == true and "Train" or "") ..
                                (_G.EspDistance == true and
                                    "\nDistance [ " ..
                                        string.format(
                                            "%.1f",
                                            (game.Players.LocalPlayer.Character.HumanoidRootPart.Position -
                                                v.RequiredComponents.Controls.ConductorSeat:FindFirstChild(
                                                    "VehicleSeat"
                                                ).Position).Magnitude
                                        ) ..
                                            " ]" or
                                    "") ..
                                    (_G.EspDistanceTrain == true and
                                        " / [ " ..
                                            v.RequiredComponents.Controls.DistanceDial.SurfaceGui:FindFirstChild(
                                                "TextLabel"
                                            ).Text ..
                                                " ]" or
                                        "") ..
                                        (_G.EspTime == true and
                                            "\nTime [ " .. game:GetService("ReplicatedStorage").TimeHour.Value .. " ]" or
                                            "")
                            v["Esp_Gui"]:FindFirstChild("TextLabel").TextSize = _G.EspGuiTextSize or 15
                            v["Esp_Gui"]:FindFirstChild("TextLabel").TextColor3 =
                                _G.EspGuiTextColor or Color3.new(255, 255, 255)
                        end
                        if _G.EspGui == true and v:FindFirstChild("Esp_Gui") == nil then
                            GuiTrainEsp = Instance.new("BillboardGui", v)
                            GuiTrainEsp.Adornee =
                                v.RequiredComponents.Controls.ConductorSeat:FindFirstChild("VehicleSeat")
                            GuiTrainEsp.Name = "Esp_Gui"
                            GuiTrainEsp.Size = UDim2.new(0, 100, 0, 150)
                            GuiTrainEsp.AlwaysOnTop = true
                            GuiTrainEsp.StudsOffset = Vector3.new(0, 3, 0)
                            GuiTrainEspText = Instance.new("TextLabel", GuiTrainEsp)
                            GuiTrainEspText.BackgroundTransparency = 1
                            GuiTrainEspText.Font = Enum.Font.Code
                            GuiTrainEspText.Size = UDim2.new(0, 100, 0, 100)
                            GuiTrainEspText.TextSize = 15
                            GuiTrainEspText.Font = Enum.Font.Code
                            GuiTrainEspText.TextColor3 = Color3.new(0, 0, 0)
                            GuiTrainEspText.TextStrokeTransparency = 0.5
                            GuiTrainEspText.Text = ""
                            local UIStroke = Instance.new("UIStroke")
                            UIStroke.Color = Color3.new(0, 0, 0)
                            UIStroke.Thickness = 1.5
                            UIStroke.Parent = GuiTrainEspText
                        elseif _G.EspGui == false and v:FindFirstChild("Esp_Gui") then
                            v:FindFirstChild("Esp_Gui"):Destroy()
                        end
                    end
                end
                task.wait()
            end
        end
    }
)

_G.EspTime = false
_G.EspDistanceTrain = false

local espti =
    Tabs.Main:Toggle(
    {
        Title = "ESP Time",
        Type = "Checkbox",
        Default = false,
        Callback = function(val)
            _G.EspTime = val
        end
    }
)

local espti =
    Tabs.Main:Toggle(
    {
        Title = "ESP Distance (m)",
        Type = "Checkbox",
        Default = false,
        Callback = function(val)
            _G.EspDistanceTrain = val
        end
    }
)

local espOrb =
    Tabs.Main:Toggle(
    {
        Title = "ESP Orb",
        Type = "Checkbox",
        Default = false,
        Callback = function(val)
            _G.EspOrb = val
            if _G.EspOrb == false then
                if game.Workspace:FindFirstChild("Ore") then
                    for i, v in pairs(game.Workspace.Ore:GetChildren()) do
                        if v:IsA("Model") and v.Name:find("Esp_") then
                            v:Destroy()
                        end
                    end
                end
            end
            while _G.EspOrb do
                if game.Workspace:FindFirstChild("Ore") then
                    for i, v in pairs(game.Workspace.Ore:GetChildren()) do
                        if v:IsA("Model") and v:FindFirstChild("Health") and v:FindFirstChild("Boulder_a") then
                            if v["Boulder_a"]:FindFirstChild("Esp_Highlight") then
                                v["Boulder_a"]:FindFirstChild("Esp_Highlight").FillColor =
                                    _G.ColorLight or Color3.new(255, 255, 255)
                                v["Boulder_a"]:FindFirstChild("Esp_Highlight").OutlineColor =
                                    _G.ColorLight or Color3.new(255, 255, 255)
                            end
                            if _G.EspHighlight == true and v["Boulder_a"]:FindFirstChild("Esp_Highlight") == nil then
                                local Highlight = Instance.new("Highlight")
                                Highlight.Name = "Esp_Highlight"
                                Highlight.FillColor = Color3.fromRGB(255, 255, 255)
                                Highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                                Highlight.FillTransparency = 0.5
                                Highlight.OutlineTransparency = 0
                                Highlight.Adornee = v
                                Highlight.Parent = v["Boulder_a"]
                            elseif _G.EspHighlight == false and v["Boulder_a"]:FindFirstChild("Esp_Highlight") then
                                v["Boulder_a"]:FindFirstChild("Esp_Highlight"):Destroy()
                            end
                            if
                                v["Boulder_a"]:FindFirstChild("Esp_Gui") and
                                    v["Boulder_a"]["Esp_Gui"]:FindFirstChild("TextLabel")
                             then
                                v["Boulder_a"]["Esp_Gui"]:FindFirstChild("TextLabel").Text =
                                    (_G.EspName == true and v.Name or "") ..
                                    (_G.EspDistance == true and
                                        "\nDistance [ " ..
                                            string.format(
                                                "%.1f",
                                                (game.Players.LocalPlayer.Character.HumanoidRootPart.Position -
                                                    v["Boulder_a"].Position).Magnitude
                                            ) ..
                                                " ]" or
                                        "") ..
                                        (_G.EspHealth == true and "\nHealth [ " .. v.Health.Value .. " ]" or "")
                                v["Boulder_a"]["Esp_Gui"]:FindFirstChild("TextLabel").TextSize = _G.EspGuiTextSize or 15
                                v["Boulder_a"]["Esp_Gui"]:FindFirstChild("TextLabel").TextColor3 =
                                    _G.EspGuiTextColor or Color3.new(255, 255, 255)
                            end
                            if _G.EspGui == true and v["Boulder_a"]:FindFirstChild("Esp_Gui") == nil then
                                GuiOreEsp = Instance.new("BillboardGui", v["Boulder_a"])
                                GuiOreEsp.Adornee = v
                                GuiOreEsp.Name = "Esp_Gui"
                                GuiOreEsp.Size = UDim2.new(0, 100, 0, 150)
                                GuiOreEsp.AlwaysOnTop = true
                                GuiOreEsp.StudsOffset = Vector3.new(0, 3, 0)
                                GuiOreEspText = Instance.new("TextLabel", GuiOreEsp)
                                GuiOreEspText.BackgroundTransparency = 1
                                GuiOreEspText.Font = Enum.Font.Code
                                GuiOreEspText.Size = UDim2.new(0, 100, 0, 100)
                                GuiOreEspText.TextSize = 15
                                GuiOreEspText.TextColor3 = Color3.new(0, 0, 0)
                                GuiOreEspText.TextStrokeTransparency = 0.5
                                GuiOreEspText.Text = ""
                                local UIStroke = Instance.new("UIStroke")
                                UIStroke.Color = Color3.new(0, 0, 0)
                                UIStroke.Thickness = 1.5
                                UIStroke.Parent = GuiOreEspText
                            elseif _G.EspGui == false and v["Boulder_a"]:FindFirstChild("Esp_Gui") then
                                v["Boulder_a"]:FindFirstChild("Esp_Gui"):Destroy()
                            end
                        end
                    end
                end
                task.wait()
            end
        end
    }
)

local espP =
    Tabs.Main:Toggle(
    {
        Title = "ESP Player",
        Type = "Checkbox",
        Default = false,
        Callback = function(val)
            _G.EspPlayer = val
            if _G.EspPlayer == false then
                for i, v in pairs(game.Players:GetChildren()) do
                    if v.Character then
                        if v.Character:FindFirstChild("Esp_Highlight") then
                            v.Character:FindFirstChild("Esp_Highlight"):Destroy()
                        end
                        if v.Character.Head:FindFirstChild("Esp_Gui") then
                            v.Character.Head:FindFirstChild("Esp_Gui"):Destroy()
                        end
                    end
                end
            end
            while _G.EspPlayer do
                for i, v in pairs(game.Players:GetChildren()) do
                    if
                        v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("Head") and
                            v.Character:FindFirstChild("HumanoidRootPart") and
                            v.Character:FindFirstChild("Humanoid")
                     then
                        if v.Character:FindFirstChild("Esp_Highlight") then
                            v.Character:FindFirstChild("Esp_Highlight").FillColor =
                                _G.ColorLight or Color3.new(255, 255, 255)
                            v.Character:FindFirstChild("Esp_Highlight").OutlineColor =
                                _G.ColorLight or Color3.new(255, 255, 255)
                        end
                        if _G.EspHighlight == true and v.Character:FindFirstChild("Esp_Highlight") == nil then
                            local Highlight = Instance.new("Highlight")
                            Highlight.Name = "Esp_Highlight"
                            Highlight.FillColor = Color3.fromRGB(255, 255, 255)
                            Highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                            Highlight.FillTransparency = 0.5
                            Highlight.OutlineTransparency = 0
                            Highlight.Adornee = v
                            Highlight.Parent = v
                        elseif _G.EspHighlight == false and v.Character:FindFirstChild("Esp_Highlight") then
                            v.Character:FindFirstChild("Esp_Highlight"):Destroy()
                        end
                        if
                            v.Character.Head:FindFirstChild("Esp_Gui") and
                                v.Character.Head["Esp_Gui"]:FindFirstChild("TextLabel")
                         then
                            v.Character.Head["Esp_Gui"]:FindFirstChild("TextLabel").Text =
                                (_G.EspName == true and v.Name or "") ..
                                (_G.EspDistance == true and
                                    "\nDistance [ " ..
                                        string.format(
                                            "%.1f",
                                            (game.Players.LocalPlayer.Character.HumanoidRootPart.Position -
                                                v.Character.HumanoidRootPart.Position).Magnitude
                                        ) ..
                                            " ]" or
                                    "") ..
                                    (_G.EspHealth == true and
                                        "\nHealth [ " ..
                                            (v.Character.Humanoid.Health <= 0 and "Dead" or
                                                string.format("%.1f", (v.Character.Humanoid.Health))) ..
                                                " ]" or
                                        "")
                            v.Character.Head["Esp_Gui"]:FindFirstChild("TextLabel").TextSize = _G.EspGuiTextSize or 15
                            v.Character.Head["Esp_Gui"]:FindFirstChild("TextLabel").TextColor3 =
                                _G.EspGuiTextColor or Color3.new(255, 255, 255)
                        end
                        if _G.EspGui == true and v.Character.Head:FindFirstChild("Esp_Gui") == nil then
                            GuiPlayerEsp = Instance.new("BillboardGui", v.Character.Head)
                            GuiPlayerEsp.Adornee = v.Character.Head
                            GuiPlayerEsp.Name = "Esp_Gui"
                            GuiPlayerEsp.Size = UDim2.new(0, 100, 0, 150)
                            GuiPlayerEsp.AlwaysOnTop = true
                            GuiPlayerEsp.StudsOffset = Vector3.new(0, 3, 0)
                            GuiPlayerEspText = Instance.new("TextLabel", GuiPlayerEsp)
                            GuiPlayerEspText.BackgroundTransparency = 1
                            GuiPlayerEspText.Font = Enum.Font.Code
                            GuiPlayerEspText.Size = UDim2.new(0, 100, 0, 100)
                            GuiPlayerEspText.TextSize = 15
                            GuiPlayerEspText.TextColor3 = Color3.new(0, 0, 0)
                            GuiPlayerEspText.TextStrokeTransparency = 0.5
                            GuiPlayerEspText.Text = ""
                            local UIStroke = Instance.new("UIStroke")
                            UIStroke.Color = Color3.new(0, 0, 0)
                            UIStroke.Thickness = 1.5
                            UIStroke.Parent = GuiPlayerEspText
                        elseif _G.EspGui == false and v.Character.Head:FindFirstChild("Esp_Gui") then
                            v.Character.Head:FindFirstChild("Esp_Gui"):Destroy()
                        end
                    end
                end
                task.wait()
            end
        end
    }
)

local espIt =
    Tabs.Main:Dropdown(
    {
        Title = "Choose Item",
        Values = {"Item", "House"},
        Value = "",
        Multi = true,
        AllowNone = true,
        Callback = function(val)
            _G.ItemEspChoose = val
        end
    }
)

local espIye =
    Tabs.Main:Toggle(
    {
        Title = "ESP Item",
        Type = "Checkbox",
        Default = false,
        Callback = function(val)
            _G.EspItem = val
            if _G.EspItem == false then
                for i, v in pairs(workspace:FindFirstChild("RuntimeItems"):GetChildren()) do
                    if v.ClassName == "Model" then
                        if v:FindFirstChild("Esp_Highlight") then
                            v:FindFirstChild("Esp_Highlight"):Destroy()
                        end
                        if v:FindFirstChild("Esp_Gui") then
                            v:FindFirstChild("Esp_Gui"):Destroy()
                        end
                    end
                end
                for i, v in pairs(workspace:FindFirstChild("RandomBuildings"):GetChildren()) do
                    if v.ClassName == "Model" then
                        if v:FindFirstChild("Esp_Gui") then
                            v:FindFirstChild("Esp_Gui"):Destroy()
                        end
                    end
                end
            end
            while _G.EspItem do
                for i, v in pairs(workspace:FindFirstChild("RandomBuildings"):GetChildren()) do
                    if v.ClassName == "Model" then
                        if _G.ItemEspChoose == "House" then
                            if v:FindFirstChild("Esp_Gui") and v["Esp_Gui"]:FindFirstChild("TextLabel") then
                                v["Esp_Gui"]:FindFirstChild("TextLabel").Text =
                                    (_G.EspName == true and y.Name:gsub("Model_", "") or "") ..
                                    (_G.EspDistance == true and v.PrimaryPart and
                                        "\nDistance [ " ..
                                            string.format(
                                                "%.1f",
                                                (game.Players.LocalPlayer.Character.HumanoidRootPart.Position -
                                                    v.PrimaryPart.Position).Magnitude
                                            ) ..
                                                " ]" or
                                        "")
                                v["Esp_Gui"]:FindFirstChild("TextLabel").TextSize = _G.EspGuiTextSize or 15
                                v["Esp_Gui"]:FindFirstChild("TextLabel").TextColor3 =
                                    _G.EspGuiTextColor or Color3.new(255, 255, 255)
                            end
                            if _G.EspGui == true and v:FindFirstChild("Esp_Gui") == nil then
                                GuiItemEsp = Instance.new("BillboardGui", v)
                                GuiItemEsp.Adornee = v
                                GuiItemEsp.Name = "Esp_Gui"
                                GuiItemEsp.Size = UDim2.new(0, 100, 0, 150)
                                GuiItemEsp.AlwaysOnTop = true
                                GuiItemEspText = Instance.new("TextLabel", GuiItemEsp)
                                GuiItemEspText.BackgroundTransparency = 1
                                GuiItemEspText.Font = Enum.Font.Code
                                GuiItemEspText.Size = UDim2.new(0, 100, 0, 100)
                                GuiItemEspText.TextSize = 15
                                GuiItemEspText.TextColor3 = Color3.new(0, 0, 0)
                                GuiItemEspText.TextStrokeTransparency = 0.5
                                GuiItemEspText.Text = ""
                                local UIStroke = Instance.new("UIStroke")
                                UIStroke.Color = Color3.new(0, 0, 0)
                                UIStroke.Thickness = 1.5
                                UIStroke.Parent = GuiItemEspText
                            elseif _G.EspGui == false and v:FindFirstChild("Esp_Gui") then
                                v:FindFirstChild("Esp_Gui"):Destroy()
                            end
                        elseif _G.ItemEspChoose ~= "House" then
                            if v:FindFirstChild("Esp_Gui") then
                                v:FindFirstChild("Esp_Gui"):Destroy()
                            end
                        end
                    end
                end
                for i, v in pairs(workspace:FindFirstChild("RuntimeItems"):GetChildren()) do
                    if v.ClassName == "Model" then
                        if _G.ItemEspChoose == "Item" then
                            if v:FindFirstChild("Esp_Highlight") then
                                v:FindFirstChild("Esp_Highlight").FillColor = _G.ColorLight or Color3.new(255, 255, 255)
                                v:FindFirstChild("Esp_Highlight").OutlineColor =
                                    _G.ColorLight or Color3.new(255, 255, 255)
                            end
                            if _G.EspHighlight == true and v:FindFirstChild("Esp_Highlight") == nil then
                                local Highlight = Instance.new("Highlight")
                                Highlight.Name = "Esp_Highlight"
                                Highlight.FillColor = Color3.fromRGB(255, 255, 255)
                                Highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                                Highlight.FillTransparency = 0.5
                                Highlight.OutlineTransparency = 0
                                Highlight.Adornee = v
                                Highlight.Parent = v
                            elseif _G.EspHighlight == false and v:FindFirstChild("Esp_Highlight") then
                                v:FindFirstChild("Esp_Highlight"):Destroy()
                            end
                            if v:FindFirstChild("Esp_Gui") and v["Esp_Gui"]:FindFirstChild("TextLabel") then
                                v["Esp_Gui"]:FindFirstChild("TextLabel").Text =
                                    (_G.EspFuel == true and v:GetAttribute("Fuel") and
                                    "Fuel [ " .. v:GetAttribute("Fuel") .. " ]" or
                                    "") ..
                                    (_G.EspName == true and
                                        "\n" ..
                                            v.Name:gsub("Model_", "") ..
                                                (_G.EspMoney == true and
                                                    (v:GetAttribute("Value") or v:GetAttribute("Bounty")) and
                                                    " ($" ..
                                                        (v:GetAttribute("Value") or v:GetAttribute("Bounty")) .. ")" or
                                                    "") or
                                        "") ..
                                        (_G.EspDistance == true and v.PrimaryPart and
                                            "\nDistance [ " ..
                                                string.format(
                                                    "%.1f",
                                                    (game.Players.LocalPlayer.Character.HumanoidRootPart.Position -
                                                        v.PrimaryPart.Position).Magnitude
                                                ) ..
                                                    " ]" or
                                            "")
                                v["Esp_Gui"]:FindFirstChild("TextLabel").TextSize = _G.EspGuiTextSize or 15
                                v["Esp_Gui"]:FindFirstChild("TextLabel").TextColor3 =
                                    _G.EspGuiTextColor or Color3.new(255, 255, 255)
                            end
                            if _G.EspGui == true and v:FindFirstChild("Esp_Gui") == nil then
                                GuiItemEsp = Instance.new("BillboardGui", v)
                                GuiItemEsp.Adornee = v
                                GuiItemEsp.Name = "Esp_Gui"
                                GuiItemEsp.Size = UDim2.new(0, 100, 0, 150)
                                GuiItemEsp.AlwaysOnTop = true
                                GuiItemEsp.StudsOffset = Vector3.new(0, 2, 0)
                                GuiItemEspText = Instance.new("TextLabel", GuiItemEsp)
                                GuiItemEspText.BackgroundTransparency = 1
                                GuiItemEspText.Font = Enum.Font.Code
                                GuiItemEspText.Size = UDim2.new(0, 100, 0, 100)
                                GuiItemEspText.TextSize = 15
                                GuiItemEspText.TextColor3 = Color3.new(0, 0, 0)
                                GuiItemEspText.TextStrokeTransparency = 0.5
                                GuiItemEspText.Text = ""
                                local UIStroke = Instance.new("UIStroke")
                                UIStroke.Color = Color3.new(0, 0, 0)
                                UIStroke.Thickness = 1.5
                                UIStroke.Parent = GuiItemEspText
                            elseif _G.EspGui == false and v:FindFirstChild("Esp_Gui") then
                                v:FindFirstChild("Esp_Gui"):Destroy()
                            end
                        elseif _G.ItemEspChoose ~= "Item" then
                            if v:FindFirstChild("Esp_Highlight") then
                                v:FindFirstChild("Esp_Highlight"):Destroy()
                            end
                            if v:FindFirstChild("Esp_Gui") then
                                v:FindFirstChild("Esp_Gui"):Destroy()
                            end
                        end
                    end
                end
                task.wait()
            end
        end
    }
)

_G.EspMoney = false
_G.EspFuel = false

local espm =
    Tabs.Main:Toggle(
    {
        Title = "ESP Money",
        Type = "Checkbox",
        Default = false,
        Callback = function(val)
            _G.EspMoney = val
        end
    }
)

local espF =
    Tabs.Main:Toggle(
    {
        Title = "ESP Fuel",
        Type = "Checkbox",
        Default = false,
        Callback = function(val)
            _G.EspFuel = val
        end
    }
)
