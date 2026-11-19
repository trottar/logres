-- P0494 actual production action-button ownership, no WoW client assumptions.
local root = arg[0]:gsub('tools/test_p0494_keybind_button_owner.lua$', '')
local function object(parent, typ)
    local o={parent=parent,kind=typ,shown=true,scripts={},hooks={},alpha=1}
    setmetatable(o,{__index=function(self,k)
        if k=='CreateTexture' then return function(s) return object(s,'Texture') end end
        if k=='CreateFontString' then return function(s) return object(s,'FontString') end end
        if k=='CreateAnimationGroup' then return function(s) return object(s,'AnimationGroup') end end
        if k=='CreateAnimation' then return function(s) return object(s,'Animation') end end
        if k=='SetScript' then return function(s,n,v) s.scripts[n]=v end end
        if k=='HookScript' then return function(s,n,v) s.hooks[n]=v end end
        if k=='Hide' then return function(s) s.shown=false end end
        if k=='Show' then return function(s) s.shown=true end end
        if k=='SetText' then return function(s,t) s.text=t end end
        if k=='GetStringWidth' then return function(s) return #(s.text or '')*6 end end
        if k=='SetAlpha' then return function(s,a) s.alpha=a end end
        if k=='SetDrawLayer' then return function(s,layer,sublevel) s.layer=layer;s.sublevel=sublevel end end
        if k=='SetFrameStrata' then return function(s,a) s.strata=a end end
        if k=='SetFrameLevel' then return function(s,a) s.level=a end end
        return function() return true end
    end})
    return o
end
UIParent=object(nil,'UIParent')
function CreateFrame(kind,name,parent) return object(parent,kind) end
local Logres={Theme={action={}},ActionButton={}}
assert(loadfile(root..'Logres/Actions/Button.lua'))('Logres',Logres)
local ActionButton=Logres.ActionButton
local cluster=ActionButton.CreateCluster('P0494Fixture',2,2,0,0,0)
local button=ActionButton.Create('P0494SecureAction',cluster,1,2)
assert(button.parent==cluster,'action must remain in its existing cluster')
assert(button.activationFeedbackFrame.parent==UIParent,'press/activation feedback remains alpha-isolated')
assert(button.activationFlash.parent==button.activationFeedbackFrame,'flash unaffected')
assert(button.activationPressedOverlay.parent==button.activationFeedbackFrame,'pressed flash unaffected')
assert(button.hotkeyPlateBorder.parent==button,'plate border must inherit action alpha')
assert(button.hotkeyPlateFill.parent==button,'plate fill must inherit action alpha')
assert(button.hotkeyText.parent==button,'hotkey text must inherit action alpha')
assert(button.hotkeyPlateBorder.sublevel==0 and button.hotkeyPlateFill.sublevel==1
       and button.hotkeyText.sublevel==2,'accepted P0118 layer ordering')
ActionButton.SetHotkeyLabel(button,'CTRL-Q')
assert(button.hotkeyText.text=='c-Q','compact binding metadata retained')
assert(button.hotkeyText.shown and button.hotkeyPlateBorder.shown and button.hotkeyPlateFill.shown,
       'key label nonempty presentation')
cluster:SetAlpha(0)
assert(cluster.alpha==0,'resting action root alpha0 retained')
-- Text/plate and button now have the same alpha ancestor; no sibling
-- SetAlpha can independently hide keybinds during secure combat reveal.
assert(button.hotkeyText.parent==button and button.parent==cluster,'shared alpha ancestor')
cluster:SetAlpha(0.75)
assert(cluster.alpha==0.75 and button.hotkeyText.parent==button,'utility combat alpha inherited')
ActionButton.SetHotkeyLabel(button,'')
assert(not button.hotkeyText.shown and not button.hotkeyPlateBorder.shown and not button.hotkeyPlateFill.shown,
       'unbound action plate hidden')
assert(button.activationFeedbackFrame.parent==UIParent,'activated press surface still independent')
print('P0494 actual Button.lua keybind parent, normalization and flash isolation: PASS')
