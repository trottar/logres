local _, Logres = ...

-- P0175: additive priority status, not a complete replacement for Blizzard auras.
-- No native aura frame is modified. World attachment remains D-042 gated.
local StatusAuras = Logres:RegisterModule("StatusAuras", {
    autoEnable = true,
})

local MAX_SCAN = 6
local TARGET_HARMFUL_SCAN = 16
local MAX_ICONS = 5
local ICON_SIZE = 25
local GAP = 3
local statusStyle = (Logres.Theme and Logres.Theme.statusAura) or {}
local statusAssets = statusStyle.assets or {}
local urgentRailColor = statusStyle.urgentRailColor or { 0.97, 0.65, 0.35, 0.95 }

local FILTERS = {
    player = {
        { filter = "HARMFUL|CROWD_CONTROL", kind = "urgent" },
        { filter = "HARMFUL|RAID", kind = "urgent" },
        { filter = "HARMFUL", kind = "harmful" },
    },
    target = {
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

    -- The whole aura can be ordinary while individual fields are secret.
    local playerOrigin = aura.isFromPlayerOrPlayerPet
    if isSecret(playerOrigin) or type(playerOrigin) ~= "boolean" then
        playerOrigin = nil
    end

    return {
        icon = icon,
        fromPlayer = playerOrigin,
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
    local targetHarmfulCandidates = {}
    for _, descriptor in ipairs(FILTERS[unit]) do
        -- A single canonical HARMFUL query avoids multiple copies of an
        -- identity-unknown DoT across overlapping filtered index spaces.
        local canonicalTargetHarmful = unit == "target"
            and descriptor.filter == "HARMFUL"
        local bucket = result.rows
        if unit == "target" then
            if descriptor.filter:sub(1, 7) == "HARMFUL" then
                bucket = result.harmfulRows
            else
                bucket = result.helpfulRows
            end
        end
        local scanLimit = canonicalTargetHarmful
            and TARGET_HARMFUL_SCAN or MAX_SCAN
        for index = 1, scanLimit do
            -- Scan beyond five for the canonical target harmful source so
            -- later ordinary player-origin DoTs can still be prioritized.
            if not canonicalTargetHarmful and #bucket >= MAX_ICONS then
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
                    if canonicalTargetHarmful then
                        targetHarmfulCandidates[#targetHarmfulCandidates + 1] = aura
                    else
                        bucket[#bucket + 1] = aura
                    end
                end
            end
        end
    end
    if unit == "target" then
        -- Prefer only *ordinary* player-origin indicators. Unknown or secret
        -- origin remains eligible in canonical order; do not guess identity.
        for pass = 1, 2 do
            for _, aura in ipairs(targetHarmfulCandidates) do
                if #result.harmfulRows < MAX_ICONS
                    and (aura.fromPlayer == true) == (pass == 1)
                then
                    result.harmfulRows[#result.harmfulRows + 1] = aura
                end
            end
        end
        for _, aura in ipairs(result.harmfulRows) do
            result.rows[#result.rows + 1] = aura
        end
        for _, aura in ipairs(result.helpfulRows) do
            result.rows[#result.rows + 1] = aura
        end
    end
    if #result.rows > 0 then
        result.reason = "populated"
    elseif result.secretSkips > 0 then
        -- This counts skipped index probes, NOT the number of actual auras.
        result.reason = "restricted-no-ordinary"
    end
    if result.failures > 0 then
        result.reason = "partial-source-failure"
    end
    return result
end

local function createLane(unit, point, relativePoint, offsetX, offsetY, laneName, previewParent)
    local root = CreateFrame("Frame", "LogresStatusAuras" .. (laneName or unit), previewParent or UIParent)
    local columns = unit == "player" and MAX_ICONS or 2
    local rows = math.ceil(MAX_ICONS / columns)
    root:SetSize(
        columns * ICON_SIZE + (columns - 1) * GAP,
        rows * ICON_SIZE + (rows - 1) * GAP
    )
    if previewParent then
        root:SetFrameStrata("DIALOG")
    else
        root:SetFrameStrata("BACKGROUND")
    end
    root:EnableMouse(false)
    root:Hide()
    local anchorKey = unit == "player" and "playerHarmful"
        or laneName == "targetHelpful" and "targetHelpful" or "targetHarmful"
    if previewParent then
        -- Reproduce V8's buff-right/debuff-left relative placement: 25 px
        -- between the target's 198 px root and each 53 px two-column lane.
        -- Both are children of the unit fixture so 50% scale/alpha applies
        -- uniformly to name, bar, helpful and harmful icons and their gaps.
        if point == "RIGHT" then
            root:SetPoint("RIGHT", previewParent, "LEFT", -25, 0)
        else
            root:SetPoint("LEFT", previewParent, "RIGHT", 25, 0)
        end
    else
        Logres.Layout.Bind(root, anchorKey, "CENTER", "CENTER")
    end

    local slots = {}
    for i = 1, MAX_ICONS do
        local slot = CreateFrame("Frame", nil, root)
        slot:SetSize(ICON_SIZE, ICON_SIZE)
        local index = i - 1
        local column = index % columns
        local row = math.floor(index / columns)
        slot:SetPoint("TOPLEFT", root, "TOPLEFT",
            column * (ICON_SIZE + GAP), -row * (ICON_SIZE + GAP))
        slot:EnableMouse(previewParent == nil)
        slot:Hide()
        local icon = slot:CreateTexture(nil, "ARTWORK")
        icon:SetPoint("TOPLEFT", slot, "TOPLEFT", 2, -2)
        icon:SetPoint("BOTTOMRIGHT", slot, "BOTTOMRIGHT", -2, 2)
        local border = slot:CreateTexture(nil, "OVERLAY")
        border:SetAllPoints(slot)
        border:SetTexture(
            statusAssets.frame
            or (Logres.Theme and Logres.Theme.playerHelpfulAuras
            and Logres.Theme.playerHelpfulAuras.assets
            and Logres.Theme.playerHelpfulAuras.assets.frame)
            or "Interface\\Buttons\\UI-Quickslot2"
        )
        -- Only addon-owned ordinary status presentations are decorated here.
        local urgentRail = slot:CreateTexture(nil, "OVERLAY")
        urgentRail:SetPoint("TOPLEFT", slot, "TOPLEFT", 2, -2)
        urgentRail:SetSize(
            statusStyle.urgentRailWidth or 11,
            statusStyle.urgentRailHeight or 2
        )
        urgentRail:SetColorTexture(
            urgentRailColor[1], urgentRailColor[2],
            urgentRailColor[3], urgentRailColor[4]
        )
        urgentRail:Hide()
        local countPlate = slot:CreateTexture(nil, "OVERLAY")
        countPlate:SetSize(
            statusStyle.countWidth or 18,
            statusStyle.countHeight or 12
        )
        countPlate:SetPoint("BOTTOMRIGHT", slot, "BOTTOMRIGHT", 1, -1)
        countPlate:SetTexture(statusAssets.countPlate)
        countPlate:Hide()
        local marker = slot:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        marker:SetPoint("TOPLEFT", slot, "TOPLEFT", 0, 2)
        local count = slot:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        count:SetAllPoints(countPlate)
        count:SetJustifyH("CENTER")
        count:SetJustifyV("MIDDLE")
        count:SetShadowColor(0, 0, 0, 0.98)
        count:SetShadowOffset(1, -1)
        local item = {
            frame = slot, icon = icon, border = border,
            marker = marker, count = count, countPlate = countPlate,
            urgentRail = urgentRail, unit = unit,
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
            item.urgentRail:SetShown(aura.kind == "urgent")
            item.marker:SetText(aura.kind == "urgent" and "!"
                or aura.kind == "helpful" and "+" or "-")
            if aura.applications and aura.applications > 1 then
                item.count:SetFormattedText("%.0f", aura.applications)
                item.countPlate:Show()
            else
                item.count:ClearText()
                item.countPlate:Hide()
            end
            item.frame:Show()
        else
            item.index = nil
            item.filter = nil
            item.icon:SetTexture(nil)
            item.count:ClearText()
            item.countPlate:Hide()
            item.urgentRail:Hide()
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
    -- Native Blizzard aura containers render restricted harmful icons without
    -- exposing their payloads to addon Lua. Ordinary legacy rows are fallback.
    local useNative = false
    if self.nativeDebuffs then
        local nativeOK, activationReason = Logres.NativeDebuffs.SetActive(
            self.nativeDebuffs, active and not self.preview,
            reason == "PLAYER_ENTERING_WORLD" or reason == "preference"
                or reason == "PLAYER_REGEN_ENABLED" or reason == "preview-off"
        )
        useNative = nativeOK and active and not self.preview
        self.nativeActivationReason = activationReason
    end
    self.nativeActive = useNative
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
            if unit == "target" and self.worldTrialLanes then
                self:RefreshWorldTrialLanes()
            end
            if unit == "target" and self.worldEnemyLiveLanes then
                self:RefreshWorldEnemyLiveLanes()
            end
            if active and not self.preview then
                self:RecordLiveSnapshot(unit, snapshot, reason)
            end
            if unit == "target" then
                renderLane(self.lanes.target, snapshot.harmfulRows, active and not useNative)
                renderLane(self.lanes.targetHelpful, snapshot.helpfulRows, active)
            else
                local stock = not self.preview and Logres.NativeDebuffs.StockPlayerHarmful()
                renderLane(self.lanes.player, snapshot.rows, active and not useNative and not stock)
            end
        end
    end
end

-- Synthetic owned preview lanes share live StatusAuras.createLane/renderLane.
-- Neither hidden nor displayed fixtures query, inspect, suppress or relocate
-- native auras. The fixture omits tooltips and cannot claim live aggro.
function StatusAuras:CreateEnemyFixtureLanes(parent, ordinal)
    if parent.enemyFixtureLanes then return parent.enemyFixtureLanes end
    local suffix = tostring(ordinal)
    local harmful = createLane("target", "RIGHT", "LEFT", 0, 0,
        "P0435Harmful" .. suffix, parent)
    local helpful = createLane("target", "LEFT", "RIGHT", 0, 0,
        "P0435Helpful" .. suffix, parent)
    renderLane(harmful, PREVIEW.target, true)
    renderLane(helpful, PREVIEW.targetHelpful, true)
    parent.enemyFixtureLanes = {harmful = harmful, helpful = helpful}
    return parent.enemyFixtureLanes
end

-- Live world trial uses the SAME owned aura renderer and spacing as the
-- 100/50 fixture, but uses only already-validated ordinary target aura rows.
-- Stock aura and screen-space fallback ownership are never changed here.
function StatusAuras:CreateWorldTrialLanes(parent)
    if self.worldTrialLanes then return self.worldTrialLanes end
    local harmful = createLane("target", "RIGHT", "LEFT", 0, 0,
        "P0438WorldHarmful", parent)
    local helpful = createLane("target", "LEFT", "RIGHT", 0, 0,
        "P0438WorldHelpful", parent)
    self.worldTrialLanes = {harmful = harmful, helpful = helpful}
    return self.worldTrialLanes
end

function StatusAuras:RefreshWorldTrialLanes()
    if not self.worldTrialLanes then return end
    -- Once an owned trial is anchored to a native plate, even child aura
    -- mutations are deferred through lockdown. The parent secure driver
    -- handles visibility; ordinary rows refresh only after combat.
    if type(InCombatLockdown) ~= "function" then return end
    local ok, lockdown = pcall(InCombatLockdown)
    if not ok or isSecret(lockdown) or lockdown ~= false then return end
    local snapshot = self.last.target
    local trial = Logres:GetModule("HUD")
    local active = trial and trial.worldTrialVisible == true
        and self.moduleEnabled and not self.preview
    renderLane(self.worldTrialLanes.harmful,
        snapshot and snapshot.harmfulRows or {}, active)
    renderLane(self.worldTrialLanes.helpful,
        snapshot and snapshot.helpfulRows or {}, active)
end

-- P0441: the combat world trial uses the same ordinary target snapshot,
-- aura renderer, grid and +/-25px lane geometry. These are addon-owned
-- children; never inspect or mutate Blizzard's native aura frames.
function StatusAuras:CreateWorldEnemyLiveLanes(parent)
    if self.worldEnemyLiveLanes then return self.worldEnemyLiveLanes end
    local harmful = createLane("target", "RIGHT", "LEFT", 0, 0,
        "P0441WorldHarmful", parent)
    local helpful = createLane("target", "LEFT", "RIGHT", 0, 0,
        "P0441WorldHelpful", parent)
    self.worldEnemyLiveLanes = {harmful = harmful, helpful = helpful}
    -- The ordinary texture lanes remain a complete fail-open fallback. The
    -- preferred world lanes are secure Blizzard AuraContainer *children of
    -- our own frame*, not native nameplate/target-frame children. Construct
    -- only while out of combat, before this world parent can be shown.
    local ok, nativeFrames, nativeReason = pcall(
        Logres.NativeDebuffs.CreateWorldEnemyLanes, parent
    )
    if ok and nativeFrames then
        self.worldEnemyNativeLanes = nativeFrames
        self.worldEnemyNativeReason = nativeReason or "native-delegated"
    else
        self.worldEnemyNativeReason = ok and (nativeReason or "native-refused")
            or "native-init-error"
    end
    return self.worldEnemyLiveLanes
end

-- P0450: native, addon-owned screen target auras must not duplicate the
-- world child. This is a presentation-only alpha handoff. Failure leaves
-- the existing Blizzard/Logres fallback accessible and is reported.
function StatusAuras:SetWorldEnemyScreenAuraHandoff(worldOwned)
    if not self.nativeDebuffs
        or type(Logres.NativeDebuffs.SetScreenTargetWorldOwned) ~= "function"
    then
        self.worldEnemyScreenAuraReason = "unavailable"
        return false
    end
    local wasOwned = self.worldEnemyScreenAuraOwned == true
    local ok, accepted, reason = pcall(
        Logres.NativeDebuffs.SetScreenTargetWorldOwned,
        self.nativeDebuffs, worldOwned == true
    )
    self.worldEnemyScreenAuraReason = ok and reason or "handoff-error"
    self.worldEnemyScreenAuraOwned = ok and accepted == true
        and worldOwned == true
    if worldOwned == true and self.worldEnemyScreenAuraOwned and not wasOwned then
        self.worldEnemyScreenAuraHandoffs = self.worldEnemyScreenAuraHandoffs + 1
    elseif worldOwned ~= true and wasOwned and ok and accepted == true then
        self.worldEnemyScreenAuraRestores = self.worldEnemyScreenAuraRestores + 1
    end
    if not ok or accepted ~= true then
        self.worldEnemyScreenAuraFailures = self.worldEnemyScreenAuraFailures + 1
    end
    return ok and accepted == true
end

function StatusAuras:RefreshWorldEnemyLiveLanes()
    if not self.worldEnemyLiveLanes then return false end
    local hud = Logres:GetModule("HUD")
    local active = hud and hud.worldEnemyLiveVisible == true
        and self.moduleEnabled and not self.preview
    local snapshot = self.last.target
    local rows = snapshot and snapshot.harmfulRows or {}
    local helpful = snapshot and snapshot.helpfulRows or {}
    -- Some Forever frame mutations may be protected in combat; failure is
    -- contained to this owned trial, never the native/Logres fallback.
    self.worldEnemyLiveRenderAttempts = self.worldEnemyLiveRenderAttempts + 1
    if self.worldEnemyNativeLanes then
        -- Never query native icon children or inspect restricted values in
        -- combat. Ready means engine delegated, NOT confirmed visible icons.
        self.worldEnemyLiveRenderLastResult = active and "native-delegated"
            or "native-parent-hidden"
        return true
    end
    local ok = pcall(function()
        renderLane(self.worldEnemyLiveLanes.harmful, rows, active)
        renderLane(self.worldEnemyLiveLanes.helpful, helpful, active)
    end)
    if not ok then
        self.worldEnemyLiveFailures = self.worldEnemyLiveFailures + 1
        self.worldEnemyLiveRenderLastResult = "owned-render-refused"
    else
        self.worldEnemyLiveRenderLastResult = active and "rendered" or "inactive"
    end
    return ok
end

-- P0448: NAME_PLATE_UNIT_ADDED/target events can attach a world frame after
-- the last target aura refresh. Scan the CURRENT target once on the attach
-- event, rather than replaying a stale snapshot or reading Blizzard UI.
-- Restricted/secret source data is never inferred or inspected.
function StatusAuras:RefreshWorldEnemyLiveSource(reason)
    if not self.moduleEnabled or self.preview then
        self.worldEnemySourceLastReason = "inactive"
        return false
    end
    self.worldEnemySourceAttachScans = self.worldEnemySourceAttachScans + 1
    local ok, snapshot = pcall(readUnit, "target")
    if not ok or type(snapshot) ~= "table" then
        self.worldEnemySourceAttachFailures =
            self.worldEnemySourceAttachFailures + 1
        self.worldEnemySourceLastReason = "scan-refused"
        return false
    end
    self.last.target = snapshot
    self:RecordLiveSnapshot("target", snapshot, reason or "world-enemy-attach")
    self.worldEnemySourceLastReason = snapshot.reason
    self.worldEnemySourceLastHarmful = #snapshot.harmfulRows
    self.worldEnemySourceLastHelpful = #snapshot.helpfulRows
    self.worldEnemySourceLastSecrets = snapshot.secretSkips
    self.worldEnemySourceLastFailures = snapshot.failures
    self:RefreshWorldEnemyLiveLanes()
    return true
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
        worldEnemySourceAttachScans = self.worldEnemySourceAttachScans,
        worldEnemySourceAttachFailures = self.worldEnemySourceAttachFailures,
        worldEnemySourceLastReason = self.worldEnemySourceLastReason,
        worldEnemySourceLastHarmful = self.worldEnemySourceLastHarmful,
        worldEnemySourceLastHelpful = self.worldEnemySourceLastHelpful,
        worldEnemySourceLastSecrets = self.worldEnemySourceLastSecrets,
        worldEnemySourceLastFailures = self.worldEnemySourceLastFailures,
        worldEnemyLiveRenderAttempts = self.worldEnemyLiveRenderAttempts,
        worldEnemyLiveFailures = self.worldEnemyLiveFailures,
        worldEnemyLiveRenderLastResult = self.worldEnemyLiveRenderLastResult,
        worldEnemyNativeReady = self.worldEnemyNativeLanes ~= nil,
        worldEnemyNativeReason = self.worldEnemyNativeReason,
        worldEnemyNativeVisibilityProof = "unobserved",
        worldEnemyScreenAuraOwned = self.worldEnemyScreenAuraOwned == true,
        worldEnemyScreenAuraReason = self.worldEnemyScreenAuraReason,
        worldEnemyScreenAuraHandoffs = self.worldEnemyScreenAuraHandoffs,
        worldEnemyScreenAuraRestores = self.worldEnemyScreenAuraRestores,
        worldEnemyScreenAuraFailures = self.worldEnemyScreenAuraFailures,
        worldEnemyLiveHarmfulSlots = self.worldEnemyLiveLanes
            and self.worldEnemyLiveLanes.harmful.visible or 0,
        worldEnemyLiveHelpfulSlots = self.worldEnemyLiveLanes
            and self.worldEnemyLiveLanes.helpful.visible or 0,
        worldEnemyLiveHarmfulShown = self.worldEnemyLiveLanes ~= nil
            and self.worldEnemyLiveLanes.harmful.root:IsShown(),
        worldEnemyLiveHelpfulShown = self.worldEnemyLiveLanes ~= nil
            and self.worldEnemyLiveLanes.helpful.root:IsShown(),
        lastReason = self.lastReason,
        stockPreserved = true,
        nativeReady = self.nativeDebuffs ~= nil,
        nativeActive = self.nativeDebuffs ~= nil and self.nativeActive == true,
        -- These are Logres-owned cached tokens, NOT native UI visibility.
        nativeEnabledCached = self.nativeDebuffs ~= nil
            and self.nativeDebuffs.active == true,
        nativeActivationReason = self.nativeActivationReason,
        stockPlayerHarmful = Logres.NativeDebuffs.StockPlayerHarmful() ~= nil,
        stockPlayerPlacementReason = self.nativeDebuffs and self.nativeDebuffs.stockPlacementReason,
        nativeReason = self.nativeReason,
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
    self.worldEnemySourceAttachScans = 0
    self.worldEnemySourceAttachFailures = 0
    self.worldEnemySourceLastReason = "not-attempted"
    self.worldEnemySourceLastHarmful = 0
    self.worldEnemySourceLastHelpful = 0
    self.worldEnemySourceLastSecrets = 0
    self.worldEnemySourceLastFailures = 0
    self.worldEnemyLiveRenderAttempts = 0
    self.worldEnemyLiveFailures = 0
    self.worldEnemyLiveRenderLastResult = "not-attempted"
    self.worldEnemyNativeLanes = nil
    self.worldEnemyNativeReason = "not-attempted"
    self.worldEnemyScreenAuraOwned = false
    self.worldEnemyScreenAuraReason = "not-attempted"
    self.worldEnemyScreenAuraHandoffs = 0
    self.worldEnemyScreenAuraRestores = 0
    self.worldEnemyScreenAuraFailures = 0
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
    -- Secure native renderer is an additive HARMFUL presentation path.
    -- Stock Blizzard aura frames and normal helpful presentation are retained.
    self.nativeDebuffs, self.nativeReason = Logres.NativeDebuffs.Create()
    self.nativeActive = false
    self.nativeActivationReason = self.nativeReason or "unavailable"
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
    self.regenEventRegistered = pcall(
        eventFrame.RegisterEvent, eventFrame, "PLAYER_REGEN_ENABLED"
    )
    eventFrame:SetScript("OnEvent", function(_, event, unit)
        if not self.moduleEnabled then
            if event == "PLAYER_REGEN_ENABLED" and self.nativeDebuffs
                and self.nativeDebuffs.stockPlacement then self:Refresh(event) end
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
        -- Event-driven diagnostic only: never inspect UNIT_AURA delta payloads.
        -- The existing renderer remains the only status presentation owner.
        if (event == "UNIT_AURA" or event == "PLAYER_TARGET_CHANGED")
            and not self.preview
        then
            local preferences = Logres:GetPreferences()
            if preferences.immersionEnabled == true then
                local observedUnit = event == "UNIT_AURA" and unit or "target"
                local ok = pcall(
                    Logres.AuraSourceEngine.ObserveEvent, observedUnit, event
                )
                if not ok then Logres.AuraSourceEngine.NoteEventFailure() end
            end
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
    self:SetWorldEnemyScreenAuraHandoff(false)
    self.moduleEnabled = false
    self.preview = false
    self:Refresh("disable")
end
