local _, Logres = ...

-- P0178: single read-only ownership register for Blizzard / Logres surfaces.
-- Inspect only existing addon-owned diagnostic snapshots; do not query
-- protected Blizzard frame state or secret values for this report.
local surfaces, byID = {}, {}
local Audit = {}
Logres.UIOwnershipAudit = Audit

local function copy(entry)
    local out = {}
    for k, v in pairs(entry) do out[k] = v end
    return out
end

function Logres:RegisterUIOwnershipSurface(spec)
    if type(spec) ~= "table" or type(spec.id) ~= "string"
        or not spec.id:match("^[a-z][a-z0-9_]*$")
        or type(spec.blizzard) ~= "string" or spec.blizzard == ""
        or type(spec.logres) ~= "string" or spec.logres == ""
        or type(spec.evaluate) ~= "function" then
        error("Logres:RegisterUIOwnershipSurface invalid registration")
    end
    if byID[spec.id] then
        error("Duplicate Logres UI ownership surface: " .. spec.id)
    end
    local entry = copy(spec)
    byID[entry.id] = entry
    surfaces[#surfaces + 1] = entry
end

local function result(status, expected, observed, detail)
    return {
        status = status,
        expected = expected,
        observed = observed,
        detail = detail or "",
    }
end

local function stock(why)
    return function()
        -- STOCK means deliberate retention policy, never verification that a
        -- native Blizzard frame is currently displayed or interactive.
        return result("STOCK", "Blizzard retained", "not inspected", why)
    end
end

local function get(snapshot, name)
    if snapshot[name] ~= nil then return snapshot[name] end
    local ok, module = pcall(Logres.GetModule, Logres, name)
    if not ok then
        snapshot[name] = { unavailable = "module-unavailable" }
        return snapshot[name]
    end
    local moduleOK, status = pcall(module.GetDebugStatus, module)
    if not moduleOK or type(status) ~= "table" then
        snapshot[name] = { unavailable = "diagnostic-unavailable" }
    else
        snapshot[name] = status
    end
    return snapshot[name]
end

local function suppression(moduleName, desiredKey, requestedKey, appliedKey, pendingKey)
    requestedKey = requestedKey or "requestedEnabled"
    appliedKey = appliedKey or "appliedEnabled"
    pendingKey = pendingKey or "pending"
    return function(flags, snapshot)
        local d = get(snapshot, moduleName)
        local expected = flags[desiredKey] and "Logres owns" or "Blizzard restored"
        if d.unavailable then
            return result("DEFERRED", expected, "unavailable", d.unavailable)
        end
        local wanted = flags[desiredKey] == true
        local requested, applied = d[requestedKey], d[appliedKey]
        if d.lastError ~= nil then
            return result("FAIL", expected, "error", "module-error")
        end
        if requested == wanted and applied == wanted then
            return result("PASS", expected,
                applied and "Logres applied" or "Logres released")
        end
        if d[pendingKey] == true and flags.combat then
            return result("DEFERRED", expected, "combat pending")
        end
        return result("FAIL", expected,
            "requested=" .. tostring(requested) .. ",applied=" .. tostring(applied))
    end
end

local function hud(field, detail)
    return function(flags, snapshot)
        local d = get(snapshot, "HUD")
        local expected = flags.immersion and "Logres presentation" or "Logres hidden"
        if d.unavailable then
            return result("DEFERRED", expected, "unavailable", d.unavailable)
        end
        local ready = d[field] == true
        local shown = d.rootShown == true
        if not ready or shown ~= flags.immersion then
            return result("FAIL", expected, "ready=" .. tostring(ready)
                .. ",rootShown=" .. tostring(shown), detail)
        end
        return result("PASS", expected, shown and "Logres active" or "Logres hidden", detail)
    end
end

local function supplemental(moduleName, readyField, reason)
    return function(flags, snapshot)
        local d = get(snapshot, moduleName)
        local expected = flags.immersion and "Logres supplemental" or "Logres inactive"
        if d.unavailable then
            return result("DEFERRED", expected, "unavailable", d.unavailable)
        end
        local ready = d[readyField] == true
        if d.lastError ~= nil or d.failures and d.failures > 0
            or d.failureCount and d.failureCount > 0 then
            return result("FAIL", expected, "diagnostic error", reason)
        end
        if not ready then
            return result("DEFERRED", expected, "source or setup unavailable", reason)
        end
        return result("PASS", expected, "Logres source ready", reason)
    end
end

local function native(domain)
    return function(flags, snapshot)
        local d = get(snapshot, "NativeAccess")
        local expected = flags.immersion and "folded or user-open" or "native restored"
        if d.unavailable then
            return result("DEFERRED", expected, "unavailable", d.unavailable)
        end
        if d.lastError ~= nil or d.failures ~= 0 or d.refoldFailures ~= 0 then
            return result("FAIL", expected, "native access failure")
        end
        local mode = type(d.domains) == "string"
            and d.domains:match(domain .. ":([%a]+)/") or nil
        if not mode then return result("DEFERRED", expected, "domain unknown") end
        if flags.immersion then
            if mode == "folded" then
                return result("PASS", expected, "folded; dock fallback")
            elseif mode == "open" then
                return result("STOCK", "user-open", "Blizzard retained", "manual dock open")
            elseif flags.combat and d.pendingRefolds > 0 then
                return result("DEFERRED", expected, "combat pending")
            end
            return result("FAIL", expected, mode, "native domain not reconciled")
        end
        return result(mode == "native" and "PASS" or "FAIL", expected, mode)
    end
end

local function castGate(flags, snapshot)
    local d = get(snapshot, "NativeAccess")
    local expected = flags.immersion and "on-demand stock cast gate" or "stock cast retained"
    if d.unavailable then return result("DEFERRED", expected, "unavailable") end
    if d.castGateFailures ~= 0 or d.castGateEscapes ~= 0 then
        return result("FAIL", expected, "cast gate failure")
    end
    return result(d.castGateArmed == d.castGateExpected and "PASS" or "FAIL",
        expected, d.castGateArmed and "armed" or "not armed",
        "Blizzard cast fallback preserved")
end

local function offer(flags, snapshot)
    local d = get(snapshot, "QuestOfferStockSuppression")
    if d.unavailable then return result("DEFERRED", "conditional ownership", "unavailable") end
    if d.lastError ~= nil then
        return result("FAIL", "conditional ownership", "error")
    end
    if d.appliedEnabled == true then
        return result("PASS", "supported ordinary offer", "Logres shell+controls owned")
    end
    if d.pending and flags.combat then
        return result("DEFERRED", "supported ordinary offer", "combat pending")
    end
    return result("STOCK", "unsupported/no ordinary offer", "Blizzard retained",
        "progress/reward/gossip not covered")
end

local function aura(flags, snapshot)
    local d = get(snapshot, "StatusAuras")
    if d.unavailable then return result("DEFERRED", "additive status", "unavailable") end
    if d.failures ~= 0 or d.stockPreserved ~= true then
        return result("FAIL", "Blizzard aura retained", "status source error")
    end
    if not d.eventsReady or not d.source then
        return result("DEFERRED", "Blizzard aura retained", "source unavailable")
    end
    -- A structural PASS does not prove hostile or player harmful coverage.
    return result("STOCK", "Blizzard aura retained", "Logres additive lanes",
        "harmful live coverage remains unproven")
end

local function helpful(flags, snapshot)
    local d = get(snapshot, "PlayerHelpfulAuras")
    if d.unavailable then return result("DEFERRED", "additive player buffs", "unavailable") end
    if d.lastError ~= nil or d.failureCount ~= 0 then
        return result("FAIL", "additive player buffs", "source failure")
    end
    return result(d.sourceAvailable and "PASS" or "DEFERRED",
        "Blizzard global aura retained", d.sourceAvailable and "Logres HELPFUL|PLAYER ready" or "source unavailable",
        "partial helpful replacement, no global aura suppression")
end

local function questFocus(flags, snapshot)
    local d = get(snapshot, "ActiveQuest")
    if d.unavailable then return result("DEFERRED", "one-focus additive", "unavailable") end
    if d.lastError ~= nil then return result("FAIL", "one-focus additive", "error") end
    if not flags.immersion or not flags.activeQuest then
        return result("STOCK", "feature disabled", "Blizzard quest access retained")
    end
    return result("PASS", "one-focus additive", d.presentationShown and "Logres focus shown" or "Logres idle",
        "not full tracker replacement")
end

local function shell(moduleName, kind)
    return function(flags, snapshot)
        local base = suppression(moduleName, "immersion")(flags, snapshot)
        if base.status ~= "PASS" then return base end
        local d = get(snapshot, moduleName)
        if flags.immersion then
            local safe = d.snapshotReady == true
                and d.interactionMouseOwnedByLogres == true
                and d.stockMouseSuppressed == true
                and (kind == "player" or d.stockPresentationSuppressed == true)
            if not safe then
                return result("FAIL", "Logres owns", "incomplete interaction/suppression")
            end
        else
            if d.snapshotReady ~= false or d.interactionMouseOwnedByLogres ~= false then
                return result("FAIL", "Blizzard restored", "stale snapshot/interaction")
            end
        end
        return base
    end
end

local function chat(flags, snapshot)
    local base = suppression("QuietMode", "quiet")(flags, snapshot)
    if base.status ~= "PASS" then return base end
    local d = get(snapshot, "QuietMode")
    if flags.quiet and (d.chatFrameCount ~= d.suppressedChatFrameCount
        or d.tabCount ~= d.suppressedTabCount
        or d.persistentShownMatches ~= true) then
        return result("FAIL", "Logres quiet", "chat/tab presentation mismatch")
    end
    return base
end

local function bar(which)
    return function(flags, snapshot)
        local base = suppression("StockActionReplacement", "immersion")(flags, snapshot)
        if base.status ~= "PASS" or not flags.immersion then return base end
        local d = get(snapshot, "StockActionReplacement")
        local prefix = which == "bar2" and "secondary" or "utility"
        if d[prefix .. "Alpha"] ~= 0
            or d[prefix .. "FrameMouseEnabled"] ~= false
            or d[prefix .. "ButtonMouseEnabledCount"] ~= 0
            or d[prefix .. "RoutingEnabled"] ~= true
            or d[prefix .. "BindingsApplied"] ~= true then
            return result("FAIL", "Logres owns", "visual/mouse/routing mismatch", which)
        end
        return base
    end
end

-- Static baseline inventory from P0164 plus later proven Phase H domains.
-- Future capabilities add ONE registration and reuse existing module debug state.
local register = function(id, blizzard, logres, evaluate)
    Logres:RegisterUIOwnershipSurface({
        id = id, blizzard = blizzard, logres = logres, evaluate = evaluate,
    })
end

register("quiet_chat", "Passive chat/tabs", "QuietMode", chat)
register("player_frame", "PlayerFrame shell", "PlayerFrameReplacement", shell("PlayerFrameReplacement", "player"))
register("target_frame", "TargetFrame shell", "TargetFrameReplacement", shell("TargetFrameReplacement", "target"))
register("player_health", "Player health shell", "HUD health tunnel", hud("curvesReady", "exact HP intentionally absent"))
register("player_resource", "Player resource power", "HUD resource % bar", hud("resourceBarReady"))
register("target_name_health", "Target name/health", "HUD screen-space fallback", hud("targetFrameReady", "world anchor conditional"))
register("player_cast", "Player cast information", "HUD cast cue", hud("playerCastCueReady"))
register("target_cast", "Target cast information", "HUD target cast cue", hud("targetCastCueReady"))
register("allies", "Party/CompactPartyFrame", "HUD ally hints", stock("secure group/aura/interaction replacement incomplete"))
register("player_class", "Player class/runes/totems/alternate", "no full replacement", stock("player child resources preserved"))
register("pet_frame", "PetFrame", "no secure unit replacement", stock("pet unit interaction retained"))
register("pet_actions", "PetActionBar", "pet execution probe only", stock("edit/bind/full feedback unsupported"))
register("main_action", "MainActionBar", "Logres Primary partial routing", stock("secure special/edit fallback incomplete"))
register("special_actions", "Override/vehicle/possess/extra", "normal-page routing only", stock("special actions deliberately stock"))
register("bar2", "MultiBarBottomLeft", "Logres Secondary", bar("bar2"))
register("bar3", "MultiBarBottomRight", "Logres Utility", bar("bar3"))
register("bar4", "MultiBarRight", "Logres Bar4 routing", stock("stock presentation retained; routing is supplemental"))
register("bar5", "MultiBarLeft", "Logres Bar5 routing", stock("stock presentation retained; routing is supplemental"))
register("navigation", "Minimap/navigation", "native dock + compass", native("navigation"))
register("objectives", "ObjectiveTrackerFrame", "native dock + active quest", native("objectives"))
register("progress", "XP/status native", "native dock + contextual XP", native("progress"))
register("micro_menu", "Micro menu", "native dock fallback", native("menu"))
register("stock_cast", "Blizzard cast visuals", "cast gate / on-demand fallback", castGate)
register("full_quest", "QuestLog/full tracker", "one-focus only", stock("full quest log and watch remain accessible"))
register("quest_focus", "Focused quest presentation", "ActiveQuest", questFocus)
register("quest_offer", "Quest offer shell/Accept/Decline", "QuestOfferStockSuppression", offer)
register("quest_other", "Progress/Complete/rewards/gossip", "partial offer dialogue", stock("unsupported lifecycle and controls retained"))
register("player_buffs", "Global player buff auras", "PlayerHelpfulAuras", helpful)
register("player_debuffs", "Global player harmful auras", "StatusAuras", aura)
register("target_auras", "Target buff/debuff/status", "StatusAuras", aura)
register("target_of_target", "Target-of-target", "no replacement", stock("Blizzard-owned"))
register("focus_boss", "Focus/boss frames", "no replacement", stock("Blizzard-owned"))
register("nameplates", "Blizzard nameplates", "screen-space target fallback", stock("world anchor proof incomplete"))
register("xp_pulse", "Persistent XP completeness", "XP pulse", stock("contextual pulse not full replacement"))
register("objective_pulse", "Persistent objective progress", "Progress pulse", stock("contextual pulse not full replacement"))

function Audit.Capture()
    local state = Logres:GetState()
    local prefs = Logres:GetPreferences()
    local flags = {
        immersion = prefs.immersionEnabled == true,
        quiet = prefs.immersionEnabled == true and state.context == "world",
        context = state.context,
        combat = state.combat == true,
        pvp = state.pvpFlagged == true,
        activeQuest = prefs.activeQuestEnabled ~= false,
    }
    local snapshot, rows = {}, {}
    local summary = { PASS = 0, FAIL = 0, DEFERRED = 0, STOCK = 0 }
    for _, spec in ipairs(surfaces) do
        local ok, evaluated = pcall(spec.evaluate, flags, snapshot)
        local entry = ok and type(evaluated) == "table" and evaluated
            or result("FAIL", "registered policy", "checker error")
        if summary[entry.status] == nil then
            entry = result("FAIL", "registered policy", "invalid classification")
        end
        summary[entry.status] = summary[entry.status] + 1
        rows[#rows + 1] = {
            id = spec.id, blizzard = spec.blizzard, logres = spec.logres,
            status = entry.status, expected = entry.expected,
            observed = entry.observed, detail = entry.detail,
        }
    end
    return { flags = flags, rows = rows, counts = summary, total = #surfaces }
end
