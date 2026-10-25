#!/usr/bin/env python3
"""P0336 bounded same-bearing, shared one-baseline compass glyph declutter."""
from pathlib import Path
import re,sys

def reserve(x,width,occupied,gap=3):
    if not isinstance(x,(int,float)) or not isinstance(width,(int,float)) or width<=0: return False
    if any(abs(x-entry[0]) < (width+entry[1])/2+gap for entry in occupied): return False
    occupied.append((x,width))
    return True

def run_fixtures():
    u=[]
    assert reserve(0,12,u) and not reserve(0,9,u) and len(u)==1
    assert not reserve(11,9,u) and reserve(17,9,u)
    u=[]
    assert reserve(-15,18,u) and not reserve(-4,8,u) and reserve(10,8,u)
    # A rejected row must not exhaust the pool index or prevent a later clear candidate.
    u=[]; shown=[]
    for x,w in [(0,12),(1,9),(22,9),(22,10),(40,8)]:
        if len(shown)>=3: break
        if reserve(x,w,u):shown.append(x)
    assert shown==[0,22,40], shown
    # Shared map across distinct marker families, prioritizing quest over POI/service/tracking.
    u=[]
    assert reserve(3,14,u) and not reserve(3,9,u) and reserve(40,9,u)
    print('P0336 pure position/width/priority/slot fixtures: PASS 5/5')

if '--selftest' in sys.argv:
    run_fixtures();raise SystemExit(0)
R=Path(__file__).resolve().parents[1]
read=lambda p:(R/p).read_text(encoding='utf8')
C=read('Logres/Navigation/Compass.lua')
A=read('tools/check_p0220_available_quest_poi_contract.py')
B=read('tools/check_p0222_native_map_marker_contract.py')
I=read('docs/memory/investigations/ISSUE_REGISTER.md')
CUR=read('docs/memory/CURRENT.md')
H=read('docs/memory/handoffs/CURRENT_HANDOFF.md')
T=read('Logres/Logres.toc')
BOOT=read('Logres/Core/Bootstrap.lua')
def need(ok,msg):
    if not ok:raise AssertionError(msg)
helper=C[C.index('local function reserveMarkerBearing('):C.index('local BASELINE_HEIGHT',C.index('local function reserveMarkerBearing('))]
for x in ('local function reserveMarkerBearing(x, width, occupied)',
          'math.abs(x - used.x) < (width + used.width) / 2 + MARKER_GAP',
          'occupied[#occupied + 1] = { x = x, width = width }','return true'):
    need(x in helper, 'common true-bearing reservation missing '+x)
need(C.count('reserveMarkerBearing(')>=3,'preview and live must share one reservation helper')
paint=C[C.index('local occupied = {}',C.index('function Compass:RefreshAvailableQuestPOIs')):C.index('paint(majorQuests,self.questDestinationMarkers',C.index('function Compass:RefreshAvailableQuestPOIs'))]
for x in ('local occupied = {}','if self.waypointMarkerShown','self.waypointRelativeDegrees * PIXELS_PER_DEGREE',
          'local rendered = 0','for index = 1, #items do',
          'reserveMarkerBearing(candidate.x, markerWidth, occupied)',
          'self.poiCollisionHiddenCount = self.poiCollisionHiddenCount + 1',
          'glyph:SetPoint("CENTER", self.frame, "CENTER", candidate.x, TAPE_Y)',
          'glyph:SetAlpha((roleStyle.alpha or 0.90)',
          'self.focusedQuestDistanceYards = candidate.distance'):
    need(x in paint,'single tape/after-overlap candidate scanner missing '+x)
for f in ('lane * 9','TAPE_Y+16','TAPE_Y-12','TAPE_Y+5'):
    need(f not in paint,'retired vertical lane used '+f)
need('self.artworkPreviewRoles = roles' in C and
     'for _, role in ipairs(self.artworkPreviewRoles) do' in C and
     'reserveMarkerBearing(role[5], role[3].width or 9, occupied)' in C and
     'glyph:SetPoint("CENTER", self.frame, "CENTER", role[5], TAPE_Y)' in C,
     'same-helper one-line preview missing')
need('poiCollisionHiddenCount = self.poiCollisionHiddenCount' in C and
     'self.poiCollisionHiddenCount = 0' in C,
     'overlap diagnostic not reset/reported')
for s in (A,B):
    need("'reserveMarkerBearing(candidate.x, markerWidth, occupied)'" in s,
         'P0220/P0222 old lane formula not migrated')
    need("'TAPE_Y + lane * 9'" not in s,
         'historical vertical lane falsely pinned')
for token in ('source.availableQuestRows','source.questMapRows','source.areaPoiRows',
              'source.vignetteRows','source.superTrackedQuestID',
              'paint(majorQuests,self.questDestinationMarkers,questStyle,"quest")',
              'paint(localPOIs,self.availableQuestPoiMarkers,poiStyle,"poi")',
              'paint(services,self.serviceMarkers,poiStyle,"service")',
              'paint(tracked,self.trackingMarkers,trackingStyle,"tracking")'):
    need(token in C,'source/role coverage lost: '+token)
for bad in ('C_QuestLog.','C_SuperTrack.','C_VignetteInfo.','C_Timer.NewTicker(',
            'RegisterStateDriver(', 'HideUIPanel(', 'SetUserWaypoint('):
    need(bad not in C,'unsafe source or mutation: '+bad)
need('frame:SetFrameStrata("BACKGROUND")' in C,'P0331 menu layering changed')
need(len([x for x in T.splitlines() if x.endswith('.lua')])==94,'loaded Lua inventory drift')
ver=re.search(r'^## Version: (\S+)$',T,re.M)
boot=re.search(r'^Logres.VERSION = "([^"]+)"$',BOOT,re.M)
need(ver and boot and ver.group(1)==boot.group(1),'Bootstrap/TOC mismatch')
need('L-032' in I and 'P0336' in I,'L-032 triage missing')
for n in range(317,337): need(f'P{n:04d}' in CUR,'CURRENT history '+str(n))
for s in ('P0326','P0327','P0334','P0335','P0336','CURRENT.md'):
    need(s in H,'handoff continuity '+s)
for p in ('docs/memory/evidence/P0336_COMPASS_SINGLE_BASELINE.md',
          'docs/memory/patches/P0336_COMPASS_SINGLE_BASELINE.md'):
    s=read(p);need('UNVERIFIED' in s and s.endswith('\n') and not s.endswith('\n\n'),
                   p+' deferred record hygiene')
run_fixtures()
print('P0336 compass shared true-bearing baseline / hidden collision contract: PASS (STATIC)')
