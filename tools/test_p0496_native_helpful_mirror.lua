-- P0496 actual-source native player HELPFUL AuraContainer setup and continuity.
local path = arg[0]:gsub('tools/test_p0496_native_helpful_mirror.lua$', '')
local frames = {}
local combat, restricted, nBuff = false, false, 7
local function object(kind)
    local o={kind=kind,shown=false, handlers={},events={}}
    return setmetatable(o,{__index=function(self,key)
        if key=='CreateTexture' or key=='CreateFontString' then return function()return object('region')end end
        if key=='Show' then return function(self)self.shown=true end end
        if key=='Hide' then return function(self)self.shown=false end end
        if key=='SetShown' then return function(self,shown)self.shown=shown end end
        if key=='IsShown' then return function(self)return self.shown end end
        if key=='SetScript' then return function(self,event,cb)self.handlers[event]=cb end end
        if key=='RegisterEvent' or key=='RegisterUnitEvent' then return function(self,e)self.events[e]=true end end
        if key=='SetUnit' then return function(self,u)self.unit=u end end
        if key=='SetEnabled' then return function(self,b)self.enabled=b end end
        if key=='UpdateAllAuras' then return function(self)self.updates=(rawget(self,"updates") or 0)+1 end end
        if key=='AddAuraGroup' then return function(self,n,f,d)self.group={name=n,filter=f,config=d} end end
        if key=='SetPoint' then return function(self,...)self.point={...} end end
        if key=='SetFrameStrata' then return function(self,strata)self.strata=strata end end
        if key=='SetFlowLayoutMaximumLineSize' then return function(self,v)self.maxLine=v end end
        return function()end
    end})
end
function CreateFrame(kind)
    local frame=object(kind);frames[#frames+1]=frame;return frame
end
UIParent=object('ui')
AnchorUtil={FlowDirection={Right=1,Up=2}}
C_AddOns={IsAddOnLoaded=function(n)assert(n=='Blizzard_AuraContainer');return true end}
function InCombatLockdown()return combat end
function issecretvalue(v)return false end
C_Secrets={ShouldUnitAuraIndexBeSecret=function(unit,index,filter)
    assert(unit=='player' and filter=='HELPFUL');return restricted
end}
C_UnitAuras={GetAuraDataByIndex=function(unit,index,filter)
    assert(unit=='player' and filter=='HELPFUL')
    if index>nBuff then return nil end
    return {icon=1000+index,applications=1}
end}
local modules={}
local Logres={Theme={playerHelpfulAuras={iconSize=36,gap=7},statusAura={}},Layout={Bind=function(f,k)f.layoutKey=k end}}
function Logres:RegisterModule(name)
    local m={}
    function m:SubscribePreferences() end
    function m:OwnCleanup() end
    function m:IsEnabled()return true end
    modules[name]=m;return m
end
function Logres:GetPreferences()return {immersionEnabled=true}end
function Logres:GetModule(name)return modules[name]end
function Logres:RegisterEvent()end
assert(loadfile(path..'Logres/HUD/NativeDebuffs.lua'))('Logres',Logres)
assert(loadfile(path..'Logres/HUD/PlayerHelpfulAuras.lua'))('Logres',Logres)
local helpful=modules.PlayerHelpfulAuras
helpful:OnInitialize(); helpful:OnEnable()
local native=helpful.nativeHelpfulFrame
assert(native and helpful.nativeHelpfulActive, 'native mirror not prepared')
local missing,missingReason=Logres.NativeDebuffs.CreatePlayerHelpfulMirror()
assert(missing==nil and missingReason=='player-helpful-anchor-unavailable',
    'missing placement owner must fail open')
assert(native.group and native.group.filter=='HELPFUL' and native.group.config.maxFrameCount==40)
assert(native.unit=='player' and native.enabled and native.shown and native.updates>0)
assert(helpful.root.layoutKey=='passiveStatus' and rawget(native,'layoutKey')==nil)
assert(native.point and native.point[1]=='BOTTOMLEFT' and native.point[2]==helpful.root
    and native.point[3]=='LEFT' and native.point[4]==0 and native.point[5]==-18,
    'first native icon must follow original player helpful first-row anchor')
assert(native.strata=='LOW' and native.maxLine==4*36+3*7)
assert(helpful.visibleCount==7 and not helpful.root.shown,'ordinary Lua rendering must not duplicate native')
combat=true;restricted=true
helpful.eventFrame.handlers.OnEvent(nil,'UNIT_AURA')
assert(helpful.lastSecretSkipCount==40 and helpful.visibleCount==0 and not helpful.root.shown)
assert(native.shown and native.enabled, 'native source must survive secret-only combat')
combat=false;restricted=false
helpful.eventFrame.handlers.OnEvent(nil,'ADDON_RESTRICTION_STATE_CHANGED')
assert(native.shown and helpful.visibleCount==7 and helpful.lastCoverageReady)
assert(not helpful.root.shown and helpful.nativeHelpfulActive)
helpful:SetPreviewEnabled(true)
assert(not native.shown and helpful.root.shown, 'preview isolates native source')
helpful:SetPreviewEnabled(false)
assert(native.shown and not helpful.root.shown, 'preview exit restores native source')
-- Fail-open on absent client template/Blizzard dependency; never declare ready.
C_AddOns.IsAddOnLoaded=function() return false end
C_AddOns.LoadAddOn=function()return false end
local frame,reason=Logres.NativeDebuffs.CreatePlayerHelpfulMirror(helpful.root)
assert(frame==nil and reason=='player-helpful-native-unavailable')
print('P0496 actual-source HELPFUL native mirror/restriction/preview PASS')
