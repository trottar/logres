local _, Logres = ...

-- P0175: additive priority status, not a complete replacement for Blizzard auras.
-- No native aura frame is modified. World attachment remains D-042 gated.
local StatusAuras = Logres:RegisterModule("StatusAuras", {
    autoEnable = true,
})

local MAX_SCAN = 6
local MAX_ICONS = 5
local ICON_SIZE = 30
local GAP = 5

local FILTERS = {
    player = {
        { filter = "HARMFUL|CROWD_CONTROL", kind = "urgent" },
        { filter = "HARMFUL|RAID", kind = "urgent" },
        { filter = "HARMFUL", kind = "harmful" },
    },
    target = {
        { filter = "HARMFUL|PLAYER", kind = "harmful" },
        { filter = "HARMFUL|CROWD_CONTROL", kind = "urgent" },
        { filter = "HARMFUL", kind = "harmful" },
        { filter = "HELPFUL|DISPELLABLE", kind = "urgent" },
        { filter = "HELPFUL|BIG_DEFENSIVE", kind = "urgent" },
        { filter = "HELPFUL|IMPORTANT", kind = "helpful" },
        { filter = "HELPFUL", kind = "helpful" },
    },
}

local COLORS = {
    urgent = { 0.95, 0.43, 0.23, 1 },
    harmful = { 0.77, 0.31, 0.35, 1 },
    helpful = { 0.72, 0.70, 0.48, 1 },
}

local function isSecret(value)
    if type(issecretvalue) ~= "function" then
        return true
    end
    local ok, result = pcall(issecretvalue, value)
    return not ok or result ~= false
end

local function sourceAvailable()
    return type(issecretvalue) == "function"
        and C_Secrets ~= nil
        and type(C_Secrets.ShouldUnitAuraIndexBeSecret) == "function"
        and C_UnitAuras ~= nil
        and type(C_UnitAuras.GetAuraDataByIndex) == "function"
        and type(UnitExists) == "function"
end

local function readAura(unit, index, filter, kind)
    local ok, predicate = pcall(
        C_Secrets.ShouldUnitAuraIndexBeSecret, unit, index, filter
    )
    if not ok then
        return nil, "predicate-failed"
    end
    if isSecret(predicate) then
        return nil, "secret"
    end
    if predicate ~= false then
        if predicate == true then
            return nil, "secret"
        end
        return nil, "predicate-indeterminate"
    end

    local queryOK, aura = pcall(
        C_UnitAuras.GetAuraDataByIndex, unit, index, filter
    )
    if not queryOK then
        return nil, "query-failed"
    end
    if isSecret(aura) then
        return nil, "secret"
    end
    if aura == nil then
        return nil, "empty"
    end
    if type(aura) ~= "table" then
        return nil, "invalid-aura"
    end

    local icon = aura.icon
    if isSecret(icon) then
        return nil, "secret"
    end
    if type(icon) ~= "number" and type(icon) ~= "string" then
        return nil, "invalid-icon"
    end

    local applications = aura.applications
    local stacksSecret = isSecret(applications)
    if stacksSecret or type(applications) ~= "number" then
        applications = nil
    end

    -- Never branch on an auraInstanceID until it is proven ordinary.
    local instanceID = aura.auraInstanceID
    if isSecret(instanceID) or type(instanceID) ~= "number" then
        instanceID = nil
    end

    return {
        icon = icon,
        applications = applications,
        stacksSecret = stacksSecret,
        instanceID = instanceID,
        index = index,
        filter = filter,
        kind = kind,
    }, "ordinary"
end

