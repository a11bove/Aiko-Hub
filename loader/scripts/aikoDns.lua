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

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Mc4121ban/Fluriore-UI/main/source.lua"))()

Library:MakeNotify({
    Title = "@aikoware",
    Description = "",
    Content = "Diesel 'N Steel Script Loaded!",
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

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local RunService = game:GetService("RunService")
local LocalPlayer = player
local Character = player.Character or player.CharacterAdded:Wait()

local autoKM_Running = false
local dupe_Running = false

local function autoFarmKm(state)
    autoKM_Running = state

    if state then
        task.spawn(function()
            while autoKM_Running and player.Character do
                local hum = player.Character:FindFirstChild("Humanoid")
                if hum and hum.SeatPart then
                    local car = hum.SeatPart.Parent

                    if car:FindFirstChild("Body") and car.Body:FindFirstChild("#Weight") then
                        car.PrimaryPart = car.Body["#Weight"]
                    end

                    local pos1 = Vector3.new(-6205.2983, 100, 8219.8535)
                    local pos2 = Vector3.new(-7594.5410, 100, 5130.9526)

                    repeat
                        task.wait()
                        car.PrimaryPart.Velocity = car.PrimaryPart.CFrame.LookVector * 550
                        car:PivotTo(CFrame.new(car.PrimaryPart.Position, pos1))
                    until not autoKM_Running or (player.Character.PrimaryPart.Position - pos1).Magnitude < 50

                    car.PrimaryPart.Velocity = Vector3.new()

                    repeat
                        task.wait()
                        car.PrimaryPart.Velocity = car.PrimaryPart.CFrame.LookVector * 550
                        car:PivotTo(CFrame.new(car.PrimaryPart.Position, pos2))
                    until not autoKM_Running or (player.Character.PrimaryPart.Position - pos2).Magnitude < 50

                    car.PrimaryPart.Velocity = Vector3.new()
                end

                task.wait(0.1)
            end
        end)
    end
end

local function activateExp()
    pcall(function()
        local ls = player:FindFirstChild("leaderstats")
        if ls and ls:FindFirstChild("Exp") then
            ls.Exp.Value = 82917
        end
    end)
end

local function duplicateCoin(state)
    dupe_Running = state

    local RS = ReplicatedStorage
    local WS = Workspace
    local Remotes = RS:WaitForChild("Remotes")
    local RecieveCoin = Remotes:WaitForChild("RecieveCoin")
    local Jeepnies = WS:WaitForChild("Jeepnies")

    if state then
        task.spawn(function()
            while dupe_Running do
                pcall(function()
                    local Jeep = Jeepnies:FindFirstChild(player.Name)
                    if Jeep then
                        local PV = Jeep:FindFirstChild("PassengerValues")
                        if PV then
                            RecieveCoin:FireServer({
                                PassengerValues = PV,
                                Password = 123456789,
                                Main = true,
                                Value = 300
                            })
                        end
                    end
                end)
                task.wait(0.01)
            end
        end)
    end
end

local BoostPower = 0
local BoostEnabled = false
local BoostConnection = nil

local function BoostLogic(dt)
    local success, err = pcall(function()
        if BoostPower <= 0 then return end
        local char = LocalPlayer.Character
        if not char then return end
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if not humanoid then return end
        local seat = humanoid.SeatPart
        if not seat or not seat:IsA("VehicleSeat") then return end
        
        local velocity = seat.AssemblyLinearVelocity
        if velocity and velocity.Magnitude > 0.5 then
            seat.AssemblyLinearVelocity = velocity + (velocity.Unit * BoostPower * dt)
        end
    end)
    
    if not success then
        warn("Booster Error:", err)
    end
end

local function EnableBoost()
    if BoostEnabled then return end
    BoostEnabled = true
    BoostConnection = RunService.Heartbeat:Connect(BoostLogic)
end

local function DisableBoost()
    if not BoostEnabled then return end
    BoostEnabled = false
    if BoostConnection then
        BoostConnection:Disconnect()
        BoostConnection = nil
    end
end

local function SetBoostPower(value)
    BoostPower = value
end

local function ResetBoostPower()
    BoostPower = 0
end

local main = Window:CreateTab({
    Name = "Main",
    Icon = "rbxassetid://10723407389"
})

local expsec = main:AddSection("Exploit")

expsec:AddParagraph({
    Title = "Tip:",
    Content = "Sobrahan niyo ng sukli para dalawang beses mag duplicate yung coins."
})

expsec:AddToggle({
    Title = "Manual Duplicate Coins",
    Content = "",
    Default = false,
    Callback = function(value)
        duplicateCoin(value)
    end
})

expsec:AddToggle({
    Title = "Auto Farm KM",
    Content = "",
    Default = false,
    Callback = function(value)
        autoFarmKm(value)
    end
})

--[[ local jep = main:AddSection("Jeepney")

jep:AddToggle({
    Title = "Booster",
    Content = "",
    Default = false,
    Callback = function(value)
        if value then
            EnableBoost()
        else
            DisableBoost()
        end
    end
})

jep:AddSlider({
    Title = "Booster Power",
    Content = "Adjust booster strength",
    Min = 0,
    Max = 300,
    Default = 0,
    Callback = function(value)
        SetBoostPower(value)
    end
})

jep:AddButton({
    Title = "Reset Booster",
    Content = "Reset booster power to 0",
    Callback = function()
        ResetBoostPower()
    end
}) ]]

local visec = main:AddSection("Visual")

visec:AddParagraph({
    Title = "Recommend:",
    Content = "Use the add exp if you're only going to buy something in talyer, then rejoin so your exp wont get reset if you bump into other jeeps or walls."
})

visec:AddButton({
    Title = "Add Exp",
    Content = "Visual but usable in talyer.",
    Callback = function()
        activateExp()
        Library:MakeNotify({
            Title = "@aikoware",
            Description = "",
            Content = "Exp Added!"
        })
    end
})

local info = Window:CreateTab({
    Name = "Information",
    Icon = "rbxassetid://10723415903"
})

local infosec = info:AddSection("Info")

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
            Description = "",
            Content = "Link Copied!"
        })
    end
})
