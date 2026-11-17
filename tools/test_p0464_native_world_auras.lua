-- Executes actual NativeDebuffs source; no client/secret visibility claim.
local root=assert(arg[1])
local function read(p) local f=assert(io.open(root.."/"..p,"rb"));local s=f:read("*a");f:close();return s end
local function slice(s,a,b) local i=assert(s:find(a,1,true));local j=assert(s:find(b,i+#a,1,true));return s:sub(i,j-1) end
local log,objects,fail={}, {}, {}
local function object(kind,parent)
    local o={kind=kind,parent=parent,shown=false,enabled=false}
    function o:Hide() self.shown=false;log[#log+1]="hide" end
    function o:Show() assert(not fail.show);self.shown=true;log[#log+1]="show" end
    function o:SetEnabled(v) assert(not (fail.enable and v));self.enabled=v;log[#log+1]=v and "enable" or "disable" end
    function o:SetUnit(u) assert(not fail.bind);self.unit=u;log[#log+1]="bind:"..u end
    function o:UpdateAllAuras() assert(not fail.update);log[#log+1]="update" end
    function o:EnableMouse(v) assert(v==false);self.mouse=v end
    function o:SetPoint(...) self.point={...} end
    function o:SetSize(w,h) self.width,self.height=w,h end
    function o:SetAllPoints(p) self.all=p end
    function o:SetTexture(t) self.texture=t end
    function o:SetVertexColor(...) self.color={...} end
    function o:SetFlowLayoutAnchorPoint(p) self.flowAnchor=p end
    function o:SetFlowLayoutGrowthDirection(x,y) assert((x==1 or x==-1) and y==1);self.growth={x,y} end
    function o:SetFlowLayoutMaximumLineSize(n) assert(n==81);self.line=n end
    function o:CreateTexture() return object("Texture",self) end
    function o:CreateFontString() return object("FontString",self) end
    function o:SetIcon(i) self.icon=i end
    function o:SetDurationCooldown(v) self.cooldown=v end
    function o:SetApplicationCount(v) self.count=v end
    function o:AddAuraGroup(key,filter,opt)
        assert(not fail.setup);self.filter=filter;self.options=opt
        local b=object("AuraButton",self);opt.initializeFrame(b);self.button=b
    end
    objects[#objects+1]=o;return o
end
local L={Theme={nativeHarmfulAuras={assets={frame="LogresBorder"}}},Layout={Bind=function()end}}
local locked=false
local env={UIParent={},AnchorUtil={FlowDirection={Left=-1,Right=1,Up=1}},
 issecretvalue=function(v) return type(v)=="table" and v.secret==true end,
 InCombatLockdown=function()return locked end,
 C_AddOns={IsAddOnLoaded=function()return true end},
 CreateFrame=function(kind,_,parent) return object(kind,parent) end}
setmetatable(env,{__index=_G})
assert(load(read("Logres/HUD/NativeDebuffs.lua"),"actual-native","t",env))(nil,L)
local N=L.NativeDebuffs
local function nativeRegion(key)
    local token={secret=true};local o={shown=token,original=token,key=key,touches=0}
    function o:IsProtected() return self.protected==true end
    function o:IsForbidden() return false end
    function o:GetPoint() error("forbidden position read") end
    function o:GetNumPoints() error("forbidden position count") end
    function o:IsShown() if fail.capture==key then error("capture") end;return self.shown end
    function o:SetShown(v)
        if (fail.restore==key and v==token) or (fail.suppress==key and v==false) then error("alpha refusal") end
        self.touches=self.touches+1;self.shown=v;log[#log+1]=v==false and "suppress:"..key or "restore:"..key
    end
    return o
end
local parent={scale=1,alpha=1};local secondary={scale=.5,alpha=.5}
local owner=assert(N.PrepareWorldAuraOwner(parent));local other=assert(N.PrepareWorldAuraOwner(secondary))
for _,own in ipairs({owner,other}) do
 for key,f in pairs(own.frames) do
    assert(f.parent==(own==owner and parent or secondary));assert(f.mouse==false and not f.enabled)
    assert(f.options.maxFrameCount==12 and f.options.layout.elementWidth==25)
    assert(f.button.icon and f.button.cooldown and f.button.count)
    assert(f.button.cooldown.mouse==false)
    assert(f.flowAnchor==(key=="harmful" and "BOTTOMRIGHT" or "BOTTOMLEFT"))
 end
end
locked=true;assert(N.PrepareWorldAuraOwner(parent)==nil);locked=false
local h,b=nativeRegion("harmful"),nativeRegion("helpful")
local h2,b2=nativeRegion("harmful2"),nativeRegion("helpful2")
log={};assert(N.BindWorldAuraOwner(owner,"nameplate1",h,b))
local suppress,show
for i,v in ipairs(log)do if v=="show"then show=i end;if v:find("suppress:",1,true)and not suppress then suppress=i end end
assert(show<suppress and h.shown==false and b.shown==false)
assert(N.BindWorldAuraOwner(other,"nameplate2",h2,b2))
assert(owner.frames.harmful.unit=="nameplate1" and other.frames.harmful.unit=="nameplate2")
local count=#log;assert(N.BindWorldAuraOwner(owner,"nameplate1",h,b));assert(#log==count,"steady owner rebound")
fail.restore="harmful";assert(not N.ReleaseWorldAuraOwner(owner))
assert(owner.claim and owner.active and owner.frames.harmful.shown,"replacement lost before restore")
assert(not N.BindWorldAuraOwner(owner,"nameplate3",h,b),"reused pending owner")
assert(not N.BindWorldAuraOwner(owner,"nameplate1",h,b),"same unit bypassed pending restore")
fail.restore=nil;log={};assert(N.ReleaseWorldAuraOwner(owner))
assert(h.shown==h.original and b.shown==b.original and not owner.active)
assert(log[1]=="restore:harmful" and log[2]=="restore:helpful")
assert(N.ReleaseWorldAuraOwner(other));assert(h2.shown==h2.original)
assert(N.BindWorldAuraOwner(other,"nameplate2",h2,b2));h2:SetShown(true)
assert(h2.shown==true,"native re-show must fail open visibly")
assert(N.ReleaseWorldAuraOwner(other))
for _,failure in ipairs({"bind","enable","update","show"}) do
 fail[failure]=true;assert(not N.BindWorldAuraOwner(owner,"nameplate3",h,b));fail[failure]=nil
 assert(h.shown==h.original and b.shown==b.original and not owner.claim)
end
fail.suppress="helpful";assert(not N.BindWorldAuraOwner(owner,"nameplate3",h,b));fail.suppress=nil
assert(h.shown==h.original and b.shown==b.original and not owner.active)
fail.capture="helpful";count=h.touches;assert(not N.BindWorldAuraOwner(owner,"nameplate3",h,b));fail.capture=nil;assert(h.touches==count)
h.protected=true;assert(not N.BindWorldAuraOwner(owner,"nameplate3",h,b));h.protected=false
assert(not N.BindWorldAuraOwner(owner,"target",h,b))
fail.setup=true;assert(N.PrepareWorldAuraOwner(parent)==nil);fail.setup=nil
-- Actual HUD withdrawal paths must retain HP parent until aura restore succeeds.
local HUD={worldEnemyAuraOwner=owner,worldEnemyLiveVisible=true}
local henv={HUD=HUD,Logres=L};setmetatable(henv,{__index=_G})
local source=read("Logres/HUD/HUD.lua")
assert(load(slice(source,"function HUD:HideLiveWorldEnemy(reason)","function HUD:UpdateLiveWorldEnemyValues()"),"actual-hide","t",henv))()
assert(load(slice(source,"function HUD:HideSecondaryAggroOwner(slot, reason)","function HUD:HideSecondaryAggroTrial(reason)"),"actual-secondary-hide","t",henv))()
assert(N.BindWorldAuraOwner(owner,"nameplate3",h,b));fail.restore="harmful"
assert(not HUD:HideLiveWorldEnemy("off") and HUD.worldEnemyLiveVisible)
local slot={auraOwner=owner,visible=true};assert(not HUD:HideSecondaryAggroOwner(slot,"off"));assert(slot.visible and slot.blocked)
fail.restore=nil;assert(N.ReleaseWorldAuraOwner(owner))
print("P0464 actual-source PASS: styled per-unit native consumers, 50/50 inheritance, no point reads, transactional fallback, restore quarantine")
