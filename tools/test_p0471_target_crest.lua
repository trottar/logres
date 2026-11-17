local root=assert(arg[1]);local f=assert(io.open(root..'/Logres/Immersion/TargetFrameReplacement.lua','rb'));local src=f:read('*a');f:close()
local T;local locked=false;local writes=0;local failure
local L={RegisterModule=function(_,name,opts)T={options=opts};return T end}
local env={Logres=L,InCombatLockdown=function()return locked end,
 RegisterUnitWatch=function()end,UnregisterUnitWatch=function()end}
env._G=env;setmetatable(env,{__index=_G})
assert(load(src,'actual-target-owner','t',env))(nil,L)
local originals={};local regions={}
local function region(name)
 local token=setmetatable({}, {__tostring=function()error('opaque alpha inspected')end})
 local r={alpha=token};originals[r]=token;regions[name]=r
 function r:GetAlpha()return self.alpha end
 function r:SetAlpha(v)
  writes=writes+1
  if failure and failure.name==name and (failure.restore and rawequal(v,token) or not failure.restore and rawequal(v,0))then
   if failure.once then failure=nil end
   error('injected alpha refusal')
  end
  self.alpha=v
 end
 return r
end
local keys={'HighLevelTexture','LeaderIcon','GuideIcon','BossIcon','PvpIcon','PvpBackgroundIcon',
 'PrestigePortrait','PrestigeBadge','PetBattleIcon','NumericalThreat'}
local contextual={}
for _,key in ipairs(keys)do contextual[key]=region(key)end
for _,key in ipairs({'Auras','RaidTargetIcon','QuestIcon','PingIconFrame','UnknownChild'})do contextual[key]=region(key)end
local target={TargetFrameContainer=region('container'),TargetFrameContent={TargetFrameContentMain=region('main'),TargetFrameContentContextual=contextual}}
local mouse=true
function target:IsMouseEnabled()return mouse end
function target:EnableMouse(v)writes=writes+1;mouse=v end
env.TargetFrame=target
T.interaction={GetAttribute=function(_,k)return ({unit='target',['*type1']='target',['*type2']='togglemenu'})[k]end}
T.interactionConfigured=true;T.appliedEnabled=false
function T:EnableInteraction()self.interactionMouseOwnedByLogres=true end
function T:DisableInteraction()
 assert(rawequal(contextual.PvpBackgroundIcon.alpha,originals[contextual.PvpBackgroundIcon]),'input disabled before crest restore')
 self.interactionMouseOwnedByLogres=false
end
local function restored()
 for _,r in pairs(regions)do assert(rawequal(r.alpha,originals[r]),'alpha not restored')end
 assert(mouse)
end
locked=true;assert(not T:EnableReplacement('combat'));assert(writes==0)
locked=false;local crest=contextual.PvpBackgroundIcon;contextual.PvpBackgroundIcon=nil
local before=writes;assert(not T:EnableReplacement('missing'));assert(writes==before)
contextual.PvpBackgroundIcon=crest
assert(T:EnableReplacement('normal'),T.lastError);assert(T.contextualSuppressedCount==10 and #T.snapshot.suppressed==10)
assert(rawequal(crest.alpha,0) and not mouse)
for _,key in ipairs({'Auras','RaidTargetIcon','QuestIcon','PingIconFrame','UnknownChild'})do assert(rawequal(contextual[key].alpha,originals[contextual[key]]))end
locked=true;before=writes;assert(not T:DisableReplacement('combat'));assert(writes==before and T.snapshot)
locked=false;assert(T:DisableReplacement('off'));restored()
failure={name='PvpBackgroundIcon',once=true};assert(not T:EnableReplacement('partial-refusal'));restored()
assert(not T.appliedEnabled and T.snapshot==nil)
assert(T:EnableReplacement('retry'));failure={name='PvpBackgroundIcon',restore=true}
assert(not T:DisableReplacement('restore-refusal'));assert(T.snapshot and T.appliedEnabled)
failure=nil;assert(T:DisableReplacement('restore-retry'));restored()
print('P0471 actual-source PASS: exact crest capture/suppress/opaque restore, 4 preserved+unknown, missing capability, combat, partial rollback and restore retry')
