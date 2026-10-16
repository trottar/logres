#!/usr/bin/env python3
"""P0223 focused accepted-quest marker and waypoint-derived depth contract."""
from pathlib import Path
import re
R = Path(__file__).resolve().parents[1]
s = (R/'Logres/Navigation/Compass.lua').read_text()
probe = (R/'Logres/Navigation/NavigationSourceProbe.lua').read_text()
cmd = (R/'Logres/Core/Commands.lua').read_text()
errors = []
required = (
  'local focusedQuestID = source.superTrackedQuestID',
  'row.role=="quest" and row.questID==focusedQuestID',
  'self.focusedQuestID = focusedQuestID',
  'manualWaypointDepthScaleForDistance(candidate.distance, radius)',
  'glyph:SetSize((roleStyle.width or 10)*scale,',
  'self.focusedQuestRenderScale = scale',
  'self.focusedQuestDepthBand = band',
  'focusedQuestID = self.focusedQuestID',
  'focusedQuestRenderScale = self.focusedQuestRenderScale',
  'focusedQuestDepthBand = self.focusedQuestDepthBand',
  'paint(majorQuests,self.questDestinationMarkers,questStyle,"quest")',
  'paint(localPOIs,self.availableQuestPoiMarkers,poiStyle,"poi")',
  'paint(tracked,self.trackingMarkers,trackingStyle,"tracking")',
)
for token in required:
  if token not in s: errors.append('missing focused/depth contract: '+token)
if 'source.superTrackedQuestID' not in s: errors.append('missing ordinary selection source')
if 'self.superTrackedQuestID' not in probe: errors.append('probe lost focused quest source')
if 'focusedQuestID=' not in cmd or 'scale=' not in cmd: errors.append('panel has no focus/depth diagnostics')
for forbidden in ('C_QuestLog.', 'C_SuperTrack.', 'C_VignetteInfo.', 'C_Timer.', 'RegisterStateDriver('):
  if forbidden in s: errors.append('compass acquired forbidden API: '+forbidden)
print('P0223 focused quest depth/selection contract')
print('=========================================')
for error in errors: print('ERROR:', error)
print('PASS: 0 errors' if not errors else f'FAILED: {len(errors)} errors')
raise SystemExit(bool(errors))
