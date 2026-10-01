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

    local secondary = sideDebug.secondary
    local utility = sideDebug.utility

    local primaryDeferredOK =
        (
            primaryDebug.pendingPageRefresh == false
            and primaryDebug.pendingBindingRefresh == false
        )
        or (
            InCombatLockdown()
            and (
                primaryDebug.pendingPageRefresh
                or primaryDebug.pendingBindingRefresh
            )
        )

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
        and primaryDebug.currentPage ~= nil
        and primaryDebug.firstActionSlot ~= nil
        and primaryDebug.lastActionSlot ~= nil
        and primaryDeferredOK
        and sideStatus.initialized == true
        and sideStatus.enabled == true
        and sideDebug.moduleEnabled == true
        and secondary.shown == true
        and secondary.buttonCount == 12
        and secondary.registeredCount == 12
        and secondary.firstActionSlot == 61
        and secondary.lastActionSlot == 72
        and secondaryDeferredOK
        and utility.shown == true
        and utility.buttonCount == 12
        and utility.registeredCount == 12
        and utility.firstActionSlot == 49
        and utility.lastActionSlot == 60
        and utilityDeferredOK
        and primaryDebug.stockBarsSuppressed == false
        and sideDebug.stockBarsSuppressed == false

    if passed then
        emit(string.format(
            "Logres actioncheck: PASS (primary=12 page=%s slots=%s-%s keys=%s/%s secondary=12 slots=61-72 keys=%s/%s utility=12 slots=49-60 keys=%s/%s stockBarsSuppressed=false)",
            tostring(primaryDebug.currentPage),
            tostring(primaryDebug.firstActionSlot),
            tostring(primaryDebug.lastActionSlot),
            boolText(primaryDebug.bindingRoutingEnabled),
            tostring(primaryDebug.boundButtonCount),
            boolText(secondary.bindingRoutingEnabled),
            tostring(secondary.boundButtonCount),
            boolText(utility.bindingRoutingEnabled),
            tostring(utility.boundButtonCount)
        ))
        return
    end

    emit(string.format(
        "Logres actioncheck: FAIL (primary init=%s enabled=%s shown=%s buttons=%s registered=%s page=%s slots=%s-%s secondary init=%s enabled=%s shown=%s buttons=%s registered=%s slots=%s-%s utility shown=%s buttons=%s registered=%s slots=%s-%s stockSuppressed=%s/%s)",
        tostring(primaryStatus.initialized),
        tostring(primaryStatus.enabled),
        tostring(primaryDebug.clusterShown),
        tostring(primaryDebug.buttonCount),
        tostring(primaryDebug.registeredCount),
        tostring(primaryDebug.currentPage),
        tostring(primaryDebug.firstActionSlot),
        tostring(primaryDebug.lastActionSlot),
        tostring(sideStatus.initialized),
        tostring(sideStatus.enabled),
        tostring(secondary.shown),
        tostring(secondary.buttonCount),
        tostring(secondary.registeredCount),
        tostring(secondary.firstActionSlot),
        tostring(secondary.lastActionSlot),
        tostring(utility.shown),
        tostring(utility.buttonCount),
        tostring(utility.registeredCount),
        tostring(utility.firstActionSlot),
        tostring(utility.lastActionSlot),
        tostring(primaryDebug.stockBarsSuppressed),
        tostring(sideDebug.stockBarsSuppressed)
    ))
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


local function runAllChecks()
    emit("Logres checkall: beginning")
    printStatus()
    runStateCheck()
    runSensorCheck()
    runPreferenceCheck()
    runLifecycleCheck()
    runHUDCheck()
    runActionCheck()
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
    emit("  /logres actionbindings [on|off]")
    emit("  /logres secondarybindings [on|off]")
    emit("  /logres utilitybindings [on|off]")
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
