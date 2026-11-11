local _, Logres = ...

local ERROR_TEXT_LIMIT = 96

local Probe = Logres:RegisterModule("WorldTargetProbe", {
    autoEnable = true,
})

-- P0440: separate event-time unit-token observation from the existing
-- current-target hidden attachment probe. No Blizzard frame is retained.
local LIFECYCLE_EVENTS = {
    "NAME_PLATE_UNIT_ADDED",
    "NAME_PLATE_UNIT_REMOVED",
    "UNIT_TARGET",
    "UNIT_FLAGS",
    "UNIT_THREAT_LIST_UPDATE",
}

local EVENTS = {
    "PLAYER_TARGET_CHANGED",
    "NAME_PLATE_UNIT_ADDED",
    "NAME_PLATE_UNIT_REMOVED",
    "NAME_PLATE_UNIT_BEHIND_CAMERA_CHANGED",
    "PLAYER_ENTERING_WORLD",
}

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

local function truncateText(value)
    if #value <= ERROR_TEXT_LIMIT then
        return value
    end

    return value:sub(1, ERROR_TEXT_LIMIT - 3) .. "..."
end

local function safeErrorText(value)
    if isSecret(value) then
        return "secret-error"
    end

    if value == nil then
        return "unknown-error"
    end

    local valueType = type(value)

    if valueType ~= "string" then
        return valueType .. "-error"
    end

    return truncateText(value)
end

local function callOrdinary(api, ...)
    local result = {
        available = type(api) == "function",
        ok = false,
        secret = false,
        present = false,
        failure = false,
    }

    if not result.available then
        result.deferred = "api-unavailable"
        return result, nil
    end

    local ok, value = pcall(api, ...)
    result.ok = ok == true

    if not result.ok then
        result.failure = true
        result.error = safeErrorText(value)
        return result, nil
    end

    local secret = isSecret(value)
    result.secret = secret

    if secret then
        result.deferred = "secret-result"
        return result, nil
    end

    if value == nil then
        return result, nil
    end

    result.present = true
    return result, value
end

local function readBoolean(api, ...)
    local result, value = callOrdinary(api, ...)

    if not result.ok
        or result.secret
        or not result.present
    then
        return result
    end

    local valueType = type(value)

    if valueType ~= "boolean" then
        result.failure = true
        result.error = "unexpected-" .. valueType
        return result
    end

    result.value = value
    return result
end

local function readReaction()
    local result, value = callOrdinary(
        UnitReaction,
        "player",
        "target"
    )

    if not result.ok
        or result.secret
        or not result.present
    then
        return result
    end

    local valueType = type(value)

    if valueType ~= "number" then
        result.failure = true
        result.error = "unexpected-" .. valueType
        return result
    end

    if value <= 3 then
        result.category = "hostile"
    elseif value == 4 then
        result.category = "neutral"
    else
        result.category = "friendly"
    end

    return result
end

local function apiPresence()
    return {
        secretChecker = hasSecretChecker(),
        nameplate =
            C_NamePlate
            and type(C_NamePlate.GetNamePlateForUnit)
                == "function"
            or false,
        behindCamera =
            C_NamePlateManager
            and type(
                C_NamePlateManager.IsNamePlateUnitBehindCamera
            ) == "function"
            or false,
        reaction = type(UnitReaction) == "function",
        canAttack = type(UnitCanAttack) == "function",
        isFriend = type(UnitIsFriend) == "function",
        isTrivial = type(UnitIsTrivial) == "function",
        combatLockdown = type(InCombatLockdown) == "function",
    }
end

local function readNameplate()
    local api =
        C_NamePlate
        and C_NamePlate.GetNamePlateForUnit
        or nil

    return callOrdinary(
        api,
        "target",
        false
    )
end

local function readBehindCamera()
    local api =
        C_NamePlateManager
        and C_NamePlateManager.IsNamePlateUnitBehindCamera
        or nil

    return readBoolean(api, "target")
end

local function readReactionSources()
    return {
        reaction = readReaction(),
        canAttack = readBoolean(
            UnitCanAttack,
            "player",
            "target"
        ),
        isFriend = readBoolean(
            UnitIsFriend,
            "player",
            "target"
        ),
        isTrivial = readBoolean(
            UnitIsTrivial,
            "target"
        ),
    }
end

local function sourceFailureCount(source)
    if source and source.failure == true then
        return 1
    end

    return 0
end

local function sourceSecretCount(source)
    if source and source.secret == true then
        return 1
    end

    return 0
end

local function sanitizedBoolean(source)
    if source
        and source.ok
        and not source.secret
        and source.present
        and type(source.value) == "boolean"
    then
        return source.value
    end

    return nil
