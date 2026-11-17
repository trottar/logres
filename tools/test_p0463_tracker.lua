local root=assert(arg[1]);local combat=true;local SECRET={};local hides=0
local frame={}
function frame:IsProtected()return self.secret and SECRET or self.protected or false end
function frame:IsForbidden()return self.forbidden or false end
function frame:IsShown()error('native visibility must not be inspected')end
function frame:Hide()hides=hides+1 end
function frame:HookScript(_,callback)self.callback=callback end
local Native
local Logres={RegisterModule=function(_,_,module)Native=module;return module end,RegisterEvent=function()end}
local env={Logres=Logres,InCombatLockdown=function()return combat end,
 issecretvalue=function(v)return rawequal(v,SECRET)end,ObjectiveTrackerFrame=frame}
env._G=env;setmetatable(env,{__index=_G})
assert(loadfile(root..'/Logres/Immersion/NativeAccess.lua','t',env))('Logres',Logres)
Native.desired=true;Native.snapshots={objectives={{frame=frame,shown=false}}}
Native.manualOpen={};Native.restoring={};Native.hookedFrames={};Native.pendingRefolds={};Native.lastReasons={}
for _,k in ipairs({'nativeShows','showRefolds','combatShowDeferrals','failures','refoldFailures','refoldAttempts'})do Native[k]=0 end
Native:InstallRefoldHooks();assert(frame.callback)
frame.callback();assert(hides==1 and Native.pendingRefolds.objectives==nil)
assert(Native:Refold('objectives','QUEST_LOG_UPDATE'));assert(hides==2)
print('PASS unprotected tracker OnShow and quest event refold during combat without visibility readback')
for _,kind in ipairs({'protected','forbidden','secret'})do
 frame[kind]=true;local before=hides;frame.callback()
 assert(hides==before and Native.pendingRefolds.objectives)
 frame[kind]=nil;Native.pendingRefolds.objectives=nil
end
print('PASS protected, forbidden and secret capability remain deferred')
Native.manualOpen.objectives=true;frame.callback();assert(hides==2)
assert(Native:Refold('objectives','quest'));assert(hides==2)
Native.manualOpen.objectives=nil;Native.desired=false;frame.callback();assert(hides==2)
print('PASS intentional native access and immersion OFF are preserved')
assert(not Native:CanRefoldObjectivesInCombat('casts'))
-- Model the public secure-wrapper contract; this is not a live trust/taint test.
combat=false;Native.desired=true;frame.protected=true
local control,preBody,postBody
env.CreateFrame=function(_,_,_,template)
 assert(not combat and template=='SecureHandlerStateTemplate')
 control={attributes={}}
 function control:SetAttribute(k,v)assert(not combat);self.attributes[k]=v end
 function control:GetAttribute(k)return self.attributes[k]end
 return control
end
env.SecureHandlerWrapScript=function(subject,script,header,pre,post)
 assert(not combat and subject==frame and script=='OnShow' and header==control)
 preBody,postBody=pre,post
end
assert(Native:SetObjectiveSecureGate(true));assert(Native.objectiveSecureGateArmed)
assert(preBody=='return true, true')
local post=assert(load('return function(self,control) '..postBody..' end','secure-model','t',env))()
combat=true;local before=hides;frame.callback();assert(hides==before)
post(frame,control);assert(hides==before+1)
assert(Native:Refold('objectives','QUEST_LOG_UPDATE'));assert(hides==before+1)
assert(not Native:SetObjectiveSecureGate(false))
print('PASS protected tracker uses an OOC-installed secure post-handler; combat has no insecure mutation')
combat=false;assert(Native:SetObjectiveSecureGate(false));assert(not Native.objectiveSecureGateArmed)
before=hides;post(frame,control);assert(hides==before)
print('PASS disarmed secure wrapper preserves manual/native visibility')
print('P0463 tracker source tests PASS; client secure execution/taint remains UNVERIFIED')
