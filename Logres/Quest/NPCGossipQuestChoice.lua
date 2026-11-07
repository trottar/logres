-- P0320: direct-click guarded quest-greeting navigation through native gossip.
-- Opens Blizzard quest detail/progress; NEVER accepts, completes or claims quests.
local _, Logres = ...
local Quest = {}
Logres.NPCGossipQuestChoice = Quest

local attempts, issued, blocked = 0, 0, 0
local last = "not-selected"

local function ordinary(value)
    if type(issecretvalue) ~= "function" then return false end
    local ok, secret = pcall(issecretvalue, value)
    return ok and secret == false
end

local function selector(kind)
    if kind ~= "available" and kind ~= "active" then return nil end
    if not ordinary(C_GossipInfo) then return nil end
    local key = kind == "available" and "SelectAvailableQuest" or "SelectActiveQuest"
    local ok, fn = pcall(function() return C_GossipInfo[key] end)
    if not ok or not ordinary(fn) or type(fn) ~= "function" then return nil end
    return fn
end

local function allowed(kind)
    local fn = selector(kind)
    if not fn then return nil, "quest-selector-unavailable" end
    if type(InCombatLockdown) ~= "function" then return nil, "combat-gate-unavailable" end
    local ok, combat = pcall(InCombatLockdown)
    if not ok or not ordinary(combat) or combat ~= false then
        return nil, "combat-or-unknown"
    end
    local state = Logres:GetState()
    if not state or state.interacting ~= true or not ordinary(state.interactionType)
        or type(state.interactionType) ~= "number" then
        return nil, "interaction-not-ready"
    end
    return fn
end

function Quest.CanSelect(kind)
    return allowed(kind) ~= nil
end

local function deny(reason)
    blocked = blocked + 1
    last = reason
    return false, reason
end

function Quest.Activate(model, index)
    -- No automatic quest selection. Only a direct addon option click enters here.
    if type(index) ~= "number" or index ~= math.floor(index)
        or index < 1 or index > 72 or type(model) ~= "table"
        or model.previewOnly ~= false or type(model.nodes) ~= "table" then
        return deny("invalid-quest-selection")
    end
    local original = model.nodes[model.start]
    local originalChoices = original and original.options
    local chosen = originalChoices and originalChoices[index]
    if type(originalChoices) ~= "table" or type(chosen) ~= "table"
        or (chosen.questKind ~= "available" and chosen.questKind ~= "active")
        or chosen.enabled ~= false or not ordinary(chosen.questID)
        or type(chosen.questID) ~= "number" or chosen.questID < 1
        or chosen.questID ~= math.floor(chosen.questID) then
        return deny("unverified-quest-row")
    end
    local fn, why = allowed(chosen.questKind)
    if not fn then return deny(why) end
    local fresh, audit = Logres.NPCGossipSource.Sample()
    if not fresh or not audit or audit.status ~= "model-ready"
        or fresh.title ~= model.title or fresh.gossipKind ~= model.gossipKind
        or type(fresh.questSummary) ~= "table" or type(model.questSummary) ~= "table"
        or fresh.questSummary.available ~= model.questSummary.available
        or fresh.questSummary.active ~= model.questSummary.active then
        return deny("quest-gossip-stage-changed")
    end
    local node = fresh.nodes and fresh.nodes[fresh.start]
    local current = node and node.options
    if type(current) ~= "table" or #current ~= #originalChoices then
        return deny("quest-list-changed")
    end
    for i = 1, #originalChoices do
        local a, b = originalChoices[i], current[i]
        if type(a) ~= "table" or type(b) ~= "table"
            or a.label ~= b.label or a.questKind ~= b.questKind
            or a.questID ~= b.questID or a.gossipOptionID ~= b.gossipOptionID
            or a.gossipStatus ~= b.gossipStatus then
            return deny("quest-or-gossip-row-changed")
        end
    end
    local restored = Logres.NPCGossipPresentation.BeforeNativeChoice()
    if not restored then return deny("native-quest-restore-deferred") end
    attempts = attempts + 1
    local ok = pcall(fn, chosen.questID)
    if not ok then return deny("native-quest-open-failed") end
    issued = issued + 1
    last = "native-quest-detail-requested"
    if Logres.NPCGossipPresentation and Logres.NPCGossipPresentation.OnNativeChoice then
        Logres.NPCGossipPresentation.OnNativeChoice()
    end
    return true, last
