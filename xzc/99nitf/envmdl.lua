local VisionModule = {}

-- Services
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

-- Public state variables
VisionModule.NoFogToggle = false
VisionModule.OriginalFogStart = Lighting.FogStart
VisionModule.OriginalFogEnd = Lighting.FogEnd

-- Store original parents and values
local originalParents = {
    Sky = nil,
    Bloom = nil,
    CampfireEffect = nil
}

local originalColorCorrectionParent = nil

local originalLightingValues = {
    Brightness = nil,
    Ambient = nil,
    OutdoorAmbient = nil,
    ShadowSoftness = nil,
    GlobalShadows = nil,
    Technology = nil
}

-- Store Original Parents Function
local function storeOriginalParents()
    local sky = Lighting:FindFirstChild("Sky")
    local bloom = Lighting:FindFirstChild("Bloom")
    local campfireEffect = Lighting:FindFirstChild("CampfireEffect")

    if sky and not originalParents.Sky then
        originalParents.Sky = sky.Parent
    end
    if bloom and not originalParents.Bloom then
        originalParents.Bloom = bloom.Parent
    end
    if campfireEffect and not originalParents.CampfireEffect then
        originalParents.CampfireEffect = campfireEffect.Parent
    end
end

-- Store Color Correction Parent Function
local function storeColorCorrectionParent()
    local colorCorrection = Lighting:FindFirstChild("ColorCorrection")
    if colorCorrection and not originalColorCorrectionParent then
        originalColorCorrectionParent = colorCorrection.Parent
    end
end

-- Store Original Lighting Function
local function storeOriginalLighting()
    if not originalLightingValues.Brightness then
        originalLightingValues.Brightness = Lighting.Brightness
        originalLightingValues.Ambient = Lighting.Ambient
        originalLightingValues.OutdoorAmbient = Lighting.OutdoorAmbient
        originalLightingValues.ShadowSoftness = Lighting.ShadowSoftness
        originalLightingValues.GlobalShadows = Lighting.GlobalShadows
        originalLightingValues.Technology = Lighting.Technology
    end
end

-- Initialize
Lighting.ClockTime = 14
Lighting.GlobalShadows = false
storeOriginalParents()
storeColorCorrectionParent()
storeOriginalLighting()

-- Create Vibrant Effect
local vibrantEffect = Lighting:FindFirstChild("VibrantEffect")
if not vibrantEffect then
    vibrantEffect = Instance.new("ColorCorrectionEffect")
    vibrantEffect.Name = "VibrantEffect"
    vibrantEffect.Saturation = 0.5
    vibrantEffect.Contrast = 0.2
    vibrantEffect.Brightness = 0.1
    vibrantEffect.Enabled = false
    vibrantEffect.Parent = Lighting
end

-- Disable Fog Function
function VisionModule.ToggleDisableFog(state)
    if state then
        local sky = Lighting:FindFirstChild("Sky")
        local bloom = Lighting:FindFirstChild("Bloom")
        local campfireEffect = Lighting:FindFirstChild("CampfireEffect")

        if sky then sky.Parent = nil end
        if bloom then bloom.Parent = nil end
        if campfireEffect then campfireEffect.Parent = nil end
    else
        local sky = game:FindFirstChild("Sky", true)
        local bloom = game:FindFirstChild("Bloom", true)
        local campfireEffect = game:FindFirstChild("CampfireEffect", true)

        if not sky then sky = Lighting:FindFirstChild("Sky") end
        if not bloom then bloom = Lighting:FindFirstChild("Bloom") end
        if not campfireEffect then campfireEffect = Lighting:FindFirstChild("CampfireEffect") end

        if sky then sky.Parent = originalParents.Sky or Lighting end
        if bloom then bloom.Parent = originalParents.Bloom or Lighting end
        if campfireEffect then campfireEffect.Parent = originalParents.CampfireEffect or Lighting end
    end
end

