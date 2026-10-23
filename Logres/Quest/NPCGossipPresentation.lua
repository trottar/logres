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
    -- Quest-only cases continue to use the existing Quest/Blizzard surfaces.
    if not node or not node.options or #node.options == 0 then
        last = "no-gossip-choices-stock-or-quest-owned"
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
    local d = dialogue()
    return {
        enabled = enabled, pending = pending,
        active = active and d.optionSession ~= nil
            and d.optionSession.liveReadOnly == true
            and d.presentationShown == true,
        opens = opens, deferrals = deferrals, closes = closes,
        last = last, kind = lastKind,
        nativeActions = 0, nativeWrites = 0, stock = "retained",
    }
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
