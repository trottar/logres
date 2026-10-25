#!/usr/bin/env python3
"""P0222: source-backed compass marker families are distinct from waypoint/art preview."""
from pathlib import Path
R=Path(__file__).resolve().parents[1]
P=(R/'Logres/Navigation/NavigationSourceProbe.lua').read_text()
C=(R/'Logres/Navigation/Compass.lua').read_text()
D=(R/'Logres/Core/Commands.lua').read_text()
errors=[]
for a in ('function Probe:ReadQuestMapPOIs()', 'C_QuestLog.GetQuestsOnMap',
          'if isSecret(rawRow) then',
          'isQuestStart', 'questMapRows', 'function Probe:ReadVignettes()',
          'C_VignetteInfo.GetVignettes', 'C_VignetteInfo.GetVignettePosition',
          'self:ReadQuestMapPOIs()', 'self:ReadVignettes()',
          '"VIGNETTES_UPDATED"', 'questMap=scanned:', 'vignettes=scanned:'):
 if a not in P:errors.append('missing native position source: '+a)
for a in ('self.questDestinationMarkers', 'self.trackingMarkers',
          'source.questMapRows', 'source.areaPoiRows', 'source.vignetteRows',
          'source.availableQuestRows', 'reserveMarkerBearing(candidate.x, markerWidth, occupied)',
          'edgeFadeForMagnitude(candidate.magnitude)',
          'questDestinationShown = self.questDestinationShown',
          'trackingShown = self.trackingShown',
          'availableQuestPoiShown = self.availableQuestPoiShown'):
 if a not in C:errors.append('missing compass source/role render: '+a)
if 'compass markers:' not in D:errors.append('panel must report non-waypoint role counts')
for f in ('C_QuestLog.', 'C_VignetteInfo.', 'C_AreaPoiInfo.', 'C_QuestLine.'):
 if f in C:errors.append('source API imported into presentation module '+f)
for f in ('C_Timer.', 'hooksecurefunc', 'EnumeratePins', 'SetUserWaypoint', 'RegisterStateDriver('):
 if f in P:errors.append('forbidden source mutation/hook '+f)
for f in ('C_Timer.', 'RegisterStateDriver('):
 if f in C:errors.append('forbidden compass reassertion '+f)
print('P0222 native compass multi-source marker contract')
print('==============================================')
for e in errors:print('ERROR:',e)
print('PASS: 0 errors' if not errors else f'FAILED: {len(errors)} errors')
raise SystemExit(bool(errors))
