-- P0478: load the actual provider label function, not a reimplementation.
local root = (arg and arg[1]) or "."
local f = assert(io.open(root .. "/Logres/Navigation/Compass.lua", "rb"))
local src = f:read("*a"); f:close()
local i = assert(src:find("local function showProviderMapLabel(label, name, distance, magnitude, liveProof)",1,true))
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
assert(show(label,"Vendor [vendor]",2.23,0,false)==nil)
assert(label.text=="Vendor [vendor] - near on map (floor unknown)")
assert(label.shown and label.alpha==1)
assert(show(label,"Vendor [vendor]",7.5,0,false)==nil)
assert(label.text=="Vendor [vendor] - ~8 yd on map (floor unknown)")
assert(show(label,"Vendor [vendor]",2.23,0,true)==nil)
assert(label.text=="Vendor [vendor] - ~2 yd on map")
assert(show(label,"Vendor [vendor]",nil,0,false)==nil)
assert(label.text=="Vendor [vendor] - map position (floor unknown)")
assert(src:find('elseif uncertainNearServiceCandidates > 0 then',1,true))
assert(src:find('self.focusedMarkerKind = "service-map-only"',1,true))
assert(src:find('self.focusedMarkerDistanceAvailable = false',1,true))
print("P0478 actual-source map-only labels: near/far/verified/missing/fallback PASS")
