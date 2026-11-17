-- Actual shared primitive and renderer source, no synthetic aura data access.
local root=assert(arg[1])
local function read(p)local f=assert(io.open(root.."/"..p,"rb"));local s=f:read("*a");f:close();return s end
local function slice(s,a,b)local i=assert(s:find(a,1,true));local j=assert(s:find(b,i+#a,1,true));return s:sub(i,j-1)end
local calls={frames=0,base=0,native=0};local made={}
local function object(parent,kind)
 local o={parent=parent,kind=kind,points={}}
 function o:SetPoint(...)self.points[#self.points+1]={...}end
 function o:SetAllPoints(f)self.all=f end
 function o:SetTexture(t)self.texture=t end
 function o:SetTextColor(...)self.color={...}end
 function o:SetJustifyH(v)self.justify=v end
 function o:SetShadowColor(...)self.shadow={...}end
 function o:SetShadowOffset(...)self.shadowOffset={...}end
 function o:SetFont(...)self.font={...}end
 function o:SetWidth(w)self.width=w end
 function o:SetWordWrap(v)self.wrap=v end
 function o:CreateTexture()local t=object(self,"Texture");made[#made+1]=t;return t end
 function o:CreateFontString(_,_,font)local t=object(self,"FontString");t.inherits=font;return t end
 function o:SetVertexColor()error("native frame art must not be filter-tinted")end
 return o
end
local L={Theme={statusAura={assets={frame="approved-aura-frame"}}}}
local env={};setmetatable(env,{__index=_G})
local nativeSource=read("Logres/HUD/NativeDebuffs.lua")
assert(nativeSource:find("-- P0465 shared source-independent aura presentation.",1,true))
local boundary=assert(nativeSource:find("-- P0183:",1,true))
assert(load(nativeSource:sub(1,boundary-1),"actual-presentation","t",env))(nil,L)
local P=L.AuraPresentation
local frame=object(nil,"Frame");local base=P.CreateBase(frame)
assert(base.icon.parent==frame and base.border.parent==frame)
assert(base.icon.points[1][4]==2 and base.icon.points[2][4]==-2)
assert(base.border.texture=="approved-aura-frame" and base.border.all==frame)
local count,duration=P.CreateNativeMetadata(frame)
assert(count~=duration and count.parent==frame and duration.parent==frame)
assert(count.points[1][1]=="BOTTOMRIGHT" and duration.points[1][1]=="BOTTOMRIGHT")
assert(count.points[1][4]~=duration.points[1][4],"metadata cells overlap")
assert(count.inherits=="GameFontHighlightSmall" and duration.inherits==count.inherits)
-- Execute the initializer actually handed to AddAuraGroup, not a restatement.
local code=read("Logres/HUD/NativeDebuffs.lua")
local start=assert(code:find('local function createOwnedWorldAura',1,true))
local world=code:sub(start)
local init=slice(world,'initializeFrame = function(button)','\n        end,'):gsub('initializeFrame = ', 'return ',1)..'\nend'
local button=object(nil,"AuraButton")
function button:SetSize(w,h)self.size={w,h}end
function button:EnableMouse(v)assert(v==false)end
function button:SetIcon(t)self.icon=t end
function button:SetApplicationCount(t)self.count=t end
function button:SetDurationText(t)self.duration=t end
function button:GetChildren()error("native child inspection")end
function button:GetAuraData()error("native payload inspection")end
function button:SetDurationCooldown()error("radial sweep returned")end
local initEnv={Logres=L,ICON=25};setmetatable(initEnv,{__index=_G})
assert(load(init,"actual-native-style","t",initEnv))()(button)
assert(button.icon and button.count and button.duration)
assert(button.size[1]==25 and button.size[2]==25)
assert(read("Logres/HUD/StatusAuras.lua"):find('Logres.AuraPresentation.CreateBase(slot)',1,true))
print("P0465 actual-source PASS: shared approved frame/inset, untinted art, native text/count consumers, no cooldown widget or secret reads")
