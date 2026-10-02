local _, Logres = ...

local ImmersionController =
    Logres:RegisterModule("ImmersionController", {
        OnInitialize = function(self)
            self.policy = nil
            self.lastReconcileReason = "not-yet-reconciled"

            self.lastActionResult = "not-yet-requested"
            self.lastActionError = nil

            self.lastQuietResult = "not-yet-requested"
            self.lastQuietError = nil

            self.lastPlayerResult = "not-yet-requested"
            self.lastPlayerError = nil

            self.lastTargetResult = "not-yet-requested"
            self.lastTargetError = nil
        end,

        OnEnable = function(self)
            self:SubscribePreferences(function(
                current,
                previous,
                changes,
                reason
            )
                self:Reconcile(
                    "preference:" .. tostring(reason or "change")
                )
            end)

            self:SubscribeState(function(
                current,
                previous,
                changes,
                reason
            )
                self:Reconcile(
                    "state:" .. tostring(reason or "change")
                )
            end)

            self:Reconcile("module-enable")
        end,

        OnDisable = function(self)
            local targetReplacement =
                Logres:GetModule("TargetFrameReplacement")
            local targetRestored, targetResult =
                targetReplacement:RequestEnabled(
                    false,
                    "controller-disable"
                )

            self.lastTargetResult = targetResult or "unknown"
            self.lastTargetError = nil

            if not targetRestored
                and targetResult ~= "deferred"
            then
                local targetDebug =
                    targetReplacement:GetDebugStatus()

                self.lastTargetError =
                    targetDebug.lastError
                    or "unknown TargetFrame restore failure"

                Logres:DevPrint(
                    "ImmersionController TargetFrame "
                    .. "fail-open restore failed: "
                    .. tostring(self.lastTargetError)
                )
            end

            local playerReplacement =
                Logres:GetModule("PlayerFrameReplacement")
            local playerRestored, playerResult =
                playerReplacement:RequestEnabled(
                    false,
                    "controller-disable"
                )

            self.lastPlayerResult = playerResult or "unknown"
            self.lastPlayerError = nil

            if not playerRestored
                and playerResult ~= "deferred"
            then
                local playerDebug =
                    playerReplacement:GetDebugStatus()

                self.lastPlayerError =
                    playerDebug.lastError
                    or "unknown PlayerFrame restore failure"

                Logres:DevPrint(
                    "ImmersionController PlayerFrame "
                    .. "fail-open restore failed: "
                    .. tostring(self.lastPlayerError)
                )
            end

            local quietMode = Logres:GetModule("QuietMode")
            local quietRestored, quietResult =
                quietMode:RequestEnabled(
                    false,
                    "controller-disable"
                )

            self.lastQuietResult = quietResult or "unknown"
            self.lastQuietError = nil

            if not quietRestored then
                local quietDebug =
                    quietMode:GetDebugStatus()

                self.lastQuietError =
                    quietDebug.lastError
                    or "unknown Quiet Mode restore failure"

                Logres:DevPrint(
                    "ImmersionController Quiet Mode fail-open "
                    .. "restore failed: "
                    .. tostring(self.lastQuietError)
                )
            end

            local replacement =
                Logres:GetModule("StockActionReplacement")
            local applied, result =
                replacement:RequestEnabled(false)

            self.lastReconcileReason = "module-disable"
            self.lastActionResult = result or "unknown"
            self.lastActionError = nil

            if not applied and result ~= "deferred" then
                local replacementDebug =
                    replacement:GetDebugStatus()

                self.lastActionError =
                    replacementDebug.lastError
                    or "unknown replacement restore failure"

                Logres:DevPrint(
                    "ImmersionController fail-open restore failed: "
                    .. tostring(self.lastActionError)
                )
            end
        end,
    })

function ImmersionController:BuildPolicy()
    local preferences = Logres:GetPreferences()
    local state = Logres:GetState()
    local immersionEnabled =
        preferences.immersionEnabled == true

    return {
        preferenceRevision = preferences.revision,
        stateRevision = state.revision,

        immersionEnabled = immersionEnabled,
        context = state.context,
        combat = state.combat == true,
        pvpFlagged = state.pvpFlagged == true,

        actionReplacementDesired = immersionEnabled,

        quietModeDesired =
            immersionEnabled
            and state.context == "world",

        playerFrameSuppressionDesired = immersionEnabled,
        targetFrameSuppressionDesired = immersionEnabled,
        partyFrameSuppressionDesired = false,

        primaryActionRoutingOwned = false,
    }
