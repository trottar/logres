-- Executes production target policy and native-container transitions with mocks.
local root=assert(arg[1])
local function read(p)local f=assert(io.open(root..'/'..p,'rb'));local s=f:read('*a');f:close();return s end
local function fn(s,head)local i=assert(s:find(head,1,true));local j=assert(s:find('\nend\n',i,true));return s:sub(i,j+4)end
local modules={};local L={}
function L:RegisterModule(name)local m={};modules[name]=m;return m end
local secret={};local attack=true;local friend=false;local reaction=4
local forbidden=false;local behind=false;local combatCalls=0;local locked=false
local anchor={IsForbidden=function()return forbidden end}
local env={Logres=L,issecretvalue=function(v)return rawequal(v,secret)end,
 UnitCanAttack=function()return attack end,UnitIsFriend=function()return friend end,
 UnitReaction=function()return reaction end,UnitIsUnit=function(a,b)return a=='nameplate1' and b=='target' end,
 UnitAffectingCombat=function()combatCalls=combatCalls+1;return secret end,
 C_NamePlate={GetNamePlateForUnit=function()return anchor end},
 C_NamePlateManager={IsNamePlateUnitBehindCamera=function()return behind end}}
setmetatable(env,{__index=_G})
assert(load(read('Logres/HUD/WorldTargetProbe.lua'),'actual-probe','t',env))(nil,L)
local P=modules.WorldTargetProbe
assert(P:AcquireLiveEnemyTargetAnchor()==anchor and combatCalls==0,'known neutral still needs combat')
assert(P.liveEnemyLastEligibility=='reaction-neutral-attackable-nonfriend')
assert(P:AcquireLiveEnemyTargetAnchor('nameplate1',true)==anchor)
assert(not P:AcquireLiveEnemyTargetAnchor('nameplate2',true))
friend=true;assert(not P:AcquireLiveEnemyTargetAnchor());friend=secret;assert(not P:AcquireLiveEnemyTargetAnchor())
friend=false;attack=false;assert(not P:AcquireLiveEnemyTargetAnchor());attack=secret;assert(not P:AcquireLiveEnemyTargetAnchor())
attack=true;reaction=5;assert(not P:AcquireLiveEnemyTargetAnchor());reaction=secret;assert(not P:AcquireLiveEnemyTargetAnchor())
reaction=4;forbidden=true;assert(not P:AcquireLiveEnemyTargetAnchor());forbidden=secret;assert(not P:AcquireLiveEnemyTargetAnchor())
forbidden=false;behind=true;assert(not P:AcquireLiveEnemyTargetAnchor());behind=false
reaction=2;assert(P:AcquireLiveEnemyTargetAnchor()==anchor,'hostile path regressed')
local source=read('Logres/HUD/HUD.lua');local HUD={};env.HUD=HUD
local flag=true;local prefs={immersionEnabled=true,screenSpaceEnemyFrameEnabled=false}
local owner={pending=false,interactionMouseOwnedByLogres=false}
function L:GetPreferences()return prefs end
function L:GetModule()return owner end
env.UnitIsPVP=function()return flag end
local i=assert(source:find('local function readOrdinaryPvPFlag(unit)',1,true))
local j=assert(source:find('local function createCastCue(',i,true))
assert(load(source:sub(i,j-1),'actual-badges','t',env))()
local function badge()return {SetShown=function(self,v)self.shown=v end,Hide=function(self)self.shown=false end,Show=function(self)self.shown=true end}end
HUD.playerPvPBadge=badge();HUD.targetPvPBadge=badge()
HUD:RefreshPvPIndicators();assert(HUD.playerPvPBadge.shown and not HUD.targetPvPBadge.shown)
assert(HUD.targetPvPObserved=='flagged','source/presentation conflated')
prefs.screenSpaceEnemyFrameEnabled=true;HUD:RefreshPvPIndicators();assert(HUD.targetPvPBadge.shown)
HUD.worldEnemyLiveVisible=true;HUD:RefreshPvPIndicators();assert(not HUD.targetPvPBadge.shown)
prefs.screenSpaceEnemyFrameEnabled=false;owner.pending=true;owner.interactionMouseOwnedByLogres=true
HUD:RefreshPvPIndicators();assert(HUD.targetPvPBadge.shown,'deferred input lost presentation')
owner.pending=false;flag=secret;HUD:RefreshPvPIndicators();assert(not HUD.playerPvPBadge.shown and not HUD.targetPvPBadge.shown)
HUD.pvpPreviewEnabled=true;HUD:RefreshPvPIndicators();assert(HUD.playerPvPBadge.shown and HUD.targetPvPBadge.shown)
-- Actual native SetActive: no writes during lockdown, latest intent on regen.
local N={StockPlayerHarmful=function()return nil end};env.Native=N
env.Logres=L;env.InCombatLockdown=function()return locked end
env.placeStockPlayerHarmful=function()end
local native=read('Logres/HUD/NativeDebuffs.lua')
assert(load(fn(native,'function Native.SetActive(state, active, placementEvent)'),'actual-native-activation','t',env))()
local writes=0;local fail=false
local function frame()return {SetEnabled=function(self,v)writes=writes+1;if fail then error('setter refused')end;self.enabled=v end,
 SetShown=function(self,v)writes=writes+1;self.shown=v end,UpdateAllAuras=function()writes=writes+1 end,Hide=function(self)self.shown=false end}end
local state={frames={player=frame(),target=frame()},active=false}
assert(N.SetActive(state,true));assert(state.frames.player.enabled and not state.frames.target.enabled and not state.targetEnabled)
prefs.screenSpaceEnemyFrameEnabled=true;locked=true;local before=writes
local ok,why=N.SetActive(state,true);assert(ok and why=='screen-target-combat-deferred' and state.targetPending and writes==before)
locked=false;assert(N.SetActive(state,true));assert(state.targetEnabled and state.frames.target.shown)
locked=true;prefs.screenSpaceEnemyFrameEnabled=false;before=writes
assert(N.SetActive(state,true));assert(writes==before and state.targetEnabled and state.targetPending)
locked=false;assert(N.SetActive(state,true));assert(not state.targetEnabled and not state.frames.target.shown)
assert(N.SetActive(state,false));assert(not state.active and not state.frames.player.shown)
fail=true;assert(not N.SetActive(state,true));assert(not state.active and not state.targetEnabled)
print('P0470 actual-source PASS: neutral secret/friend/anchor gates, badge opt-out/pending/preview, native screen toggle/combat/failure')