end

function Probe:TestAttachment(anchorFrame)
    local result = {
        attempted = false,
        passed = false,
        detached = false,
        failure = false,
    }

    local combat = readBoolean(InCombatLockdown)
    result.combat = combat

    if combat.failure then
        result.failure = true
        result.error = combat.error
        return result
    end

    if not combat.available
        or not combat.ok
        or combat.secret
        or not combat.present
    then
        result.deferred = "combat-state-unavailable"
        return result
    end

    if combat.value == true then
        result.deferred = "combat-lockdown"
        return result
    end

    local clearBeforeOK, clearBeforeError = pcall(
        self.anchorProxy.ClearAllPoints,
        self.anchorProxy
    )

    if not clearBeforeOK then
        result.failure = true
        result.error = safeErrorText(clearBeforeError)
        return result
    end

    result.attempted = true

    local setOK, setError = pcall(
        self.anchorProxy.SetPoint,
        self.anchorProxy,
        "BOTTOM",
        anchorFrame,
        "TOP",
        0,
        4
    )

    local clearOK, clearError = pcall(
        self.anchorProxy.ClearAllPoints,
        self.anchorProxy
    )

    result.detached = clearOK == true

    if not setOK then
        result.failure = true
        result.error = safeErrorText(setError)
        return result
    end

    if not clearOK then
        result.failure = true
        result.error = safeErrorText(clearError)
        return result
    end

    result.passed = true
    return result
end

local function attachmentState(attachment)
    if attachment == nil then
        return "not-attempted"
    end

    if attachment.failure then
        return "failed"
    end

    if attachment.passed then
        return "passed"
    end

    if attachment.deferred then
        return attachment.deferred
    end

    return "not-attempted"
end

function Probe:Capture(reason)
    self.captureCount = self.captureCount + 1

    local anchor, anchorFrame = readNameplate()
    local behind
    local attachment
    local worldCandidate = false
    local fallback = "no-accessible-nameplate"

    if anchor.failure then
        fallback = "anchor-query-failed"
    elseif anchor.secret then
        fallback = "secret-anchor-result"
    elseif anchor.present then
        behind = readBehindCamera()

        if behind.failure then
            fallback = "behind-camera-query-failed"
        elseif behind.secret then
            fallback = "secret-behind-camera-result"
        elseif not behind.present then
            fallback = "behind-camera-unavailable"
        elseif behind.value == true then
            fallback = "behind-camera"
        else
            attachment = self:TestAttachment(anchorFrame)

            if attachment.passed then
                worldCandidate = true
                fallback = "world-anchor-candidate"
            elseif attachment.failure then
                fallback = "attachment-failed"
            elseif attachment.deferred == "combat-lockdown" then
                fallback = "attachment-deferred-combat"
            else
                fallback = "attachment-deferred"
            end
        end
    end

    local reaction = readReactionSources()

    local failureCount =
        sourceFailureCount(anchor)
        + sourceFailureCount(behind)
        + sourceFailureCount(reaction.reaction)
        + sourceFailureCount(reaction.canAttack)
        + sourceFailureCount(reaction.isFriend)
        + sourceFailureCount(reaction.isTrivial)
        + (attachment and attachment.failure and 1 or 0)

    local secretSkipCount =
        sourceSecretCount(anchor)
        + sourceSecretCount(behind)
        + sourceSecretCount(reaction.reaction)
        + sourceSecretCount(reaction.canAttack)
        + sourceSecretCount(reaction.isFriend)
        + sourceSecretCount(reaction.isTrivial)
        + (
            attachment
            and attachment.combat
            and attachment.combat.secret
            and 1
            or 0
        )

    local capture = {
        reason = reason,
        anchor = anchor,
        behind = behind,
        attachment = attachment,
        reaction = reaction,
        fallback = fallback,
        worldCandidate = worldCandidate,
        failureCount = failureCount,
        secretSkipCount = secretSkipCount,
    }

    self.lastCapture = capture
    self.lastReason = reason
    -- The frame remains an ephemeral local value, never saved in the capture.
    -- An explicit developer trial may use it only after this hidden test passes.
    if worldCandidate == true
        and reaction.reaction.category == "hostile"
    then
        return capture, anchorFrame
    end
    return capture, nil
end

