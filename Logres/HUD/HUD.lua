local _, Logres = ...

local HUD = Logres:RegisterModule("HUD", {
    autoEnable = true,
})

local HEALTH_BANDS = {
    {
        name = "outerDark",
        inset = 0,
        thickness = 52,
        color = { 0.02, 0.01, 0.01 },
        points = {
            { 0.00, 0.30 },
            { 0.15, 0.23 },
            { 0.30, 0.16 },
            { 0.50, 0.08 },
            { 0.70, 0.00 },
            { 1.00, 0.00 },
        },
    },
    {
        name = "injuryRed",
        inset = 18,
        thickness = 92,
        color = { 0.22, 0.01, 0.01 },
        points = {
            { 0.00, 0.24 },
            { 0.15, 0.16 },
            { 0.30, 0.08 },
            { 0.50, 0.00 },
            { 1.00, 0.00 },
        },
    },
    {
        name = "criticalPressure",
        inset = 48,
        thickness = 150,
        color = { 0.16, 0.00, 0.00 },
        points = {
            { 0.00, 0.16 },
            { 0.15, 0.06 },
            { 0.30, 0.00 },
            { 1.00, 0.00 },
        },
    },
    {
        name = "nearDeathTunnel",
        inset = 96,
        thickness = 230,
        color = { 0.08, 0.00, 0.00 },
        points = {
            { 0.00, 0.18 },
            { 0.08, 0.10 },
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

function HUD:UpdateHealthVignette()
    if not self.root or not self.root:IsShown() then
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

function HUD:ApplyImmersionPreference(preferences)
    if preferences.immersionEnabled then
        self.root:Show()
        self:UpdateHealthVignette()
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
        bandCount = self.healthBands and #self.healthBands or 0,
        textureCount = self.healthTextureCount or 0,
        curvesReady = self.curvesReady and true or false,
    }
end

function HUD:OnInitialize()
    local root = CreateFrame("Frame", "LogresHUDRoot", UIParent)
    root:SetAllPoints(UIParent)
    root:SetFrameStrata("HIGH")
    root:EnableMouse(false)
    root:Hide()

    self.root = root
    self.healthBands = {}
    self.healthTextureCount = 0

    for index = 1, #HEALTH_BANDS do
        local spec = HEALTH_BANDS[index]
        local band = {
            name = spec.name,
            curve = createCurve(spec.points),
            textures = createEdgeTextures(root, spec),
        }

        self.healthTextureCount =
            self.healthTextureCount + #band.textures

        self.healthBands[#self.healthBands + 1] = band
    end

    self.curvesReady = #self.healthBands == #HEALTH_BANDS

    local healthEventFrame = CreateFrame("Frame")
    healthEventFrame:SetScript("OnEvent", function(_, _, unit)
        if unit and unit ~= "player" then
            return
        end

        self:UpdateHealthVignette()
    end)

    self.healthEventFrame = healthEventFrame
end

function HUD:OnEnable()
    self.healthEventFrame:RegisterUnitEvent("UNIT_HEALTH", "player")
    self.healthEventFrame:RegisterUnitEvent("UNIT_MAXHEALTH", "player")

    self:OwnCleanup(function()
        self.healthEventFrame:UnregisterAllEvents()
    end)

    self:SubscribePreferences(function(current)
        self:ApplyImmersionPreference(current)
    end)

    self:ApplyImmersionPreference(Logres:GetPreferences())
end

function HUD:OnDisable()
    self.root:Hide()
end
