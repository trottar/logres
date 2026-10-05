local _, Logres = ...

local Probe = Logres:RegisterModule("QuestOfferActionProbe", {
    autoEnable = true,
})

local TRACKED_EVENTS = {
    "QUEST_DETAIL",
    "QUEST_ACCEPTED",
    "QUEST_FINISHED",
    "PLAYER_ENTERING_WORLD",
}

local function isSecret(value)
    if type(issecretvalue) ~= "function" then
        return false
    end

    local ok, result = pcall(issecretvalue, value)
    return ok and result or false
end

local function safeErrorText(value)
    if isSecret(value) then
        return "<secret-error>"
    end

    if value == nil then
        return "nil"
    end

    return tostring(value)
end

local function readCurrentOfferIdentity()
    if type(GetQuestID) ~= "function" then
        return nil, "quest-id-api-unavailable", false
    end

    if type(GetTitleText) ~= "function" then
        return nil, "title-api-unavailable", false
    end

    local questOK, questID = pcall(GetQuestID)

    if not questOK then
        return nil, "quest-id-call-failed", false
    end

    if isSecret(questID) then
        return nil, "quest-id-secret", true
    end

    if questID == nil then
        return nil, "quest-id-unavailable", false
    end

    if type(questID) ~= "number"
        or questID <= 0
    then
        return nil, "quest-id-invalid", false
    end

    local titleOK, title = pcall(GetTitleText)

    if not titleOK then
        return nil, "title-call-failed", false
    end

    if isSecret(title) then
        return nil, "title-secret", true
    end

    if type(title) ~= "string"
        or title == ""
    then
        return nil, "title-invalid", false
    end

    return {
        questID = questID,
        title = title,
    }, nil, false
end

local function terminalState(state)
    return state == "event-confirmed"
        or state == "event-mismatch"
        or state == "call-failed"
        or state == "offer-replaced-before-outcome"
        or state == "world-transition-before-outcome"
end