function Probe:AcquireWorldTrialAnchor()
    local capture, anchorFrame = self:Capture("world-trial")
    if capture.worldCandidate ~= true then
        return nil, capture.fallback
    end
    if capture.reaction.reaction.category ~= "hostile" or not anchorFrame then
        return nil, "not-hostile"
    end
    -- The nameplate is an ordinary anchor token, never an object to mutate.
    -- Fail closed if its forbidden state cannot be positively established.
    local forbidden = readBoolean(anchorFrame.IsForbidden, anchorFrame)
    if forbidden.failure or not forbidden.ok or forbidden.secret
        or not forbidden.present or forbidden.value ~= false
    then
        return nil, "forbidden-state-unavailable"
    end
    return anchorFrame, "hidden-attachment-passed"
end

-- P0440: consume a nameplate event's unit token only after proving it ordinary.
-- The token is never written to SavedVariables or retained on the module.
local function ordinaryNameplateToken(unit)
    if isSecret(unit) then return nil, "secret-token" end
    if type(unit) ~= "string" then return nil, "missing-token" end
    if #unit > 24 or not unit:match("^nameplate%d+$") then
        return nil, "non-nameplate-token"
    end
    return unit
end

local function readEventNameplate(unit)
    local api = C_NamePlate and C_NamePlate.GetNamePlateForUnit or nil
    return callOrdinary(api, unit, false)
end

local function readEventReaction(unit)
    local source, value = callOrdinary(UnitReaction, "player", unit)
    if source.ok and source.present and not source.secret then
        if type(value) ~= "number" then
            source.failure = true
            source.error = "unexpected-reaction-type"
        elseif value <= 3 then
            source.category = "hostile"
        elseif value == 4 then
            source.category = "neutral"
        else
            source.category = "friendly"
        end
    end
    return source
end

-- Event-time read-only proof: no frame creation, native mutations,
-- native enumeration, console-variable changes or polling.
-- A hostile, in-combat unit targeting the player is evidence of targeting;
-- it is not yet a verified threat/aggro contract for production 50% frames.
function Probe:ObserveNameplateLifecycle(event, eventUnit)
    self.lifecycleRawEvents = self.lifecycleRawEvents + 1
    self.lifecycleLastEvent = event
    local unit, reject = ordinaryNameplateToken(eventUnit)
    if not unit then
        self.lifecycleRejectedEvents = self.lifecycleRejectedEvents + 1
        if reject == "secret-token" then
            self.lifecycleSecretTokens = self.lifecycleSecretTokens + 1
        end
        self.lifecycleLastRole = "unknown"
        self.lifecycleLastAnchor = "not-read"
        self.lifecycleLastPlayerTargeting = "unknown"
        self.lifecycleLastResult = reject
        return
    end

    self.lifecycleAcceptedEvents = self.lifecycleAcceptedEvents + 1
    if event == "NAME_PLATE_UNIT_REMOVED" then
        self.lifecycleRemovedEvents = self.lifecycleRemovedEvents + 1
        self.lifecycleLastRole = "removed"
        self.lifecycleLastAnchor = "removed"
        self.lifecycleLastPlayerTargeting = "unknown"
        self.lifecycleLastResult = "unit-removed"
        return
    end
    if event == "NAME_PLATE_UNIT_ADDED" then
        self.lifecycleAddedEvents = self.lifecycleAddedEvents + 1
    elseif event == "UNIT_TARGET" then
        self.lifecycleUnitTargetEvents = self.lifecycleUnitTargetEvents + 1
    end

    local combat = readBoolean(InCombatLockdown)
    local role = readBoolean(UnitIsUnit, unit, "target")
    local reaction = readEventReaction(unit)
    local canAttack = readBoolean(UnitCanAttack, "player", unit)
    local enemyCombat = readBoolean(UnitAffectingCombat, unit)
    local playerTargeted = readBoolean(UnitIsUnit, unit .. "target", "player")
    local anchor, frame = readEventNameplate(unit)
    local forbidden, behind
    if anchor.ok and anchor.present and not anchor.secret and frame then
        -- Read only. A forbidden/secret/unknown anchor never qualifies.
        forbidden = readBoolean(frame.IsForbidden, frame)
        local api = C_NamePlateManager
            and C_NamePlateManager.IsNamePlateUnitBehindCamera or nil
        behind = readBoolean(api, unit)
    end

    local inCombat = sanitizedBoolean(combat)
    local currentTarget = sanitizedBoolean(role)
    local targetingPlayer = sanitizedBoolean(playerTargeted)
    local enemyInCombat = sanitizedBoolean(enemyCombat)
    local attackable = sanitizedBoolean(canAttack)
    local permitted = anchor.ok and not anchor.secret and anchor.present
        and sanitizedBoolean(forbidden) == false
        and sanitizedBoolean(behind) == false
        and not (forbidden and forbidden.failure)
        and not (behind and behind.failure)

    self.lifecycleLastRole = currentTarget == true and "target"
        or currentTarget == false and "secondary" or "unknown"
    self.lifecycleLastReaction = reaction.category or "unknown"
    self.lifecycleLastAnchor = permitted and "accessible-safe"
        or anchor.secret and "secret-anchor"
        or anchor.failure and "anchor-query-failed"
        or not anchor.present and "absent"
        or "anchor-unqualified"
    self.lifecycleLastPlayerTargeting = targetingPlayer == true and "yes"
        or targetingPlayer == false and "no" or "unknown"
    self.lifecycleLastResult = "observed"

    if permitted then
        if inCombat == true then
            self.lifecycleCombatAnchorsSeen = self.lifecycleCombatAnchorsSeen + 1
        elseif inCombat == false then
            self.lifecycleOutOfCombatAnchorsSeen =
                self.lifecycleOutOfCombatAnchorsSeen + 1
        end
        if currentTarget == true then
            self.lifecycleTargetAnchorsSeen = self.lifecycleTargetAnchorsSeen + 1
        elseif currentTarget == false then
            self.lifecycleSecondaryAnchorsSeen =
                self.lifecycleSecondaryAnchorsSeen + 1
        end
    end

    if currentTarget == false and targetingPlayer == true then
        self.lifecycleSecondaryTargetingPlayer =
            self.lifecycleSecondaryTargetingPlayer + 1
        -- Strictly positive candidate; not enough alone to prove aggro.
        if inCombat == true and enemyInCombat == true
            and reaction.category == "hostile" and attackable == true
        then
            self.lifecycleCombatHostileTargetingPlayer =
                self.lifecycleCombatHostileTargetingPlayer + 1
            self.lifecycleLastResult = "hostile-combat-targeting-player"
        end
    end

    local sources = {combat, role, reaction, canAttack, enemyCombat,
        playerTargeted, anchor, forbidden, behind}
    for i = 1, #sources do
        local source = sources[i]
        if source and source.secret == true then
            self.lifecycleSecretResults = self.lifecycleSecretResults + 1
        end
        if source and source.failure == true then
            self.lifecycleFailures = self.lifecycleFailures + 1
        end
    end
