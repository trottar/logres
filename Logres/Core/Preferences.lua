local _, Logres = ...

local preferenceRevision = 0
local preferenceListeners = {}

local PREFERENCE_SPECS = {
    immersionEnabled = {
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

    for index = 1, #preferenceListeners do
        local subscription = preferenceListeners[index]

        if subscription.active then
            subscription.handler(
                copyPreferences(),
                {
                    revision = previous.revision,
                    immersionEnabled = previous.immersionEnabled,
                },
                copyChanges(changes),
                reason
            )
        end
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
        subscription.active = false
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