end

function Quest.GetAudit()
    return { attempts = attempts, issued = issued, blocked = blocked, last = last }
end


-- P0386: QuestFrame QUEST_GREETING ownership, separate from GossipFrame.
-- No native quest acceptance/claim; only user-selected native quest navigation.
-- A complete Logres option list is required BEFORE stock parking. Every
-- unsupported capability fails open to Blizzard's original QuestFrame.
local Greeting = {}
Logres.QuestGreetingControl = Greeting

local parked, hookInstalled = nil, false
local attempts, shows, restores, deferrals, clicks, failures = 0, 0, 0, 0, 0, 0
local last = "not-attempted"
local retry = CreateFrame("Frame")

local function ordinary(value)
    if type(issecretvalue) ~= "function" then return false end
    local ok, secret = pcall(issecretvalue, value)
    return ok and secret == false
end

local function fn(name)
    local ok, value = pcall(function() return _G[name] end)
    if ok and ordinary(value) and type(value) == "function" then return value end
end

local function member(object, name)
    if not ordinary(object) then return nil end
    local ok, value = pcall(function() return object[name] end)
    if ok and ordinary(value) then return value end
end

local function method(object, name)
    local value = member(object, name)
    if type(value) == "function" then return value end
end

local function read(object, name)
    local f = method(object, name)
    if not f then return nil end
    local ok, value = pcall(f, object)
    if ok and ordinary(value) then return value end
end

local function unlocked()
    local f = fn("InCombatLockdown")
    if not f then return false end
    local ok, value = pcall(f)
    return ok and ordinary(value) and value == false
end

local function count(name)
    local f = fn(name)
    if not f then return nil, "count-api-unavailable" end
    local ok, value = pcall(f)
    if not ok or not ordinary(value) or type(value) ~= "number"
        or value ~= math.floor(value) or value < 0 or value > 24 then
        return nil, "count-unsafe-or-overflow"
    end
    return value
end

local function safeText(value)
    if not ordinary(value) or type(value) ~= "string" or value == ""
        or #value > 2048 then return nil end
    return value
end

local function selector(kind)
    if kind == "available" then return fn("SelectAvailableQuest") end
    if kind == "active" then return fn("SelectActiveQuest") end
end

function Greeting.CanSelect(kind)
    return unlocked() and selector(kind) ~= nil
end

-- All available and active titles must be ordinary. No truncated list is
-- rendered as if it were an actionable full replacement.
function Greeting.ReadModel()
    local available, aWhy = count("GetNumAvailableQuests")
    local active, bWhy = count("GetNumActiveQuests")
    if available == nil then return nil, "available-" .. aWhy end
    if active == nil then return nil, "active-" .. bWhy end
    if available + active == 0 or available + active > 24 then
        return nil, "empty-or-overflow-greeting"
    end
    if (available > 0 and not Greeting.CanSelect("available"))
        or (active > 0 and not Greeting.CanSelect("active")) then
        return nil, "quest-selection-unsupported"
    end
    local text = fn("GetGreetingText")
    if not text then return nil, "greeting-text-api-unavailable" end
    local textOK, body = pcall(text)
    if not textOK or not safeText(body) then
        return nil, "greeting-text-unavailable"
    end
    local options = {}
    for _, row in ipairs({
        {kind = "available", n = available, read = "GetAvailableTitle"},
        {kind = "active", n = active, read = "GetActiveTitle"},
    }) do
        local titleFn = fn(row.read)
        if row.n > 0 and not titleFn then return nil, "title-api-unavailable" end
        for index = 1, row.n do
            local ok, title = pcall(titleFn, index)
            title = ok and safeText(title) or nil
            if not title then return nil, "title-not-ordinary" end
            options[#options + 1] = {
                label = (row.kind == "available" and "Quest: " or "Quest in progress: ") .. title,
                title = title, questKind = row.kind, questIndex = index,
                enabled = false, reason = "Blizzard quest selection is the fallback",
            }
        end
    end
    local title = "Quests"
    local nameFn = fn("UnitName")
    if nameFn then
        local ok, value = pcall(nameFn, "npc")
        if ok then title = safeText(value) or title end
    end
    local model = Logres.NPCOptionModel.FromValidated(title, "greeting", {
        greeting = {title = title, body = body, options = options},
    })
    model.questGreeting = true
    return model, "ordinary-quest-greeting-model"
