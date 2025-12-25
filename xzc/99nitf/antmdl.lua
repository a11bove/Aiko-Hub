local AntiModule = {}

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

-- Get LocalPlayer
local LocalPlayer = Players.LocalPlayer

-- Public state variables
AntiModule.ESCAPE_DISTANCE_OWL = 80
AntiModule.ESCAPE_SPEED_OWL = 5

AntiModule.ESCAPE_DISTANCE_DEER = 60
AntiModule.ESCAPE_SPEED_DEER = 4

AntiModule.ESCAPE_DISTANCE_RAM = 65
AntiModule.ESCAPE_SPEED_RAM = 4.5

-- Private loop connections
local torchLoop = nil
local escapeLoopOwl = nil
local escapeLoopDeer = nil
local escapeLoopRam = nil

-- Auto Stun Deer Function
function AntiModule.ToggleAutoStunDeer(state)
    if state then
        torchLoop = RunService.RenderStepped:Connect(function()
            pcall(function()
                local remote = ReplicatedStorage:FindFirstChild("RemoteEvents")
                    and ReplicatedStorage.RemoteEvents:FindFirstChild("DeerHitByTorch")
                local deer = Workspace:FindFirstChild("Characters")
                    and Workspace.Characters:FindFirstChild("Deer")
                if remote and deer then
                    remote:InvokeServer(deer)
                end
            end)
            task.wait(0.1)
        end)
    else
        if torchLoop then
            torchLoop:Disconnect()
            torchLoop = nil
        end
    end
end

-- Auto Escape From Owl Function
function AntiModule.ToggleAutoEscapeOwl(state)
    if state then
        escapeLoopOwl = RunService.RenderStepped:Connect(function()
            pcall(function()
                local character = LocalPlayer.Character
                if not character then return end
                
                local HumanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                if not HumanoidRootPart then return end
                
                local owl = Workspace:FindFirstChild("Characters") 
                    and Workspace.Characters:FindFirstChild("Owl")
                    
                if owl and owl:FindFirstChild("HumanoidRootPart") then
                    local myPos = HumanoidRootPart.Position
                    local owlPos = owl.HumanoidRootPart.Position
                    local distance = (myPos - owlPos).Magnitude

                    if distance < AntiModule.ESCAPE_DISTANCE_OWL then
                        local direction = (myPos - owlPos).Unit
                        HumanoidRootPart.CFrame = HumanoidRootPart.CFrame + direction * AntiModule.ESCAPE_SPEED_OWL
                    end
                end
            end)
        end)
    else
        if escapeLoopOwl then
            escapeLoopOwl:Disconnect()
            escapeLoopOwl = nil
        end
    end
end

-- Auto Escape From Deer Function
function AntiModule.ToggleAutoEscapeDeer(state)
    if state then
        escapeLoopDeer = RunService.RenderStepped:Connect(function()
            pcall(function()
                local character = LocalPlayer.Character
                if not character then return end
                
                local HumanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                if not HumanoidRootPart then return end
                
                local deer = Workspace:FindFirstChild("Characters") 
                    and Workspace.Characters:FindFirstChild("Deer")
                    
                if deer and deer:FindFirstChild("HumanoidRootPart") then
                    local myPos = HumanoidRootPart.Position
                    local deerPos = deer.HumanoidRootPart.Position
                    local distance = (myPos - deerPos).Magnitude

                    if distance < AntiModule.ESCAPE_DISTANCE_DEER then
                        local direction = (myPos - deerPos).Unit
                        HumanoidRootPart.CFrame = HumanoidRootPart.CFrame + direction * AntiModule.ESCAPE_SPEED_DEER
                    end
                end
            end)
        end)
    else
        if escapeLoopDeer then
            escapeLoopDeer:Disconnect()
            escapeLoopDeer = nil
        end
    end
end

-- Auto Escape From Ram Function
function AntiModule.ToggleAutoEscapeRam(state)
    if state then
        escapeLoopRam = RunService.RenderStepped:Connect(function()
            pcall(function()
                local character = LocalPlayer.Character
                if not character then return end
                
                local HumanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                if not HumanoidRootPart then return end
                
                local ram = Workspace:FindFirstChild("Characters") 
                    and Workspace.Characters:FindFirstChild("Ram")
                    
                if ram and ram:FindFirstChild("HumanoidRootPart") then
                    local myPos = HumanoidRootPart.Position
                    local ramPos = ram.HumanoidRootPart.Position
                    local distance = (myPos - ramPos).Magnitude

                    if distance < AntiModule.ESCAPE_DISTANCE_RAM then
                        local direction = (myPos - ramPos).Unit
                        HumanoidRootPart.CFrame = HumanoidRootPart.CFrame + direction * AntiModule.ESCAPE_SPEED_RAM
                    end
                end
            end)
        end)
    else
        if escapeLoopRam then
            escapeLoopRam:Disconnect()
            escapeLoopRam = nil
        end
    end
end

-- Set Escape Distance for Entity
function AntiModule.SetEscapeDistance(entity, distance)
    if entity == "Owl" then
        AntiModule.ESCAPE_DISTANCE_OWL = distance
    elseif entity == "Deer" then
        AntiModule.ESCAPE_DISTANCE_DEER = distance
    elseif entity == "Ram" then
        AntiModule.ESCAPE_DISTANCE_RAM = distance
    end
end

-- Set Escape Speed for Entity
function AntiModule.SetEscapeSpeed(entity, speed)
    if entity == "Owl" then
        AntiModule.ESCAPE_SPEED_OWL = speed
    elseif entity == "Deer" then
        AntiModule.ESCAPE_SPEED_DEER = speed
    elseif entity == "Ram" then
        AntiModule.ESCAPE_SPEED_RAM = speed
    end
end

-- Check if Auto Stun Deer is Active
function AntiModule.IsAutoStunDeerActive()
    return torchLoop ~= nil
end

-- Check if Auto Escape is Active
function AntiModule.IsAutoEscapeActive(entity)
    if entity == "Owl" then
        return escapeLoopOwl ~= nil
    elseif entity == "Deer" then
        return escapeLoopDeer ~= nil
    elseif entity == "Ram" then
        return escapeLoopRam ~= nil
    end
    return false
end

-- Stop All Anti Features
function AntiModule.StopAll()
    AntiModule.ToggleAutoStunDeer(false)
    AntiModule.ToggleAutoEscapeOwl(false)
    AntiModule.ToggleAutoEscapeDeer(false)
    AntiModule.ToggleAutoEscapeRam(false)
end

-- Cleanup Function
function AntiModule.Cleanup()
    AntiModule.StopAll()
end

return AntiModule
