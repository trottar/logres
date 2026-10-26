local _, Logres = ...

local modulesByName = {}
local moduleOrder = {}

local function requireModule(name)
    local module = modulesByName[name]

    if not module then
        error("Unknown Logres module: " .. tostring(name))
    end

    return module
end

local function runCleanups(module)
    local firstError

    for index = #module._cleanups, 1, -1 do
        local cleanup = module._cleanups[index]
        module._cleanups[index] = nil

        local ok, cleanupError = pcall(cleanup)

        if not ok and firstError == nil then
            firstError = cleanupError
        end
    end

    return firstError
end

local ModuleMethods = {}

function ModuleMethods:OwnCleanup(cleanup)
    if type(cleanup) ~= "function" then
        error("Module cleanup must be a function")
    end

    if not self._enabling and not self._enabled then
        error(string.format(
            "Module %s can only own cleanup while enabling or enabled",
            tostring(self.name)
        ))
    end

    self._cleanups[#self._cleanups + 1] = cleanup
    return cleanup
end

function ModuleMethods:SubscribeState(handler)
    return self:OwnCleanup(Logres:SubscribeState(handler))
end

function ModuleMethods:SubscribePreferences(handler)
    return self:OwnCleanup(Logres:SubscribePreferences(handler))
end

function ModuleMethods:IsInitialized()
    return self._initialized
end

function ModuleMethods:IsEnabled()
    return self._enabled
end

function Logres:RegisterModule(name, definition)
    if type(name) ~= "string" or name == "" then
        error("Logres:RegisterModule requires a non-empty module name")
    end

    if modulesByName[name] then
        error("Logres module already registered: " .. name)
    end

    if definition == nil then
        definition = {}
    elseif type(definition) ~= "table" then
        error("Logres:RegisterModule definition must be a table")
    end

    if definition.autoEnable ~= nil and type(definition.autoEnable) ~= "boolean" then
        error("Logres module autoEnable must be boolean when provided")
    end

    for _, callbackName in ipairs({ "OnInitialize", "OnEnable", "OnDisable" }) do
        local callback = definition[callbackName]

        if callback ~= nil and type(callback) ~= "function" then
            error(string.format(
                "Logres module %s %s must be a function when provided",
                name,
                callbackName
            ))
        end
    end

    local module = {
        name = name,
        autoEnable = definition.autoEnable ~= false,

        OnInitialize = definition.OnInitialize,
        OnEnable = definition.OnEnable,
        OnDisable = definition.OnDisable,

        _initialized = false,
        _enabled = false,
        _enabling = false,
        _cleanups = {},
    }

    setmetatable(module, { __index = ModuleMethods })

    modulesByName[name] = module
    moduleOrder[#moduleOrder + 1] = module

    return module
end

function Logres:GetModule(name)
    return requireModule(name)
end

function Logres:GetModuleStatus(name)
    local module = requireModule(name)

    return {
        name = module.name,
        autoEnable = module.autoEnable,
        initialized = module._initialized,
        enabled = module._enabled,
        cleanupCount = #module._cleanups,
    }
end

function Logres:InitializeModule(name)
    local module = requireModule(name)

    if module._initialized then
        return false
    end

    if module.OnInitialize then
        module:OnInitialize()
    end

    module._initialized = true
    return true
end

function Logres:EnableModule(name)
    local module = requireModule(name)

    if module._enabled then
        return false
    end

    self:InitializeModule(name)

    module._enabling = true

    local ok, enableError = true, nil

    if module.OnEnable then
        ok, enableError = pcall(module.OnEnable, module)
    end

    module._enabling = false

    if not ok then
        local cleanupError = runCleanups(module)

        if cleanupError then
            error(string.format(
                "Logres module %s enable failed: %s; cleanup also failed: %s",
                name,
                tostring(enableError),
                tostring(cleanupError)
            ), 0)
        end

        error(enableError, 0)
    end

    module._enabled = true
    return true
end

function Logres:DisableModule(name)
    local module = requireModule(name)

    if not module._enabled then
        return false
    end

    local disableOK, disableError = true, nil

    if module.OnDisable then
        disableOK, disableError = pcall(module.OnDisable, module)
    end

    module._enabled = false

    local cleanupError = runCleanups(module)

    if not disableOK then
        if cleanupError then
            error(string.format(
                "Logres module %s disable failed: %s; cleanup also failed: %s",
                name,
                tostring(disableError),
                tostring(cleanupError)
            ), 0)
        end

        error(disableError, 0)
    end

    if cleanupError then
        error(string.format(
            "Logres module %s cleanup failed: %s",
            name,
            tostring(cleanupError)
        ), 0)
    end

    return true
end

function Logres:InitializeModules()
    for index = 1, #moduleOrder do
        self:InitializeModule(moduleOrder[index].name)
    end
end

function Logres:EnableDefaultModules()
    for index = 1, #moduleOrder do
        local module = moduleOrder[index]

        if module.autoEnable then
            self:EnableModule(module.name)
        end
    end
end

function Logres:RunDevLifecycleCheck(emit, lifecycleProbe, lifecycleProbeModule)
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
