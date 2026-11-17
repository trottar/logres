-- Actual-source behavioral fixture. Run: texlua tools/test_p0468_compatible_aura_grid.lua
local path = arg[0]:gsub("tools/test_p0468_compatible_aura_grid.lua$", "")
local modules = {}
local objects = {}
local function object()
    local o = {visible=false}
    local mt = {}
    function mt.__index(self,key)
        if key=='CreateTexture' or key=='CreateFontString' then
            return function() return object() end
        end
        if key=='SetPoint' then return function(self,...) self.point={...} end end
        if key=='SetSize' then return function(self,w,h) self.width=w;self.height=h end end
        if key=='SetHeight' then return function(self,h) self.height=h end end
        if key=='SetShown' then return function(self,b) self.visible=b end end
        if key=='Show' then return function(self) self.visible=true end end
        if key=='Hide' then return function(self) self.visible=false end end
        if key=='SetTexture' then return function(self,v) self.texture=v end end
        if key=='SetScript' then return function(self,what,cb)self[what]=cb end end
        if key=='AddAuraGroup' then return function(self,name,filter,options)
            local groups=rawget(self,"groups") or {};groups[name]={filter=filter,options=options};rawset(self,"groups",groups)
        end end
        if key=='SetFlowLayoutMaximumLineSize' then return function(self,val)self.maxLine=val end end
        return function() end
    end
    return setmetatable(o,mt)
end
function CreateFrame() local o=object();objects[#objects+1]=o;return o end
UIParent=object()
STANDARD_TEXT_FONT='stub'
AnchorUtil={FlowDirection={Left='left',Right='right',Up='up'}}
function InCombatLockdown() return false end
function issecretvalue(v) return false end
local secretAt=nil
local failAt=nil
local count=12
local observedFilter=nil
C_Secrets={ShouldUnitAuraIndexBeSecret=function(unit,index,filter)
    assert(unit=='player');observedFilter=filter
    if index==failAt then error('test predicate failure') end
    return index==secretAt
end}
C_UnitAuras={GetAuraDataByIndex=function(unit,index,filter)
    assert(unit=='player' and filter=='HELPFUL')
    if index>count then return nil end
    return {icon=index,applications=(index%2)+1}
end}
C_AddOns={IsAddOnLoaded=function()return true end}
local L={ Theme={playerHelpfulAuras={},nativeHarmfulAuras={maxIcons=40}}, Layout={Bind=function()end}, }
function L:RegisterModule(name,options) local m={};modules[name]=m;return m end
function L:GetPreferences() return {immersionEnabled=true} end
L.AuraPresentation={CreateBase=function(frame)return {icon=frame:CreateTexture(),border=frame:CreateTexture()}end,
    CreateNativeMetadata=function(frame)return frame:CreateFontString(),frame:CreateFontString()end}
assert(loadfile(path..'Logres/HUD/PlayerHelpfulAuras.lua'))('Logres',L)
local helpful=assert(modules.PlayerHelpfulAuras)
helpful:OnInitialize()
assert(#helpful.slots==40)
assert(helpful.root.width==165)
local fifth=helpful.slots[5].frame.point
assert(fifth[1]=='LEFT' and fifth[3]=='LEFT' and fifth[4]==0 and fifth[5]==-43)
local preview=helpful:BuildPreviewSnapshot()
assert(#preview.auras==9)
local snapshot=helpful:ReadSnapshot()
assert(#snapshot.auras==12 and snapshot.failures==0 and not snapshot.scanExhausted)
assert(observedFilter=='HELPFUL','should include other-cast helpful buffs')
helpful:RenderSnapshot(snapshot,'fixture')
assert(helpful.visibleCount==12 and helpful.root.height==122 and helpful.lastCoverageReady)
assert(helpful.slots[12].frame.visible and not helpful.slots[13].frame.visible)
count=4
snapshot=helpful:ReadSnapshot();helpful:RenderSnapshot(snapshot,'fixture4')
assert(helpful.root.height==36 and helpful.visibleCount==4 and helpful.lastCoverageReady)
count=41
snapshot=helpful:ReadSnapshot();helpful:RenderSnapshot(snapshot,'fixture41')
assert(#snapshot.auras==40 and snapshot.scanExhausted and not helpful.lastCoverageReady)
count=12;secretAt=7
snapshot=helpful:ReadSnapshot();helpful:RenderSnapshot(snapshot,'restricted')
assert(snapshot.secretSkips==1 and #snapshot.auras==11 and not helpful.lastCoverageReady)
secretAt=nil;failAt=5
local ok,reason=helpful:Refresh('predicate-fail')
assert(not ok and reason=='source-failure' and not helpful.lastCoverageReady)
failAt=nil
assert(loadfile(path..'Logres/HUD/NativeDebuffs.lua'))('Logres',L)
local native=L.NativeDebuffs
assert(native and native.Create)
local built,reason=native.Create()
assert(built and built.frames.player.maxLine==109 and built.frames.target.maxLine==109)
assert(built.frames.player.groups.LogresHarmful.options.maxFrameCount==40)
local parent=object()
local world=native.PrepareWorldAuraOwner(parent)
assert(world and world.frames.harmful.maxLine==109 and world.frames.helpful.maxLine==109)
assert(world.frames.helpful.groups.LogresWorldHELPFUL.options.maxFrameCount==40)
-- Exercise the actual ordinary target helpful/harmful source, including
-- more than four distinct buffs and DoTs with unchanged category routing.
function UnitExists(unit) return unit=='player' or unit=='target' end
C_Secrets.ShouldUnitAuraIndexBeSecret=function() return false end
C_UnitAuras.GetAuraDataByIndex=function(unit,index,filter)
    if unit~='target' then return nil end
    if filter=='HARMFUL' and index<=12 then
        return {icon=index,auraInstanceID=index,
            isFromPlayerOrPlayerPet=(index%2==0),applications=1}
    end
    if filter=='HELPFUL' and index<=9 then
        return {icon=index+200,auraInstanceID=index+200,
            isFromPlayerOrPlayerPet=false,applications=1}
    end
    return nil
end
assert(loadfile(path..'Logres/HUD/StatusAuras.lua'))('Logres',L)
local status=assert(modules.StatusAuras)
L.Theme.statusAura={assets={frame='stub',countPlate='stub'}}
status:OnInitialize()
status.moduleEnabled=true
status:Refresh('fixture-target')
assert(#status.last.target.harmfulRows==12, 'target harmful coverage >4')
assert(#status.last.target.helpfulRows==9, 'other-cast target helpful coverage >4')
assert(status.lanes.target.visible==12 and status.lanes.targetHelpful.visible==9)
local row5=status.lanes.targetHelpful.slots[5].frame.point
assert(row5[1]=='TOPLEFT' and row5[4]==0 and row5[5]==-28)
assert(status.lanes.targetHelpful.slots[9].frame.visible)
status:SetPreview(true)
assert(status.lanes.player.visible==6 and status.lanes.target.visible==6)
assert(status.lanes.targetHelpful.visible==6)
-- Report uses addon-owned status only; formatting must match every field.
function L:GetModuleStatus() return {initialized=true,enabled=true} end
function L:GetModule(name) return modules[name] end
helpful.moduleEnabled=true
count=12
local report
helpful:RunDevHelpfulAuraCheck(function(line) report=line end)
assert(type(report)=='string' and report:find('coverage=true',1,true)
    and report:find('exhausted=false',1,true),'coverage fields missing from report')
print('P0468 actual-source player + target aura grid and native geometry: PASS')
