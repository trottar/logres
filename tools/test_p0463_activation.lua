local root=assert(arg[1]);local f=assert(io.open(root..'/Logres/HUD/HUD.lua'));local code=f:read('*a');f:close()
local function slice(a,b)local i=assert(code:find(a,1,true));local j=assert(code:find(b,i+#a,true));return code:sub(i,j-1)end
local combat,canAttach=true,false
local calls={build=0,pool=0,refresh=0,replay=0,hide=0}
local probe={}
function probe:OrdinaryEventNameplateToken(u)if type(u)=='string' and u:match('^nameplate%d+$')then return u end end
function probe:OrdinarySecondaryRole()return self.sameSelected ~= false end
function probe:ObserveNameplateLifecycle(_,u)return {unit=u}end
function probe:ObserveSecondaryVisualEligibility()return 'eligible'end
local HUD={worldEnemyLiveRequested=false,worldEnemyEnablePending=false,worldEnemyDisablePending=false,
 worldEnemyObservedNameplateEpochs={nameplate1=1,nameplate2=2,unrelated=3},worldEnemySecondaryEpochs={},worldEnemySecondarySerial=0,
 worldEnemySecondaryTrialActive=0,worldEnemySecondaryTrialArmed=false}
function HUD:BuildLiveWorldEnemy()calls.build=calls.build+1;self.worldEnemyLiveFrame={};return true end
function HUD:BuildSecondaryAggroTrial()calls.pool=calls.pool+1;self.worldEnemySecondaryPool={};for i=1,40 do self.worldEnemySecondaryPool[i]={}end;return true end
function HUD:RefreshLiveWorldEnemy()calls.refresh=calls.refresh+1;self.worldEnemyLiveVisible=canAttach;self.worldEnemyLiveAnchorUnit="nameplate1";self.worldEnemyLiveAnchorEpoch=self.worldEnemyObservedNameplateEpochs.nameplate1;return canAttach,canAttach and 'attached' or 'not-attackable'end
function HUD:ObserveSecondaryAggroTrial(_,unit,decision)assert(unit:match('^nameplate%d+$'));assert(decision=='eligible');calls.replay=calls.replay+1 end
function HUD:HideLiveWorldEnemy()calls.hide=calls.hide+1;self.worldEnemyLiveVisible=false;return true end
function HUD:HideSecondaryAggroTrial()return true end
local env={HUD=HUD,SECONDARY_POOL_CAPACITY=40,
 ordinaryOutOfCombat=function()return not combat end,ordinaryInCombat=function()return combat end,
 ordinaryOwnedUnprotected=function(frame)return frame and not frame.protected end,
 Logres={GetModule=function(_,name)if name=='WorldTargetProbe'then return probe end end}}
setmetatable(env,{__index=_G})
assert(load(slice('local function hasOwnedWorldAuraRestoreToken()','function HUD:SetEnemyDisplayPreview(enabled)'),'activation','t',env))()
assert(not HUD:SetLiveWorldEnemy(true));assert(HUD.worldEnemyEnablePending and calls.build==0)
combat=false;HUD:SetLiveWorldEnemy(true)
assert(calls.build==1 and calls.pool==1 and calls.replay==2)
assert(HUD.worldEnemyLiveRequested and not HUD.worldEnemyEnablePending)
print('PASS first setup defers combat; OOC setup reconciles both cached plates with no current target')
assert(HUD:SetLiveWorldEnemy(false));combat=true;canAttach=true
assert(HUD:SetLiveWorldEnemy(true));assert(not HUD.worldEnemyEnablePending)
assert(calls.build==1 and calls.pool==1 and calls.replay==4)
print('PASS combat ON reuses complete prebuilt pool and revalidates observed plates without setup')
local builds,replays=calls.build,calls.replay
assert(HUD:SetLiveWorldEnemy(true));assert(calls.build==builds and calls.replay==replays)
print('PASS repeated active ON is idempotent')
assert(not HUD:SetLiveWorldEnemy(false));assert(HUD.worldEnemyDisablePending)
local hides=calls.hide
assert(HUD:SetLiveWorldEnemy(true));assert(not HUD.worldEnemyDisablePending and HUD.worldEnemyLiveRequested)
assert(calls.hide==hides and HUD.worldEnemyLiveVisible)
print('PASS ON cancels unexecuted pending OFF without native ownership churn')
assert(not HUD:SetLiveWorldEnemy(false));probe.sameSelected=false
assert(not HUD:SetLiveWorldEnemy(true));assert(HUD.worldEnemyDisablePending and HUD.worldEnemyEnablePending)
probe.sameSelected=true
assert(HUD:SetLiveWorldEnemy(true));assert(not HUD.worldEnemyDisablePending)
print('PASS changed/unknown selected identity cannot cancel pending restoration as an unchanged owner')
assert(not HUD:SetLiveWorldEnemy(false))
HUD.worldEnemyObservedNameplateEpochs.nameplate1=99
assert(not HUD:SetLiveWorldEnemy(true));assert(HUD.worldEnemyEnablePending and HUD.worldEnemyDisablePending)
HUD.worldEnemyObservedNameplateEpochs.nameplate1=HUD.worldEnemyLiveAnchorEpoch
assert(HUD:SetLiveWorldEnemy(true));assert(not HUD.worldEnemyDisablePending)
print('PASS recycled nameplate token cannot cancel restoration through a stale generation')
combat=false;HUD:SetLiveWorldEnemy(false);HUD.worldEnemyLiveFrame.protected=true;combat=true
assert(not HUD:SetLiveWorldEnemy(true));assert(HUD.worldEnemyEnablePending)
print('PASS protected prebuilt frame remains safely deferred')
HUD.worldEnemyLiveFrame=nil;HUD.worldEnemyEnablePending=false;HUD.worldEnemyLiveRequested=false
HUD:SetLiveWorldEnemy(true);assert(HUD.worldEnemyEnablePending)
assert(HUD:SetLiveWorldEnemy(false));assert(not HUD.worldEnemyEnablePending and not HUD.worldEnemyLiveRequested)
print('PASS OFF cancels unstarted pending ON')
print('P0463 activation source tests PASS')
