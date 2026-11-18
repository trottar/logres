local _, Logres = ...

-- Full helpful source, including effects from other casters. Guard every
-- ordinary index; a bounded/secret scan never certifies complete coverage.
local FILTER = "HELPFUL"
local MAX_SCAN = 40
local MAX_ICONS = 40
local COLUMNS = 4

local HelpfulAuras = Logres:RegisterModule("PlayerHelpfulAuras", {
    autoEnable = true,
})

local theme = Logres.Theme or {}
local auraStyle = theme.playerHelpfulAuras or {}
local auraAssets = auraStyle.assets or {}
local auraColors = auraStyle.colors or {}

local DEFAULT_STYLE = {
    iconSize = 36,
    iconInset = 4,
    frameOverscan = 2,
    gap = 7,
    x = 118,
    y = -118,
    countWidth = 24,
    countHeight = 16,
    countFont = "GameFontHighlightSmall",
}

local DEFAULT_COLORS = {
    countText = { 0.96, 0.92, 0.82, 1.00 },
}

local PREVIEW_AURAS = {
    {
        icon = "Interface\\Icons\\Spell_Shadow_DemonArmor",
        applications = 1,
    },
    {
        icon = "Interface\\Icons\\Spell_Nature_Regeneration",
        applications = 3,
    },
    {
        icon = "Interface\\Icons\\Spell_Holy_MagicalSentry",
        applications = 12,
    },
    {
        icon = "Interface\\Icons\\Spell_Nature_LightningShield",
        applications = 1,
    },
    -- Nine preview icons exercise four-column wrapping without gameplay.
    { icon = "Interface\\Icons\\Spell_Nature_HealingTouch", applications = 2 },
    { icon = "Interface\\Icons\\Spell_Holy_PowerWordShield", applications = 1 },
    { icon = "Interface\\Icons\\Spell_Nature_Rejuvenation", applications = 1 },
    { icon = "Interface\\Icons\\Spell_Nature_ResistNature", applications = 3 },
    { icon = "Interface\\Icons\\Spell_Holy_DivineSpirit", applications = 1 },
}

local function styleValue(name)
    local value = auraStyle[name]

    if value ~= nil then
        return value
    end

    return DEFAULT_STYLE[name]
end

local function colorValue(name)
    return auraColors[name] or DEFAULT_COLORS[name]
end

local function hasSecretChecker()
    return type(issecretvalue) == "function"
end

local function isSecret(value)
    if not hasSecretChecker() then
        return true
    end

    local ok, result = pcall(issecretvalue, value)

    if not ok then
        return true
    end

    return result == true
end

local function sourceAvailable()
    return hasSecretChecker()
        and C_Secrets
        and type(
            C_Secrets.ShouldUnitAuraIndexBeSecret
        ) == "function"
        and C_UnitAuras
        and type(
            C_UnitAuras.GetAuraDataByIndex
        ) == "function"
end

local function readAura(index)
    if not sourceAvailable() then
        return nil, "api-unavailable", "failure"
    end

    local predicateOK, predicateResult = pcall(
        C_Secrets.ShouldUnitAuraIndexBeSecret,
        "player",
        index,
        FILTER
    )

    if not predicateOK then
        return nil, "predicate-call-failed", "failure"
    end

    if isSecret(predicateResult) then
        return nil, "predicate-result-secret", "secret"
    end

    if predicateResult ~= false then
        if predicateResult == true then
            return nil, "aura-index-secret", "secret"
        end

        return nil, "predicate-indeterminate", "failure"
    end

    local queryOK, aura = pcall(
        C_UnitAuras.GetAuraDataByIndex,
        "player",
        index,
        FILTER
    )

    if not queryOK then
        return nil, "query-call-failed", "failure"
    end

    if isSecret(aura) then
        return nil, "aura-payload-secret", "secret"
    end

    if aura == nil then
        return nil, "empty", "empty"
    end

    if type(aura) ~= "table" then
        return nil, "aura-payload-invalid", "failure"
    end

    local icon = aura.icon

    if isSecret(icon) then
        return nil, "icon-secret", "secret"
    end

    if icon == nil then
        return nil, "icon-unavailable", "failure"
    end

    local iconType = type(icon)

    if iconType ~= "number"
        and iconType ~= "string"
    then
        return nil, "icon-invalid", "failure"
    end

    local applications = aura.applications
    local applicationsSecret = isSecret(applications)

    if applicationsSecret then
        applications = nil
    elseif applications ~= nil
        and type(applications) ~= "number"
    then
        applications = nil
    end

    return {
        index = index,
        icon = icon,
        applications = applications,
        applicationsSecret = applicationsSecret,
    }, "ordinary", "ordinary"
