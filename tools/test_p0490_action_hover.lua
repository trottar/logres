-- P0490 actual-source per-cluster hover opacity + retained secure action contract.
local path = arg[0]:gsub('tools/test_p0490_action_hover.lua$', '')
local modules, state = {}, {combat=false,pvpFlagged=false,context='world'}
local function widget()
    local o = {alpha=1, visible=false, scripts={}, hooks={}}
    return setmetatable(o, {__index=function(self, k)
        if k=='SetAlpha' then return function(self,a) self.alpha=a end end
        if k=='Show' then return function(self) self.visible=true end end
        if k=='Hide' then return function(self) self.visible=false end end
        if k=='SetScript' then return function(self,k,fn) self.scripts[k]=fn end end
        if k=='HookScript' then return function(self,k,fn) self.hooks[k]=self.hooks[k] or {};table.insert(self.hooks[k],fn) end end
        if k=='CreateTexture' or k=='CreateFontString' then return function() return widget() end end
        return function() return true end
    end})
end
UIParent=widget()
function CreateFrame() return widget() end
function InCombatLockdown() return state.combat end
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
    CreateCluster=function(_,...) return widget() end,
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
local primary={cluster=widget(),buttons={}}
for i=1,12 do
    local b=widget();b.activationFeedbackFrame=widget();primary.buttons[i]=b
end
local sides={clusters={}}
for _, key in ipairs({'secondary','utility','bar4','bar5'}) do
    local cluster={frame=widget(),buttons={}}
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
    assert(sides.clusters.bar4.frame.alpha==second,'bar4')
    assert(sides.clusters.utility.frame.alpha==utility,'utility')
    assert(sides.clusters.bar5.frame.alpha==utility,'bar5')
    for key, cluster in pairs(sides.clusters) do
        local want=(key=='secondary' or key=='bar4') and second or utility
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
expect('world',0.5,0,0)
state={combat=false,pvpFlagged=true,context='world'};context.onState(state)
expect('pvp',0.5,0,0)
state={combat=false,pvpFlagged=false,context='instance'};context.onState(state)
expect('instance',0.5,0,0)
state={combat=true,pvpFlagged=false,context='world'};context.onState(state)
expect('combat',1,1,0.75)
state={combat=false,pvpFlagged=false,context='world'};context.onState(state)
expect('world',0.5,0,0)
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
leave(primary.buttons[1]);expectCluster('primary',0.5)
assert(not context:GetDebugStatus().hoveredPrimary)
enter(sides.clusters.secondary.buttons[1]);expectCluster('secondary',1,'bar4');expectCluster('pet',0)
leave(sides.clusters.secondary.buttons[1]);expectCluster('secondary',0)
enter(sides.clusters.utility.buttons[1]);expectCluster('utility',0.75,'bar5')
leave(sides.clusters.utility.buttons[1]);expectCluster('utility',0)
enter(sides.clusters.bar4.buttons[1]);expectCluster('bar4',1,'secondary')
leave(sides.clusters.bar4.buttons[1]);expectCluster('bar4',0)
enter(sides.clusters.bar5.buttons[1]);expectCluster('bar5',0.75,'utility')
leave(sides.clusters.bar5.buttons[1]);expectCluster('bar5',0)
enter(pet.buttons[1]);expectCluster('pet',1,'secondary')
assert(context.petAlpha==1 and context:GetDebugStatus().hoveredPet)
leave(pet.buttons[1]);expectCluster('pet',0)
-- Hover persists over a state change and resolves to the combat policy.
enter(primary.buttons[1])
state={combat=false,pvpFlagged=true,context='world'};context.onState(state)
expectCluster('primary',1)
leave(primary.buttons[1]);expectCluster('primary',0.5)
enter(sides.clusters.utility.buttons[1]);expectCluster('utility',0.75)
state={combat=true,pvpFlagged=false,context='world'};context.onState(state)
expect('combat',1,1,0.75)
leave(sides.clusters.utility.buttons[1]);expect('combat',1,1,0.75)
state={combat=false,pvpFlagged=false,context='world'};context.onState(state)
expect('world',0.5,0,0)
-- Disable restores visible combat policy; old hooks may not dim again.
enter(pet.buttons[2]);expectCluster('pet',1)
context:OnDisable();expect('combat',1,1,0.75)
leave(pet.buttons[2]);expect('combat',1,1,0.75)
enter(primary.buttons[2]);expect('combat',1,1,0.75)
-- Re-enable does not duplicate secure button hooks and dims again.
context:OnEnable();expect('world',0.5,0,0)
assert(context.hoverHookCount==70,'no duplicate hooks')
assert(#primary.buttons[2].hooks.OnEnter==1,'no duplicate primary hook')
enter(pet.buttons[3]);expectCluster('pet',1,'secondary')
leave(pet.buttons[3]);expectCluster('pet',0)
assert(context.hoverEnterCount >= 8 and context.hoverLeaveCount >= 8,'event counts')
assert(context:GetDebugStatus().hoverHooksInstalled,'diagnostics')
print('P0490 actual-source per-cluster mouseover/rest/combat/disable: PASS')
