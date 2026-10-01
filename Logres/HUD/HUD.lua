local _, Logres = ...

local HUD = Logres:RegisterModule("HUD", {
    autoEnable = true,
})

local HEALTH_BANDS = {
    {
        name = "outerDark",
        inset = 0,
        thickness = 56,
        color = { 0.00, 0.00, 0.00 },
        previewAlpha = 0.18,
        points = {
            { 0.00, 0.46 },
            { 0.15, 0.38 },
            { 0.30, 0.28 },
            { 0.50, 0.16 },
            { 0.60, 0.08 },
            { 0.70, 0.00 },
            { 1.00, 0.00 },
        },
    },
    {
        name = "injuryRed",
        inset = 18,
        thickness = 96,
        color = { 0.45, 0.015, 0.01 },
        previewAlpha = 0.16,
        points = {
            { 0.00, 0.38 },
            { 0.15, 0.30 },
            { 0.30, 0.18 },
            { 0.40, 0.09 },
            { 0.50, 0.00 },
            { 1.00, 0.00 },
        },
    },
    {
        name = "criticalPressure",
        inset = 48,
        thickness = 156,
        color = { 0.25, 0.00, 0.00 },
        previewAlpha = 0.12,
        points = {
            { 0.00, 0.32 },
            { 0.08, 0.26 },
            { 0.15, 0.18 },
            { 0.22, 0.09 },
            { 0.30, 0.00 },
            { 1.00, 0.00 },
        },
    },
    {
        name = "nearDeathTunnel",
        inset = 96,
        thickness = 238,
        color = { 0.05, 0.00, 0.00 },
        previewAlpha = 0.10,
        points = {
            { 0.00, 0.35 },
            { 0.05, 0.28 },
            { 0.10, 0.16 },
            { 0.15, 0.00 },
            { 1.00, 0.00 },
        },
    },
}

local function createCurve(points)
    local curve = C_CurveUtil.CreateCurve()
    curve:SetType(Enum.LuaCurveType.Linear)

    for index = 1, #points do
        local point = points[index]
        curve:AddPoint(point[1], point[2])
    end

    return curve
end

local function createScaleTo100Curve()
    local curve = C_CurveUtil.CreateCurve()
    curve:SetType(Enum.LuaCurveType.Linear)
    curve:AddPoint(0.0, 0)
    curve:AddPoint(1.0, 100)
    return curve
end