end

function Probe:GetNameplateLifecycleLines()
    return {
        string.format(
            "Nameplate lifecycle (READ ONLY): raw=%s accepted=%s rejected=%s secretTokens=%s add=%s remove=%s unitTarget=%s",
            tostring(self.lifecycleRawEvents), tostring(self.lifecycleAcceptedEvents),
            tostring(self.lifecycleRejectedEvents), tostring(self.lifecycleSecretTokens),
            tostring(self.lifecycleAddedEvents), tostring(self.lifecycleRemovedEvents),
            tostring(self.lifecycleUnitTargetEvents)),
        string.format(
            "Nameplate anchors: target=%s secondary=%s combat=%s OOC=%s; lastEvent=%s role=%s reaction=%s anchor=%s",
            tostring(self.lifecycleTargetAnchorsSeen), tostring(self.lifecycleSecondaryAnchorsSeen),
            tostring(self.lifecycleCombatAnchorsSeen), tostring(self.lifecycleOutOfCombatAnchorsSeen),
            tostring(self.lifecycleLastEvent), tostring(self.lifecycleLastRole),
            tostring(self.lifecycleLastReaction), tostring(self.lifecycleLastAnchor)),
        string.format(
            "Enemy targeting player: secondary=%s hostileInCombat=%s last=%s result=%s secretResults=%s failures=%s; aggro NOT YET PROVEN",
            tostring(self.lifecycleSecondaryTargetingPlayer),
            tostring(self.lifecycleCombatHostileTargetingPlayer),
            tostring(self.lifecycleLastPlayerTargeting), tostring(self.lifecycleLastResult),
            tostring(self.lifecycleSecretResults), tostring(self.lifecycleFailures)),
    }
end

function Probe:RunDevNameplateLifecycleStatus(emit)
    -- Reads only addon-owned scalar observations; no live protected reads.
    local lines = self:GetNameplateLifecycleLines()
    for i = 1, #lines do emit(lines[i]) end
end

