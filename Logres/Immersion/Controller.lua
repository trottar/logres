local _, Logres = ...

local ImmersionController =
    Logres:RegisterModule("ImmersionController", {
        OnInitialize = function(self)
            self.policy = nil
            self.lastReconcileReason = "not-yet-reconciled"
            self.lastActionResult = "not-yet-requested"
            self.lastActionError = nil
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

        playerFrameSuppressionDesired = false,
        targetFrameSuppressionDesired = false,
        partyFrameSuppressionDesired = false,

        primaryActionRoutingOwned = false,
    }
end

function ImmersionController:Reconcile(reason)
    local policy = self:BuildPolicy()
    local replacement =
        Logres:GetModule("StockActionReplacement")
    local replacementDebug =
        replacement:GetDebugStatus()

    self.policy = policy
    self.lastReconcileReason =
        reason or "unspecified-reconcile"
    self.lastActionError = nil

    local desired =
        policy.actionReplacementDesired

    local alreadyRequested =
        replacementDebug.requestedEnabled == desired

    local appliedOrPending =
        replacementDebug.appliedEnabled == desired
        or replacementDebug.pending == true

    if alreadyRequested and appliedOrPending then
        if replacementDebug.pending then
            self.lastActionResult = "pending-existing"
        else
            self.lastActionResult = "already-applied"
        end

        return
    end

    local applied, result =
        replacement:RequestEnabled(desired)

    self.lastActionResult = result or "unknown"

    if not applied and result ~= "deferred" then
        replacementDebug =
            replacement:GetDebugStatus()

        self.lastActionError =
            replacementDebug.lastError
                or "unknown action replacement failure"

        Logres:DevPrint(
            "ImmersionController action replacement reconcile failed: "
            .. tostring(self.lastActionError)
        )
    end
end

function ImmersionController:GetDebugStatus()
    local policy = self.policy or self:BuildPolicy()
    local replacement =
        Logres:GetModule("StockActionReplacement")
    local replacementDebug =
        replacement:GetDebugStatus()

    return {
        moduleEnabled = self:IsEnabled(),

        preferenceRevision =
            policy.preferenceRevision,
        stateRevision =
            policy.stateRevision,

        immersionEnabled =
            policy.immersionEnabled,
        context =
            policy.context,
        combat =
            policy.combat,
        pvpFlagged =
            policy.pvpFlagged,

        actionReplacementDesired =
            policy.actionReplacementDesired,
        actionReplacementRequested =
            replacementDebug.requestedEnabled == true,
        actionReplacementApplied =
            replacementDebug.appliedEnabled == true,
        actionReplacementPending =
            replacementDebug.pending == true,
        actionReplacementError =
            replacementDebug.lastError,

        quietModeDesired =
            policy.quietModeDesired,
        quietModeImplemented = false,

        playerFrameSuppressionDesired =
            policy.playerFrameSuppressionDesired,
        targetFrameSuppressionDesired =
            policy.targetFrameSuppressionDesired,
        partyFrameSuppressionDesired =
            policy.partyFrameSuppressionDesired,

        primaryActionRoutingOwned =
            policy.primaryActionRoutingOwned,

        lastReconcileReason =
            self.lastReconcileReason,
        lastActionResult =
            self.lastActionResult,
        lastActionError =
            self.lastActionError,
    }
end
