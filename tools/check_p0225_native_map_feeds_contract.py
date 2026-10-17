#!/usr/bin/env python3
"""P0225 native-first public map offer source contract (not a live-marker PASS)."""
from pathlib import Path
r=Path(__file__).resolve().parents[1]
p=(r/'Logres/Navigation/NavigationSourceProbe.lua').read_text()
c=(r/'Logres/Navigation/Compass.lua').read_text()
e=[]
required=[
 'function Probe:ReadNativeOfferFeeds()',
 'C_QuestLine.GetForceVisibleQuests',
 'C_QuestLine.GetQuestLineInfo',
 'C_TaskQuest.GetQuestsOnMap',
 'C_AreaPoiInfo.GetQuestHubsForMap',
 'C_AreaPoiInfo.GetAreaPOIInfo',
 'self:ReadNativeOfferFeeds()',
 'self.nativeForceScanned', 'self.nativeTaskScanned', 'self.nativeHubScanned',
 'self.nativeOfferNearby', 'self.nativeHubNearby',
 'self.availableQuestRows[#self.availableQuestRows + 1] = row',
 'self.areaPoiRows[#self.areaPoiRows + 1] = {',
 'rawOn ~= false or rawDone ~= false',
 'distance > self.viewRadius',
 'if isSecret(questID)',
 'MAX_NATIVE_OFFER_ROWS = 24',
 'MAX_NATIVE_QUEST_HUBS = 16',
]
for x in required:
 if x not in p:e.append('probe missing '+x)
for x in ['C_Minimap.SetTracking','EnumeratePins','AcquirePin','hooksecurefunc','C_Timer.','SetScript("OnUpdate"']:
 if x in p:e.append('probe forbidden '+x)
for x in ['row.eligible==true','source.availableQuestRows','source.areaPoiRows','row.role=="quest" and row.questID==focusedQuestID']:
 if x not in c:e.append('existing compass path lost '+x)
print('P0225 native map feed source contract')
print('=====================================')
for x in e:print('ERROR:',x)
print('PASS: 0 errors' if not e else f'FAILED: {len(e)} errors')
raise SystemExit(bool(e))