local function createEdgeTextures(root, band)
    local textures = {}
    local r, g, b = band.color[1], band.color[2], band.color[3]
    local inset = band.inset
    local thickness = band.thickness

    local left = root:CreateTexture(nil, "BACKGROUND")
    left:SetColorTexture(r, g, b, 1)
    left:SetPoint("TOPLEFT", root, "TOPLEFT", inset, -inset)
    left:SetPoint("BOTTOMLEFT", root, "BOTTOMLEFT", inset, inset)
    left:SetWidth(thickness)
    textures[#textures + 1] = left

    local right = root:CreateTexture(nil, "BACKGROUND")
    right:SetColorTexture(r, g, b, 1)
    right:SetPoint("TOPRIGHT", root, "TOPRIGHT", -inset, -inset)
    right:SetPoint("BOTTOMRIGHT", root, "BOTTOMRIGHT", -inset, inset)
    right:SetWidth(thickness)
    textures[#textures + 1] = right

    local top = root:CreateTexture(nil, "BACKGROUND")
    top:SetColorTexture(r, g, b, 1)
    top:SetPoint("TOPLEFT", root, "TOPLEFT", inset, -inset)
    top:SetPoint("TOPRIGHT", root, "TOPRIGHT", -inset, -inset)
    top:SetHeight(thickness)
    textures[#textures + 1] = top

    local bottom = root:CreateTexture(nil, "BACKGROUND")
    bottom:SetColorTexture(r, g, b, 1)
    bottom:SetPoint("BOTTOMLEFT", root, "BOTTOMLEFT", inset, inset)
    bottom:SetPoint("BOTTOMRIGHT", root, "BOTTOMRIGHT", -inset, inset)
    bottom:SetHeight(thickness)
    textures[#textures + 1] = bottom

    for index = 1, #textures do
        textures[index]:SetAlpha(0)
    end

    return textures
end

function HUD:ApplyPreview()
    for index = 1, #self.healthBands do
        local band = self.healthBands[index]

        for textureIndex = 1, #band.textures do
            band.textures[textureIndex]:SetAlpha(band.previewAlpha)
        end
    end
end

function HUD:SetPreviewEnabled(enabled)
    self.previewEnabled = enabled and true or false

    if not self.root or not self.root:IsShown() then
        return
    end

    if self.previewEnabled then
        self:ApplyPreview()
    else
        self:UpdateHealthVignette()
    end
end

function HUD:UpdateHealthVignette()
    if not self.root or not self.root:IsShown() or self.previewEnabled then
        return
    end

    for index = 1, #self.healthBands do
        local band = self.healthBands[index]

        -- Player health is secret-capable on Forever. The curve is evaluated
        -- by the native UI system and the resulting secret value is passed
        -- directly to Texture:SetAlpha. Never branch, compare, stringify,
        -- persist, or perform arithmetic on this value in Lua.
        local alpha = UnitHealthPercent("player", true, band.curve)

        for textureIndex = 1, #band.textures do
            band.textures[textureIndex]:SetAlpha(alpha)
        end
    end
end


function HUD:UpdateResource()
    if not self.root or not self.root:IsShown() then
        return
    end

    -- Primary player power may be secret on Forever. Scale it to 0-100
    -- inside the native curve system and pass the resulting secret number
    -- directly to SetFormattedText. Never perform arithmetic, comparison,
    -- tostring/string.format, or persistence on the value in Lua.
    local percent = UnitPowerPercent(
        "player",
        nil,
        false,
        self.resourceScaleCurve
    )

    self.resourceText:SetFormattedText("%.0f%%", percent)
end

function HUD:ApplyImmersionPreference(preferences)
    if preferences.immersionEnabled then
        self.root:Show()

        if self.previewEnabled then
            self:ApplyPreview()
        else
            self:UpdateHealthVignette()
        end

        self:UpdateResource()
    else
        self.root:Hide()
    end
end

function HUD:GetDebugStatus()
    local preferences = Logres:GetPreferences()

    return {
        moduleEnabled = self:IsEnabled(),
        rootShown = self.root and self.root:IsShown() or false,
        immersionEnabled = preferences.immersionEnabled,
        previewEnabled = self.previewEnabled and true or false,
        bandCount = self.healthBands and #self.healthBands or 0,
        textureCount = self.healthTextureCount or 0,
        curvesReady = self.curvesReady and true or false,
        resourceTextReady = self.resourceText ~= nil,
        resourceCurveReady = self.resourceScaleCurve ~= nil,
    }
end

function HUD:OnInitialize()
    local root = CreateFrame("Frame", "LogresHUDRoot", UIParent)
    root:SetAllPoints(UIParent)
    root:SetFrameStrata("HIGH")
    root:EnableMouse(false)
    root:Hide()

    self.root = root
    self.previewEnabled = false
    self.healthBands = {}
    self.healthTextureCount = 0

    for index = 1, #HEALTH_BANDS do
        local spec = HEALTH_BANDS[index]
        local band = {
            name = spec.name,
            previewAlpha = spec.previewAlpha,
            curve = createCurve(spec.points),
            textures = createEdgeTextures(root, spec),
        }

        self.healthTextureCount =
            self.healthTextureCount + #band.textures

        self.healthBands[#self.healthBands + 1] = band
    end

    self.curvesReady = #self.healthBands == #HEALTH_BANDS

    self.resourceScaleCurve = createScaleTo100Curve()

    local resourceText = root:CreateFontString(
        "LogresHUDResourceText",
        "OVERLAY",
        "GameFontNormalLarge"
    )
    resourceText:SetPoint("CENTER", root, "CENTER", 0, -118)
    resourceText:SetTextColor(0.82, 0.78, 0.68, 0.92)
    resourceText:SetShadowColor(0, 0, 0, 0.85)
    resourceText:SetShadowOffset(1, -1)
    resourceText:SetJustifyH("CENTER")
    resourceText:ClearText()

    self.resourceText = resourceText

    local healthEventFrame = CreateFrame("Frame")
    healthEventFrame:SetScript("OnEvent", function(_, _, unit)
        if unit and unit ~= "player" then
            return
        end

        self:UpdateHealthVignette()
    end)

    self.healthEventFrame = healthEventFrame

    local resourceEventFrame = CreateFrame("Frame")
    resourceEventFrame:SetScript("OnEvent", function(_, _, unit)
        if unit and unit ~= "player" then
            return
        end

        self:UpdateResource()
    end)

    self.resourceEventFrame = resourceEventFrame
end

function HUD:OnEnable()
    self.healthEventFrame:RegisterUnitEvent("UNIT_HEALTH", "player")
    self.healthEventFrame:RegisterUnitEvent("UNIT_MAXHEALTH", "player")

    self.resourceEventFrame:RegisterUnitEvent(
        "UNIT_POWER_FREQUENT",
        "player"
    )
    self.resourceEventFrame:RegisterUnitEvent(
        "UNIT_MAXPOWER",
        "player"
    )

    self:OwnCleanup(function()
        self.healthEventFrame:UnregisterAllEvents()
        self.resourceEventFrame:UnregisterAllEvents()
    end)

    self:SubscribePreferences(function(current)
        self:ApplyImmersionPreference(current)
    end)

    self:ApplyImmersionPreference(Logres:GetPreferences())
end

function HUD:OnDisable()
    self.previewEnabled = false
    self.root:Hide()
end
