#!/usr/bin/env python3
"""P0220: source-gated unaccepted quest POI; P0221 permits one keyed request."""
from pathlib import Path

root = Path(__file__).resolve().parents[1]
probe = (root / 'Logres/Navigation/NavigationSourceProbe.lua').read_text()
compass = (root / 'Logres/Navigation/Compass.lua').read_text()
d037 = (root / 'docs/memory/decisions/D-037_NAVIGATION_MARKER_ROLES_AND_MINIMAP_DIRECTION.md').read_text()
d038 = (root / 'docs/memory/decisions/D-038_COMPASS_VISUAL_FOCUS_AND_DEPTH_CONTRACT.md').read_text()
errors = []
for frag in [
    'local MAX_AVAILABLE_QUEST_LINES = 24',
    'availableQuestLines =',
    'C_QuestLine.GetAvailableQuestLines',
    'C_QuestLog.IsOnQuest',
    'C_QuestLog.IsQuestFlaggedCompleted',
    'function Probe:ReadAvailableQuestLines()',
    'self:ReadAvailableQuestLines()',
    'if isSecret(rawRow) then',
    'ordinaryField(self, questID, "number", "availableQuest.questID")',
    'self:DistanceYards(row.x, row.y)',
    'row.onQuest == false and row.completed == false',
    'row.hidden == false',
    'row.distanceYards <= self.viewRadius',
    'availableQuestLines=',
    'availableQuestLine[%s]',
    'availableQuestAPIAvailable = self.availableQuestAPIAvailable',
]:
    if frag not in probe: errors.append('probe missing '+frag)
for frag in [
    'C_Map.SetUserWaypoint', 'C_QuestLog.AcceptQuest',
    'C_Timer.', 'RegisterStateDriver(',
    'SetScript("OnUpdate"',
]:
    if frag in probe: errors.append('forbidden active/protected path '+frag)
for frag in ['C_QuestLine.', 'C_QuestLog.', 'C_AreaPoiInfo.']:
    if frag in compass: errors.append('production compass source gate broken '+frag)
for frag in ['function Compass:RefreshAvailableQuestPOIs(reason)', 'availableQuestPoiMarkers', 'availableQuestPoiFocus', 'source.availableQuestRows', 'source.currentMapID', 'C_Minimap.GetViewRadius', 'source.mapWidth', 'edgeFadeForMagnitude(candidate.magnitude)', 'reserveMarkerBearing(candidate.x, markerWidth, occupied)', 'availableQuestPoiShown = self.availableQuestPoiShown']:
    if frag not in compass: errors.append('compass missing live source consumer '+frag)
if 'available unaccepted' not in d037.lower() or 'local POI' not in d038:
    errors.append('approved decision refinement absent')
print('P0220 unaccepted quest local POI source contract')
print('============================================')
if errors:
    for e in errors: print('ERROR:', e)
    print(f'FAILED: {len(errors)} error(s)')
    raise SystemExit(1)
print('PASS: 0 errors')
