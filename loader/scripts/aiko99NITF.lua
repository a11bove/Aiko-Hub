repeat task.wait() until game:IsLoaded()

local settings = {
    playerGui = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui"),
    interface = nil,
    fishingCatchFrame = nil,
    timingBar = nil,
    successArea = nil
}

settings.interface = settings.playerGui and settings.playerGui:FindFirstChild("Interface")
settings.fishingCatchFrame = settings.interface and settings.interface:FindFirstChild("FishingCatchFrame")
settings.timingBar = settings.fishingCatchFrame and settings.fishingCatchFrame:FindFirstChild("TimingBar")
settings.successArea = settings.timingBar and settings.timingBar:FindFirstChild("SuccessArea")

if settings.successArea then
    settings.successArea:GetPropertyChangedSignal("Size"):Connect(function()
        settings.successArea.Position = UDim2.new(0.5, 0, 0, 0)
        settings.successArea.Size = UDim2.new(1, 0, 1, 0)
        end)
end

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local rs = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Lighting = game:GetService("Lighting")
local effect = Lighting:FindFirstChild("VibrantEffect")
local vibrantEffect = Lighting:FindFirstChild("VibrantEffect")
local RunService = game:GetService("RunService")

loadstring(game:HttpGet("https://raw.githubusercontent.com/a11bove/Aiko-Hub/refs/heads/main/nitf/ui.lua"))()
