-- Actual-source P0488 regression: Forever combat-secret snapshot must recover
-- without a new UNIT_AURA when ADDON_RESTRICTION_STATE_CHANGED clears.
local path = arg[0]:gsub('tools/test_p0488_player_buff_recovery.lua$', '')
local frames, modules = {}, {}
local secureDispatch = false
local combat, restricted, buffs = false, false, 6
local function object()
    local o = { visible = false, handlers = {}, events = {}, refs = {}, attrs = {} }
    return setmetatable(o, {__index = function(self, key)
        if key == 'CreateTexture' or key == 'CreateFontString' then
            return function() return object() end
        end
        if key == 'SetScript' then
            return function(self, kind, handler) self.handlers[kind] = handler end
        end
        if key == 'HookScript' then
            return function(self, kind, handler) self.handlers['hook-' .. kind] = handler end
        end
        if key == 'RegisterEvent' then
            return function(self, event) self.events[event] = true end
        end
        if key == 'RegisterUnitEvent' then
            return function(self, event) self.events[event] = true end
        end
        if key == 'UnregisterAllEvents' then
            return function(self) self.events = {} end
        end
        if key == 'SetFrameRef' then
            return function(self, name, frame) self.refs = self.refs or {}; self.refs[name]=frame end
        end
        if key == 'GetFrameRef' then return function(self, name) return self.refs[name] end end
        if key == 'SetAttribute' then
            return function(self,name,value) self.attrs=self.attrs or {};self.attrs[name]=value end
        end
        if key == 'SetShown' then
            return function(self, shown) self.visible = shown end
        end
        if key == 'Show' then
            return function(self)
                if self == BuffFrame and combat then assert(secureDispatch, 'native combat Show must be secure') end
                self.visible = true
            end
        end
        if key == 'Hide' then
            return function(self)
                if self == BuffFrame and combat then assert(secureDispatch, 'native combat Hide must be secure') end
                self.visible = false
            end
        end
        if key == 'IsShown' then
            return function(self) return self.visible end
        end
        if key == 'SetTexture' then
            return function(self, texture) self.texture = texture end
        end
        if key == 'SetHeight' then
            return function(self, height) self.height = height end
        end
        return function() end
    end})
