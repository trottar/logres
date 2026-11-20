-- P0498 actual-source stage bridge, rollback, and native claim restoration fixture.
local root = arg[0]:gsub('tools/test_p0498_quest_bridge.lua$', '')
local logs, queue = {}, {}
function issecretvalue(_) return false end
function InCombatLockdown() return false end
local questID = 88
function GetQuestID() return questID end
C_Timer = {After=function(seconds, callback)
    assert(seconds == 0.05)
    queue[#queue+1] = callback
end}
local modules={}
local Logres = {Theme={panelSurface={colors={}},questOfferControls={colors={}}}, PanelConfigs={quest={presentation={colors={}}}}}
function Logres:RegisterModule(name)
    local owner={}
    modules[name]=owner
    return owner
end
function Logres:GetModule(name) return modules[name] end
function Logres:TraceEvent(domain,action,fields)
    logs[#logs+1]={domain=domain, action=action, fields=fields}
end
assert(loadfile(root..'Logres/Quest/CompletionControl.lua'))('Logres',Logres)
assert(loadfile(root..'Logres/Quest/Dialogue.lua'))('Logres',Logres)
local Dialogue=modules.QuestDialogue
local Control=Logres.QuestCompletionControl
local function frame()
    return {alpha=0.61, mouse=true,
        GetAlpha=function(self)return self.alpha end,
        SetAlpha=function(self,v)self.alpha=v end,
        EnableMouse=function(self,v)self.mouse=v end,
        IsProtected=function()return false end,
        Hide=function(self)self.shown=false end,
        Show=function(self)self.shown=true end,
    }
end
local native,child = frame(),frame()
local snap={frame=native,alpha=native.alpha,mouseFrames={
    {frame=native,mouseEnabled=true},{frame=child,mouseEnabled=true},
}}
local suppressed,captured,restored=0,0,0
local changedChild=false
local changedFrame=frame()
changedFrame.IsProtected=function() return true end
local stageChildren=nil
local stock={}
function stock:CanBridgeVisual(snapshot)
    for _,entry in ipairs(snapshot.mouseFrames) do
        if entry.frame:IsProtected() then return false end
    end
    return true
end
function stock:CaptureOfferPresentation()
    captured=captured+1
    local entries={{frame=native,mouseEnabled=native.mouse}}
    if stageChildren then
        for _,f in ipairs(stageChildren) do
            entries[#entries+1]={frame=f,mouseEnabled=f.mouse}
        end
    else
        local f=changedChild and changedFrame or child
        entries[#entries+1]={frame=f,mouseEnabled=f.mouse}
    end
    return {frame=native,alpha=native.alpha,mouseFrames=entries}
end
function stock:SuppressOfferPresentation(s)
    suppressed=suppressed+1
    s.frame:SetAlpha(0)
    for _,v in ipairs(s.mouseFrames) do v.frame:EnableMouse(false) end
end
function stock:RestoreOfferPresentation(s)
    restored=restored+1
    for _,v in ipairs(s.mouseFrames) do v.frame:EnableMouse(v.mouseEnabled) end
    s.frame:SetAlpha(s.alpha)
end
function stock:EmergencyRestoreOfferPresentation(s)
    self:RestoreOfferPresentation(s)
    return true
end
modules.QuestOfferStockSuppression=stock
local function makeDialogue()
    native.alpha=0
    native.mouse=false;child.mouse=false
    local d=setmetatable({
        progressOwned=true,progressContinuePending=true,
        progressStockModule=stock,progressStockSnapshot=snap,
        timerAvailable=true,lastQuestID=88,presentationGeneration=1,
        moduleEnabled=true,immersionEnabled=true,presentationShown=true,
        completionActive=true,lastPresentationReason='QUEST_COMPLETE',
        offerActionRoot=frame(),
    },{__index=Dialogue})
    return d
end
-- Successful stage transition keeps native invisible without a second
-- capture/suppress or a brief frame-restoration gap.
local d=makeDialogue()
local bridge,why=d:BeginProgressCompletionBridge()
assert(bridge and why=='held' and native.alpha==0 and not native.mouse)
assert(d.progressOwned==false and d.progressStockSnapshot==nil)
local control=Control.New(d,frame())
control.Gate=function()return true,'supported',0 end
local beforeSuppressed=suppressed
local beforeCaptured=captured
assert(d:ValidateProgressCompletionBridge(bridge)==true)
assert(captured==beforeCaptured+1, 'read-only final subtree validation required')
assert(control:Activate()==true)
assert(suppressed==beforeSuppressed and captured==beforeCaptured+1,
    'adoption must not suppress/capture the already suppressed subtree')
assert(control.snapshot==snap)
assert(d:EndProgressCompletionBridge('adopted',true))
for _,callback in ipairs(queue) do callback() end
queue={}
assert(restored==0 and native.alpha==0)
local nativeClick=0
function QuestRewardCompleteButton_OnClick()
    assert(native.alpha==0.61 and native.mouse and child.mouse,
        'native controls must be restored BEFORE native claim handler')
    nativeClick=nativeClick+1
end
d.BeginNativeQuestHandoff=function()end
assert(control:Click())
assert(nativeClick==1 and restored==1 and native.alpha==0.61)
-- Changed native child identity is detected when the next QUEST_COMPLETE
-- tries to adopt the held progress token; stock is restored on refusal.
changedChild=true
d=makeDialogue()
bridge=d:BeginProgressCompletionBridge()
assert(bridge and native.alpha==0)
local allowed,reason=d:ValidateProgressCompletionBridge(bridge)
assert(not allowed and reason=='bridge-changed-child-unsafe')
assert(d:EndProgressCompletionBridge('changed-subtree'))
assert(native.alpha==0.61 and native.mouse and child.mouse)
changedChild=false
-- P0501: safe dynamic completion children can be adopted; original opaque
-- alpha/mouse tokens survive, new child mouse state is captured before
-- its input is disabled, and all controls are restored before claim.
local extra=frame()
local successCount=0
stageChildren={child,extra}
d=makeDialogue()
bridge=d:BeginProgressCompletionBridge()
assert(bridge and native.alpha==0 and child.mouse==false and extra.mouse==true)
allowed,reason=d:ValidateProgressCompletionBridge(bridge)
assert(allowed and reason=='same-quest-subtree-rebased' and extra.mouse==false)
assert(bridge.snapshot.alpha==snap.alpha and #bridge.snapshot.mouseFrames==3)
assert(bridge.snapshot.mouseFrames[2].mouseEnabled==true
    and bridge.snapshot.mouseFrames[3].mouseEnabled==true)
control=Control.New(d,frame())
control.Gate=function()return true,'supported',0 end
assert(control:Activate())
assert(control.snapshot==bridge.snapshot)
assert(d:EndProgressCompletionBridge('adopted',true))
QuestRewardCompleteButton_OnClick=function()
    assert(native.alpha==0.61 and child.mouse==true and extra.mouse==true)
    successCount=successCount+1
end
assert(control:Click() and successCount==1)
-- Child replacement (equal count but different identities) is also supported
-- when the replacement is ordinary and fully nonprotected.
local replacement=frame()
stageChildren={replacement}
d=makeDialogue();bridge=d:BeginProgressCompletionBridge()
allowed,reason=d:ValidateProgressCompletionBridge(bridge)
assert(allowed and reason=='same-quest-subtree-rebased')
assert(replacement.mouse==false and #bridge.snapshot.mouseFrames==3)
assert(d:EndProgressCompletionBridge('cancelled'))
assert(replacement.mouse==true and child.mouse==true and native.alpha==0.61)
-- A changed subtree that cannot be suppressed must restore the merged
-- snapshot, not leave a newly created invisible mouse target behind.
local interrupted=frame()
stageChildren={child,interrupted}
d=makeDialogue();bridge=d:BeginProgressCompletionBridge()
local suppress=stock.SuppressOfferPresentation
stock.SuppressOfferPresentation=function(self,s)
    s.mouseFrames[#s.mouseFrames].frame:EnableMouse(false)
    error('injected suppression failure')
end
allowed,reason=d:ValidateProgressCompletionBridge(bridge)
assert(not allowed and reason=='bridge-rebase-suppress-failed')
assert(d:EndProgressCompletionBridge(reason))
assert(interrupted.mouse and child.mouse and native.mouse and native.alpha==0.61)
stock.SuppressOfferPresentation=suppress
stageChildren=nil
-- If the completion gate rejects, restore pre-progress stock first.
d=makeDialogue()
bridge=d:BeginProgressCompletionBridge()
assert(bridge)
control=Control.New(d,frame())
control.Gate=function()return false,'unsupported-completion' end
local supported,r=control:Activate()
assert(not supported and r=='unsupported-completion')
assert(d:EndProgressCompletionBridge('unsupported-completion')==true)
assert(native.alpha==0.61 and native.mouse and child.mouse)
-- Any abandoned bridge releases stock in its bounded one-shot callback.
d=makeDialogue()
bridge=d:BeginProgressCompletionBridge()
assert(bridge)
for _,callback in ipairs(queue) do callback() end
queue={}
assert(d.progressCompletionBridge==nil and native.alpha==0.61 and child.mouse)
-- Changed next-stage identity is refused and releases the stock token.
d=makeDialogue();questID=999
bridge=d:BeginProgressCompletionBridge()
assert(bridge)
allowed,reason=d:ValidateProgressCompletionBridge(bridge)
assert(not allowed and reason=='progress-quest-changed')
assert(d:EndProgressCompletionBridge(reason))
assert(native.alpha==0.61 and native.mouse)
questID=88
-- Full actual Dialogue:HandleQuestComplete() event orchestration: the
-- old progress root is dismissed without a native restore gap, then the
-- completion controller adopts the original snapshot in one event turn.
Logres.QuestRewardModel={FromLive=function(_,footer)
    return {cards={},footer=footer}
end}
d=makeDialogue()
d.completeEventCount=0;d.completionShownCount=0;d.presentationCount=0
local seenRestoreAtClear=restored
d.HidePresentation=function(self,reason)
    assert(reason=='QUEST_FINISHED' or reason=='QUEST_COMPLETE')
    assert(self:RestoreProgressStock(reason))
    assert(restored==seenRestoreAtClear,
        'progress presentation must not restore native stock mid-handoff')
    self.presentationShown=false
    return true,'hidden'
end
d.ReadCompletion=function() return {questID=88,title='Quest 88',body='Rewards'} end
d.ReadCompletionRewardSummary=function(self)
    self.completionRewardCards={}
    return 'reward','ordinary',false,0,'ordinary','reward footer'
end
d.PresentText=function(self,title,body,summary,stage)
    assert(stage=='QUEST_COMPLETE')
    self.presentationShown=true
    self.lastPresentationReason=stage
    return true,'shown'
end
d.UpdatePageControls=function()end
d.UpdateCompletionPagePresentation=function()end
d.PositionCompletionActionVisual=function()end
d.root=frame();d.root.SetHeight=function()end
d.root.GetFrameLevel=function() return 10 end
d.objectiveText={SetText=function()end}
d.acceptButton=frame();d.acceptButton.label={SetText=function()end}
d.acceptButton.ClearAllPoints=function()end
d.acceptButton.SetPoint=function()end
d.acceptButton.SetFrameLevel=function()end
d.declineButton=frame()
d.offerActionRoot.SetFrameLevel=function()end
d.completionControl=Control.New(d,d.offerActionRoot)
d.completionControl.Gate=function() return true,'supported',0 end
-- The actual journal emits QUEST_FINISHED, THEN QUEST_COMPLETE. The
-- first boundary must retain original stock suppression until adoption.
bridge=d:BeginProgressCompletionBridge()
assert(bridge and native.alpha==0 and not native.mouse)
d:ClearActiveDetail('QUEST_FINISHED')
assert(restored==seenRestoreAtClear and d.progressCompletionBridge==bridge)
d:HandleQuestComplete()
assert(restored==seenRestoreAtClear and native.alpha==0,
    'successful event orchestration unexpectedly restored native visuals')
assert(d.progressBridgeHeldCount==1 and d.progressBridgeAdoptedCount==1)
assert(d.completionControl.applied and d.completionControl.snapshot==snap)
assert(d:EndProgressCompletionBridge('event-finished')==true)
assert(d.completionControl:Restore('normal-completion-exit'))
assert(native.alpha==0.61 and native.mouse and child.mouse)
print('P0498 actual-source bridge/restore/fallback/claim PASS')
