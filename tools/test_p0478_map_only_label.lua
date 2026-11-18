-- P0478: load the actual provider label function, not a reimplementation.
local root = (arg and arg[1]) or "."
local f = assert(io.open(root .. "/Logres/Navigation/Compass.lua", "rb"))
local src = f:read("*a"); f:close()
local i = assert(src:find("-- Both the inert art fixture and live focused candidates use this renderer.",1,true))
local j = assert(src:find("local function normalizeRelativeDegrees(value)",i,true))
local text = src:sub(i,j-1) .. "\nreturn showProviderMapLabel"
local env = { ordinaryFocusedDistance=function(v)
    if type(v)=="number" and v>=0 and v~=math.huge and v==v then return v end
end, math=math, tostring=tostring, type=type }
local maker,err=load(text,"P0478_provider_label_actual_source","t",env)
assert(maker,err)
local show=maker()
local label={}
function label:SetText(v) self.text=v end
function label:SetAlpha(v) self.alpha=v end
function label:Show() self.shown=true end
-- P0479: historical P0478 label regression, now explicitly rejected.
assert(show(label,"Vendor [vendor]",2.23,0,false)==nil)
assert(label.text=="Vendor [vendor]", "unverified near source must not invent distance")
assert(label.shown and label.alpha==1)
assert(show(label,"Vendor [vendor]",7.5,0,false)==7.5)
assert(label.text=="Vendor [vendor] - 8 yd", "restore accepted exact style")
assert(show(label,"Vendor [vendor]",2.23,0,true)==2.23)
assert(label.text=="Vendor [vendor] - 2 yd", "verified live source uses old style")
assert(show(label,"Vendor [vendor]",nil,0,false)==nil)
assert(label.text=="Vendor [vendor]", "unknown map basis omits distance")
assert(not src:find('Services at map location',1,true))
assert(not src:find('floor unknown',1,true))
assert(not src:find('"~" .. tostring',1,true))
assert(not src:find('self.focusedMarkerKind = "service-map-only"',1,true))
print("P0478/P0479 actual-source legacy visual recovery: no tilde, no generic filler PASS")