end
function CreateFrame() local o = object(); frames[#frames+1] = o; return o end
UIParent = object()
BuffFrame = object(); BuffFrame.visible = true
function InCombatLockdown() return combat end
local buffDriver
function RegisterStateDriver(driver, state, condition)
    assert(state == 'logresbuffcombat' and condition == '[combat] combat; rest')
    driver.callback = assert(load('return function(self,stateid,newstate)\n'..
        driver.attrs['_onstate-'..state]..'\nend'))()
    buffDriver = driver
    secureDispatch=true
    driver.callback(driver,state,'rest')
    secureDispatch=false
end
function UnregisterStateDriver(driver,state)
    assert(buffDriver == driver and state == 'logresbuffcombat')
    buffDriver=nil
end
local function secureTransition(value)
    assert(buffDriver and buffDriver.callback)
    secureDispatch=true
    buffDriver.callback(buffDriver,'logresbuffcombat',value)
    secureDispatch=false
end
function issecretvalue(value) return false end
C_Secrets = { ShouldUnitAuraIndexBeSecret = function(unit, idx, filter)
    assert(unit == 'player' and filter == 'HELPFUL')
    return restricted
end }
C_UnitAuras = { GetAuraDataByIndex = function(unit, idx, filter)
    assert(unit == 'player' and filter == 'HELPFUL')
    if idx > buffs then return nil end
    return { icon = idx + 1000, applications = 1 }
end }
local Logres = {Theme = {playerHelpfulAuras = {}}, Layout = {Bind=function()end}}
function Logres:RegisterModule(name, options)
    local m = { enabled = true }
    function m:IsEnabled() return self.enabled end
    function m:SubscribePreferences() end
    function m:OwnCleanup() end
    modules[name] = m
    return m
end
function Logres:GetModule(name)
    assert(modules[name], 'missing module '.. name)
    return modules[name]
end
function Logres:GetPreferences() return {immersionEnabled = true} end
function Logres:GetPreference(name) assert(name=='immersionEnabled');return true end
function Logres:ToggleDevPanel() end
function Logres:RegisterEvent() end
assert(loadfile(path..'Logres/HUD/PlayerHelpfulAuras.lua'))('Logres',Logres)
assert(loadfile(path..'Logres/Immersion/NativeSurfaceReplacement.lua'))('Logres',Logres)
local helpful,native = modules.PlayerHelpfulAuras,modules.NativeSurfaceReplacement
helpful:OnInitialize(); native:OnInitialize()
helpful:OnEnable();native:OnEnable()
local helpfulFrame=helpful.eventFrame
assert(helpfulFrame.events.ADDON_RESTRICTION_STATE_CHANGED)
assert(helpful.restrictionRegistered)
-- Starting from a complete out-of-combat buff display, native is folded.
assert(helpful.root.visible and helpful.visibleCount==6 and helpful.lastCoverageReady)
assert(native.snapshots.playerBuffs and not BuffFrame.visible)
-- Enter combat and lose all 40 secret-restricted source indices.
combat=true;restricted=true
secureTransition('combat')
helpfulFrame.handlers.OnEvent(nil,'UNIT_AURA')
assert(BuffFrame.visible, 'secure combat entry must reveal native stock buffs')
assert(not helpful.root.visible and helpful.visibleCount==0)
assert(helpful.lastSecretSkipCount==40 and not helpful.lastCoverageReady)
assert(native.snapshots.playerBuffs)
-- Combat release arrives before ordinary aura data becomes readable.
combat=false
secureTransition('rest')
native:Reconcile('PLAYER_REGEN_ENABLED')
assert(BuffFrame.visible and not native.snapshots.playerBuffs)
helpfulFrame.handlers.OnEvent(nil,'ADDON_RESTRICTION_STATE_CHANGED')
assert(not helpful.root.visible and not helpful.lastCoverageReady)
assert(BuffFrame.visible and not native.snapshots.playerBuffs,
    'incomplete scan must fail open to stock')
local first=helpful.restrictionRecoveryCount
-- Restricted state fully releases, but NO new UNIT_AURA is sent.
restricted=false
helpfulFrame.handlers.OnEvent(nil,'ADDON_RESTRICTION_STATE_CHANGED')
assert(helpful.visibleCount==6 and helpful.root.visible and helpful.lastCoverageReady,
    'ordinary buffs must reappear without a rebuff')
assert(native.snapshots.playerBuffs and not BuffFrame.visible,
    'stock BUFFS should re-fold only after complete coverage')
local dbg=helpful:GetDebugStatus()
assert(dbg.restrictionRegistered and dbg.restrictionRecoveryCount==first+1)
assert(dbg.restrictionReconcileCount==first+1)
assert(dbg.restrictionReconcileFailures==0)
assert(dbg.restrictionRecoveryLastCoverage and dbg.lastRefreshReason=='restriction-release')
-- A transition during combat may not force a recovery or fold stock.
combat=true;restricted=true
secureTransition('combat')
helpfulFrame.handlers.OnEvent(nil,'ADDON_RESTRICTION_STATE_CHANGED')
assert(helpful.restrictionRecoveryCount==first+1)
-- Native access by choice remains respected on ordinary recovery.
combat=false;restricted=false
secureTransition('rest')
native.manual.playerBuffs=true
native:Reconcile('manual-open')
assert(BuffFrame.visible)
helpfulFrame.handlers.OnEvent(nil,'ADDON_RESTRICTION_STATE_CHANGED')
assert(helpful.root.visible and BuffFrame.visible and not native.snapshots.playerBuffs)
assert(not native.snapshots.playerBuffs, 'manual BUFFS must disarm secure fallback')
-- Missing driver capability must fail open to stock rather than folding it.
native.manual.playerBuffs = false
RegisterStateDriver = nil
native:Reconcile('unavailable-secure-fallback')
assert(BuffFrame.visible and not native.snapshots.playerBuffs,
    'native buffs must remain usable when secure state driver is unavailable')
assert(native.lastError == 'stock-buff-secure-fallback-unavailable')
print('P0488/P0495 actual-source player buffs secure fallback/recovery PASS')
