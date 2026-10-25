#!/usr/bin/env python3
"""P0338 L-031 focused compass yards: identical preview/live renderer, guarded inputs."""
from pathlib import Path
import math
import re
# The isolated fixture mode does not require the whole checked-out repository.
# The production checker below always validates the real sources.
if __import__('sys').argv[1:] == ['--selftest']:
    def demo(name,distance):
        valid=isinstance(distance,(float,int)) and not isinstance(distance,bool) and math.isfinite(distance) and distance>=0
        return f'{name}  ·  ~{math.floor(distance+0.5)} yd' if valid else f'{name}  ·  distance unavailable'
    assert demo('Quest destination',125)=='Quest destination  ·  ~125 yd'
    assert demo('Marker',13.7)=='Marker  ·  ~14 yd'
    assert demo('POI',0)=='POI  ·  ~0 yd'
    assert demo('Waypoint',None).endswith('distance unavailable')
    assert demo('Waypoint',float('nan')).endswith('distance unavailable')
    assert demo('Waypoint',float('inf')).endswith('distance unavailable')
    print('P0338 isolated formatting fixtures: 6/6 PASS')
    raise SystemExit(0)
ROOT=Path(__file__).resolve().parents[1]
read=lambda p:(ROOT/p).read_text(encoding='utf-8')
C=read('Logres/Navigation/Compass.lua')
SOURCE=read('Logres/Navigation/NavigationSourceProbe.lua')
DB=read('Logres/Navigation/QuestieDBNearby.lua')
CURRENT=read('docs/memory/CURRENT.md')
HANDOFF=read('docs/memory/handoffs/CURRENT_HANDOFF.md')
ISSUES=read('docs/memory/investigations/ISSUE_REGISTER.md')
TOC=read('Logres/Logres.toc')
BOOT=read('Logres/Core/Bootstrap.lua')

def need(ok, why):
    if not ok: raise AssertionError(why)

# Pure fixtures are deliberately inert. All 6 cases check the presentation
# acceptance boundary; no native gameplay APIs are invoked from this test.
def focused_text(name,distance):
    valid=isinstance(distance,(float,int)) and not isinstance(distance,bool) and math.isfinite(distance) and distance>=0
    return f'{name}  ·  ~{math.floor(distance+0.5)} yd' if valid else f'{name}  ·  distance unavailable'

def run_fixtures():
    assert focused_text('Quest destination',125)=='Quest destination  ·  ~125 yd'
    assert focused_text('Marker',13.7)=='Marker  ·  ~14 yd'
    assert focused_text('POI',0)=='POI  ·  ~0 yd'
    assert focused_text('Waypoint',None)=='Waypoint  ·  distance unavailable'
    assert focused_text('Waypoint',float('nan')).endswith('distance unavailable')
    assert focused_text('Waypoint',float('inf')).endswith('distance unavailable')
    print('P0338 6/6 pure focus-label fixtures: PASS')

if __import__('sys').argv[1:] == ['--selftest']:
    run_fixtures()
    raise SystemExit(0)

helper=C[C.index('local function ordinaryFocusedDistance('):C.index('local function normalizeRelativeDegrees(value)')]
for item in ('isSecret(distance)', 'type(distance) ~= "number"','distance ~= distance',
             'distance < 0','distance == math.huge',
             'local function showFocusedMarkerLabel(label, name, distance, magnitude)',
             'math.floor(yards + 0.5)', '"distance unavailable"',
             'label:SetText(name .. "  ·  " .. text)', 'label:SetAlpha(fade * fade)',
             'label:Show()', 'return yards'):
    need(item in helper,'missing focused distance guard/renderer: '+item)
need(C.count('showFocusedMarkerLabel(')==3,
     'the same helper must serve one definition, live focus and art preview')
preview=C[C.index('function Compass:UpdateArtworkPreview()'):C.index('function Compass:ClearAvailableQuestPOIs')]
# Role fixtures live in OnInitialize, not UpdateArtworkPreview. R0's
# incorrectly sliced assertion caused the eighth PREWRITE refusal despite
# the candidate correctly changing the static quest role to center bearing.
initialize=C[C.index('OnInitialize = function(self)'):C.index('OnEnable = function(self)')]
need('{ "questDestination", compassAssets.questDestination, questStyle, "CENTER", 0, TAPE_Y },' in initialize,
     'art preview centered quest fixture missing from OnInitialize')
for item in ('self.artworkPreviewShown == shown','self.artworkPreviewRoles',
             'reserveMarkerBearing(role[5], role[3].width or 9, occupied)',
             'showFocusedMarkerLabel(self.availableQuestPoiFocus,',
             '"Quest destination", 125, 0',
             'self.availableQuestPoiFocus:Hide()'):
    need(item in preview,'art preview must use live focus widget/renderer: '+item)
