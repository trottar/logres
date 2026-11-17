-- P0460: execute real selected-refresh and nameplate event callback source.
-- Test uses ordinary event-token roles; no Blizzard frame identity is read.
local root=assert(arg[1])
local function read(path)
    local file=assert(io.open(root.."/"..path,"rb"))
    local result=file:read("*a");file:close();return result
end
local function section(src,start,finish)
    local a=assert(src:find(start,1,true),start)
    local b=assert(src:find(finish,a+#start,true),finish)
    return src:sub(a,b-1)
end
local source=read("Logres/HUD/HUD.lua")
local probeSource=read("Logres/HUD/WorldTargetProbe.lua")
local roles={nameplate1=true,nameplate2=false,nameplate3=false}
local unsafe=false
local counters={attach=0,restore=0,hide=0,update=0,secondaryOff=0}
local anchor={}
local probe={}
function probe:OrdinaryEventNameplateToken(unit)
    if type(unit)=="string" and unit:match("^nameplate%d+$") then return unit end
    return nil,"non-nameplate-token"
end
function probe:OrdinarySecondaryRole(unit)
    if roles[unit]==nil then return nil,"role-unknown" end
    return roles[unit],"ordinary-role"
end
function probe:AcquireLiveEnemyTargetAnchor(eventUnit,fromEvent)
    if unsafe then return nil,"forbidden-or-unknown" end
    if fromEvent and roles[eventUnit]~=true then
        return nil,"not-current-target"
    end
    return anchor,"accessible-hostile-target",fromEvent and eventUnit or nil
end
local pEnv={Probe=probe,ordinaryNameplateToken=function(unit)return probe:OrdinaryEventNameplateToken(unit)end}
setmetatable(pEnv,{__index=_G})
assert(load(section(probeSource,"function Probe:IsLiveEnemyRemovalRelevant(",
    "-- Preserve bounded event-time evidence"),"probe-removal","t",pEnv))()
local frame={}
function frame:Hide()self.shown=false; counters.hide=counters.hide+1 end
function frame:Show()self.shown=true end
function frame:ClearAllPoints()self.anchor=nil end
function frame:SetPoint(_,v)self.anchor=v end
local function widget()return {Hide=function(self)self.shown=false end,
    Show=function(self)self.shown=true end}end
local HUD={worldEnemyLiveRequested=false,worldEnemyLiveFrame=frame,
    worldEnemyLiveVisible=false,worldEnemyObservedNameplateEpochs={},
    worldEnemyObservedNameplateSerial=0,worldEnemyNativeClaim=nil,
    worldEnemyLiveAttachments=0,worldEnemyLiveCombatAttaches=0,
    worldEnemyLiveDetaches=0,worldEnemyLiveContinuityRefreshes=0,
    worldEnemyLiveReanchors=0,worldEnemyLiveObservedTokenResolutions=0,
    worldEnemyLiveUnknownTokenQueries=0,worldEnemyLiveIgnoredOtherRemovals=0,
    worldEnemyScreenHandoffs=0,worldEnemyLiveFailures=0,
    worldEnemySecondaryEpochs={},worldEnemySecondaryTrialArmed=true,
    targetFrame=widget(),targetNameText=widget(),targetHealthBar=widget()}
function HUD:UpdateLiveWorldEnemyValues()counters.update=counters.update+1;return true end
function HUD:ClaimNativeEnemyDecor(_)
    assert(not self.worldEnemyNativeClaim)
    self.worldEnemyNativeClaim={}
    counters.attach=counters.attach+1
    return true,"decor-owned"
end
function HUD:RestoreNativeEnemyDecor()
    if self.worldEnemyNativeClaim then
        if self.failRestore then return false end
        counters.restore=counters.restore+1
        self.worldEnemyNativeClaim=nil
    end
    return true
end
function HUD:HideLiveWorldEnemy(reason)
    self.worldEnemyLiveLastReason=reason
    if self.worldEnemyLiveVisible then
        self.worldEnemyLiveDetaches=self.worldEnemyLiveDetaches+1
    end
    if not self:RestoreNativeEnemyDecor() then return false end
    self.worldEnemyLiveVisible=false
    self.worldEnemyLiveAnchorUnit=nil
    self.worldEnemyLiveAnchorEpoch=nil
    return true
end
function HUD:HideSecondaryAggroTrial(_)
    counters.secondaryOff=counters.secondaryOff+1
    return true
end
function HUD:ReconcileSecondaryAggroTargetChange(_)return true end
local logres={}
function logres:GetPreferences()return {immersionEnabled=true} end
function logres:GetModule(name)
    if name=="WorldTargetProbe" then return probe end
    return nil
end
HUD.BindEnemyWorldAuras=function()return "aura-not-prepared" end
local env={HUD=HUD,Logres=logres,
    ordinaryOutOfCombat=function()return true end,
    ordinaryInCombat=function()return false end,
    ordinaryOwnedUnprotected=function()return true end,
    CreateFrame=function()return {SetScript=function(self,_,fn)self.callback=fn end}end}
setmetatable(env,{__index=_G})
assert(load(section(source,"function HUD:ResolveObservedSelectedNameplateUnit(",
    "function HUD:SetLiveWorldEnemy("),"HUD-selected","t",env))()
assert(load(section(source,"local function hasOwnedWorldAuraRestoreToken()",
    "function HUD:SetEnemyDisplayPreview("),"HUD-toggle","t",env))()
local block=section(source,"local worldTrialEvents = CreateFrame(\"Frame\")",
    "self.worldTrialEvents = worldTrialEvents")
local build=assert(load("return function(self)\n"..block..
    "self.worldTrialEvents = worldTrialEvents\nend","HUD-events","t",env))()
build(HUD)
local function event(kind,unit)HUD.worldTrialEvents.callback(nil,kind,unit)end
local function active()return HUD.worldEnemyLiveVisible end
-- Existing ADD tokens are remembered even before World Enemy ON.
event("NAME_PLATE_UNIT_ADDED","nameplate1")
event("NAME_PLATE_UNIT_ADDED","nameplate2")
assert(HUD.worldEnemyObservedNameplateEpochs.nameplate1)
HUD.worldEnemyLiveRequested=true
assert(HUD:RefreshLiveWorldEnemy("manual"))
assert(active() and HUD.worldEnemyLiveAnchorUnit=="nameplate1")
assert(HUD.worldEnemyLiveAnchorEpoch==HUD.worldEnemyObservedNameplateEpochs.nameplate1)
assert(counters.attach==1 and counters.restore==0)
-- Critical P0459 regression: removal of another enemy cannot restore
-- the selected native plate; no claim, anchor or screen handoff changes.
event("NAME_PLATE_UNIT_REMOVED","nameplate2")
assert(active() and HUD.worldEnemyLiveAnchorUnit=="nameplate1")
assert(HUD.worldEnemyLiveRemovalResult=="other-unit-removed")
assert(HUD.worldEnemyLiveIgnoredOtherRemovals==1)
assert(counters.attach==1 and counters.restore==0)
-- Unrelated ADD stays no-op for the selected owner.
roles.nameplate4=false
event("NAME_PLATE_UNIT_ADDED","nameplate4")
assert(active() and counters.attach==1 and counters.restore==0)
-- Steady target updates keep the existing native claim.
assert(HUD:RefreshLiveWorldEnemy("PLAYER_REGEN_ENABLED"))
assert(counters.attach==1 and counters.restore==0)
-- Selected removal is attributable and restores its native decoration.
event("NAME_PLATE_UNIT_REMOVED","nameplate1")
assert(not active() and counters.restore==1)
assert(HUD.worldEnemyLiveRemovalResult=="attached-unit-removed")
-- Re-added token after removal is a new generation; selected can claim.
event("NAME_PLATE_UNIT_ADDED","nameplate1")
assert(active() and counters.attach==2)
-- A second ADD with the same token forces a structural reanchor (reuse).
local prior=HUD.worldEnemyLiveAnchorEpoch
event("NAME_PLATE_UNIT_ADDED","nameplate1")
assert(active() and counters.attach==3 and counters.restore==2)
assert(HUD.worldEnemyLiveAnchorEpoch~=prior and HUD.worldEnemyLiveReanchors>=1)
-- Target change resolves the new selected unit from prior ordinary ADD.
roles.nameplate1=false;roles.nameplate3=true
event("NAME_PLATE_UNIT_ADDED","nameplate3")
event("PLAYER_TARGET_CHANGED")
assert(active() and HUD.worldEnemyLiveAnchorUnit=="nameplate3")
-- A future secondary REMOVE still cannot detach the new selected owner.
event("NAME_PLATE_UNIT_REMOVED","nameplate4")
assert(active() and HUD.worldEnemyLiveAnchorUnit=="nameplate3")
-- Unsafe target anchor correctly fails open to native.
unsafe=true
assert(not HUD:RefreshLiveWorldEnemy("PLAYER_REGEN_ENABLED"))
assert(not active() and not HUD.worldEnemyNativeClaim)
unsafe=false
-- Unknown identity keeps the conservative fallback: no false certainty.
roles.nameplate3=nil;roles.nameplate5=nil
assert(HUD:RefreshLiveWorldEnemy("manual"))
assert(active() and HUD.worldEnemyLiveAnchorUnit==nil)
event("NAME_PLATE_UNIT_REMOVED","nameplate5")
assert(not active() and HUD.worldEnemyLiveRemovalResult=="unknown-attached-unit")
-- OFF withdraws native claim; refusing restore is not treated as success.
roles.nameplate3=true
event("NAME_PLATE_UNIT_ADDED","nameplate3")
assert(active())
HUD.failRestore=true
local ok,why=HUD:SetLiveWorldEnemy(false)
assert(not ok or HUD.worldEnemyNativeClaim, "restore refusal must not disappear")
HUD.failRestore=false
assert(HUD:SetLiveWorldEnemy(false))
assert(not HUD.worldEnemyNativeClaim)
-- World transition clears observed token epochs and restores owner.
HUD.worldEnemyLiveRequested=true
assert(HUD:RefreshLiveWorldEnemy("manual"))
event("PLAYER_ENTERING_WORLD")
assert(not active() and next(HUD.worldEnemyObservedNameplateEpochs)==nil)
print("P0460 behavioral PASS: observed target identity, unrelated/removal, steady, reuse, promotion, unsafe, unknown, OFF and world transition")
