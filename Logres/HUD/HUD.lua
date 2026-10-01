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

local CAST_EVENTS = {
    "UNIT_SPELLCAST_START",
    "UNIT_SPELLCAST_STOP",
    "UNIT_SPELLCAST_FAILED",
    "UNIT_SPELLCAST_FAILED_QUIET",
    "UNIT_SPELLCAST_INTERRUPTED",
    "UNIT_SPELLCAST_CHANNEL_START",
    "UNIT_SPELLCAST_CHANNEL_STOP",
}

local function createCastCue(parent, name)
    local cue = CreateFrame("Frame", name, parent)
    cue:SetSize(18, 18)
    cue:Hide()

    local border = cue:CreateTexture(nil, "OVERLAY")
    border:SetAllPoints(cue)
    border:SetColorTexture(0.04, 0.03, 0.02, 0.92)

    local inner = cue:CreateTexture(nil, "OVERLAY")
    inner:SetPoint("TOPLEFT", cue, "TOPLEFT", 3, -3)
    inner:SetPoint("BOTTOMRIGHT", cue, "BOTTOMRIGHT", -3, 3)

    local core = cue:CreateTexture(nil, "OVERLAY")
    core:SetSize(4, 4)
    core:SetPoint("CENTER", cue, "CENTER", 0, 0)

    cue.border = border
    cue.inner = inner
    cue.core = core
    cue.generation = 0
    cue.terminalHold = false

    return cue
end

local function styleCastCue(cue, state, scope)
    if state == "channel" then
        if scope == "player" then
            cue.inner:SetColorTexture(0.18, 0.55, 0.82, 0.95)
            cue.core:SetColorTexture(0.72, 0.88, 1.00, 1.00)
        else
            cue.inner:SetColorTexture(0.42, 0.30, 0.72, 0.95)
            cue.core:SetColorTexture(0.82, 0.72, 1.00, 1.00)
        end
        return
    end

    if state == "interrupted" then
        cue.inner:SetColorTexture(0.68, 0.04, 0.025, 1.00)
        cue.core:SetColorTexture(1.00, 0.42, 0.22, 1.00)
        return
    end

    if scope == "player" then
        cue.inner:SetColorTexture(0.70, 0.48, 0.12, 0.95)
        cue.core:SetColorTexture(1.00, 0.85, 0.42, 1.00)
    else
        cue.inner:SetColorTexture(0.68, 0.28, 0.08, 0.95)
        cue.core:SetColorTexture(1.00, 0.66, 0.28, 1.00)
    end
end

local function showCastCue(cue, state, scope)
    cue.generation = cue.generation + 1
    cue.terminalHold = false
    styleCastCue(cue, state, scope)
    cue:Show()
end

local function hideCastCue(cue, force)
    if cue.terminalHold and not force then
        return
    end

    cue.generation = cue.generation + 1
    cue.terminalHold = false
    cue:Hide()
end

local function interruptCastCue(cue, scope)
    cue.generation = cue.generation + 1
    local generation = cue.generation

    cue.terminalHold = true
    styleCastCue(cue, "interrupted", scope)
    cue:Show()

    C_Timer.After(0.18, function()
        if cue.generation ~= generation then
            return
        end

        cue.terminalHold = false
        cue:Hide()
    end)
end

local function handleCastEvent(cue, event, scope)
    if event == "UNIT_SPELLCAST_START" then
        showCastCue(cue, "cast", scope)
        return
    end

    if event == "UNIT_SPELLCAST_CHANNEL_START" then
        showCastCue(cue, "channel", scope)
        return
    end

    if event == "UNIT_SPELLCAST_INTERRUPTED"
        or event == "UNIT_SPELLCAST_FAILED"
    then
        interruptCastCue(cue, scope)
        return
    end

    hideCastCue(cue, false)
end

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
        self.percentScaleCurve
    )

    self.resourceText:SetFormattedText("%.0f%%", percent)
end