-- P0441: opt-in world display may request a short-lived, ordinary anchor
-- during nameplate events. It never writes to the Blizzard frame.
-- P0440's read-only lifecycle observations remain independent.
function Probe:AcquireLiveEnemyTargetAnchor(eventUnit, fromEvent)
    local unit = "target"
    if fromEvent == true then
        local token, reason = ordinaryNameplateToken(eventUnit)
        if not token then return nil, reason end
        unit = token
        local target = readBoolean(UnitIsUnit, unit, "target")
        if not target.ok or target.secret or target.value ~= true then
            return nil, "not-current-target"
        end
    end

    local reaction = readEventReaction(unit)
    if reaction.category ~= "hostile" then
        return nil, "not-hostile"
    end
    local attack = readBoolean(UnitCanAttack, "player", unit)
    if not attack.ok or attack.secret or attack.value ~= true then
        return nil, "not-attackable"
    end
    local source, anchor = readEventNameplate(unit)
    if not source.ok or source.secret or not source.present or not anchor then
        return nil, "no-accessible-nameplate"
    end
    local forbidden = readBoolean(anchor.IsForbidden, anchor)
    if not forbidden.ok or forbidden.secret or forbidden.value ~= false then
        return nil, "forbidden-or-unknown"
    end
    local api = C_NamePlateManager
        and C_NamePlateManager.IsNamePlateUnitBehindCamera
    local behind = readBoolean(api, unit)
    if not behind.ok or behind.secret or behind.value ~= false then
        return nil, "behind-camera-or-unknown"
    end
    return anchor, "accessible-hostile-target", fromEvent == true and unit or nil
end

-- Removal events must never reacquire a potentially stale native anchor.
-- Comparing two ordinary event tokens is allowed; unknown identity fails
-- open by hiding the owned overlay, never native interaction or fallback.
function Probe:IsLiveEnemyRemovalRelevant(eventUnit, attachedUnit)
    local unit, reason = ordinaryNameplateToken(eventUnit)
    if not unit then return true, reason end
    if attachedUnit == nil then return true, "unknown-attached-unit" end
    if unit == attachedUnit then return true, "attached-unit-removed" end
    return false, "other-unit-removed"
end

-- Preserve bounded event-time evidence instead of allowing a later Report Bug
-- (or target loss) to overwrite the only in-combat nameplate observation.
-- This observes the current target only; secondary anchors and aggro are NOT
-- inferred from nameplate event counts or unexamined event unit tokens.
function Probe:RecordEventAnchor(reason, capture)
    local combat = readBoolean(InCombatLockdown)
    local active = sanitizedBoolean(combat)
    if active == nil then
        self.combatStateUnknownSamples = self.combatStateUnknownSamples + 1
        return
    end

    local ordinaryAnchor = capture.anchor
        and capture.anchor.ok == true
        and capture.anchor.secret ~= true
        and capture.anchor.present == true
        or false

    if active == true then
        self.combatEventSamples = self.combatEventSamples + 1
        self.lastCombatEvent = reason
        self.lastCombatAnchorPresent = ordinaryAnchor
        self.lastCombatFallback = capture.fallback
        self.lastCombatAttachmentState = attachmentState(capture.attachment)
        if ordinaryAnchor then
            self.targetAnchorEverSeenInCombat = true
            self.lastCombatPositiveEvent = reason
        end
    else
        self.outOfCombatEventSamples = self.outOfCombatEventSamples + 1
        self.lastOutOfCombatEvent = reason
        if ordinaryAnchor then
            self.targetAnchorEverSeenOutOfCombat = true
        end
        if capture.worldCandidate == true then
            self.worldCandidateEverSeenOutOfCombat = true
        end
    end
end

function Probe:CaptureManual()
    self.manualCount = self.manualCount + 1
    return self:Capture("manual")
end

local function boolText(value)
    if value == nil then
        return "-"
    end

    return value and "true" or "false"
end

local function sourceState(source)
    if source == nil then
        return "not-read"
    end

    if source.failure then
        return "FAIL(" .. tostring(source.error) .. ")"
    end

    if not source.available then
        return "DEFERRED(api-unavailable)"
    end

    if source.secret then
        return "DEFERRED(secret-result)"
    end

    if not source.ok then
        return "DEFERRED(call-unproven)"
    end

    if not source.present then
        return "absent"
    end

    return "ordinary"
end

function Probe:GetDiagnosticLines()
    local capture = self.lastCapture

    if not capture then
        return {
            "no capture available",
        }
    end

    local reaction = capture.reaction

    return {
        string.format(
            "anchor=%s present=%s behind=%s attachment=%s candidate=%s fallback=%s",
            sourceState(capture.anchor),
            boolText(capture.anchor.present),
            capture.behind
                and boolText(sanitizedBoolean(capture.behind))
                or "-",
            attachmentState(capture.attachment),
            boolText(capture.worldCandidate),
            tostring(capture.fallback)
        ),
        string.format(
            "reaction=%s category=%s canAttack=%s friend=%s trivial=%s secretSkips=%s failures=%s",
            sourceState(reaction.reaction),
            tostring(reaction.reaction.category or "-"),
            boolText(sanitizedBoolean(reaction.canAttack)),
            boolText(sanitizedBoolean(reaction.isFriend)),
            boolText(sanitizedBoolean(reaction.isTrivial)),
            tostring(capture.secretSkipCount),
            tostring(capture.failureCount)
        ),
    }