end

function HelpfulAuras:ReadSnapshot()
    local snapshot = {
        auras = {},
        secretSkips = 0,
        secretFields = 0,
        failures = 0,
        lastError = nil,
        scanExhausted = false,
    }

    for index = 1, MAX_SCAN do
        local aura, reason, state = readAura(index)
        if index == MAX_SCAN and state ~= "empty" then
            snapshot.scanExhausted = true
        end

        if state == "empty" then
            break
        end

        if state == "failure" then
            snapshot.failures = snapshot.failures + 1
            snapshot.lastError = reason
        elseif state == "secret" then
            snapshot.secretSkips =
                snapshot.secretSkips + 1
        elseif state == "ordinary" then
            if aura.applicationsSecret == true then
                snapshot.secretFields =
                    snapshot.secretFields + 1
            end

            if #snapshot.auras < MAX_ICONS then
                snapshot.auras[#snapshot.auras + 1] =
                    aura
            end
        end
    end

    return snapshot
end

local function setSlotAura(slot, aura)
    slot.auraIndex = aura.index
    slot.icon:SetTexture(aura.icon)
    slot.icon:Show()

    local applications = aura.applications

    if applications ~= nil
        and applications > 1
    then
        slot.count:SetFormattedText(
            "%.0f",
            applications
        )
        slot.countRoot:Show()
    else
        slot.count:ClearText()
        slot.countRoot:Hide()
    end

    slot.frame:Show()
end

local function clearSlot(slot)
    slot.auraIndex = nil
    slot.frame:Hide()
    slot.icon:SetTexture(nil)
    slot.count:ClearText()
    slot.countRoot:Hide()
end

function HelpfulAuras:HidePresentation(reason)
    if self.root then
        self.root:Hide()
    end

    if self.slots then
        for index = 1, #self.slots do
            clearSlot(self.slots[index])
        end
    end

    self.visibleCount = 0
    self.presentationShown = false
    self.lastCoverageReady = false

    if reason then
        self.lastPresentationReason = reason
    end
end

function HelpfulAuras:RenderSnapshot(snapshot, reason)
    local visible = #snapshot.auras

    if visible > MAX_ICONS then
        visible = MAX_ICONS
    end

    for index = 1, MAX_ICONS do
        local slot = self.slots[index]
        local aura = snapshot.auras[index]

        if aura then
            setSlotAura(slot, aura)
        else
            clearSlot(slot)
        end
    end

    self.visibleCount = visible
    self.lastCoverageReady = self.previewEnabled ~= true
        and snapshot.secretSkips == 0 and snapshot.failures == 0
        and snapshot.scanExhausted ~= true
    self.lastScanExhausted = snapshot.scanExhausted == true
    -- The LEFT anchor stays fixed at the original first icon's center;
    -- extra rows grow upward without shifting the approved first row.
    local iconSize = styleValue("iconSize")
    local rows = math.ceil(math.max(visible, 1) / COLUMNS)
    self.root:SetHeight(iconSize + (rows - 1) * (iconSize + styleValue("gap")))
    self.lastSecretSkipCount =
        snapshot.secretSkips or 0
    self.lastSecretFieldCount =
        snapshot.secretFields or 0
    self.lastFailureCount =
        snapshot.failures or 0
    self.lastError = snapshot.lastError
    self.lastPresentationReason = reason

    local preferences = Logres:GetPreferences()
    local shouldShow =
        preferences.immersionEnabled == true
        and visible > 0

    if shouldShow then
        self.root:Show()
        self.presentationShown = true
    else
        self.root:Hide()
        self.presentationShown = false
    end
end

function HelpfulAuras:BuildPreviewSnapshot()
    local auras = {}

    for index = 1, #PREVIEW_AURAS do
        auras[index] = PREVIEW_AURAS[index]
    end

    return {
        auras = auras,
        secretSkips = 0,
        secretFields = 0,
        failures = 0,
        lastError = nil,
        scanExhausted = false,
    }
end

function HelpfulAuras:SetPreviewEnabled(enabled)
    self.previewEnabled = enabled == true

    if self.previewEnabled then
        self.previewCount = self.previewCount + 1
        self:RenderSnapshot(
            self:BuildPreviewSnapshot(),
            "preview"
        )
        return true, "preview"
    end

    self:Refresh("preview-off")
    return true, "live"
end

function HelpfulAuras:Refresh(reason)
    self.refreshCount = self.refreshCount + 1
    self.lastRefreshReason = reason

    if self.previewEnabled then
        return true, "preview-active"
    end

    local preferences = Logres:GetPreferences()

    if preferences.immersionEnabled ~= true then
        self:HidePresentation("immersion-off")
        return true, "immersion-off"
    end

    local snapshot = self:ReadSnapshot()

    if snapshot.failures > 0 then
        self.lastSecretSkipCount =
            snapshot.secretSkips
        self.lastSecretFieldCount =
            snapshot.secretFields
        self.lastFailureCount =
            snapshot.failures
        self.lastError = snapshot.lastError
        self:HidePresentation("source-failure")
        return false, "source-failure"
    end

    self:RenderSnapshot(snapshot, reason)

    if #snapshot.auras == 0 then
        return true, "empty"
    end

    return true, "shown"
end

function HelpfulAuras:ApplyPreferences(preferences)
    if preferences.immersionEnabled ~= true then
        self:HidePresentation("immersion-off")
        return
    end

    if self.previewEnabled then
        self:RenderSnapshot(
            self:BuildPreviewSnapshot(),
            "preview"
        )
        return
    end

    self:Refresh("preference")
end

function HelpfulAuras:GetDebugStatus()
    local preferences = Logres:GetPreferences()

    return {
        moduleEnabled = self.moduleEnabled == true,
        rootReady = self.root ~= nil,
        rootShown =
            self.root ~= nil
            and self.root:IsShown()
            or false,
        immersionEnabled =
            preferences.immersionEnabled == true,
        previewEnabled =
            self.previewEnabled == true,
        slotCount =
            self.slots and #self.slots or 0,
        visibleCount =
            self.visibleCount or 0,
        presentationShown =
            self.presentationShown == true,
        unitAuraRegistered =
            self.unitAuraRegistered == true,
        worldRegistered =
            self.worldRegistered == true,
        restrictionRegistered = self.restrictionRegistered == true,
        restrictionRecoveryCount = self.restrictionRecoveryCount or 0,
        restrictionReconcileCount = self.restrictionReconcileCount or 0,
        restrictionReconcileFailures = self.restrictionReconcileFailures or 0,
        restrictionRecoveryLastReason = self.restrictionRecoveryLastReason,
        restrictionRecoveryLastCoverage =
            self.restrictionRecoveryLastCoverage == true,
        refreshCount =
            self.refreshCount or 0,
        previewCount =
            self.previewCount or 0,
        unitAuraEvents =
            self.unitAuraEvents or 0,
        worldEvents =
            self.worldEvents or 0,
        secretSkipCount =
            self.lastSecretSkipCount or 0,
        secretFieldCount =
            self.lastSecretFieldCount or 0,
        failureCount =
            self.lastFailureCount or 0,
        lastRefreshReason =
            self.lastRefreshReason,
        lastPresentationReason =
            self.lastPresentationReason,
        lastError =
            self.lastError,
        sourceAvailable =
            sourceAvailable() == true,
        coverageReady = self.lastCoverageReady == true,
        scanExhausted = self.lastScanExhausted == true,
        filter = FILTER,
    }
end

function HelpfulAuras:OnInitialize()
    self.moduleEnabled = false
    self.previewEnabled = false
    self.presentationShown = false
    self.visibleCount = 0
    self.lastCoverageReady = false
    self.lastScanExhausted = false
    self.refreshCount = 0
    self.previewCount = 0
    self.unitAuraEvents = 0
    self.worldEvents = 0
    self.restrictionRecoveryCount = 0
    self.restrictionReconcileCount = 0
    self.restrictionReconcileFailures = 0
    self.restrictionRecoveryLastReason = "not-observed"
    self.restrictionRecoveryLastCoverage = false
    self.lastSecretSkipCount = 0
    self.lastSecretFieldCount = 0
    self.lastFailureCount = 0
    self.lastError = nil
    self.lastRefreshReason = "initialize"
    self.lastPresentationReason = "initialize"

    local iconSize = styleValue("iconSize")
    local gap = styleValue("gap")
    local totalWidth =
        (COLUMNS * iconSize)
        + ((COLUMNS - 1) * gap)

    local root = CreateFrame(
        "Frame",
        "LogresPlayerHelpfulAuras",
        UIParent
    )
    root:SetSize(totalWidth, iconSize)
    root:SetPoint(
        "LEFT",
        UIParent,
        "CENTER",
        styleValue("x"),
        styleValue("y")
    )
    Logres.Layout.Bind(root, "passiveStatus", "LEFT", "CENTER")
    root:SetFrameStrata("BACKGROUND")
    root:EnableMouse(false)
    root:Hide()

    self.root = root
    self.slots = {}

    for index = 1, MAX_ICONS do
        local slotFrame = CreateFrame(
            "Frame",
            nil,
            root
        )
        slotFrame:SetSize(iconSize, iconSize)
        local column = (index - 1) % COLUMNS
        local row = math.floor((index - 1) / COLUMNS)
        slotFrame:SetPoint(
            "LEFT", root, "LEFT",
            column * (iconSize + gap),
            row * (iconSize + gap)
        )
        slotFrame:EnableMouse(true)
        slotFrame:Hide()
        slotFrame.logresAuraIndex = index
        slotFrame:SetScript("OnEnter", function(current)
            local slot = self.slots[current.logresAuraIndex]
            if not slot or type(slot.auraIndex) ~= "number"
                or not GameTooltip or type(GameTooltip.SetUnitAura) ~= "function"
            then
                return
            end
            -- The source index was validated by the existing per-index
            -- secret preflight. The native tooltip renders aura internals.
            GameTooltip:SetOwner(current, "ANCHOR_RIGHT")
            GameTooltip:SetUnitAura("player", slot.auraIndex, FILTER)
            GameTooltip:Show()
        end)
        slotFrame:SetScript("OnLeave", function()
            if GameTooltip then
                GameTooltip:Hide()
            end
        end)

        local icon = slotFrame:CreateTexture(
            nil,
            "ARTWORK"
        )
        icon:SetPoint(
            "TOPLEFT",
            slotFrame,
            "TOPLEFT",
            styleValue("iconInset"),
            -styleValue("iconInset")
        )
        icon:SetPoint(
            "BOTTOMRIGHT",
            slotFrame,
            "BOTTOMRIGHT",
            -styleValue("iconInset"),
            styleValue("iconInset")
        )

        local frameTexture = slotFrame:CreateTexture(
            nil,
            "OVERLAY"
        )
        frameTexture:SetPoint(
            "TOPLEFT",
            slotFrame,
            "TOPLEFT",
            -styleValue("frameOverscan"),
            styleValue("frameOverscan")
        )
        frameTexture:SetPoint(
            "BOTTOMRIGHT",
            slotFrame,
            "BOTTOMRIGHT",
            styleValue("frameOverscan"),
            -styleValue("frameOverscan")
        )
        frameTexture:SetTexture(
            auraAssets.frame
            or "Interface\\Buttons\\UI-Quickslot2"
        )

        local countRoot = CreateFrame(
            "Frame",
            nil,
            slotFrame
        )
        countRoot:SetSize(
            styleValue("countWidth"),
            styleValue("countHeight")
        )
        countRoot:SetPoint(
            "BOTTOMRIGHT",
            slotFrame,
            "BOTTOMRIGHT",
            2,
            -1
        )
        countRoot:EnableMouse(false)
        countRoot:Hide()

        local countPlate = countRoot:CreateTexture(
            nil,
            "BACKGROUND"
        )
        countPlate:SetAllPoints(countRoot)
        countPlate:SetTexture(
            auraAssets.countPlate
            or "Interface\\Buttons\\WHITE8x8"
        )

        local count = countRoot:CreateFontString(
            nil,
            "OVERLAY",
            styleValue("countFont")
        )
        count:SetPoint(
            "CENTER",
            countRoot,
            "CENTER",
            0,
            0
        )
        count:SetJustifyH("CENTER")
        count:SetJustifyV("MIDDLE")
        local countColor = colorValue("countText")
        count:SetTextColor(
            countColor[1],
            countColor[2],
            countColor[3],
            countColor[4]
        )
        count:SetShadowColor(0, 0, 0, 1)
        count:SetShadowOffset(1, -1)
        count:ClearText()

        self.slots[index] = {
            frame = slotFrame,
            icon = icon,
            frameTexture = frameTexture,
            countRoot = countRoot,
            countPlate = countPlate,
            count = count,
        }
    end

    local eventFrame = CreateFrame("Frame")

    self.unitAuraRegistered = pcall(
        eventFrame.RegisterUnitEvent,
        eventFrame,
        "UNIT_AURA",
        "player"
    )
    self.worldRegistered = pcall(
        eventFrame.RegisterEvent,
        eventFrame,
        "PLAYER_ENTERING_WORLD"
    )
    -- Same native restriction transition already observed by Logres State.
    -- Event-driven recovery only: no timers, polling or OnUpdate hooks.
    self.restrictionRegistered = pcall(
        eventFrame.RegisterEvent,
        eventFrame,
        "ADDON_RESTRICTION_STATE_CHANGED"
    )

    eventFrame:SetScript("OnEvent", function(_, event)
        if self.moduleEnabled ~= true then
            return
        end

        if event == "ADDON_RESTRICTION_STATE_CHANGED" then
            -- On Forever a combat-restricted UNIT_AURA can make all 40
            -- helpful indices secret. No later UNIT_AURA is guaranteed at
            -- restriction release: the old empty/incomplete snapshot then
            -- persists until the player happens to rebuff.
            -- Only retry after restrictions lift; never inspect secret data.
            if InCombatLockdown() then
                return
            end
            self.restrictionRecoveryCount =
                self.restrictionRecoveryCount + 1
            local _, refreshReason = self:Refresh("restriction-release")
            self.restrictionRecoveryLastReason = refreshReason
            self.restrictionRecoveryLastCoverage =
                self.lastCoverageReady == true

            -- Reconcile the stock BUFFS owner after (not before) our
            -- ordinary coverage decision, independent of event order.
            -- Incomplete coverage must fail open to stock; never suppress
            -- Blizzard merely because the Logres art exists.
            local ownerOK, native = pcall(
                Logres.GetModule, Logres, "NativeSurfaceReplacement"
            )
            if ownerOK and native and native:IsEnabled()
                and type(native.Reconcile) == "function"
            then
                local ok = pcall(
                    native.Reconcile, native,
                    "player-helpful-restriction-release"
                )
                if ok then
                    self.restrictionReconcileCount =
                        self.restrictionReconcileCount + 1
                else
                    self.restrictionReconcileFailures =
                        self.restrictionReconcileFailures + 1
                end
            end
            return
        end

        if event == "UNIT_AURA" then
            self.unitAuraEvents =
                self.unitAuraEvents + 1
        elseif event == "PLAYER_ENTERING_WORLD" then
            self.worldEvents =
                self.worldEvents + 1
        end

        -- UNIT_AURA update payload arguments are deliberately discarded.
        self:Refresh(event)
    end)

    self.eventFrame = eventFrame
end

function HelpfulAuras:OnEnable()
    self.moduleEnabled = true

    self:SubscribePreferences(function(preferences)
        self:ApplyPreferences(preferences)
    end)

    self:ApplyPreferences(Logres:GetPreferences())
end

function HelpfulAuras:OnDisable()
    self.moduleEnabled = false
    self.previewEnabled = false
    self:HidePresentation("module-disabled")
end

function HelpfulAuras:RunDevHelpfulAuraCheck(emit)
    local status =
        Logres:GetModuleStatus("PlayerHelpfulAuras")
    local module =
        Logres:GetModule("PlayerHelpfulAuras")

    local refreshOK, refreshReason =
        module:Refresh("diagnostic-check")
    local debugStatus = module:GetDebugStatus()

    local expectedShown =
        debugStatus.immersionEnabled == true
        and debugStatus.visibleCount > 0

    local visibilityCoherent =
        debugStatus.rootShown == expectedShown
        and debugStatus.presentationShown
            == expectedShown

    local passed =
        status.initialized == true
        and status.enabled == true
        and debugStatus.moduleEnabled == true
        and debugStatus.rootReady == true
        and debugStatus.slotCount == MAX_ICONS
        and debugStatus.unitAuraRegistered == true
        and debugStatus.worldRegistered == true
        and debugStatus.sourceAvailable == true
        and refreshOK == true
        and debugStatus.failureCount == 0
        and visibilityCoherent

    emit(string.format(
        "Logres helpfulauracheck: %s (refresh=%s reason=%s root=%s expected=%s immersion=%s preview=%s slots=%s visible=%s shown=%s events=aura:%s world:%s source=%s filter=%s secretSkips=%s secretFields=%s failures=%s lastRefresh=%s presentation=%s error=%s coverage=%s exhausted=%s)",
        passed and "PASS" or "FAIL",
        tostring(refreshOK),
        tostring(refreshReason),
        tostring(debugStatus.rootShown),
        tostring(expectedShown),
        tostring(debugStatus.immersionEnabled),
        tostring(debugStatus.previewEnabled),
        tostring(debugStatus.slotCount),
        tostring(debugStatus.visibleCount),
        tostring(debugStatus.presentationShown),
        tostring(debugStatus.unitAuraEvents),
        tostring(debugStatus.worldEvents),
        tostring(debugStatus.sourceAvailable),
        tostring(debugStatus.filter),
        tostring(debugStatus.secretSkipCount),
        tostring(debugStatus.secretFieldCount),
        tostring(debugStatus.failureCount),
        tostring(debugStatus.lastRefreshReason),
        tostring(debugStatus.lastPresentationReason),
        tostring(debugStatus.lastError),
        tostring(debugStatus.coverageReady),
        tostring(debugStatus.scanExhausted)
    ))
end