local function captureEventArgs(...)
    local count = select("#", ...)
    local records = {}
    local secretObserved = false

    for index = 1, count do
        local value = select(index, ...)
        local secret = isSecret(value)
        local record = {
            index = index,
            secret = secret,
        }

        if secret then
            secretObserved = true
        elseif value == nil then
            record.present = false
        else
            record.present = true
            record.valueType = type(value)

            if record.valueType == "number"
                or record.valueType == "boolean"
                or record.valueType == "string"
            then
                record.value = value
            end
        end

        records[#records + 1] = record
    end

    return records, secretObserved
end

local function acceptedIdentityState(records, questID)
    local numericObserved = false
    local secretObserved = false

    for index = 1, #records do
        local record = records[index]

        if record.secret == true then
            secretObserved = true
        elseif record.present == true
            and record.valueType == "number"
        then
            numericObserved = true

            if record.value == questID then
                return "matched"
            end
        end
    end

    if secretObserved then
        return "secret"
    end

    if numericObserved then
        return "mismatch"
    end

    return "unavailable"
end

function Probe:RecordBlocked(kind, reason, secretObserved)
    self.blockedCount = self.blockedCount + 1
    self.lastBlockedKind = kind
    self.lastBlockedReason = reason
    self.lastSecret = secretObserved and true or false
    self.lastError = reason
end

function Probe:CaptureOffer(reason)
    if self.pendingAction ~= nil then
        local action = self.pendingAction
        action.state = "offer-replaced-before-outcome"
        action.event = "QUEST_DETAIL"
        action.success = false

        if action.source == "production" then
            action.reported = true
        end

        self.pendingAction = nil
        self.lastAction = action
        self.failureCount = self.failureCount + 1
    end

    local offer, errorText, secretObserved =
        readCurrentOfferIdentity()

    self.offerGeneration = self.offerGeneration + 1
    self.lastOfferReason = reason
    self.lastSecret = secretObserved and true or false
    self.lastError = errorText

    if not offer then
        self.currentOffer = nil
        self.offerOpen = false
        return false, errorText
    end

    self.currentOffer = {
        questID = offer.questID,
        title = offer.title,
        generation = self.offerGeneration,
    }
    self.offerOpen = true
    self.lastError = nil

    return true, "captured"
end

function Probe:ResolveAccepted(...)
    local action = self.pendingAction

    if not action
        or action.kind ~= "accept"
    then
        return
    end

    local records, secretObserved =
        captureEventArgs(...)
    local identityState =
        acceptedIdentityState(
            records,
            action.questID
        )

    action.event = "QUEST_ACCEPTED"
    action.eventArgs = records
    action.eventSecret = secretObserved
    action.eventIdentityState = identityState

    if identityState == "mismatch"
        or identityState == "secret"
    then
        action.state = "event-mismatch"
        action.success = false
        self.failureCount = self.failureCount + 1
    else
        action.state = "event-confirmed"
        action.success = true
        self.successCount = self.successCount + 1
    end

    if action.source == "production" then
        action.reported = true
    end

    self.pendingAction = nil
    self.lastAction = action
    self.offerOpen = false
    self.currentOffer = nil
end

function Probe:ResolveFinished()
    local action = self.pendingAction

    if action then
        action.event = "QUEST_FINISHED"
        action.finishedObserved = true

        if action.kind == "decline" then
            action.state = "event-confirmed"
            action.success = true
            self.successCount = self.successCount + 1

            if action.source == "production" then
                action.reported = true
            end

            self.pendingAction = nil
        else
            action.state = "awaiting-accepted-after-finished"
            action.success = false
        end

        self.lastAction = action
    end

    self.offerOpen = false
    self.currentOffer = nil
end

function Probe:ResolveWorldTransition()
    local action = self.pendingAction

    if action then
        action.event = "PLAYER_ENTERING_WORLD"
        action.state = "world-transition-before-outcome"
        action.success = false
        if action.source == "production" then
            action.reported = true
        end

        self.pendingAction = nil
        self.lastAction = action
        self.failureCount = self.failureCount + 1
    end

    self.offerOpen = false
    self.currentOffer = nil
end

function Probe:TriggerAction(kind, source)
    source = source or "diagnostic"

    if not self.moduleEnabled then
        self:RecordBlocked(
            kind,
            "module-disabled",
            false
        )
        return false, "module-disabled"
    end

    if kind ~= "accept"
        and kind ~= "decline"
    then
        self:RecordBlocked(
            kind,
            "invalid-action-kind",
            false
        )
        return false, "invalid-action-kind"
    end

    if self.pendingAction ~= nil then
        self:RecordBlocked(
            kind,
            "action-pending",
            false
        )
        return false, "action-pending"
    end

    if self.lastAction
        and terminalState(self.lastAction.state)
        and self.lastAction.reported ~= true
    then
        self:RecordBlocked(
            kind,
            "unreported-result",
            false
        )
        return false, "unreported-result"
    end

    if not self.offerOpen
        or not self.currentOffer
    then
        self:RecordBlocked(
            kind,
            "no-current-offer",
            false
        )
        return false, "no-current-offer"
    end

    local offer, errorText, secretObserved =
        readCurrentOfferIdentity()

    if not offer then
        self:RecordBlocked(
            kind,
            errorText,
            secretObserved
        )
        return false, errorText
    end

    if offer.questID ~= self.currentOffer.questID then
        self:RecordBlocked(
            kind,
            "offer-identity-changed",
            false
        )
        return false, "offer-identity-changed"
    end

    if kind == "accept"
        and type(AcceptQuest) ~= "function"
    then
        self:RecordBlocked(
            kind,
            "accept-api-unavailable",
            false
        )
        return false, "accept-api-unavailable"
    end

    if kind == "decline"
        and type(DeclineQuest) ~= "function"
    then
        self:RecordBlocked(
            kind,
            "decline-api-unavailable",
            false
        )
        return false, "decline-api-unavailable"
    end

    local action = {
        source = source,
        kind = kind,
        questID = offer.questID,
        title = offer.title,
        offerGeneration = self.currentOffer.generation,
        state = "invoking",
        success = false,
        callOK = false,
        reported = false,
        event = nil,
        eventIdentityState = nil,
        eventSecret = false,
        finishedObserved = false,
        error = nil,
    }

    self.actionAttemptCount =
        self.actionAttemptCount + 1
    self.mutationCallCount =
        self.mutationCallCount + 1

    if source == "production" then
        self.productionAttemptCount =
            self.productionAttemptCount + 1
    end

    if kind == "accept" then
        self.acceptAttemptCount =
            self.acceptAttemptCount + 1
    else
        self.declineAttemptCount =
            self.declineAttemptCount + 1
    end

    self.pendingAction = action
    self.lastAction = action
    self.lastSecret = false
    self.lastError = nil

    local callOK, callError

    if kind == "accept" then
        callOK, callError = pcall(AcceptQuest)
    else
        callOK, callError = pcall(DeclineQuest)
    end

    action.callOK = callOK == true

    if not callOK then
        action.error = safeErrorText(callError)
        action.state = "call-failed"
        action.success = false

        if action.source == "production" then
            action.reported = true
        end

        if self.pendingAction == action then
            self.pendingAction = nil
        end

        self.lastAction = action
        self.lastError = action.error
        self.failureCount = self.failureCount + 1
        return false, "call-failed"
    end

    if self.pendingAction == action
        and action.finishedObserved ~= true
    then
        action.state = "awaiting-event"
    end

    return true, "started"
end

function Probe:TriggerProductionAction(
    kind,
    expectedQuestID,
    expectedTitle
)
    if type(expectedQuestID) ~= "number"
        or expectedQuestID <= 0
    then
        self:RecordBlocked(
            kind,
            "expected-quest-invalid",
            false
        )
        return false, "expected-quest-invalid"
    end

    if type(expectedTitle) ~= "string"
        or expectedTitle == ""
    then
        self:RecordBlocked(
            kind,
            "expected-title-invalid",
            false
        )
        return false, "expected-title-invalid"
    end

    if not self.offerOpen
        or not self.currentOffer
    then
        self:RecordBlocked(
            kind,
            "no-current-offer",
            false
        )
        return false, "no-current-offer"
    end

    if self.currentOffer.questID
            ~= expectedQuestID
        or self.currentOffer.title
            ~= expectedTitle
    then
        self:RecordBlocked(
            kind,
            "bound-offer-mismatch",
            false
        )
        return false, "bound-offer-mismatch"
    end

    return self:TriggerAction(
        kind,
        "production"
    )
end

function Probe:HandlePanelAction(kind)
    if self.pendingAction ~= nil then
        return "pending", self.pendingAction.state
    end

    if self.lastAction
        and terminalState(self.lastAction.state)
        and self.lastAction.reported ~= true
    then
        if self.lastAction.kind == kind then
            return "result", self.lastAction.state
        end

        return "blocked", "unreported-result"
    end

    local ok, reason =
        self:TriggerAction(
            kind,
            "diagnostic"
        )

    if ok then
        return "started", reason
    end

    return "blocked", reason
end

function Probe:MarkReported(kind)
    if not self.lastAction
        or self.lastAction.kind ~= kind
        or not terminalState(self.lastAction.state)
    then
        return false
    end

    self.lastAction.reported = true
    return true
end

function Probe:GetDebugStatus()
    local action = self.lastAction

    return {
        moduleEnabled = self.moduleEnabled == true,
        eventFrameReady = self.eventFrame ~= nil,

        questDetailRegistered =
            self.eventRegistration.QUEST_DETAIL == true,
        questAcceptedRegistered =
            self.eventRegistration.QUEST_ACCEPTED == true,
        questFinishedRegistered =
            self.eventRegistration.QUEST_FINISHED == true,
        worldRegistered =
            self.eventRegistration.PLAYER_ENTERING_WORLD == true,

        questDetailCount =
            self.eventCounts.QUEST_DETAIL or 0,
        questAcceptedCount =
            self.eventCounts.QUEST_ACCEPTED or 0,
        questFinishedCount =
            self.eventCounts.QUEST_FINISHED or 0,
        worldCount =
            self.eventCounts.PLAYER_ENTERING_WORLD or 0,

        offerOpen = self.offerOpen == true,
        currentQuestID =
            self.currentOffer
            and self.currentOffer.questID
            or nil,
        currentTitle =
            self.currentOffer
            and self.currentOffer.title
            or nil,
        offerGeneration = self.offerGeneration,
        lastOfferReason = self.lastOfferReason,

        actionAttemptCount = self.actionAttemptCount,
        productionAttemptCount =
            self.productionAttemptCount,
        acceptAttemptCount = self.acceptAttemptCount,
        declineAttemptCount = self.declineAttemptCount,
        mutationCallCount = self.mutationCallCount,
        blockedCount = self.blockedCount,
        successCount = self.successCount,
        failureCount = self.failureCount,

        pendingKind =
            self.pendingAction
            and self.pendingAction.kind
            or nil,
        pendingState =
            self.pendingAction
            and self.pendingAction.state
            or nil,

        lastActionSource =
            action and action.source or nil,
        lastActionKind = action and action.kind or nil,
        lastActionState = action and action.state or nil,
        lastActionSuccess =
            action and action.success == true or false,
        lastActionQuestID =
            action and action.questID or nil,
        lastActionTitle =
            action and action.title or nil,
        lastActionCallOK =
            action and action.callOK == true or false,
        lastActionEvent =
            action and action.event or nil,
        lastActionEventIdentityState =
            action and action.eventIdentityState or nil,
        lastActionEventSecret =
            action and action.eventSecret == true or false,
        lastActionFinishedObserved =
            action and action.finishedObserved == true or false,
        lastActionReported =
            action and action.reported == true or false,
        lastActionError =
            action and action.error or nil,

        lastBlockedKind = self.lastBlockedKind,
        lastBlockedReason = self.lastBlockedReason,
        lastSecret = self.lastSecret == true,
        lastError = self.lastError,
    }
end

function Probe:OnInitialize()
    self.moduleEnabled = false
    self.eventFrame = nil
    self.eventRegistration = {}
    self.eventCounts = {}

    self.offerOpen = false
    self.currentOffer = nil
    self.offerGeneration = 0
    self.lastOfferReason = "initialize"

    self.actionAttemptCount = 0
    self.productionAttemptCount = 0
    self.acceptAttemptCount = 0
    self.declineAttemptCount = 0
    self.mutationCallCount = 0
    self.blockedCount = 0
    self.successCount = 0
    self.failureCount = 0

    self.pendingAction = nil
    self.lastAction = nil
    self.lastBlockedKind = nil
    self.lastBlockedReason = nil
    self.lastSecret = false
    self.lastError = nil

    local eventFrame = CreateFrame("Frame")

    for index = 1, #TRACKED_EVENTS do
        local event = TRACKED_EVENTS[index]
        local ok = pcall(
            eventFrame.RegisterEvent,
            eventFrame,
            event
        )

        self.eventRegistration[event] =
            ok and true or false
        self.eventCounts[event] = 0
    end

    eventFrame:SetScript(
        "OnEvent",
        function(_, event, ...)
            if not self.moduleEnabled then
                return
            end

            self.eventCounts[event] =
                (self.eventCounts[event] or 0) + 1

            if event == "QUEST_DETAIL" then
                self:CaptureOffer(event)
                return
            end

            if event == "QUEST_ACCEPTED" then
                self:ResolveAccepted(...)
                return
            end

            if event == "QUEST_FINISHED" then
                self:ResolveFinished()
                return
            end

            if event == "PLAYER_ENTERING_WORLD" then
                self:ResolveWorldTransition()
            end
        end
    )

    self.eventFrame = eventFrame
end

function Probe:OnEnable()
    self.moduleEnabled = true
end

function Probe:OnDisable()
    self.moduleEnabled = false
    self.pendingAction = nil
    self.offerOpen = false
    self.currentOffer = nil
end