end

function Probe:GetDebugStatus()
    local api = apiPresence()
    local capture = self.lastCapture
    local anchor = capture and capture.anchor or {}
    local reaction = capture and capture.reaction or {}

    return {
        -- Event-time, unit-token evidence; never a stored Blizzard frame.
        lifecycleEventFrameReady = self.lifecycleFrame ~= nil,
        lifecycleNameplateAddedRegistered =
            self.lifecycleRegistration.NAME_PLATE_UNIT_ADDED == true,
        lifecycleNameplateRemovedRegistered =
            self.lifecycleRegistration.NAME_PLATE_UNIT_REMOVED == true,
        lifecycleUnitTargetRegistered =
            self.lifecycleRegistration.UNIT_TARGET == true,
        lifecycleRawEvents = self.lifecycleRawEvents,
        lifecycleAcceptedEvents = self.lifecycleAcceptedEvents,
        lifecycleRejectedEvents = self.lifecycleRejectedEvents,
        lifecycleSecretTokens = self.lifecycleSecretTokens,
        lifecycleAddedEvents = self.lifecycleAddedEvents,
        lifecycleRemovedEvents = self.lifecycleRemovedEvents,
        lifecycleUnitTargetEvents = self.lifecycleUnitTargetEvents,
        lifecycleTargetAnchorsSeen = self.lifecycleTargetAnchorsSeen,
        lifecycleSecondaryAnchorsSeen = self.lifecycleSecondaryAnchorsSeen,
        lifecycleCombatAnchorsSeen = self.lifecycleCombatAnchorsSeen,
        lifecycleOutOfCombatAnchorsSeen = self.lifecycleOutOfCombatAnchorsSeen,
        lifecycleSecondaryTargetingPlayer = self.lifecycleSecondaryTargetingPlayer,
        lifecycleCombatHostileTargetingPlayer =
            self.lifecycleCombatHostileTargetingPlayer,
        lifecycleLastEvent = self.lifecycleLastEvent,
        lifecycleLastRole = self.lifecycleLastRole,
        lifecycleLastReaction = self.lifecycleLastReaction,
        lifecycleLastAnchor = self.lifecycleLastAnchor,
        lifecycleLastPlayerTargeting = self.lifecycleLastPlayerTargeting,
        lifecycleLastResult = self.lifecycleLastResult,
        lifecycleSecretResults = self.lifecycleSecretResults,
        lifecycleFailures = self.lifecycleFailures,
        moduleEnabled = self.moduleEnabled == true,
        eventFrameReady = self.eventFrame ~= nil,
        proxyReady = self.anchorProxy ~= nil,
        captureCount = self.captureCount,
        manualCount = self.manualCount,
        combatEventSamples = self.combatEventSamples,
        outOfCombatEventSamples = self.outOfCombatEventSamples,
        combatStateUnknownSamples = self.combatStateUnknownSamples,
        targetAnchorEverSeenInCombat = self.targetAnchorEverSeenInCombat,
        targetAnchorEverSeenOutOfCombat = self.targetAnchorEverSeenOutOfCombat,
        worldCandidateEverSeenOutOfCombat = self.worldCandidateEverSeenOutOfCombat,
        lastCombatEvent = self.lastCombatEvent,
        lastCombatPositiveEvent = self.lastCombatPositiveEvent,
        lastCombatAnchorPresent = self.lastCombatAnchorPresent,
        lastCombatFallback = self.lastCombatFallback,
        lastCombatAttachmentState = self.lastCombatAttachmentState,
        lastOutOfCombatEvent = self.lastOutOfCombatEvent,
        lastReason = self.lastReason,
        secretCheckerAvailable = api.secretChecker,
        nameplateAPIAvailable = api.nameplate,
        behindCameraAPIAvailable = api.behindCamera,
        reactionAPIAvailable = api.reaction,
        canAttackAPIAvailable = api.canAttack,
        isFriendAPIAvailable = api.isFriend,
        isTrivialAPIAvailable = api.isTrivial,
        combatLockdownAPIAvailable = api.combatLockdown,
        targetChangedRegistered =
            self.eventRegistration.PLAYER_TARGET_CHANGED
                == true,
        nameplateAddedRegistered =
            self.eventRegistration.NAME_PLATE_UNIT_ADDED
                == true,
        nameplateRemovedRegistered =
            self.eventRegistration.NAME_PLATE_UNIT_REMOVED
                == true,
        behindCameraChangedRegistered =
            self.eventRegistration.NAME_PLATE_UNIT_BEHIND_CAMERA_CHANGED
                == true,
        enteringWorldRegistered =
            self.eventRegistration.PLAYER_ENTERING_WORLD
                == true,
        targetChangedEvents =
            self.eventCounts.PLAYER_TARGET_CHANGED or 0,
        nameplateAddedEvents =
            self.eventCounts.NAME_PLATE_UNIT_ADDED or 0,
        nameplateRemovedEvents =
            self.eventCounts.NAME_PLATE_UNIT_REMOVED or 0,
        behindCameraChangedEvents =
            self.eventCounts.NAME_PLATE_UNIT_BEHIND_CAMERA_CHANGED or 0,
        enteringWorldEvents =
            self.eventCounts.PLAYER_ENTERING_WORLD or 0,
        failureCount = capture and capture.failureCount or 0,
        secretSkipCount = capture and capture.secretSkipCount or 0,
        anchorPresent = anchor.present == true,
        worldCandidate = capture and capture.worldCandidate == true or false,
        fallback = capture and capture.fallback or "uncaptured",
        behindCamera =
            capture
            and capture.behind
            and sanitizedBoolean(capture.behind)
            or nil,
        attachmentState =
            capture
            and attachmentState(capture.attachment)
            or "uncaptured",
        reactionCategory =
            reaction.reaction
            and reaction.reaction.category
            or nil,
        canAttack = sanitizedBoolean(reaction.canAttack),
        isFriend = sanitizedBoolean(reaction.isFriend),
        isTrivial = sanitizedBoolean(reaction.isTrivial),
    }
