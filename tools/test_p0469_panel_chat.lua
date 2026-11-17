-- Actual-source policy/lifecycle test; no client visibility claim.
local root=assert(arg[1])
local function read(p)local f=assert(io.open(root..'/'..p,'rb'));local s=f:read('*a');f:close();return s end
local function fn(s,head)
 local i=assert(s:find(head,1,true));local j=assert(s:find('\nend\n',i,true));return s:sub(i,j+4)
end
local modules={};local frames={};local queued={}
local L={};local prefs={immersionEnabled=true};local state={context='world',revision=1}
function L:RegisterModule(name,options)
 local m={options=options,enabled=true}
 function m:IsEnabled()return self.enabled end
 modules[name]=m;return m
end
function L:GetModule(name)return assert(modules[name],name)end
function L:GetPreferences()return prefs end
function L:GetState()return state end
function L:DevPrint()end
local env={Logres=L,CreateFrame=function()
 local f={SetScript=function(self,k,v)self[k]=v end};frames[#frames+1]=f;return f
end,C_Timer={After=function(_,cb)queued[#queued+1]=cb end}}
setmetatable(env,{__index=_G})
assert(load(read('Logres/Immersion/QuietMode.lua'),'actual-quiet','t',env))(nil,L)
local Q=modules.QuietMode;Q.options.OnInitialize(Q)
-- Retain actual RequestEnabled, scheduling and controller orchestration.
local restores,suppresses=0,0;local failRestore=false
function Q:GetDebugStatus()return {requestedEnabled=self.requestedEnabled,appliedEnabled=self.appliedEnabled,lastError=self.lastError}end
function Q:ApplyDisabled()
 restores=restores+1
 if failRestore then self.lastError='fixture restore refused';return false end
 self.appliedEnabled=false;self.lastError=nil;return true
end
function Q:ApplyEnabled()suppresses=suppresses+1;self.appliedEnabled=true;return true end
local C={enabled=true};modules.ImmersionController=C;env.ImmersionController=C
function C:IsEnabled()return self.enabled end
local source=read('Logres/Immersion/Controller.lua')
for _,name in ipairs({'BuildPolicy','SetChatVisible','ReconcileQuietMode'})do
 assert(load(fn(source,'function ImmersionController:'..name..'('),'actual-'..name,'t',env))()
end
assert(C:BuildPolicy().quietModeDesired)
C:ReconcileQuietMode(C:BuildPolicy(),'initial');assert(Q.appliedEnabled and suppresses==1)
Q:ScheduleReconcile('queued-before-show');assert(#queued==1)
assert(C:SetChatVisible(true));assert(Q.manualOpen and not Q.requestedEnabled and not Q.appliedEnabled and restores==1)
queued[1]();assert(suppresses==1,'queued callback rehid shown chat')
for _,context in ipairs({'world','instance'})do
 for _,immersion in ipairs({false,true})do
  state.context=context;prefs.immersionEnabled=immersion
  assert(not C:BuildPolicy().quietModeDesired,'SHOW lost on unrelated context')
  assert(C:SetChatVisible(false));assert(C:BuildPolicy().quietModeDesired==(immersion and context=='world'))
  assert(C:SetChatVisible(true))
 end
end
prefs.immersionEnabled=true;state.context='world'
assert(C:SetChatVisible(false));assert(Q.appliedEnabled)
failRestore=true;local ok,why=C:SetChatVisible(true)
assert(not ok and why=='failed-open-see-quiet-check' and C.lastQuietError)
failRestore=false;C:ReconcileQuietMode(C:BuildPolicy(),'retry');assert(not Q.appliedEnabled)
local before=restores;assert(not C:SetChatVisible('invalid'));assert(restores==before)
C.enabled=false;assert(not C:SetChatVisible(false));assert(Q.manualOpen)
C.enabled=true;Q.enabled=false;assert(not C:SetChatVisible(false));assert(Q.manualOpen)
Q.options.OnInitialize(Q);assert(Q.manualOpen==false,'reload must reset session override')
print('P0469 actual-source chat policy, queued reconcile, context matrix, failures and disabled gates PASS')
