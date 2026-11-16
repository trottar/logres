-- Execute the actual P0458 source functions in a simulated WoW runtime.
-- No copies of the state-machine implementation are present in this test.
local root=assert(arg[1])
local function read(path) local f=assert(io.open(root..'/'..path,'rb'));local s=f:read('*a');f:close();return s end
local function section(source,beginning,ending)
  local a=assert(source:find(beginning,1,true),beginning)
  local b=assert(source:find(ending,a+#beginning,true),ending)
  return source:sub(a,b-1)
end
local src=read('Logres/HUD/HUD.lua')
local states={combat=false,immersion=true};local counts={alpha=0,point=0,hide=0,show=0,values=0}
local anchors={};local guids={};local roles={};local unsafe={};local reactions={};local attackables={}
local function region(initial)
 local r={value=initial or .9,failRestore=false,failMutation=false}
 function r:IsProtected() return false end
 function r:IsForbidden() return false end
 function r:GetAlpha() return self.value end
 function r:SetAlpha(v)
   if v==0 and self.failMutation then error('SetAlpha mutation refused') end
   if v~=0 and self.failRestore then error('SetAlpha restore refused') end
   self.value=v;counts.alpha=counts.alpha+1
 end
 return r
end
local function anchor(unit)
 if not anchors[unit] then anchors[unit]={UnitFrame={name=region(.82),HealthBarsContainer=region(.61), LevelFrame=region(.73), PlayerLevelDiffFrame=region(.5)}} end
 return anchors[unit]
end
local function txt()return {SetText=function(self,v)self.value=v;counts.values=counts.values+1 end,SetFormattedText=function(self,fmt,v)self.value=v;counts.values=counts.values+1 end}end
local function buildFixture(parent,id)
 local frame={id=id,shown=false,enemyNameText=txt(),enemyHealthText=txt(),enemyHealthBar={status={SetValue=function(self,n)self.value=n;counts.values=counts.values+1 end}}}
 function frame:SetFrameStrata(s)self.strata=s end
 function frame:SetScale(s)self.scale=s end
 function frame:SetAlpha(a)self.alpha=a end
 function frame:EnableMouse(b)self.mouse=b end
 function frame:Hide()if self.failHide then error('frame Hide refused') end;counts.hide=counts.hide+1;self.shown=false end
 function frame:Show()if self.failShow then error('frame Show refused') end;counts.show=counts.show+1;self.shown=true end
 function frame:ClearAllPoints() self.point=nil end
 function frame:SetPoint(_,native,...)if self.failPoint then error('SetPoint refused') end;self.point=native;counts.point=counts.point+1 end
 function frame:IsProtected()return false end
 return frame
end
local probe={};function probe:OrdinaryEventNameplateToken(x)if type(x)=='string' and x:match('^nameplate%d+$') then return x end return nil end
function probe:OrdinarySecondaryIdentity(unit)return guids[unit],guids[unit] and 'ordinary-guid' or 'guid-restricted' end
function probe:OrdinarySecondaryRole(unit)if roles[unit]==nil then return nil,'role-unknown' end return roles[unit],'ordinary-role' end
function probe:AcquireLiveEnemySecondaryAnchor(unit)
 if roles[unit]~=false then return nil,'no-longer-secondary' end
 if unsafe[unit] then return nil,'secondary-anchor-unsafe' end
 return anchor(unit),'secondary-safe-anchor',unit
end
local fakeObservation={secondary=true,currentTarget=false,anchorSafe=true,inCombat=true,enemyInCombat=true,attackable=true,targetingPlayer=true,reaction='hostile',inCombatObserved=true,enemyCombatObserved=true,attackableObserved=true,targetingObserved=true}
function probe:ObserveNameplateLifecycle(event,unit)if roles[unit]==true then return {currentTarget=true,secondary=false,anchorSafe=true} end
 local r={};for k,v in pairs(fakeObservation) do r[k]=v end
 r.reaction=reactions[unit] or 'hostile'
 r.attackableObserved=attackables[unit]~=false
 return r end
local Logres={};function Logres:GetModule(name)if name=='WorldTargetProbe' then return probe end end
function Logres:GetPreferences()return {immersionEnabled=states.immersion} end
local HUD={worldEnemyLiveRequested=true,worldEnemySecondaryTrialArmed=true,worldEnemySecondaryPool={},worldEnemySecondaryOwners={},worldEnemySecondaryEpochs={},worldEnemySecondarySerial=0,worldEnemySecondaryTrialVisible=false}
setmetatable(HUD,{__index=function(t,k)if type(k)=='string' and k:match('^worldEnemySecondaryTrial') then return 0 end end})
local env={HUD=HUD,Logres=Logres,UIParent={},buildEnemyDisplayFixture=buildFixture,
  ordinaryOutOfCombat=function()return not states.combat end,
  ordinaryInCombat=function()return states.combat end,
  issecretvalue=function()return false end,
  UnitName=function(u)return u end,UnitHealthPercent=function()return 75 end,
  pcall=pcall,ipairs=ipairs,tostring=tostring,type=type}
setmetatable(env,{__index=_G})
local ownerSection=section(src,'local function ordinaryOwnedUnprotected(frame)','function HUD:BuildLiveWorldEnemy()')
assert(load(ownerSection,'P0458-HUD-secondary','t',env))()
-- The live probe's real classifier is executed; detailed threat is restricted.
local ps=read('Logres/HUD/WorldTargetProbe.lua')
local basic={};local pStats={}
setmetatable(pStats,{__index=function(t,k)if type(k)=='string' and k:match('^secondaryThreat') then return 0 end end})
local pEnv={Probe=pStats,
    callOrdinary=function(api,player,unit)
      local v=basic[unit]
      if v==nil then return {available=true,ok=true,present=false,secret=false,failure=false},nil end
      if v=='secret' then return {available=true,ok=true,present=false,secret=true,failure=false},nil end
      return {available=true,ok=true,present=true,secret=false,failure=false},v
    end,
    readBoolean=function()return {available=true,ok=true,present=false,secret=true,failure=false} end,
    UnitThreatSituation=function()end,UnitDetailedThreatSituation=function()end,
    ordinaryNameplateToken=function(unit)return probe:OrdinaryEventNameplateToken(unit)end,math=math,type=type}
setmetatable(pEnv,{__index=_G})
assert(load(section(ps,'function Probe:ObserveSecondaryThreat(event, eventUnit, observation)','function Probe:RunDevNameplateLifecycleStatus('),'P0458-probe-classifier','t',pEnv))()
function probe:ObserveSecondaryThreat(event,u,observation)return pStats:ObserveSecondaryThreat(event,u,observation)end
function probe:ObserveSecondaryVisualEligibility(event,u,observation)return pStats:ObserveSecondaryVisualEligibility(event,u,observation)end
local function event(u,ev,decision)
 local obs=probe:ObserveNameplateLifecycle(ev or 'UNIT_THREAT_LIST_UPDATE',u)
 probe:ObserveSecondaryThreat(ev or 'UNIT_THREAT_LIST_UPDATE',u,obs)
 local d=decision or probe:ObserveSecondaryVisualEligibility(ev or 'UNIT_THREAT_LIST_UPDATE',u,obs)
 HUD:ObserveSecondaryAggroTrial(ev or 'UNIT_THREAT_LIST_UPDATE',u,d)
 return d
end
local function alive(unit)
 local s=HUD:SecondaryOwnerForUnit(unit);return s and s.visible==true
end
local function prepare(u,guid,threat)
 guids[u]=guid;roles[u]=false;basic[u]=threat or 3;unsafe[u]=false;reactions[u]='hostile';attackables[u]=true;anchor(u)
end

assert(HUD:BuildSecondaryAggroTrial())
assert(#HUD.worldEnemySecondaryPool==40)
for _,slot in ipairs(HUD.worldEnemySecondaryPool) do assert(slot.frame.scale==.5 and slot.frame.alpha==.5 and not slot.frame.mouse) end
-- Visual eligibility is independent of ordinary threat, including 0/1 and missing.
prepare('nameplate1','G1',3);prepare('nameplate2','G2',0)
assert(event('nameplate1','NAME_PLATE_UNIT_ADDED')=='eligible')
assert(event('nameplate2','NAME_PLATE_UNIT_ADDED')=='eligible')
assert(HUD.worldEnemySecondaryTrialActive==2)
for _,u in ipairs({'nameplate1','nameplate2'}) do
 local r=anchor(u).UnitFrame
 assert(r.name.value==0 and r.HealthBarsContainer.value==0 and r.LevelFrame.value==0 and r.PlayerLevelDiffFrame.value==0)
end
local mut,point,att=counts.alpha,counts.point,HUD.worldEnemySecondaryTrialAttachments
states.combat=true
basic.nameplate1=0;basic.nameplate2=1
for i=1,5 do
 assert(event('nameplate1')=='eligible' and event('nameplate2')=='eligible')
end
basic.nameplate1=nil;basic.nameplate2='secret'
assert(event('nameplate1')=='eligible' and event('nameplate2')=='eligible')
assert(HUD.worldEnemySecondaryTrialActive==2 and counts.alpha==mut and counts.point==point and HUD.worldEnemySecondaryTrialAttachments==att)
assert(HUD.worldEnemySecondaryTrialStableUpdates>=12)
-- Unrelated events never restore native artwork.
HUD:ObserveSecondaryAggroTrial('UNIT_THREAT_LIST_UPDATE','player','inconclusive')
assert(HUD.worldEnemySecondaryTrialIgnoredUnrelatedEvents==1 and alive('nameplate2'))
-- Combat ends, hostile nameplates remain skinned (no automatic regen hide).
states.combat=false
assert(event('nameplate1')=='eligible' and alive('nameplate1'))
-- Other hostile enemy appears with no current threat table.
prepare('nameplate3','G3',nil);basic.nameplate3=nil
assert(event('nameplate3','NAME_PLATE_UNIT_ADDED')=='eligible' and alive('nameplate3'))
-- One plate becomes non-attackable: restore only it.
attackables.nameplate1=false
assert(event('nameplate1')=='ineligible' and not alive('nameplate1'))
assert(alive('nameplate2') and alive('nameplate3'))
assert(anchor('nameplate1').UnitFrame.LevelFrame.value==.73)
-- Friendly no longer qualifies; unrelated enemies remain.
reactions.nameplate2='friendly'
assert(event('nameplate2')=='ineligible' and not alive('nameplate2') and alive('nameplate3'))
-- 4 unknown reactions require bounded proof; absence of proof restores.
reactions.nameplate3='unknown'
for i=1,3 do assert(event('nameplate3')=='inconclusive' and alive('nameplate3')) end
assert(event('nameplate3')=='inconclusive' and not alive('nameplate3'))
assert(HUD.worldEnemySecondaryTrialInconclusiveWithdrawals==1)
-- Two visually eligible nameplates; remove one, then token reuse.
for i=4,5 do prepare('nameplate'..i,'G'..i,0);event('nameplate'..i,'NAME_PLATE_UNIT_ADDED') end
assert(alive('nameplate4') and alive('nameplate5'))
HUD:ObserveSecondaryAggroTrial('NAME_PLATE_UNIT_REMOVED','nameplate4','removed')
assert(not alive('nameplate4') and alive('nameplate5'))
local restoreBefore=HUD.worldEnemySecondaryTrialRestores
prepare('nameplate5','G5-new',0);event('nameplate5','NAME_PLATE_UNIT_ADDED')
assert(alive('nameplate5') and HUD.worldEnemySecondaryTrialRestores==restoreBefore+1)
-- Promotion releases only selected slot; previous selected can demote without aggro.
roles.nameplate5=true
assert(HUD:ReconcileSecondaryAggroTargetChange())
assert(not alive('nameplate5'))
prepare('nameplate20','G20',0)
assert(HUD:ReconcileSecondaryAggroTargetChange('nameplate20') and alive('nameplate20'))
-- Unsafe anchor withdraws, no stale hidden region.
unsafe.nameplate20=true;event('nameplate20')
assert(not alive('nameplate20'))
unsafe.nameplate20=false
-- Restoration refusal is quarantined and retryable, not reused.
prepare('nameplate30','G30',0);event('nameplate30','NAME_PLATE_UNIT_ADDED')
anchor('nameplate30').UnitFrame.name.failRestore=true
attackables.nameplate30=false;event('nameplate30')
local pending=HUD:SecondaryOwnerForUnit('nameplate30')
assert(pending and pending.blocked and pending.claim and not pending.visible)
anchor('nameplate30').UnitFrame.name.failRestore=false;event('nameplate30')
assert(not HUD:SecondaryOwnerForUnit('nameplate30'))
-- Refused attach and refused alpha mutation must never create an owned skin.
prepare('nameplate31','G31',0)
local free=HUD:FindFreeSecondaryAggroSlot();free.frame.failPoint=true
local oldAlpha=counts.alpha;event('nameplate31','NAME_PLATE_UNIT_ADDED')
assert(not alive('nameplate31') and counts.alpha==oldAlpha)
free.frame.failPoint=false;event('nameplate31');assert(alive('nameplate31'))
prepare('nameplate32','G32',0);anchor('nameplate32').UnitFrame.name.failMutation=true
event('nameplate32','NAME_PLATE_UNIT_ADDED')
assert(not alive('nameplate32'))
assert(HUD:HideSecondaryAggroTrial('off'))
assert(HUD.worldEnemySecondaryTrialActive==0 and HUD.worldEnemySecondaryTrialPending==0)
for i=1,41 do local u='nameplate'..(100+i);prepare(u,'GUID-'..i,0);event(u,'NAME_PLATE_UNIT_ADDED') end
assert(HUD.worldEnemySecondaryTrialActive==40 and HUD.worldEnemySecondaryTrialPoolExhaustions>=1)
assert(HUD:HideSecondaryAggroTrial('off'))
print('P0459 behavioral PASS: actual source visual classifier, threat 0/1/missing independent, multi-owner, steady, OOC, safety, role, reuse, restore, OFF, capacity')
