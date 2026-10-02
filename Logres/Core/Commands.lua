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
            and debugStatus.interactionConfigured == true
            and debugStatus.interactionMouseOwnedByLogres == true
            and debugStatus.interactionUnit == "player"
            and debugStatus.interactionLeftType == "target"
            and debugStatus.interactionRightType == "togglemenu"
            and debugStatus.snapshotReady == true
    elseif not debugStatus.pending then
        presentationMatches =
            debugStatus.appliedEnabled == false
            and debugStatus.snapshotReady == false
            and debugStatus.interactionMouseOwnedByLogres == false
            and debugStatus.stockPresentationSuppressed == false
            and debugStatus.stockMouseSuppressed == false
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
            "Logres playerframecheck: PASS (expected=%s applied=%s pending=%s frame=%s container=%s main=%s alpha=%s/%s stockMouse=%s interactionConfigured=%s mouseOwned=%s unit=%s types=%s/%s wholeFrame=false directChildren=false target=false party=false reason=%s)",
            boolText(expected),
            boolText(debugStatus.appliedEnabled),
            boolText(debugStatus.pending),
            boolText(debugStatus.playerFrameFound),
            boolText(debugStatus.containerFound),
            boolText(debugStatus.contentMainFound),
            tostring(debugStatus.containerAlpha),
            tostring(debugStatus.contentMainAlpha),
            tostring(debugStatus.playerFrameMouseEnabled),
            boolText(debugStatus.interactionConfigured),
            boolText(debugStatus.interactionMouseOwnedByLogres),
            tostring(debugStatus.interactionUnit),
            tostring(debugStatus.interactionLeftType),
            tostring(debugStatus.interactionRightType),
            tostring(debugStatus.lastReason)
        ))
        return
    end

    emit(string.format(
        "Logres playerframecheck: FAIL (initialized=%s enabled=%s moduleEnabled=%s expected=%s requested=%s applied=%s pending=%s stateMatches=%s presentationMatches=%s preservationSafe=%s frame=%s container=%s main=%s alpha=%s/%s stockMouse=%s click=%s motion=%s interactionReady=%s configured=%s mouseOwned=%s unit=%s types=%s/%s snapshot=%s wholeFrame=%s directChildren=%s target=%s party=%s reason=%s error=%s)",
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
        tostring(debugStatus.interactionConfigured),
        tostring(debugStatus.interactionMouseOwnedByLogres),
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

local function collectRestorationState()
    local state = Logres:GetState()

    return {
        immersion =
            Logres:GetPreference("immersionEnabled") == true,
        context = state.context,

        controllerStatus =
            Logres:GetModuleStatus("ImmersionController"),
        controller =
            Logres:GetModule("ImmersionController")
                :GetRecoveryStatus(),

        actionStatus =
            Logres:GetModuleStatus("StockActionReplacement"),
        action =
            Logres:GetModule("StockActionReplacement")
                :GetRecoveryStatus(),

        quietStatus =
            Logres:GetModuleStatus("QuietMode"),
        quiet =
            Logres:GetModule("QuietMode")
                :GetRecoveryStatus(),

        playerStatus =
            Logres:GetModuleStatus("PlayerFrameReplacement"),
        player =
            Logres:GetModule("PlayerFrameReplacement")
                :GetRecoveryStatus(),

        targetStatus =
            Logres:GetModuleStatus("TargetFrameReplacement"),
        target =
            Logres:GetModule("TargetFrameReplacement")
                :GetRecoveryStatus(),
    }
end

local function protectedRecoveryMatches(
    recovery,
    expected,
    allowPending
)
    if recovery.requestedEnabled ~= expected then
        return false
    end

    if recovery.appliedEnabled == expected then
        return true
    end

    return allowPending
        and recovery.pending == true
        and InCombatLockdown()
end

local function restorationOwnershipCoherent(snapshot)
    local action = snapshot.action
    local quiet = snapshot.quiet
    local player = snapshot.player
    local target = snapshot.target

    local targetOverrideExpected =
        target.appliedEnabled and 4 or 0

    return action.snapshotReady == action.appliedEnabled
        and action.routingManaged == action.appliedEnabled
        and quiet.snapshotReady == quiet.appliedEnabled
        and player.snapshotReady == player.appliedEnabled
        and player.interactionConfigured == true
        and player.interactionMouseOwnedByLogres
            == player.appliedEnabled
        and player.stockPresentationSuppressed
            == player.appliedEnabled
        and player.stockMouseSuppressed
            == player.appliedEnabled
        and target.snapshotReady == target.appliedEnabled
        and target.interactionConfigured == true
        and target.unitWatchRegistered == target.appliedEnabled
        and target.interactionMouseOwnedByLogres
            == target.appliedEnabled
        and target.stockPresentationSuppressed
            == target.appliedEnabled
        and target.stockMouseSuppressed
            == target.appliedEnabled
        and target.preservedOverrideCount
            == targetOverrideExpected
end

local function restorationMatchDetails(
    snapshot,
    expectedImmersion,
    allowPending
)
    local expectedQuiet =
        expectedImmersion
        and snapshot.context == "world"

    local controller = snapshot.controller

    local modulesReady =
        snapshot.controllerStatus.initialized == true
        and snapshot.controllerStatus.enabled == true
        and controller.moduleEnabled == true
        and snapshot.actionStatus.enabled == true
        and snapshot.quietStatus.enabled == true
        and snapshot.playerStatus.enabled == true
        and snapshot.targetStatus.enabled == true

    local desiredMatches =
        controller.immersionEnabled == expectedImmersion
        and controller.context == snapshot.context
        and controller.actionReplacementDesired
            == expectedImmersion
        and controller.quietModeDesired == expectedQuiet
        and controller.playerFrameSuppressionDesired
            == expectedImmersion
        and controller.targetFrameSuppressionDesired
            == expectedImmersion
        and controller.partyFrameSuppressionDesired == false
        and controller.primaryActionRoutingOwned == false

    local recoveryMatches =
        protectedRecoveryMatches(
            snapshot.action,
            expectedImmersion,
            allowPending
        )
        and snapshot.quiet.requestedEnabled == expectedQuiet
        and snapshot.quiet.appliedEnabled == expectedQuiet
        and protectedRecoveryMatches(
            snapshot.player,
            expectedImmersion,
            allowPending
        )
        and protectedRecoveryMatches(
            snapshot.target,
            expectedImmersion,
            allowPending
        )

    local ownershipCoherent =
        restorationOwnershipCoherent(snapshot)

    local errorsClear =
        snapshot.action.lastError == nil
        and snapshot.quiet.lastError == nil
        and snapshot.player.lastError == nil
        and snapshot.target.lastError == nil
        and controller.lastActionError == nil
        and controller.lastQuietError == nil
        and controller.lastPlayerError == nil
        and controller.lastTargetError == nil

    return {
        passed =
            modulesReady
            and desiredMatches
            and recoveryMatches
            and ownershipCoherent
            and errorsClear,
        modulesReady = modulesReady,
        desiredMatches = desiredMatches,
        recoveryMatches = recoveryMatches,
        ownershipCoherent = ownershipCoherent,
        errorsClear = errorsClear,
        expectedQuiet = expectedQuiet,
    }
end

local function restorationStateMatches(
    snapshot,
    expectedImmersion,
    allowPending
)
    return restorationMatchDetails(
        snapshot,
        expectedImmersion,
        allowPending
    ).passed
end

local function restorationMismatchSummary(
    snapshot,
    expectedImmersion,
    allowPending
)
    local details =
        restorationMatchDetails(
            snapshot,
            expectedImmersion,
            allowPending
        )

    local controller = snapshot.controller
    local action = snapshot.action
    local quiet = snapshot.quiet
    local player = snapshot.player
    local target = snapshot.target

    return string.format(
        "expected=%s quietExpected=%s modules=%s desired=%s recovery=%s ownership=%s errors=%s controller=%s/%s/%s/%s action=%s/%s/%s snap=%s route=%s quiet=%s/%s snap=%s player=%s/%s/%s snap=%s interact=%s mouse=%s present=%s stockMouse=%s target=%s/%s/%s snap=%s watch=%s interact=%s mouse=%s present=%s stockMouse=%s overrides=%s targetReason=%s targetError=%s controllerTargetResult=%s controllerTargetError=%s",
        boolText(expectedImmersion),
        boolText(details.expectedQuiet),
        boolText(details.modulesReady),
        boolText(details.desiredMatches),
        boolText(details.recoveryMatches),
        boolText(details.ownershipCoherent),
        boolText(details.errorsClear),
        boolText(controller.immersionEnabled),
        boolText(controller.actionReplacementDesired),
        boolText(controller.playerFrameSuppressionDesired),
        boolText(controller.targetFrameSuppressionDesired),
        boolText(action.requestedEnabled),
        boolText(action.appliedEnabled),
        boolText(action.pending),
        boolText(action.snapshotReady),
        boolText(action.routingManaged),
        boolText(quiet.requestedEnabled),
        boolText(quiet.appliedEnabled),
        boolText(quiet.snapshotReady),
        boolText(player.requestedEnabled),
        boolText(player.appliedEnabled),
        boolText(player.pending),
        boolText(player.snapshotReady),
        boolText(player.interactionConfigured),
        boolText(player.interactionMouseOwnedByLogres),
        boolText(player.stockPresentationSuppressed),
        boolText(player.stockMouseSuppressed),
        boolText(target.requestedEnabled),
        boolText(target.appliedEnabled),
        boolText(target.pending),
        boolText(target.snapshotReady),
        boolText(target.unitWatchRegistered),
        boolText(target.interactionConfigured),
        boolText(target.interactionMouseOwnedByLogres),
        boolText(target.stockPresentationSuppressed),
        boolText(target.stockMouseSuppressed),
        tostring(target.preservedOverrideCount),
        tostring(target.lastReason),
        tostring(target.lastError),
        tostring(controller.lastTargetResult),
        tostring(controller.lastTargetError)
    )
end

local function failOpenStateMatches(snapshot, originalImmersion)
    local controller = snapshot.controller

    return snapshot.immersion == originalImmersion
        and snapshot.controllerStatus.enabled == false
        and controller.moduleEnabled == false
        and snapshot.action.requestedEnabled == false
        and snapshot.action.appliedEnabled == false
        and snapshot.action.pending == false
        and snapshot.quiet.requestedEnabled == false
        and snapshot.quiet.appliedEnabled == false
        and snapshot.player.requestedEnabled == false
        and snapshot.player.appliedEnabled == false
        and snapshot.player.pending == false
        and snapshot.target.requestedEnabled == false
        and snapshot.target.appliedEnabled == false
        and snapshot.target.pending == false
        and restorationOwnershipCoherent(snapshot)
        and snapshot.action.lastError == nil
        and snapshot.quiet.lastError == nil
        and snapshot.player.lastError == nil
        and snapshot.target.lastError == nil
        and controller.lastActionError == nil
        and controller.lastQuietError == nil
        and controller.lastPlayerError == nil
        and controller.lastTargetError == nil
end

local function restorationSummary(snapshot)
    return string.format(
        "immersion=%s context=%s action=%s/%s/%s quiet=%s/%s player=%s/%s/%s target=%s/%s/%s",
        boolText(snapshot.immersion),
        tostring(snapshot.context),
        boolText(snapshot.action.requestedEnabled),
        boolText(snapshot.action.appliedEnabled),
        boolText(snapshot.action.pending),
        boolText(snapshot.quiet.requestedEnabled),
        boolText(snapshot.quiet.appliedEnabled),
        boolText(snapshot.player.requestedEnabled),
        boolText(snapshot.player.appliedEnabled),
        boolText(snapshot.player.pending),
        boolText(snapshot.target.requestedEnabled),
        boolText(snapshot.target.appliedEnabled),
        boolText(snapshot.target.pending)
    )
end

local function runRestorationCheck()
    local originalImmersion =
        Logres:GetPreference("immersionEnabled") == true
    local initial = collectRestorationState()

    if initial.controllerStatus.enabled ~= true then
        emit(
            "Logres restorationcheck: FAIL "
            .. "(ImmersionController is disabled; no mutation attempted)"
        )
        return
    end

    if InCombatLockdown() then
        local passed =
            restorationStateMatches(
                initial,
                originalImmersion,
                true
            )

        if passed then
            emit(
                "Logres restorationcheck: PASS "
                .. "(mode=combat-nonmutating "
                .. restorationSummary(initial)
                .. ")"
            )
            return
        end

        emit(
            "Logres restorationcheck: FAIL "
            .. "(mode=combat-nonmutating "
            .. restorationSummary(initial)
            .. ")"
        )
        return
    end

    local cycleOK, cycleError = pcall(function()
        if not restorationStateMatches(
            initial,
            originalImmersion,
            false
        ) then
            error(
                "initial state is not settled "
                .. restorationMismatchSummary(
                    initial,
                    originalImmersion,
                    false
                ),
                0
            )
        end

        local flipped =
            Logres:SetPreference(
                "immersionEnabled",
                not originalImmersion,
                "DEV_RESTORATIONCHECK_FLIP"
            )

        if flipped ~= true then
            error("preference flip did not change state", 0)
        end

        local opposite = collectRestorationState()

        if not restorationStateMatches(
            opposite,
            not originalImmersion,
            false
        ) then
            error(
                "opposite preference state did not settle "
                .. restorationMismatchSummary(
                    opposite,
                    not originalImmersion,
                    false
                ),
                0
            )
        end

        local restored =
            Logres:SetPreference(
                "immersionEnabled",
                originalImmersion,
                "DEV_RESTORATIONCHECK_RESTORE"
            )

        if restored ~= true then
            error("preference restore did not change state", 0)
        end

        local restoredState = collectRestorationState()

        if not restorationStateMatches(
            restoredState,
            originalImmersion,
            false
        ) then
            error(
                "original preference did not reconverge "
                .. restorationMismatchSummary(
                    restoredState,
                    originalImmersion,
                    false
                ),
                0
            )
        end

        if Logres:DisableModule("ImmersionController") ~= true then
            error("ImmersionController did not disable", 0)
        end

        local disabledState = collectRestorationState()

        if not failOpenStateMatches(
            disabledState,
            originalImmersion
        ) then
            error("controller fail-open restoration did not settle", 0)
        end

        if Logres:EnableModule("ImmersionController") ~= true then
            error("ImmersionController did not re-enable", 0)
        end

        local reenabledState = collectRestorationState()

        if not restorationStateMatches(
            reenabledState,
            originalImmersion,
            false
        ) then
            error(
                "controller re-enable did not reconverge "
                .. restorationMismatchSummary(
                    reenabledState,
                    originalImmersion,
                    false
                ),
                0
            )
        end
    end)

    local cleanupErrors = {}

    if Logres:GetPreference("immersionEnabled") ~= originalImmersion then
        local ok, cleanupError = pcall(function()
            Logres:SetPreference(
                "immersionEnabled",
                originalImmersion,
                "DEV_RESTORATIONCHECK_FINALIZE_PREFERENCE"
            )
        end)

        if not ok then
            cleanupErrors[#cleanupErrors + 1] =
                "preference=" .. tostring(cleanupError)
        end
    end

    if not Logres:GetModuleStatus("ImmersionController").enabled then
        local ok, cleanupError = pcall(function()
            Logres:EnableModule("ImmersionController")
        end)

        if not ok then
            cleanupErrors[#cleanupErrors + 1] =
                "controller=" .. tostring(cleanupError)
        end
    end

    if Logres:GetModuleStatus("ImmersionController").enabled then
        local controller =
            Logres:GetModule("ImmersionController")

        local ok, cleanupError = pcall(function()
            controller:Reconcile(
                "DEV_RESTORATIONCHECK_FINALIZE_RECONCILE"
            )
        end)

        if not ok then
            cleanupErrors[#cleanupErrors + 1] =
                "reconcile=" .. tostring(cleanupError)
        end
    end

    local final = collectRestorationState()
    local finalOK =
        final.immersion == originalImmersion
        and restorationStateMatches(
            final,
            originalImmersion,
            false
        )

    if cycleOK
        and #cleanupErrors == 0
        and finalOK
    then
        emit(string.format(
            "Logres restorationcheck: PASS (mode=active original=%s final=%s controllerCycle=true context=%s)",
            boolText(originalImmersion),
            boolText(final.immersion),
            tostring(final.context)
        ))
        return
    end

    emit(
        "Logres restorationcheck: FAIL "
        .. "(cycleError="
        .. tostring(cycleOK and "none" or cycleError)
        .. " cleanup="
        .. tostring(
            #cleanupErrors == 0
            and "none"
            or table.concat(cleanupErrors, " | ")
        )
        .. " finalOK="
        .. tostring(finalOK)
        .. " "
        .. restorationSummary(final)
        .. ")"
    )
end

local function runCompassCheck()
    local status = Logres:GetModuleStatus("Compass")
    local compass = Logres:GetModule("Compass")
    local debugStatus = compass:GetDebugStatus()
    local preferences = Logres:GetPreferences()
    local state = Logres:GetState()

    local expectedPolicy =
        preferences.immersionEnabled == true
        and state.context == "world"

    local policyMatches =
        debugStatus.immersionEnabled
            == (preferences.immersionEnabled == true)
        and debugStatus.context == state.context
        and debugStatus.policyEligible == expectedPolicy

    local presentationMatches
    local headingOK = false

    if expectedPolicy then
        headingOK =
            type(debugStatus.headingDegrees) == "number"
            and debugStatus.headingDegrees >= 0
            and debugStatus.headingDegrees < 360

        presentationMatches =
            debugStatus.facingAPIAvailable == true
            and debugStatus.facingAvailable == true
            and debugStatus.updateActive == true
            and debugStatus.presentationActive == true
            and debugStatus.rootShown == true
            and headingOK
    else
        presentationMatches =
            debugStatus.updateActive == false
            and debugStatus.presentationActive == false
            and debugStatus.rootShown == false
            and debugStatus.headingDegrees == nil
    end

    local waypointBearingOK =
        debugStatus.waypointBearingAvailable == false

    if debugStatus.waypointBearingAvailable then
        waypointBearingOK =
            type(debugStatus.waypointBearingDegrees) == "number"
            and debugStatus.waypointBearingDegrees >= 0
            and debugStatus.waypointBearingDegrees < 360
            and type(debugStatus.waypointRelativeDegrees) == "number"
    end

    local expectedMarkerShown = false

    if expectedPolicy
        and debugStatus.waypointBearingAvailable
        and type(debugStatus.waypointRelativeDegrees) == "number"
    then
        expectedMarkerShown =
            math.abs(debugStatus.waypointRelativeDegrees) <= 100
    end

    local waypointCoherent =
        debugStatus.waypointMarkerReady == true
        and debugStatus.waypointEventRegistered == true
        and waypointBearingOK
        and debugStatus.waypointMarkerShown == expectedMarkerShown
        and (
            debugStatus.waypointSourcePresent == true
            or (
                debugStatus.waypointBearingAvailable == false
                and debugStatus.waypointMarkerShown == false
            )
        )

    if not expectedPolicy then
        waypointCoherent =
            waypointCoherent
            and debugStatus.waypointMarkerShown == false
    end

    local passed =
        status.initialized == true
        and status.enabled == true
        and debugStatus.moduleEnabled == true
        and debugStatus.rootReady == true
        and debugStatus.directionCount == 8
        and policyMatches
        and presentationMatches
        and waypointCoherent
        and debugStatus.lastError == nil
        and debugStatus.lastWaypointError == nil

    local headingText = "nil"
    local waypointBearingText = "nil"
    local waypointRelativeText = "nil"

    if type(debugStatus.headingDegrees) == "number" then
        headingText = string.format("%.1f", debugStatus.headingDegrees)
    end

    if type(debugStatus.waypointBearingDegrees) == "number" then
        waypointBearingText =
            string.format("%.1f", debugStatus.waypointBearingDegrees)
    end

    if type(debugStatus.waypointRelativeDegrees) == "number" then
        waypointRelativeText =
            string.format("%.1f", debugStatus.waypointRelativeDegrees)
    end

    if passed then
        emit(string.format(
            "Logres compasscheck: PASS (immersion=%s context=%s policy=%s facing=%s update=%s active=%s heading=%s waypointAPI=%s event=%s waypoint=%s bearing=%s relative=%s marker=%s waypointReason=%s reason=%s)",
            boolText(preferences.immersionEnabled == true),
            tostring(state.context),
            boolText(debugStatus.policyEligible),
            boolText(debugStatus.facingAvailable),
            boolText(debugStatus.updateActive),
            boolText(debugStatus.presentationActive),
            headingText,
            boolText(debugStatus.waypointAPIAvailable),
            boolText(debugStatus.waypointEventRegistered),
            boolText(debugStatus.waypointSourcePresent),
            waypointBearingText,
            waypointRelativeText,
            boolText(debugStatus.waypointMarkerShown),
            tostring(debugStatus.lastWaypointReason),
            tostring(debugStatus.lastReason)
        ))
        return
    end

    emit(string.format(
        "Logres compasscheck: FAIL (initialized=%s enabled=%s moduleEnabled=%s rootReady=%s directions=%s policyMatches=%s presentationMatches=%s waypointCoherent=%s expectedPolicy=%s immersion=%s/%s context=%s/%s facingAPI=%s facing=%s update=%s active=%s shown=%s heading=%s headingOK=%s waypointAPI=%s event=%s waypoint=%s bearingAvailable=%s bearing=%s relative=%s markerReady=%s markerShown=%s expectedMarker=%s waypointReason=%s waypointError=%s reason=%s error=%s)",
        tostring(status.initialized),
        tostring(status.enabled),
        tostring(debugStatus.moduleEnabled),
        tostring(debugStatus.rootReady),
        tostring(debugStatus.directionCount),
        tostring(policyMatches),
        tostring(presentationMatches),
        tostring(waypointCoherent),
        tostring(expectedPolicy),
        tostring(debugStatus.immersionEnabled),
        tostring(preferences.immersionEnabled == true),
        tostring(debugStatus.context),
        tostring(state.context),
        tostring(debugStatus.facingAPIAvailable),
        tostring(debugStatus.facingAvailable),
        tostring(debugStatus.updateActive),
        tostring(debugStatus.presentationActive),
        tostring(debugStatus.rootShown),
        headingText,
        tostring(headingOK),
        tostring(debugStatus.waypointAPIAvailable),
        tostring(debugStatus.waypointEventRegistered),
        tostring(debugStatus.waypointSourcePresent),
        tostring(debugStatus.waypointBearingAvailable),
        waypointBearingText,
        waypointRelativeText,
        tostring(debugStatus.waypointMarkerReady),
        tostring(debugStatus.waypointMarkerShown),
        tostring(expectedMarkerShown),
        tostring(debugStatus.lastWaypointReason),
        tostring(debugStatus.lastWaypointError),
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

local function runXPCheck()
    local status = Logres:GetModuleStatus("QuestXP")
    local xp = Logres:GetModule("QuestXP")
    local debugStatus = xp:GetDebugStatus()

    local baselineCoherent = true

    if debugStatus.baselineAvailable then
        baselineCoherent =
            type(debugStatus.lastCurrentXP) == "number"
            and type(debugStatus.lastMaxXP) == "number"
            and debugStatus.lastCurrentXP >= 0
            and debugStatus.lastMaxXP > 0
    end

    local policyCoherent =
        debugStatus.immersionEnabled
        or debugStatus.pulseShown == false

    local passed =
        status.initialized == true
        and status.enabled == true
        and debugStatus.moduleEnabled == true
        and debugStatus.rootReady == true
        and debugStatus.textReady == true
        and debugStatus.eventFrameReady == true
        and debugStatus.timerAvailable == true
        and debugStatus.xpAPIAvailable == true
        and debugStatus.playerXPEventRegistered == true
        and debugStatus.levelEventRegistered == true
        and debugStatus.worldEventRegistered == true
        and baselineCoherent
        and policyCoherent
        and debugStatus.lastError == nil

    local currentText = "nil"
    local maxText = "nil"
    local deltaText = "nil"
    local progressText = "nil"

    if type(debugStatus.lastCurrentXP) == "number" then
        currentText = tostring(debugStatus.lastCurrentXP)
    end

    if type(debugStatus.lastMaxXP) == "number" then
        maxText = tostring(debugStatus.lastMaxXP)
    end

    if type(debugStatus.lastDelta) == "number" then
        deltaText = tostring(debugStatus.lastDelta)
    end

    if type(debugStatus.lastProgressPercent) == "number" then
        progressText =
            string.format(
                "%.1f",
                debugStatus.lastProgressPercent
            )
    end

    local line = string.format(
        "initialized=%s enabled=%s module=%s immersion=%s api=%s timer=%s events=%s/%s/%s baseline=%s current=%s max=%s xpEvents=%s pulses=%s suppressed=%s previews=%s shown=%s delta=%s progress=%s sampleSecret=%s sampleReason=%s presentationReason=%s error=%s",
        tostring(status.initialized),
        tostring(status.enabled),
        tostring(debugStatus.moduleEnabled),
        tostring(debugStatus.immersionEnabled),
        tostring(debugStatus.xpAPIAvailable),
        tostring(debugStatus.timerAvailable),
        tostring(debugStatus.playerXPEventRegistered),
        tostring(debugStatus.levelEventRegistered),
        tostring(debugStatus.worldEventRegistered),
        tostring(debugStatus.baselineAvailable),
        currentText,
        maxText,
        tostring(debugStatus.xpEventCount),
        tostring(debugStatus.pulseCount),
        tostring(debugStatus.suppressedCount),
        tostring(debugStatus.previewCount),
        tostring(debugStatus.pulseShown),
        deltaText,
        progressText,
        tostring(debugStatus.lastSampleSecret),
        tostring(debugStatus.lastSampleReason),
        tostring(debugStatus.lastPresentationReason),
        tostring(debugStatus.lastError)
    )

    emit(
        "Logres xpcheck: "
        .. (passed and "PASS" or "FAIL")
        .. " ("
        .. line
        .. ")"
    )
end

local function runXPPreview()
    local xp = Logres:GetModule("QuestXP")
    local ok, state = xp:ShowPreview()

    emit(string.format(
        "Logres xppreview: %s (state=%s)",
        ok and "PASS" or "FAIL",
        tostring(state)
    ))
end

local function runQuestDialogueCheck()
    local status =
        Logres:GetModuleStatus("QuestDialogue")
    local dialogue =
        Logres:GetModule("QuestDialogue")
    local debugStatus =
        dialogue:GetDebugStatus()

    local policyCoherent =
        debugStatus.immersionEnabled
        or debugStatus.presentationShown == false

    local passed =
        status.initialized == true
        and status.enabled == true
        and debugStatus.moduleEnabled == true
        and debugStatus.rootReady == true
        and debugStatus.titleReady == true
        and debugStatus.bodyReady == true
        and debugStatus.objectiveReady == true
        and debugStatus.eventFrameReady == true
        and debugStatus.timerAvailable == true
        and debugStatus.apiAvailable == true
        and debugStatus.questDetailRegistered == true
        and debugStatus.questAcceptedRegistered == true
        and debugStatus.questFinishedRegistered == true
        and debugStatus.worldRegistered == true
        and policyCoherent
        and debugStatus.lastError == nil

    emit(string.format(
        "Logres questdialoguecheck: %s (initialized=%s enabled=%s module=%s immersion=%s api=%s timer=%s events=%s/%s/%s/%s detailEvents=%s accepted=%s finished=%s world=%s presentations=%s suppressed=%s previews=%s shown=%s questID=%s body=%s objective=%s secret=%s reason=%s presentationReason=%s error=%s)",
        passed and "PASS" or "FAIL",
        tostring(status.initialized),
        tostring(status.enabled),
        tostring(debugStatus.moduleEnabled),
        tostring(debugStatus.immersionEnabled),
        tostring(debugStatus.apiAvailable),
        tostring(debugStatus.timerAvailable),
        tostring(debugStatus.questDetailRegistered),
        tostring(debugStatus.questAcceptedRegistered),
        tostring(debugStatus.questFinishedRegistered),
        tostring(debugStatus.worldRegistered),
        tostring(debugStatus.detailEventCount),
        tostring(debugStatus.acceptedEventCount),
        tostring(debugStatus.finishedEventCount),
        tostring(debugStatus.worldEventCount),
        tostring(debugStatus.presentationCount),
        tostring(debugStatus.suppressedCount),
        tostring(debugStatus.previewCount),
        tostring(debugStatus.presentationShown),
        tostring(debugStatus.lastQuestID),
        tostring(debugStatus.lastHadBody),
        tostring(debugStatus.lastHadObjective),
        tostring(debugStatus.lastSecret),
        tostring(debugStatus.lastReason),
        tostring(debugStatus.lastPresentationReason),
        tostring(debugStatus.lastError)
    ))
end

local function runQuestDialoguePreview()
    local dialogue =
        Logres:GetModule("QuestDialogue")
    local ok, state =
        dialogue:ShowPreview()

    emit(string.format(
        "Logres questdialoguepreview: %s (state=%s)",
        ok and "PASS" or "FAIL",
        tostring(state)
    ))
end

local function runWaypointProbe()
    if type(LogresWaypointAudit_Run) ~= "function" then
        emit(
            "Logres waypointprobe: FAIL "
            .. "(LogresWaypointAudit addon unavailable)"
        )
        return
    end

    local ok, probeError = pcall(
        LogresWaypointAudit_Run,
        emit
    )

    if not ok then
        emit(
            "Logres waypointprobe: FAIL (error="
            .. tostring(probeError)
            .. ")"
        )
    end
end

local function runQuestProbe()
    if type(LogresQuestAudit_Run) ~= "function" then
        emit(
            "Logres questprobe: FAIL "
            .. "(LogresQuestAudit addon unavailable)"
        )
        return
    end

    local ok, probeError = pcall(
        LogresQuestAudit_Run,
        emit
    )

    if not ok then
        emit(
            "Logres questprobe: FAIL (error="
            .. tostring(probeError)
            .. ")"
        )
    end
end

local function runAllChecks()
    emit("Logres checkall: beginning")
    printStatus()
    runStateCheck()
    runSensorCheck()
    runPreferenceCheck()
    runLifecycleCheck()
    runHUDCheck()
    runXPCheck()
    runQuestDialogueCheck()
    runActionCheck()
    runStockReplacementCheck()
    runImmersionCheck()
    runQuietModeCheck()
    runPlayerFrameCheck()
    runTargetFrameCheck()
    runRestorationCheck()
    runContextPolicyCheck()
    runCompassCheck()
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
    emit("  /logres restorationcheck")
    emit("  /logres contextpolicycheck")
    emit("  /logres compasscheck")
    emit("  /logres waypointprobe")
    emit("  /logres questprobe")
    emit("  /logres xpcheck")
    emit("  /logres xppreview")
    emit("  /logres questdialoguecheck")
    emit("  /logres questdialoguepreview")
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

    if command == "restorationcheck" then
        runRestorationCheck()
        return
    end

    if command == "contextpolicycheck" then
        runContextPolicyCheck()
        return
    end

    if command == "compasscheck" then
        runCompassCheck()
        return
    end

    if command == "waypointprobe" then
        runWaypointProbe()
        return
    end

    if command == "questprobe" then
        runQuestProbe()
        return
    end

    if command == "xpcheck" then
        runXPCheck()
        return
    end

    if command == "xppreview" then
        runXPPreview()
        return
    end

    if command == "questdialoguecheck" then
        runQuestDialogueCheck()
        return
    end

    if command == "questdialoguepreview" then
        runQuestDialoguePreview()
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
    "restorationCheck",
    "Restoration Check",
    "restorationcheck"
)
Logres:RegisterDevPanelAction(
    "contextPolicyCheck",
    "Context Policy Check",
    "contextpolicycheck"
)
Logres:RegisterDevPanelAction(
    "compassCheck",
    "Compass Check",
    "compasscheck"
)
Logres:RegisterDevPanelAction(
    "waypointProbe",
    "Waypoint Probe",
    "waypointprobe"
)
Logres:RegisterDevPanelAction(
    "questProbe",
    "Quest Probe",
    "questprobe"
)
Logres:RegisterDevPanelAction(
    "xpCheck",
    "XP Check",
    "xpcheck"
)
Logres:RegisterDevPanelAction(
    "xpPreview",
    "XP Preview",
    "xppreview"
)
Logres:RegisterDevPanelAction(
    "questDialogueCheck",
    "Quest Dialogue Check",
    "questdialoguecheck"
)
Logres:RegisterDevPanelAction(
    "questDialoguePreview",
    "Quest Dialogue Preview",
    "questdialoguepreview"
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
