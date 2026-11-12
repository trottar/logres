local _, Logres = ...

local HUD = Logres:RegisterModule("HUD", {
    autoEnable = true,
})

local HEALTH_PREVIEW_PERCENTAGES = {
    [100] = true,
    [80] = true,
    [70] = true,
    [60] = true,
    [50] = true,
    [40] = true,
    [30] = true,
    [20] = true,
    [15] = true,
    [5] = true,
    [0] = true,
}

local HEALTH_BANDS = {
    {
        name = "outerDark",
        assetKey = "outer",
        fallbackColor = { 0.040, 0.035, 0.045, 1.00 },
        points = {
            { 0.00, 0.92 },
            { 0.05, 0.90 },
            { 0.15, 0.82 },
            { 0.20, 0.74 },
            { 0.30, 0.62 },
            { 0.40, 0.48 },
            { 0.50, 0.34 },
            { 0.60, 0.24 },
            { 0.70, 0.15 },
            { 0.80, 0.08 },
            { 1.00, 0.00 },
        },
    },
    {
        name = "injuryRed",
        assetKey = "injury",
        fallbackColor = { 0.31, 0.035, 0.065, 1.00 },
        points = {
            { 0.00, 0.72 },
            { 0.05, 0.70 },
            { 0.15, 0.62 },
            { 0.20, 0.54 },
            { 0.30, 0.42 },
            { 0.40, 0.28 },
            { 0.50, 0.16 },
            { 0.60, 0.08 },
            { 0.70, 0.00 },
            { 1.00, 0.00 },
        },
    },
    {
        name = "criticalPressure",
        assetKey = "critical",
        fallbackColor = { 0.17, 0.020, 0.040, 1.00 },
        points = {
            { 0.00, 0.90 },
            { 0.05, 0.86 },
            { 0.10, 0.76 },
            { 0.15, 0.64 },
            { 0.20, 0.48 },
            { 0.30, 0.26 },
            { 0.40, 0.10 },
            { 0.50, 0.00 },
            { 1.00, 0.00 },
        },
    },
    {
        name = "nearDeathTunnel",
        assetKey = "nearDeath",
        fallbackColor = { 0.055, 0.012, 0.025, 1.00 },
        points = {
            { 0.00, 1.00 },
            { 0.05, 0.92 },
            { 0.10, 0.76 },
            { 0.15, 0.56 },
            { 0.20, 0.30 },
            { 0.25, 0.10 },
            { 0.30, 0.00 },
            { 1.00, 0.00 },
        },
    },
    {
        name = "deathCollapse",
        assetKey = "death",
        fallbackColor = { 0.008, 0.004, 0.008, 1.00 },
        points = {
            { 0.00, 1.00 },
            { 0.01, 0.15 },
            { 0.02, 0.00 },
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

local ALLY_UNITS = {
    "pet",
    "party1",
    "party2",
    "party3",
    "party4",
}

local percentageBarStyle =
    (Logres.Theme and Logres.Theme.percentageBar) or {}
local percentageBarAssets = percentageBarStyle.assets or {}
local percentageBarColors = percentageBarStyle.colors or {}
local hudTypography = (Logres.Theme and Logres.Theme.hudTypography) or {}

local castCueStyle =
    (Logres.Theme and Logres.Theme.castCue) or {}
local castCueAssets = castCueStyle.assets or {}
local DEFAULT_CAST_CUE_SIZE = castCueStyle.size or 24

local healthTunnelStyle =
    (Logres.Theme and Logres.Theme.healthTunnel) or {}
local healthTunnelAssets = healthTunnelStyle.assets or {}
local healthTunnelColors = healthTunnelStyle.colors or {}

local DEFAULT_PERCENTAGE_BAR = {
    normal = {
        trackWidth = 142,
        trackHeight = 12,
        frameHeight = 18,
        textWidth = 34,
        textGap = 8,
        diamondSize = 10,
        font = "GameFontNormal",
    },
    compact = {
        trackWidth = 58,
        trackHeight = 8,
        frameHeight = 14,
        textWidth = 30,
        textGap = 4,
        diamondSize = 8,
        font = "GameFontNormalSmall",
    },
}

local DEFAULT_TRACK_COLOR = { 0.012, 0.010, 0.008, 0.94 }
local DEFAULT_BORDER_COLOR = { 0.45, 0.32, 0.15, 0.96 }
local DEFAULT_TEXT_COLOR = { 0.94, 0.90, 0.80, 1.00 }
local DEFAULT_RESOURCE_COLOR = { 0.72, 0.49, 0.13, 1.00 }
local DEFAULT_TARGET_COLOR = { 0.62, 0.11, 0.07, 1.00 }
local DEFAULT_ALLY_COLOR = { 0.18, 0.55, 0.27, 1.00 }

local RESOURCE_COLOR_KEYS = {
    MANA = "mana",
    RAGE = "rage",
    ENERGY = "energy",
    FOCUS = "focus",
    RUNIC_POWER = "runicPower",
    LUNAR_POWER = "alternate",
    MAELSTROM = "alternate",
    INSANITY = "alternate",
    FURY = "alternate",
    PAIN = "alternate",
}

-- PvP flags are secret-capable on Forever. Only a positively proven
-- ordinary boolean may govern the Logres-owned visual indicator.
local function readOrdinaryPvPFlag(unit)
    if type(UnitIsPVP) ~= "function" or type(issecretvalue) ~= "function" then
        return nil
    end
    local ok, raw = pcall(UnitIsPVP, unit)
    if not ok then
        return nil
    end
    local checked, secret = pcall(issecretvalue, raw)
    if not checked or secret ~= false then
        return nil
    end
    if type(raw) ~= "boolean" then
        return nil
    end
    return raw
end

-- Same compact renderer for deterministic preview and verified live flags.
-- No faction inference, combat branches, Blizzard frame reads or controls.
local function createPvPBadge(parent)
    local badge = CreateFrame("Frame", nil, parent)
    badge:SetSize(32, 16)
    badge:EnableMouse(false)
    local plate = badge:CreateTexture(nil, "BACKGROUND")
    plate:SetAllPoints(badge)
    plate:SetColorTexture(0.055, 0.043, 0.036, 0.88)
    local rule = badge:CreateTexture(nil, "BORDER")
    rule:SetPoint("BOTTOMLEFT", badge, "BOTTOMLEFT", 2, 1)
    rule:SetPoint("BOTTOMRIGHT", badge, "BOTTOMRIGHT", -2, 1)
    rule:SetHeight(1)
    rule:SetColorTexture(0.82, 0.39, 0.21, 0.94)
    local text = badge:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    text:SetAllPoints(badge)
    text:SetJustifyH("CENTER")
    text:SetText("PvP")
    text:SetTextColor(1.00, 0.75, 0.52, 1.00)
    badge:Hide()
    return badge
end

function HUD:RefreshPvPIndicators()
    if not self.playerPvPBadge or not self.targetPvPBadge then
        return
    end
    if self.pvpPreviewEnabled then
        -- Visual fixture uses the production badges, but no live PvP reads.
        self.playerPvPBadge:Show()
        self.targetPvPBadge:Show()
        return
    end
    local playerFlag = readOrdinaryPvPFlag("player")
    local targetFlag = readOrdinaryPvPFlag("target")
    self.playerPvPObserved = playerFlag == nil and "unknown"
        or playerFlag and "flagged" or "unflagged"
    self.targetPvPObserved = targetFlag == nil and "unknown"
        or targetFlag and "flagged" or "unflagged"
    -- Unknown is not unflagged: hide only our additive badge, not stock UI.
    self.playerPvPBadge:SetShown(playerFlag == true)
    self.targetPvPBadge:SetShown(targetFlag == true)
end

function HUD:SetPvPPreview(enabled)
    self.pvpPreviewEnabled = enabled == true
    self:RefreshPvPIndicators()
    return true
end

local function createCastCue(parent, name)
    local cue = CreateFrame("Frame", name, parent)
    cue:SetSize(DEFAULT_CAST_CUE_SIZE, DEFAULT_CAST_CUE_SIZE)
    cue:Hide()

    local glyph = cue:CreateTexture(nil, "ARTWORK")
    glyph:SetAllPoints(cue)
    glyph:Hide()

    local frameTexture = cue:CreateTexture(nil, "OVERLAY")
    frameTexture:SetAllPoints(cue)
    frameTexture:SetTexture(
        castCueAssets.frame or "Interface\\Buttons\\UI-Quickslot2"
    )

    cue.frameTexture = frameTexture
    cue.glyph = glyph
    cue.generation = 0
    cue.terminalHold = false

    return cue
end

local function styleCastCue(cue, state, scope)
    local asset

    if state == "channel" then
        if scope == "player" then
            asset = castCueAssets.playerChannel
        else
            asset = castCueAssets.targetChannel
        end
    elseif state == "interrupted" then
        asset = castCueAssets.interrupted
    elseif scope == "player" then
        asset = castCueAssets.playerCast
    else
        asset = castCueAssets.targetCast
    end

    if asset then
        cue.glyph:SetTexture(asset)
        cue.glyph:Show()
    else
        cue.glyph:Hide()
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

local function percentageBarSpec(variant)
    return percentageBarStyle[variant]
        or DEFAULT_PERCENTAGE_BAR[variant]
        or DEFAULT_PERCENTAGE_BAR.normal
end

local function percentageBarColor(color, fallback)
    if type(color) == "table" then
        return color
    end

    return fallback
end

local function setPercentageBarColor(bar, color)
    bar.status:SetStatusBarColor(
        color[1],
        color[2],
        color[3],
        color[4] or 1
    )
end

local function createPercentageBar(parent, name, variant, initialColor)
    local spec = percentageBarSpec(variant)
    local trackColor = percentageBarColor(
        percentageBarStyle.trackColor,
        DEFAULT_TRACK_COLOR
    )
    local borderColor = percentageBarColor(
        percentageBarStyle.borderColor,
        DEFAULT_BORDER_COLOR
    )
    local textColor = percentageBarColor(
        percentageBarStyle.textColor,
        DEFAULT_TEXT_COLOR
    )
    local diamondSize = spec.diamondSize
    local totalWidth =
        spec.trackWidth + diamondSize + spec.textGap + spec.textWidth

    local frame = CreateFrame("Frame", name, parent)
    frame:SetSize(totalWidth, spec.frameHeight)
    frame:EnableMouse(false)

    local status = CreateFrame("StatusBar", nil, frame)
    status:SetPoint("LEFT", frame, "LEFT", diamondSize / 2, 0)
    status:SetSize(spec.trackWidth, spec.trackHeight)
    status:SetMinMaxValues(0, 100)
    status:SetValue(0)
    status:SetStatusBarTexture(
        percentageBarAssets.fill
            or "Interface\\Buttons\\WHITE8x8"
    )

    local track = status:CreateTexture(nil, "BACKGROUND")
    track:SetAllPoints(status)
    track:SetColorTexture(
        trackColor[1],
        trackColor[2],
        trackColor[3],
        trackColor[4]
    )

    local top = status:CreateTexture(nil, "BORDER")
    top:SetPoint("TOPLEFT", status, "TOPLEFT", 0, 0)
    top:SetPoint("TOPRIGHT", status, "TOPRIGHT", 0, 0)
    top:SetHeight(1)
    top:SetColorTexture(
        borderColor[1],
        borderColor[2],
        borderColor[3],
        borderColor[4]
    )

    local bottom = status:CreateTexture(nil, "BORDER")
    bottom:SetPoint("BOTTOMLEFT", status, "BOTTOMLEFT", 0, 0)
    bottom:SetPoint("BOTTOMRIGHT", status, "BOTTOMRIGHT", 0, 0)
    bottom:SetHeight(1)
    bottom:SetColorTexture(
        borderColor[1],
        borderColor[2],
        borderColor[3],
        borderColor[4]
    )

    local leftEdge = status:CreateTexture(nil, "BORDER")
    leftEdge:SetPoint("TOPLEFT", status, "TOPLEFT", 0, 0)
    leftEdge:SetPoint("BOTTOMLEFT", status, "BOTTOMLEFT", 0, 0)
    leftEdge:SetWidth(1)
    leftEdge:SetColorTexture(
        borderColor[1],
        borderColor[2],
        borderColor[3],
        borderColor[4]
    )

    local rightEdge = status:CreateTexture(nil, "BORDER")
    rightEdge:SetPoint("TOPRIGHT", status, "TOPRIGHT", 0, 0)
    rightEdge:SetPoint("BOTTOMRIGHT", status, "BOTTOMRIGHT", 0, 0)
    rightEdge:SetWidth(1)
    rightEdge:SetColorTexture(
        borderColor[1],
        borderColor[2],
        borderColor[3],
        borderColor[4]
    )

    local leftDiamond = frame:CreateTexture(nil, "ARTWORK")
    leftDiamond:SetSize(diamondSize, diamondSize)
    leftDiamond:SetPoint("CENTER", status, "LEFT", 0, 0)
    leftDiamond:SetTexture(
        percentageBarAssets.diamond
            or "Interface\\Buttons\\WHITE8x8"
    )

    local rightDiamond = frame:CreateTexture(nil, "ARTWORK")
    rightDiamond:SetSize(diamondSize, diamondSize)
    rightDiamond:SetPoint("CENTER", status, "RIGHT", 0, 0)
    rightDiamond:SetTexture(
        percentageBarAssets.diamond
            or "Interface\\Buttons\\WHITE8x8"
    )

    local percentText = frame:CreateFontString(
        nil,
        "OVERLAY",
        spec.font or "GameFontNormalSmall"
    )
    percentText:SetPoint(
        "LEFT",
        status,
        "RIGHT",
        (diamondSize / 2) + spec.textGap,
        0
    )
    percentText:SetWidth(spec.textWidth)
    percentText:SetJustifyH("RIGHT")
    percentText:SetTextColor(
        textColor[1],
        textColor[2],
        textColor[3],
        textColor[4]
    )
    percentText:SetShadowColor(0, 0, 0, 0.98)
    percentText:SetShadowOffset(1, -1)
    percentText:ClearText()

    frame.status = status
    frame.percentText = percentText
    frame.variant = variant

    setPercentageBarColor(
        frame,
        initialColor or DEFAULT_RESOURCE_COLOR
    )

    return frame
end

local function createHealthTunnelTexture(root, band)
    local texture = root:CreateTexture(nil, "BACKGROUND")
    texture:SetAllPoints(root)

    local asset = healthTunnelAssets[band.assetKey]
    texture:SetTexture(asset)

    local color =
        healthTunnelColors[band.assetKey]
        or band.fallbackColor

    texture:SetVertexColor(
        color[1],
        color[2],
        color[3],
        color[4] or 1
    )
    texture:SetAlpha(0)

    return texture
end

local function samplePreviewCurve(points, normalizedPreview)
    if normalizedPreview <= points[1][1] then
        return points[1][2]
    end

    for index = 2, #points do
        local left = points[index - 1]
        local right = points[index]

        if normalizedPreview <= right[1] then
            local width = right[1] - left[1]

            if width <= 0 then
                return right[2]
            end

            local position =
                (normalizedPreview - left[1]) / width

            return left[2]
                + ((right[2] - left[2]) * position)
        end
    end

    return points[#points][2]
end

function HUD:ApplyHealthPreviewPercent(previewPercent)
    local normalizedPreview = previewPercent / 100

    for index = 1, #self.healthBands do
        local band = self.healthBands[index]
        local previewValue =
            samplePreviewCurve(
                band.points,
                normalizedPreview
            )

        band.texture:SetAlpha(previewValue)
    end
end

function HUD:SetHealthPreviewPercent(previewPercent)
    if previewPercent == nil then
        self.previewEnabled = false
        self.previewPercent = nil

        if self.root and self.root:IsShown() then
            self:UpdateHealthVignette()
        end

        return true, "live"
    end

    if type(previewPercent) ~= "number"
        or not HEALTH_PREVIEW_PERCENTAGES[previewPercent]
    then
        return false, "unsupported-preview-percent"
    end

    self.previewEnabled = true
    self.previewPercent = previewPercent

    if self.root and self.root:IsShown() then
        if self.deathTravelMode then
            self:UpdateHealthVignette()
        else
            self:ApplyHealthPreviewPercent(previewPercent)
        end
    end

    return true, "preview"
end

function HUD:ApplyPreview()
    self:ApplyHealthPreviewPercent(
        self.previewPercent or 30
    )
end

function HUD:SetPreviewEnabled(enabled)
    -- HUD Preview is the owned enemy fixture only. Health simulation is a
    -- separate explicit /logres healthpreview action; do not fabricate low
    -- player health when previewing enemies at normal live health.
    self:SetEnemyDisplayPreview(enabled == true)
    return true, enabled and "enemy-preview" or "enemy-preview-hidden"
end

local function readOrdinaryDeathTravelState()
    -- Death/ghost observations can be secret-capable. Inspect only a value
    -- positively classified ordinary; unknown leaves our cached state alone.
    if type(UnitIsDeadOrGhost) ~= "function"
        or type(issecretvalue) ~= "function"
    then
        return nil
    end
    local ok, result = pcall(UnitIsDeadOrGhost, "player")
    if not ok then
        return nil
    end
    local tested, secret = pcall(issecretvalue, result)
    if not tested or secret then
        return nil
    end
    if type(result) ~= "boolean" then
        return nil
    end
    return result
end

function HUD:RefreshDeathTravelState(event)
    -- Known lifecycle events are ordinary control signals, not health values.
    -- PLAYER_ALIVE can mean spirit release; only a safe observation can clear
    -- the death override there. PLAYER_UNGHOST always completes corpse travel.
    if event == "PLAYER_DEAD" then
        self.deathTravelMode = true
    elseif event == "PLAYER_UNGHOST" then
        self.deathTravelMode = false
    else
        local ordinaryState = readOrdinaryDeathTravelState()
        if ordinaryState ~= nil then
            self.deathTravelMode = ordinaryState
        end
    end
    self:UpdateHealthVignette()
end

function HUD:UpdateHealthVignette()
    if not self.root or not self.root:IsShown() then
        return
    end

    -- Corpse travel is not a health percentage. Keep the world navigable
    -- after death; never query secret-capable health while this mode is active.
    if self.deathTravelMode then
        for index = 1, #self.healthBands do
            self.healthBands[index].texture:SetAlpha(0)
        end
        return
    end
    if self.previewEnabled then
        return
    end

    for index = 1, #self.healthBands do
        local band = self.healthBands[index]

        -- Player health is secret-capable on Forever. The curve is evaluated
        -- by the native UI system and the resulting secret value is passed
        -- directly to Texture:SetAlpha. Never branch, compare, stringify,
        -- persist, or perform arithmetic on this value in Lua.
        local alpha = UnitHealthPercent("player", true, band.curve)

        band.texture:SetAlpha(alpha)
    end
end

function HUD:UpdateResource()
    if not self.root or not self.root:IsShown() then
        return
    end

    local _, powerToken = UnitPowerType("player")
    local colorKey = RESOURCE_COLOR_KEYS[powerToken] or "alternate"
    local resourceColor =
        percentageBarColors[colorKey] or DEFAULT_RESOURCE_COLOR
    setPercentageBarColor(self.resourceBar, resourceColor)

    -- Primary player power is secret-capable on Forever. The native curve
    -- scales it to 0-100 and the opaque result is forwarded directly to two
    -- native consumers: StatusBar:SetValue and FontString:SetFormattedText.
    -- Never branch, compare, stringify, persist, or perform Lua arithmetic on
    -- the returned percentage.
    local percent = UnitPowerPercent(
        "player",
        nil,
        false,
        self.percentScaleCurve
    )

    self.resourceBar.status:SetValue(percent)
    self.resourceText:SetFormattedText("%.0f%%", percent)
end



function HUD:UpdateAllyUnit(unit)
    if not self.root or not self.root:IsShown() then
        return
    end

    local row = self.allyRowsByUnit[unit]
    if not row then
        return
    end

    if not UnitExists(unit) then
        row.frame:Hide()
        return
    end

    -- Ally/pet identity may be secret-restricted. Forward the value directly
    -- to the native FontString consumer and never inspect/read it back.
    row.nameText:SetText(UnitName(unit))

    -- Ally/pet health is secret-capable. The native curve performs the
    -- 0-100 scale and the opaque result goes directly to native bar/text
    -- consumers without Lua inspection.
    local percent = UnitHealthPercent(
        unit,
        true,
        self.percentScaleCurve
    )

    row.healthBar.status:SetValue(percent)
    row.healthText:SetFormattedText("%.0f%%", percent)
    row.frame:Show()
end

function HUD:UpdateAllies()
    for index = 1, #ALLY_UNITS do
        self:UpdateAllyUnit(ALLY_UNITS[index])
    end
end

function HUD:UpdateTarget()
    if not self.root or not self.root:IsShown() then
        return
    end

    if not UnitExists("target") then
        self.targetFrame:Hide()
        self:UpdateWorldTrialValues()
        return
    end

    -- Target identity can become secret under unit-identity restrictions.
    -- Forward it directly to the native FontString consumer. Do not inspect,
    -- concatenate, stringify, or branch on the returned name in Lua.
    self.targetNameText:SetText(UnitName("target"))

    -- Target health is secret-capable. Scale it to 0-100 inside the native
    -- curve system and forward the opaque result directly to native bar/text
    -- consumers. Reaction/danger coloring remains separately capability-gated.
    local percent = UnitHealthPercent(
        "target",
        true,
        self.percentScaleCurve
    )

    self.targetHealthBar.status:SetValue(percent)
    self.targetHealthText:SetFormattedText("%.0f%%", percent)
    -- P0446: the world copy owns selected-target presentation only while
    -- successfully attached. The canonical screen target stays as fallback.
    self.targetFrame:Show()
    -- The cast cue is a child of targetFrame, so never hide its parent.
    self.targetNameText:SetShown(self.worldEnemyLiveVisible ~= true)
    self.targetHealthBar:SetShown(self.worldEnemyLiveVisible ~= true)
    self:UpdateWorldTrialValues()
end

function HUD:ApplyImmersionPreference(preferences)
    if preferences.immersionEnabled then
        self.root:Show()

        if self.deathTravelMode then
            self:UpdateHealthVignette()
        elseif self.previewEnabled then
            self:ApplyPreview()
        else
            self:UpdateHealthVignette()
        end

        self:UpdateResource()
        self:UpdateTarget()
        self:UpdateAllies()
        self:RefreshPvPIndicators()
    else
        self.root:Hide()
        self:SetWorldTargetTrial(false)
        self:SetLiveWorldEnemy(false)
    end
end

function HUD:GetDebugStatus()
    local preferences = Logres:GetPreferences()

    return {
        moduleEnabled = self:IsEnabled(),
        rootShown = self.root and self.root:IsShown() or false,
        immersionEnabled = preferences.immersionEnabled,
        screenSpaceEnemyFrameEnabled = preferences.screenSpaceEnemyFrameEnabled,
        enemyPreviewReady = self.enemyDisplayPreview ~= nil,
        enemyPreviewVisible = self.enemyPreviewVisible == true,
        enemyPreviewTargetScale = 1,
        enemyPreviewAggroScale = 0.5,
        enemyPreviewAggroAlpha = 0.5,
        enemyWorldAttachmentEnabled = false,
        enemyFallbackPreserved = true,
        worldEnemyLiveRequested = self.worldEnemyLiveRequested == true,
        worldEnemyLiveVisible = self.worldEnemyLiveVisible == true,
        worldEnemyLiveLastReason = self.worldEnemyLiveLastReason,
        worldEnemyLiveAttachments = self.worldEnemyLiveAttachments or 0,
        worldEnemyLiveCombatAttaches = self.worldEnemyLiveCombatAttaches or 0,
        worldEnemyLiveFailures = self.worldEnemyLiveFailures or 0,
        worldEnemyLiveDetaches = self.worldEnemyLiveDetaches or 0,
        worldEnemyScreenHandoffs = self.worldEnemyScreenHandoffs or 0,
        worldEnemyScreenFallbackRefreshes = self.worldEnemyScreenFallbackRefreshes or 0,
        worldEnemyScreenFallbackVisible = self.targetNameText
            and self.targetHealthBar and self.targetNameText:IsShown()
            and self.targetHealthBar:IsShown() or false,
        worldEnemyLiveRemovalResult = self.worldEnemyLiveRemovalResult,
        worldEnemyNativeVisualOwner = self.worldEnemyNativeClaim
            and "Logres-decor-only" or "Blizzard",
        worldEnemyNativeTransfers = self.worldEnemyNativeTransfers or 0,
        worldEnemyNativeRestoreCount = self.worldEnemyNativeRestoreCount or 0,
        worldEnemyNativeRestoreFailures = self.worldEnemyNativeRestoreFailures or 0,
        worldEnemyNativeLastResult = self.worldEnemyNativeLastResult,
        worldEnemyNativeAuraOwner = self.worldEnemyNativeAuraOwned
            and "Logres-world" or "Blizzard",
        worldEnemyNativeAuraLastResult = self.worldEnemyNativeAuraLastResult,
        worldEnemyNativeAuraTransfers = self.worldEnemyNativeAuraTransfers or 0,
        worldEnemyNativeAuraRestores = self.worldEnemyNativeAuraRestores or 0,
        worldEnemyLiveAnchorSource = self.worldEnemyLiveAnchorUnit
            and "event-token" or "target-query-or-none",
        worldEnemyLiveLayout = "native-anchor-center",
        -- Only the name, health and aura widgets render; no opaque backing.
        worldEnemyLivePresentation = "transparent-owned-unit",
        worldEnemySecondaryEnabled = false, -- production remains disabled
        worldEnemySecondaryTrialArmed = self.worldEnemySecondaryTrialArmed == true,
        worldEnemySecondaryTrialVisible = self.worldEnemySecondaryTrialVisible == true,
        worldEnemySecondaryTrialEligibleEvents = self.worldEnemySecondaryTrialEligibleEvents,
        worldEnemySecondaryTrialAttachments = self.worldEnemySecondaryTrialAttachments,
        worldEnemySecondaryTrialDetaches = self.worldEnemySecondaryTrialDetaches,
        worldEnemySecondaryTrialFailures = self.worldEnemySecondaryTrialFailures,
        worldEnemySecondaryTrialRestores = self.worldEnemySecondaryTrialRestores,
        worldEnemySecondaryTrialRestoreFailures = self.worldEnemySecondaryTrialRestoreFailures,
        worldEnemySecondaryTrialLastResult = self.worldEnemySecondaryTrialLastResult,
        worldEnemySecondaryTrialLastDetachReason = self.worldEnemySecondaryTrialLastDetachReason,
        worldEnemySecondaryTrialIgnoredUnrelatedEvents = self.worldEnemySecondaryTrialIgnoredUnrelatedEvents,
        worldTrialRequested = self.worldTrialRequested == true,
        worldTrialVisible = self.worldTrialVisible == true,
        worldTrialLastReason = self.worldTrialLastReason,
        worldTrialAttachCount = self.worldTrialAttachCount or 0,
        worldTrialFailures = self.worldTrialFailures or 0,
        worldTrialCombatHidden = self.worldTrialCombatHidden == true,
        previewEnabled = self.previewEnabled and true or false,
        previewPercent = self.previewPercent,
        deathTravelMode = self.deathTravelMode and true or false,
        pvpPreviewEnabled = self.pvpPreviewEnabled == true,
        playerPvPObserved = self.playerPvPObserved,
        targetPvPObserved = self.targetPvPObserved,
        pvpIndicatorsReady = self.playerPvPBadge ~= nil
            and self.targetPvPBadge ~= nil,
        bandCount = self.healthBands and #self.healthBands or 0,
        textureCount = self.healthTextureCount or 0,
        curvesReady = self.curvesReady and true or false,
        resourceTextReady = self.resourceText ~= nil,
        resourceBarReady = self.resourceBar ~= nil,
        resourceCurveReady = self.percentScaleCurve ~= nil,
        targetFrameReady = self.targetFrame ~= nil,
        targetNameTextReady = self.targetNameText ~= nil,
        targetHealthTextReady = self.targetHealthText ~= nil,
        targetHealthBarReady = self.targetHealthBar ~= nil,
        targetEventFrameReady = self.targetEventFrame ~= nil,
        playerCastCueReady = self.playerCastCue ~= nil,
        targetCastCueReady = self.targetCastCue ~= nil,
        playerCastEventFrameReady = self.playerCastEventFrame ~= nil,
        targetCastEventFrameReady = self.targetCastEventFrame ~= nil,
        allyRowCount = self.allyRows and #self.allyRows or 0,
        allyEventFrameCount =
            self.allyEventFrames and #self.allyEventFrames or 0,
        allyRosterEventFrameReady = self.allyRosterEventFrame ~= nil,
    }
end

-- The font treatment is shared by the original target fallback and the
-- owned two-size enemy fixtures. No Blizzard unit or nameplate is mutated.
local function styleEnemyNameText(label)
    local enemyNameColor = hudTypography.targetName or { 0.97, 0.91, 0.80, 1.00 }
    label:SetTextColor(
        enemyNameColor[1], enemyNameColor[2],
        enemyNameColor[3], enemyNameColor[4]
    )
    label:SetShadowColor(0, 0, 0, 0.96)
    label:SetShadowOffset(1, -1)
    label:SetJustifyH("CENTER")
    label:SetWidth(190)
end

-- Purely addon-owned fixture: the same percentage-bar primitive, font,
-- and target cast layout as the existing fallback. This constructor
-- can become the world display only after D-042's attachment proof.
local function buildEnemyDisplayFixture(parent, fixtureName, label, percent)
    local frame = CreateFrame("Frame", fixtureName, parent)
    frame:SetSize(198, 54)
    frame:EnableMouse(false)
    local nameText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    nameText:SetPoint("TOP", frame, "TOP", 0, 0)
    styleEnemyNameText(nameText)
    nameText:SetText(label) -- fixed preview fixture, never UnitName() data
    local bar = createPercentageBar(frame, nil, "normal",
        percentageBarColors.targetHealth or DEFAULT_TARGET_COLOR)
    bar:SetPoint("TOP", nameText, "BOTTOM", 0, -4)
    bar.status:SetValue(percent)
    bar.percentText:SetFormattedText("%.0f%%", percent)
    local cue = createCastCue(frame, nil)
    cue:SetPoint("TOP", frame, "BOTTOM", 0, -6)
    frame.enemyNameText = nameText
    frame.enemyHealthBar = bar
    frame.enemyHealthText = bar.percentText
    frame.enemyCastCue = cue
    return frame
end

-- Preview is a synthetic policy demonstration, not a live threat classifier.
-- OOC: one selected hostile. Combat: selected 100/100 and only a fixture
-- explicitly marked confirmed aggro at 50/50. No nameplate frame touched.
function HUD:BuildEnemyDisplayPreview()
    if self.enemyDisplayPreview then return true end
    local host = CreateFrame("Frame", "LogresEnemyDisplayPreview", UIParent)
    host:SetSize(810, 390)
    host:SetPoint("CENTER", UIParent, "CENTER", 0, 15)
    host:SetFrameStrata("DIALOG")
    host:EnableMouse(false)
    host:Hide()
    local tint = host:CreateTexture(nil, "BACKGROUND")
    tint:SetAllPoints(host)
    tint:SetColorTexture(0.02, 0.02, 0.02, 0.85)
    local title = host:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOP", host, "TOP", 0, -12)
    title:SetText("ENEMY DISPLAY — FIXTURE PREVIEW (NOT LIVE)")
    local ooc = host:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    ooc:SetPoint("TOPLEFT", host, "TOPLEFT", 20, -41)
    ooc:SetText("OUT OF COMBAT: only selected hostile  |  100% size / opacity")
    local combat = host:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    combat:SetPoint("TOPLEFT", host, "TOPLEFT", 20, -204)
    combat:SetText("COMBAT: current target 100%  |  confirmed-aggro non-target 50%")

    local oocTarget = buildEnemyDisplayFixture(host, nil, "Selected hostile", 78)
    oocTarget:SetPoint("TOP", host, "TOP", -95, -86)
    local combatTarget = buildEnemyDisplayFixture(host, nil, "Current hostile target", 61)
    combatTarget:SetPoint("TOP", host, "TOP", -160, -252)
    -- A scaled frame anchored directly to the dialog can drift vertically.
    -- Keep the combat-row position in an unscaled slot, then scale only the
    -- owned display and its V8-spaced aura children inside that slot.
    local aggroSlot = CreateFrame("Frame", nil, host)
    aggroSlot:SetSize(198, 54)
    aggroSlot:SetPoint("TOP", host, "TOP", 245, -252)
    aggroSlot:EnableMouse(false)
    local aggro = buildEnemyDisplayFixture(aggroSlot, nil, "Confirmed aggro", 43)
    aggro:SetScale(0.5)
    aggro:SetPoint("TOP", aggroSlot, "TOP", 0, 0)
    aggro:SetAlpha(0.5)

    self.enemyPreviewAggroSlot = aggroSlot
    self.enemyDisplayPreview = host
    self.enemyPreviewUnits = {oocTarget, combatTarget, aggro}
    return true
end

-- P0438: a developer-only live target preview on an *already proven* anchor.
-- No production relocation, no replacement, no Blizzard mutations, no polling.
-- This must never be enabled automatically from saved preferences.
local function ordinaryOutOfCombat()
    if type(InCombatLockdown) ~= "function"
        or type(issecretvalue) ~= "function" then return false end
    local ok, value = pcall(InCombatLockdown)
    if not ok then return false end
    local checked, secret = pcall(issecretvalue, value)
    return checked and secret == false
        and type(value) == "boolean" and value == false
end

-- Only an ordinary positive combat state can authorize a combat-only
-- attachment attempt or contribute to the combat attachment count.
local function ordinaryInCombat()
    if type(InCombatLockdown) ~= "function"
        or type(issecretvalue) ~= "function" then return false end
    local ok, value = pcall(InCombatLockdown)
    if not ok then return false end
    local checked, secret = pcall(issecretvalue, value)
    return checked and secret == false
        and type(value) == "boolean" and value == true
end

function HUD:BuildWorldTargetTrial()
    if self.worldTrialFrame then return true end
    if not ordinaryOutOfCombat() then
        return false, "combat-or-state-unavailable"
    end
    if type(RegisterStateDriver) ~= "function" then
        return false, "combat-state-driver-unavailable"
    end
    -- A separate parent has a secure combat visibility driver, so no Lua
    -- SetPoint/Show/Hide is needed on combat entry or target transitions.
    local shell = CreateFrame("Frame", "LogresWorldTargetTrialShell", UIParent)
    shell:SetAllPoints(UIParent)
    shell:SetFrameStrata("HIGH")
    shell:EnableMouse(false)
    shell:SetScript("OnShow", function()
        -- A stale target must not briefly resurface when the secure driver
        -- reveals its parent after combat. OOC events reacquire the anchor.
        if self.worldTrialFrame and ordinaryOutOfCombat() then
            self.worldTrialFrame:Hide()
            self.worldTrialVisible = false
        end
    end)
    local frame = buildEnemyDisplayFixture(shell,
        "LogresWorldTargetTrial", "World target (trial)", 100)
    frame:EnableMouse(false)
    frame:Hide()
    local ok = pcall(RegisterStateDriver, shell,
        "visibility", "[combat] hide; show")
    if not ok then
        shell:Hide()
        self.worldTrialLastReason = "combat-state-driver-failed"
        return false, self.worldTrialLastReason
    end
    self.worldTrialShell = shell
    self.worldTrialFrame = frame
    -- Always reuse StatusAuras' ordinary-source renderer and its +/-25px
    -- unit-relative lanes; no synthetic auras in the world trial.
    local aura = Logres:GetModule("StatusAuras")
    if aura and type(aura.CreateWorldTrialLanes) == "function" then
        aura:CreateWorldTrialLanes(frame)
    end
    return true
end

function HUD:UpdateWorldTrialValues()
    if not self.worldTrialFrame or not self.worldTrialVisible
        or not ordinaryOutOfCombat() then return end
    local frame = self.worldTrialFrame
    local ok = pcall(function()
        -- Secret-capable unit identity and percent flow directly into native
        -- consumers, with no Lua comparison, arithmetic or formatting.
        frame.enemyNameText:SetText(UnitName("target"))
        local percent = UnitHealthPercent("target", true, self.percentScaleCurve)
        frame.enemyHealthBar.status:SetValue(percent)
        frame.enemyHealthText:SetFormattedText("%.0f%%", percent)
    end)
    if not ok then
        self.worldTrialFailures = self.worldTrialFailures + 1
        self.worldTrialLastReason = "unit-consumer-failed"
        self.worldTrialVisible = false
        -- This addon-owned trial is still OOC; never display stale fixtures.
        frame:Hide()
        return false
    end
    return true
end

function HUD:RefreshWorldTargetTrial(reason)
    if not self.worldTrialRequested then return false, "not-requested" end
    if not ordinaryOutOfCombat() then
        self.worldTrialLastReason = "combat-deferred"
        self.worldTrialVisible = false
        -- The secure parent handles combat hiding. Do not mutate frames here.
        return false, self.worldTrialLastReason
    end
    local built, buildReason = self:BuildWorldTargetTrial()
    if not built then
        self.worldTrialLastReason = buildReason
        return false, buildReason
    end
    local frame = self.worldTrialFrame
    frame:Hide()
    self.worldTrialVisible = false
    pcall(frame.ClearAllPoints, frame)
    local preferences = Logres:GetPreferences()
    if preferences.immersionEnabled ~= true then
        self.worldTrialLastReason = "immersion-off"
        return false, self.worldTrialLastReason
    end
    local probe = Logres:GetModule("WorldTargetProbe")
    if not probe or type(probe.AcquireWorldTrialAnchor) ~= "function" then
        self.worldTrialLastReason = "probe-unavailable"
        return false, self.worldTrialLastReason
    end
    local anchor, why = probe:AcquireWorldTrialAnchor()
    if not anchor then
        self.worldTrialLastReason = why
        return false, why
    end
    local attached = pcall(frame.SetPoint, frame,
        "BOTTOM", anchor, "TOP", 0, 6)
    if not attached then
        self.worldTrialFailures = self.worldTrialFailures + 1
        self.worldTrialLastReason = "live-trial-setpoint-failed"
        pcall(frame.ClearAllPoints, frame)
        return false, self.worldTrialLastReason
    end
    self.worldTrialVisible = true
    self.worldTrialAttachCount = self.worldTrialAttachCount + 1
    self.worldTrialLastReason = "preview-anchored-ooc"
    if not self:UpdateWorldTrialValues() then
        return false, self.worldTrialLastReason
    end
    local auras = Logres:GetModule("StatusAuras")
    if auras and type(auras.RefreshWorldTrialLanes) == "function" then
        auras:RefreshWorldTrialLanes()
    end
    frame:Show()
    return true, self.worldTrialLastReason
end

function HUD:SetWorldTargetTrial(enabled)
    if enabled and not ordinaryOutOfCombat() then
        self.worldTrialLastReason = "combat-deferred"
        return false, self.worldTrialLastReason
    end
    self.worldTrialRequested = enabled == true
    if not self.worldTrialRequested then
        if ordinaryOutOfCombat() and self.worldTrialFrame then
            self.worldTrialFrame:Hide()
            pcall(self.worldTrialFrame.ClearAllPoints, self.worldTrialFrame)
        end
        self.worldTrialVisible = false
        self.worldTrialLastReason = "off"
        return true, "off"
    end
    return self:RefreshWorldTargetTrial("manual")
end

-- P0441: event-driven, opt-in real world enemy trial. Existing World Trial
-- remains unchanged for its historical out-of-combat secure-driver tests.
-- Only addon-owned UIParent children are moved; Blizzard plates/children and
-- interaction remain untouched. Every combat mutation can be refused safely.
local function ordinaryOwnedUnprotected(frame)
    if not frame or type(frame.IsProtected) ~= "function"
        or type(issecretvalue) ~= "function" then return false end
    local ok, protected = pcall(frame.IsProtected, frame)
    if not ok then return false end
    local checked, secret = pcall(issecretvalue, protected)
    return checked and secret == false and protected == false
end

-- P0447 opt-in native decorative ownership trial. Only the known separate
-- name/health/level regions may be dimmed. The unit frame, its mouse/target
-- owner, casts, auras, raid icons, and selection highlights stay Blizzard-owned.
-- Never inspect a secret-capable alpha: save it as an opaque restoration token.
local function safeNativeDecor(region)
    if not region or type(issecretvalue) ~= "function" then return false end
    local secretOK, secret = pcall(issecretvalue, region)
    if not secretOK or secret then return false end
    if type(region.IsProtected) ~= "function"
        or type(region.IsForbidden) ~= "function"
        or type(region.GetAlpha) ~= "function"
        or type(region.SetAlpha) ~= "function" then return false end
    local protectedOK, protected = pcall(region.IsProtected, region)
    local forbiddenOK, forbidden = pcall(region.IsForbidden, region)
    if not protectedOK or not forbiddenOK then return false end
    local pOK, pSecret = pcall(issecretvalue, protected)
    local fOK, fSecret = pcall(issecretvalue, forbidden)
    return pOK and not pSecret and protected == false
        and fOK and not fSecret and forbidden == false
end

local function nativeDecorField(parent, field)
    if not parent or type(issecretvalue) ~= "function" then return nil end
    local ok, value = pcall(function() return parent[field] end)
    if not ok or not value then return nil end
    local checked, secret = pcall(issecretvalue, value)
    if not checked or secret then return nil end
    return value
end

function HUD:RestoreNativeEnemyDecor()
    local claim = self.worldEnemyNativeClaim
    if not claim then return true end
    local restored = true
    -- Restore all captured original tokens, without comparing or formatting.
    for index = #claim, 1, -1 do
        local entry = claim[index]
        if not pcall(entry.region.SetAlpha, entry.region, entry.original) then
            restored = false
        end
    end
    if restored then
        if self.worldEnemyNativeAuraOwned then
            self.worldEnemyNativeAuraRestores = self.worldEnemyNativeAuraRestores + 1
            self.worldEnemyNativeAuraLastResult = "restored"
        end
        self.worldEnemyNativeAuraOwned = false
        self.worldEnemyNativeClaim = nil
        self.worldEnemyNativeRestoreCount = self.worldEnemyNativeRestoreCount + 1
        self.worldEnemyNativeLastResult = "restored"
    else
        self.worldEnemyNativeRestoreFailures =
            self.worldEnemyNativeRestoreFailures + 1
        self.worldEnemyNativeLastResult = "restore-refused"
    end
    return restored
end

function HUD:ClaimNativeEnemyDecor(anchor)
    if self.worldEnemyNativeClaim and not self:RestoreNativeEnemyDecor() then
        return false, "pending-native-restore"
    end
    local unitFrame = nativeDecorField(anchor, "UnitFrame")
    if not unitFrame then return false, "no-ordinary-unit-frame" end
    -- Name and health are mandatory; level indicators are optional.
    local name = nativeDecorField(unitFrame, "name")
    local health = nativeDecorField(unitFrame, "HealthBarsContainer")
    if not safeNativeDecor(name) or not safeNativeDecor(health) then
        return false, "native-decor-protected-or-unknown"
    end
    local claim = {}
    local candidates = {name, health}
    -- P0450: Native nameplate aura lists are presentation-only, separate
    -- from casts, raid markers, CC and target hit regions. Only when an
    -- addon-owned *native* world aura renderer is ready may these two
    -- independently verified, unprotected lists be transferred. Otherwise
    -- Blizzard retains all auras unchanged. No aura values are inspected.
    local auraAccepted = false
    local auraModule = Logres:GetModule("StatusAuras")
    if auraModule and auraModule.moduleEnabled
        and auraModule.worldEnemyNativeLanes then
        local auraRoot = nativeDecorField(unitFrame, "AurasFrame")
        local harmful = nativeDecorField(auraRoot, "DebuffListFrame")
        local helpful = nativeDecorField(auraRoot, "BuffListFrame")
        if safeNativeDecor(harmful) and safeNativeDecor(helpful) then
            candidates[#candidates + 1] = harmful
            candidates[#candidates + 1] = helpful
            auraAccepted = true
            self.worldEnemyNativeAuraLastResult = "aura-lists-capable"
        else
            self.worldEnemyNativeAuraLastResult = "aura-lists-protected-or-unavailable"
        end
    else
        self.worldEnemyNativeAuraLastResult = "world-aura-not-ready"
    end
    local level = nativeDecorField(unitFrame, "LevelFrame")
    local levelDiff = nativeDecorField(unitFrame, "PlayerLevelDiffFrame")
    if level then candidates[#candidates + 1] = level end
    if levelDiff then candidates[#candidates + 1] = levelDiff end
    for index = 1, #candidates do
        local region = candidates[index]
        if region then
            if not safeNativeDecor(region) then
                return false, "native-decor-protected-or-unknown"
            end
            local ok, token = pcall(region.GetAlpha, region)
            if not ok then return false, "native-alpha-capture-refused" end
            claim[#claim + 1] = {region = region, original = token}
        end
    end
    -- Every restoration token is captured before the first mutation.
    self.worldEnemyNativeClaim = claim
    for index = 1, #claim do
        local region = claim[index].region
        if not pcall(region.SetAlpha, region, 0) then
            self:RestoreNativeEnemyDecor()
            return false, "native-decor-mutation-refused"
        end
    end
    self.worldEnemyNativeAuraOwned = auraAccepted
    if auraAccepted then
        self.worldEnemyNativeAuraTransfers = self.worldEnemyNativeAuraTransfers + 1
        self.worldEnemyNativeAuraLastResult = "aura-lists-owned"
    end
    self.worldEnemyNativeTransfers = self.worldEnemyNativeTransfers + 1
    self.worldEnemyNativeLastResult = "decor-owned"
    return true, "decor-owned"
end

-- P0454: one developer-only 50% secondary at a time. The frame is
-- precreated OOC and never accepts mouse input. It owns name/health only;
-- Blizzard retains native auras, casts, targeting, and hit regions.
function HUD:BuildSecondaryAggroTrial()
    if self.worldEnemySecondaryTrialFrame then return true end
    if not ordinaryOutOfCombat() then return false, "secondary-build-requires-ooc" end
    local frame = buildEnemyDisplayFixture(UIParent,
        "LogresWorldEnemySecondaryTrial", "Secondary aggro", 100)
    frame:SetFrameStrata("HIGH")
    frame:SetScale(0.5)
    frame:SetAlpha(0.5)
    frame:EnableMouse(false)
    frame:Hide()
    if not ordinaryOwnedUnprotected(frame) then
        return false, "secondary-owned-frame-unsafe"
    end
    self.worldEnemySecondaryTrialFrame = frame
    return true
end

function HUD:RestoreNativeSecondaryEnemyDecor()
    local claim = self.worldEnemySecondaryTrialClaim
    if not claim then return true end
    local success = true
    for index = #claim, 1, -1 do
        local entry = claim[index]
        -- Captured alpha is an opaque token: never inspect or compare it.
        if not pcall(entry.region.SetAlpha, entry.region, entry.original) then
            success = false
        end
    end
    if success then
        self.worldEnemySecondaryTrialClaim = nil
        self.worldEnemySecondaryTrialRestores =
            self.worldEnemySecondaryTrialRestores + 1
    else
        self.worldEnemySecondaryTrialRestoreFailures =
            self.worldEnemySecondaryTrialRestoreFailures + 1
    end
    return success
end

function HUD:ClaimNativeSecondaryEnemyDecor(anchor)
    if not self:RestoreNativeSecondaryEnemyDecor() then
        return false, "secondary-restore-pending"
    end
    local unitFrame = nativeDecorField(anchor, "UnitFrame")
    local name = nativeDecorField(unitFrame, "name")
    local health = nativeDecorField(unitFrame, "HealthBarsContainer")
    if not safeNativeDecor(name) or not safeNativeDecor(health) then
        return false, "secondary-native-decor-unsafe"
    end
    local claim = {}
    for _, region in ipairs({name, health}) do
        local ok, alpha = pcall(region.GetAlpha, region)
        if not ok then return false, "secondary-alpha-capture-refused" end
        claim[#claim + 1] = {region = region, original = alpha}
    end
    self.worldEnemySecondaryTrialClaim = claim
    for _, entry in ipairs(claim) do
        if not pcall(entry.region.SetAlpha, entry.region, 0) then
            self:RestoreNativeSecondaryEnemyDecor()
            return false, "secondary-native-mutation-refused"
        end
    end
    return true, "secondary-native-name-health-owned"
end

function HUD:HideSecondaryAggroTrial(reason)
    local wasVisible = self.worldEnemySecondaryTrialVisible == true
    self.worldEnemySecondaryTrialVisible = false
    self.worldEnemySecondaryTrialUnit = nil
    if wasVisible then
        self.worldEnemySecondaryTrialDetaches =
            self.worldEnemySecondaryTrialDetaches + 1
        self.worldEnemySecondaryTrialLastDetachReason = reason or "secondary-hidden"
    end
    -- Restore Blizzard presentation before withdrawing owned presentation.
    local restored = self:RestoreNativeSecondaryEnemyDecor()
    local frame = self.worldEnemySecondaryTrialFrame
    local hidden = true
    if frame then
        hidden = ordinaryOwnedUnprotected(frame) and pcall(frame.Hide, frame)
    end
    if not hidden or not restored then
        self.worldEnemySecondaryTrialFailures =
            self.worldEnemySecondaryTrialFailures + 1
        self.worldEnemySecondaryTrialLastResult =
            not restored and "secondary-native-restore-refused"
            or "secondary-owned-hide-refused"
        return false
    end
    self.worldEnemySecondaryTrialLastResult = reason or "secondary-hidden"
    return true
end

function HUD:UpdateSecondaryAggroTrialValues(unit)
    local frame = self.worldEnemySecondaryTrialFrame
    if not frame or not ordinaryOwnedUnprotected(frame) then return false end
    -- Secret-capable unit name/health go directly into native UI consumers.
    local ok = pcall(function()
        frame.enemyNameText:SetText(UnitName(unit))
        local health = UnitHealthPercent(unit, true, self.percentScaleCurve)
        frame.enemyHealthBar.status:SetValue(health)
        frame.enemyHealthText:SetFormattedText("%.0f%%", health)
    end)
    if not ok then
        self.worldEnemySecondaryTrialFailures =
            self.worldEnemySecondaryTrialFailures + 1
        self:HideSecondaryAggroTrial("secondary-unit-consumer-refused")
    end
    return ok
end

function HUD:ObserveSecondaryAggroTrial(event, eventUnit, decision)
    if not self.worldEnemyLiveRequested
        or not self.worldEnemySecondaryTrialArmed then return end
    if Logres:GetPreferences().immersionEnabled ~= true then
        self:HideSecondaryAggroTrial("secondary-immersion-off")
        return
    end
    local probe = Logres:GetModule("WorldTargetProbe")
    if not probe then return end
    if event == "NAME_PLATE_UNIT_REMOVED" then
        if self.worldEnemySecondaryTrialUnit then
            local relevant = probe:IsLiveEnemyRemovalRelevant(
                eventUnit, self.worldEnemySecondaryTrialUnit)
            if relevant then self:HideSecondaryAggroTrial("secondary-removed") end
        end
        return
    end
    local unit = probe:OrdinaryEventNameplateToken(eventUnit)
    if not unit then
        -- P0455: non-nameplate UPDATE tokens cannot establish the identity or
        -- state of the attached secondary. Ignore them rather than restoring
        -- and reclaiming Blizzard name/health on unrelated threat events.
        -- NAME_PLATE_UNIT_REMOVED remains conservative above; a matching
        -- ordinary nameplate update can still withdraw on threat loss.
        if self.worldEnemySecondaryTrialUnit then
            self.worldEnemySecondaryTrialIgnoredUnrelatedEvents =
                self.worldEnemySecondaryTrialIgnoredUnrelatedEvents + 1
        end
        return
    end
    if self.worldEnemySecondaryTrialUnit
        and self.worldEnemySecondaryTrialUnit ~= unit then
        return -- one-unit trial; ignore other units, never steal their plates
    end
    if decision ~= "eligible" or not ordinaryInCombat() then
        if self.worldEnemySecondaryTrialUnit == unit then
            self:HideSecondaryAggroTrial("secondary-threat-lost-or-unknown")
        end
        return
    end
    self.worldEnemySecondaryTrialEligibleEvents =
        self.worldEnemySecondaryTrialEligibleEvents + 1
    local anchor, reason = probe:AcquireLiveEnemySecondaryAnchor(unit)
    if not anchor then
        if self.worldEnemySecondaryTrialUnit == unit then
            self:HideSecondaryAggroTrial(reason)
        end
        self.worldEnemySecondaryTrialLastResult = reason
        return
    end
    if self.worldEnemySecondaryTrialVisible then
        self:UpdateSecondaryAggroTrialValues(unit)
        return
    end
    local frame = self.worldEnemySecondaryTrialFrame
    if not ordinaryOwnedUnprotected(frame)
        or self.worldEnemySecondaryTrialClaim then
        self.worldEnemySecondaryTrialLastResult = "secondary-frame-or-restore-unsafe"
        return
    end
    local attached = pcall(function()
        frame:Hide()
        frame:ClearAllPoints()
        frame:SetPoint("CENTER", anchor, "CENTER", 0, 0)
    end)
    if not attached then
        self.worldEnemySecondaryTrialFailures =
            self.worldEnemySecondaryTrialFailures + 1
        self:HideSecondaryAggroTrial("secondary-attach-refused")
        return
    end
    if not self:UpdateSecondaryAggroTrialValues(unit) then return end
    local claimed, claimReason = self:ClaimNativeSecondaryEnemyDecor(anchor)
    if not claimed then
        self:HideSecondaryAggroTrial(claimReason)
        return
    end
    if not pcall(frame.Show, frame) then
        self.worldEnemySecondaryTrialFailures =
            self.worldEnemySecondaryTrialFailures + 1
        self:HideSecondaryAggroTrial("secondary-show-refused")
        return
    end
    self.worldEnemySecondaryTrialUnit = unit -- ordinary token for removal only
    self.worldEnemySecondaryTrialVisible = true
    self.worldEnemySecondaryTrialAttachments =
        self.worldEnemySecondaryTrialAttachments + 1
    self.worldEnemySecondaryTrialLastResult = "secondary-basic-aggro-attached"
end

function HUD:BuildLiveWorldEnemy()
    if self.worldEnemyLiveFrame then return true end
    if not ordinaryOutOfCombat() then return false, "build-requires-ooc" end
    local frame = buildEnemyDisplayFixture(UIParent,
        "LogresWorldEnemyLiveTrial", "Enemy world trial", 100)
    frame:SetFrameStrata("HIGH")
    frame:EnableMouse(false)
    frame:Hide()
    if not ordinaryOwnedUnprotected(frame) then
        return false, "owned-frame-protected-or-unknown"
    end
    self.worldEnemyLiveFrame = frame
    -- P0444: never cover Blizzard's nameplate with an opaque background.
    -- Preserve the existing transparent health/name and aura layout.
    local auras = Logres:GetModule("StatusAuras")
    if auras and type(auras.CreateWorldEnemyLiveLanes) == "function" then
        auras:CreateWorldEnemyLiveLanes(frame)
    end
    return true
end

function HUD:HideLiveWorldEnemy(reason)
    local hadWorldOwner = self.worldEnemyLiveVisible == true
    if hadWorldOwner then
        self.worldEnemyLiveDetaches = (self.worldEnemyLiveDetaches or 0) + 1
    end
    self.worldEnemyLiveVisible = false
    -- Restore the addon-owned screen aura copy on every detach/failure/OFF.
    -- Its native aura container remains active; only its alpha was handed
    -- off, and a refused restore remains an explicit diagnostic failure.
    local statusAuras = Logres:GetModule("StatusAuras")
    if statusAuras and type(statusAuras.SetWorldEnemyScreenAuraHandoff) == "function" then
        statusAuras:SetWorldEnemyScreenAuraHandoff(false)
    end
    -- Native decorative presentation must regain its original alpha on
    -- target change, removal, OFF and disable, even if our frame hide fails.
    self:RestoreNativeEnemyDecor()
    self.worldEnemyLiveAnchorUnit = nil
    self.worldEnemyLiveLastReason = reason or "hidden"
    -- Always restore the independent addon-owned screen target after any
    -- detach attempt, even when hiding our world frame is refused.
    local function refreshScreenFallback()
        if not hadWorldOwner then return end
        self.worldEnemyScreenFallbackRefreshes =
            (self.worldEnemyScreenFallbackRefreshes or 0) + 1
        self:UpdateTarget()
    end
    local frame = self.worldEnemyLiveFrame
    if not frame then refreshScreenFallback(); return true end
    if not ordinaryOwnedUnprotected(frame) then
        self.worldEnemyLiveFailures = self.worldEnemyLiveFailures + 1
        self.worldEnemyLiveLastReason = "hide-protected-deferred"
        refreshScreenFallback()
        return false
    end
    local ok = pcall(frame.Hide, frame)
    if not ok then
        self.worldEnemyLiveFailures = self.worldEnemyLiveFailures + 1
        self.worldEnemyLiveLastReason = "hide-refused"
    end
    refreshScreenFallback()
    return ok
end

function HUD:UpdateLiveWorldEnemyValues()
    if not self.worldEnemyLiveVisible then return false end
    local frame = self.worldEnemyLiveFrame
    if not frame or not ordinaryOwnedUnprotected(frame) then
        return false
    end
    -- Secret-capable identity and percentage flow only to native consumers.
    local ok = pcall(function()
        frame.enemyNameText:SetText(UnitName("target"))
        local health = UnitHealthPercent("target", true, self.percentScaleCurve)
        frame.enemyHealthBar.status:SetValue(health)
        frame.enemyHealthText:SetFormattedText("%.0f%%", health)
    end)
    if not ok then
        self.worldEnemyLiveFailures = self.worldEnemyLiveFailures + 1
        self:HideLiveWorldEnemy("native-unit-consumer-refused")
    end
    return ok
end

function HUD:RefreshLiveWorldEnemy(event, eventUnit)
    if not self.worldEnemyLiveRequested then return false, "not-requested" end
    local preferences = Logres:GetPreferences()
    if preferences.immersionEnabled ~= true then
        self:HideLiveWorldEnemy("immersion-off")
        return false, self.worldEnemyLiveLastReason
    end
    if not self.worldEnemyLiveFrame then
        self.worldEnemyLiveLastReason = "build-pending-ooc"
        return false, self.worldEnemyLiveLastReason
    end
    if not ordinaryOutOfCombat() and not ordinaryInCombat() then
        self:HideLiveWorldEnemy("combat-state-unavailable")
        return false, self.worldEnemyLiveLastReason
    end
    local probe = Logres:GetModule("WorldTargetProbe")
    if not probe or type(probe.AcquireLiveEnemyTargetAnchor) ~= "function" then
        self:HideLiveWorldEnemy("probe-unavailable")
        return false, self.worldEnemyLiveLastReason
    end
    local requestedUnit
    if event == "NAME_PLATE_UNIT_ADDED" then requestedUnit = eventUnit end
    local anchor, why, anchorUnit = probe:AcquireLiveEnemyTargetAnchor(
        requestedUnit, event == "NAME_PLATE_UNIT_ADDED")
    if not anchor then
        -- Another unit gaining a nameplate must not hide the selected unit.
        if why ~= "not-current-target" then self:HideLiveWorldEnemy(why) end
        return false, why
    end
    local frame = self.worldEnemyLiveFrame
    if not ordinaryOwnedUnprotected(frame) then
        self:HideLiveWorldEnemy("owned-frame-protected")
        return false, self.worldEnemyLiveLastReason
    end
    -- This is the only experimental combat attachment step. It touches an
    -- addon-owned unprotected frame, never the native nameplate. A refused
    -- protected operation leaves the normal screen-space fallback usable.
    local ok = pcall(function()
        frame:Hide()
        frame:ClearAllPoints()
        -- P0442: place the owned display in the plate's native anchor
        -- region, rather than 6px above its TOP. Native children and
        -- their click regions are intentionally never read or changed.
        frame:SetPoint("CENTER", anchor, "CENTER", 0, 0)
    end)
    if not ok then
        self.worldEnemyLiveFailures = self.worldEnemyLiveFailures + 1
        self:HideLiveWorldEnemy("owned-attach-refused")
        return false, self.worldEnemyLiveLastReason
    end
    self.worldEnemyLiveVisible = true
    -- Only an ordinary, event-validated nameplate token may be retained
    -- for matching removal events. A target-query anchor is unknown here;
    -- removal of any plate then conservatively hides the owned display.
    self.worldEnemyLiveAnchorUnit = anchorUnit
    if not self:UpdateLiveWorldEnemyValues() then
        return false, self.worldEnemyLiveLastReason
    end
    local auras = Logres:GetModule("StatusAuras")
    if auras and type(auras.RefreshWorldEnemyLiveSource) == "function" then
        -- The anchor's event-time target may differ from the last cached
        -- UNIT_AURA scan. Refresh only the addon-owned ordinary aura source;
        -- do not mutate native aura activation inside combat.
        auras:RefreshWorldEnemyLiveSource("world-enemy-attach")
    elseif auras and type(auras.RefreshWorldEnemyLiveLanes) == "function" then
        -- Keep the pre-P0448 renderer available if the source capability
        -- is not installed; no native aura container is touched.
        auras:RefreshWorldEnemyLiveLanes()
    end
    local nativeOwned, nativeReason = self:ClaimNativeEnemyDecor(anchor)
    if not nativeOwned then
        self.worldEnemyNativeLastResult = nativeReason
        self:HideLiveWorldEnemy("native-decor-unavailable")
        return false, nativeReason
    end
    if not pcall(frame.Show, frame) then
        self.worldEnemyLiveFailures = self.worldEnemyLiveFailures + 1
        self:HideLiveWorldEnemy("owned-show-refused")
        return false, self.worldEnemyLiveLastReason
    end
    self.worldEnemyLiveAttachments = self.worldEnemyLiveAttachments + 1
    self.worldEnemyLiveCombatAttaches = self.worldEnemyLiveCombatAttaches
        + (ordinaryInCombat() and 1 or 0)
    -- Only after Show succeeds may the world copy replace screen-space
    -- presentation. Native nameplate visuals, casts and click owners remain.
    self.targetFrame:Show() -- Preserve its independent cast cue child.
    self.targetNameText:Hide()
    self.targetHealthBar:Hide()
    -- Preserve the cast cue and the entire Blizzard target/plate input.
    -- Only the addon-created screen aura copy receives reversible alpha.
    if auras and type(auras.SetWorldEnemyScreenAuraHandoff) == "function" then
        auras:SetWorldEnemyScreenAuraHandoff(true)
    end
    self.worldEnemyScreenHandoffs = (self.worldEnemyScreenHandoffs or 0) + 1
    self.worldEnemyLiveLastReason = "owned-target-attached"
    return true, self.worldEnemyLiveLastReason
end

function HUD:SetLiveWorldEnemy(enabled)
    if enabled then
        if not ordinaryOutOfCombat() then
            self.worldEnemyLiveLastReason = "enable-requires-ooc"
            return false, self.worldEnemyLiveLastReason
        end
        local built, reason = self:BuildLiveWorldEnemy()
        if not built then
            self.worldEnemyLiveLastReason = reason
            return false, reason
        end
        -- P0456: P0454/P0455 live secondary alpha ownership failed visual
        -- acceptance. Keep the selected 100% display, but do not arm an
        -- automatic 50% takeover on World Enemy ON. The ordinary threat
        -- probe and its event counters remain independent and read-only.
        -- Restore any earlier claim before leaving this experiment idle.
        self.worldEnemySecondaryTrialArmed = false
        self:HideSecondaryAggroTrial("secondary-trial-suspended")
        self.worldEnemyLiveRequested = true
        return self:RefreshLiveWorldEnemy("manual")
    end
    self.worldEnemyLiveRequested = false
    self.worldEnemySecondaryTrialArmed = false
    self:HideSecondaryAggroTrial("off")
    local stopped = self:HideLiveWorldEnemy("off")
    return stopped, self.worldEnemyLiveLastReason
end

function HUD:SetEnemyDisplayPreview(enabled)
    if enabled and not self.enemyDisplayPreview then
        self:BuildEnemyDisplayPreview()
    end
    if self.enemyDisplayPreview then
        if enabled then
            -- Always defer real attachment and use only owned sample auras.
            local auras = Logres:GetModule("StatusAuras")
            if auras and type(auras.CreateEnemyFixtureLanes) == "function" then
                for index, frame in ipairs(self.enemyPreviewUnits) do
                    auras:CreateEnemyFixtureLanes(frame, index)
                end
            end
        end
        self.enemyDisplayPreview:SetShown(enabled == true)
    end
    self.enemyPreviewVisible = enabled == true
    return true
end

function HUD:OnInitialize()
    self.worldEnemyLiveRequested = false
    self.worldEnemyLiveVisible = false
    self.worldEnemyLiveLastReason = "off"
    self.worldEnemyLiveAttachments = 0
    self.worldEnemyLiveCombatAttaches = 0
    self.worldEnemyLiveFailures = 0
    self.worldEnemyLiveDetaches = 0
    self.worldEnemyScreenHandoffs = 0
    self.worldEnemyScreenFallbackRefreshes = 0
    self.worldEnemyNativeClaim = nil
    self.worldEnemyNativeTransfers = 0
    self.worldEnemyNativeRestoreCount = 0
    self.worldEnemyNativeRestoreFailures = 0
    self.worldEnemyNativeLastResult = "not-attempted"
    self.worldEnemyNativeAuraOwned = false
    self.worldEnemyNativeAuraLastResult = "not-attempted"
    self.worldEnemyNativeAuraTransfers = 0
    self.worldEnemyNativeAuraRestores = 0
    self.worldEnemyLiveAnchorUnit = nil
    self.worldEnemyLiveRemovalResult = "none"
    self.worldEnemySecondaryTrialArmed = false
    self.worldEnemySecondaryTrialFrame = nil
    self.worldEnemySecondaryTrialUnit = nil
    self.worldEnemySecondaryTrialClaim = nil
    self.worldEnemySecondaryTrialVisible = false
    self.worldEnemySecondaryTrialEligibleEvents = 0
    self.worldEnemySecondaryTrialAttachments = 0
    self.worldEnemySecondaryTrialDetaches = 0
    self.worldEnemySecondaryTrialFailures = 0
    self.worldEnemySecondaryTrialRestores = 0
    self.worldEnemySecondaryTrialRestoreFailures = 0
    self.worldEnemySecondaryTrialLastResult = "disabled"
    self.worldEnemySecondaryTrialLastDetachReason = "none"
    self.worldEnemySecondaryTrialIgnoredUnrelatedEvents = 0
    self.worldTrialRequested = false
    self.worldTrialVisible = false
    self.worldTrialCombatHidden = false
    self.worldTrialLastReason = "off"
    self.worldTrialAttachCount = 0
    self.worldTrialFailures = 0
    local root = CreateFrame("Frame", "LogresHUDRoot", UIParent)
    root:SetAllPoints(UIParent)
    root:SetFrameStrata("BACKGROUND")
    root:SetFrameLevel(20)
    root:EnableMouse(false)
    root:Hide()

    self.root = root
    self.previewEnabled = false
    self.previewPercent = nil
    self.deathTravelMode = false
    self.healthBands = {}
    self.pvpPreviewEnabled = false
    self.playerPvPObserved = "unknown"
    self.targetPvPObserved = "unknown"
    self.healthTextureCount = 0

    for index = 1, #HEALTH_BANDS do
        local spec = HEALTH_BANDS[index]
        local band = {
            name = spec.name,
            assetKey = spec.assetKey,
            points = spec.points,
            fallbackColor = spec.fallbackColor,
            curve = createCurve(spec.points),
        }

        band.texture =
            createHealthTunnelTexture(root, band)

        self.healthTextureCount =
            self.healthTextureCount + 1

        self.healthBands[#self.healthBands + 1] = band
    end

    self.curvesReady = #self.healthBands == #HEALTH_BANDS

    self.percentScaleCurve = createScaleTo100Curve()

    local resourceBar = createPercentageBar(
        root,
        "LogresHUDResourceBar",
        "resource",
        percentageBarColors.alternate or DEFAULT_RESOURCE_COLOR
    )
    resourceBar:SetPoint("CENTER", root, "CENTER", 0, -118)
    Logres.Layout.Bind(resourceBar, "playerReaction", "CENTER", "CENTER")

    self.resourceBar = resourceBar
    self.resourceText = resourceBar.percentText

    local playerPvPBadge = createPvPBadge(root)
    playerPvPBadge:SetPoint("LEFT", resourceBar, "RIGHT", 8, 0)
    self.playerPvPBadge = playerPvPBadge

    local targetFrame = CreateFrame("Frame", "LogresHUDTarget", root)
    targetFrame:SetSize(198, 54)
    targetFrame:SetPoint("CENTER", root, "CENTER", 0, -54)
    Logres.Layout.Bind(targetFrame, "targetFallback", "CENTER", "CENTER")
    targetFrame:Hide()

    local targetNameText = targetFrame:CreateFontString(
        "LogresHUDTargetName",
        "OVERLAY",
        "GameFontNormal"
    )
    targetNameText:SetPoint("TOP", targetFrame, "TOP", 0, 0)
    local enemyNameColor = hudTypography.targetName or { 0.97, 0.91, 0.80, 1.00 }
    targetNameText:SetTextColor(
        enemyNameColor[1], enemyNameColor[2],
        enemyNameColor[3], enemyNameColor[4]
    )
    targetNameText:SetShadowColor(0, 0, 0, 0.96)
    targetNameText:SetShadowOffset(1, -1)
    targetNameText:SetJustifyH("CENTER")
    targetNameText:SetWidth(190)
    -- Shared target typography is used by the independent preview fixtures.
    styleEnemyNameText(targetNameText)

    local targetHealthBar = createPercentageBar(
        targetFrame,
        "LogresHUDTargetHealthBar",
        "normal",
        percentageBarColors.targetHealth or DEFAULT_TARGET_COLOR
    )
    targetHealthBar:SetPoint("TOP", targetNameText, "BOTTOM", 0, -4)
    -- Approved sparse name/bar identity; decorative HP underline retired in P0437.

    local targetPvPBadge = createPvPBadge(root)
    targetPvPBadge:SetPoint("TOPLEFT", targetFrame, "TOPRIGHT", 4, -1)
    self.targetPvPBadge = targetPvPBadge

    self.targetFrame = targetFrame
    self.targetNameText = targetNameText
    self.targetHealthBar = targetHealthBar
    self.targetHealthText = targetHealthBar.percentText

    local playerCastCue = createCastCue(root, "LogresHUDPlayerCastCue")
    playerCastCue:SetPoint("RIGHT", resourceBar, "LEFT", -12, 0)

    local targetCastCue = createCastCue(
        targetFrame,
        "LogresHUDTargetCastCue"
    )
    targetCastCue:SetPoint("TOP", targetFrame, "BOTTOM", 0, -6)

    self.playerCastCue = playerCastCue
    self.targetCastCue = targetCastCue

    local allyAnchor = CreateFrame("Frame", "LogresHUDAllies", root)
    allyAnchor:SetSize(190, 118)
    allyAnchor:SetPoint("CENTER", root, "CENTER", -330, -44)
    Logres.Layout.Bind(allyAnchor, "allies", "CENTER", "CENTER")

    self.allyAnchor = allyAnchor
    self.allyRows = {}
    self.allyRowsByUnit = {}

    for index = 1, #ALLY_UNITS do
        local unit = ALLY_UNITS[index]
        local rowFrame = CreateFrame("Frame", nil, allyAnchor)
        rowFrame:SetSize(184, 20)
        rowFrame:SetPoint(
            "TOPLEFT",
            allyAnchor,
            "TOPLEFT",
            0,
            -((index - 1) * 23)
        )
        rowFrame:Hide()

        local nameText = rowFrame:CreateFontString(
            nil,
            "OVERLAY",
            "GameFontNormalSmall"
        )
        nameText:SetPoint("LEFT", rowFrame, "LEFT", 0, 0)
        nameText:SetWidth(80)
        nameText:SetJustifyH("LEFT")
        local allyNameColor = hudTypography.allyName or { 0.89, 0.84, 0.74, 1.00 }
        local nameColor = unit == "pet"
            and (hudTypography.petName or allyNameColor) or allyNameColor
        nameText:SetTextColor(
            nameColor[1], nameColor[2],
            nameColor[3], nameColor[4]
        )
        nameText:SetShadowColor(0, 0, 0, 0.94)
        nameText:SetShadowOffset(1, -1)
        local rowAccentColor = unit == "pet"
            and (hudTypography.petAccent or { 0.73, 0.51, 0.27, 0.82 })
            or (hudTypography.allyAccent or { 0.46, 0.34, 0.20, 0.65 })
        local rowAccent = rowFrame:CreateTexture(nil, "ARTWORK")
        rowAccent:SetPoint("BOTTOMLEFT", rowFrame, "BOTTOMLEFT", 0, 2)
        rowAccent:SetSize(52, 1)
        rowAccent:SetColorTexture(
            rowAccentColor[1], rowAccentColor[2],
            rowAccentColor[3], rowAccentColor[4]
        )

        local healthBar = createPercentageBar(
            rowFrame,
            nil,
            "compact",
            percentageBarColors.allyHealth or DEFAULT_ALLY_COLOR
        )
        healthBar:SetPoint("RIGHT", rowFrame, "RIGHT", 0, 0)

        local healthText = healthBar.percentText

        local row = {
            unit = unit,
            frame = rowFrame,
            nameText = nameText,
            healthBar = healthBar,
            healthText = healthText,
        }

        self.allyRows[#self.allyRows + 1] = row
        self.allyRowsByUnit[unit] = row
    end

    local healthEventFrame = CreateFrame("Frame")
    healthEventFrame:SetScript("OnEvent", function(_, event, unit)
        if event == "PLAYER_DEAD" or event == "PLAYER_ALIVE"
            or event == "PLAYER_UNGHOST" or event == "PLAYER_ENTERING_WORLD"
        then
            self:RefreshDeathTravelState(event)
            return
        end
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
    targetEventFrame:SetScript("OnEvent", function(_, event, unit)
        if unit and unit ~= "target" then
            return
        end

        self:UpdateTarget()
        -- TARGET_CHANGED may run before the world-lifecycle handler. Do
        -- not push the NEW target's identity/health into an OLD anchor.
        -- The lifecycle handler first hides, then validates/reattaches.
        if event ~= "PLAYER_TARGET_CHANGED" then
            self:UpdateLiveWorldEnemyValues()
        end
    end)

    self.targetEventFrame = targetEventFrame

    local worldTrialEvents = CreateFrame("Frame")
    worldTrialEvents:SetScript("OnEvent", function(_, event, unit)
        if event == "PLAYER_REGEN_ENABLED" then
            self:HideSecondaryAggroTrial("secondary-combat-ended")
        elseif event == "PLAYER_TARGET_CHANGED" then
            self:HideSecondaryAggroTrial("secondary-target-changed")
        end
        if event == "PLAYER_REGEN_ENABLED" and self.worldEnemyNativeClaim
            and not self.worldEnemyLiveVisible then
            self:RestoreNativeEnemyDecor()
        end
        if event == "PLAYER_REGEN_DISABLED" then
            -- No frame mutation during combat. Secure state driver owns hide.
            self.worldTrialCombatHidden = true
            self.worldTrialVisible = false
            self.worldTrialLastReason = "combat-state-driver"
        elseif self.worldTrialRequested then
            self:RefreshWorldTargetTrial(event)
        end
        if self.worldEnemyLiveRequested then
            if event == "NAME_PLATE_UNIT_REMOVED" then
                local probe = Logres:GetModule("WorldTargetProbe")
                local relevant, reason = true, "unverified-removal"
                if probe and type(probe.IsLiveEnemyRemovalRelevant) == "function" then
                    relevant, reason = probe:IsLiveEnemyRemovalRelevant(
                        unit, self.worldEnemyLiveAnchorUnit)
                end
                self.worldEnemyLiveRemovalResult = reason
                if relevant then
                    -- Do NOT reacquire on a REMOVED event: the native API
                    -- may still return a stale anchor in the same dispatch.
                    self:HideLiveWorldEnemy("nameplate-removed")
                end
            elseif event == "PLAYER_TARGET_CHANGED" then
                -- Clear the old identity/anchor before considering a new one.
                self:HideLiveWorldEnemy("target-changed")
                self:RefreshLiveWorldEnemy(event)
            elseif event == "NAME_PLATE_UNIT_ADDED" then
                -- Event token is screened inside WorldTargetProbe.
                self:RefreshLiveWorldEnemy(event, unit)
            elseif event ~= "PLAYER_REGEN_DISABLED" then
                self:RefreshLiveWorldEnemy(event)
            end
        end
    end)
    self.worldTrialEvents = worldTrialEvents

    -- P0454: health/name events for the one currently attached secondary.
    -- No timer, polling or nameplate enumeration; no unit token inspected
    -- before the probe's ordinary-token gate.
    local secondaryValueEvents = CreateFrame("Frame")
    secondaryValueEvents:SetScript("OnEvent", function(_, _, eventUnit)
        if not self.worldEnemySecondaryTrialVisible then return end
        local probe = Logres:GetModule("WorldTargetProbe")
        if not probe then return end
        local unit = probe:OrdinaryEventNameplateToken(eventUnit)
        if unit and unit == self.worldEnemySecondaryTrialUnit then
            self:UpdateSecondaryAggroTrialValues(unit)
        end
    end)
    self.secondaryValueEvents = secondaryValueEvents

    local pvpEventFrame = CreateFrame("Frame")
    pvpEventFrame:SetScript("OnEvent", function()
        -- Ignore event payloads. Re-evaluate both ordinary booleans only.
        self:RefreshPvPIndicators()
    end)
    self.pvpEventFrame = pvpEventFrame

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

    self.allyEventFrames = {}

    for index = 1, #ALLY_UNITS do
        local unit = ALLY_UNITS[index]
        local allyEventFrame = CreateFrame("Frame")

        allyEventFrame:SetScript("OnEvent", function(_, _, eventUnit)
            if eventUnit and eventUnit ~= unit then
                return
            end

            self:UpdateAllyUnit(unit)
        end)

        allyEventFrame.unit = unit

        self.allyEventFrames[#self.allyEventFrames + 1] =
            allyEventFrame
    end

    local allyRosterEventFrame = CreateFrame("Frame")
    allyRosterEventFrame:SetScript("OnEvent", function()
        self:UpdateAllies()
    end)

    self.allyRosterEventFrame = allyRosterEventFrame
end

function HUD:OnEnable()
    self.healthEventFrame:RegisterUnitEvent("UNIT_HEALTH", "player")
    self.healthEventFrame:RegisterUnitEvent("UNIT_MAXHEALTH", "player")
    self.healthEventFrame:RegisterEvent("PLAYER_DEAD")
    self.healthEventFrame:RegisterEvent("PLAYER_ALIVE")
    self.healthEventFrame:RegisterEvent("PLAYER_UNGHOST")
    self.healthEventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")

    self.resourceEventFrame:RegisterUnitEvent(
        "UNIT_POWER_FREQUENT",
        "player"
    )
    self.resourceEventFrame:RegisterUnitEvent(
        "UNIT_MAXPOWER",
        "player"
    )
    self.resourceEventFrame:RegisterUnitEvent(
        "UNIT_DISPLAYPOWER",
        "player"
    )

    self.targetEventFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
    self.pvpEventFrame:RegisterEvent("PLAYER_FLAGS_CHANGED")
    self.pvpEventFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
    self.pvpEventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
    self.pvpEventFrame:RegisterUnitEvent("UNIT_FACTION", "player", "target")
    self.pvpEventFrame:RegisterUnitEvent("UNIT_FLAGS", "player", "target")
    self.targetEventFrame:RegisterUnitEvent("UNIT_HEALTH", "target")
    self.targetEventFrame:RegisterUnitEvent("UNIT_MAXHEALTH", "target")
    self.targetEventFrame:RegisterUnitEvent("UNIT_NAME_UPDATE", "target")

    for _, event in ipairs({"PLAYER_TARGET_CHANGED", "NAME_PLATE_UNIT_ADDED",
        "NAME_PLATE_UNIT_REMOVED", "NAME_PLATE_UNIT_BEHIND_CAMERA_CHANGED",
        "PLAYER_REGEN_DISABLED", "PLAYER_REGEN_ENABLED"}) do
        self.worldTrialEvents:RegisterEvent(event)
    end

    for _, event in ipairs({"UNIT_HEALTH", "UNIT_MAXHEALTH",
        "UNIT_NAME_UPDATE"}) do
        self.secondaryValueEvents:RegisterEvent(event)
    end

    for index = 1, #CAST_EVENTS do
        local event = CAST_EVENTS[index]
        self.playerCastEventFrame:RegisterUnitEvent(event, "player")
        self.targetCastEventFrame:RegisterUnitEvent(event, "target")
    end

    self.targetCastEventFrame:RegisterEvent("PLAYER_TARGET_CHANGED")

    for index = 1, #self.allyEventFrames do
        local allyEventFrame = self.allyEventFrames[index]
        local unit = allyEventFrame.unit

        allyEventFrame:RegisterUnitEvent("UNIT_HEALTH", unit)
        allyEventFrame:RegisterUnitEvent("UNIT_MAXHEALTH", unit)
        allyEventFrame:RegisterUnitEvent("UNIT_NAME_UPDATE", unit)
    end

    self.allyRosterEventFrame:RegisterEvent("GROUP_ROSTER_UPDATE")
    self.allyRosterEventFrame:RegisterUnitEvent("UNIT_PET", "player")

    self:OwnCleanup(function()
        self.healthEventFrame:UnregisterAllEvents()
        self.resourceEventFrame:UnregisterAllEvents()
        self.targetEventFrame:UnregisterAllEvents()
        self.worldTrialEvents:UnregisterAllEvents()
        self.secondaryValueEvents:UnregisterAllEvents()
        self.pvpEventFrame:UnregisterAllEvents()
        self.playerCastEventFrame:UnregisterAllEvents()
        self.targetCastEventFrame:UnregisterAllEvents()

        for index = 1, #self.allyEventFrames do
            self.allyEventFrames[index]:UnregisterAllEvents()
        end

        self.allyRosterEventFrame:UnregisterAllEvents()
    end)

    self:SubscribePreferences(function(current)
        self:ApplyImmersionPreference(current)
    end)

    self:RefreshDeathTravelState("initial")
    self:ApplyImmersionPreference(Logres:GetPreferences())
end

function HUD:OnDisable()
    self:SetLiveWorldEnemy(false)
    self:SetWorldTargetTrial(false)
    self:SetEnemyDisplayPreview(false)
    self.previewEnabled = false
    self.previewPercent = nil
    self.pvpPreviewEnabled = false
    self.playerPvPBadge:Hide()
    self.targetPvPBadge:Hide()
    hideCastCue(self.playerCastCue, true)
    hideCastCue(self.targetCastCue, true)
    self.targetFrame:Hide()

    for index = 1, #self.allyRows do
        self.allyRows[index].frame:Hide()
    end

    self.root:Hide()
end

-- P0354: original command-invoked HUD structural diagnostic.
function HUD:RunDevHUDCheck(emit, boolText)
    local status = Logres:GetModuleStatus("HUD")
    local hud = Logres:GetModule("HUD")
    local debugStatus = hud:GetDebugStatus()

    local visibilityMatchesPreference =
        debugStatus.rootShown == debugStatus.immersionEnabled

    local passed =
        status.initialized == true
        and status.enabled == true
        and debugStatus.moduleEnabled == true
        and debugStatus.bandCount == 5
        and debugStatus.textureCount == 5
        and debugStatus.curvesReady == true
        and debugStatus.resourceTextReady == true
        and debugStatus.resourceCurveReady == true
        and debugStatus.targetFrameReady == true
        and debugStatus.targetNameTextReady == true
        and debugStatus.targetHealthTextReady == true
        and debugStatus.targetEventFrameReady == true
        and debugStatus.playerCastCueReady == true
        and debugStatus.targetCastCueReady == true
        and debugStatus.playerCastEventFrameReady == true
        and debugStatus.targetCastEventFrameReady == true
        and debugStatus.allyRowCount == 5
        and debugStatus.allyEventFrameCount == 5
        and debugStatus.allyRosterEventFrameReady == true
        and visibilityMatchesPreference

    if passed then
        emit(string.format(
            "Logres hudcheck: PASS (bands=5 textures=5 tunnel=true curves=true resourceText=true resourceCurve=true target=true casts=true allies=5 immersion=%s visible=%s)",
            boolText(debugStatus.immersionEnabled),
            boolText(debugStatus.rootShown)
        ))
        return
    end

    emit(string.format(
        "Logres hudcheck: FAIL (initialized=%s enabled=%s moduleEnabled=%s bands=%s textures=%s curves=%s resourceText=%s resourceCurve=%s targetFrame=%s targetName=%s targetHealth=%s targetEvents=%s playerCast=%s targetCast=%s playerCastEvents=%s targetCastEvents=%s allyRows=%s allyEvents=%s allyRoster=%s immersion=%s visible=%s visibilityMatches=%s)",
        tostring(status.initialized),
        tostring(status.enabled),
        tostring(debugStatus.moduleEnabled),
        tostring(debugStatus.bandCount),
        tostring(debugStatus.textureCount),
        tostring(debugStatus.curvesReady),
        tostring(debugStatus.resourceTextReady),
        tostring(debugStatus.resourceCurveReady),
        tostring(debugStatus.targetFrameReady),
        tostring(debugStatus.targetNameTextReady),
        tostring(debugStatus.targetHealthTextReady),
        tostring(debugStatus.targetEventFrameReady),
        tostring(debugStatus.playerCastCueReady),
        tostring(debugStatus.targetCastCueReady),
        tostring(debugStatus.playerCastEventFrameReady),
        tostring(debugStatus.targetCastEventFrameReady),
        tostring(debugStatus.allyRowCount),
        tostring(debugStatus.allyEventFrameCount),
        tostring(debugStatus.allyRosterEventFrameReady),
        tostring(debugStatus.immersionEnabled),
        tostring(debugStatus.rootShown),
        tostring(visibilityMatchesPreference)
    ))
end