local function readUnit(unit)
    local result = {
        rows = {}, harmfulRows = {}, helpfulRows = {},
        secretSkips = 0, secretFields = 0,
        failures = 0, duplicateUnknown = 0,
        reason = "empty", lastError = nil,
    }
    if not sourceAvailable() then
        result.reason = "api-unavailable"
        return result
    end
    local ok, exists = pcall(UnitExists, unit)
    if not ok or isSecret(exists) then
        result.reason = "unit-unavailable"
        return result
    end
    if exists ~= true then
        result.reason = "unit-absent"
        return result
    end
    local seen = {}
    for _, descriptor in ipairs(FILTERS[unit]) do
        -- Never let target buffs consume the harmful/status action budget.
        -- This category comes from our immutable source filter, not aura data.
        local bucket = result.rows
        if unit == "target" then
            if descriptor.filter:sub(1, 7) == "HARMFUL" then
                bucket = result.harmfulRows
            else
                bucket = result.helpfulRows
            end
        end
        for index = 1, MAX_SCAN do
            if #bucket >= MAX_ICONS then
                break
            end
            local aura, state = readAura(
                unit, index, descriptor.filter, descriptor.kind
            )
            if state == "empty" then
                break
            elseif state == "secret" then
                result.secretSkips = result.secretSkips + 1
            elseif state ~= "ordinary" then
                result.failures = result.failures + 1
                result.lastError = state
            elseif aura then
                if aura.stacksSecret then
                    result.secretFields = result.secretFields + 1
                end
                if aura.instanceID == nil or not seen[aura.instanceID] then
                    if aura.instanceID == nil then
                        result.duplicateUnknown = result.duplicateUnknown + 1
                    else
                        seen[aura.instanceID] = true
                    end
                    bucket[#bucket + 1] = aura
                end
            end
        end
        -- The other category must still be scanned if this one is full.
    end
    if unit == "target" then
        for _, aura in ipairs(result.harmfulRows) do
            result.rows[#result.rows + 1] = aura
        end
        for _, aura in ipairs(result.helpfulRows) do
            result.rows[#result.rows + 1] = aura
        end
    end
    if #result.rows > 0 then
        result.reason = "populated"
    end
    if result.failures > 0 then
        result.reason = "partial-source-failure"
    end
    return result
end

local function createLane(unit, point, relativePoint, offsetX, offsetY, laneName)
    local root = CreateFrame("Frame", "LogresStatusAuras" .. (laneName or unit), UIParent)
    root:SetSize(MAX_ICONS * ICON_SIZE + (MAX_ICONS - 1) * GAP, ICON_SIZE)
    root:SetFrameStrata("HIGH")
    root:EnableMouse(false)
    root:Hide()
    local anchorKey = unit == "player" and "playerReaction" or "targetFallback"
    Logres.Layout.Bind(root, anchorKey, point, relativePoint, offsetX, offsetY)

    local slots = {}
    for i = 1, MAX_ICONS do
        local slot = CreateFrame("Frame", nil, root)
        slot:SetSize(ICON_SIZE, ICON_SIZE)
        slot:SetPoint("LEFT", root, "LEFT", (i - 1) * (ICON_SIZE + GAP), 0)
        slot:EnableMouse(true)
        slot:Hide()
        local icon = slot:CreateTexture(nil, "ARTWORK")
        icon:SetPoint("TOPLEFT", slot, "TOPLEFT", 2, -2)
        icon:SetPoint("BOTTOMRIGHT", slot, "BOTTOMRIGHT", -2, 2)
        local border = slot:CreateTexture(nil, "OVERLAY")
        border:SetAllPoints(slot)
        border:SetTexture(
            (Logres.Theme and Logres.Theme.playerHelpfulAuras
            and Logres.Theme.playerHelpfulAuras.assets
            and Logres.Theme.playerHelpfulAuras.assets.frame)
            or "Interface\\Buttons\\UI-Quickslot2"
        )
        local marker = slot:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        marker:SetPoint("TOPLEFT", slot, "TOPLEFT", 0, 2)
        local count = slot:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        count:SetPoint("BOTTOMRIGHT", slot, "BOTTOMRIGHT", 2, -2)
        count:SetShadowOffset(1, -1)
        local item = {
            frame = slot, icon = icon, border = border,
            marker = marker, count = count, unit = unit,
        }
        slot:SetScript("OnEnter", function(current)
            if type(item.index) ~= "number"
                or not item.filter
                or not GameTooltip
                or type(GameTooltip.SetUnitAura) ~= "function"
                or not sourceAvailable()
            then
                return
            end
            -- Recheck the current index at hover; UNIT_AURA can reorder it.
            local ok, secretIndex = pcall(
                C_Secrets.ShouldUnitAuraIndexBeSecret,
                item.unit, item.index, item.filter
            )
            if not ok or isSecret(secretIndex) or secretIndex ~= false then
                return
            end
            GameTooltip:SetOwner(current, "ANCHOR_RIGHT")
            local tooltipOK = pcall(
                GameTooltip.SetUnitAura, GameTooltip,
                item.unit, item.index, item.filter
            )
            if tooltipOK then
                GameTooltip:Show()
            else
                GameTooltip:Hide()
            end
        end)
        slot:SetScript("OnLeave", function()
            if GameTooltip then
                GameTooltip:Hide()
            end
        end)
        slots[i] = item
    end
    return { root = root, slots = slots, visible = 0 }
end

local function renderLane(lane, rows, shown)
    for i, item in ipairs(lane.slots) do
        local aura = rows[i]
        if aura then
            item.index = aura.index
            item.filter = aura.filter
            item.icon:SetTexture(aura.icon)
            local color = COLORS[aura.kind] or COLORS.harmful
            item.border:SetVertexColor(color[1], color[2], color[3], color[4])
            item.marker:SetText(aura.kind == "urgent" and "!"
                or aura.kind == "helpful" and "+" or "-")
            if aura.applications and aura.applications > 1 then
                item.count:SetFormattedText("%.0f", aura.applications)
            else
                item.count:ClearText()
            end
            item.frame:Show()
        else
            item.index = nil
            item.filter = nil
            item.icon:SetTexture(nil)
            item.count:ClearText()
            item.frame:Hide()
        end
    end
    lane.visible = #rows
    lane.root:SetShown(shown and #rows > 0)
end

local PREVIEW = {
    player = {
        { icon = "Interface\\Icons\\Spell_Shadow_CurseOfTounges", kind = "urgent", applications = 1 },
        { icon = "Interface\\Icons\\Spell_Shadow_AbominationExplosion", kind = "harmful", applications = 3 },
    },
    target = {
        { icon = "Interface\\Icons\\Spell_Shadow_ShadowWordPain", kind = "harmful", applications = 1 },
        { icon = "Interface\\Icons\\Spell_Shadow_CurseOfTounges", kind = "urgent", applications = 2 },
    },
    targetHelpful = {
        { icon = "Interface\\Icons\\Spell_Holy_DispelMagic", kind = "urgent", applications = 1 },
        { icon = "Interface\\Icons\\Spell_Holy_SealOfProtection", kind = "helpful", applications = 1 },
    },
}

-- Retain category-level, ordinary-read evidence without retaining aura payloads.
-- This is session-only and does not poll or read protected Blizzard UI state.
local function recordLiveBucket(bucket, count, reason)
    if count <= 0 then
        return
    end
    bucket.positiveReads = bucket.positiveReads + 1
    if count > bucket.maxRows then
        bucket.maxRows = count
    end
    bucket.lastReason = reason
end

function StatusAuras:RecordLiveSnapshot(unit, snapshot, reason)
    self.liveScans = self.liveScans + 1
    self.liveFailures = self.liveFailures + snapshot.failures
    self.liveSecrets = self.liveSecrets + snapshot.secretSkips
    if unit == "player" then
        recordLiveBucket(self.liveHistory.playerHarmful, #snapshot.rows, reason)
    else
        recordLiveBucket(self.liveHistory.targetHarmful, #snapshot.harmfulRows, reason)
        recordLiveBucket(self.liveHistory.targetHelpful, #snapshot.helpfulRows, reason)
    end
end

function StatusAuras:Refresh(reason, onlyUnit)
    self.refreshes = self.refreshes + 1
    self.lastReason = reason
    local preferences = Logres:GetPreferences()
    local active = self.moduleEnabled and preferences.immersionEnabled == true
    for _, unit in ipairs({ "player", "target" }) do
        if onlyUnit == nil or onlyUnit == unit then
            local snapshot
            if active and self.preview then
                snapshot = {
                    rows = PREVIEW[unit], reason = "preview",
                    harmfulRows = unit == "target" and PREVIEW.target or {},
                    helpfulRows = unit == "target" and PREVIEW.targetHelpful or {},
                    failures = 0, secretSkips = 0,
                    secretFields = 0, duplicateUnknown = 0,
                }
            elseif active then
                snapshot = readUnit(unit)
            else
                snapshot = {
                    rows = {}, harmfulRows = {}, helpfulRows = {},
                    reason = "disabled", failures = 0,
                    secretSkips = 0, secretFields = 0, duplicateUnknown = 0,
                }
            end
            self.last[unit] = snapshot
            if active and not self.preview then
                self:RecordLiveSnapshot(unit, snapshot, reason)
            end
            if unit == "target" then
                renderLane(self.lanes.target, snapshot.harmfulRows, active)
                renderLane(self.lanes.targetHelpful, snapshot.helpfulRows, active)
            else
                renderLane(self.lanes.player, snapshot.rows, active)
            end
        end
    end
end

function StatusAuras:SetPreview(enabled)
    self.preview = enabled == true
    self:Refresh(self.preview and "preview-on" or "preview-off")
end

function StatusAuras:GetDebugStatus()
    local p, t = self.last.player, self.last.target
    return {
        enabled = self.moduleEnabled,
        preview = self.preview,
        source = sourceAvailable() == true,
        playerVisible = self.lanes.player.visible,
        targetVisible = self.lanes.target.visible + self.lanes.targetHelpful.visible,
        targetHarmfulVisible = self.lanes.target.visible,
        targetHelpfulVisible = self.lanes.targetHelpful.visible,
        playerShown = self.lanes.player.root:IsShown(),
        targetShown = self.lanes.target.root:IsShown()
            or self.lanes.targetHelpful.root:IsShown(),
        targetHarmfulShown = self.lanes.target.root:IsShown(),
        targetHelpfulShown = self.lanes.targetHelpful.root:IsShown(),
        playerReason = p.reason,
        targetReason = t.reason,
        playerSecret = p.secretSkips,
        targetSecret = t.secretSkips,
        playerFields = p.secretFields,
        targetFields = t.secretFields,
        failures = p.failures + t.failures,
        duplicatesUnknown = p.duplicateUnknown + t.duplicateUnknown,
        refreshes = self.refreshes,
        historyPlayerMax = self.liveHistory.playerHarmful.maxRows,
        historyPlayerPositive = self.liveHistory.playerHarmful.positiveReads,
        historyPlayerReason = self.liveHistory.playerHarmful.lastReason,
        historyTargetHarmfulMax = self.liveHistory.targetHarmful.maxRows,
        historyTargetHarmfulPositive = self.liveHistory.targetHarmful.positiveReads,
        historyTargetHarmfulReason = self.liveHistory.targetHarmful.lastReason,
        historyTargetHelpfulMax = self.liveHistory.targetHelpful.maxRows,
        historyTargetHelpfulPositive = self.liveHistory.targetHelpful.positiveReads,
        historyTargetHelpfulReason = self.liveHistory.targetHelpful.lastReason,
        historyScans = self.liveScans,
        historyFailures = self.liveFailures,
        historySecrets = self.liveSecrets,
        lastReason = self.lastReason,
        stockPreserved = true,
        eventsReady = self.unitAuraRegistered == true
            and self.targetEventRegistered == true
            and self.worldEventRegistered == true,
    }
end

function StatusAuras:OnInitialize()
    self.moduleEnabled = false
    self.preview = false
    self.refreshes = 0
    self.lastReason = "initialize"
    self.last = {}
    self.liveScans = 0
    self.liveFailures = 0
    self.liveSecrets = 0
    self.liveHistory = {
        playerHarmful = { maxRows = 0, positiveReads = 0, lastReason = nil },
        targetHarmful = { maxRows = 0, positiveReads = 0, lastReason = nil },
        targetHelpful = { maxRows = 0, positiveReads = 0, lastReason = nil },
    }
    self.lanes = {
        player = createLane("player", "RIGHT", "LEFT", -100, 17),
        -- Enemy debuffs and buffs must be inspectable in independent rows.
        target = createLane("target", "LEFT", "RIGHT", 100, -17),
        targetHelpful = createLane(
            "target", "LEFT", "RIGHT", 100, -55, "targetHelpful"
        ),
    }
    local eventFrame = CreateFrame("Frame")
    self.unitAuraRegistered = pcall(
        eventFrame.RegisterUnitEvent, eventFrame, "UNIT_AURA", "player", "target"
    )
    self.targetEventRegistered = pcall(
        eventFrame.RegisterEvent, eventFrame, "PLAYER_TARGET_CHANGED"
    )
    self.worldEventRegistered = pcall(
        eventFrame.RegisterEvent, eventFrame, "PLAYER_ENTERING_WORLD"
    )
    eventFrame:SetScript("OnEvent", function(_, event, unit)
        if not self.moduleEnabled then
            return
        end
        if event == "UNIT_AURA" then
            if isSecret(unit) then
                return
            end
            if unit ~= "player" and unit ~= "target" then
                return
            end
        end
        -- The UNIT_AURA delta payload is intentionally never inspected.
        if event == "UNIT_AURA" then
            self:Refresh(event, unit)
        elseif event == "PLAYER_TARGET_CHANGED" then
            self:Refresh(event, "target")
        else
            self:Refresh(event)
        end
    end)
    self.eventFrame = eventFrame
end

function StatusAuras:OnEnable()
    self.moduleEnabled = true
    self:SubscribePreferences(function()
        self:Refresh("preference")
    end)
    self:Refresh("enable")
end

function StatusAuras:OnDisable()
    self.moduleEnabled = false
    self.preview = false
    self:Refresh("disable")
end
