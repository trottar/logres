-- P0473 actual-source quest focus behavior fixture; no client claim.
local root = assert(arg[1], "source root argument missing")
local modules = {}
local L = {Theme={questDialogue={assets={pageChevron="texture"}}}}
function L:RegisterModule(name, options)
    local obj = {options=options, enabled=true}
    function obj:IsEnabled() return self.enabled end
    modules[name] = obj
    return obj
end
function L:GetModule(name) return assert(modules[name], name) end
local secret = {secret=true}
local entries = {0, 101, 202, 303, 202}
local focused, selected = 101, 0
local calls, refused, lag = {}, false, false
local countSecret, indexSecret = false, false
local env = {
    issecretvalue = function(value) return value == secret end,
    C_QuestLog = {
        GetNumQuestLogEntries = function()
            return countSecret and secret or #entries
        end,
        GetQuestIDForLogIndex = function(index)
            if indexSecret and index == 3 then return secret end
            if entries[index] == 0 then return nil end
            return entries[index]
        end,
        GetSelectedQuest = function() return selected end,
    },
    C_SuperTrack = {
        GetSuperTrackedQuestID = function() return focused end,
        SetSuperTrackedQuestID = function(questID)
            if refused then error("native refused") end
            calls[#calls+1] = questID
            if not lag then focused = questID end
        end,
    },
}
setmetatable(env, {__index=_G})
assert(loadfile(root .. "/Logres/Quest/Progress.lua", "t", env))(nil,L)
assert(loadfile(root .. "/Logres/Quest/ActiveQuest.lua", "t", env))(nil,L)
local P=modules.QuestObjectiveProgress
local A=modules.ActiveQuest
A.moduleEnabled=true;A.immersionEnabled=true;A.activeQuestEnabled=true
A.cycleAttempts=0;A.previewMode=nil
local refreshes=0
function A:Refresh() refreshes=refreshes+1;return true end
local ids,reason=P:ReadCycleQuestIDs()
assert(reason=="cycle-log-ready" and #ids==3 and ids[1]==101 and ids[2]==202 and ids[3]==303)
assert(A:CycleFocusedQuest("button") and focused==202 and A.lastCycleQuestID==202)
assert(A:CycleFocusedQuest("button") and focused==303)
assert(A:CycleFocusedQuest("button") and focused==101,"last-to-first wrap")
assert(refreshes==3 and A.cycleAttempts==3)
assert(env.Logres_NextFocusedQuest, "Bindings.xml global missing")
env.Logres_NextFocusedQuest();assert(focused==202 and refreshes==4)
-- Native selected-quest fallback when no supertrack ID.
focused=0; selected=202
assert(A:CycleFocusedQuest("binding") and focused==303)
-- Quest not in log starts at first available; no list mutation.
focused=8000;selected=0
assert(A:CycleFocusedQuest("binding") and focused==101)
-- Header rows and duplicates are ignored. One quest cannot cycle.
entries={101};focused=101
local before=#calls
local ok,why=A:CycleFocusedQuest("button")
assert(not ok and why=="cycle-no-alternative" and #calls==before)
entries={101,202,303};focused=101
indexSecret=true;before=#calls
ok,why=A:CycleFocusedQuest("button")
assert(not ok and why=="cycle-quest-secret" and #calls==before)
indexSecret=false;countSecret=true
ok,why=A:CycleFocusedQuest("button")
assert(not ok and why=="cycle-log-count-secret" and #calls==before)
countSecret=false
refused=true;ok,why=A:CycleFocusedQuest("button")
assert(not ok and why=="cycle-set-refused" and #calls==before)
refused=false;lag=true
ok,why=A:CycleFocusedQuest("button")
assert(ok and why=="cycle-requested-unconfirmed" and #calls==before+1 and focused==101)
lag=false;before=#calls
A.previewMode="normal";ok,why=A:CycleFocusedQuest("button")
assert(not ok and why=="cycle-presentation-inactive" and #calls==before)
A.previewMode=nil;A.immersionEnabled=false
ok,why=A:CycleFocusedQuest("binding")
assert(not ok and #calls==before)
A.immersionEnabled=true;A.activeQuestEnabled=false
ok,why=A:CycleFocusedQuest("button")
assert(not ok and #calls==before)
A.activeQuestEnabled=true;A.enabled=false
env.Logres_NextFocusedQuest();assert(#calls==before,"disabled module binding must not mutate")
A.enabled=true
print("P0473 actual-source focus cycle, wrap, native precedence, binding, rejection and OFF/preview PASS")