end

function ImmersionController:ReconcileActionReplacement(policy)
    local replacement =
        Logres:GetModule("StockActionReplacement")
    local replacementDebug =
        replacement:GetDebugStatus()
    local desired = policy.actionReplacementDesired

    local alreadyRequested =
        replacementDebug.requestedEnabled == desired

    local appliedOrPending =
        replacementDebug.appliedEnabled == desired
        or replacementDebug.pending == true

    if alreadyRequested and appliedOrPending then
        self.lastActionResult =
            replacementDebug.pending
            and "pending-existing"
            or "already-applied"
        self.lastActionError = nil
        return
    end

    local applied, result =
        replacement:RequestEnabled(desired)

    self.lastActionResult = result or "unknown"
    self.lastActionError = nil

    if not applied and result ~= "deferred" then
        replacementDebug = replacement:GetDebugStatus()
        self.lastActionError =
            replacementDebug.lastError
            or "unknown action replacement failure"

        Logres:DevPrint(
            "ImmersionController action replacement "
            .. "reconcile failed: "
            .. tostring(self.lastActionError)
        )
    end
end

function ImmersionController:ReconcileQuietMode(policy, reason)
    local quietMode = Logres:GetModule("QuietMode")
    local quietDebug = quietMode:GetDebugStatus()
    local desired = policy.quietModeDesired

    if quietDebug.requestedEnabled == desired
        and quietDebug.appliedEnabled == desired
    then
        self.lastQuietResult = "already-applied"
        self.lastQuietError = nil
        return
    end

    local applied, result =
        quietMode:RequestEnabled(desired, reason)

    self.lastQuietResult = result or "unknown"
    self.lastQuietError = nil

    if not applied then
        quietDebug = quietMode:GetDebugStatus()
        self.lastQuietError =
            quietDebug.lastError
            or "unknown Quiet Mode failure"

        Logres:DevPrint(
            "ImmersionController Quiet Mode "
            .. "reconcile failed: "
            .. tostring(self.lastQuietError)
        )
    end
end

function ImmersionController:ReconcilePlayerFrame(policy, reason)
    local replacement =
        Logres:GetModule("PlayerFrameReplacement")
    local debugStatus = replacement:GetDebugStatus()
    local desired = policy.playerFrameSuppressionDesired

    local alreadyRequested =
        debugStatus.requestedEnabled == desired
    local appliedOrPending =
        debugStatus.appliedEnabled == desired
        or debugStatus.pending == true

    if alreadyRequested and appliedOrPending then
        self.lastPlayerResult =
            debugStatus.pending
            and "pending-existing"
            or "already-applied"
        self.lastPlayerError = nil
        return
    end

    local applied, result =
        replacement:RequestEnabled(desired, reason)

    self.lastPlayerResult = result or "unknown"
    self.lastPlayerError = nil

    if not applied and result ~= "deferred" then
        debugStatus = replacement:GetDebugStatus()
        self.lastPlayerError =
            debugStatus.lastError
            or "unknown PlayerFrame replacement failure"

        Logres:DevPrint(
            "ImmersionController PlayerFrame "
            .. "reconcile failed: "
            .. tostring(self.lastPlayerError)
        )
    end
end

function ImmersionController:ReconcileTargetFrame(policy, reason)
    local replacement =
        Logres:GetModule("TargetFrameReplacement")
    local debugStatus = replacement:GetDebugStatus()
    local desired = policy.targetFrameSuppressionDesired

    local alreadyRequested =
        debugStatus.requestedEnabled == desired
    local appliedOrPending =
        debugStatus.appliedEnabled == desired
        or debugStatus.pending == true

    if alreadyRequested and appliedOrPending then
        self.lastTargetResult =
            debugStatus.pending
            and "pending-existing"
            or "already-applied"
        self.lastTargetError = nil
        return
    end

    local applied, result =
        replacement:RequestEnabled(desired, reason)

    self.lastTargetResult = result or "unknown"
    self.lastTargetError = nil

    if not applied and result ~= "deferred" then
        debugStatus = replacement:GetDebugStatus()
        self.lastTargetError =
            debugStatus.lastError
            or "unknown TargetFrame replacement failure"

        Logres:DevPrint(
            "ImmersionController TargetFrame "
            .. "reconcile failed: "
            .. tostring(self.lastTargetError)
        )
    end
end

