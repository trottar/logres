-- P0317: live gossip -> approved Quest/NPC option visual, additive and inert.
-- This is event-driven presentation, never a native gossip action or stock hide.
local _, Logres = ...
local Live = {}
Logres.NPCGossipPresentation = Live

local enabled, pending, active = true, false, false
local opens, deferrals, closes = 0, 0, 0
local last = "awaiting-gossip"
local lastKind = "none"
-- P0503: a validated gossip option may open a Blizzard-owned service. Keep
-- GossipFrame parked only across that one direct click's bounded handoff;
-- quest choices, unsupported actions and ordinary exits still restore first.
local choiceTicket, choiceSerial = nil, 0
local choiceHolds, choiceTimeouts, choiceFailures = 0, 0, 0
local choiceOutcome = "idle"

local function ordinary(value)
    if type(issecretvalue) ~= "function" then return false end
    local ok, secret = pcall(issecretvalue, value)
    return ok and secret == false
end

local function dialogue()
    return Logres:GetModule("QuestDialogue")
end

local function hide(reason)
    choiceTicket = nil
    local restored = Logres.NPCGossipStockParking.RequestExit(reason or "gossip-closed")
    if not restored then
        last = "stock-restoration-pending"
        return false
    end
    pending = false
    local d = dialogue()
    if d.optionSession and d.optionSession.liveReadOnly == true
        and d.optionSession.questGreeting ~= true then
        d:HidePresentation(reason or "gossip-closed")
        closes = closes + 1
    end
    active = false
    last = reason or "closed"
    Logres:TraceEvent("gossip", "hidden", {reason = last})
    return true
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
    -- Native UI is parked only after the complete Logres presentation exists.
    -- If parking is unsupported, do not leave TWO competing windows open.
    -- Return ownership to the usable native gossip surface, not a blind hide.
    local parked, parkingReason = Logres.NPCGossipStockParking.TryPark(model)
    if not parked then
        d:HidePresentation("gossip-native-owner")
        pending = false  -- next intentional GOSSIP_SHOW re-arms; never poll
        active = false
        deferrals = deferrals + 1
        last = "native-gossip-stock-owned"
        Logres:TraceEvent("gossip", "stock-owned",
            {reason = parkingReason or "parking-unsupported"})
        return false, last
    end
    active = true
    opens = opens + 1
    last = "live-parked-read-only-" .. (reason or "gossip")
    Logres:TraceEvent("gossip", "shown", {kind = lastKind,
        parked = parked, result = parkingReason})
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
        choiceHandoffPending = choiceTicket ~= nil,
        choiceHandoffHolds = choiceHolds, choiceHandoffTimeouts = choiceTimeouts,
        choiceHandoffFailures = choiceFailures, choiceHandoffOutcome = choiceOutcome,
    }
end

-- Quest links and unsupported paths MUST restore stock before invoking a
-- native action. Only a directly validated gossip option can hold the already
-- parked unprotected GossipFrame, and only with an armed one-shot fallback.
function Live.BeforeNativeChoice(kind)
    if choiceTicket ~= nil then return false, "choice-handoff-pending" end
    if kind == "gossip-option" and active
        and Logres.NPCGossipStockParking.IsParked() then
        local d = dialogue()
        choiceSerial = choiceSerial + 1
        local ticket = choiceSerial
        choiceTicket = ticket
        if d.ScheduleGossipOptionHandoff and d:ScheduleGossipOptionHandoff(ticket) then
            choiceHolds = choiceHolds + 1
            choiceOutcome = "held-before-native-option"
            return true, ticket
        end
        choiceTicket = nil
        choiceOutcome = "timer-unavailable-stock-fallback"
    end
    local restored = Logres.NPCGossipStockParking.RequestExit("native-choice-handoff")
    return restored, nil
end

-- A failed native SelectOption must immediately return its original window;
-- a successful call waits for the next authoritative interaction event or
-- a one-shot timeout. No native visual state is inspected to confirm parking.
function Live.OnNativeChoiceFailed(ticket)
    if ticket ~= nil and ticket ~= choiceTicket then return false end
    choiceFailures = choiceFailures + 1
    choiceOutcome = "native-option-call-failed"
    return hide("native-option-failed-stock-fallback")
end

function Live.OnChoiceHandoffTimeout(ticket)
    if ticket == nil or ticket ~= choiceTicket then return end
    choiceTimeouts = choiceTimeouts + 1
    choiceOutcome = "no-next-stage-stock-restored"
    Logres:TraceEvent("gossip", "choice-handoff-timeout", {result = choiceOutcome})
    hide("native-choice-handoff-timeout")
end

function Live.CancelChoiceHandoff(reason)
    if choiceTicket == nil then return end
    choiceTicket = nil
    choiceOutcome = reason or "other-dialogue-exit"
end

function Live.OnStockRestored()
    hide("deferred-stock-restored")
end

-- Goodbye closes native gossip when the guarded API supports it; on failure,
-- native anchors are restored and its stock Goodbye remains accessible.
function Live.Goodbye()
    local closed, reason = Logres.NPCGossipStockParking.CloseGossip()
    if Logres.NPCGossipStockParking.IsParked() then return false, reason end
    hide("gossip-goodbye")
    return true, closed and "native-gossip-closed" or "native-stock-restored"
end

-- User-selected native branches dismiss only the Logres overlay.
function Live.OnNativeChoice(ticket)
    if ticket ~= nil then
        -- A synchronous GOSSIP_SHOW or service event may already have taken
        -- ownership. Never dismiss the replacement stage with a stale click.
        if ticket ~= choiceTicket then return true, "next-stage-already-observed" end
        choiceOutcome = "waiting-for-native-branch"
        Logres:TraceEvent("gossip", "choice-handoff-held", {result = choiceOutcome})
        return true, choiceOutcome
    end
    return hide("native-gossip-choice-issued")
end

function Live.Toggle()
    enabled = not enabled
    if not enabled then hide("gossip-live-disabled") end
    if enabled then last = "enabled-next-gossip" end
    return Live.GetAudit()
end

Logres:RegisterEvent("GOSSIP_SHOW", function()
    local replacing = choiceTicket ~= nil
    if replacing then
        choiceTicket = nil
        choiceOutcome = "next-gossip-stage"
    end
    pending = true
    local shown = Live.TryShow("GOSSIP_SHOW")
    if replacing and not shown then hide("next-gossip-stock-fallback") end
end)
-- Frame-show order varies; one authoritative event retry, never polling.
Logres:RegisterEvent("PLAYER_INTERACTION_MANAGER_FRAME_SHOW", function()
    if choiceTicket ~= nil then
        local state = Logres:GetState()
        local kind = state and state.interactionType
        -- The addon state publishes ordinary interaction type 3 for gossip;
        -- type 7 is observed for the class-trainer destination. Any other
        -- ordinary interaction type is a new native owner, not a gossip page.
        if state and state.interacting == true and ordinary(kind)
            and type(kind) == "number" and kind ~= 3 then
            choiceOutcome = "native-service-opened"
            hide("native-branch-service-open")
            return
        end
    end
    if pending and not active then Live.TryShow("interaction-show") end
end)
Logres:RegisterEvent("GOSSIP_CLOSED", function()
    if choiceTicket ~= nil then
        -- Native close commonly precedes service-open by one event interval.
        -- Restoring here is the measured trainer flash candidate.
        choiceOutcome = "gossip-closed-awaiting-branch"
        return
    end
    hide("gossip-closed")
end)
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
