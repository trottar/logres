-- P0492 actual-source combat-exit reconciliation and incident source state.
local path = arg[0]:gsub('tools/test_p0492_postcombat_reconcile.lua$', '')
local modules, state = {}, {combat=false,pvpFlagged=false,context='world'}
local secureDispatch = false
local protectedSetAttempts = 0
local function widget(protectedRoot)
    local o = {alpha=1, visible=false, mouseOver=false, scripts={}, hooks={}, refs={}, attrs={}}
    return setmetatable(o, {__index=function(self, k)
        if k=='SetFrameRef' then return function(self,key,value) self.refs[key]=value end end
        if k=='GetFrameRef' then return function(self,key) return self.refs[key] end end
        if k=='SetAttribute' then return function(self,key,value) self.attrs[key]=value end end
        if k=='GetAttribute' then return function(self,key) return self.attrs[key] end end
        if k=='IsMouseOver' then return function(self) return self.mouseOver end end
        if k=='GetAlpha' then return function(self) return self.alpha end end
        if k=='SetAlpha' then return function(self,a)
            if protectedRoot and state.combat and not secureDispatch then
                protectedSetAttempts = protectedSetAttempts + 1
                error('insecure protected-root SetAlpha during combat')
            end
            self.alpha=a
        end end
        if k=='Show' then return function(self) self.visible=true end end
        if k=='Hide' then return function(self) self.visible=false end end
        if k=='SetScript' then return function(self,k,fn) self.scripts[k]=fn end end
        if k=='HookScript' then return function(self,k,fn) self.hooks[k]=self.hooks[k] or {};table.insert(self.hooks[k],fn) end end
        if k=='CreateTexture' or k=='CreateFontString' then return function() return widget() end end
        return function() return true end
    end})
end
issecretvalue=function(value) return value=="secret-token" end
UIParent=widget()
function CreateFrame() return widget() end
function InCombatLockdown() return state.combat end
local secureDriver
function RegisterStateDriver(driver,id,condition)
    driver.stateDriver=id
    driver.secureSnippet=assert(load('return function(self,stateid,newstate)\n'..driver.attrs['_onstate-'..id]..'\nend'))()
    secureDriver=driver
    secureDispatch=true
    driver.secureSnippet(driver,id,state.combat and 'combat' or 'rest')
    secureDispatch=false
end
function UnregisterStateDriver(driver,id)
    assert(driver.stateDriver==id)
    driver.stateDriver=nil
    secureDriver=nil
end
local function secureTransition(mode)
    assert(secureDriver and secureDriver.secureSnippet,'registered combat driver')
    secureDispatch=true
    secureDriver.secureSnippet(secureDriver,secureDriver.stateDriver,mode)
    secureDispatch=false
end
local Logres={Layout={GetActionBarSpec=function(key)
    local roles={secondary='secondary',utility='utility',bar4='secondary',bar5='utility'}
    return {role=assert(roles[key])}
end,Bind=function() return true end}}
function Logres:RegisterModule(name,options)
    local mod=options or {}
    mod.enabled=true
    function mod:IsEnabled() return self.enabled end
    function mod:SubscribeState(fn) self.onState=fn end
    modules[name]=mod;return mod