function HUD:UpdateTarget()
    if not self.root or not self.root:IsShown() then
        return
    end

    if not UnitExists("target") then
        self.targetFrame:Hide()
        return
    end

    -- Target identity can become secret under unit-identity restrictions.
    -- Forward it directly to the native FontString consumer. Do not inspect,
    -- concatenate, stringify, or branch on the returned name in Lua.
    self.targetNameText:SetText(UnitName("target"))

    -- Target health is secret-capable. Scale it to 0-100 inside the native
    -- curve system and forward the result directly to SetFormattedText.
    local percent = UnitHealthPercent(
        "target",
        true,
        self.percentScaleCurve
    )

    self.targetHealthText:SetFormattedText("%.0f%%", percent)
    self.targetFrame:Show()
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
        self:UpdateTarget()
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
        resourceCurveReady = self.percentScaleCurve ~= nil,
        targetFrameReady = self.targetFrame ~= nil,
        targetNameTextReady = self.targetNameText ~= nil,
        targetHealthTextReady = self.targetHealthText ~= nil,
        targetEventFrameReady = self.targetEventFrame ~= nil,
        playerCastCueReady = self.playerCastCue ~= nil,
        targetCastCueReady = self.targetCastCue ~= nil,
        playerCastEventFrameReady = self.playerCastEventFrame ~= nil,
        targetCastEventFrameReady = self.targetCastEventFrame ~= nil,
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

    self.percentScaleCurve = createScaleTo100Curve()

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

    local targetFrame = CreateFrame("Frame", "LogresHUDTarget", root)
    targetFrame:SetSize(260, 54)
    targetFrame:SetPoint("CENTER", root, "CENTER", 0, -54)
    targetFrame:Hide()

    local targetNameText = targetFrame:CreateFontString(
        "LogresHUDTargetName",
        "OVERLAY",
        "GameFontNormal"
    )
    targetNameText:SetPoint("TOP", targetFrame, "TOP", 0, 0)
    targetNameText:SetTextColor(0.88, 0.83, 0.74, 0.95)
    targetNameText:SetShadowColor(0, 0, 0, 0.85)
    targetNameText:SetShadowOffset(1, -1)
    targetNameText:SetJustifyH("CENTER")
    targetNameText:SetWidth(250)

    local targetHealthText = targetFrame:CreateFontString(
        "LogresHUDTargetHealthText",
        "OVERLAY",
        "GameFontNormalLarge"
    )
    targetHealthText:SetPoint("TOP", targetNameText, "BOTTOM", 0, -2)
    targetHealthText:SetTextColor(0.76, 0.72, 0.66, 0.95)
    targetHealthText:SetShadowColor(0, 0, 0, 0.85)
    targetHealthText:SetShadowOffset(1, -1)
    targetHealthText:SetJustifyH("CENTER")

    self.targetFrame = targetFrame
    self.targetNameText = targetNameText
    self.targetHealthText = targetHealthText

    local playerCastCue = createCastCue(root, "LogresHUDPlayerCastCue")
    playerCastCue:SetPoint("RIGHT", resourceText, "LEFT", -12, 0)

    local targetCastCue = createCastCue(
        targetFrame,
        "LogresHUDTargetCastCue"
    )
    targetCastCue:SetPoint("LEFT", targetFrame, "RIGHT", 8, 8)

    self.playerCastCue = playerCastCue
    self.targetCastCue = targetCastCue

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

    local targetEventFrame = CreateFrame("Frame")
    targetEventFrame:SetScript("OnEvent", function(_, _, unit)
        if unit and unit ~= "target" then
            return
        end

        self:UpdateTarget()
    end)

    self.targetEventFrame = targetEventFrame

    local playerCastEventFrame = CreateFrame("Frame")
    playerCastEventFrame:SetScript("OnEvent", function(_, event)
        -- The frame is unit-filtered for "player"; spellcast payload fields
        -- are intentionally ignored.
        handleCastEvent(self.playerCastCue, event, "player")
    end)

    local targetCastEventFrame = CreateFrame("Frame")
    targetCastEventFrame:SetScript("OnEvent", function(_, event)
        if event == "PLAYER_TARGET_CHANGED" then
            hideCastCue(self.targetCastCue, true)
            return
        end

        -- Target spellcast payload fields may be secret on Forever.
        -- The frame is unit-filtered for "target", so Logres consumes only
        -- the ordinary event type and never inspects castGUID/spellID/etc.
        handleCastEvent(self.targetCastCue, event, "target")
    end)

    self.playerCastEventFrame = playerCastEventFrame
    self.targetCastEventFrame = targetCastEventFrame
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

    self.targetEventFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
    self.targetEventFrame:RegisterUnitEvent("UNIT_HEALTH", "target")
    self.targetEventFrame:RegisterUnitEvent("UNIT_MAXHEALTH", "target")
    self.targetEventFrame:RegisterUnitEvent("UNIT_NAME_UPDATE", "target")

    for index = 1, #CAST_EVENTS do
        local event = CAST_EVENTS[index]
        self.playerCastEventFrame:RegisterUnitEvent(event, "player")
        self.targetCastEventFrame:RegisterUnitEvent(event, "target")
    end

    self.targetCastEventFrame:RegisterEvent("PLAYER_TARGET_CHANGED")

    self:OwnCleanup(function()
        self.healthEventFrame:UnregisterAllEvents()
        self.resourceEventFrame:UnregisterAllEvents()
        self.targetEventFrame:UnregisterAllEvents()
        self.playerCastEventFrame:UnregisterAllEvents()
        self.targetCastEventFrame:UnregisterAllEvents()
    end)

    self:SubscribePreferences(function(current)
        self:ApplyImmersionPreference(current)
    end)

    self:ApplyImmersionPreference(Logres:GetPreferences())
end

function HUD:OnDisable()
    self.previewEnabled = false
    hideCastCue(self.playerCastCue, true)
    hideCastCue(self.targetCastCue, true)
    self.targetFrame:Hide()
    self.root:Hide()
end
