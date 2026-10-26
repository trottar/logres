local _, Logres = ...

local preferenceRevision = 0
local preferenceListeners = {}
local preferenceDispatchDepth = 0
local preferenceListenersDirty = false

local function compactPreferenceListeners()
    if not preferenceListenersDirty then return end
    local write = 1
    for read = 1, #preferenceListeners do
        local subscription = preferenceListeners[read]
        if subscription.active then
            preferenceListeners[write] = subscription
            write = write + 1
        end
    end
    for index = write, #preferenceListeners do
        preferenceListeners[index] = nil
    end
    preferenceListenersDirty = false
end

local PREFERENCE_SPECS = {
    immersionEnabled = {
        valueType = "boolean",
    },
    activeQuestEnabled = {
        valueType = "boolean",
    },
}

local function requireDatabase()
    if not Logres.db or not Logres.db.settings then
        error("Logres preferences require an initialized database")
    end
end

local function requirePreference(name)
    local spec = PREFERENCE_SPECS[name]
    if not spec then
        error("Unknown Logres preference: " .. tostring(name))
    end
    return spec
end

local function copyPreferences()
    requireDatabase()

    return {
        revision = preferenceRevision,
        immersionEnabled = Logres.db.settings.immersionEnabled and true or false,
        activeQuestEnabled = Logres.db.settings.activeQuestEnabled and true or false,
    }
end

local function copyChanges(source)
    local result = {}

    for key, change in pairs(source) do
        result[key] = {
            old = change.old,
            new = change.new,
        }
    end

    return result
end

local function publishPreferenceChange(previous, changes, reason)
    local current = copyPreferences()

    preferenceDispatchDepth = preferenceDispatchDepth + 1
    local ok, failure = pcall(function()
        for index = 1, #preferenceListeners do
            local subscription = preferenceListeners[index]

            if subscription.active then
                subscription.handler(
                    copyPreferences(),
                    {
                        revision = previous.revision,
                        immersionEnabled = previous.immersionEnabled,
                        activeQuestEnabled = previous.activeQuestEnabled,
                    },
                    copyChanges(changes),
                    reason
                )
            end
        end
    end)
    preferenceDispatchDepth = preferenceDispatchDepth - 1
    if preferenceDispatchDepth == 0 then
        compactPreferenceListeners()
    end
    if not ok then
        error(failure, 0)
    end

    return current
end

function Logres:GetPreferences()
    return copyPreferences()
end

function Logres:GetPreference(name)
    requireDatabase()
    requirePreference(name)
    return self.db.settings[name]
end

function Logres:SubscribePreferences(handler)
    if type(handler) ~= "function" then
        error("Logres:SubscribePreferences requires a function handler")
    end

    local subscription = {
        active = true,
        handler = handler,
    }

    preferenceListeners[#preferenceListeners + 1] = subscription

    local function unsubscribe()
        if not subscription.active then
            return
        end
        subscription.active = false
        subscription.handler = nil
        preferenceListenersDirty = true
        -- Keep callback iteration stable; release tombstones afterward.
        if preferenceDispatchDepth == 0 then
            compactPreferenceListeners()
        end
    end

    return unsubscribe
end

function Logres:SetPreference(name, value, reason)
    requireDatabase()

    local spec = requirePreference(name)

    if type(value) ~= spec.valueType then
        error(string.format(
            "Preference %s requires %s, got %s",
            tostring(name),
            tostring(spec.valueType),
            type(value)
        ))
    end

    local oldValue = self.db.settings[name]

    if oldValue == value then
        return false
    end

    local previous = copyPreferences()

    self.db.settings[name] = value
    preferenceRevision = preferenceRevision + 1

    local changes = {
        [name] = {
            old = oldValue,
            new = value,
        },
    }

    publishPreferenceChange(previous, changes, reason or "manual")
    return true
end

function Logres:RunDevPreferenceCheck(emit, boolText)
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
