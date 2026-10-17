#!/usr/bin/env python3
"""P0241 source contract: additive ordinary progress; all mutation stays Blizzard-owned."""
from pathlib import Path
import re
R=Path(__file__).resolve().parents[1]
d=(R/'Logres/Quest/Dialogue.lua').read_text(encoding='utf-8')
c=(R/'Logres/Core/Commands.lua').read_text(encoding='utf-8')
p=(R/'Logres/Quest/InteractionProbe.lua').read_text(encoding='utf-8')
errors=[]
def need(x,needle,label=None):
    if needle not in x: errors.append('missing '+str(label or needle))
for x in ('function Dialogue:ReadProgress()', 'function Dialogue:HandleQuestProgress()',
          'readQuestID()', 'readString("progress-title", GetTitleText)',
          'readString("progress-text", GetProgressText)', 'if body == "" then',
          'self:ClearActiveDetail("QUEST_PROGRESS")', 'self:ClearActiveDetail("QUEST_COMPLETE")',
          'self:ClearActiveDetail("GOSSIP_CLOSED")',
          'false, false, false', 'self.progressActive = false',
          '"QUEST_PROGRESS"', '"QUEST_COMPLETE"', '"GOSSIP_CLOSED"',
          'lastProgressSecret', 'progressSkippedCount'):
    need(d,x)
start=d.find('function Dialogue:ReadProgress()');end=d.find('function Dialogue:UpdatePageControls()',start)
progress=d[start:end] if start>=0 and end>start else ''
for x in ('if idError then return nil', 'if questID == nil or questID <= 0',
          'if titleError then return nil', 'if bodyError then return nil',
          'self:PresentText(', 'progress.title, progress.body, "", "QUEST_PROGRESS"'):
    need(progress,x)
for x in ('CompleteQuest(', 'GetQuestReward(', 'C_GossipInfo.Select',
          'C_Timer.After(', 'SetScript("OnUpdate"', 'QuestFrame:Hide', 'GossipFrame:Hide'):
    if x in progress: errors.append('forbidden new progress mutation: '+x)
for x in ('debugStatus.progressRegistered == true', 'debugStatus.completeRegistered == true',
          '"Logres questdialogue progress: %s', 'stock=retained actions=none'):
    need(c,x)
for x in ('"QUEST_PROGRESS"', '"QUEST_COMPLETE"', 'function Probe:CaptureSnapshot(reason)'):
    need(p,x)
for x in ('pcall(CompleteQuest)', 'pcall(GetQuestReward)', 'C_GossipInfo.SelectOption('):
    if x in d: errors.append('forbidden direct quest mutation: '+x)
if d.count('SetScript("OnUpdate"')!=0:errors.append('no quest-dialogue polling')
print('Logres P0241 additive progress contract')
print('======================================')
if errors:
    for e in errors: print('ERROR:',e)
    raise SystemExit(1)
print('PASS: 0 errors')
