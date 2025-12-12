if not game:IsLoaded() then
    game.Loaded:Wait()
end

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "@aiko",
    Text = "Diesel 'N Steel Script Loaded!",
    Icon = "rbxassetid://140356301069419",
    Duration = 2
})

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer

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

local Fluent = loadstring(game:HttpGet("https://raw.githubusercontent.com/discoart/FluentPlus/refs/heads/main/Beta.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "@aiko",
    SubTitle = "made by untog !",
    Search = false,
    Icon = "rbxassetid://140356301069419",
    TabWidth = 120,
    Size = UDim2.fromOffset(420, 320),
    Acrylic = false,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl,
    UserInfo = false,
})

local Tabs = {
    Main = Window:AddTab({ Title = "Main",  Icon = "star" }),
}

local Minimizer = Fluent:CreateMinimizer({
    Icon = "rbxassetid://140356301069419",
    Size = UDim2.fromOffset(44, 44),
    Position = UDim2.new(0, 320, 0, 24),
    Acrylic = true,
    Corner = 10,
    Transparency = 1,
    Draggable = true,
    Visible = true
})

local Options = Fluent.Options

do

    local DupeToggle = Tabs.Main:AddToggle("dupeCoin", {
        Title = "Duplicate Coin",
        Default = false
    })

    DupeToggle:OnChanged(function(value)
        duplicateCoin(value)
    end)

    local KmToggle = Tabs.Main:AddToggle("autoKM", {
        Title = "Auto KM Farm",
        Default = false
    })

    KmToggle:OnChanged(function(value)
        autoFarmKm(value)
    end)
end

    Tabs.Main:AddButton({
        Title = "Add Exp",
        Description = "Visual but usable in talyer.",
        Callback = function()
            activateExp()
        end
    })
