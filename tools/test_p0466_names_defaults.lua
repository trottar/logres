local root=assert(arg[1])
local function read(p)local f=assert(io.open(root.."/"..p,"rb"));local s=f:read("*a");f:close();return s end
local function slice(s,a,b)local i=assert(s:find(a,1,true),a);local j=assert(s:find(b,i+#a,true),b);return s:sub(i,j-1)end
local locked=false;local secret={};local writes=0;local fail={}
local original={UnitNameOwn="1",UnitNameNPC="1",UnitNameFriendlySpecialNPCName="1",
 UnitNameHostleNPC="1",UnitNameInteractiveNPC="1",UnitNameFriendlyPlayerName="1",
 UnitNameEnemyPlayerName="1",UnitNameFocused="0",UnitNameFriendlyPetName="1",
 UnitNamePlayerGuild="1",nameplateShowEnemies="0",nameplateShowAll="1",nameplateShowFriends="1"}
local values={};for k,v in pairs(original)do values[k]=v end
local L={};local controller={}
local env={Logres=L,ImmersionController=controller,InCombatLockdown=function()return locked end,
 issecretvalue=function(v)return rawequal(v,secret)end,
 C_CVar={GetCVar=function(k)if fail.secret==k then return secret end;return values[k]end,
 SetCVar=function(k,v)
  assert(original[k],"unsupported CVar created")
  if fail.write==k and v=="0"then fail.write=nil;return end
  if fail.restore==k and v==original[k]then error("restore refused")end
  values[k]=v;writes=writes+1
 end}}
setmetatable(env,{__index=_G})
local source=read("Logres/Immersion/Controller.lua")
local start=assert(source:find('-- P0466: reversible client name-display policy',1,true))
assert(load(source:sub(start),"actual-overhead-policy","t",env))()
local N=L.OverheadNamePolicy;local meta={};local state=N.New(meta)
assert(N.Apply(state,true));assert(state.active and state.skipped>0)
assert(values.UnitNameNPC=="0" and values.UnitNameOwn=="0" and values.UnitNameFriendlyPetName=="0")
assert(values.UnitNameFocused=="1" and values.nameplateShowEnemies=="1" and values.nameplateShowAll=="0")
local before=writes;assert(N.Apply(state,true));assert(writes==before,"steady state reasserted CVars")
assert(meta.overheadNameSnapshot.UnitNameNPC=="1")
-- Recreate owner as /reload does: initial originals must survive imposed values.
local reload=N.New(meta);assert(N.Apply(reload,true));assert(meta.overheadNameSnapshot.UnitNameNPC=="1")
locked=true;before=writes;assert(not N.Apply(reload,false));assert(writes==before and reload.pending)
locked=false;assert(N.Apply(reload,false));assert(meta.overheadNameSnapshot==nil)
for k,v in pairs(original)do assert(values[k]==v,k.." did not restore")end
-- Missing mandatory and secret-capable settings refuse before any write.
values.UnitNameNPC=nil;before=writes;assert(not N.Apply(N.New({}),true));assert(writes==before)
values.UnitNameNPC="1";fail.secret="UnitNameNPC";assert(not N.Apply(N.New({}),true));assert(writes==before);fail.secret=nil
-- Silent setter failure must be detected through ordinary config readback.
fail.write="UnitNameOwn";local failed=N.New({});assert(not N.Apply(failed,true))
for k,v in pairs(original)do assert(values[k]==v,k.." rollback")end
-- Pending restoration retains persisted originals until a safe event succeeds.
local pending=N.New({});assert(N.Apply(pending,true));fail.restore="UnitNameNPC"
assert(not N.Apply(pending,false));assert(pending.pending and pending.meta.overheadNameSnapshot)
fail.restore=nil;assert(N.Apply(pending,false));assert(not pending.pending)
-- Controller's actual event seam registers only deferred work.
controller.overheadNames=N.New({});controller.overheadNameEvents={
 RegisterEvent=function(self,k)self.registered=k end,UnregisterEvent=function(self)self.registered=nil end}
locked=true;controller:ReconcileOverheadNames({immersionEnabled=true});assert(controller.overheadNameEvents.registered=="PLAYER_REGEN_ENABLED")
controller:ReconcileOverheadNames({immersionEnabled=false});locked=false
controller:ReconcileOverheadNames({immersionEnabled=controller.overheadNames.desired})
assert(not controller.overheadNameEvents.registered and not controller.overheadNames.active)
-- Real database defaults and explicit saved choices, no destructive migration.
local dbEnv={GetBuildInfo=function()return "v","b",nil,16001 end};setmetatable(dbEnv,{__index=_G})
assert(load(read("Logres/Core/Database.lua"),"actual-db","t",dbEnv))(nil,L)
L:InitializeDatabase();assert(L.db.settings.worldEnemyEnabled==true and L.db.settings.screenSpaceEnemyFrameEnabled==false)
dbEnv.LogresDB={schema=3,settings={worldEnemyEnabled=false,screenSpaceEnemyFrameEnabled=true}}
L:InitializeDatabase();assert(L.db.settings.worldEnemyEnabled==false and L.db.settings.screenSpaceEnemyFrameEnabled==true)
assert(load(read("Logres/Core/Preferences.lua"),"actual-preferences","t",dbEnv))(nil,L)
assert(L:GetPreferences().worldEnemyEnabled==false)
local observed=false;L:SubscribePreferences(function(now,previous,changes)
 assert(now.worldEnemyEnabled and previous.worldEnemyEnabled==false and changes.worldEnemyEnabled);observed=true end)
L:SetPreference("worldEnemyEnabled",true,"fixture");assert(observed)
-- Actual HUD functions: screen preference hides name/HP while cast parent stays.
local h=read("Logres/HUD/HUD.lua");local HUD={worldEnemyLiveVisible=false}
local function region()return {SetText=function()end,SetFormattedText=function()end,
 SetValue=function()end,SetShown=function(self,v)self.shown=v end,
 Show=function(self)self.shown=true end,Hide=function(self)self.shown=false end,IsShown=function()return true end}end
HUD.root=region();HUD.targetFrame=region();HUD.targetNameText=region();HUD.targetHealthText=region()
HUD.targetHealthBar=region();HUD.targetHealthBar.status=region()
HUD.UpdateWorldTrialValues=function()end
local pref={immersionEnabled=true,worldEnemyEnabled=true,screenSpaceEnemyFrameEnabled=false}
local henv={HUD=HUD,Logres={GetPreferences=function()return pref end},
 UnitExists=function()return true end,UnitName=function()return secret end,UnitHealthPercent=function()return secret end}
setmetatable(henv,{__index=_G})
assert(load(slice(h,'function HUD:UpdateTarget()','function HUD:ApplyImmersionPreference'),"actual-target","t",henv))()
HUD:UpdateTarget();assert(HUD.targetFrame.shown and not HUD.targetNameText.shown and not HUD.targetHealthBar.shown)
pref.screenSpaceEnemyFrameEnabled=true;HUD:UpdateTarget();assert(HUD.targetNameText.shown and HUD.targetHealthBar.shown)
HUD.worldEnemyLiveVisible=true;HUD:UpdateTarget();assert(not HUD.targetNameText.shown)
pref.screenSpaceEnemyFrameEnabled=false
local pendingInput={pending=true,interactionMouseOwnedByLogres=true}
henv.Logres.GetModule=function()return pendingInput end
HUD:UpdateTarget();assert(HUD.targetNameText.shown and HUD.targetHealthBar.shown,"pending secure input became invisible")
pendingInput.pending=false;HUD:UpdateTarget();assert(not HUD.targetNameText.shown)
local starts={};HUD.SetLiveWorldEnemy=function(_,v)starts[#starts+1]=v end
HUD.SetWorldTargetTrial=function()end;HUD.UpdateHealthVignette=function()end;HUD.UpdateResource=function()end
HUD.UpdateAllies=function()end;HUD.RefreshPvPIndicators=function()end
assert(load(slice(h,'function HUD:ApplyImmersionPreference(preferences)','function HUD:GetDebugStatus()'),"actual-default-activation","t",henv))()
HUD:ApplyImmersionPreference(pref);assert(starts[1]==true)
HUD:ApplyImmersionPreference(pref);assert(#starts==1,"unrelated preference churned world owner")
pref.immersionEnabled=false;HUD:ApplyImmersionPreference(pref);assert(starts[2]==false)
pref.immersionEnabled=true;HUD:ApplyImmersionPreference(pref);assert(starts[3]==true)
pref.worldEnemyEnabled=false;HUD:ApplyImmersionPreference(pref);assert(starts[4]==false)
print("P0466 actual-source PASS: saved defaults/explicit choices, screen name/HP gate, steady activation, native names transaction/reload/combat/refusal/restore")
-- Actual secure screen-input seam: no invisible opt-out overlay; no combat mutation.
local T={unitWatchRegistered=true,interactionMouseOwnedByLogres=true,appliedEnabled=true}
local inputCalls=0
T.interaction={EnableMouse=function(self,v)self.mouse=v;inputCalls=inputCalls+1 end,
 Hide=function(self)self.hidden=true end}
local enabledScreen=false
local tenv={TargetFrameReplacement=T,Logres={GetPreference=function()return enabledScreen end},
 InCombatLockdown=function()return locked end,RegisterUnitWatch=function()end,UnregisterUnitWatch=function()end}
setmetatable(tenv,{__index=_G})
local target=read("Logres/Immersion/TargetFrameReplacement.lua")
assert(load(slice(target,'function TargetFrameReplacement:EnableInteraction()','function TargetFrameReplacement:SuppressStock(snapshot)'),"actual-input","t",tenv))()
assert(load(slice(target,'function TargetFrameReplacement:EnableReplacement(reason)','function TargetFrameReplacement:DisableReplacement(reason)'),"actual-secure-input-update","t",tenv))()
locked=true;assert(not T:EnableReplacement("fixture"));assert(inputCalls==0)
locked=false;assert(T:EnableReplacement("fixture"));assert(not T.unitWatchRegistered and not T.interaction.mouse)
enabledScreen=true;assert(T:EnableReplacement("fixture"));assert(T.unitWatchRegistered and T.interaction.mouse)
enabledScreen=false;assert(T:EnableReplacement("fixture"));assert(not T.unitWatchRegistered and T.interaction.hidden)
print("P0466 secure-input PASS: opt-in only, default-off has no click region; combat deferred")
