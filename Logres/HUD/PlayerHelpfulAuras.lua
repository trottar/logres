local _, Logres = ...

local FILTER = "HELPFUL|PLAYER"
local MAX_SCAN = 6
local MAX_ICONS = 4

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
    }

    for index = 1, MAX_SCAN do
        local aura, reason, state = readAura(index)

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
        filter = FILTER,
    }
end

function HelpfulAuras:OnInitialize()
    self.moduleEnabled = false
    self.previewEnabled = false
    self.presentationShown = false
    self.visibleCount = 0
    self.refreshCount = 0
    self.previewCount = 0
    self.unitAuraEvents = 0
    self.worldEvents = 0
    self.lastSecretSkipCount = 0
    self.lastSecretFieldCount = 0
    self.lastFailureCount = 0
    self.lastError = nil
    self.lastRefreshReason = "initialize"
    self.lastPresentationReason = "initialize"

    local iconSize = styleValue("iconSize")
    local gap = styleValue("gap")
    local totalWidth =
        (MAX_ICONS * iconSize)
        + ((MAX_ICONS - 1) * gap)

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
    root:SetFrameStrata("HIGH")
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
        slotFrame:SetPoint(
            "LEFT",
            root,
            "LEFT",
            (index - 1) * (iconSize + gap),
            0
        )
        slotFrame:EnableMouse(false)
        slotFrame:Hide()

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

    eventFrame:SetScript("OnEvent", function(_, event)
        if self.moduleEnabled ~= true then
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
