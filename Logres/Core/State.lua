local _, Logres = ...

local INTERACTION_NONE = 0
local activeInteractionType = INTERACTION_NONE

local State = {
    initialized = false,
    revision = 0,

    context = "unknown",
    combat = false,
    pvpFlagged = false,
    inInstance = false,
    instanceType = "none",

    mounted = false,
    resting = false,
    onTaxi = false,

    interacting = false,
    interactionType = INTERACTION_NONE,

    changedBy = "bootstrap",
}

local TRACKED_FIELDS = {
    "context",
    "combat",
    "pvpFlagged",
    "inInstance",
    "instanceType",

    "mounted",
    "resting",
    "onTaxi",

    "interacting",
    "interactionType",
}

local stateListeners = {}

local function copyState(source)
    return {
        initialized = source.initialized,
        revision = source.revision,

        context = source.context,
        combat = source.combat,
        pvpFlagged = source.pvpFlagged,
        inInstance = source.inInstance,
        instanceType = source.instanceType,

        mounted = source.mounted,
        resting = source.resting,
        onTaxi = source.onTaxi,

        interacting = source.interacting,
        interactionType = source.interactionType,

        changedBy = source.changedBy,
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

local function captureState()
    local inInstance, instanceType = IsInInstance()

    inInstance = inInstance and true or false
    instanceType = instanceType or "none"

    local onTaxi = UnitOnTaxi("player") and true or false
    local mounted = IsMounted() and not onTaxi

    return {
        context = inInstance and "instance" or "world",
        combat = InCombatLockdown() and true or false,
        pvpFlagged = UnitIsPVP("player") and true or false,
        inInstance = inInstance,
        instanceType = instanceType,

        mounted = mounted and true or false,
        resting = IsResting() and true or false,
        onTaxi = onTaxi,

        interacting = activeInteractionType ~= INTERACTION_NONE,
        interactionType = activeInteractionType,
    }
end

local function publishStateChange(previous, changes, reason)
    local current = copyState(State)

    for index = 1, #stateListeners do
        local subscription = stateListeners[index]

        if subscription.active then
            subscription.handler(
                copyState(current),
                previous and copyState(previous) or nil,
                copyChanges(changes),
                reason
            )
        end
    end
end

function Logres:GetState()
    return copyState(State)
end

function Logres:SubscribeState(handler)
    if type(handler) ~= "function" then
        error("Logres:SubscribeState requires a function handler")
    end

    local subscription = {
        active = true,
        handler = handler,
    }

    stateListeners[#stateListeners + 1] = subscription

    local function unsubscribe()
        subscription.active = false
    end

    return unsubscribe
end

function Logres:RefreshState(reason)
    reason = reason or "manual"

    local observed = captureState()
    local changes = {}

    if not State.initialized then
        for index = 1, #TRACKED_FIELDS do
            local key = TRACKED_FIELDS[index]
            changes[key] = {
                old = nil,
                new = observed[key],
            }
            State[key] = observed[key]
        end

        State.initialized = true
        State.revision = 1
        State.changedBy = reason

        publishStateChange(nil, changes, reason)
        return true
    end

    local previous = copyState(State)
    local changed = false

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

    if not changed then
        return false
    end

    State.revision = State.revision + 1
    State.changedBy = reason

    publishStateChange(previous, changes, reason)
    return true
end

local function refreshFromEvent(event, ...)
    if event == "PLAYER_FLAGS_CHANGED" or event == "UNIT_AURA" then
        local unit = ...
        if unit and unit ~= "player" then
            return
        end
    end

    if event == "PLAYER_ENTERING_WORLD" then
        -- Interactions should not survive world transitions. This also gives
        -- reload/login a conservative known baseline until a SHOW event arrives.
        activeInteractionType = INTERACTION_NONE
    end

    -- I-001 proved that combat-related state can settle across multiple events.
    -- Refresh from each authoritative signal rather than assuming one event is final.
    Logres:RefreshState(event)
end

local function interactionShow(event, interactionType)
    local numericType = tonumber(interactionType)

    if numericType == nil then
        -- Do not invent an interaction type when the documented payload is absent.
        return
    end

    activeInteractionType = numericType
    Logres:RefreshState(event)
end

local function interactionHide(event, interactionType)
    local numericType = tonumber(interactionType)

    if numericType ~= nil and numericType == activeInteractionType then
        activeInteractionType = INTERACTION_NONE
        Logres:RefreshState(event)
    end
end

local EVENTS = {
    "PLAYER_LOGIN",
    "PLAYER_ENTERING_WORLD",
    "ZONE_CHANGED_NEW_AREA",
    "PLAYER_REGEN_DISABLED",
    "PLAYER_REGEN_ENABLED",
    "PLAYER_FLAGS_CHANGED",
    "ADDON_RESTRICTION_STATE_CHANGED",

    "PLAYER_MOUNT_DISPLAY_CHANGED",
    "UNIT_AURA",
    "PLAYER_UPDATE_RESTING",
    "PLAYER_CONTROL_LOST",
    "PLAYER_CONTROL_GAINED",
}

for index = 1, #EVENTS do
    Logres:RegisterEvent(EVENTS[index], refreshFromEvent)
end

Logres:RegisterEvent("PLAYER_INTERACTION_MANAGER_FRAME_SHOW", interactionShow)
Logres:RegisterEvent("PLAYER_INTERACTION_MANAGER_FRAME_HIDE", interactionHide)