end

function Probe:OnInitialize()
    -- Bounded scalar counters; never retain nameplate tokens or frame objects.
    self.lifecycleRawEvents = 0
    self.lifecycleAcceptedEvents = 0
    self.lifecycleRejectedEvents = 0
    self.lifecycleSecretTokens = 0
    self.lifecycleAddedEvents = 0
    self.lifecycleRemovedEvents = 0
    self.lifecycleUnitTargetEvents = 0
    self.lifecycleTargetAnchorsSeen = 0
    self.lifecycleSecondaryAnchorsSeen = 0
    self.lifecycleCombatAnchorsSeen = 0
    self.lifecycleOutOfCombatAnchorsSeen = 0
    self.lifecycleSecondaryTargetingPlayer = 0
    self.lifecycleCombatHostileTargetingPlayer = 0
    self.lifecycleSecretResults = 0
    self.lifecycleFailures = 0
    self.lifecycleLastEvent = "none"
    self.lifecycleLastRole = "unknown"
    self.lifecycleLastReaction = "unknown"
    self.lifecycleLastAnchor = "uncaptured"
    self.lifecycleLastPlayerTargeting = "unknown"
    self.lifecycleLastResult = "uncaptured"
    self.lifecycleRegistration = {}
    self.moduleEnabled = false
    self.captureCount = 0
    self.manualCount = 0
    -- Session-scoped scalar observations; no Blizzard frame/token retained.
    self.combatEventSamples = 0
    self.outOfCombatEventSamples = 0
    self.combatStateUnknownSamples = 0
    self.targetAnchorEverSeenInCombat = false
    self.targetAnchorEverSeenOutOfCombat = false
    self.worldCandidateEverSeenOutOfCombat = false
    self.lastCombatEvent = "none"
    self.lastCombatPositiveEvent = "none"
    self.lastCombatAnchorPresent = false
    self.lastCombatFallback = "uncaptured"
    self.lastCombatAttachmentState = "uncaptured"
    self.lastOutOfCombatEvent = "none"
    self.lastCapture = nil
    self.lastReason = nil
    self.eventCounts = {}
    self.eventRegistration = {}

    for index = 1, #EVENTS do
        local event = EVENTS[index]
        self.eventCounts[event] = 0
        self.eventRegistration[event] = false
    end

    local proxy = CreateFrame("Frame", nil, UIParent)
    proxy:SetSize(1, 1)
    proxy:Hide()
    self.anchorProxy = proxy

    local eventFrame = CreateFrame("Frame")

    for index = 1, #EVENTS do
        local event = EVENTS[index]
        self.eventRegistration[event] = pcall(
            eventFrame.RegisterEvent,
            eventFrame,
            event
        )
    end

    eventFrame:SetScript("OnEvent", function(_, event)
        if self.moduleEnabled ~= true then
            return
        end

        self.eventCounts[event] =
            (self.eventCounts[event] or 0) + 1

        local capture = self:Capture(event)
        self:RecordEventAnchor(event, capture)
    end)

    self.eventFrame = eventFrame

    -- Independent event channel preserves P0432's historical target-only
    -- capture lifecycle, including its exact payload-discard contract.
    local lifecycleFrame = CreateFrame("Frame")
    for index = 1, #LIFECYCLE_EVENTS do
        local event = LIFECYCLE_EVENTS[index]
        self.lifecycleRegistration[event] = pcall(
            lifecycleFrame.RegisterEvent, lifecycleFrame, event)
    end
    lifecycleFrame:SetScript("OnEvent", function(_, event, unit)
        if self.moduleEnabled ~= true then return end
        self:ObserveNameplateLifecycle(event, unit)
    end)
    self.lifecycleFrame = lifecycleFrame
