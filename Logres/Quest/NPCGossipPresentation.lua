-- P0317: live gossip -> approved Quest/NPC option visual, additive and inert.
-- This is event-driven presentation, never a native gossip action or stock hide.
local _, Logres = ...
local Live = {}
Logres.NPCGossipPresentation = Live

local enabled, pending, active = true, false, false
local opens, deferrals, closes = 0, 0, 0
local last = "awaiting-gossip"
local lastKind = "none"

local function dialogue()
    return Logres:GetModule("QuestDialogue")
end

local function hide(reason)
    pending = false
    local d = dialogue()
    if d.optionSession and d.optionSession.liveReadOnly == true then
        d:HidePresentation(reason or "gossip-closed")
        closes = closes + 1
    end
    active = false
    last = reason or "closed"
end

function Live.TryShow(reason)
    if not enabled or not pending then return false, "not-armed" end
    local d = dialogue()
    if not d.moduleEnabled or not d.immersionEnabled or not d.optionSession
        or d.completionActive or d.progressActive or d.activeDetail
        or (d.presentationShown and d.lastPresentationReason ~= "npc-options-read-only")
    then
        last = "quest-or-preview-owns-presentation"
        return false, last
    end
    local model, report = Logres.NPCGossipSource.Sample()
    if not model then
        last = report.status
        deferrals = deferrals + 1
        return false, last
    end
    lastKind = model.gossipKind
    local node = model.nodes and model.nodes[model.start]
    -- A gossip stage is a narrative, not necessarily a menu. Quest-only
    -- and direction-response text share the accepted narrative renderer;
    -- Blizzard retains all quest/service controls (no invented choices).
    if not node or type(node.options) ~= "table" then
        last = "gossip-model-node-unavailable"
        return false, last
    end
    local hasChoices = #node.options > 0
    local hasBody = type(node.body) == "string" and node.body ~= ""
    if not hasChoices and not hasBody then
        last = "no-displayable-gossip-stage"
        return false, last
    end
    local ok, state = d:ShowReadOnlyGossip(model)
    if not ok then
        last = state
        deferrals = deferrals + 1
        return false, state
    end
    active = true
    opens = opens + 1
    last = "live-additive-read-only-" .. (reason or "gossip")
    return true, last
end

function Live.GetAudit()
    local actions = Logres.NPCGossipChoice and Logres.NPCGossipChoice.GetAudit()
        or { attempts = 0 }
    local quest = Logres.NPCGossipQuestChoice and Logres.NPCGossipQuestChoice.GetAudit()
        or { attempts = 0, blocked = 0 }
    local d = dialogue()
    return {
        enabled = enabled, pending = pending,
        active = active and d.optionSession ~= nil
            and d.optionSession.liveReadOnly == true
            and d.presentationShown == true,
        opens = opens, deferrals = deferrals, closes = closes,
        last = last, kind = lastKind,
        nativeActions = actions.attempts, questActions = quest.attempts,
        questBlocked = quest.blocked, nativeWrites = 0, stock = "retained",
    }
end

-- User-selected native branches dismiss only the Logres overlay.
function Live.OnNativeChoice()
    hide("native-gossip-choice-issued")
end

function Live.Toggle()
    enabled = not enabled
    if not enabled then hide("gossip-live-disabled") end
    if enabled then last = "enabled-next-gossip" end
    return Live.GetAudit()
end

Logres:RegisterEvent("GOSSIP_SHOW", function()
    pending = true
    Live.TryShow("GOSSIP_SHOW")
end)
-- Frame-show order varies; one authoritative event retry, never polling.
Logres:RegisterEvent("PLAYER_INTERACTION_MANAGER_FRAME_SHOW", function()
    if pending and not active then Live.TryShow("interaction-show") end
end)
Logres:RegisterEvent("GOSSIP_CLOSED", function() hide("gossip-closed") end)
Logres:RegisterEvent("PLAYER_INTERACTION_MANAGER_FRAME_HIDE", function()
    if pending or active then hide("interaction-hidden") end
end)
for _, event in ipairs({"QUEST_DETAIL", "QUEST_PROGRESS", "QUEST_COMPLETE",
    "PLAYER_ENTERING_WORLD"}) do
    Logres:RegisterEvent(event, function()
        if pending or active then hide("gossip-handoff-" .. event) end
    end)
end

return Live
