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

local VALID_DEV_PANEL_PHASES = {
    ["0"] = true,
    A = true,
    B = true,
    C = true,
    D = true,
    E = true,
    F = true,
    G = true,
    H = true,
}

function Logres:RegisterDevPanelAction(id, label, command, phase)
    if type(id) ~= "string" or id == "" then
        error("Logres:RegisterDevPanelAction requires a non-empty id")
    end

    if type(label) ~= "string" or label == "" then
        error("Logres:RegisterDevPanelAction requires a non-empty label")
    end

    if type(command) ~= "string" or command == "" then
        error("Logres:RegisterDevPanelAction requires a non-empty command")
    end

    if type(phase) ~= "string" or not VALID_DEV_PANEL_PHASES[phase] then
        error("Logres:RegisterDevPanelAction requires roadmap phase 0/A/B/C/D/E/F/G/H")
    end

    if devPanelActionsByID[id] then
        error("Duplicate Logres dev-panel action: " .. id)
    end

    local action = {
        id = id,
        label = label,
        command = command,
        phase = phase,
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
            phase = action.phase,
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
        "Logres preferences: schema=%s revision=%s immersionEnabled=%s activeQuestEnabled=%s",
        tostring(Logres.db and Logres.db.schema or "?"),
        tostring(preferences.revision),
        boolText(preferences.immersionEnabled),
        boolText(preferences.activeQuestEnabled)
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
        and debugStatus.bandCount == 5
        and debugStatus.textureCount == 5
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
            "Logres hudcheck: PASS (bands=5 textures=5 tunnel=true curves=true resourceText=true resourceCurve=true target=true casts=true allies=5 immersion=%s visible=%s)",
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
    local bar4 = sideDebug.bar4
    local bar5 = sideDebug.bar5

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
        and bar4.registeredCount == 12
        and bar4.activationFeedbackReadyCount == 12
        and bar4.firstActionSlot == 25
        and bar4.lastActionSlot == 36
        and bar5.registeredCount == 12
        and bar5.activationFeedbackReadyCount == 12
        and bar5.firstActionSlot == 37
        and bar5.lastActionSlot == 48
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
        emit(string.format(
            "Logres action extras: Bar4 25-36 shown=%s routing=%s keys=%s Bar5 37-48 shown=%s routing=%s keys=%s",
            boolText(bar4.shown),
            boolText(bar4.bindingRoutingEnabled),
            tostring(bar4.boundButtonCount),
            boolText(bar5.shown),
            boolText(bar5.bindingRoutingEnabled),
            tostring(bar5.boundButtonCount)
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


-- P0173 deliberately reports a capability gate, not a replacement PASS.
local function runPrimaryOwnershipCheck()
    local moduleStatus = Logres:GetModuleStatus("PrimaryActions")
    local primary = Logres:GetModule("PrimaryActions")
    local result = primary:GetStockOwnershipGate()
    local measured = moduleStatus.initialized == true
        and moduleStatus.enabled == true
        and result.sourcePresent
        and result.stockButtons == 12
        and result.flagsUnresolved == 0
    local classification = measured and "PASS" or "DEFERRED"
    emit(string.format(
        "Logres primaryownershipcheck: %s (normal=%s special=%s stock=%s buttons=%s flags=%s/%s route=%s paging=%s candidate=%s suppressAuthorized=false stockPreserved=true reason=%s)",
        classification,
        tostring(result.normalMode), tostring(result.specialActive),
        tostring(result.sourcePresent), tostring(result.stockButtons),
        tostring(result.flagsTotal - result.flagsUnresolved),
        tostring(result.flagsTotal), tostring(result.routingReady),
        tostring(result.securePagingReady),
        tostring(result.candidateNormal), tostring(result.status)
    ))
    emit("Logres primaryownership modes: " .. result.flagDetails)
end

local function runStockReplacementCheck()
    local status =
        Logres:GetModuleStatus("StockActionReplacement")
    local replacement =
        Logres:GetModule("StockActionReplacement")
    local debugStatus = replacement:GetDebugStatus()

    local expectedEnabled =
        Logres:GetPreference("immersionEnabled") == true
    local lifecycleConsistent =
        debugStatus.requestedEnabled == expectedEnabled
        and debugStatus.appliedEnabled == expectedEnabled
        and debugStatus.pending == false
        and debugStatus.lastError == nil
        and debugStatus.snapshotReady == expectedEnabled

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
            and debugStatus.bar4Alpha == 0
            and debugStatus.bar5Alpha == 0
            and debugStatus.bar4FrameMouseEnabled == false
            and debugStatus.bar5FrameMouseEnabled == false
            and debugStatus.bar4ButtonMouseEnabledCount == 0
            and debugStatus.bar5ButtonMouseEnabledCount == 0
            and debugStatus.bar4RoutingEnabled == true
            and debugStatus.bar4BindingsApplied == true
            and debugStatus.bar5RoutingEnabled == true
            and debugStatus.bar5BindingsApplied == true
    end

    local passed =
        status.initialized == true
        and status.enabled == true
        and debugStatus.moduleEnabled == true
        and debugStatus.secondaryFrameFound == true
        and debugStatus.utilityFrameFound == true
        and debugStatus.bar4FrameFound == true
        and debugStatus.bar5FrameFound == true
        and debugStatus.mainActionBarSuppressed == false
        and debugStatus.unsupportedBarsSuppressed == false
        and lifecycleConsistent
        and appliedConsistent

    if passed then
        emit(string.format(
            "Logres stockreplacecheck: PASS (expected=%s requested=%s applied=%s pending=%s bar2Alpha=%s bar2Mouse=%s/%s bar3Alpha=%s bar3Mouse=%s/%s secondaryRouting=%s/%s utilityRouting=%s/%s error=%s)",
            boolText(expectedEnabled),
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
        emit(string.format(
            "Logres stockreplacecheck extras: bar4 alpha=%s mouse=%s/%s route=%s/%s bar5 alpha=%s mouse=%s/%s route=%s/%s",
            tostring(debugStatus.bar4Alpha),
            boolText(debugStatus.bar4FrameMouseEnabled),
            tostring(debugStatus.bar4ButtonMouseEnabledCount),
            boolText(debugStatus.bar4RoutingEnabled),
            boolText(debugStatus.bar4BindingsApplied),
            tostring(debugStatus.bar5Alpha),
            boolText(debugStatus.bar5FrameMouseEnabled),
            tostring(debugStatus.bar5ButtonMouseEnabledCount),
            boolText(debugStatus.bar5RoutingEnabled),
            boolText(debugStatus.bar5BindingsApplied)
        ))
        emit(string.format(
            "Logres stockreplacecheck startup: deferrals=%s retries=%s lastEvent=%s",
            tostring(debugStatus.sourceDeferrals),
            tostring(debugStatus.retryCount),
            tostring(debugStatus.lastRetryEvent)
        ))
        return
    end

    emit(string.format(
        "Logres stockreplacecheck: FAIL (initialized=%s enabled=%s expected=%s requested=%s applied=%s pending=%s frames=%s/%s alphas=%s/%s frameMouse=%s/%s buttonMouse=%s/%s routing=%s/%s/%s/%s error=%s)",
        tostring(status.initialized),
        tostring(status.enabled),
        tostring(expectedEnabled),
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
    emit(string.format(
        "Logres stockreplacecheck startup: deferrals=%s retries=%s lastEvent=%s",
        tostring(debugStatus.sourceDeferrals),
        tostring(debugStatus.retryCount),
        tostring(debugStatus.lastRetryEvent)
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
                .. " applied for Bars 2-5."
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
            and debugStatus.suppressedContextCount == 9
            and debugStatus.contextualSuppressedCount == 9
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
            and debugStatus.contextualSuppressedCount == 0
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
            "Logres targetframecheck: PASS (expected=%s applied=%s pending=%s frame=%s container=%s main=%s contextual=%s stockPresentation=%s stockMouseSuppressed=%s contextualSuppressed=%s preserved=%s interactionReady=%s configured=%s watch=%s mouseOwned=%s unit=%s types=%s/%s wholeFrame=false tot=false focus=false boss=false party=false reason=%s)",
            boolText(expected),
            boolText(debugStatus.appliedEnabled),
            boolText(debugStatus.pending),
            boolText(debugStatus.targetFrameFound),
            boolText(debugStatus.containerFound),
            boolText(debugStatus.contentMainFound),
            boolText(debugStatus.contextualFound),
            boolText(debugStatus.stockPresentationSuppressed),
            boolText(debugStatus.stockMouseSuppressed),
            tostring(debugStatus.contextualSuppressedCount),
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
        "Logres targetframecheck: FAIL (initialized=%s enabled=%s moduleEnabled=%s expected=%s requested=%s applied=%s pending=%s stateMatches=%s presentationMatches=%s preservationSafe=%s frame=%s container=%s main=%s contextual=%s stockPresentation=%s stockMouseSuppressed=%s contextualSuppressed=%s preserved=%s interactionReady=%s configured=%s watch=%s mouseOwned=%s unit=%s types=%s/%s snapshot=%s wholeFrame=%s tot=%s focus=%s boss=%s party=%s reason=%s error=%s)",
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
        tostring(debugStatus.contextualSuppressedCount),
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

    local targetSuppressedExpected =
        target.appliedEnabled and 9 or 0

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
        and target.contextualSuppressedCount
            == targetSuppressedExpected
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
        "expected=%s quietExpected=%s modules=%s desired=%s recovery=%s ownership=%s errors=%s controller=%s/%s/%s/%s action=%s/%s/%s snap=%s route=%s quiet=%s/%s snap=%s player=%s/%s/%s snap=%s interact=%s mouse=%s present=%s stockMouse=%s target=%s/%s/%s snap=%s watch=%s interact=%s mouse=%s present=%s stockMouse=%s contextualSuppressed=%s targetReason=%s targetError=%s controllerTargetResult=%s controllerTargetError=%s",
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
        tostring(target.contextualSuppressedCount),
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

    local waypointDistanceCoherent =
        debugStatus.waypointDistanceAPIAvailable == true
        and debugStatus.lastWaypointDistanceError == nil
        and (
            (
                debugStatus.waypointDistanceAvailable == true
                and type(debugStatus.waypointDistanceYards) == "number"
                and debugStatus.waypointDistanceYards >= 0
                and debugStatus.lastWaypointDistanceReason == "distance-available"
            )
            or (
                debugStatus.waypointDistanceAvailable == false
                and debugStatus.waypointDistanceYards == nil
            )
        )

    local depthBandCoherent =
        type(debugStatus.waypointDepthScale) == "number"
        and debugStatus.waypointDepthScale >= 0.70
        and debugStatus.waypointDepthScale <= 1.20
        and (
            (
                debugStatus.waypointDistanceAvailable == true
                and debugStatus.waypointViewRadiusAPIAvailable == true
                and debugStatus.waypointViewRadiusAvailable == true
                and type(debugStatus.waypointViewRadiusYards) == "number"
                and debugStatus.waypointViewRadiusYards > 0
                and type(debugStatus.waypointDistanceRadiusRatio) == "number"
                and debugStatus.waypointDistanceRadiusRatio >= 0
                and (
                    debugStatus.waypointDepthBand == "close"
                    or debugStatus.waypointDepthBand == "near"
                    or debugStatus.waypointDepthBand == "medium"
                    or debugStatus.waypointDepthBand == "far"
                )
                and debugStatus.lastWaypointDepthReason == "depth-available"
                and debugStatus.lastWaypointDepthError == nil
            )
            or (
                debugStatus.waypointDistanceAvailable == false
                and debugStatus.waypointViewRadiusAvailable == false
                and debugStatus.waypointViewRadiusYards == nil
                and debugStatus.waypointDistanceRadiusRatio == nil
                and debugStatus.waypointDepthBand == nil
                and debugStatus.waypointDepthScale == 1
            )
        )

    local waypointScaleCoherent =
        (
            debugStatus.waypointMarkerShown == false
            and debugStatus.waypointRenderScale == nil
        )
        or (
            debugStatus.waypointMarkerShown == true
            and type(debugStatus.waypointRenderScale) == "number"
            and debugStatus.waypointRenderScale >= 0.70
            and debugStatus.waypointRenderScale <= 1.28
        )

    local passed =
        status.initialized == true
        and status.enabled == true
        and debugStatus.moduleEnabled == true
        and debugStatus.rootReady == true
        and debugStatus.directionCount == 8
        and policyMatches
        and presentationMatches
        and waypointCoherent
        and waypointDistanceCoherent
        and depthBandCoherent
        and waypointScaleCoherent
        and debugStatus.lastError == nil
        and debugStatus.lastWaypointError == nil

    local function numberText(value, format)
        if type(value) == "number" then
            return string.format(format, value)
        end
        return "nil"
    end

    local headingText = numberText(debugStatus.headingDegrees, "%.1f")
    local waypointBearingText = numberText(debugStatus.waypointBearingDegrees, "%.1f")
    local waypointRelativeText = numberText(debugStatus.waypointRelativeDegrees, "%.1f")
    local waypointDistanceText = numberText(debugStatus.waypointDistanceYards, "%.1f")
    local waypointRadiusText = numberText(debugStatus.waypointViewRadiusYards, "%.1f")
    local waypointRatioText = numberText(debugStatus.waypointDistanceRadiusRatio, "%.2f")
    local waypointDepthText = numberText(debugStatus.waypointDepthScale, "%.3f")
    local waypointRenderText = numberText(debugStatus.waypointRenderScale, "%.3f")

    if passed then
        emit(string.format(
            "Logres compasscheck: PASS (immersion=%s context=%s policy=%s facing=%s update=%s active=%s heading=%s waypointAPI=%s event=%s waypoint=%s bearing=%s relative=%s marker=%s distanceAPI=%s distance=%s yards=%s radiusAPI=%s radiusAvailable=%s radius=%s ratio=%s band=%s depth=%s renderScale=%s distanceReason=%s depthReason=%s waypointReason=%s reason=%s)",
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
            boolText(debugStatus.waypointDistanceAPIAvailable),
            boolText(debugStatus.waypointDistanceAvailable),
            waypointDistanceText,
            boolText(debugStatus.waypointViewRadiusAPIAvailable),
            boolText(debugStatus.waypointViewRadiusAvailable),
            waypointRadiusText,
            waypointRatioText,
            tostring(debugStatus.waypointDepthBand),
            waypointDepthText,
            waypointRenderText,
            tostring(debugStatus.lastWaypointDistanceReason),
            tostring(debugStatus.lastWaypointDepthReason),
            tostring(debugStatus.lastWaypointReason),
            tostring(debugStatus.lastReason)
        ))
        return
    end

    emit(string.format(
        "Logres compasscheck: FAIL (initialized=%s enabled=%s policyMatches=%s presentationMatches=%s waypointCoherent=%s distanceCoherent=%s depthBandCoherent=%s scaleCoherent=%s waypoint=%s marker=%s yards=%s radiusAPI=%s radiusAvailable=%s radius=%s ratio=%s band=%s depth=%s renderScale=%s distanceReason=%s distanceError=%s depthReason=%s depthError=%s waypointReason=%s waypointError=%s reason=%s error=%s)",
        tostring(status.initialized),
        tostring(status.enabled),
        tostring(policyMatches),
        tostring(presentationMatches),
        tostring(waypointCoherent),
        tostring(waypointDistanceCoherent),
        tostring(depthBandCoherent),
        tostring(waypointScaleCoherent),
        tostring(debugStatus.waypointSourcePresent),
        tostring(debugStatus.waypointMarkerShown),
        waypointDistanceText,
        tostring(debugStatus.waypointViewRadiusAPIAvailable),
        tostring(debugStatus.waypointViewRadiusAvailable),
        waypointRadiusText,
        waypointRatioText,
        tostring(debugStatus.waypointDepthBand),
        waypointDepthText,
        waypointRenderText,
        tostring(debugStatus.lastWaypointDistanceReason),
        tostring(debugStatus.lastWaypointDistanceError),
        tostring(debugStatus.lastWaypointDepthReason),
        tostring(debugStatus.lastWaypointDepthError),
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

local function runObjectiveProgressCheck()
    local status =
        Logres:GetModuleStatus("QuestObjectiveProgress")
    local progress =
        Logres:GetModule("QuestObjectiveProgress")
    local debugStatus = progress:GetDebugStatus()

    local identityAPIAvailable =
        debugStatus.superTrackedAPIAvailable == true
        or debugStatus.selectedQuestAPIAvailable == true

    local baselineCoherent =
        (
            debugStatus.currentQuestID == nil
            and debugStatus.baselineRowCount == 0
        )
        or (
            type(debugStatus.currentQuestID) == "number"
            and debugStatus.currentQuestID > 0
            and type(debugStatus.baselineRowCount) == "number"
            and debugStatus.baselineRowCount >= 0
        )

    local policyCoherent =
        debugStatus.immersionEnabled == true
        or debugStatus.pulseShown == false

    local passed =
        status.initialized == true
        and status.enabled == true
        and debugStatus.moduleEnabled == true
        and debugStatus.rootReady == true
        and debugStatus.textReady == true
        and debugStatus.eventFrameReady == true
        and debugStatus.timerAvailable == true
        and debugStatus.objectiveAPIAvailable == true
        and identityAPIAvailable
        and debugStatus.questLogEventRegistered == true
        and debugStatus.questWatchEventRegistered == true
        and debugStatus.superTrackingEventRegistered == true
        and debugStatus.worldEventRegistered == true
        and baselineCoherent
        and policyCoherent
        and debugStatus.lastError == nil

    emit(string.format(
        "Logres objectiveprogresscheck: %s (initialized=%s enabled=%s module=%s immersion=%s api=%s identityAPI=%s timer=%s events=%s/%s/%s/%s eventCounts=%s/%s/%s/%s baselines=%s changes=%s pulses=%s suppressed=%s previews=%s shown=%s questID=%s rows=%s secret=%s sampleReason=%s presentationReason=%s error=%s)",
        passed and "PASS" or "FAIL",
        tostring(status.initialized),
        tostring(status.enabled),
        tostring(debugStatus.moduleEnabled),
        tostring(debugStatus.immersionEnabled),
        tostring(debugStatus.objectiveAPIAvailable),
        tostring(identityAPIAvailable),
        tostring(debugStatus.timerAvailable),
        tostring(debugStatus.questLogEventRegistered),
        tostring(debugStatus.questWatchEventRegistered),
        tostring(debugStatus.superTrackingEventRegistered),
        tostring(debugStatus.worldEventRegistered),
        tostring(debugStatus.questLogEventCount),
        tostring(debugStatus.questWatchEventCount),
        tostring(debugStatus.superTrackingEventCount),
        tostring(debugStatus.worldEventCount),
        tostring(debugStatus.baselineCaptureCount),
        tostring(debugStatus.meaningfulChangeCount),
        tostring(debugStatus.pulseCount),
        tostring(debugStatus.suppressedCount),
        tostring(debugStatus.previewCount),
        tostring(debugStatus.pulseShown),
        tostring(debugStatus.currentQuestID),
        tostring(debugStatus.baselineRowCount),
        tostring(debugStatus.lastSecret),
        tostring(debugStatus.lastSampleReason),
        tostring(debugStatus.lastPresentationReason),
        tostring(debugStatus.lastError)
    ))
end

local function runObjectiveProgressPreview()
    local progress =
        Logres:GetModule("QuestObjectiveProgress")
    local ok, state =
        progress:ShowPreview()

    emit(string.format(
        "Logres objectiveprogresspreview: %s (state=%s)",
        ok and "PASS" or "FAIL",
        tostring(state)
    ))
end

local function runActiveQuestCheck()
    local status =
        Logres:GetModuleStatus("ActiveQuest")
    local active =
        Logres:GetModule("ActiveQuest")

    local refreshOK, refreshState =
        active:Refresh("diagnostic-check")
    local debugStatus = active:GetDebugStatus()

    local policyCoherent =
        (
            debugStatus.immersionEnabled == true
            and debugStatus.activeQuestEnabled == true
        )
        or debugStatus.presentationShown == false

    local sourceCoherent =
        debugStatus.lastQuestID == nil
        or (
            type(debugStatus.lastQuestID) == "number"
            and debugStatus.lastQuestID > 0
            and debugStatus.lastTitleReady == true
            and type(debugStatus.lastRowCount) == "number"
            and debugStatus.lastRowCount >= 0
        )

    local passed =
        refreshOK == true
        and status.initialized == true
        and status.enabled == true
        and debugStatus.moduleEnabled == true
        and debugStatus.rootReady == true
        and debugStatus.titleReady == true
        and debugStatus.ambientReady == true
        and debugStatus.rowsReady == true
        and debugStatus.eventFrameReady == true
        and debugStatus.titleAPIAvailable == true
        and debugStatus.completeAPIAvailable == true
        and debugStatus.readyAPIAvailable == true
        and debugStatus.tooltipAvailable == true
        and debugStatus.questLogEventRegistered == true
        and debugStatus.questWatchEventRegistered == true
        and debugStatus.questWatchListEventRegistered == true
        and debugStatus.superTrackingEventRegistered == true
        and debugStatus.worldEventRegistered == true
        and policyCoherent
        and sourceCoherent
        and debugStatus.lastSecret == false
        and debugStatus.lastError == nil

    emit(string.format(
        "Logres activequestcheck: %s (initialized=%s enabled=%s module=%s immersion=%s feature=%s preview=%s shown=%s titleAPI=%s completeAPI=%s readyAPI=%s tooltip=%s events=%s/%s/%s/%s/%s eventCounts=%s/%s/%s/%s/%s refreshes=%s presentations=%s previews=%s questID=%s source=%s rows=%s/%s complete=%s ready=%s secret=%s refreshState=%s reason=%s presentationReason=%s error=%s)",
        passed and "PASS" or "FAIL",
        tostring(status.initialized),
        tostring(status.enabled),
        tostring(debugStatus.moduleEnabled),
        tostring(debugStatus.immersionEnabled),
        tostring(debugStatus.activeQuestEnabled),
        tostring(debugStatus.previewMode),
        tostring(debugStatus.presentationShown),
        tostring(debugStatus.titleAPIAvailable),
        tostring(debugStatus.completeAPIAvailable),
        tostring(debugStatus.readyAPIAvailable),
        tostring(debugStatus.tooltipAvailable),
        tostring(debugStatus.questLogEventRegistered),
        tostring(debugStatus.questWatchEventRegistered),
        tostring(debugStatus.questWatchListEventRegistered),
        tostring(debugStatus.superTrackingEventRegistered),
        tostring(debugStatus.worldEventRegistered),
        tostring(debugStatus.questLogEventCount),
        tostring(debugStatus.questWatchEventCount),
        tostring(debugStatus.questWatchListEventCount),
        tostring(debugStatus.superTrackingEventCount),
        tostring(debugStatus.worldEventCount),
        tostring(debugStatus.refreshCount),
        tostring(debugStatus.presentationCount),
        tostring(debugStatus.previewCount),
        tostring(debugStatus.lastQuestID),
        tostring(debugStatus.lastSource),
        tostring(debugStatus.lastVisibleRowCount),
        tostring(debugStatus.lastRowCount),
        tostring(debugStatus.lastComplete),
        tostring(debugStatus.lastReady),
        tostring(debugStatus.lastSecret),
        tostring(refreshState),
        tostring(debugStatus.lastReason),
        tostring(debugStatus.lastPresentationReason),
        tostring(debugStatus.lastError)
    ))
end

local function runActiveQuestPreview(mode)
    local active = Logres:GetModule("ActiveQuest")
    local ok, state = active:SetPreviewMode(mode)

    emit(string.format(
        "Logres activequestpreview: %s (mode=%s state=%s)",
        ok and "PASS" or "FAIL",
        tostring(mode),
        tostring(state)
    ))
end

local function handleActiveQuest(argument)
    if argument == "" or argument == "status" then
        emit(string.format(
            "Logres: activeQuestEnabled=%s",
            boolText(Logres:GetPreference("activeQuestEnabled"))
        ))
        return
    end

    local current = Logres:GetPreference("activeQuestEnabled")
    local newValue

    if argument == "on" then
        newValue = true
    elseif argument == "off" then
        newValue = false
    elseif argument == "toggle" then
        newValue = not current
    else
        emit("Usage: /logres activequest [on|off|toggle]")
        return
    end

    local changed = Logres:SetPreference(
        "activeQuestEnabled",
        newValue,
        "COMMAND_ACTIVE_QUEST"
    )

    emit(string.format(
        "Logres: activeQuestEnabled=%s%s",
        boolText(newValue),
        changed and "" or " (unchanged)"
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

local function runQuestInteractionProbe()
    local status =
        Logres:GetModuleStatus("QuestInteractionProbe")
    local probe =
        Logres:GetModule("QuestInteractionProbe")

    local captureOK, captureState =
        probe:CaptureManual()
    local debugStatus =
        probe:GetDebugStatus()

    local passed =
        captureOK == true
        and status.initialized == true
        and status.enabled == true
        and debugStatus.moduleEnabled == true
        and debugStatus.eventFrameReady == true
        and debugStatus.gossipShowRegistered == true
        and debugStatus.gossipClosedRegistered == true
        and debugStatus.questDetailRegistered == true
        and debugStatus.questProgressRegistered == true
        and debugStatus.questCompleteRegistered == true
        and debugStatus.questFinishedRegistered == true
        and debugStatus.mutationCallCount == 0

    emit(string.format(
        "Logres questinteractionprobe: %s (capture=%s state=%s captures=%s manual=%s lastEvent=%s lastCapture=%s observed=gossip:%s detail:%s progress:%s complete:%s invoked=%s)",
        passed and "PASS" or "FAIL",
        tostring(captureOK),
        tostring(captureState),
        tostring(debugStatus.captureCount),
        tostring(debugStatus.manualCount),
        tostring(debugStatus.lastEvent),
        tostring(debugStatus.lastCaptureReason),
        tostring(debugStatus.gossipObserved),
        tostring(debugStatus.detailObserved),
        tostring(debugStatus.progressObserved),
        tostring(debugStatus.completeObserved),
        tostring(debugStatus.mutationCallCount)
    ))

    local lines = probe:GetDiagnosticLines()

    for index = 1, #lines do
        emit(
            "Logres questinteractionprobe: "
            .. tostring(lines[index])
        )
    end
end

local function runAuraStatusProbe()
    local status =
        Logres:GetModuleStatus("AuraStatusProbe")
    local probe =
        Logres:GetModule("AuraStatusProbe")
    local capture = probe:CaptureManual()
    local debugStatus = probe:GetDebugStatus()
    local captureOK = type(capture) == "table"

    local passed =
        status.initialized == true
        and status.enabled == true
        and debugStatus.moduleEnabled == true
        and captureOK
        and debugStatus.unitAuraRegistered == true
        and debugStatus.targetChangedRegistered == true
        and debugStatus.enteringWorldRegistered == true
        and debugStatus.secretCheckerAvailable == true
        and debugStatus.predicateAvailable == true
        and debugStatus.queryAvailable == true
        and debugStatus.unitExistsAvailable == true
        and debugStatus.failureCount == 0

    emit(string.format(
        "Logres aurastatusprobe: %s (capture=%s captures=%s manual=%s last=%s events=aura:%s target:%s world:%s api=secret:%s predicate:%s query:%s unitExists:%s ordinary=%s secretSkips=%s secretFields=%s failures=%s targetAvailable=%s)",
        passed and "PASS" or "FAIL",
        tostring(captureOK),
        tostring(debugStatus.captureCount),
        tostring(debugStatus.manualCount),
        tostring(debugStatus.lastReason),
        tostring(debugStatus.unitAuraEvents),
        tostring(debugStatus.targetChangedEvents),
        tostring(debugStatus.enteringWorldEvents),
        tostring(debugStatus.secretCheckerAvailable),
        tostring(debugStatus.predicateAvailable),
        tostring(debugStatus.queryAvailable),
        tostring(debugStatus.unitExistsAvailable),
        tostring(debugStatus.ordinaryAuraCount),
        tostring(debugStatus.secretSkipCount),
        tostring(debugStatus.secretFieldCount),
        tostring(debugStatus.failureCount),
        tostring(debugStatus.targetAvailable)
    ))

    local lines = probe:GetDiagnosticLines()

    for index = 1, #lines do
        emit(
            "Logres aurastatusprobe: "
            .. tostring(lines[index])
        )
    end
end

local function runWorldTargetProbe()
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

local function runNavigationSourceProbe()
    local status =
        Logres:GetModuleStatus("NavigationSourceProbe")
    local probe =
        Logres:GetModule("NavigationSourceProbe")
    local capture = probe:CaptureManual()
    local debugStatus = probe:GetDebugStatus()
    local captureOK = type(capture) == "table"

    local passed =
        captureOK
        and status.initialized == true
        and status.enabled == true
        and debugStatus.moduleEnabled == true
        and debugStatus.eventFrameReady == true
        and debugStatus.secretCheckerAvailable == true
        and debugStatus.requiredAPIReady == true
        and debugStatus.minimapTrackingRegistered == true
        and debugStatus.areaPoisRegistered == true
        and debugStatus.superTrackingRegistered == true
        and debugStatus.superTrackingPathRegistered == true
        and debugStatus.questLogRegistered == true
        and debugStatus.playerMapRegistered == true
        and debugStatus.enteringWorldRegistered == true
        and debugStatus.secretSkipCount == 0
        and debugStatus.failureCount == 0

    emit(string.format(
        "Logres navigationsourceprobe: %s (capture=%s captures=%s manual=%s last=%s events=tracking:%s poi:%s super:%s path:%s quest:%s map:%s world:%s api=secret:%s required:%s mapID=%s minimapMap=%s player=%s worldSize=%s viewRadius=%s tracking=%s/%s active=%s areaPOI=%s positioned=%s withinRadius=%s super=%s quest=%s userWaypoint=%s questID=%s navigation=%s questWaypoint=%s/%s secretSkips=%s failures=%s)",
        passed and "PASS" or "FAIL",
        tostring(captureOK),
        tostring(debugStatus.captureCount),
        tostring(debugStatus.manualCount),
        tostring(debugStatus.lastReason),
        tostring(debugStatus.minimapTrackingEvents),
        tostring(debugStatus.areaPoisEvents),
        tostring(debugStatus.superTrackingEvents),
        tostring(debugStatus.superTrackingPathEvents),
        tostring(debugStatus.questLogEvents),
        tostring(debugStatus.playerMapEvents),
        tostring(debugStatus.enteringWorldEvents),
        tostring(debugStatus.secretCheckerAvailable),
        tostring(debugStatus.requiredAPIReady),
        tostring(debugStatus.currentMapID),
        tostring(debugStatus.minimapMapID),
        tostring(debugStatus.playerPositionAvailable),
        tostring(debugStatus.mapWorldSizeAvailable),
        tostring(debugStatus.viewRadius),
        tostring(debugStatus.trackingCount),
        tostring(debugStatus.trackingScanned),
        tostring(debugStatus.trackingActive),
        tostring(debugStatus.areaPoiScanned),
        tostring(debugStatus.areaPoiOrdinary),
        tostring(debugStatus.areaPoiWithinRadius),
        tostring(debugStatus.superTrackingAnything),
        tostring(debugStatus.superTrackingQuest),
        tostring(debugStatus.superTrackingUserWaypoint),
        tostring(debugStatus.superTrackedQuestID),
        tostring(debugStatus.navigationAvailable),
        tostring(debugStatus.questWaypointAvailable),
        tostring(debugStatus.questWaypointForMapAvailable),
        tostring(debugStatus.secretSkipCount),
        tostring(debugStatus.failureCount)
    ))

    local lines = probe:GetDiagnosticLines()

    for index = 1, #lines do
        emit(
            "Logres navigationsourceprobe: "
            .. tostring(lines[index])
        )
    end
end

local function runClassPetSpecialProbe()
    local status =
        Logres:GetModuleStatus("ClassPetSpecialProbe")
    local probe =
        Logres:GetModule("ClassPetSpecialProbe")
    local capture = probe:CaptureManual()
    local debugStatus = probe:GetDebugStatus()
    local captureOK = type(capture) == "table"

    local passed =
        captureOK
        and status.initialized == true
        and status.enabled == true
        and debugStatus.moduleEnabled == true
        and debugStatus.eventFrameReady == true
        and debugStatus.secretCheckerAvailable == true
        and debugStatus.requiredAPIReady == true
        and debugStatus.eventRegistrationComplete == true
        and debugStatus.failureCount == 0

    emit(string.format(
        "Logres classpetspecialprobe: %s (capture=%s captures=%s manual=%s last=%s events=%s/%s api=secret:%s required:%s missing:%s ordinary=%s absent=%s secretSkips=%s failures=%s pet=%s/%s stance=%s/%s totems=%s/%s class=%s resource=%s runes=%s special=possess:%s vehicle:%s override:%s temp:%s extra:%s)",
        passed and "PASS" or "FAIL",
        tostring(captureOK),
        tostring(debugStatus.captureCount),
        tostring(debugStatus.manualCount),
        tostring(debugStatus.lastReason),
        tostring(debugStatus.registeredEventCount),
        tostring(debugStatus.expectedEventCount),
        tostring(debugStatus.secretCheckerAvailable),
        tostring(debugStatus.requiredAPIReady),
        tostring(debugStatus.missingAPI),
        tostring(debugStatus.ordinaryFieldCount),
        tostring(debugStatus.absentFieldCount),
        tostring(debugStatus.secretSkipCount),
        tostring(debugStatus.failureCount),
        tostring(debugStatus.petHasActionBar),
        tostring(debugStatus.petOccupied),
        tostring(debugStatus.stanceCount),
        tostring(debugStatus.stanceScanned),
        tostring(debugStatus.activeTotems),
        tostring(debugStatus.totemSlots),
        tostring(debugStatus.playerClass),
        tostring(debugStatus.selectedResource),
        tostring(debugStatus.runeScanned),
        tostring(debugStatus.possess),
        tostring(debugStatus.vehicle),
        tostring(debugStatus.override),
        tostring(debugStatus.tempShapeshift),
        tostring(debugStatus.extra)
    ))

    local lines = probe:GetDiagnosticLines()

    for index = 1, #lines do
        emit(
            "Logres classpetspecialprobe: "
            .. tostring(lines[index])
        )
    end
end

local function runPetActionExecutionProbe(argument)
    local status = Logres:GetModuleStatus("PetActionExecutionProbe")

    if not status.initialized then
        Logres:InitializeModule("PetActionExecutionProbe")
    end
    if not status.enabled then
        Logres:EnableModule("PetActionExecutionProbe")
    end

    local probe = Logres:GetModule("PetActionExecutionProbe")
    local action = argument
    if action == nil or action == "" then
        action = "check"
    end

    local actionOK = true
    local reason = action

    if action == "arm" then
        actionOK, reason = probe:Arm()
    elseif action == "check" then
        reason = probe:Check()
    elseif action == "hide" then
        actionOK, reason = probe:HideProbe()
    else
        emit("Usage: /logres petactionexecprobe [arm|check|hide]")
        return
    end

    local debugStatus = probe:GetDebugStatus()

    emit(string.format(
        "Logres petactionexecprobe: %s (action=%s ok=%s reason=%s configured=%s pending=%s armed=%s visible=%s petBar=%s occupied=%s attempts=%s clicks=%s slot=%s followup=%s lastEvent=%s pre=%s/%s post=%s/%s changed=%s secretSkips=%s failures=%s combat=%s)",
        tostring(debugStatus.result),
        tostring(action),
        tostring(actionOK),
        tostring(reason),
        tostring(debugStatus.configured),
        tostring(debugStatus.pendingConfigure),
        tostring(debugStatus.armed),
        tostring(debugStatus.visible),
        tostring(debugStatus.petHasActionBar),
        tostring(debugStatus.occupiedCount),
        tostring(debugStatus.attemptCount),
        tostring(debugStatus.clickCount),
        tostring(debugStatus.lastClickedSlot),
        tostring(debugStatus.followupEventCount),
        tostring(debugStatus.lastFollowupEvent),
        tostring(debugStatus.preActive),
        tostring(debugStatus.preActiveState),
        tostring(debugStatus.postActive),
        tostring(debugStatus.postActiveState),
        tostring(debugStatus.activeStateChanged),
        tostring(debugStatus.secretSkipCount),
        tostring(debugStatus.failureCount),
        tostring(debugStatus.combat)
    ))

    if action == "arm" and actionOK then
        emit(
            "Logres petactionexecprobe: shared Logres action buttons are live; "
            .. "LEFT CLICK executes the pet slot, RIGHT CLICK toggles autocast "
            .. "when supported. For secure proof, left-click one INACTIVE "
            .. "Follow/Stay-type slot, then run Check. Stock PetActionBar stays available."
        )
    end

    local lines = probe:GetDiagnosticLines()
    for index = 1, #lines do
        emit("Logres petactionexecprobe: " .. tostring(lines[index]))
    end
end

local function runStatusAuraCheck()
    local status = Logres:GetModuleStatus("StatusAuras")
    local module = Logres:GetModule("StatusAuras")
    module:Refresh("diagnostic-check")
    local d = module:GetDebugStatus()
    local preferences = Logres:GetPreferences()
    local shouldShow = preferences.immersionEnabled == true
    local coherent =
        d.playerShown == (shouldShow and d.playerVisible > 0)
        and d.targetShown == (shouldShow and d.targetVisible > 0)
        and d.targetHarmfulShown == (shouldShow and d.targetHarmfulVisible > 0)
        and d.targetHelpfulShown == (shouldShow and d.targetHelpfulVisible > 0)
    local targetEvidence = d.preview and "preview-only"
        or d.targetVisible > 0 and "live-populated"
        or "deferred-no-populated-target-aura"
    local harmfulEvidence = d.preview and "preview-only"
        or d.targetHarmfulVisible > 0 and "live-populated"
        or "deferred-no-populated-target-harmful"
    local playerEvidence = d.preview and "preview-only"
        or d.playerVisible > 0 and "live-populated"
        or "deferred-no-populated-player-harmful"
    local pass = status.initialized == true
        and status.enabled == true
        and d.enabled == true
        and d.source == true
        and d.eventsReady == true
        and d.failures == 0
        and d.stockPreserved == true
        and coherent
    emit(string.format(
        "Logres statusauracheck: %s (source=%s player=%s/%s/%s playerHarmfulEvidence=%s target=%s/%s/%s targetEvidence=%s targetHarmful=%s/%s targetHelpful=%s/%s harmfulEvidence=%s preview=%s secrets=%s/%s fields=%s/%s failures=%s duplicatesUnknown=%s refreshes=%s stock=%s reason=%s)",
        pass and "PASS" or "FAIL",
        tostring(d.source),
        tostring(d.playerVisible), tostring(d.playerShown), tostring(d.playerReason),
        tostring(playerEvidence),
        tostring(d.targetVisible), tostring(d.targetShown), tostring(d.targetReason),
        tostring(targetEvidence),
        tostring(d.targetHarmfulVisible), tostring(d.targetHarmfulShown),
        tostring(d.targetHelpfulVisible), tostring(d.targetHelpfulShown),
        tostring(harmfulEvidence), tostring(d.preview),
        tostring(d.playerSecret), tostring(d.targetSecret),
        tostring(d.playerFields), tostring(d.targetFields),
        tostring(d.failures), tostring(d.duplicatesUnknown),
        tostring(d.refreshes), tostring(d.stockPreserved), tostring(d.lastReason)
    ))
    -- Event-latched source evidence is intentionally distinct from preview PASS.
    emit(string.format(
        "Logres statusaura live history: playerHarmful max=%s positiveReads=%s last=%s targetHarmful max=%s positiveReads=%s last=%s targetHelpful max=%s positiveReads=%s last=%s scans=%s failures=%s secrets=%s (session-only, preview-excluded)",
        tostring(d.historyPlayerMax), tostring(d.historyPlayerPositive),
        tostring(d.historyPlayerReason),
        tostring(d.historyTargetHarmfulMax), tostring(d.historyTargetHarmfulPositive),
        tostring(d.historyTargetHarmfulReason),
        tostring(d.historyTargetHelpfulMax), tostring(d.historyTargetHelpfulPositive),
        tostring(d.historyTargetHelpfulReason),
        tostring(d.historyScans), tostring(d.historyFailures),
        tostring(d.historySecrets)
    ))
    -- Compare our independent source engine only on explicit Phase H/Run All
    -- checks, never while preview data is active. This does not render icons.
    if d.preview then
        emit("Logres aura source engine: DEFERRED (preview active)")
    elseif not shouldShow then
        emit("Logres aura source engine: DEFERRED (Immersion OFF)")
    else
        local comparison = Logres.AuraSourceEngine.Capture()
        if not comparison.ready then
            emit("Logres aura source engine: DEFERRED (" .. comparison.reason .. ")")
        else
            for _, source in ipairs(comparison.groups) do
                if source.reason ~= "scanned" then
                    emit("Logres aura source " .. source.key .. ": DEFERRED (" .. source.reason .. ")")
                else
                    local base, priority = source.base, source.priority
                    emit(string.format(
                        "Logres aura source %s: base ordinary=%s secret=%s failures=%s empty=%s inspected=%s priority ordinary=%s secret=%s failures=%s empty=%s inspected=%s (read-only)",
                        source.key,
                        tostring(base.ordinary), tostring(base.secret),
                        tostring(base.failures), tostring(base.empty),
                        tostring(base.inspected),
                        tostring(priority.ordinary), tostring(priority.secret),
                        tostring(priority.failures), tostring(priority.empty),
                        tostring(priority.inspected)
                    ))
                end
            end
        end
    end
end

local function runStatusAuraPreview(argument)
    local module = Logres:GetModule("StatusAuras")
    if argument == "on" then
        module:SetPreview(true)
    elseif argument == "off" or argument == "live" then
        module:SetPreview(false)
    else
        emit("Usage: /logres statusaurapreview [on|off]")
        return
    end
    runStatusAuraCheck()
end

local function runPlayerHelpfulAuraCheck()
    local status =
        Logres:GetModuleStatus("PlayerHelpfulAuras")
    local module =
        Logres:GetModule("PlayerHelpfulAuras")

    local refreshOK, refreshReason =
        module:Refresh("diagnostic-check")
    local debugStatus = module:GetDebugStatus()

    local expectedShown =
        debugStatus.immersionEnabled == true
        and debugStatus.visibleCount > 0

    local visibilityCoherent =
        debugStatus.rootShown == expectedShown
        and debugStatus.presentationShown
            == expectedShown

    local passed =
        status.initialized == true
        and status.enabled == true
        and debugStatus.moduleEnabled == true
        and debugStatus.rootReady == true
        and debugStatus.slotCount == 4
        and debugStatus.unitAuraRegistered == true
        and debugStatus.worldRegistered == true
        and debugStatus.sourceAvailable == true
        and refreshOK == true
        and debugStatus.failureCount == 0
        and visibilityCoherent

    emit(string.format(
        "Logres helpfulauracheck: %s (refresh=%s reason=%s root=%s expected=%s immersion=%s preview=%s slots=%s visible=%s shown=%s events=aura:%s world:%s source=%s filter=%s secretSkips=%s secretFields=%s failures=%s lastRefresh=%s presentation=%s error=%s)",
        passed and "PASS" or "FAIL",
        tostring(refreshOK),
        tostring(refreshReason),
        tostring(debugStatus.rootShown),
        tostring(expectedShown),
        tostring(debugStatus.immersionEnabled),
        tostring(debugStatus.previewEnabled),
        tostring(debugStatus.slotCount),
        tostring(debugStatus.visibleCount),
        tostring(debugStatus.presentationShown),
        tostring(debugStatus.unitAuraEvents),
        tostring(debugStatus.worldEvents),
        tostring(debugStatus.sourceAvailable),
        tostring(debugStatus.filter),
        tostring(debugStatus.secretSkipCount),
        tostring(debugStatus.secretFieldCount),
        tostring(debugStatus.failureCount),
        tostring(debugStatus.lastRefreshReason),
        tostring(debugStatus.lastPresentationReason),
        tostring(debugStatus.lastError)
    ))
end

local function runPlayerHelpfulAuraPreview(argument)
    local module =
        Logres:GetModule("PlayerHelpfulAuras")
    local debugBefore = module:GetDebugStatus()

    local enabled

    if argument == "" then
        enabled = not debugBefore.previewEnabled
    elseif argument == "on" then
        enabled = true
    elseif argument == "off" then
        enabled = false
    else
        emit(
            "Logres helpfulaurapreview: FAIL "
            .. "(expected on/off)"
        )
        return
    end

    local ok, reason =
        module:SetPreviewEnabled(enabled)
    local debugAfter = module:GetDebugStatus()

    local expectedShown =
        debugAfter.immersionEnabled == true
        and (
            debugAfter.previewEnabled == true
            or debugAfter.visibleCount > 0
        )

    local passed =
        ok == true
        and debugAfter.failureCount == 0
        and (
            debugAfter.previewEnabled ~= true
            or debugAfter.visibleCount == 4
        )
        and debugAfter.rootShown
            == expectedShown

    emit(string.format(
        "Logres helpfulaurapreview: %s (enabled=%s reason=%s root=%s visible=%s previews=%s failures=%s)",
        passed and "PASS" or "FAIL",
        tostring(debugAfter.previewEnabled),
        tostring(reason),
        tostring(debugAfter.rootShown),
        tostring(debugAfter.visibleCount),
        tostring(debugAfter.previewCount),
        tostring(debugAfter.failureCount)
    ))
end

local function runQuestOfferControlsCheck()
    local status =
        Logres:GetModuleStatus("QuestDialogue")
    local dialogue =
        Logres:GetModule("QuestDialogue")
    local debugStatus =
        dialogue:GetDebugStatus()
    local probe =
        Logres:GetModule("QuestOfferActionProbe")
    local probeDebug =
        probe:GetDebugStatus()

    local finalPage =
        debugStatus.pageCount <= 1
        or debugStatus.currentPage
            == debugStatus.pageCount

    local expectedShown =
        debugStatus.presentationShown
        and debugStatus.offerActionsEnabled
        and finalPage

    local visibilityCoherent =
        debugStatus.offerControlsShown
        == expectedShown

    local productionResultCoherent =
        probeDebug.lastActionSource
            ~= "production"
        or probeDebug.lastActionReported == true

    local passed =
        status.initialized == true
        and status.enabled == true
        and debugStatus.moduleEnabled == true
        and debugStatus.offerControlsReady == true
        and visibilityCoherent
        and productionResultCoherent
        and debugStatus.lastOfferActionError == nil

    emit(string.format(
        "Logres questoffercontrolscheck: %s (ready=%s shown=%s expectedShown=%s finalPage=%s preview=%s pending=%s clicks=%s lastKind=%s lastResult=%s lastError=%s probeSource=%s probeState=%s probeEvent=%s probeIdentity=%s probeCallOK=%s finishedObserved=%s probeReported=%s probeSuccess=%s probeError=%s)",
        passed and "PASS" or "FAIL",
        tostring(debugStatus.offerControlsReady),
        tostring(debugStatus.offerControlsShown),
        tostring(expectedShown),
        tostring(debugStatus.offerControlsFinalPage),
        tostring(debugStatus.offerActionPreview),
        tostring(debugStatus.offerActionPending),
        tostring(debugStatus.offerActionClickCount),
        tostring(debugStatus.lastOfferActionKind),
        tostring(debugStatus.lastOfferActionResult),
        tostring(debugStatus.lastOfferActionError),
        tostring(probeDebug.lastActionSource),
        tostring(probeDebug.lastActionState),
        tostring(probeDebug.lastActionEvent),
        tostring(probeDebug.lastActionEventIdentityState),
        tostring(probeDebug.lastActionCallOK),
        tostring(probeDebug.lastActionFinishedObserved),
        tostring(probeDebug.lastActionReported),
        tostring(probeDebug.lastActionSuccess),
        tostring(probeDebug.lastActionError)
    ))
end

local function runQuestOfferStockSuppressionCheck()
    local status =
        Logres:GetModuleStatus("QuestOfferStockSuppression")
    local suppression =
        Logres:GetModule("QuestOfferStockSuppression")
    local debugStatus =
        suppression:GetDebugStatus()
    local dialogue =
        Logres:GetModule("QuestDialogue")
    local dialogueDebug =
        dialogue:GetDebugStatus()

    local productionEligible =
        dialogueDebug.presentationShown == true
        and dialogueDebug.offerActionsEnabled == true
        and dialogueDebug.offerActionPreview ~= true

    local supportedOwnershipExpected =
        productionEligible
        and debugStatus.lastSupportReason == "supported"

    local ownershipCoherent =
        (debugStatus.appliedEnabled ~= true
            and debugStatus.snapshotReady ~= true)
        or (
            debugStatus.appliedEnabled == true
            and debugStatus.requestedEnabled == true
            and debugStatus.snapshotReady == true
        )

    local passed =
        status.initialized == true
        and status.enabled == true
        and debugStatus.moduleEnabled == true
        and debugStatus.sourceCommit
            == "15666a6e67938a1ab5caf041406464251db111ca"
        and debugStatus.failureCount == 0
        and debugStatus.lastError == nil
        and ownershipCoherent
        and (
            not supportedOwnershipExpected
            or debugStatus.appliedEnabled == true
        )

    emit(string.format(
        "Logres questofferstocksuppressioncheck: %s (source=%s requested=%s applied=%s pending=%s snapshot=%s detailHooked=%s accept=%s decline=%s support=%s apply=%s restore=%s unsupported=%s secrets=%s failures=%s emergency=%s reason=%s error=%s)",
        passed and "PASS" or "FAIL",
        tostring(debugStatus.sourceCommit),
        tostring(debugStatus.requestedEnabled),
        tostring(debugStatus.appliedEnabled),
        tostring(debugStatus.pending),
        tostring(debugStatus.snapshotReady),
        tostring(debugStatus.detailHooked),
        tostring(debugStatus.acceptFound),
        tostring(debugStatus.declineFound),
        tostring(debugStatus.lastSupportReason),
        tostring(debugStatus.applyCount),
        tostring(debugStatus.restoreCount),
        tostring(debugStatus.unsupportedCount),
        tostring(debugStatus.secretBlockCount),
        tostring(debugStatus.failureCount),
        tostring(debugStatus.emergencyRestoreCount),
        tostring(debugStatus.lastReason),
        tostring(debugStatus.lastError)
    ))
    emit(string.format(
        "Logres quest offer presentation: owned=%s capturedFrames=%s (QuestFrame remains shown; stock mouse subtree disabled only for supported ordinary offers)",
        tostring(debugStatus.visualOwned),
        tostring(debugStatus.visualFrameCount)
    ))
end

local function runQuestOfferActionProbe(kind)
    local probe =
        Logres:GetModule("QuestOfferActionProbe")
    local mode, reason =
        probe:HandlePanelAction(kind)
    local debugStatus =
        probe:GetDebugStatus()

    if mode == "started" then
        emit(string.format(
            "Logres questoffer%sprobe: STARTED (questID=%s title=%s attempts=%s mutationCalls=%s state=%s; click the same action again after the quest event resolves)",
            tostring(kind),
            tostring(debugStatus.lastActionQuestID),
            tostring(debugStatus.lastActionTitle),
            tostring(debugStatus.actionAttemptCount),
            tostring(debugStatus.mutationCallCount),
            tostring(debugStatus.lastActionState)
        ))
        return
    end

    if mode == "pending" then
        emit(string.format(
            "Logres questoffer%sprobe: PENDING (kind=%s questID=%s state=%s event=%s error=%s)",
            tostring(kind),
            tostring(debugStatus.pendingKind),
            tostring(debugStatus.lastActionQuestID),
            tostring(debugStatus.pendingState),
            tostring(debugStatus.lastActionEvent),
            tostring(debugStatus.lastActionError)
        ))
        return
    end

    if mode == "blocked" then
        emit(string.format(
            "Logres questoffer%sprobe: BLOCKED (reason=%s offerOpen=%s currentQuestID=%s pending=%s/%s attempts=%s mutationCalls=%s secret=%s error=%s)",
            tostring(kind),
            tostring(reason),
            tostring(debugStatus.offerOpen),
            tostring(debugStatus.currentQuestID),
            tostring(debugStatus.pendingKind),
            tostring(debugStatus.pendingState),
            tostring(debugStatus.actionAttemptCount),
            tostring(debugStatus.mutationCallCount),
            tostring(debugStatus.lastSecret),
            tostring(debugStatus.lastError)
        ))
        return
    end

    local passed =
        mode == "result"
        and debugStatus.lastActionKind == kind
        and debugStatus.lastActionState == "event-confirmed"
        and debugStatus.lastActionSuccess == true
        and debugStatus.lastActionCallOK == true
        and debugStatus.lastActionEventSecret == false

    emit(string.format(
        "Logres questoffer%sprobe: %s (questID=%s title=%s callOK=%s event=%s eventIdentity=%s state=%s finishedObserved=%s attempts=%s accept=%s decline=%s mutationCalls=%s success=%s failure=%s secret=%s error=%s)",
        tostring(kind),
        passed and "PASS" or "FAIL",
        tostring(debugStatus.lastActionQuestID),
        tostring(debugStatus.lastActionTitle),
        tostring(debugStatus.lastActionCallOK),
        tostring(debugStatus.lastActionEvent),
        tostring(debugStatus.lastActionEventIdentityState),
        tostring(debugStatus.lastActionState),
        tostring(debugStatus.lastActionFinishedObserved),
        tostring(debugStatus.actionAttemptCount),
        tostring(debugStatus.acceptAttemptCount),
        tostring(debugStatus.declineAttemptCount),
        tostring(debugStatus.mutationCallCount),
        tostring(debugStatus.successCount),
        tostring(debugStatus.failureCount),
        tostring(debugStatus.lastActionEventSecret),
        tostring(debugStatus.lastActionError)
    ))

    probe:MarkReported(kind)
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

local function cameraWorldCombatStatusPasses(status)
    local coexistenceSafe =
        status.lastDynamicCamStatusKnown == true
        and (
            status.lastDynamicCamLoaded ~= true
            or (
                status.ownsContext == false
                and status.transitionActive == false
            )
        )

    local ownedContext =
        status.selectedContext == "world"
        or status.selectedContext == "city"
        or status.selectedContext == "combat"
        or status.selectedContext == "taxi"
        or status.selectedContext == "teleport"
        or status.selectedContext == "afk"
        or status.selectedContext == "gathering"
        or status.selectedContext == "interaction"
        or status.selectedContext == "fishing"

    local ownershipCoherent =
        (status.selectedContext == "none" and status.ownsContext == false)
        or (ownedContext and status.ownsContext == true)

    local transitionContext =
        status.transitionContext == "world"
        or status.transitionContext == "city"
        or status.transitionContext == "combat"
        or status.transitionContext == "taxi"
        or status.transitionContext == "teleport"
        or status.transitionContext == "gathering"
        or status.transitionContext == "interaction"
        or status.transitionContext == "fishing"
        or status.transitionContext == "reactive"

    local transitionCoherent =
        status.transitionActive ~= true or transitionContext

    local profileHealthy =
        (status.profileReadFailures or 0) == 0
        and status.lastProfileError == nil

    local reactive = status.reactiveZoom
    local reactiveHealthy =
        reactive ~= nil
        and (reactive.failureCount or 0) == 0
        and (reactive.secretSkipCount or 0) == 0
        and reactive.lastError == nil
        and (
            (
                status.ownsContext == true
                and reactive.active == true
                and reactive.hooked == true
                and reactive.lastHookConflict ~= true
            )
            or (
                status.ownsContext == false
                and reactive.active == false
            )
        )

    local behavior = status.profileBehavior
    local behaviorHealthy =
        behavior ~= nil
        and (behavior.settingsFailureCount or 0) == 0
        and (behavior.rotationFailureCount or 0) == 0
        and behavior.lastSettingsError == nil
        and behavior.lastRotationError == nil
        and (
            (
                status.ownsContext == true
                and behavior.active == true
            )
            or (
                status.ownsContext == false
                and behavior.active == false
            )
        )

    return
        status.moduleEnabled == true
        and status.apiAvailable == true
        and status.lastSecret == false
        and status.lastError == nil
        and coexistenceSafe
        and ownershipCoherent
        and transitionCoherent
        and profileHealthy
        and reactiveHealthy
        and behaviorHealthy
end

local function emitCameraWorldCombatStatus(prefix, status, passed)
    emit(string.format(
        "Logres cameraworldcombat: %s (enabled=%s context=%s owns=%s transition=%s/%s action=%s reason=%s stop=%s blocked=%s liveCombat=%s lockdown=%s cachedCombat=%s mismatch=%s resting=%s dynamicCam=%s/%s api=%s current=%s start=%s requested=%s effective=%s duration=%s maxFactor=%s targetMaxFactor=%s maxCeiling=%s final=%s elapsed=%s targetReached=%s reconcile=%s starts=%s complete=%s stops=%s noop=%s blockedCount=%s relinquish=%s failures=%s secret=%s error=%s)",
        prefix or (passed and "PASS" or "FAIL"),
        tostring(status.moduleEnabled),
        tostring(status.selectedContext),
        tostring(status.ownsContext),
        tostring(status.transitionActive),
        tostring(status.transitionContext),
        tostring(status.lastAction),
        tostring(status.lastReason),
        tostring(status.lastStopReason),
        tostring(status.lastBlockedReason),
        tostring(status.lastLiveCombat),
        tostring(status.lastLockdown),
        tostring(status.lastCachedCombat),
        tostring(status.lastCombatMismatch),
        tostring(status.lastResting),
        tostring(status.lastDynamicCamLoaded),
        tostring(status.lastDynamicCamStatusSource),
        tostring(status.apiAvailable),
        tostring(status.lastCurrentZoom),
        tostring(status.transitionStartZoom),
        tostring(status.transitionRequestedZoom),
        tostring(status.transitionEffectiveTargetZoom),
        tostring(status.transitionDuration),
        tostring(status.lastCameraDistanceFactor),
        tostring(status.lastCameraDistanceTargetFactor),
        tostring(status.lastCameraDistanceCeiling),
        tostring(status.lastFinalZoom),
        tostring(status.lastTransitionElapsed),
        tostring(status.lastTargetReached),
        tostring(status.reconcileCount),
        tostring(status.transitionStartCount),
        tostring(status.transitionCompleteCount),
        tostring(status.transitionStopCount),
        tostring(status.noOpCount),
        tostring(status.blockedCount),
        tostring(status.relinquishCount),
        tostring(status.failureCount),
        tostring(status.lastSecret),
        tostring(status.lastError)
    ))
end

local function emitCameraWorldCombatMotion(status)
    emit(string.format(
        "Logres cameraworldcombat motion: samples=%s toward=%s away=%s flat=%s min=%s max=%s expected=%s posError=%s maxAbsPosError=%s observed=%s/%s command=%s/%s inCommands=%s outCommands=%s switches=%s rebases=%s rebaseIters=%s corrections=%s correctionActive=%s correctionSpeed=%s rebase=%s->%s armZoom=%s firstDelay=%s",
        tostring(status.transitionSampleCount),
        tostring(status.transitionTowardCount),
        tostring(status.transitionAwayCount),
        tostring(status.transitionFlatCount),
        tostring(status.transitionMinZoom),
        tostring(status.transitionMaxZoom),
        tostring(status.lastExpectedZoom),
        tostring(status.lastPositionError),
        tostring(status.transitionMaxAbsPositionError),
        tostring(status.lastObservedDirection),
        tostring(status.lastObservedDelta),
        tostring(status.lastCommandDirection),
        tostring(status.lastCommandFactor),
        tostring(status.transitionInCommandCount),
        tostring(status.transitionOutCommandCount),
        tostring(status.transitionDirectionSwitchCount),
        tostring(status.transitionRebaseCount),
        tostring(status.transitionRebaseIterationCount),
        tostring(status.transitionCorrectionCount),
        tostring(status.transitionCorrectionActive),
        tostring(status.lastCorrectionZoomSpeed),
        tostring(status.lastRebaseFromElapsed),
        tostring(status.lastRebaseToElapsed),
        tostring(status.transitionArmZoom),
        tostring(status.transitionFirstUpdateDelay)
    ))
end

local function emitCameraProfileContextStatus(status)
    emit(string.format(
        "Logres cameraprofile contexts: teleport=%s teleportDuration=%s afk=%s gathering=%s interaction=%s fishing=%s secretSkips=%s secretSource=%s readFailures=%s profileError=%s fishingHold=%s holdCount=%s holdRemaining=%s",
        tostring(status.lastProfileTeleport),
        tostring(status.lastProfileTeleportDuration),
        tostring(status.lastProfileAFK),
        tostring(status.lastProfileGathering),
        tostring(status.lastProfileInteraction),
        tostring(status.lastProfileFishing),
        tostring(status.profileSecretSkips),
        tostring(status.lastProfileSecretSource),
        tostring(status.profileReadFailures),
        tostring(status.lastProfileError),
        tostring(status.fishingHoldActive),
        tostring(status.fishingHoldCount),
        tostring(status.lastFishingHoldRemaining)
    ))
end

local function emitCameraReactiveZoomStatus(status)
    local reactive = status.reactiveZoom
    if reactive == nil then
        emit("Logres cameraprofile reactive: unavailable")
        return
    end

    emit(string.format(
        "Logres cameraprofile reactive: active=%s hooked=%s source=%s enabled=%s settings=%s/%s/%s/%s easing=%s target=%s current=%s lastTarget=%s duration=%s direction=%s increment=%s wheel=%s quick=%s resets=%s native=%s corrections=%s fallback=%s acquire=%s release=%s conflicts=%s/%s secrets=%s failures=%s action=%s error=%s",
        tostring(reactive.active),
        tostring(reactive.hooked),
        tostring(reactive.sourceDynamicCamCommit),
        tostring(reactive.enabled),
        tostring(reactive.addIncrementsAlways),
        tostring(reactive.addIncrements),
        tostring(reactive.incAddDifference),
        tostring(reactive.maxZoomTime),
        tostring(reactive.easing),
        tostring(reactive.target),
        tostring(reactive.lastCurrentZoom),
        tostring(reactive.lastTargetZoom),
        tostring(reactive.lastDuration),
        tostring(reactive.lastDirection),
        tostring(reactive.lastIncrement),
        tostring(reactive.wheelTickCount),
        tostring(reactive.quickZoomCount),
        tostring(reactive.directionResetCount),
        tostring(reactive.nativeZoomCount),
        tostring(reactive.targetCorrectionCount),
        tostring(reactive.fallbackCount),
        tostring(reactive.acquireCount),
        tostring(reactive.releaseCount),
        tostring(reactive.hookConflictCount),
        tostring(reactive.lastHookConflict),
        tostring(reactive.secretSkipCount),
        tostring(reactive.failureCount),
        tostring(reactive.lastAction),
        tostring(reactive.lastError)
    ))
end

local function emitCameraProfileBehaviorStatus(status)
    local behavior = status.profileBehavior
    if behavior == nil then
        emit(
            "Logres cameraprofile behavior: unavailable"
        )
        return
    end

    emit(string.format(
        "Logres cameraprofile behavior: active=%s context=%s source=%s/%s settings=%s/%s/%s failures=%s secretSkips=%s shoulder=%s distance=%s targetDistance=%s originalDistance=%s rotation=%s/%s speed=%s starts=%s returns=%s stops=%s failures=%s lastContext=%s lastKind=%s return=%s/%s settingsError=%s rotationError=%s",
        tostring(behavior.active),
        tostring(behavior.context),
        tostring(behavior.sourceDynamicCamCommit),
        tostring(behavior.sourceLibCameraCommit),
        tostring(behavior.settingsCaptureCount),
        tostring(behavior.settingsApplyCount),
        tostring(behavior.settingsRestoreCount),
        tostring(behavior.settingsFailureCount),
        tostring(behavior.settingsSecretSkips),
        tostring(behavior.lastShoulderOffset),
        tostring(behavior.lastDistanceFactor),
        tostring(behavior.lastDistanceTargetFactor),
        tostring(behavior.originalDistanceFactor),
        tostring(behavior.yawMode),
        tostring(behavior.pitchMode),
        tostring(behavior.yawContinuousSpeed),
        tostring(behavior.rotationStartCount),
        tostring(behavior.rotationReturnCount),
        tostring(behavior.rotationStopCount),
        tostring(behavior.rotationFailureCount),
        tostring(behavior.lastRotationContext),
        tostring(behavior.lastRotationKind),
        tostring(behavior.lastReturnYaw),
        tostring(behavior.lastReturnPitch),
        tostring(behavior.lastSettingsError),
        tostring(behavior.lastRotationError)
    ))
end

local function runCameraWorldCombatCheck()
    local controller = Logres:GetModule("CameraWorldCombat")
    local status = controller:GetDebugStatus()
    local passed = cameraWorldCombatStatusPasses(status)
    emitCameraWorldCombatStatus(passed and "PASS" or "FAIL", status, passed)
    emitCameraWorldCombatMotion(status)
    emitCameraProfileContextStatus(status)
    emitCameraReactiveZoomStatus(status)
    emitCameraProfileBehaviorStatus(status)
end

local function runCameraWorldCombatReconcile()
    local controller = Logres:GetModule("CameraWorldCombat")
    local ok, reason = controller:Reconcile("manual-diagnostic")
    local status = controller:GetDebugStatus()

    emitCameraWorldCombatStatus(
        ok and "RECONCILE" or "BLOCKED",
        status,
        ok
    )

    emitCameraWorldCombatMotion(status)
    emitCameraProfileContextStatus(status)
    emitCameraReactiveZoomStatus(status)
    emitCameraProfileBehaviorStatus(status)

    if not ok and reason then
        emit("Logres cameraworldcombat reconcile reason: " .. tostring(reason))
    end
end

local function handleCameraWorldCombat(argument)
    local controller = Logres:GetModule("CameraWorldCombat")

    if argument == "on" then
        Logres:EnableModule("CameraWorldCombat")
        emit("Logres cameraworldcombat: controller enabled")
        runCameraWorldCombatCheck()
        return
    end

    if argument == "off" then
        Logres:DisableModule("CameraWorldCombat")
        emit("Logres cameraworldcombat: controller disabled")
        return
    end

    if argument == "" or argument == "status" then
        local status = controller:GetDebugStatus()
        emitCameraWorldCombatStatus("STATUS", status, true)
        return
    end

    emit("Usage: /logres cameraworldcombat [on|off|status]")
end


local function runCameraZoomProbe()
    local probe = Logres:GetModule("CameraCapabilityProbe")
    local mode, reason = probe:HandlePanelAction()
    local debugStatus = probe:GetDebugStatus()

    if mode == "started" then
        emit(string.format(
            "Logres camerazoomprobe: STARTED (combat=%s lockdown=%s cachedCombat=%s mismatch=%s start=%s target=%s speed=%s; click Camera Zoom Probe again after the movement finishes)",
            tostring(debugStatus.lastCombat),
            tostring(debugStatus.lastCombatLockdown),
            tostring(debugStatus.lastCachedCombat),
            tostring(debugStatus.lastCombatMismatch),
            tostring(debugStatus.startZoom),
            tostring(debugStatus.targetZoom),
            tostring(debugStatus.lastZoomSpeed)
        ))
        return
    end

    if mode == "running" then
        emit(string.format(
            "Logres camerazoomprobe: RUNNING (phase=%s combat=%s)",
            tostring(debugStatus.phase),
            tostring(debugStatus.lastCombat)
        ))
        return
    end

    local passed = debugStatus.lastState == "pass"

    emit(string.format(
        "Logres camerazoomprobe: %s (mode=%s combat=%s lockdown=%s cachedCombat=%s mismatch=%s dynamicCam=%s/%s api=%s speed=%s start=%s target=%s turn=%s final=%s targetReached=%s moved=%s restored=%s secret=%s elapsed=%s/%s runs=%s pass=%s fail=%s error=%s)",
        passed and "PASS" or "FAIL",
        tostring(mode),
        tostring(debugStatus.lastCombat),
        tostring(debugStatus.lastCombatLockdown),
        tostring(debugStatus.lastCachedCombat),
        tostring(debugStatus.lastCombatMismatch),
        tostring(debugStatus.lastDynamicCamLoaded),
        tostring(debugStatus.lastDynamicCamStatusSource),
        tostring(debugStatus.lastAPIAvailable),
        tostring(debugStatus.lastZoomSpeed),
        tostring(debugStatus.startZoom),
        tostring(debugStatus.targetZoom),
        tostring(debugStatus.turnZoom),
        tostring(debugStatus.finalZoom),
        tostring(debugStatus.targetReached),
        tostring(debugStatus.moved),
        tostring(debugStatus.restored),
        tostring(debugStatus.lastSecret),
        tostring(debugStatus.outboundElapsed),
        tostring(debugStatus.returnElapsed),
        tostring(debugStatus.runCount),
        tostring(debugStatus.passCount),
        tostring(debugStatus.failCount),
        tostring(debugStatus.lastError or reason)
    ))

    if mode == "result" then
        probe:MarkReported()
    end
end



local function runCameraDistanceInfo()
    local probe = Logres:GetModule("CameraCapabilityProbe")
    local info, reason, secret = probe:ReadCameraDistanceInfo()

    if not info then
        emit(string.format(
            "Logres cameradistanceinfo: FAIL (secret=%s error=%s)",
            tostring(secret and true or false),
            tostring(reason)
        ))
        return
    end

    emit(string.format(
        "Logres cameradistanceinfo: PASS (source=%s current=%s default=%s currentCeiling=%s defaultCeiling=%s requiredFactor=%s currentSupports50=%s defaultSupports50=%s storedAccount=%s storedCharacter=%s locked=%s secure=%s readOnly=%s dynamicCam=%s/%s/%s secret=false error=nil)",
        tostring(info.source),
        tostring(info.current),
        tostring(info.default),
        tostring(info.currentCeiling),
        tostring(info.defaultCeiling),
        tostring(info.requiredFactor),
        tostring(info.currentSupports50),
        tostring(info.defaultSupports50),
        tostring(info.isStoredServerAccount),
        tostring(info.isStoredServerCharacter),
        tostring(info.isLockedFromUser),
        tostring(info.isSecure),
        tostring(info.isReadOnly),
        tostring(info.dynamicCamLoaded),
        tostring(info.dynamicCamStatusKnown),
        tostring(info.dynamicCamStatusSource)
    ))
end

local function runCameraTaxiTargetProbe()
    local probe = Logres:GetModule("CameraCapabilityProbe")
    local mode, reason = probe:HandleTaxiTargetPanelAction()
    local debugStatus = probe:GetDebugStatus()

    if mode == "started" then
        emit(string.format(
            "Logres camerataxitargetprobe: STARTED (start=%s target=%s speed=%s factor=%s ceiling=%s combat=%s lockdown=%s; wait for movement to finish, then click Taxi Target 50 Probe again)",
            tostring(debugStatus.startZoom),
            tostring(debugStatus.targetZoom),
            tostring(debugStatus.lastZoomSpeed),
            tostring(debugStatus.lastCameraDistanceFactor),
            tostring(debugStatus.lastCameraDistanceCeiling),
            tostring(debugStatus.lastCombat),
            tostring(debugStatus.lastCombatLockdown)
        ))
        return
    end

    if mode == "running" then
        emit(string.format(
            "Logres camerataxitargetprobe: RUNNING (phase=%s start=%s target=%s factor=%s ceiling=%s)",
            tostring(debugStatus.phase),
            tostring(debugStatus.startZoom),
            tostring(debugStatus.targetZoom),
            tostring(debugStatus.lastCameraDistanceFactor),
            tostring(debugStatus.lastCameraDistanceCeiling)
        ))
        return
    end

    if mode == "blocked" then
        emit(string.format(
            "Logres camerataxitargetprobe: BLOCKED (reason=%s factor=%s ceiling=%s secret=%s error=%s)",
            tostring(reason),
            tostring(debugStatus.lastCameraDistanceFactor),
            tostring(debugStatus.lastCameraDistanceCeiling),
            tostring(debugStatus.lastSecret),
            tostring(debugStatus.lastError)
        ))
        return
    end

    local passed =
        debugStatus.lastState == "pass"
        and debugStatus.probeKind == "taxi-target"

    emit(string.format(
        "Logres camerataxitargetprobe: %s (mode=%s factor=%s factorFinal=%s ceiling=%s cvarUnchanged=%s speed=%s start=%s target=%s turn=%s final=%s targetReached=%s moved=%s restored=%s combat=%s lockdown=%s dynamicCam=%s/%s secret=%s elapsed=%s/%s runs=%s pass=%s fail=%s error=%s)",
        passed and "PASS" or "FAIL",
        tostring(mode),
        tostring(debugStatus.lastCameraDistanceFactor),
        tostring(debugStatus.lastCameraDistanceFactorFinal),
        tostring(debugStatus.lastCameraDistanceCeiling),
        tostring(debugStatus.lastCameraDistanceUnchanged),
        tostring(debugStatus.lastZoomSpeed),
        tostring(debugStatus.startZoom),
        tostring(debugStatus.targetZoom),
        tostring(debugStatus.turnZoom),
        tostring(debugStatus.finalZoom),
        tostring(debugStatus.targetReached),
        tostring(debugStatus.moved),
        tostring(debugStatus.restored),
        tostring(debugStatus.lastCombat),
        tostring(debugStatus.lastCombatLockdown),
        tostring(debugStatus.lastDynamicCamLoaded),
        tostring(debugStatus.lastDynamicCamStatusSource),
        tostring(debugStatus.lastSecret),
        tostring(debugStatus.outboundElapsed),
        tostring(debugStatus.returnElapsed),
        tostring(debugStatus.runCount),
        tostring(debugStatus.passCount),
        tostring(debugStatus.failCount),
        tostring(debugStatus.lastError or reason)
    ))

    if mode == "result" then
        probe:MarkReported()
    end
end

local LAYOUT_EXPECTED = {
    { "LogresHUDResourceBar", "playerReaction" },
    { "LogresHUDTarget", "targetFallback" },
    { "LogresHUDAllies", "allies" },
    { "LogresPrimaryActionCluster", "primaryActions" },
    { "LogresSecondaryActionCluster", "secondaryActions" },
    { "LogresUtilityActionCluster", "utilityActions" },
    { "LogresBar4ActionCluster", "bar4Actions" },
    { "LogresBar5ActionCluster", "bar5Actions" },
    { "LogresCompassFrame", "navigation" },
    { "LogresQuestXPPulse", "contextXP" },
    { "LogresQuestObjectiveProgress", "contextObjective" },
    { "LogresActiveQuest", "activeQuest" },
    { "LogresQuestDialogue", "questDialogue" },
    { "LogresPlayerHelpfulAuras", "passiveStatus" },
    { "LogresPetActionExecutionProbeCluster", "classPet" },
    { "LogresNativeAccessDock", "nativeAccess" },
}

local function runLayoutCheck()
    local status =
        Logres.Layout
        and Logres.Layout.GetDebugStatus
        and Logres.Layout.GetDebugStatus()
        or nil

    if not status then
        emit(
            "Logres layoutcheck: FAIL "
            .. "(layout status unavailable)"
        )
        return
    end

    local missing = 0
    local mismatched = 0

    for index = 1, #LAYOUT_EXPECTED do
        local definition = LAYOUT_EXPECTED[index]
        local frame = _G[definition[1]]
        local expected = definition[2]

        if not frame then
            missing = missing + 1
        elseif frame.logresLayoutAnchor ~= expected then
            mismatched = mismatched + 1
        end
    end

    local passed =
        status.anchorCount == #LAYOUT_EXPECTED
        and status.bindFailureCount == 0
        and missing == 0
        and mismatched == 0

    emit(string.format(
        "Logres layoutcheck: %s (anchors=%s binds=%s failures=%s missing=%s mismatched=%s error=%s)",
        passed and "PASS" or "FAIL",
        tostring(status.anchorCount),
        tostring(status.bindCount),
        tostring(status.bindFailureCount),
        tostring(missing),
        tostring(mismatched),
        tostring(status.lastBindError)
    ))
end

local function runNativeAccessCheck()
    local status = Logres:GetModuleStatus("NativeAccess")
    local native = Logres:GetModule("NativeAccess")
    local result = native:GetDebugStatus()
    local expected = Logres:GetPreference("immersionEnabled") == true
    local passed = status.initialized == true
        and status.enabled == true
        and result.moduleEnabled == true
        and result.desired == expected
        and result.dockShown == expected
        and result.incompleteDomains == 0
        and result.foldedDomains + result.openDomains == (expected and 5 or 0)
        and result.failures == 0
        and result.refoldFailures == 0
        and result.pendingRefolds == 0
        and result.castGateArmed == result.castGateExpected
        and result.castGateFailures == 0
        and result.castGateEscapes == 0
        and result.lastError == nil
    local classification = passed and "PASS"
        or (result.pendingRefolds > 0 and InCombatLockdown()
            and "DEFERRED" or "FAIL")
    emit(string.format(
        "Logres nativeuicheck: %s (desired=%s dock=%s folded=%s open=%s incomplete=%s attempts=%s folds=%s restores=%s failures=%s event=%s details=%s error=%s refolds=%s/%s lastRefold=%s nativeShows=%s/%s combatDeferred=%s pending=%s lastShow=%s castGate=%s/%s gateCounts=%s/%s/%s gateEscapes=%s mainPetStock=true castStockOnDemand=true)",
        classification,
        tostring(result.desired), tostring(result.dockShown),
        tostring(result.foldedDomains), tostring(result.openDomains),
        tostring(result.incompleteDomains), tostring(result.attempts),
        tostring(result.folds), tostring(result.restores),
        tostring(result.failures), tostring(result.lastEvent),
        tostring(result.domains), tostring(result.lastError),
        tostring(result.refoldAttempts), tostring(result.refoldFailures),
        tostring(result.lastRefoldEvent),
        tostring(result.nativeShows), tostring(result.showRefolds),
        tostring(result.combatShowDeferrals),
        tostring(result.pendingRefolds), tostring(result.lastNativeShow),
        tostring(result.castGateArmed), tostring(result.castGateExpected),
        tostring(result.castGateAttempts), tostring(result.castGateRestores),
        tostring(result.castGateFailures), tostring(result.castGateEscapes)
    ))
end

function Logres:RunUIOwnershipCheck()
    local report = Logres.UIOwnershipAudit.Capture()
    local flags = report.flags
    emit(string.format(
        "Logres uiownership flags: immersion=%s context=%s combat=%s pvp=%s activeQuest=%s (snapshot, no native mutation)",
        tostring(flags.immersion), tostring(flags.context),
        tostring(flags.combat), tostring(flags.pvp), tostring(flags.activeQuest)
    ))
    for _, entry in ipairs(report.rows) do
        emit(string.format(
            "Logres uiownership %s: %s (Blizzard=%s; Logres=%s; expected=%s; observed=%s; note=%s)",
            entry.id, entry.status, entry.blizzard, entry.logres,
            tostring(entry.expected), tostring(entry.observed), tostring(entry.detail)
        ))
    end
    local counts = report.counts
    local status = counts.FAIL > 0 and "FAIL"
        or counts.DEFERRED > 0 and "DEFERRED" or "PASS"
    emit(string.format(
        "Logres uiownership: %s (total=%s pass=%s stock=%s deferred=%s fail=%s; stock=policy-not-native-visibility)",
        status, tostring(report.total), tostring(counts.PASS),
        tostring(counts.STOCK), tostring(counts.DEFERRED), tostring(counts.FAIL)
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
    runLayoutCheck()
    runNativeAccessCheck()
    runXPCheck()
    runObjectiveProgressCheck()
    runActiveQuestCheck()
    runQuestDialogueCheck()
    runQuestOfferControlsCheck()
    runQuestOfferStockSuppressionCheck()
    runPlayerHelpfulAuraCheck()
    runStatusAuraCheck()
    runActionCheck()
    runPrimaryOwnershipCheck()
    runStockReplacementCheck()
    runImmersionCheck()
    runQuietModeCheck()
    runPlayerFrameCheck()
    runTargetFrameCheck()
    runRestorationCheck()
    runContextPolicyCheck()
    runCameraWorldCombatCheck()
    runCompassCheck()
    Logres:RunUIOwnershipCheck()
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


local function handleHealthPreview(argument)
    local hud = Logres:GetModule("HUD")

    if argument == "off" or argument == "live" then
        local ok, state =
            hud:SetHealthPreviewPercent(nil)

        emit(string.format(
            "Logres healthpreview: %s (state=%s percent=live)",
            ok and "PASS" or "FAIL",
            tostring(state)
        ))
        return
    end

    local previewPercent = tonumber(argument)
    local ok, state =
        hud:SetHealthPreviewPercent(previewPercent)

    if not ok then
        emit(
            "Usage: /logres healthpreview [100|80|70|60|50|40|30|20|15|5|0|off]"
        )
        return
    end

    emit(string.format(
        "Logres healthpreview: PASS (state=%s percent=%s)",
        tostring(state),
        tostring(previewPercent)
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

local function runPetStateDiagnostic()
    local presentation = Logres:GetModule("PetActionPresentation")
    local lines = presentation:GetDiagnosticLines()

    for index = 1, #lines do
        emit(lines[index])
    end
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
    emit("  /logres layoutcheck")
    emit("  /logres compasscheck")
    emit("  /logres waypointprobe")
    emit("  /logres questprobe")
    emit("  /logres cameraworldcombatcheck")
    emit("  /logres cameraworldcombatreconcile")
    emit("  /logres cameraworldcombat [on|off|status]")
    emit("  /logres camerazoomprobe")
    emit("  /logres xpcheck")
    emit("  /logres xppreview")
    emit("  /logres objectiveprogresscheck")
    emit("  /logres objectiveprogresspreview")
    emit("  /logres activequestcheck")
    emit("  /logres activequestpreview [normal|complete|live]")
    emit("  /logres activequest [on|off|toggle]")
    emit("  /logres questdialoguecheck")
    emit("  /logres questdialoguepreview")
    emit("  /logres questoffercontrolscheck")
    emit("  /logres questofferstocksuppressioncheck")
    emit("  /logres questinteractionprobe")
    emit("  /logres aurastatusprobe")
    emit("  /logres worldtargetprobe")
    emit("  /logres navigationsourceprobe")
    emit("  /logres classpetspecialprobe")
    emit("  /logres petactionexecprobe [arm|check|hide]")
    emit("  /logres statusauracheck")
    emit("  /logres statusaurapreview [on|off]")
    emit("  /logres helpfulauracheck")
    emit("  /logres helpfulaurapreview [on|off]")
    emit("  /logres questofferacceptprobe")
    emit("  /logres questofferdeclineprobe")
    emit("  /logres hudpreview [on|off]")
    emit("  /logres healthpreview [100|80|70|60|50|40|30|20|15|5|0|off]")
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

    if command == "uiownershipcheck" then
        Logres:RunUIOwnershipCheck()
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

    if command == "primaryownershipcheck" then
        runPrimaryOwnershipCheck()
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

    if command == "nativeuicheck" then
        runNativeAccessCheck()
        return
    end

    if command == "nativeui" then
        local native = Logres:GetModule("NativeAccess")
        local domain = argument == "" and "all" or argument
        local ok, result = native:Toggle(domain)
        emit("Logres nativeui: " .. tostring(result) .. " (" .. domain .. ")")
        return
    end

    if command == "layoutcheck" then
        runLayoutCheck()
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

    if command == "cameraworldcombatcheck" then
        runCameraWorldCombatCheck()
        return
    end

    if command == "cameraworldcombatreconcile" then
        runCameraWorldCombatReconcile()
        return
    end

    if command == "cameraworldcombat" then
        handleCameraWorldCombat(argument)
        return
    end

    if command == "camerazoomprobe" then
        runCameraZoomProbe()
        return
    end

    if command == "camerataxitargetprobe" then
        runCameraTaxiTargetProbe()
        return
    end

    if command == "cameradistanceinfo" then
        runCameraDistanceInfo()
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

    if command == "objectiveprogresscheck" then
        runObjectiveProgressCheck()
        return
    end

    if command == "objectiveprogresspreview" then
        runObjectiveProgressPreview()
        return
    end

    if command == "activequestcheck" then
        runActiveQuestCheck()
        return
    end

    if command == "activequestpreview" then
        if argument == "normal"
            or argument == "complete"
            or argument == "live"
        then
            runActiveQuestPreview(argument)
        else
            emit("Usage: /logres activequestpreview [normal|complete|live]")
        end
        return
    end

    if command == "activequest" then
        handleActiveQuest(argument)
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

    if command == "questoffercontrolscheck" then
        runQuestOfferControlsCheck()
        return
    end

    if command == "questofferstocksuppressioncheck" then
        runQuestOfferStockSuppressionCheck()
        return
    end

    if command == "questinteractionprobe" then
        runQuestInteractionProbe()
        return
    end

    if command == "aurastatusprobe" then
        runAuraStatusProbe()
        return
    end

    if command == "worldtargetprobe" then
        runWorldTargetProbe()
        return
    end

    if command == "navigationsourceprobe" then
        runNavigationSourceProbe()
        return
    end

    if command == "classpetspecialprobe" then
        runClassPetSpecialProbe()
        return
    end

    if command == "petactionexecprobe" then
        runPetActionExecutionProbe(argument)
        return
    end

    if command == "petstate" then
        runPetStateDiagnostic()
        return
    end


    if command == "statusauracheck" then
        runStatusAuraCheck()
        return
    end

    if command == "statusaurapreview" then
        runStatusAuraPreview(argument)
        return
    end

    if command == "helpfulauracheck" then
        runPlayerHelpfulAuraCheck()
        return
    end

    if command == "helpfulaurapreview" then
        runPlayerHelpfulAuraPreview(argument)
        return
    end

    if command == "questofferacceptprobe" then
        runQuestOfferActionProbe("accept")
        return
    end

    if command == "questofferdeclineprobe" then
        runQuestOfferActionProbe("decline")
        return
    end

    if command == "healthpreview" then
        handleHealthPreview(argument)
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

Logres:RegisterDevPanelAction(
    "runall",
    "Run All",
    "checkall",
    "0"
)
Logres:RegisterDevPanelAction(
    "uiOwnershipCheck",
    "UI Ownership Check",
    "uiownershipcheck",
    "0"
)
Logres:RegisterDevPanelAction(
    "status",
    "Status",
    "status",
    "0"
)
Logres:RegisterDevPanelAction(
    "state",
    "State Check",
    "statecheck",
    "A"
)
Logres:RegisterDevPanelAction(
    "sensor",
    "Sensor Check",
    "sensorcheck",
    "A"
)
Logres:RegisterDevPanelAction(
    "preference",
    "Preference Check",
    "preferencecheck",
    "0"
)
Logres:RegisterDevPanelAction(
    "lifecycle",
    "Lifecycle Check",
    "lifecyclecheck",
    "0"
)
Logres:RegisterDevPanelAction(
    "hud",
    "HUD Check",
    "hudcheck",
    "B"
)
Logres:RegisterDevPanelAction(
    "action",
    "Action Check",
    "actioncheck",
    "C"
)
Logres:RegisterDevPanelAction(
    "actionFeedback",
    "Feedback Test",
    "actionfeedback",
    "C"
)
Logres:RegisterDevPanelAction(
    "actionKeysOn",
    "Action Keys ON",
    "actionbindings on",
    "C"
)
Logres:RegisterDevPanelAction(
    "actionKeysOff",
    "Action Keys OFF",
    "actionbindings off",
    "C"
)
Logres:RegisterDevPanelAction(
    "secondaryKeysOn",
    "Secondary Keys ON",
    "secondarybindings on",
    "C"
)
Logres:RegisterDevPanelAction(
    "secondaryKeysOff",
    "Secondary Keys OFF",
    "secondarybindings off",
    "C"
)
Logres:RegisterDevPanelAction(
    "utilityKeysOn",
    "Utility Keys ON",
    "utilitybindings on",
    "C"
)
Logres:RegisterDevPanelAction(
    "utilityKeysOff",
    "Utility Keys OFF",
    "utilitybindings off",
    "C"
)
Logres:RegisterDevPanelAction(
    "primaryOwnershipCheck",
    "Primary Ownership Check",
    "primaryownershipcheck",
    "C"
)
Logres:RegisterDevPanelAction(
    "stockReplaceCheck",
    "Stock Replace Check",
    "stockreplacecheck",
    "C"
)
Logres:RegisterDevPanelAction(
    "stockReplaceOn",
    "Stock Replace ON",
    "stockreplace on",
    "C"
)
Logres:RegisterDevPanelAction(
    "stockReplaceOff",
    "Stock Replace OFF",
    "stockreplace off",
    "C"
)
Logres:RegisterDevPanelAction(
    "immersionCheck",
    "Immersion Check",
    "immersioncheck",
    "D"
)
Logres:RegisterDevPanelAction(
    "quietCheck",
    "Quiet Check",
    "quietcheck",
    "D"
)
Logres:RegisterDevPanelAction(
    "playerFrameCheck",
    "Player Frame Check",
    "playerframecheck",
    "D"
)
Logres:RegisterDevPanelAction(
    "targetFrameCheck",
    "Target Frame Check",
    "targetframecheck",
    "D"
)
Logres:RegisterDevPanelAction(
    "restorationCheck",
    "Restoration Check",
    "restorationcheck",
    "D"
)
Logres:RegisterDevPanelAction(
    "contextPolicyCheck",
    "Context Policy Check",
    "contextpolicycheck",
    "D"
)
Logres:RegisterDevPanelAction(
    "compassCheck",
    "Compass Check",
    "compasscheck",
    "E"
)
Logres:RegisterDevPanelAction(
    "waypointProbe",
    "Waypoint Probe",
    "waypointprobe",
    "E"
)
Logres:RegisterDevPanelAction(
    "questProbe",
    "Quest Probe",
    "questprobe",
    "F"
)
Logres:RegisterDevPanelAction(
    "cameraWorldCombatCheck",
    "Camera Profile Check",
    "cameraworldcombatcheck",
    "G"
)
Logres:RegisterDevPanelAction(
    "cameraWorldCombatReconcile",
    "Camera Profile Reconcile",
    "cameraworldcombatreconcile",
    "G"
)
Logres:RegisterDevPanelAction(
    "cameraWorldCombatOn",
    "Camera Profile ON",
    "cameraworldcombat on",
    "G"
)
Logres:RegisterDevPanelAction(
    "cameraWorldCombatOff",
    "Camera Profile OFF",
    "cameraworldcombat off",
    "G"
)
Logres:RegisterDevPanelAction(
    "cameraZoomProbe",
    "Camera Zoom Probe",
    "camerazoomprobe",
    "G"
)
Logres:RegisterDevPanelAction(
    "cameraTaxiTargetProbe",
    "Taxi Target 50 Probe",
    "camerataxitargetprobe",
    "G"
)
Logres:RegisterDevPanelAction(
    "cameraDistanceInfo",
    "Camera Distance Info",
    "cameradistanceinfo",
    "G"
)
Logres:RegisterDevPanelAction(
    "xpCheck",
    "XP Check",
    "xpcheck",
    "F"
)
Logres:RegisterDevPanelAction(
    "xpPreview",
    "XP Preview",
    "xppreview",
    "F"
)
Logres:RegisterDevPanelAction(
    "objectiveProgressCheck",
    "Objective Progress Check",
    "objectiveprogresscheck",
    "F"
)
Logres:RegisterDevPanelAction(
    "objectiveProgressPreview",
    "Objective Progress Preview",
    "objectiveprogresspreview",
    "F"
)
Logres:RegisterDevPanelAction(
    "activeQuestCheck",
    "Active Quest Check",
    "activequestcheck",
    "F"
)
Logres:RegisterDevPanelAction(
    "activeQuestPreviewNormal",
    "Active Quest Preview",
    "activequestpreview normal",
    "F"
)
Logres:RegisterDevPanelAction(
    "activeQuestPreviewComplete",
    "Active Quest Complete",
    "activequestpreview complete",
    "F"
)
Logres:RegisterDevPanelAction(
    "activeQuestLive",
    "Active Quest Live",
    "activequestpreview live",
    "F"
)
Logres:RegisterDevPanelAction(
    "activeQuestOn",
    "Active Quest ON",
    "activequest on",
    "F"
)
Logres:RegisterDevPanelAction(
    "activeQuestOff",
    "Active Quest OFF",
    "activequest off",
    "F"
)
Logres:RegisterDevPanelAction(
    "questDialogueCheck",
    "Quest Dialogue Check",
    "questdialoguecheck",
    "F"
)
Logres:RegisterDevPanelAction(
    "questDialoguePreview",
    "Quest Dialogue Preview",
    "questdialoguepreview",
    "F"
)
Logres:RegisterDevPanelAction(
    "layoutCheck",
    "Layout Check",
    "layoutcheck",
    "H"
)
Logres:RegisterDevPanelAction(
    "nativeAccessCheck",
    "Native Access Check",
    "nativeuicheck",
    "H"
)
Logres:RegisterDevPanelAction(
    "statusAuraCheck",
    "Status Aura Check",
    "statusauracheck",
    "H"
)
Logres:RegisterDevPanelAction(
    "statusAuraPreviewOn",
    "Status Aura Preview ON",
    "statusaurapreview on",
    "H"
)
Logres:RegisterDevPanelAction(
    "statusAuraPreviewOff",
    "Status Aura Preview OFF",
    "statusaurapreview off",
    "H"
)
Logres:RegisterDevPanelAction(
    "questInteractionProbe",
    "Quest Interaction Probe",
    "questinteractionprobe",
    "H"
)
Logres:RegisterDevPanelAction(
    "auraStatusProbe",
    "Aura Status Probe",
    "aurastatusprobe",
    "H"
)
Logres:RegisterDevPanelAction(
    "worldTargetProbe",
    "World Target Probe",
    "worldtargetprobe",
    "H"
)
Logres:RegisterDevPanelAction(
    "navigationSourceProbe",
    "Navigation Source Probe",
    "navigationsourceprobe",
    "H"
)
Logres:RegisterDevPanelAction(
    "classPetSpecialProbe",
    "Class / Pet / Special Probe",
    "classpetspecialprobe",
    "H"
)
Logres:RegisterDevPanelAction(
    "petActionExecArm",
    "Pet Action Probe ARM",
    "petactionexecprobe arm",
    "C"
)
Logres:RegisterDevPanelAction(
    "petActionExecCheck",
    "Pet Action Probe Check",
    "petactionexecprobe check",
    "C"
)
Logres:RegisterDevPanelAction(
    "petActionExecHide",
    "Pet Action Probe Hide",
    "petactionexecprobe hide",
    "C"
)
Logres:RegisterDevPanelAction(
    "petStateDiagnostic",
    "Pet State Diagnostic",
    "petstate",
    "H"
)
Logres:RegisterDevPanelAction(
    "playerHelpfulAuraCheck",
    "Player Helpful Aura Check",
    "helpfulauracheck",
    "H"
)
Logres:RegisterDevPanelAction(
    "playerHelpfulAuraPreview",
    "Player Helpful Aura Preview",
    "helpfulaurapreview",
    "H"
)
Logres:RegisterDevPanelAction(
    "questOfferControlsCheck",
    "Quest Offer Controls Check",
    "questoffercontrolscheck",
    "H"
)
Logres:RegisterDevPanelAction(
    "questOfferStockSuppressionCheck",
    "Quest Offer Stock Check",
    "questofferstocksuppressioncheck",
    "H"
)
Logres:RegisterDevPanelAction(
    "questOfferAcceptProbe",
    "TEST Accept Current Quest",
    "questofferacceptprobe",
    "F"
)
Logres:RegisterDevPanelAction(
    "questOfferDeclineProbe",
    "TEST Decline Current Quest",
    "questofferdeclineprobe",
    "F"
)
Logres:RegisterDevPanelAction(
    "immersionOn",
    "Immersion ON",
    "immersion on",
    "D"
)
Logres:RegisterDevPanelAction(
    "immersionOff",
    "Immersion OFF",
    "immersion off",
    "D"
)
Logres:RegisterDevPanelAction(
    "healthPreview100",
    "Health 100%",
    "healthpreview 100",
    "B"
)
Logres:RegisterDevPanelAction(
    "healthPreview80",
    "Health 80%",
    "healthpreview 80",
    "B"
)
Logres:RegisterDevPanelAction(
    "healthPreview70",
    "Health 70%",
    "healthpreview 70",
    "B"
)
Logres:RegisterDevPanelAction(
    "healthPreview60",
    "Health 60%",
    "healthpreview 60",
    "B"
)
Logres:RegisterDevPanelAction(
    "healthPreview50",
    "Health 50%",
    "healthpreview 50",
    "B"
)
Logres:RegisterDevPanelAction(
    "healthPreview40",
    "Health 40%",
    "healthpreview 40",
    "B"
)
Logres:RegisterDevPanelAction(
    "healthPreview30",
    "Health 30%",
    "healthpreview 30",
    "B"
)
Logres:RegisterDevPanelAction(
    "healthPreview20",
    "Health 20%",
    "healthpreview 20",
    "B"
)
Logres:RegisterDevPanelAction(
    "healthPreview15",
    "Health 15%",
    "healthpreview 15",
    "B"
)
Logres:RegisterDevPanelAction(
    "healthPreview5",
    "Health 5%",
    "healthpreview 5",
    "B"
)
Logres:RegisterDevPanelAction(
    "healthPreview0",
    "Health 0%",
    "healthpreview 0",
    "B"
)
Logres:RegisterDevPanelAction(
    "healthPreviewLive",
    "Health Live",
    "healthpreview off",
    "B"
)

SLASH_LOGRES1 = "/logres"
SlashCmdList.LOGRES = function(message)
    Logres:RunDevCommand(message)
end
