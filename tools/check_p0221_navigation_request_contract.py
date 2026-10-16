#!/usr/bin/env python3
"""P0221: one-shot quest-line request after observed P0220 empty source."""
from pathlib import Path
R=Path(__file__).resolve().parents[1]
s=(R/'Logres/Navigation/NavigationSourceProbe.lua').read_text()
c=(R/'Logres/Navigation/Compass.lua').read_text()
errors=[]
for v in ('C_QuestLine.RequestQuestLinesForMap', 'function Probe:RequestAvailableQuestLinesForCurrentMap()', 'if self.questLineRequestMapID == self.currentMapID then', 'self.questLineRequestMapID = self.currentMapID', 'pcall(C_QuestLine.RequestQuestLinesForMap, self.currentMapID)', 'self:RequestAvailableQuestLinesForCurrentMap()', 'self.questLineRequestAttemptCount', 'questLineRequest=api:', 'questLineRequestStatus = self.questLineRequestStatus', '"QUESTLINE_UPDATE"'):
    if v not in s: errors.append('missing guarded quest-line request contract: '+v)
for v in ('C_Timer.', 'SetScript("OnUpdate"', 'EnumeratePins', 'AcquirePin', 'SetTracking', 'SetUserWaypoint', 'hooksecurefunc'):
    if v in s: errors.append('forbidden polling/protected/stock mutation: '+v)
for v in ('C_QuestLog.', 'C_QuestLine.', 'C_AreaPoiInfo.', 'C_Minimap.GetTrackingInfo'):
    if v in c: errors.append('compass must not own quest source reads: '+v)
if s.count('pcall(C_QuestLine.RequestQuestLinesForMap, self.currentMapID)') != 1:
    errors.append('request must have one precise source invocation')
if 'self:RequestAvailableQuestLinesForCurrentMap()' not in s[s.index('function Probe:ReadAvailableQuestLines()'):s.index('function Probe:ReadSuperTracking()')]:
    errors.append('request must be triggered by empty ordinary list in read flow')
print('P0221 empty quest-line source one-shot request contract')
print('====================================================')
for err in errors: print('ERROR:',err)
print('PASS: 0 errors' if not errors else f'FAILED: {len(errors)} errors')
raise SystemExit(bool(errors))
