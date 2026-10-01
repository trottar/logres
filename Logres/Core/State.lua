local _, Logres = ...

local State = {
    initialized = false,
    revision = 0,

    context = "unknown",
    combat = false,
    pvpFlagged = false,
    inInstance = false,
    instanceType = "none",

    lastEvent = "bootstrap",
}

Logres.State = State

local TRACKED_FIELDS = {
    "context",
    "combat",
    "pvpFlagged",
    "inInstance",
    "instanceType",
}

local function captureState()
    local inInstance, instanceType = IsInInstance()

    inInstance = inInstance and true or false
    instanceType = instanceType or "none"

    return {
        context = inInstance and "instance" or "world",
        combat = InCombatLockdown() and true or false,
        pvpFlagged = UnitIsPVP("player") and true or false,
        inInstance = inInstance,
        instanceType = instanceType,
    }
end

function Logres:RefreshState(reason)
    local observed = captureState()
    local changes = {}
    local changed = not State.initialized

    for index = 1, #TRACKED_FIELDS do
        local key = TRACKED_FIELDS[index]
        local oldValue = State[key]
        local newValue = observed[key]

        if oldValue ~= newValue then
            changes[key] = {
                old = oldValue,
                new = newValue,
            }
            State[key] = newValue
            changed = true
        end
    end

    State.initialized = true
    State.lastEvent = reason or "manual"

    if changed then
        State.revision = State.revision + 1
        self:FireCallback("STATE_CHANGED", State, changes)
    end

    return changed
end

local function refreshFromEvent(event, ...)
    if event == "PLAYER_FLAGS_CHANGED" then
        local unit = ...
        if unit and unit ~= "player" then
            return
        end
    end

    -- I-001 proved that combat-related state can settle across multiple events.
    -- We therefore refresh from each authoritative signal instead of assuming
    -- PLAYER_REGEN_DISABLED alone represents the final restriction state.
    Logres:RefreshState(event)
end

local EVENTS = {
    "PLAYER_LOGIN",
    "PLAYER_ENTERING_WORLD",
    "ZONE_CHANGED_NEW_AREA",
    "PLAYER_REGEN_DISABLED",
    "PLAYER_REGEN_ENABLED",
    "PLAYER_FLAGS_CHANGED",
    "ADDON_RESTRICTION_STATE_CHANGED",
}

for index = 1, #EVENTS do
    Logres:RegisterEvent(EVENTS[index], refreshFromEvent)
end
