local _, Logres = ...

local activeOutput
local devPanelActions = {}
local devPanelActionsByID = {}

local function emit(message)
    message = tostring(message)

    if activeOutput then
        activeOutput(message)
        return
    end

    print(message)
end

function Logres:RegisterDevPanelAction(id, label, command)
    if type(id) ~= "string" or id == "" then
        error("Logres:RegisterDevPanelAction requires a non-empty id")
    end

    if type(label) ~= "string" or label == "" then
        error("Logres:RegisterDevPanelAction requires a non-empty label")
    end

    if type(command) ~= "string" or command == "" then
        error("Logres:RegisterDevPanelAction requires a non-empty command")
    end

    if devPanelActionsByID[id] then
        error("Duplicate Logres dev-panel action: " .. id)
    end

    local action = {
        id = id,
        label = label,
        command = command,
    }

    devPanelActionsByID[id] = action
    devPanelActions[#devPanelActions + 1] = action
end

function Logres:GetDevPanelActions()
    local copy = {}

    for index = 1, #devPanelActions do
        local action = devPanelActions[index]
        copy[index] = {
            id = action.id,
            label = action.label,
            command = action.command,
        }
    end

    return copy
end

local function boolText(value)
    return value and "true" or "false"
end

local lifecycleProbe = {
    initializeCount = 0,
    enableCount = 0,
    disableCount = 0,
    cleanupCount = 0,
    preferenceCallbackCount = 0,
}

local lifecycleProbeModule = Logres:RegisterModule("DevLifecycleProbe", {
    autoEnable = false,

    OnInitialize = function()
        lifecycleProbe.initializeCount = lifecycleProbe.initializeCount + 1
    end,

    OnEnable = function(self)
        lifecycleProbe.enableCount = lifecycleProbe.enableCount + 1

        self:OwnCleanup(function()
            lifecycleProbe.cleanupCount = lifecycleProbe.cleanupCount + 1
        end)

        self:SubscribePreferences(function()
            lifecycleProbe.preferenceCallbackCount =
                lifecycleProbe.preferenceCallbackCount + 1
        end)
    end,

    OnDisable = function()
        lifecycleProbe.disableCount = lifecycleProbe.disableCount + 1
    end,
})

local function printStatus()
    local state = Logres:GetState()
    local db = Logres.db
    local _, _, _, interfaceVersion = GetBuildInfo()

    emit(string.format(
        "Logres %s: loadCount=%s revision=%s context=%s combat=%s pvp=%s instance=%s/%s mounted=%s resting=%s taxi=%s interact=%s/%s changedBy=%s interface=%s",
        tostring(Logres.VERSION),
        tostring(db and db.meta and db.meta.loadCount or "?"),
        tostring(state.revision),
        tostring(state.context),
        boolText(state.combat),
        boolText(state.pvpFlagged),
        boolText(state.inInstance),
        tostring(state.instanceType),
        boolText(state.mounted),
        boolText(state.resting),
        boolText(state.onTaxi),
        boolText(state.interacting),
        tostring(state.interactionType),
        tostring(state.changedBy),
        tostring(interfaceVersion)
    ))
end

local function printPreferences()
    local preferences = Logres:GetPreferences()

    emit(string.format(
        "Logres preferences: schema=%s revision=%s immersionEnabled=%s",
        tostring(Logres.db and Logres.db.schema or "?"),
        tostring(preferences.revision),
        boolText(preferences.immersionEnabled)
    ))
end

local function runStateCheck()
    local before = Logres:GetState()
    local expectedContext = before.context

    before.context = "__consumer_mutation_test__"
    local afterMutation = Logres:GetState()
    local snapshotIsolation = afterMutation.context == expectedContext

    local revisionBefore = afterMutation.revision
    local callbackCount = 0

    local unsubscribe = Logres:SubscribeState(function()
        callbackCount = callbackCount + 1
    end)

    local changed = Logres:RefreshState("DEV_STATECHECK_NOOP")
    unsubscribe()

    local afterRefresh = Logres:GetState()

    local noopStable =
        changed == false
        and afterRefresh.revision == revisionBefore
        and callbackCount == 0

    if snapshotIsolation and noopStable then
        emit(string.format(
            "Logres statecheck: PASS (snapshot isolation=true, no-op revision=%s, callbacks=0)",
            tostring(afterRefresh.revision)
        ))
        return
    end

    emit(string.format(
        "Logres statecheck: FAIL (snapshotIsolation=%s changed=%s revisionBefore=%s revisionAfter=%s callbacks=%s)",
        tostring(snapshotIsolation),
        tostring(changed),
        tostring(revisionBefore),
        tostring(afterRefresh.revision),
        tostring(callbackCount)
    ))
end

local function runSensorCheck()
    local state = Logres:GetState()

    local apiTaxi = UnitOnTaxi("player") and true or false
    local apiMounted = IsMounted() and not apiTaxi
    local apiResting = IsResting() and true or false

    local mountedOK = state.mounted == (apiMounted and true or false)
    local restingOK = state.resting == apiResting
    local taxiOK = state.onTaxi == apiTaxi
    local interactionShapeOK =
        state.interacting == (state.interactionType ~= 0)

    if mountedOK and restingOK and taxiOK and interactionShapeOK then
        emit(string.format(
            "Logres sensorcheck: PASS (mounted=%s resting=%s taxi=%s interact=%s/%s)",
            boolText(state.mounted),
            boolText(state.resting),
            boolText(state.onTaxi),
            boolText(state.interacting),
            tostring(state.interactionType)
        ))
        return
    end

    emit(string.format(
        "Logres sensorcheck: FAIL (mounted=%s/%s resting=%s/%s taxi=%s/%s interact=%s/%s)",
        boolText(state.mounted),
        boolText(apiMounted),
        boolText(state.resting),
        boolText(apiResting),
        boolText(state.onTaxi),
        boolText(apiTaxi),
        boolText(state.interacting),
        tostring(state.interactionType)
    ))
end

local function runPreferenceCheck()
    local original = Logres:GetPreferences()
    local originalValue = original.immersionEnabled

    original.immersionEnabled = not originalValue
    local afterMutation = Logres:GetPreferences()
    local snapshotIsolation = afterMutation.immersionEnabled == originalValue

    local callbackCount = 0
    local unsubscribe = Logres:SubscribePreferences(function()
        callbackCount = callbackCount + 1
    end)

    local noopChanged = Logres:SetPreference(
        "immersionEnabled",
        originalValue,
        "DEV_PREFERENCECHECK_NOOP"
    )

    local afterNoop = Logres:GetPreferences()
    local noopStable =
        noopChanged == false
        and afterNoop.revision == afterMutation.revision
        and callbackCount == 0

    local changedAway = Logres:SetPreference(
        "immersionEnabled",
        not originalValue,
        "DEV_PREFERENCECHECK_CHANGE"
    )
    local changedBack = Logres:SetPreference(
        "immersionEnabled",
        originalValue,
        "DEV_PREFERENCECHECK_RESTORE"
    )

    unsubscribe()

    local final = Logres:GetPreferences()

    local changeSemantics =
        changedAway == true
        and changedBack == true
        and callbackCount == 2
        and final.immersionEnabled == originalValue
        and final.revision == afterNoop.revision + 2

    if snapshotIsolation and noopStable and changeSemantics then
        emit(string.format(
            "Logres preferencecheck: PASS (snapshot isolation=true, callbacks=2, revision=%s, immersionEnabled=%s)",
            tostring(final.revision),
            boolText(final.immersionEnabled)
        ))
        return
    end

    emit(string.format(
        "Logres preferencecheck: FAIL (snapshotIsolation=%s noopStable=%s changeSemantics=%s callbacks=%s revision=%s immersionEnabled=%s)",
        tostring(snapshotIsolation),
        tostring(noopStable),
        tostring(changeSemantics),
        tostring(callbackCount),
        tostring(final.revision),
        boolText(final.immersionEnabled)
    ))
end

local function runLifecycleCheck()
    local moduleName = lifecycleProbeModule.name
    local before = Logres:GetModuleStatus(moduleName)

    local initBefore = lifecycleProbe.initializeCount
    local enableBefore = lifecycleProbe.enableCount
    local disableBefore = lifecycleProbe.disableCount
    local cleanupBefore = lifecycleProbe.cleanupCount
    local preferenceCallbackBefore = lifecycleProbe.preferenceCallbackCount

    local initializedAgain = Logres:InitializeModule(moduleName)

    local enabledFirst = Logres:EnableModule(moduleName)
    local enabledSecond = Logres:EnableModule(moduleName)

    local originalImmersion = Logres:GetPreference("immersionEnabled")

    Logres:SetPreference(
        "immersionEnabled",
        not originalImmersion,
        "DEV_LIFECYCLECHECK_ENABLED_CHANGE"
    )
    Logres:SetPreference(
        "immersionEnabled",
        originalImmersion,
        "DEV_LIFECYCLECHECK_ENABLED_RESTORE"
    )

    local callbacksWhileEnabled =
        lifecycleProbe.preferenceCallbackCount - preferenceCallbackBefore

    local disabledFirst = Logres:DisableModule(moduleName)
    local disabledSecond = Logres:DisableModule(moduleName)

    local callbacksBeforeDisabledChanges = lifecycleProbe.preferenceCallbackCount

    Logres:SetPreference(
        "immersionEnabled",
        not originalImmersion,
        "DEV_LIFECYCLECHECK_DISABLED_CHANGE"
    )
    Logres:SetPreference(
        "immersionEnabled",
        originalImmersion,
        "DEV_LIFECYCLECHECK_DISABLED_RESTORE"
    )

    local callbacksWhileDisabled =
        lifecycleProbe.preferenceCallbackCount - callbacksBeforeDisabledChanges

    local after = Logres:GetModuleStatus(moduleName)

    local passed =
        before.initialized == true
        and before.enabled == false
        and initializedAgain == false
        and lifecycleProbe.initializeCount == initBefore
        and enabledFirst == true
        and enabledSecond == false
        and lifecycleProbe.enableCount == enableBefore + 1
        and callbacksWhileEnabled == 2
        and disabledFirst == true
        and disabledSecond == false
        and lifecycleProbe.disableCount == disableBefore + 1
        and lifecycleProbe.cleanupCount == cleanupBefore + 1
        and callbacksWhileDisabled == 0
        and after.initialized == true
        and after.enabled == false
        and after.cleanupCount == 0

    if passed then
        emit(string.format(
            "Logres lifecyclecheck: PASS (init=%s enable=%s disable=%s cleanup=%s prefCallbacksWhileEnabled=2 prefCallbacksWhileDisabled=0)",
            tostring(lifecycleProbe.initializeCount),
            tostring(lifecycleProbe.enableCount),
            tostring(lifecycleProbe.disableCount),
            tostring(lifecycleProbe.cleanupCount)
        ))
        return
    end

    emit(string.format(
        "Logres lifecyclecheck: FAIL (beforeInit=%s beforeEnabled=%s initializedAgain=%s enabled=%s/%s disabled=%s/%s init=%s->%s enable=%s->%s disable=%s->%s cleanup=%s->%s prefEnabled=%s prefDisabled=%s afterEnabled=%s afterCleanup=%s)",
        tostring(before.initialized),
        tostring(before.enabled),
        tostring(initializedAgain),
        tostring(enabledFirst),
        tostring(enabledSecond),
        tostring(disabledFirst),
        tostring(disabledSecond),
        tostring(initBefore),
        tostring(lifecycleProbe.initializeCount),
        tostring(enableBefore),
        tostring(lifecycleProbe.enableCount),
        tostring(disableBefore),
        tostring(lifecycleProbe.disableCount),
        tostring(cleanupBefore),
        tostring(lifecycleProbe.cleanupCount),
        tostring(callbacksWhileEnabled),
        tostring(callbacksWhileDisabled),
        tostring(after.enabled),
        tostring(after.cleanupCount)
    ))
end


local function runHUDCheck()
    local status = Logres:GetModuleStatus("HUD")
    local hud = Logres:GetModule("HUD")
    local debugStatus = hud:GetDebugStatus()

    local visibilityMatchesPreference =
        debugStatus.rootShown == debugStatus.immersionEnabled

    local passed =
        status.initialized == true
        and status.enabled == true
        and debugStatus.moduleEnabled == true
        and debugStatus.bandCount == 4
        and debugStatus.textureCount == 16
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
            "Logres hudcheck: PASS (bands=4 textures=16 curves=true resourceText=true resourceCurve=true target=true casts=true allies=5 immersion=%s visible=%s)",
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




local function runActionCheck()
    local primaryStatus = Logres:GetModuleStatus("PrimaryActions")
    local primary = Logres:GetModule("PrimaryActions")
    local primaryDebug = primary:GetDebugStatus()

    local sideStatus =
        Logres:GetModuleStatus("SecondaryUtilityActions")
    local sideActions =
        Logres:GetModule("SecondaryUtilityActions")
    local sideDebug = sideActions:GetDebugStatus()

    local contextStatus = Logres:GetModuleStatus("ActionContext")
    local actionContext = Logres:GetModule("ActionContext")
    local contextDebug = actionContext:GetDebugStatus()

    local secondary = sideDebug.secondary
    local utility = sideDebug.utility

    local primaryDeferredOK =
        primaryDebug.pendingBindingRefresh == false
        or InCombatLockdown()

    local secondaryDeferredOK =
        secondary.pendingBindingRefresh == false
        or InCombatLockdown()

    local utilityDeferredOK =
        utility.pendingBindingRefresh == false
        or InCombatLockdown()

    local passed =
        primaryStatus.initialized == true
        and primaryStatus.enabled == true
        and primaryDebug.moduleEnabled == true
        and primaryDebug.clusterShown == true
        and primaryDebug.buttonCount == 12
        and primaryDebug.registeredCount == 12
        and primaryDebug.activationFeedbackReadyCount == 12
        and primaryDebug.currentPage ~= nil
        and primaryDebug.firstActionSlot ~= nil
        and primaryDebug.lastActionSlot ~= nil
        and primaryDebug.securePagingReady == true
        and primaryDebug.secureDriverRegisteredCount == 12
        and primaryDeferredOK
        and sideStatus.initialized == true
        and sideStatus.enabled == true
        and sideDebug.moduleEnabled == true
        and secondary.shown == true
        and secondary.buttonCount == 12
        and secondary.registeredCount == 12
        and secondary.activationFeedbackReadyCount == 12
        and secondary.firstActionSlot == 61
        and secondary.lastActionSlot == 72
        and secondaryDeferredOK
        and utility.shown == true
        and utility.buttonCount == 12
        and utility.registeredCount == 12
        and utility.activationFeedbackReadyCount == 12
        and utility.firstActionSlot == 49
        and utility.lastActionSlot == 60
        and utilityDeferredOK
        and contextStatus.initialized == true
        and contextStatus.enabled == true
        and contextDebug.moduleEnabled == true
        and contextDebug.primaryAlpha > 0
        and contextDebug.secondaryAlpha > 0
        and contextDebug.utilityAlpha > 0
        and contextDebug.alphaZeroUsed == false
        and primaryDebug.stockBarsSuppressed == false
        and sideDebug.stockBarsSuppressed == false

    if passed then
        emit(string.format(
            "Logres actioncheck: PASS (primary=12 feedback=12 page=%s securePage=%s driver=12 slots=%s-%s keys=%s/%s secondary=12 feedback=12 slots=61-72 alpha=%.2f keys=%s/%s utility=12 feedback=12 slots=49-60 alpha=%.2f keys=%s/%s policy=%s primaryAlpha=%.2f specialPaging=%s stockBarsSuppressed=false)",
            tostring(primaryDebug.currentPage),
            tostring(primaryDebug.securePage),
            tostring(primaryDebug.firstActionSlot),
            tostring(primaryDebug.lastActionSlot),
            boolText(primaryDebug.bindingRoutingEnabled),
            tostring(primaryDebug.boundButtonCount),
            contextDebug.secondaryAlpha,
            boolText(secondary.bindingRoutingEnabled),
            tostring(secondary.boundButtonCount),
            contextDebug.utilityAlpha,
            boolText(utility.bindingRoutingEnabled),
            tostring(utility.boundButtonCount),
            tostring(contextDebug.policyName),
            contextDebug.primaryAlpha,
            tostring(primaryDebug.specialPagingCoverage)
        ))
        return
    end

    emit(string.format(
        "Logres actioncheck: FAIL (primary init=%s enabled=%s shown=%s buttons=%s registered=%s feedback=%s page=%s securePage=%s driverReady=%s drivers=%s slots=%s-%s secondary init=%s enabled=%s shown=%s registered=%s feedback=%s utility shown=%s registered=%s feedback=%s context init=%s enabled=%s policy=%s alphas=%.2f/%.2f/%.2f alphaZero=%s stockSuppressed=%s/%s)",
        tostring(primaryStatus.initialized),
        tostring(primaryStatus.enabled),
        tostring(primaryDebug.clusterShown),
        tostring(primaryDebug.buttonCount),
        tostring(primaryDebug.registeredCount),
        tostring(primaryDebug.activationFeedbackReadyCount),
        tostring(primaryDebug.currentPage),
        tostring(primaryDebug.securePage),
        tostring(primaryDebug.securePagingReady),
        tostring(primaryDebug.secureDriverRegisteredCount),
        tostring(primaryDebug.firstActionSlot),
        tostring(primaryDebug.lastActionSlot),
        tostring(sideStatus.initialized),
        tostring(sideStatus.enabled),
        tostring(secondary.shown),
        tostring(secondary.registeredCount),
        tostring(secondary.activationFeedbackReadyCount),
        tostring(utility.shown),
        tostring(utility.registeredCount),
        tostring(utility.activationFeedbackReadyCount),
        tostring(contextStatus.initialized),
        tostring(contextStatus.enabled),
        tostring(contextDebug.policyName),
        contextDebug.primaryAlpha or -1,
        contextDebug.secondaryAlpha or -1,
        contextDebug.utilityAlpha or -1,
        tostring(contextDebug.alphaZeroUsed),
        tostring(primaryDebug.stockBarsSuppressed),
        tostring(sideDebug.stockBarsSuppressed)
    ))
end


local function runActionFeedbackTest()
    local primary = Logres:GetModule("PrimaryActions")
    local sides = Logres:GetModule("SecondaryUtilityActions")

    Logres.ActionButton.Pulse(primary.buttons[1])
    Logres.ActionButton.Pulse(sides.clusters.secondary.buttons[1])
    Logres.ActionButton.Pulse(sides.clusters.utility.buttons[1])

    emit(
        "Logres actionfeedback: pulsed first Primary, Secondary, "
        .. "and Utility buttons."
    )
end

local function handleActionBindings(argument)
    local actions = Logres:GetModule("PrimaryActions")

    if argument == "on" then
        local applied = actions:SetBindingRoutingEnabled(true)

        if applied then
            emit(
                "Logres: Action Keys ON. Existing ACTIONBUTTON keys "
                .. "temporarily route through Logres."
            )
        else
            emit(
                "Logres: Action Keys ON deferred until combat ends."
            )
        end

        return
    end

    if argument == "off" then
        local applied = actions:SetBindingRoutingEnabled(false)

        if applied then
            emit(
                "Logres: Action Keys OFF. Normal stock action bindings "
                .. "are active."
            )
        else
            emit(
                "Logres: Action Keys OFF deferred until combat ends."
            )
        end

        return
    end

    local debugStatus = actions:GetDebugStatus()
    emit(string.format(
        "Logres actionbindings: keyRouting=%s overrides=%s pending=%s",
        boolText(debugStatus.bindingRoutingEnabled),
        boolText(debugStatus.bindingsApplied),
        boolText(debugStatus.pendingBindingRefresh)
    ))
end

local function handleSideActionBindings(key, label, argument)
    local actions = Logres:GetModule("SecondaryUtilityActions")
    local replacement = Logres:GetModule("StockActionReplacement")

    if (
        argument == "off"
        and replacement:IsRoutingManaged(key)
    ) then
        emit(
            "Logres: " .. label .. " Keys OFF blocked while stock "
            .. "replacement owns this routing domain. Turn Stock Bars "
            .. "Replace OFF first."
        )
        return
    end

    if argument == "on" then
        local applied = actions:SetBindingRoutingEnabled(key, true)

        if applied then
            emit(
                "Logres: " .. label .. " Keys ON. Existing stock "
                .. "multi-bar keys temporarily route through Logres."
            )
        else
            emit(
                "Logres: " .. label
                .. " Keys ON deferred until combat ends."
            )
        end

        return
    end

    if argument == "off" then
        local applied = actions:SetBindingRoutingEnabled(key, false)

        if applied then
            emit(
                "Logres: " .. label
                .. " Keys OFF. Normal stock multi-bar bindings "
                .. "are active."
            )
        else
            emit(
                "Logres: " .. label
                .. " Keys OFF deferred until combat ends."
            )
        end

        return
    end

    local status = actions:GetClusterDebugStatus(key)

    emit(string.format(
        "Logres %s bindings: keyRouting=%s overrides=%s boundButtons=%s pending=%s",
        key,
        boolText(status.bindingRoutingEnabled),
        boolText(status.bindingsApplied),
        tostring(status.boundButtonCount),
        boolText(status.pendingBindingRefresh)
    ))
end


local function runStockReplacementCheck()
    local status =
        Logres:GetModuleStatus("StockActionReplacement")
    local replacement =
        Logres:GetModule("StockActionReplacement")
    local debugStatus = replacement:GetDebugStatus()

    local appliedConsistent = true

    if debugStatus.appliedEnabled then
        appliedConsistent =
            debugStatus.snapshotReady == true
            and debugStatus.secondaryAlpha == 0
            and debugStatus.utilityAlpha == 0
            and debugStatus.secondaryFrameMouseEnabled == false
            and debugStatus.utilityFrameMouseEnabled == false
            and debugStatus.secondaryButtonMouseEnabledCount == 0
            and debugStatus.utilityButtonMouseEnabledCount == 0
            and debugStatus.secondaryRoutingEnabled == true
            and debugStatus.secondaryBindingsApplied == true
            and debugStatus.utilityRoutingEnabled == true
            and debugStatus.utilityBindingsApplied == true
    end

    local passed =
        status.initialized == true
        and status.enabled == true
        and debugStatus.moduleEnabled == true
        and debugStatus.secondaryFrameFound == true
        and debugStatus.utilityFrameFound == true
        and debugStatus.mainActionBarSuppressed == false
        and debugStatus.unsupportedBarsSuppressed == false
        and appliedConsistent

    if passed then
        emit(string.format(
            "Logres stockreplacecheck: PASS (requested=%s applied=%s pending=%s bar2Alpha=%s bar2Mouse=%s/%s bar3Alpha=%s bar3Mouse=%s/%s secondaryRouting=%s/%s utilityRouting=%s/%s error=%s)",
            boolText(debugStatus.requestedEnabled),
            boolText(debugStatus.appliedEnabled),
            boolText(debugStatus.pending),
            tostring(debugStatus.secondaryAlpha),
            boolText(debugStatus.secondaryFrameMouseEnabled),
            tostring(debugStatus.secondaryButtonMouseEnabledCount),
            tostring(debugStatus.utilityAlpha),
            boolText(debugStatus.utilityFrameMouseEnabled),
            tostring(debugStatus.utilityButtonMouseEnabledCount),
            boolText(debugStatus.secondaryRoutingEnabled),
            boolText(debugStatus.secondaryBindingsApplied),
            boolText(debugStatus.utilityRoutingEnabled),
            boolText(debugStatus.utilityBindingsApplied),
            tostring(debugStatus.lastError)
        ))
        return
    end

    emit(string.format(
        "Logres stockreplacecheck: FAIL (initialized=%s enabled=%s requested=%s applied=%s pending=%s frames=%s/%s alphas=%s/%s frameMouse=%s/%s buttonMouse=%s/%s routing=%s/%s/%s/%s error=%s)",
        tostring(status.initialized),
        tostring(status.enabled),
        tostring(debugStatus.requestedEnabled),
        tostring(debugStatus.appliedEnabled),
        tostring(debugStatus.pending),
        tostring(debugStatus.secondaryFrameFound),
        tostring(debugStatus.utilityFrameFound),
        tostring(debugStatus.secondaryAlpha),
        tostring(debugStatus.utilityAlpha),
        tostring(debugStatus.secondaryFrameMouseEnabled),
        tostring(debugStatus.utilityFrameMouseEnabled),
        tostring(debugStatus.secondaryButtonMouseEnabledCount),
        tostring(debugStatus.utilityButtonMouseEnabledCount),
        tostring(debugStatus.secondaryRoutingEnabled),
        tostring(debugStatus.secondaryBindingsApplied),
        tostring(debugStatus.utilityRoutingEnabled),
        tostring(debugStatus.utilityBindingsApplied),
        tostring(debugStatus.lastError)
    ))
end

local function handleStockReplacement(argument)
    local replacement =
        Logres:GetModule("StockActionReplacement")

    if argument == "on" or argument == "off" then
        local applied, result =
            replacement:RequestEnabled(argument == "on")

        if applied then
            emit(
                "Logres: Stock Bars Replace "
                .. string.upper(argument)
                .. " applied for Bars 2-3."
            )
        elseif result == "deferred" then
            emit(
                "Logres: Stock Bars Replace "
                .. string.upper(argument)
                .. " deferred until combat ends."
            )
        else
            local debugStatus = replacement:GetDebugStatus()
            emit(
                "Logres: Stock Bars Replace "
                .. string.upper(argument)
                .. " failed: "
                .. tostring(debugStatus.lastError)
            )
        end

        return
    end

    local debugStatus = replacement:GetDebugStatus()
    emit(string.format(
        "Logres stockreplace: requested=%s applied=%s pending=%s secondaryRouting=%s utilityRouting=%s error=%s",
        boolText(debugStatus.requestedEnabled),
        boolText(debugStatus.appliedEnabled),
        boolText(debugStatus.pending),
        boolText(debugStatus.secondaryRoutingEnabled),
        boolText(debugStatus.utilityRoutingEnabled),
        tostring(debugStatus.lastError)
    ))
end

local function runImmersionCheck()
    local status =
        Logres:GetModuleStatus("ImmersionController")
    local controller =
        Logres:GetModule("ImmersionController")
    local debugStatus =
        controller:GetDebugStatus()

    local preferences = Logres:GetPreferences()
    local state = Logres:GetState()

    local expectedActionReplacement =
        preferences.immersionEnabled == true
    local expectedQuietMode =
        preferences.immersionEnabled == true
        and state.context == "world"
    local expectedPlayerFrame =
        preferences.immersionEnabled == true
    local expectedTargetFrame =
        preferences.immersionEnabled == true

    local desiredMatches =
        debugStatus.immersionEnabled
            == preferences.immersionEnabled
        and debugStatus.context == state.context
        and debugStatus.actionReplacementDesired
            == expectedActionReplacement
        and debugStatus.quietModeDesired
            == expectedQuietMode
        and debugStatus.playerFrameSuppressionDesired
            == expectedPlayerFrame
        and debugStatus.targetFrameSuppressionDesired
            == expectedTargetFrame

    local replacementMatches =
        debugStatus.actionReplacementRequested
            == expectedActionReplacement
        and (
            debugStatus.actionReplacementApplied
                == expectedActionReplacement
            or (
                debugStatus.actionReplacementPending
                and InCombatLockdown()
            )
        )

    local quietMatches =
        debugStatus.quietModeImplemented == true
        and debugStatus.quietModeRequested
            == expectedQuietMode
        and debugStatus.quietModeApplied
            == expectedQuietMode

    local playerMatches =
        debugStatus.playerFrameSuppressionImplemented == true
        and debugStatus.playerFrameSuppressionRequested
            == expectedPlayerFrame
        and (
            debugStatus.playerFrameSuppressionApplied
                == expectedPlayerFrame
            or (
                debugStatus.playerFrameSuppressionPending
                and InCombatLockdown()
            )
        )

    local targetMatches =
        debugStatus.targetFrameSuppressionImplemented == true
        and debugStatus.targetFrameSuppressionRequested
            == expectedTargetFrame
        and (
            debugStatus.targetFrameSuppressionApplied
                == expectedTargetFrame
            or (
                debugStatus.targetFrameSuppressionPending
                and InCombatLockdown()
            )
        )

    local capabilityGatesSafe =
        debugStatus.partyFrameSuppressionDesired == false
        and debugStatus.primaryActionRoutingOwned == false

    local passed =
        status.initialized == true
        and status.enabled == true
        and debugStatus.moduleEnabled == true
        and desiredMatches
        and replacementMatches
        and quietMatches
        and playerMatches
        and targetMatches
        and capabilityGatesSafe
        and debugStatus.lastActionError == nil
        and debugStatus.lastQuietError == nil
        and debugStatus.lastPlayerError == nil
        and debugStatus.lastTargetError == nil

    if passed then
        emit(string.format(
            "Logres immersioncheck: PASS (immersion=%s context=%s pvp=%s action=%s/%s/%s/%s quiet=%s/%s/%s player=%s/%s/%s/%s target=%s/%s/%s/%s party=false primaryRoutingOwned=false reason=%s actionResult=%s quietResult=%s playerResult=%s targetResult=%s)",
            boolText(debugStatus.immersionEnabled),
            tostring(debugStatus.context),
            boolText(debugStatus.pvpFlagged),
            boolText(debugStatus.actionReplacementDesired),
            boolText(debugStatus.actionReplacementRequested),
            boolText(debugStatus.actionReplacementApplied),
            boolText(debugStatus.actionReplacementPending),
            boolText(debugStatus.quietModeDesired),
            boolText(debugStatus.quietModeRequested),
            boolText(debugStatus.quietModeApplied),
            boolText(debugStatus.playerFrameSuppressionDesired),
            boolText(debugStatus.playerFrameSuppressionRequested),
            boolText(debugStatus.playerFrameSuppressionApplied),
            boolText(debugStatus.playerFrameSuppressionPending),
            boolText(debugStatus.targetFrameSuppressionDesired),
            boolText(debugStatus.targetFrameSuppressionRequested),
            boolText(debugStatus.targetFrameSuppressionApplied),
            boolText(debugStatus.targetFrameSuppressionPending),
            tostring(debugStatus.lastReconcileReason),
            tostring(debugStatus.lastActionResult),
            tostring(debugStatus.lastQuietResult),
            tostring(debugStatus.lastPlayerResult),
            tostring(debugStatus.lastTargetResult)
        ))
        return
    end

    emit(string.format(
        "Logres immersioncheck: FAIL (initialized=%s enabled=%s moduleEnabled=%s desiredMatches=%s replacementMatches=%s quietMatches=%s playerMatches=%s targetMatches=%s gatesSafe=%s immersion=%s context=%s player=%s/%s/%s/%s target=%s/%s/%s/%s party=%s reason=%s actionError=%s quietError=%s playerError=%s targetError=%s)",
        tostring(status.initialized),
        tostring(status.enabled),
        tostring(debugStatus.moduleEnabled),
        tostring(desiredMatches),
        tostring(replacementMatches),
        tostring(quietMatches),
        tostring(playerMatches),
        tostring(targetMatches),
        tostring(capabilityGatesSafe),
        tostring(debugStatus.immersionEnabled),
        tostring(debugStatus.context),
        tostring(debugStatus.playerFrameSuppressionDesired),
        tostring(debugStatus.playerFrameSuppressionRequested),
        tostring(debugStatus.playerFrameSuppressionApplied),
        tostring(debugStatus.playerFrameSuppressionPending),
        tostring(debugStatus.targetFrameSuppressionDesired),
        tostring(debugStatus.targetFrameSuppressionRequested),
        tostring(debugStatus.targetFrameSuppressionApplied),
        tostring(debugStatus.targetFrameSuppressionPending),
        tostring(debugStatus.partyFrameSuppressionDesired),
        tostring(debugStatus.lastReconcileReason),
        tostring(debugStatus.lastActionError),
        tostring(debugStatus.lastQuietError),
        tostring(debugStatus.lastPlayerError),
        tostring(debugStatus.lastTargetError)
    ))
end

local function runQuietModeCheck()
    local status =
        Logres:GetModuleStatus("QuietMode")
    local quietMode =
        Logres:GetModule("QuietMode")
    local debugStatus =
        quietMode:GetDebugStatus()

    local preferences = Logres:GetPreferences()
    local state = Logres:GetState()

    local expected =
        preferences.immersionEnabled == true
        and state.context == "world"

    local stateMatches =
        debugStatus.requestedEnabled == expected
        and debugStatus.appliedEnabled == expected

    local presentationMatches = true

    if expected then
        presentationMatches =
            debugStatus.chatFrameCount >= 1
            and debugStatus.suppressedChatFrameCount
                == debugStatus.chatFrameCount
            and debugStatus.suppressedTabCount
                == debugStatus.tabCount
            and debugStatus.editBoxIgnoreCount
                == debugStatus.editBoxCount
            and debugStatus.regionSnapshotCount >= 1
            and debugStatus.persistentShownMatches == true
    else
        presentationMatches =
            debugStatus.regionSnapshotCount == 0
            and debugStatus.editBoxSnapshotCount == 0
    end

    local passed =
        status.initialized == true
        and status.enabled == true
        and debugStatus.moduleEnabled == true
        and stateMatches
        and presentationMatches
        and debugStatus.savedConfigurationMutation == false
        and debugStatus.lastError == nil

    if passed then
        emit(string.format(
            "Logres quietcheck: PASS (expected=%s applied=%s frames=%s/%s tabs=%s/%s editBoxes=%s/%s snapshots=%s/%s aux=%s persistentShownMatches=%s savedMutation=false reason=%s)",
            boolText(expected),
            boolText(debugStatus.appliedEnabled),
            tostring(debugStatus.suppressedChatFrameCount),
            tostring(debugStatus.chatFrameCount),
            tostring(debugStatus.suppressedTabCount),
            tostring(debugStatus.tabCount),
            tostring(debugStatus.editBoxIgnoreCount),
            tostring(debugStatus.editBoxCount),
            tostring(debugStatus.regionSnapshotCount),
            tostring(debugStatus.editBoxSnapshotCount),
            tostring(debugStatus.auxiliarySnapshotCount),
            boolText(debugStatus.persistentShownMatches),
            tostring(debugStatus.lastReason)
        ))
        return
    end

    emit(string.format(
        "Logres quietcheck: FAIL (initialized=%s enabled=%s moduleEnabled=%s expected=%s requested=%s applied=%s stateMatches=%s presentationMatches=%s frames=%s/%s tabs=%s/%s editBoxes=%s/%s snapshots=%s/%s aux=%s persistentShownMatches=%s savedMutation=%s reason=%s error=%s)",
        tostring(status.initialized),
        tostring(status.enabled),
        tostring(debugStatus.moduleEnabled),
        tostring(expected),
        tostring(debugStatus.requestedEnabled),
        tostring(debugStatus.appliedEnabled),
        tostring(stateMatches),
        tostring(presentationMatches),
        tostring(debugStatus.suppressedChatFrameCount),
        tostring(debugStatus.chatFrameCount),
        tostring(debugStatus.suppressedTabCount),
        tostring(debugStatus.tabCount),
        tostring(debugStatus.editBoxIgnoreCount),
        tostring(debugStatus.editBoxCount),
        tostring(debugStatus.regionSnapshotCount),
        tostring(debugStatus.editBoxSnapshotCount),
        tostring(debugStatus.auxiliarySnapshotCount),
        tostring(debugStatus.persistentShownMatches),
        tostring(debugStatus.savedConfigurationMutation),
        tostring(debugStatus.lastReason),
        tostring(debugStatus.lastError)
    ))
end


local function runPlayerFrameCheck()
    local status =
        Logres:GetModuleStatus("PlayerFrameReplacement")
    local replacement =
        Logres:GetModule("PlayerFrameReplacement")
    local debugStatus =
        replacement:GetDebugStatus()

    local expected =
        Logres:GetPreference("immersionEnabled") == true

    local stateMatches =
        debugStatus.requestedEnabled == expected
        and (
            debugStatus.appliedEnabled == expected
            or (
                debugStatus.pending
                and InCombatLockdown()
            )
        )

    local presentationMatches = true

    if not debugStatus.pending and expected then
        presentationMatches =
            debugStatus.playerFrameFound == true
            and debugStatus.containerFound == true
            and debugStatus.contentMainFound == true
            and debugStatus.containerAlpha == 0
            and debugStatus.contentMainAlpha == 0
            and debugStatus.playerFrameMouseEnabled == false
            and debugStatus.interactionReady == true
            and debugStatus.interactionShown == true
            and debugStatus.interactionMouseEnabled == true
            and debugStatus.interactionUnit == "player"
            and debugStatus.interactionLeftType == "target"
            and debugStatus.interactionRightType == "togglemenu"
            and debugStatus.snapshotReady == true
    elseif not debugStatus.pending then
        presentationMatches =
            debugStatus.appliedEnabled == false
            and debugStatus.snapshotReady == false
            and debugStatus.interactionShown == false
            and debugStatus.interactionMouseEnabled == false
    end

    local preservationSafe =
        debugStatus.wholePlayerFrameSuppressedByLogres == false
        and debugStatus.directPlayerChildrenSuppressedByLogres == false
        and debugStatus.targetFrameSuppressedByLogres == false
        and debugStatus.partyFramesSuppressedByLogres == false

    local passed =
        status.initialized == true
        and status.enabled == true
        and debugStatus.moduleEnabled == true
        and stateMatches
        and presentationMatches
        and preservationSafe
        and debugStatus.lastError == nil

    if passed then
        emit(string.format(
            "Logres playerframecheck: PASS (expected=%s applied=%s pending=%s frame=%s container=%s main=%s alpha=%s/%s stockMouse=%s interaction=%s/%s unit=%s types=%s/%s wholeFrame=false directChildren=false target=false party=false reason=%s)",
            boolText(expected),
            boolText(debugStatus.appliedEnabled),
            boolText(debugStatus.pending),
            boolText(debugStatus.playerFrameFound),
            boolText(debugStatus.containerFound),
            boolText(debugStatus.contentMainFound),
            tostring(debugStatus.containerAlpha),
            tostring(debugStatus.contentMainAlpha),
            tostring(debugStatus.playerFrameMouseEnabled),
            boolText(debugStatus.interactionShown),
            boolText(debugStatus.interactionMouseEnabled),
            tostring(debugStatus.interactionUnit),
            tostring(debugStatus.interactionLeftType),
            tostring(debugStatus.interactionRightType),
            tostring(debugStatus.lastReason)
        ))
        return
    end

    emit(string.format(
        "Logres playerframecheck: FAIL (initialized=%s enabled=%s moduleEnabled=%s expected=%s requested=%s applied=%s pending=%s stateMatches=%s presentationMatches=%s preservationSafe=%s frame=%s container=%s main=%s alpha=%s/%s stockMouse=%s click=%s motion=%s interactionReady=%s shown=%s mouse=%s unit=%s types=%s/%s snapshot=%s wholeFrame=%s directChildren=%s target=%s party=%s reason=%s error=%s)",
        tostring(status.initialized),
        tostring(status.enabled),
        tostring(debugStatus.moduleEnabled),
        tostring(expected),
        tostring(debugStatus.requestedEnabled),
        tostring(debugStatus.appliedEnabled),
        tostring(debugStatus.pending),
        tostring(stateMatches),
        tostring(presentationMatches),
        tostring(preservationSafe),
        tostring(debugStatus.playerFrameFound),
        tostring(debugStatus.containerFound),
        tostring(debugStatus.contentMainFound),
        tostring(debugStatus.containerAlpha),
        tostring(debugStatus.contentMainAlpha),
        tostring(debugStatus.playerFrameMouseEnabled),
        tostring(debugStatus.playerFrameMouseClickEnabled),
        tostring(debugStatus.playerFrameMouseMotionEnabled),
        tostring(debugStatus.interactionReady),
        tostring(debugStatus.interactionShown),
        tostring(debugStatus.interactionMouseEnabled),
        tostring(debugStatus.interactionUnit),
        tostring(debugStatus.interactionLeftType),
        tostring(debugStatus.interactionRightType),
        tostring(debugStatus.snapshotReady),
        tostring(debugStatus.wholePlayerFrameSuppressedByLogres),
        tostring(debugStatus.directPlayerChildrenSuppressedByLogres),
        tostring(debugStatus.targetFrameSuppressedByLogres),
        tostring(debugStatus.partyFramesSuppressedByLogres),
        tostring(debugStatus.lastReason),
        tostring(debugStatus.lastError)
    ))
end

local function runTargetFrameCheck()
    local status =
        Logres:GetModuleStatus("TargetFrameReplacement")
    local replacement =
        Logres:GetModule("TargetFrameReplacement")
    local debugStatus =
        replacement:GetDebugStatus()

    local expected =
        Logres:GetPreference("immersionEnabled") == true

    local stateMatches =
        debugStatus.requestedEnabled == expected
        and (
            debugStatus.appliedEnabled == expected
            or (
                debugStatus.pending
                and InCombatLockdown()
            )
        )

    local presentationMatches = true

    if not debugStatus.pending and expected then
        presentationMatches =
            debugStatus.targetFrameFound == true
            and debugStatus.containerFound == true
            and debugStatus.contentMainFound == true
            and debugStatus.contextualFound == true
            and debugStatus.stockPresentationSuppressed == true
            and debugStatus.stockMouseSuppressed == true
            and debugStatus.preservedCount == 4
            and debugStatus.preservedOverrideCount == 4
            and debugStatus.interactionReady == true
            and debugStatus.interactionConfigured == true
            and debugStatus.unitWatchRegistered == true
            and debugStatus.interactionMouseOwnedByLogres == true
            and debugStatus.interactionUnit == "target"
            and debugStatus.interactionLeftType == "target"
            and debugStatus.interactionRightType == "togglemenu"
            and debugStatus.snapshotReady == true
    elseif not debugStatus.pending then
        presentationMatches =
            debugStatus.appliedEnabled == false
            and debugStatus.snapshotReady == false
            and debugStatus.unitWatchRegistered == false
            and debugStatus.interactionMouseOwnedByLogres == false
            and debugStatus.stockPresentationSuppressed == false
            and debugStatus.stockMouseSuppressed == false
            and debugStatus.preservedOverrideCount == 0
    end

    local preservationSafe =
        debugStatus.wholeTargetFrameSuppressedByLogres == false
        and debugStatus.targetOfTargetSuppressedByLogres == false
        and debugStatus.focusFrameSuppressedByLogres == false
        and debugStatus.bossFramesSuppressedByLogres == false
        and debugStatus.partyFramesSuppressedByLogres == false

    local passed =
        status.initialized == true
        and status.enabled == true
        and debugStatus.moduleEnabled == true
        and stateMatches
        and presentationMatches
        and preservationSafe
        and debugStatus.lastError == nil

    if passed then
        emit(string.format(
            "Logres targetframecheck: PASS (expected=%s applied=%s pending=%s frame=%s container=%s main=%s contextual=%s stockPresentation=%s stockMouseSuppressed=%s preservedOverrides=%s/%s interactionReady=%s configured=%s watch=%s mouseOwned=%s unit=%s types=%s/%s wholeFrame=false tot=false focus=false boss=false party=false reason=%s)",
            boolText(expected),
            boolText(debugStatus.appliedEnabled),
            boolText(debugStatus.pending),
            boolText(debugStatus.targetFrameFound),
            boolText(debugStatus.containerFound),
            boolText(debugStatus.contentMainFound),
            boolText(debugStatus.contextualFound),
            boolText(debugStatus.stockPresentationSuppressed),
            boolText(debugStatus.stockMouseSuppressed),
            tostring(debugStatus.preservedOverrideCount),
            tostring(debugStatus.preservedCount),
            boolText(debugStatus.interactionReady),
            boolText(debugStatus.interactionConfigured),
            boolText(debugStatus.unitWatchRegistered),
            boolText(debugStatus.interactionMouseOwnedByLogres),
            tostring(debugStatus.interactionUnit),
            tostring(debugStatus.interactionLeftType),
            tostring(debugStatus.interactionRightType),
            tostring(debugStatus.lastReason)
        ))
        return
    end

    emit(string.format(
        "Logres targetframecheck: FAIL (initialized=%s enabled=%s moduleEnabled=%s expected=%s requested=%s applied=%s pending=%s stateMatches=%s presentationMatches=%s preservationSafe=%s frame=%s container=%s main=%s contextual=%s stockPresentation=%s stockMouseSuppressed=%s preservedOverrides=%s/%s interactionReady=%s configured=%s watch=%s mouseOwned=%s unit=%s types=%s/%s snapshot=%s wholeFrame=%s tot=%s focus=%s boss=%s party=%s reason=%s error=%s)",
        tostring(status.initialized),
        tostring(status.enabled),
        tostring(debugStatus.moduleEnabled),
        tostring(expected),
        tostring(debugStatus.requestedEnabled),
        tostring(debugStatus.appliedEnabled),
        tostring(debugStatus.pending),
        tostring(stateMatches),
        tostring(presentationMatches),
        tostring(preservationSafe),
        tostring(debugStatus.targetFrameFound),
        tostring(debugStatus.containerFound),
        tostring(debugStatus.contentMainFound),
        tostring(debugStatus.contextualFound),
        tostring(debugStatus.stockPresentationSuppressed),
        tostring(debugStatus.stockMouseSuppressed),
        tostring(debugStatus.preservedOverrideCount),
        tostring(debugStatus.preservedCount),
        tostring(debugStatus.interactionReady),
        tostring(debugStatus.interactionConfigured),
        tostring(debugStatus.unitWatchRegistered),
        tostring(debugStatus.interactionMouseOwnedByLogres),
        tostring(debugStatus.interactionUnit),
        tostring(debugStatus.interactionLeftType),
        tostring(debugStatus.interactionRightType),
        tostring(debugStatus.snapshotReady),
        tostring(debugStatus.wholeTargetFrameSuppressedByLogres),
        tostring(debugStatus.targetOfTargetSuppressedByLogres),
        tostring(debugStatus.focusFrameSuppressedByLogres),
        tostring(debugStatus.bossFramesSuppressedByLogres),
        tostring(debugStatus.partyFramesSuppressedByLogres),
        tostring(debugStatus.lastReason),
        tostring(debugStatus.lastError)
    ))
end

local CONTEXT_POLICY_ALPHA = {
    world = {
        primary = 1.00,
        secondary = 0.45,
        utility = 0.20,
    },
    pvp = {
        primary = 1.00,
        secondary = 0.75,
        utility = 0.40,
    },
    instance = {
        primary = 1.00,
        secondary = 0.70,
        utility = 0.45,
    },
    combat = {
        primary = 1.00,
        secondary = 1.00,
        utility = 0.75,
    },
}

local function resolveExpectedContextPolicy(state)
    if state.combat then
        return "combat"
    end

    if state.pvpFlagged then
        return "pvp"
    end

    if state.context == "instance" then
        return "instance"
    end

    return "world"
end

local function contextDomainSettledOrDeferred(
    applied,
    expected,
    pending
)
    if applied == expected then
        return true
    end

    return pending == true
        and InCombatLockdown()
end

local function runContextPolicyCheck()
    local state = Logres:GetState()
    local preferences = Logres:GetPreferences()

    local controllerStatus =
        Logres:GetModuleStatus("ImmersionController")
    local controller =
        Logres:GetModule("ImmersionController")
    local controllerDebug =
        controller:GetDebugStatus()

    local actionContextStatus =
        Logres:GetModuleStatus("ActionContext")
    local actionContext =
        Logres:GetModule("ActionContext")
    local actionDebug =
        actionContext:GetDebugStatus()

    local immersion =
        preferences.immersionEnabled == true

    local expectedContext =
        state.inInstance
        and "instance"
        or "world"

    local expectedQuiet =
        immersion
        and state.context == "world"

    local expectedActionPolicy =
        resolveExpectedContextPolicy(state)

    local expectedAlpha =
        CONTEXT_POLICY_ALPHA[expectedActionPolicy]

    local stateShapeOK =
        (
            state.context == "world"
            or state.context == "instance"
        )
        and state.context == expectedContext
        and type(state.combat) == "boolean"
        and type(state.pvpFlagged) == "boolean"
        and type(state.inInstance) == "boolean"

    local controllerStateOK =
        controllerDebug.immersionEnabled == immersion
        and controllerDebug.context == state.context
        and controllerDebug.combat == state.combat
        and controllerDebug.pvpFlagged == state.pvpFlagged

    local desiredOwnershipOK =
        controllerDebug.actionReplacementDesired == immersion
        and controllerDebug.quietModeDesired == expectedQuiet
        and controllerDebug.playerFrameSuppressionDesired == immersion
        and controllerDebug.targetFrameSuppressionDesired == immersion
        and controllerDebug.partyFrameSuppressionDesired == false
        and controllerDebug.primaryActionRoutingOwned == false

    local requestedOwnershipOK =
        controllerDebug.actionReplacementRequested == immersion
        and controllerDebug.quietModeRequested == expectedQuiet
        and controllerDebug.playerFrameSuppressionRequested == immersion
        and controllerDebug.targetFrameSuppressionRequested == immersion

    local appliedOwnershipOK =
        contextDomainSettledOrDeferred(
            controllerDebug.actionReplacementApplied,
            immersion,
            controllerDebug.actionReplacementPending
        )
        and controllerDebug.quietModeApplied == expectedQuiet
        and contextDomainSettledOrDeferred(
            controllerDebug.playerFrameSuppressionApplied,
            immersion,
            controllerDebug.playerFrameSuppressionPending
        )
        and contextDomainSettledOrDeferred(
            controllerDebug.targetFrameSuppressionApplied,
            immersion,
            controllerDebug.targetFrameSuppressionPending
        )

    local actionPolicyOK =
        actionDebug.policyName == expectedActionPolicy
        and actionDebug.primaryAlpha == expectedAlpha.primary
        and actionDebug.secondaryAlpha == expectedAlpha.secondary
        and actionDebug.utilityAlpha == expectedAlpha.utility
        and actionDebug.alphaZeroUsed == false

    local errorsClear =
        controllerDebug.actionReplacementError == nil
        and controllerDebug.quietModeError == nil
        and controllerDebug.playerFrameSuppressionError == nil
        and controllerDebug.targetFrameSuppressionError == nil
        and controllerDebug.lastActionError == nil
        and controllerDebug.lastQuietError == nil
        and controllerDebug.lastPlayerError == nil
        and controllerDebug.lastTargetError == nil

    local modulesReady =
        controllerStatus.initialized == true
        and controllerStatus.enabled == true
        and controllerDebug.moduleEnabled == true
        and actionContextStatus.initialized == true
        and actionContextStatus.enabled == true
        and actionDebug.moduleEnabled == true

    local passed =
        modulesReady
        and stateShapeOK
        and controllerStateOK
        and desiredOwnershipOK
        and requestedOwnershipOK
        and appliedOwnershipOK
        and actionPolicyOK
        and errorsClear

    if passed then
        emit(string.format(
            "Logres contextpolicycheck: PASS (immersion=%s context=%s instance=%s/%s combat=%s pvp=%s actionPolicy=%s alpha=%.2f/%.2f/%.2f replace=%s quiet=%s player=%s target=%s party=false pending=%s/%s/%s)",
            boolText(immersion),
            tostring(state.context),
            boolText(state.inInstance),
            tostring(state.instanceType),
            boolText(state.combat),
            boolText(state.pvpFlagged),
            tostring(actionDebug.policyName),
            actionDebug.primaryAlpha,
            actionDebug.secondaryAlpha,
            actionDebug.utilityAlpha,
            boolText(controllerDebug.actionReplacementDesired),
            boolText(controllerDebug.quietModeDesired),
            boolText(controllerDebug.playerFrameSuppressionDesired),
            boolText(controllerDebug.targetFrameSuppressionDesired),
            boolText(controllerDebug.actionReplacementPending),
            boolText(controllerDebug.playerFrameSuppressionPending),
            boolText(controllerDebug.targetFrameSuppressionPending)
        ))
        return
    end

    emit(string.format(
        "Logres contextpolicycheck: FAIL (modulesReady=%s stateShape=%s controllerState=%s desiredOwnership=%s requestedOwnership=%s appliedOwnership=%s actionPolicy=%s errorsClear=%s immersion=%s context=%s expectedContext=%s instance=%s/%s combat=%s pvp=%s policy=%s expectedPolicy=%s alpha=%s/%s/%s expectedAlpha=%s/%s/%s actionDesired=%s requested=%s applied=%s pending=%s quietDesired=%s requested=%s applied=%s playerDesired=%s requested=%s applied=%s pending=%s targetDesired=%s requested=%s applied=%s pending=%s party=%s primaryRoutingOwned=%s)",
        tostring(modulesReady),
        tostring(stateShapeOK),
        tostring(controllerStateOK),
        tostring(desiredOwnershipOK),
        tostring(requestedOwnershipOK),
        tostring(appliedOwnershipOK),
        tostring(actionPolicyOK),
        tostring(errorsClear),
        tostring(immersion),
        tostring(state.context),
        tostring(expectedContext),
        tostring(state.inInstance),
        tostring(state.instanceType),
        tostring(state.combat),
        tostring(state.pvpFlagged),
        tostring(actionDebug.policyName),
        tostring(expectedActionPolicy),
        tostring(actionDebug.primaryAlpha),
        tostring(actionDebug.secondaryAlpha),
        tostring(actionDebug.utilityAlpha),
        tostring(expectedAlpha.primary),
        tostring(expectedAlpha.secondary),
        tostring(expectedAlpha.utility),
        tostring(controllerDebug.actionReplacementDesired),
        tostring(controllerDebug.actionReplacementRequested),
        tostring(controllerDebug.actionReplacementApplied),
        tostring(controllerDebug.actionReplacementPending),
        tostring(controllerDebug.quietModeDesired),
        tostring(controllerDebug.quietModeRequested),
        tostring(controllerDebug.quietModeApplied),
        tostring(controllerDebug.playerFrameSuppressionDesired),
        tostring(controllerDebug.playerFrameSuppressionRequested),
        tostring(controllerDebug.playerFrameSuppressionApplied),
        tostring(controllerDebug.playerFrameSuppressionPending),
        tostring(controllerDebug.targetFrameSuppressionDesired),
        tostring(controllerDebug.targetFrameSuppressionRequested),
        tostring(controllerDebug.targetFrameSuppressionApplied),
        tostring(controllerDebug.targetFrameSuppressionPending),
        tostring(controllerDebug.partyFrameSuppressionDesired),
        tostring(controllerDebug.primaryActionRoutingOwned)
    ))
end

local function runAllChecks()
    emit("Logres checkall: beginning")
    printStatus()
    runStateCheck()
    runSensorCheck()
    runPreferenceCheck()
    runLifecycleCheck()
    runHUDCheck()
    runActionCheck()
    runStockReplacementCheck()
    runImmersionCheck()
    runQuietModeCheck()
    runPlayerFrameCheck()
    runTargetFrameCheck()
    runContextPolicyCheck()
    emit("Logres checkall: complete")
end

local function handleHUDPreview(argument)
    local hud = Logres:GetModule("HUD")

    if argument == "on" then
        hud:SetPreviewEnabled(true)
    elseif argument == "off" then
        hud:SetPreviewEnabled(false)
    else
        emit("Usage: /logres hudpreview [on|off]")
        return
    end

    emit(string.format(
        "Logres: HUD preview=%s",
        argument
    ))
end

local function handleImmersion(argument)
    if argument == "" or argument == "status" then
        printPreferences()
        return
    end

    local current = Logres:GetPreference("immersionEnabled")
    local newValue

    if argument == "on" then
        newValue = true
    elseif argument == "off" then
        newValue = false
    elseif argument == "toggle" then
        newValue = not current
    else
        emit("Usage: /logres immersion [on|off|toggle]")
        return
    end

    local changed = Logres:SetPreference(
        "immersionEnabled",
        newValue,
        "COMMAND_IMMERSION"
    )

    emit(string.format(
        "Logres: immersionEnabled=%s%s",
        boolText(newValue),
        changed and "" or " (unchanged)"
    ))
end

local function printHelp()
    emit("Logres development commands:")
    emit("  /logres panel")
    emit("  /logres checkall")
    emit("  /logres status")
    emit("  /logres statecheck")
    emit("  /logres sensorcheck")
    emit("  /logres preferencecheck")
    emit("  /logres lifecyclecheck")
    emit("  /logres hudcheck")
    emit("  /logres actioncheck")
    emit("  /logres actionfeedback")
    emit("  /logres actionbindings [on|off]")
    emit("  /logres secondarybindings [on|off]")
    emit("  /logres utilitybindings [on|off]")
    emit("  /logres stockreplace [on|off]")
    emit("  /logres stockreplacecheck")
    emit("  /logres immersioncheck")
    emit("  /logres quietcheck")
    emit("  /logres playerframecheck")
    emit("  /logres targetframecheck")
    emit("  /logres contextpolicycheck")
    emit("  /logres hudpreview [on|off]")
    emit("  /logres immersion [on|off|toggle]")
    emit("  /logres debug on")
    emit("  /logres debug off")
end

local function handleCommand(message)
    local command, argument =
        (message or ""):lower():match("^%s*(%S*)%s*(.-)%s*$")

    if command == "" then
        if Logres.ToggleDevPanel then
            Logres:ToggleDevPanel()
        else
            printStatus()
        end
        return
    end

    if command == "panel" then
        if Logres.ToggleDevPanel then
            Logres:ToggleDevPanel()
        else
            emit("Logres: development panel is not available yet.")
        end
        return
    end

    if command == "checkall" then
        runAllChecks()
        return
    end

    if command == "status" then
        printStatus()
        return
    end

    if command == "statecheck" then
        runStateCheck()
        return
    end

    if command == "sensorcheck" then
        runSensorCheck()
        return
    end

    if command == "preferencecheck" then
        runPreferenceCheck()
        return
    end

    if command == "lifecyclecheck" then
        runLifecycleCheck()
        return
    end

    if command == "hudcheck" then
        runHUDCheck()
        return
    end

    if command == "actioncheck" then
        runActionCheck()
        return
    end

    if command == "actionfeedback" then
        runActionFeedbackTest()
        return
    end

    if command == "actionbindings" then
        handleActionBindings(argument)
        return
    end

    if command == "secondarybindings" then
        handleSideActionBindings("secondary", "Secondary", argument)
        return
    end

    if command == "utilitybindings" then
        handleSideActionBindings("utility", "Utility", argument)
        return
    end

    if command == "stockreplace" then
        handleStockReplacement(argument)
        return
    end

    if command == "stockreplacecheck" then
        runStockReplacementCheck()
        return
    end

    if command == "immersioncheck" then
        runImmersionCheck()
        return
    end

    if command == "quietcheck" then
        runQuietModeCheck()
        return
    end

    if command == "playerframecheck" then
        runPlayerFrameCheck()
        return
    end

    if command == "targetframecheck" then
        runTargetFrameCheck()
        return
    end

    if command == "contextpolicycheck" then
        runContextPolicyCheck()
        return
    end

    if command == "hudpreview" then
        handleHUDPreview(argument)
        return
    end

    if command == "immersion" then
        handleImmersion(argument)
        return
    end

    if command == "debug" then
        if not Logres.db then
            emit("Logres: database is not initialized yet.")
            return
        end

        if argument == "on" then
            Logres.db.settings.debug = true
            emit("Logres: development messages enabled.")
            return
        elseif argument == "off" then
            Logres.db.settings.debug = false
            emit("Logres: development messages disabled.")
            return
        end
    end

    printHelp()
end

function Logres:RunDevCommand(message, output)
    local previousOutput = activeOutput
    activeOutput = output

    local ok, commandError = pcall(handleCommand, message)

    activeOutput = previousOutput

    if not ok then
        if output then
            output("Logres command error: " .. tostring(commandError))
            return false, commandError
        end

        error(commandError, 0)
    end

    return true
end

Logres:RegisterDevPanelAction("runall", "Run All", "checkall")
Logres:RegisterDevPanelAction("status", "Status", "status")
Logres:RegisterDevPanelAction("state", "State Check", "statecheck")
Logres:RegisterDevPanelAction("sensor", "Sensor Check", "sensorcheck")
Logres:RegisterDevPanelAction(
    "preference",
    "Preference Check",
    "preferencecheck"
)
Logres:RegisterDevPanelAction(
    "lifecycle",
    "Lifecycle Check",
    "lifecyclecheck"
)
Logres:RegisterDevPanelAction("hud", "HUD Check", "hudcheck")
Logres:RegisterDevPanelAction("action", "Action Check", "actioncheck")
Logres:RegisterDevPanelAction("actionFeedback", "Feedback Test", "actionfeedback")
Logres:RegisterDevPanelAction("actionKeysOn", "Action Keys ON", "actionbindings on")
Logres:RegisterDevPanelAction("actionKeysOff", "Action Keys OFF", "actionbindings off")
Logres:RegisterDevPanelAction(
    "secondaryKeysOn",
    "Secondary Keys ON",
    "secondarybindings on"
)
Logres:RegisterDevPanelAction(
    "secondaryKeysOff",
    "Secondary Keys OFF",
    "secondarybindings off"
)
Logres:RegisterDevPanelAction(
    "utilityKeysOn",
    "Utility Keys ON",
    "utilitybindings on"
)
Logres:RegisterDevPanelAction(
    "utilityKeysOff",
    "Utility Keys OFF",
    "utilitybindings off"
)
Logres:RegisterDevPanelAction(
    "stockReplaceCheck",
    "Stock Replace Check",
    "stockreplacecheck"
)
Logres:RegisterDevPanelAction(
    "stockReplaceOn",
    "Stock Replace ON",
    "stockreplace on"
)
Logres:RegisterDevPanelAction(
    "stockReplaceOff",
    "Stock Replace OFF",
    "stockreplace off"
)
Logres:RegisterDevPanelAction(
    "immersionCheck",
    "Immersion Check",
    "immersioncheck"
)
Logres:RegisterDevPanelAction(
    "quietCheck",
    "Quiet Check",
    "quietcheck"
)
Logres:RegisterDevPanelAction(
    "playerFrameCheck",
    "Player Frame Check",
    "playerframecheck"
)
Logres:RegisterDevPanelAction(
    "targetFrameCheck",
    "Target Frame Check",
    "targetframecheck"
)
Logres:RegisterDevPanelAction(
    "contextPolicyCheck",
    "Context Policy Check",
    "contextpolicycheck"
)
Logres:RegisterDevPanelAction(
    "immersionOn",
    "Immersion ON",
    "immersion on"
)
Logres:RegisterDevPanelAction(
    "immersionOff",
    "Immersion OFF",
    "immersion off"
)
Logres:RegisterDevPanelAction(
    "previewOn",
    "HUD Preview ON",
    "hudpreview on"
)
Logres:RegisterDevPanelAction(
    "previewOff",
    "HUD Preview OFF",
    "hudpreview off"
)

SLASH_LOGRES1 = "/logres"
SlashCmdList.LOGRES = function(message)
    Logres:RunDevCommand(message)
end
