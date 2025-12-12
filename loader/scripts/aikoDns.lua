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

local function autoFarmKm(state)
    if state then
        task.spawn(function()
            while state and player.Character do
                local hum = player.Character:FindFirstChild("Humanoid")
                if hum and hum.SeatPart then
                    local car = hum.SeatPart.Parent
                    if car.Body:FindFirstChild("#Weight") then
                        car.PrimaryPart = car.Body["#Weight"]
                    end

                    local pos1 = Vector3.new(-6205.2983, 100, 8219.8535)
                    local pos2 = Vector3.new(-7594.5410, 100, 5130.9526)

                    repeat
                        task.wait()
                        car.PrimaryPart.Velocity = car.PrimaryPart.CFrame.LookVector * 550
                        car:PivotTo(CFrame.new(car.PrimaryPart.Position, pos1))
                    until not state or (player.Character.PrimaryPart.Position - pos1).Magnitude < 50

                    car.PrimaryPart.Velocity = Vector3.new()

                    repeat
                        task.wait()
                        car.PrimaryPart.Velocity = car.PrimaryPart.CFrame.LookVector * 550
                        car:PivotTo(CFrame.new(car.PrimaryPart.Position, pos2))
                    until not state or (player.Character.PrimaryPart.Position - pos2).Magnitude < 50

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
            ls.Exp.Value = 47823
        end
    end)
end

local function duplicateCoin(state)
    local RS = ReplicatedStorage
    local WS = Workspace
    local Remotes = RS:WaitForChild("Remotes")
    local RecieveCoin = Remotes:WaitForChild("RecieveCoin")
    local Jeepnies = WS:WaitForChild("Jeepnies")
    local Player = Players.LocalPlayer
    if state then
        spawn(function()
            while state do
                pcall(function()
                    local Jeep = Jeepnies:FindFirstChild(Player.Name)
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

local Library = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/x2zu/OPEN-SOURCE-UI-ROBLOX/refs/heads/main/X2ZU%20UI%20ROBLOX%20OPEN%20SOURCE/DummyUi-leak-by-x2zu/fetching-main/Tools/Framework.luau"
))()

local Window = Library:Window({
    Title = "@aiko",
    Desc = "Made by untog ;p",
    Icon = 140356301069419,
    Theme = "Dark",
    Config = {
        Keybind = Enum.KeyCode.LeftControl,
        Size = UDim2.new(0, 400, 0, 300)
    },
    CloseUIButton = {Enabled = true, Text = "AIKO"}
})

local Tab = Window:Tab({Title = "Main", Icon = "house"})

Tab:Toggle({
    Title = "Duplicate Coin",
    Value = false,
    Callback = function(v)
        duplicateCoin(v)
    end
})

Tab:Toggle({
    Title = "Auto Farm KM",
    Value = false,
    Callback = function(v)
        autoFarmKm(v)
    end
})

Tab:Button({
    Title = "Add Exp",
    Desc = "Visual but usable in talyer.",
    Callback = function()
        activateExp()
    end
})
