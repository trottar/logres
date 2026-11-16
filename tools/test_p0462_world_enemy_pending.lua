-- Run against exact assembled HUD.lua; no WoW UI calls or restricted data.
local root = assert(arg[1])
local f = assert(io.open(root .. '/Logres/HUD/HUD.lua','rb'))
local code=f:read('*a');f:close()
local function slice(a,b)
    local i=assert(code:find(a,1,true),a)
    local j=assert(code:find(b,i+#a,1,true),b)
    return code:sub(i,j-1)
end
local lock=true
local worldTrialEvents
local frame={}
function frame:SetScript(_,fn) self.handler=fn end
local calls={build=0,secondary=0,refresh=0,hide=0,secondaryhide=0}
local aura={nativeDebuffs={screenTargetWorldAlpha=nil}}
local refuseAuraRestore=false
local HUD={worldEnemyLiveRequested=false,worldEnemyLiveVisible=false,
 worldEnemyEnablePending=false,worldEnemyDisablePending=false,
 worldEnemySecondaryTrialArmed=false,worldEnemySecondaryTrialActive=0,
 worldEnemyObservedNameplateEpochs={},worldEnemyObservedNameplateSerial=0,
 worldEnemySecondaryEpochs={},worldEnemyNativeClaim=nil,
 BuildLiveWorldEnemy=function(self) calls.build=calls.build+1;return true end,
 BuildSecondaryAggroTrial=function(self) calls.secondary=calls.secondary+1;return true end,
 RefreshLiveWorldEnemy=function(self,why)
   calls.refresh=calls.refresh+1;self.worldEnemyLiveVisible=true
   return true,'owned-target-attached' end,
 HideLiveWorldEnemy=function(self,why)
   calls.hide=calls.hide+1;self.worldEnemyLiveVisible=false;self.worldEnemyNativeClaim=nil
   if not refuseAuraRestore then aura.nativeDebuffs.screenTargetWorldAlpha=nil end
   return true end,
 HideSecondaryAggroTrial=function(self,why)
   calls.secondaryhide=calls.secondaryhide+1;self.worldEnemySecondaryTrialActive=0;return true end,
 RestoreNativeEnemyDecor=function(self)
   self.worldEnemyNativeClaim=nil; return true end,
}
local stub={HUD=HUD, ordinaryOutOfCombat=function()return not lock end,
 ordinaryInCombat=function()return lock end,
 Logres={GetModule=function(_,name)if name=='StatusAuras' then return aura end end},
 CreateFrame=function()return frame end}
setmetatable(stub,{__index=_G})
assert(load(slice('local function hasOwnedWorldAuraRestoreToken()',
    'function HUD:SetEnemyDisplayPreview(enabled)'), 'pending', 't', stub))()
stub.hasOwnedWorldAuraRestoreToken = function()
  local auras=stub.Logres.GetModule()
  return auras and auras.nativeDebuffs
    and auras.nativeDebuffs.screenTargetWorldAlpha ~= nil
end
local evt=slice('    local worldTrialEvents = CreateFrame("Frame")',
    '    self.worldTrialEvents = worldTrialEvents')
assert(load('return function(self) '..evt..' end','handler','t',stub))()(HUD)
assert(type(frame.handler)=='function')
-- 1. Combat ON request with two presses: latch once, mutate nothing.
local ok,why=HUD:SetLiveWorldEnemy(true)
assert(not ok and why=='pending-combat' and HUD.worldEnemyEnablePending)
assert(HUD.worldEnemyLiveRequested and not HUD.worldEnemyLiveVisible)
assert(HUD:SetLiveWorldEnemy(true)==false)
assert(calls.build==0 and calls.refresh==0 and calls.hide==0)
-- 2. Event after combat: one build and one attach; repeated ON idempotent.
lock=false;frame.handler(nil,'PLAYER_REGEN_ENABLED')
assert(HUD.worldEnemyEnablePending==false and HUD.worldEnemyLiveVisible)
assert(calls.build==1 and calls.refresh==1 and calls.secondary==1)
assert(HUD:SetLiveWorldEnemy(true)==true and calls.build==1 and calls.refresh==1)
-- 3. OFF in combat with active owner queues safe restoration, no immediate write.
lock=true;HUD.worldEnemyNativeClaim={{}};local h=calls.hide
ok,why=HUD:SetLiveWorldEnemy(false)
assert(not ok and why=='off-restoration-pending-ooc')
assert(HUD.worldEnemyDisablePending and not HUD.worldEnemyLiveRequested)
assert(calls.hide==h)
lock=false;frame.handler(nil,'PLAYER_REGEN_ENABLED')
assert(not HUD.worldEnemyDisablePending and calls.hide==h+1)
assert(not HUD.worldEnemyLiveVisible and not HUD.worldEnemyLiveRequested)
-- 4. Pending ON followed by OFF: zero activation on regen.
lock=true;HUD:SetLiveWorldEnemy(true)
assert(HUD.worldEnemyEnablePending)
assert(HUD:SetLiveWorldEnemy(false)==true and HUD.worldEnemyEnablePending==false)
local before=calls.build
lock=false;frame.handler(nil,'PLAYER_REGEN_ENABLED')
assert(calls.build==before and not HUD.worldEnemyLiveVisible)
-- 5. Capability failure: requested but not pending, no blind timer retry.
HUD.BuildLiveWorldEnemy=function()calls.build=calls.build+1;return false,'capability-refused' end
lock=true;HUD:SetLiveWorldEnemy(true)
lock=false;frame.handler(nil,'PLAYER_REGEN_ENABLED')
assert(HUD.worldEnemyLiveRequested and HUD.worldEnemyEnablePending==false)
assert(HUD.worldEnemyEnableLastResult=='capability-refused')
assert(calls.build==before+1)
frame.handler(nil,'PLAYER_REGEN_ENABLED')
assert(calls.build==before+1)
-- 6. Explicit OFF clears capability-failed intent.
assert(HUD:SetLiveWorldEnemy(false))
assert(HUD.worldEnemyLiveRequested==false and HUD.worldEnemyEnablePending==false)
-- 7. Refused screen-alpha restoration remains pending; never claim OFF.
HUD.BuildLiveWorldEnemy=function()return true end
HUD.worldEnemyLiveRequested=true
HUD.worldEnemyLiveVisible=true
refuseAuraRestore=true
-- The token is addon-owned; its opaque alpha is never accessed.
aura.nativeDebuffs.screenTargetWorldAlpha={alpha={}}
ok,why=HUD:SetLiveWorldEnemy(false)
assert(not ok and why=='off-restoration-refused')
assert(HUD.worldEnemyDisablePending and aura.nativeDebuffs.screenTargetWorldAlpha)
refuseAuraRestore=false
frame.handler(nil,'PLAYER_REGEN_ENABLED')
assert(HUD.worldEnemyDisablePending==false)
assert(aura.nativeDebuffs.screenTargetWorldAlpha==nil)
-- 8. During combat, even a lone pending alpha token waits for regen.
lock=true
aura.nativeDebuffs.screenTargetWorldAlpha={alpha={}}
ok,why=HUD:SetLiveWorldEnemy(false)
assert(not ok and why=='off-restoration-pending-ooc')
assert(aura.nativeDebuffs.screenTargetWorldAlpha and HUD.worldEnemyDisablePending)
lock=false
frame.handler(nil,'PLAYER_REGEN_ENABLED')
assert(HUD.worldEnemyDisablePending==false and not aura.nativeDebuffs.screenTargetWorldAlpha)
print('P0462 LUA MOCK PASS: pending ON, single regen attempt, OFF cancellation, idempotency, capability refusal, opaque restore refusal')