function ImmersionController:Reconcile(reason)
    local policy = self:BuildPolicy()

    self.policy = policy
    self.lastReconcileReason =
        reason or "unspecified-reconcile"

    self:ReconcileActionReplacement(policy)
    self:ReconcileQuietMode(policy, self.lastReconcileReason)
    self:ReconcilePlayerFrame(policy, self.lastReconcileReason)
    self:ReconcileTargetFrame(policy, self.lastReconcileReason)
end

function ImmersionController:GetRecoveryStatus()
    local policy = self.policy or self:BuildPolicy()

    return {
        moduleEnabled = self:IsEnabled(),

        immersionEnabled = policy.immersionEnabled,
        context = policy.context,
        combat = policy.combat,
        pvpFlagged = policy.pvpFlagged,

        actionReplacementDesired =
            policy.actionReplacementDesired,
        quietModeDesired =
            policy.quietModeDesired,
        playerFrameSuppressionDesired =
            policy.playerFrameSuppressionDesired,
        targetFrameSuppressionDesired =
            policy.targetFrameSuppressionDesired,
        partyFrameSuppressionDesired =
            policy.partyFrameSuppressionDesired,
        primaryActionRoutingOwned =
            policy.primaryActionRoutingOwned,

        lastActionResult = self.lastActionResult,
        lastActionError = self.lastActionError,
        lastQuietResult = self.lastQuietResult,
        lastQuietError = self.lastQuietError,
        lastPlayerResult = self.lastPlayerResult,
        lastPlayerError = self.lastPlayerError,
        lastTargetResult = self.lastTargetResult,
        lastTargetError = self.lastTargetError,
    }
end

function ImmersionController:GetDebugStatus()
    local policy = self.policy or self:BuildPolicy()

    local actionDebug =
        Logres:GetModule("StockActionReplacement"):GetDebugStatus()
    local quietDebug =
        Logres:GetModule("QuietMode"):GetDebugStatus()
    local playerDebug =
        Logres:GetModule("PlayerFrameReplacement"):GetDebugStatus()
    local targetDebug =
        Logres:GetModule("TargetFrameReplacement"):GetDebugStatus()

    return {
        moduleEnabled = self:IsEnabled(),

        preferenceRevision = policy.preferenceRevision,
        stateRevision = policy.stateRevision,

        immersionEnabled = policy.immersionEnabled,
        context = policy.context,
        combat = policy.combat,
        pvpFlagged = policy.pvpFlagged,

        actionReplacementDesired =
            policy.actionReplacementDesired,
        actionReplacementRequested =
            actionDebug.requestedEnabled == true,
        actionReplacementApplied =
            actionDebug.appliedEnabled == true,
        actionReplacementPending =
            actionDebug.pending == true,
        actionReplacementError = actionDebug.lastError,

        quietModeDesired = policy.quietModeDesired,
        quietModeImplemented = true,
        quietModeRequested =
            quietDebug.requestedEnabled == true,
        quietModeApplied =
            quietDebug.appliedEnabled == true,
        quietModeError = quietDebug.lastError,

        playerFrameSuppressionDesired =
            policy.playerFrameSuppressionDesired,
        playerFrameSuppressionImplemented = true,
        playerFrameSuppressionRequested =
            playerDebug.requestedEnabled == true,
        playerFrameSuppressionApplied =
            playerDebug.appliedEnabled == true,
        playerFrameSuppressionPending =
            playerDebug.pending == true,
        playerFrameSuppressionError =
            playerDebug.lastError,

        targetFrameSuppressionDesired =
            policy.targetFrameSuppressionDesired,
        targetFrameSuppressionImplemented = true,
        targetFrameSuppressionRequested =
            targetDebug.requestedEnabled == true,
        targetFrameSuppressionApplied =
            targetDebug.appliedEnabled == true,
        targetFrameSuppressionPending =
            targetDebug.pending == true,
        targetFrameSuppressionError =
            targetDebug.lastError,

        partyFrameSuppressionDesired =
            policy.partyFrameSuppressionDesired,

        primaryActionRoutingOwned =
            policy.primaryActionRoutingOwned,

        lastReconcileReason = self.lastReconcileReason,

        lastActionResult = self.lastActionResult,
        lastActionError = self.lastActionError,

        lastQuietResult = self.lastQuietResult,
        lastQuietError = self.lastQuietError,

        lastPlayerResult = self.lastPlayerResult,
        lastPlayerError = self.lastPlayerError,

        lastTargetResult = self.lastTargetResult,
        lastTargetError = self.lastTargetError,
    }
end
