local _, Logres = ...

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

    print(string.format(
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

    print(string.format(
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
        print(string.format(
            "Logres statecheck: PASS (snapshot isolation=true, no-op revision=%s, callbacks=0)",
            tostring(afterRefresh.revision)
        ))
        return
    end

    print(string.format(
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
        print(string.format(
            "Logres sensorcheck: PASS (mounted=%s resting=%s taxi=%s interact=%s/%s)",
            boolText(state.mounted),
            boolText(state.resting),
            boolText(state.onTaxi),
            boolText(state.interacting),
            tostring(state.interactionType)
        ))
        return
    end

    print(string.format(
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
        print(string.format(
            "Logres preferencecheck: PASS (snapshot isolation=true, callbacks=2, revision=%s, immersionEnabled=%s)",
            tostring(final.revision),
            boolText(final.immersionEnabled)
        ))
        return
    end

    print(string.format(
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
        print(string.format(
            "Logres lifecyclecheck: PASS (init=%s enable=%s disable=%s cleanup=%s prefCallbacksWhileEnabled=2 prefCallbacksWhileDisabled=0)",
            tostring(lifecycleProbe.initializeCount),
            tostring(lifecycleProbe.enableCount),
            tostring(lifecycleProbe.disableCount),
            tostring(lifecycleProbe.cleanupCount)
        ))
        return
    end

    print(string.format(
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
        and visibilityMatchesPreference

    if passed then
        print(string.format(
            "Logres hudcheck: PASS (bands=4 textures=16 curves=true immersion=%s visible=%s)",
            boolText(debugStatus.immersionEnabled),
            boolText(debugStatus.rootShown)
        ))
        return
    end

    print(string.format(
        "Logres hudcheck: FAIL (initialized=%s enabled=%s moduleEnabled=%s bands=%s textures=%s curves=%s immersion=%s visible=%s visibilityMatches=%s)",
        tostring(status.initialized),
        tostring(status.enabled),
        tostring(debugStatus.moduleEnabled),
        tostring(debugStatus.bandCount),
        tostring(debugStatus.textureCount),
        tostring(debugStatus.curvesReady),
        tostring(debugStatus.immersionEnabled),
        tostring(debugStatus.rootShown),
        tostring(visibilityMatchesPreference)
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
        print("Usage: /logres immersion [on|off|toggle]")
        return
    end

    local changed = Logres:SetPreference(
        "immersionEnabled",
        newValue,
        "SLASH_IMMERSION"
    )

    print(string.format(
        "Logres: immersionEnabled=%s%s",
        boolText(newValue),
        changed and "" or " (unchanged)"
    ))
end

local function printHelp()
    print("Logres development commands:")
    print("  /logres status")
    print("  /logres statecheck")
    print("  /logres sensorcheck")
    print("  /logres preferencecheck")
    print("  /logres lifecyclecheck")
    print("  /logres hudcheck")
    print("  /logres immersion [on|off|toggle]")
    print("  /logres debug on")
    print("  /logres debug off")
end

SLASH_LOGRES1 = "/logres"
SlashCmdList.LOGRES = function(message)
    local command, argument = (message or ""):lower():match("^%s*(%S*)%s*(.-)%s*$")

    if command == "" or command == "status" then
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

    if command == "immersion" then
        handleImmersion(argument)
        return
    end

    if command == "debug" then
        if not Logres.db then
            print("Logres: database is not initialized yet.")
            return
        end

        if argument == "on" then
            Logres.db.settings.debug = true
            print("Logres: development messages enabled.")
            return
        elseif argument == "off" then
            Logres.db.settings.debug = false
            print("Logres: development messages disabled.")
            return
        end
    end

    printHelp()
end
