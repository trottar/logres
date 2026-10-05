local _, Logres = ...

local ERROR_TEXT_LIMIT = 96

local Probe = Logres:RegisterModule("WorldTargetProbe", {
    autoEnable = true,
})

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
    return capture
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
        moduleEnabled = self.moduleEnabled == true,
        eventFrameReady = self.eventFrame ~= nil,
        proxyReady = self.anchorProxy ~= nil,
        captureCount = self.captureCount,
        manualCount = self.manualCount,
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
    self.moduleEnabled = false
    self.captureCount = 0
    self.manualCount = 0
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

        self:Capture(event)
    end)

    self.eventFrame = eventFrame
end

function Probe:OnEnable()
    self.moduleEnabled = true
    self:Capture("enable")
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
