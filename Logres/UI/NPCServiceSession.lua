-- P0304: service-neutral, event-driven NPC presentation entry and dismissal.
-- The native root remains shown, interactive, and Blizzard-owned. No native
-- setters, source payload reads, transactions, polling, camera or UI hiding.
local _, Logres = ...
local Session = {}
Logres.NPCServiceSession = Session

local services, hooked, dismissed = {}, {}, {}
local current, attempts, opens, deferrals, nativeHooks = nil, 0, 0, 0, 0
local readySignals, lastReady = 0, "none"
local last = "awaiting-native-service"

local function ordinary(value)
    if type(issecretvalue) ~= "function" then return false end
    local ok, secret = pcall(issecretvalue, value)
    return ok and secret == false
end

local function method(owner, name)
    if not ordinary(owner) then return nil end
    local ok, fn = pcall(function() return owner[name] end)
    if not ok or not ordinary(fn) or type(fn) ~= "function" then return nil end
    return fn
end

local function read(owner, name)
    local fn = method(owner, name)
    if not fn then return nil end
    local ok, value = pcall(fn, owner)
    if not ok or not ordinary(value) then return nil end
    return value
end

local function nativeRoot(spec)
    local ok, root = pcall(function() return _G[spec.nativeFrame] end)
    if not ok or not ordinary(root) or root == nil then return nil end
    if read(root, "IsProtected") ~= false then return nil end
    return root
end

local function inCombat()
    if type(InCombatLockdown) ~= "function" then return true end
    local ok, value = pcall(InCombatLockdown)
    return not (ok and ordinary(value) and value == false)
end

local function matches(spec)
    local state = Logres:GetState()
    return state and state.interacting == true
        and state.interactionType == spec.interactionType
end

-- Dismissal belongs to this NPC visit, not the service definition. Goodbye,
-- H OFF and a purchase request must not be undone by an unrelated state event.
function Session.Dismiss(key)
    if not services[key] then return false end
    dismissed[key] = true
    if current == key then current = nil end
    last = "dismissed-" .. key
    return true
end

function Session.TryOpen(key, reason)
    local spec = services[key]
    if not spec or not spec.automatic or dismissed[key] or not matches(spec)
        or inCombat() then return false, "not-ready" end
    local root = nativeRoot(spec)
    if not root or read(root, "IsShown") ~= true then
        return false, "stock-not-shown"
    end
    -- Only Logres-owned visibility is queried; no native presentation
    -- inspection beyond the existing source/protection gate above.
    local visibleOK, visible = pcall(spec.isVisible)
    if visibleOK and visible == true then current = key; return true, "already-visible" end
    attempts = attempts + 1
    local ok, shown = pcall(spec.open, reason or "native-shown")
    if not ok or shown ~= true then
        deferrals = deferrals + 1
        last = "open-deferred-" .. key
        return false, last
    end
    current = key
    opens = opens + 1
    last = "opened-" .. key
    return true, last
end

-- One precise callback per independently authorized native service frame.
-- No show reassertion hooks, periodic timers, SetScript replacement or polls.
local function attach(key, spec)
    if hooked[key] then return true end
    if inCombat() then return false end
    local root = nativeRoot(spec)
    local hook = root and method(root, "HookScript")
    if not hook then return false end
    local ok = pcall(hook, root, "OnShow", function()
        Session.TryOpen(key, "native-onshow")
    end)
    if ok then
        hooked[key] = true
        nativeHooks = nativeHooks + 1
    end
    return ok
end

function Session.Reconcile(reason)
    for key, spec in pairs(services) do
        if matches(spec) then
            if inCombat() then
                -- A trainer interaction interrupted by combat is not silently
                -- reactivated on regen; allow a fresh native visit instead.
                dismissed[key] = true
                if current == key then
                    current = nil
                    pcall(spec.close, "combat-ended-presentation")
                end
            else
                attach(key, spec)
                if not dismissed[key] then Session.TryOpen(key, reason) end
            end
        else
            dismissed[key] = nil
            if current == key then
                current = nil
                pcall(spec.close, "native-context-ended")
                last = "closed-" .. key
            end
        end
    end
end

-- Registry is shared; data, visuals, transactions and their error policies
-- are supplied by each service's existing dedicated modules.
function Session.Register(key, spec)
    if type(key) ~= "string" or #key < 1 or #key > 40
        or services[key] ~= nil or type(spec) ~= "table"
        or type(spec.interactionType) ~= "number"
        or type(spec.nativeFrame) ~= "string"
        or type(spec.loadedAddon) ~= "string"
        or type(spec.open) ~= "function" or type(spec.close) ~= "function"
        or type(spec.isVisible) ~= "function" then return false end
    services[key] = spec
    Session.Reconcile("service-registered")
    return true
end

Logres:RegisterEvent("ADDON_LOADED", function(_, name)
    for _, spec in pairs(services) do
        if name == spec.loadedAddon then
            Session.Reconcile("native-addon-loaded")
            return
        end
    end
end)

-- Source-specific readiness, not a timer or retry loop: state changes may
-- precede lazy trainer frame loading and the original native OnShow hook.
-- Both events still pass through Reconcile's interaction, combat and
-- stock-source gates; Goodbye/OFF dismissal suppresses same-visit reopen.
Logres:RegisterEvent("TRAINER_SHOW", function()
    readySignals = readySignals + 1
    lastReady = "TRAINER_SHOW"
    Session.Reconcile("trainer-show")
    if Logres.NPCTrainerLiveTrial then
        Logres.NPCTrainerLiveTrial.RefreshEmptyFromSource()
    end
end)
Logres:RegisterEvent("TRAINER_UPDATE", function()
    readySignals = readySignals + 1
    lastReady = "TRAINER_UPDATE"
    Session.Reconcile("trainer-update")
    if Logres.NPCTrainerLiveTrial then
        Logres.NPCTrainerLiveTrial.RefreshEmptyFromSource()
    end
end)

-- State.lua provides an already-normalized interaction type and lifecycle.
-- No separate camera handling and no Blizzard source payload is inspected.
Logres:SubscribeState(function()
    Session.Reconcile("npc-interaction-state")
end)

function Session.GetAudit()
    return {current=current or "none", opens=opens, attempts=attempts,
        deferrals=deferrals, last=last,
        nativeHooks=nativeHooks, readinessSignals=readySignals,
        lastReadinessEvent=lastReady, nativePresentationWrites=0,
        nativePresentation="unchanged-stock-visible"}
end

-- P0304 first consumer: the trainer reuses this lifecycle without handing
-- ownership of spell data, search, purchase or the approved visuals to it.
Session.Register("trainer", {
    interactionType=7, nativeFrame="ClassTrainerFrame",
    loadedAddon="Blizzard_TrainerUI", automatic=true,
    open=function() return Logres.NPCTrainerLiveTrial.Toggle("on") end,
    close=function(reason) return Logres.NPCTrainerLiveTrial.Disable(reason) end,
    isVisible=function() return Logres.NPCTrainerLiveTrial.GetAudit().shown end,
})

return Session