end

local function defer(reason)
    deferrals = deferrals + 1
    last = reason
    Logres:TraceEvent("quest", "greeting-native-fallback", {reason = reason})
    return false, reason
end

-- Capture secret-capable anchor components as OPAQUE restoration tokens.
-- Never inspect, compare, format or persist their values.
local function anchors(root)
    local n, get = read(root, "GetNumPoints"), method(root, "GetPoint")
    if type(n) ~= "number" or n < 1 or n > 8
        or n ~= math.floor(n) or not get then return nil end
    local tokens = {}
    for index = 1, n do
        local ok, p, relative, rp, x, y = pcall(get, root, index)
        if not ok then return nil end
        tokens[index] = {p, relative, rp, x, y}
    end
    return tokens
end

function Greeting.IsParked()
    return parked ~= nil
end

function Greeting.Restore(reason)
    if not parked then return true, "native-stock-visible" end
    if not unlocked() then
        parked.pending = true
        retry:RegisterEvent("PLAYER_REGEN_ENABLED")
        return defer("restore-deferred-combat")
    end
    local saved = parked
    local ok = pcall(function()
        saved.clear(saved.root)
        for i = 1, #saved.points do
            local p = saved.points[i]
            saved.set(saved.root, p[1], p[2], p[3], p[4], p[5])
        end
    end)
    if not ok then
        failures = failures + 1
        saved.pending = true
        retry:RegisterEvent("PLAYER_REGEN_ENABLED")
        -- Emergency visible fallback if original anchors cannot be restored.
        pcall(function()
            saved.clear(saved.root)
            saved.set(saved.root, "CENTER", UIParent, "CENTER", 0, 0)
        end)
        return defer("restore-failed-emergency-visible")
    end
    parked = nil
    retry:UnregisterEvent("PLAYER_REGEN_ENABLED")
    restores = restores + 1
    last = reason or "stock-restored"
    Logres:TraceEvent("quest", "greeting-stock-restored", {reason = last})
    return true, last
end

retry:SetScript("OnEvent", function(_, event)
    if event == "PLAYER_REGEN_ENABLED" and parked and parked.pending then
        local restored = Greeting.Restore("combat-ended")
        if restored then
            local dialogue = Logres:GetModule("QuestDialogue")
            if dialogue and dialogue.optionSession
                and dialogue.optionSession.questGreeting == true then
                dialogue:HidePresentation("greeting-restored-after-combat")
            end
        end
    end
end)

local function tryPark()
    if parked then return defer("prior-restore-pending") end
    if not unlocked() then return defer("combat-or-unknown") end
    local rootOK, root = pcall(function() return _G.QuestFrame end)
    if not rootOK or not ordinary(root) or not root
        or read(root, "IsProtected") ~= false or read(root, "IsShown") ~= true then
        return defer("native-root-absent-protected-or-hidden")
    end
    local clear, set, hook = method(root, "ClearAllPoints"),
        method(root, "SetPoint"), method(root, "HookScript")
    local points = anchors(root)
    if not clear or not set or not hook or not points
        or not ordinary(UIParent) then
        return defer("native-anchor-capability-unavailable")
    end
    if not hookInstalled then
        local ok = pcall(hook, root, "OnHide", function()
            if parked then
                local restored = Greeting.Restore("native-frame-hidden")
                if restored then
                    local dialogue = Logres:GetModule("QuestDialogue")
                    if dialogue and dialogue.optionSession
                        and dialogue.optionSession.questGreeting == true then
                        dialogue:HidePresentation("greeting-native-frame-hidden")
                    end
                end
            end
        end)
        if not ok then return defer("native-hide-hook-unavailable") end
        hookInstalled = true
    end
    parked = {root = root, clear = clear, set = set, points = points,
        pending = false}
    local moved = pcall(function()
        clear(root)
        set(root, "TOPRIGHT", UIParent, "BOTTOMLEFT", -64, -64)
    end)
    if not moved then
        failures = failures + 1
        Greeting.Restore("move-rollback")
        return defer("native-move-failed")
    end
    last = "native-offscreen-requested-unverified"
    return true, last
end