-- Disable Night Campfire Effect Function
function VisionModule.ToggleDisableNightCampfire(state)
    if state then
        local colorCorrection = Lighting:FindFirstChild("ColorCorrection")
        if colorCorrection then
            if not originalColorCorrectionParent then
                originalColorCorrectionParent = colorCorrection.Parent
            end
            colorCorrection.Parent = nil
        end
    else
        local colorCorrection = Lighting:FindFirstChild("ColorCorrection")
        if not colorCorrection then
            colorCorrection = game:FindFirstChild("ColorCorrection", true)
        end
        if colorCorrection then
            colorCorrection.Parent = Lighting
        end
    end
end

-- Full Bright Function
function VisionModule.ToggleFullBright(state)
    if state then
        Lighting.ClockTime = 14
        Lighting.Brightness = 2.2
        Lighting.Ambient = Color3.new(1, 1, 1)
        Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
        Lighting.ShadowSoftness = 0
        Lighting.GlobalShadows = false
        Lighting.Technology = Enum.Technology.Compatibility
    else
        Lighting.Brightness = originalLightingValues.Brightness
        Lighting.Ambient = originalLightingValues.Ambient
        Lighting.OutdoorAmbient = originalLightingValues.OutdoorAmbient
        Lighting.ShadowSoftness = originalLightingValues.ShadowSoftness
        Lighting.GlobalShadows = originalLightingValues.GlobalShadows
        Lighting.Technology = originalLightingValues.Technology
    end
end

-- No Fog Function
function VisionModule.ToggleNoFog(state)
    VisionModule.NoFogToggle = state

    if not state then
        Lighting.ClockTime = 14
        Lighting.GlobalShadows = false
        Lighting.FogStart = VisionModule.OriginalFogStart
        Lighting.FogEnd = VisionModule.OriginalFogEnd
    end
end

-- No Fog Heartbeat Connection
local noFogConnection
function VisionModule.StartNoFogLoop()
    if noFogConnection then return end
    
    noFogConnection = RunService.Heartbeat:Connect(function()
        if VisionModule.NoFogToggle then
            if Lighting.FogStart ~= 100000 or Lighting.FogEnd ~= 100000 then
                Lighting.ClockTime = 14
                Lighting.GlobalShadows = false
                Lighting.FogStart = 100000
                Lighting.FogEnd = 100000
            end
        end
    end)
end

-- Stop No Fog Loop
function VisionModule.StopNoFogLoop()
    if noFogConnection then
        noFogConnection:Disconnect()
        noFogConnection = nil
    end
end

-- Vibrant Colors Function
function VisionModule.ToggleVibrantColors(state)
    local effect = Lighting:FindFirstChild("VibrantEffect")
    
    if state then
        Lighting.ClockTime = 14
        Lighting.GlobalShadows = false
        Lighting.Ambient = Color3.fromRGB(180, 180, 180)
        Lighting.OutdoorAmbient = Color3.fromRGB(170, 170, 170)
        Lighting.ColorShift_Top = Color3.fromRGB(255, 230, 200)
        Lighting.ColorShift_Bottom = Color3.fromRGB(200, 240, 255)
        if effect then
            effect.Enabled = true
        end
    else
        if effect then
            effect.Enabled = false
        end
        Lighting.ClockTime = 14
        Lighting.GlobalShadows = false
        Lighting.Ambient = Color3.new(0, 0, 0)
        Lighting.OutdoorAmbient = Color3.new(0, 0, 0)
        Lighting.ColorShift_Top = Color3.new(0, 0, 0)
        Lighting.ColorShift_Bottom = Color3.new(0, 0, 0)
    end
end

-- Remove Gameplay Paused Function
function VisionModule.RemoveGameplayPaused()
    pcall(function()
        CoreGui.RobloxGui["CoreScripts/NetworkPause"]:Destroy()
    end)
end

-- Restore All Function
function VisionModule.RestoreAll()
    VisionModule.ToggleDisableFog(false)
    VisionModule.ToggleDisableNightCampfire(false)
    VisionModule.ToggleFullBright(false)
    VisionModule.ToggleNoFog(false)
    VisionModule.ToggleVibrantColors(false)
    VisionModule.StopNoFogLoop()
end

-- Auto-start the no fog loop
VisionModule.StartNoFogLoop()

return VisionModule
