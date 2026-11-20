-- Actual-source P0500 corpse compass: no Blizzard UI modification.
local root = arg[1] or arg[0]:gsub('tools/test_p0500_corpse_compass.lua$', '')
if root:sub(-1) ~= '/' then root=root..'/' end
local Logres = {Theme={compass={}}}
function Logres:RegisterModule(name, object) self[name]=object;return object end
assert(loadfile(root..'Logres/Navigation/Compass.lua'))('Logres',Logres)
local Compass=assert(Logres.Compass)
local marker={shown=false}
function marker:Show() self.shown=true end
function marker:Hide() self.shown=false end
function marker:ClearAllPoints() self.point=nil end
function marker:SetPoint(...) self.point={...} end
function marker:SetAlpha(a) self.alpha=a end
local c=setmetatable({
    policyEligible=true,presentationActive=true,headingDegrees=0,
    frame={},corpseMarker=marker,corpseSampleCount=0,
    corpseSecretDeferrals=0,
},{__index=Compass})
local dead=true
local corpse={x=0.75,y=0.5}
local player={x=0.5,y=0.5}
local map=12
issecretvalue=function(x) return type(x)=='table' and x.secret==true end
UnitIsDeadOrGhost=function() return dead end
C_DeathInfo={GetCorpseMapPosition=function(id) assert(id==map);return corpse end}
C_Map={
 GetBestMapForUnit=function(unit) assert(unit=='player');return map end,
 GetPlayerMapPosition=function(id,unit) assert(id==map and unit=='player');return player end,
 GetMapWorldSize=function(id) assert(id==map);return 1000,600 end,
}
assert(c:RefreshCorpseBearing('fixture-ghost'))
assert(c.corpseSourcePresent and c.corpseMarkerShown and marker.shown)
assert(math.abs(c.corpseBearingDegrees-90)<0.00001)
assert(math.abs(c.corpseDistanceYards-250)<0.00001)
assert(not c.corpseEdgeCued and marker.alpha>0.9)
local xRight=c.corpseMarkerOffset
assert(xRight>0)
-- A true bearing behind the player gets a visibly distinct boundary cue.
c.headingDegrees=270
c:UpdateCorpseMarker()
assert(c.corpseEdgeCued and c.corpseMarkerOffset<0
 and marker.alpha<0.9 and c.corpseRelativeDegrees==-180)
-- The ordinary heading change refreshes the same owned marker.
c.headingDegrees=90
c:UpdateCorpseMarker()
assert(not c.corpseEdgeCued and c.corpseMarkerOffset==0)
-- Living/revived players have no corpse marker and no retained position.
dead=false
assert(c:RefreshCorpseBearing('fixture-alive'))
assert(not c.corpseSourcePresent and not c.corpseMarkerShown
 and not marker.shown and c.corpseBearingDegrees==nil)
-- Secret-capable death state must never be compared with a boolean.
dead={secret=true}
assert(not c:RefreshCorpseBearing('fixture-death-secret'))
assert(c.lastCorpseReason=='death-state-unreadable')
assert(c.corpseSecretDeferrals==1 and not marker.shown)
dead=true
-- Secret position and unavailable map projection fail open to stock map.
corpse={secret=true}
assert(not c:RefreshCorpseBearing('fixture-position-secret'))
assert(c.lastCorpseReason=='corpse-position-unreadable' and not marker.shown)
corpse=nil
assert(not c:RefreshCorpseBearing('fixture-no-corpse'))
assert(not marker.shown)
corpse={x=0.75,y=0.5}
C_Map.GetMapWorldSize=function() return nil,nil end
assert(c:RefreshCorpseBearing('fixture-no-world-size'))
assert(c.corpseMarkerShown and c.corpseDistanceYards==nil)
-- Changed world map must not reuse a stale corpse location.
C_DeathInfo.GetCorpseMapPosition=function() return nil end
assert(not c:RefreshCorpseBearing('fixture-wrong-map'))
assert(not c.corpseMarkerShown)
-- Module-off restoration never edits Blizzard waypoints/quest pins.
c:ClearCorpsePresentation('module-disabled')
assert(not marker.shown and c.lastCorpseReason=='module-disabled')
print('P0500 actual-source corpse compass: PASS')