function Greeting.TryShow(dialogue)
    if not dialogue or not dialogue.moduleEnabled or not dialogue.immersionEnabled
        or dialogue.activeDetail or dialogue.completionActive or dialogue.progressActive
        or dialogue.presentationShown then
        return defer("another-view-or-immersion-off")
    end
    local model, why = Greeting.ReadModel()
    if not model then return defer(why) end
    local ok, state = dialogue:ShowReadOnlyQuestGreeting(model)
    if not ok then return defer(state) end
    local parkedOK, parkedReason = tryPark()
    if not parkedOK then
        -- Never leave two quest windows competing for input.
        dialogue:HidePresentation("greeting-native-stock-owned")
        return false, parkedReason
    end
    attempts = attempts + 1
    shows = shows + 1
    last = "logres-greeting-owned"
    Logres:TraceEvent("quest", "greeting-owned", {
        result = last, choices = #model.nodes.greeting.options,
    })
    return true, last
end

local function sameList(a, b)
    if not a or not b or not a.questGreeting or not b.questGreeting then
        return false
    end
    local aa = a.nodes.greeting.options
    local bb = b.nodes.greeting.options
    if a.title ~= b.title or #aa ~= #bb then return false end
    for i = 1, #aa do
        if aa[i].title ~= bb[i].title
            or aa[i].questKind ~= bb[i].questKind
            or aa[i].questIndex ~= bb[i].questIndex then return false end
    end
    return true
end

function Greeting.Activate(model, index)
    local dialogue = Logres:GetModule("QuestDialogue")
    if not parked or not dialogue or not dialogue.presentationShown
        or not dialogue.optionSession or dialogue.optionSession.questGreeting ~= true
        or type(index) ~= "number" or index ~= math.floor(index)
        or type(model) ~= "table" or model.questGreeting ~= true then
        return defer("greeting-choice-not-owned")
    end
    local options = model.nodes and model.nodes.greeting and model.nodes.greeting.options
    local chosen = options and options[index]
    if type(chosen) ~= "table" or chosen.enabled ~= false
        or (chosen.questKind ~= "available" and chosen.questKind ~= "active") then
        return defer("greeting-choice-invalid")
    end
    local fresh, why = Greeting.ReadModel()
    if not fresh or not sameList(model, fresh) then
        Greeting.Restore("greeting-changed")
        dialogue:HidePresentation("greeting-native-fallback")
        return defer(why or "greeting-list-changed")
    end
    local selectFn = selector(chosen.questKind)
    if not selectFn or not unlocked() then return defer("selector-no-longer-available") end
    -- Restore native QuestFrame BEFORE dispatch, then allow Blizzard to drive
    -- QUEST_DETAIL/QUEST_PROGRESS and their existing Logres controllers.
    if not Greeting.Restore("native-quest-selected") then
        return defer("native-restore-pending")
    end
    dialogue:HidePresentation("greeting-native-selection")
    clicks = clicks + 1
    local ok = pcall(selectFn, chosen.questIndex)
    if not ok then return defer("native-quest-selection-failed") end
    last = "native-quest-selection-issued"
    Logres:TraceEvent("quest", "greeting-quest-selected", {
        kind = chosen.questKind, index = chosen.questIndex, result = last,
    })
    return true, last
end

function Greeting.Goodbye()
    local dialogue = Logres:GetModule("QuestDialogue")
    if not Greeting.Restore("greeting-goodbye") then
        return false, "native-restore-pending"
    end
    if dialogue then dialogue:HidePresentation("greeting-goodbye") end
    local close = fn("CloseQuest")
    if not close or not unlocked() then
        return true, "native-goodbye-available"
    end
    local ok = pcall(close)
    if not ok then return true, "native-goodbye-available" end
    return true, "native-greeting-closed"
end

-- An interaction ending is an authoritative exit, not a visual polling hook.
Logres:RegisterEvent("PLAYER_INTERACTION_MANAGER_FRAME_HIDE", function()
    if parked then
        local ok = Greeting.Restore("interaction-ended")
        if ok then
            local dialogue = Logres:GetModule("QuestDialogue")
            if dialogue and dialogue.optionSession
                and dialogue.optionSession.questGreeting == true then
                dialogue:HidePresentation("greeting-interaction-ended")
            end
        end
    end
end)

function Greeting.GetAudit()
    return {parked = parked ~= nil, pending = parked and parked.pending == true,
        attempts = attempts, shows = shows, restores = restores,
        deferrals = deferrals, failures = failures, clicks = clicks, last = last}
end
return Quest