end
function Logres:GetModule(name) return assert(modules[name],name) end
function Logres:GetState() return state end
Logres.ActionButton={
    CreateCluster=function(_,...) return widget(true) end,
    Create=function(_,parent,...)
        local button=widget()
        button.activationFeedbackFrame=widget()
        return button
    end,
    SetHotkeyLabel=function()end,
}
assert(loadfile(path..'Logres/HUD/PetActionExecutionProbe.lua'))('Logres', Logres)
assert(loadfile(path..'Logres/Actions/Context.lua'))('Logres', Logres)
local pet=modules.PetActionExecutionProbe
pet:OnInitialize()
assert(#pet.buttons==10)
local primary={cluster=widget(true),buttons={}}
for i=1,12 do
    local b=widget();b.activationFeedbackFrame=widget();primary.buttons[i]=b
end
local sides={clusters={}}
for _, key in ipairs({'secondary','utility','bar4','bar5'}) do
    local cluster={frame=widget(true),buttons={}}
    for i=1,12 do
        local b=widget();b.activationFeedbackFrame=widget();cluster.buttons[i]=b
    end
    sides.clusters[key]=cluster
end
modules.PrimaryActions=primary
modules.SecondaryUtilityActions=sides
local context=modules.ActionContext
context:OnInitialize();context:OnEnable()
local function expect(name,primaryAlpha,second,utility)
    assert(context.policyName==name,context.policyName)
    assert(primary.cluster.alpha==primaryAlpha,'primary')
    for _,b in ipairs(primary.buttons) do
        assert(b.activationFeedbackFrame.alpha==primaryAlpha,'primary feedback')
    end
    assert(sides.clusters.secondary.frame.alpha==second,'secondary')
    assert(sides.clusters.bar4.frame.alpha==(name=='combat' and 1 or 0),'bar4')
    assert(sides.clusters.utility.frame.alpha==utility,'utility')
    assert(sides.clusters.bar5.frame.alpha==utility,'bar5')
    for key, cluster in pairs(sides.clusters) do
        local want=key=='bar4' and (name=='combat' and 1 or 0) or (key=='secondary' and second or utility)
        for _, b in ipairs(cluster.buttons) do
            assert(b.activationFeedbackFrame.alpha==want,'feedback '..key)
        end
    end
    assert(pet.cluster.alpha==second,'pet cluster')
    for _, b in ipairs(pet.buttons) do
        assert(b.activationFeedbackFrame.alpha==second,'pet feedback')
    end
    assert(context.petAlpha==second,'context pet debug')
    assert(pet.contextFeedbackCount==10,'pet count')
    assert(context.feedbackFramesUpdated==60,'feedback count')
    assert(context:GetDebugStatus().alphaZeroUsed==(second==0 or utility==0),'alpha-zero debug')
end
expect('world',0,0,0)
assert(context.secureDriverReady and context.secureDriverLastResult=='registered', 'preconfigured driver')
assert(secureDriver and secureDriver.attrs['_onstate-logrescombat'], 'restricted snippet')
state={combat=false,pvpFlagged=true,context='world'};context.onState(state)
expect('pvp',0,0,0)
state={combat=false,pvpFlagged=false,context='instance'};context.onState(state)
expect('instance',0,0,0)
state={combat=true,pvpFlagged=false,context='world'}
context.onState(state)
-- Normal addon state callback must not change protected cluster alpha.
assert(primary.cluster.alpha==0 and pet.cluster.alpha==0,'pre-driver parent alpha unchanged')
assert(protectedSetAttempts==0, 'no insecure protected SetAlpha attempts')
secureTransition('combat')
expect('combat',1,0.85,0.75)
assert(context.protectedRootSkips>=5,'protected mutation skipped')
state={combat=false,pvpFlagged=false,context='world'};context.onState(state);secureTransition('rest')
expect('world',0,0,0)
-- Exactly 70 existing secure buttons supply hover; no overlay is created.
local function enter(button)
    assert(button.hooks.OnEnter and #button.hooks.OnEnter==1,'enter hook')
    button.hooks.OnEnter[1](button)
end
local function leave(button)
    assert(button.hooks.OnLeave and #button.hooks.OnLeave==1,'leave hook')
    button.hooks.OnLeave[1](button)
end
assert(context.hoverHooksInstalled and context.hoverHookCount==70,'hook count')
assert(context.feedbackFramesUpdated==60,'primary+side feedback coverage')
local function expectCluster(source, want, other)
    local p=source=='primary' and primary.cluster or
        source=='pet' and pet.cluster or sides.clusters[source].frame
    assert(p.alpha==want,source..' cluster')
    local b=source=='primary' and primary.buttons or
        source=='pet' and pet.buttons or sides.clusters[source].buttons
    for _,btn in ipairs(b) do
        assert(btn.activationFeedbackFrame.alpha==want,source..' feedback')
    end
    if other then
        local otherCluster=other=='primary' and primary.cluster or
            other=='pet' and pet.cluster or sides.clusters[other].frame
        assert(otherCluster.alpha==0,'unhovered '..other)
    end
end
enter(primary.buttons[1]);expectCluster('primary',1);expectCluster('secondary',0)
assert(context:GetDebugStatus().hoveredPrimary)
leave(primary.buttons[1]);expectCluster('primary',0)
assert(not context:GetDebugStatus().hoveredPrimary)
enter(sides.clusters.secondary.buttons[1]);expectCluster('secondary',0.85,'bar4');expectCluster('pet',0)
leave(sides.clusters.secondary.buttons[1]);expectCluster('secondary',0)
enter(sides.clusters.utility.buttons[1]);expectCluster('utility',0.75,'bar5')
leave(sides.clusters.utility.buttons[1]);expectCluster('utility',0)
enter(sides.clusters.bar4.buttons[1]);expectCluster('bar4',1,'secondary')
leave(sides.clusters.bar4.buttons[1]);expectCluster('bar4',0)
enter(sides.clusters.bar5.buttons[1]);expectCluster('bar5',0.75,'utility')
leave(sides.clusters.bar5.buttons[1]);expectCluster('bar5',0)
enter(pet.buttons[1]);expectCluster('pet',0.85,'secondary')
assert(context.petAlpha==0.85 and context:GetDebugStatus().hoveredPet)
leave(pet.buttons[1]);expectCluster('pet',0)
-- Hover persists over a state change and resolves to the combat policy.
enter(primary.buttons[1])
state={combat=false,pvpFlagged=true,context='world'};context.onState(state)
expectCluster('primary',1)
leave(primary.buttons[1]);expectCluster('primary',0)
enter(sides.clusters.utility.buttons[1]);expectCluster('utility',0.75)
state={combat=true,pvpFlagged=false,context='world'}
secureTransition('combat') -- Also test the opposite event ordering.
context.onState(state)
expect('combat',1,0.85,0.75)
assert(protectedSetAttempts==0,'no protected writes even after driver event')
leave(sides.clusters.utility.buttons[1]);expect('combat',1,0.85,0.75)
state={combat=false,pvpFlagged=false,context='world'};context.onState(state);secureTransition('rest')
expect('world',0,0,0)
-- Disable restores visible combat policy; old hooks may not dim again.
enter(pet.buttons[2]);expectCluster('pet',0.85)
context:OnDisable();expect('combat',1,0.85,0.75)
leave(pet.buttons[2]);expect('combat',1,0.85,0.75)
enter(primary.buttons[2]);expect('combat',1,0.85,0.75)
-- Re-enable does not duplicate secure button hooks and dims again.
context:OnEnable();expect('world',0,0,0)
assert(context.hoverHookCount==70,'no duplicate hooks')
assert(#primary.buttons[2].hooks.OnEnter==1,'no duplicate primary hook')
enter(pet.buttons[3]);expectCluster('pet',0.85,'secondary')
leave(pet.buttons[3]);expectCluster('pet',0)
assert(context.hoverEnterCount >= 8 and context.hoverLeaveCount >= 8,'event counts')
-- A held mouseover must survive either event ordering on combat exit.
enter(primary.buttons[1])
state={combat=true,pvpFlagged=false,context='world'}
secureTransition('combat')
context.onState(state)
expect('combat',1,0.85,0.75)
state={combat=false,pvpFlagged=false,context='world'}
context.onState(state)
secureTransition('rest') -- Native driver may update after addon state.
expectCluster('primary',1)
leave(primary.buttons[1])
expectCluster('primary',0)
assert(context:GetDebugStatus().hoverHooksInstalled,'diagnostics')
assert(context:GetDebugStatus().secureDriverReady,'driver diagnostics')
assert(protectedSetAttempts==0,'no insecure protected cluster mutations')
-- P0492: state publisher misses its OOC transition after the secure
-- driver has already shown combat alphas. The real regen event recovers
-- *all* six addon-owned roots and sibling feedback without polling.
state={combat=true,pvpFlagged=false,context='world'}
secureTransition('combat');context.onState(state)
expect('combat',1,0.85,0.75)
state={combat=false,pvpFlagged=false,context='world'}
secureTransition('rest')
assert(primary.cluster.alpha==1,'P0491 inert rest would strand combat alpha')
context.disableEventFrame.scripts.OnEvent(context.disableEventFrame,'PLAYER_REGEN_ENABLED')
expect('world',0,0,0)
assert(context.postCombatReconciles==1,'regen active reconciliation count')
assert(context.postCombatLastResult=='rest-applied','post-combat settled')
assert(context:GetDebugStatus().ownedPrimaryActualAlpha==0,'owned-root actual alpha')
assert(context:GetDebugStatus().ownedPetActualAlpha==0,'owned-pet actual alpha')
-- If OnLeave was missed across lockdown, the addon-owned mouse truth
-- resets stale hover. A genuinely held mouse stays visible.
enter(primary.buttons[1]);expectCluster('primary',1)
assert(context.hovered.primary==true and not primary.buttons[1].mouseOver)
context.disableEventFrame.scripts.OnEvent(context.disableEventFrame,'PLAYER_REGEN_ENABLED')
expect('world',0,0,0)
assert(context.postCombatHoverRepairs>=1,'stale hover repaired')
primary.buttons[1].mouseOver=true
enter(primary.buttons[1]);expectCluster('primary',1)
context.disableEventFrame.scripts.OnEvent(context.disableEventFrame,'PLAYER_REGEN_ENABLED')
expectCluster('primary',1)
primary.buttons[1].mouseOver=false
leave(primary.buttons[1]);expectCluster('primary',0)
-- Secret/unavailable owned mouse result cannot be inspected to force
-- a hover mutation. Keep the prior token; still reconcile safe roots.
local oldRead=primary.buttons[1].IsMouseOver
primary.buttons[1].IsMouseOver=function() return 'secret-token' end
enter(primary.buttons[1]);expectCluster('primary',1)
local unknownBefore=context.postCombatHoverUnknown
context.disableEventFrame.scripts.OnEvent(context.disableEventFrame,'PLAYER_REGEN_ENABLED')
assert(context.postCombatHoverUnknown>unknownBefore,'unknown preserved')
expectCluster('primary',1)
primary.buttons[1].IsMouseOver=oldRead
leave(primary.buttons[1]);expectCluster('primary',0)
assert(protectedSetAttempts==0,'postcombat path never wrote protected roots in combat')
-- Disable during combat: no protected write, event-driven safe teardown.
state={combat=true,pvpFlagged=false,context='world'}
secureTransition('combat')
context.onState(state)
context:OnDisable()
assert(context.pendingDisableReconcile,'disable deferred during lockdown')
assert(context.secureDriverReady,'secure driver retained through combat')
assert(protectedSetAttempts==0,'disable must not mutate protected root')
state={combat=false,pvpFlagged=false,context='world'}
secureTransition('rest')
context.disableEventFrame.scripts.OnEvent(context.disableEventFrame,'PLAYER_REGEN_ENABLED')
expect('combat',1,0.85,0.75)
assert(not context.pendingDisableReconcile and not context.secureDriverReady,'clean teardown after regen')
-- Driver registration unavailable: fail open to visible combat opacity.
RegisterStateDriver=nil
context:OnEnable()
expect('combat',1,0.85,0.75)
assert(context.secureDriverReady==false,'missing-driver detection')
assert(context.secureDriverLastResult=='unavailable-or-lockdown','missing-driver reason')
print('P0492 actual-source regen, hover truth and fail-open: PASS')
