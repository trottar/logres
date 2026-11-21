-- P0503 actual-source, event-ordered gossip -> service lease regression fixture.
local root = assert(arg[1], "repo root required")
local events, scheduled, traces = {}, {}, {}
local state = {interacting = true, interactionType = 3}
local model = {previewOnly=false, start=1, nodes={{options={{
    gossipOptionID=42, gossipStatus=0, enabled=false, label="Train",
}}}}, questSummary={available=0,active=0}, title="Trainer", gossipKind="gossip-only"}
local park, restore, selection, selectBehavior = false, 0, 0, "normal"
local allowTimer, requireParked = true, true
issecretvalue = function() return false end
InCombatLockdown = function() return false end
C_GossipInfo = {SelectOption=function(id)
    assert(id==42)
    selection = selection + 1
    assert(park or not requireParked, "stock gossip must remain safely offscreen through native choice")
    if selectBehavior == "error" then error("native select failure") end
    if selectBehavior == "synchronous-new-gossip" then
        events.GOSSIP_SHOW()
    end
end}
local d = {
    moduleEnabled=true, immersionEnabled=true,
    optionSession={liveReadOnly=true}, presentationShown=false,
    lastPresentationReason="none", completionActive=false,
    progressActive=false, activeDetail=false,
    ShowReadOnlyGossip=function(self)
        self.presentationShown=true
        self.lastPresentationReason="npc-options-read-only"
        return true, "shown"
    end,
    HidePresentation=function(self, reason)
        self.presentationShown=false
        self.lastPresentationReason=reason
        self.optionSession=nil
        return true
    end,
    ScheduleGossipOptionHandoff=function(self, ticket)
        if not allowTimer then return false end
        scheduled[#scheduled+1]=function()
            if Logres.NPCGossipPresentation then
                Logres.NPCGossipPresentation.OnChoiceHandoffTimeout(ticket)
            end
        end
        return true
    end,
}
Logres={
    GetModule=function(_,key) assert(key=="QuestDialogue");return d end,
    GetState=function() return state end,
    TraceEvent=function(_,domain,action,fields)
        traces[#traces+1]={domain=domain,action=action,fields=fields}
    end,
    RegisterEvent=function(_,event,callback) events[event]=callback end,
    NPCGossipSource={Sample=function() return model,{status="model-ready"} end},
    NPCGossipQuestChoice={CanSelect=function() return true end},
    NPCGossipStockParking={
        IsParked=function() return park end,
        RequestExit=function()
            if park then restore=restore+1;park=false end
            return true,"restored"
        end,
        TryPark=function()
            park=true;return true,"native-offscreen-requested-unverified"
        end,
        CloseGossip=function() park=false;return true,"closed" end,
    },
}
local function loadSource(path)
    local chunk=assert(loadfile(root.."/"..path))
    return chunk("Logres",Logres)
end
loadSource("Logres/Quest/NPCGossipPresentation.lua")
loadSource("Logres/Quest/NPCGossipChoice.lua")
local function open()
    state.interactionType=3
    d.optionSession={liveReadOnly=true}
    d.moduleEnabled=true;d.immersionEnabled=true
    d.presentationShown=false;d.lastPresentationReason="none"
    events.GOSSIP_SHOW()
    assert(park and d.presentationShown)
end
local function click()
    local ok,reason=Logres.NPCGossipChoice.Activate(model,1)
    assert(ok,reason)
end
-- Successful service: the old native frame remains parked during direct click,
-- GOSSIP_CLOSED, and until the service show; no stale timer may restore it.
open(); local r0=restore
click();assert(park and restore==r0)
events.GOSSIP_CLOSED();assert(park and d.presentationShown and restore==r0)
state.interactionType=7
events.PLAYER_INTERACTION_MANAGER_FRAME_SHOW()
assert(not park and not d.presentationShown and restore==r0+1)
local afterService=restore
scheduled[#scheduled]()
assert(restore==afterService,"stale timeout must not mutate next stage")
-- No following event: bounded timeout returns native stock and dismisses Logres.
open();r0=restore;click();events.GOSSIP_CLOSED()
scheduled[#scheduled]();assert(not park and restore==r0+1 and not d.presentationShown)
-- Nested gossip reappears synchronously within the native SelectOption call;
-- the old click must not dismiss the new owned stage or restore its stock.
open();r0=restore;selectBehavior="synchronous-new-gossip";click()
assert(park and d.presentationShown and restore==r0)
scheduled[#scheduled]();assert(park and restore==r0)
selectBehavior="normal"
-- An exceptional native selector must immediately fail open to usable stock.
Logres.NPCGossipPresentation.CancelChoiceHandoff("fixture-exit")
Logres.NPCGossipStockParking.RequestExit("fixture-exit")
open();r0=restore;selectBehavior="error"
local ok=Logres.NPCGossipChoice.Activate(model,1)
assert(not ok and not park and restore==r0+1 and not d.presentationShown)
selectBehavior="normal"
-- Without a one-shot scheduler, preserve the original restore-first path.
open();r0=restore;allowTimer=false;requireParked=false
local success=Logres.NPCGossipChoice.Activate(model,1)
assert(success and not park and restore==r0+1 and not d.presentationShown)
allowTimer=true;requireParked=true
-- Quest links do not opt in: default caller restores prior to native use.
open();r0=restore
local before,ticket=Logres.NPCGossipPresentation.BeforeNativeChoice()
assert(before and ticket==nil and not park and restore==r0+1)
Logres.NPCGossipPresentation.OnNativeChoice()
-- An immersion/module exit must invalidate the lease and restore native stock.
open();r0=restore;click()
Logres.NPCGossipPresentation.CancelChoiceHandoff("immersion-off")
Logres.NPCGossipStockParking.RequestExit("immersion-off")
assert(restore==r0+1 and not park)
scheduled[#scheduled]();assert(restore==r0+1)
print("P0503 actual-source gossip handoff: service, timeout, synchronous next stage, failure, no timer, quest, OFF PASS")