end

function Probe:OnEnable()
    self.moduleEnabled = true
    self:Capture("enable")
    self:RecordEventAnchor("enable", self.lastCapture)
end

function Probe:OnDisable()
    self.moduleEnabled = false

    if self.anchorProxy then
        pcall(
            self.anchorProxy.ClearAllPoints,
            self.anchorProxy
        )
    end
end

function Probe:RunDevWorldTargetProbe(emit)
    local status =
        Logres:GetModuleStatus("WorldTargetProbe")
    local probe =
        Logres:GetModule("WorldTargetProbe")
    local capture = probe:CaptureManual()
    local debugStatus = probe:GetDebugStatus()
    local captureOK = type(capture) == "table"

    local passed =
        captureOK
        and status.initialized == true
        and status.enabled == true
        and debugStatus.moduleEnabled == true
        and debugStatus.eventFrameReady == true
        and debugStatus.proxyReady == true
        and debugStatus.secretCheckerAvailable == true
        and debugStatus.nameplateAPIAvailable == true
        and debugStatus.behindCameraAPIAvailable == true
        and debugStatus.reactionAPIAvailable == true
        and debugStatus.canAttackAPIAvailable == true
        and debugStatus.isFriendAPIAvailable == true
        and debugStatus.isTrivialAPIAvailable == true
        and debugStatus.combatLockdownAPIAvailable == true
        and debugStatus.targetChangedRegistered == true
        and debugStatus.nameplateAddedRegistered == true
        and debugStatus.nameplateRemovedRegistered == true
        and debugStatus.behindCameraChangedRegistered == true
        and debugStatus.enteringWorldRegistered == true
        and debugStatus.failureCount == 0

    emit(string.format(
        "Logres worldtargetprobe: %s (capture=%s captures=%s manual=%s last=%s events=target:%s add:%s remove:%s behind:%s world:%s api=secret:%s plate:%s behind:%s reaction:%s attack:%s friend:%s trivial:%s combat:%s anchor=%s candidate=%s attachment=%s fallback=%s reactionCategory=%s canAttack=%s friend=%s trivial=%s secretSkips=%s failures=%s)",
        passed and "PASS" or "FAIL",
        tostring(captureOK),
        tostring(debugStatus.captureCount),
        tostring(debugStatus.manualCount),
        tostring(debugStatus.lastReason),
        tostring(debugStatus.targetChangedEvents),
        tostring(debugStatus.nameplateAddedEvents),
        tostring(debugStatus.nameplateRemovedEvents),
        tostring(debugStatus.behindCameraChangedEvents),
        tostring(debugStatus.enteringWorldEvents),
        tostring(debugStatus.secretCheckerAvailable),
        tostring(debugStatus.nameplateAPIAvailable),
        tostring(debugStatus.behindCameraAPIAvailable),
        tostring(debugStatus.reactionAPIAvailable),
        tostring(debugStatus.canAttackAPIAvailable),
        tostring(debugStatus.isFriendAPIAvailable),
        tostring(debugStatus.isTrivialAPIAvailable),
        tostring(debugStatus.combatLockdownAPIAvailable),
        tostring(debugStatus.anchorPresent),
        tostring(debugStatus.worldCandidate),
        tostring(debugStatus.attachmentState),
        tostring(debugStatus.fallback),
        tostring(debugStatus.reactionCategory),
        tostring(debugStatus.canAttack),
        tostring(debugStatus.isFriend),
        tostring(debugStatus.isTrivial),
        tostring(debugStatus.secretSkipCount),
        tostring(debugStatus.failureCount)
    ))

    local lines = probe:GetDiagnosticLines()

    for index = 1, #lines do
        emit(
            "Logres worldtargetprobe: "
            .. tostring(lines[index])
        )
    end
end