block=C[C.index('function Compass:RefreshAvailableQuestPOIs(reason)'):C.index('function Compass:SetArtworkPreview')]
for item in ('source.currentMapID','source.mapWidth','source.mapHeight',
             'mapID~=source.currentMapID','readVectorXY(position)',
             'dx=(row.x-px)*source.mapWidth','dy=(row.y-py)*source.mapHeight',
             'local distance=math.sqrt(dx*dx+dy*dy)',
             'kind=role, serviceKind=', 'reserveMarkerBearing(candidate.x, markerWidth, occupied)',
             'if candidate.magnitude<=focusDegrees',
             'and (not closestFocus or candidate.distance<closestFocus.distance)',
             'self.poiCollisionHiddenCount = self.poiCollisionHiddenCount + 1',
             'self.focusedQuestDistanceYards = candidate.distance',
             'self.waypointMarkerShown and type(manualRelative) == "number"',
             'self.waypointDistanceAvailable and self.waypointDistanceYards or nil',
             'and (not closestFocus or math.abs(manualRelative) < closestFocus.magnitude)',
             'showFocusedMarkerLabel(self.availableQuestPoiFocus,',
             'closestFocus.name, closestFocus.distance, closestFocus.magnitude)',
             'self.focusedMarkerKind = closestFocus.kind',
             'self.focusedMarkerDistanceAvailable = focusedYards ~= nil',
             'self.focusedMarkerDistanceYards = focusedYards'):
    need(item in block,'focused actual-marker distance or old geometry lost: '+item)
need(block.index('local manualRelative = self.waypointRelativeDegrees') >
     block.index('paint(tracked,self.trackingMarkers,trackingStyle,"tracking")'),
     'manual marker focus must inspect already-painted visible candidates')
need(block.index('self.waypointMarkerShown and type(manualRelative)') >
     block.index('paint(majorQuests,self.questDestinationMarkers,questStyle,"quest")'),
     'waypoint focus may not alter live marker reservation')
clear=C[C.index('function Compass:ClearAvailableQuestPOIs(reason)'):C.index('function Compass:RefreshAvailableQuestPOIs(reason)')]
for item in ('self.focusedMarkerKind = nil','self.focusedMarkerDistanceAvailable = false',
             'self.focusedMarkerDistanceYards = nil','if self.artworkPreview ~= true then',
             'self.availableQuestPoiFocus:Hide()'):
    need(item in clear,'focus must clear on source loss but preserve preview: '+item)
for item in ('focusedMarkerKind = self.focusedMarkerKind',
             'focusedMarkerDistanceAvailable = self.focusedMarkerDistanceAvailable == true',
             'focusedMarkerDistanceYards = self.focusedMarkerDistanceYards'):
    need(item in C[C.index('function Compass:GetDebugStatus()'):],
         'debug status missing addon-owned focus detail: '+item)
for item in ('WAYPOINT_UPDATE_INTERVAL = 0.15','self:RefreshAvailableQuestPOIs("onupdate")',
             'self:RefreshWaypointBearing("onupdate")','self:RefreshHeading("onupdate")',
             'self.artworkPreviewCaption:SetShown(shown)'):
    need(item in C,'existing update/preview lifecycle changed: '+item)
for forbidden in ('C_QuestLog.','C_SuperTrack.','C_QuestLine.','C_TaskQuest.',
                  'C_Timer.NewTicker(', 'hooksecurefunc(', 'SetUserWaypoint(',
                  'HideUIPanel(', 'RegisterStateDriver('):
    need(forbidden not in C,'focus patch must not add source/mutation API: '+forbidden)
for item in ('function Probe:DistanceYards(x, y)','self.mapWidth',
             'self.mapHeight', 'self:ReadNativeOfferFeeds()'):
    need(item in SOURCE,'native map-yard feed changed: '+item)
need('distanceYards = dist, potential = true' in DB,'optional source distance contract changed')
need(re.search(r'(?m)^## Version: (\S+)$',TOC).group(1)==
     re.search(r'(?m)^Logres.VERSION = "([^"]+)"$',BOOT).group(1),
     'runtime version TOC and Bootstrap mismatch')
need(len([x for x in TOC.splitlines() if x.endswith('.lua')])==94,
     'TOC inventory changed')
for item in ('P0337','cfdc07af','P0338','L-031','UNVERIFIED'):
    need(item in CURRENT and item in HANDOFF, 'CURRENT/HANDOFF continuity '+item)
need('P0338 SOURCE-PREPARED / WoW UNVERIFIED' in ISSUES,
     'L-031 issue remains unreconciled')
for path in ('docs/memory/evidence/P0338_FOCUSED_COMPASS_YARDS.md',
             'docs/memory/patches/P0338_FOCUSED_COMPASS_YARDS.md'):
    body=read(path)
    need('UNVERIFIED' in body and body.endswith('\n') and not body.endswith('\n\n'),
         path+' evidence/deferred state hygiene')
run_fixtures()
print('P0338 same-widget preview/live focused yard label + capability gates: PASS (STATIC; WoW UNVERIFIED)')
