#!/usr/bin/env python3
"""P0245: single read-only ordinary reward-item name cache fallback."""
from pathlib import Path
import re
r=Path(__file__).resolve().parents[1]
d=(r/'Logres/Quest/Dialogue.lua').read_text(encoding='utf-8')
start=d.find('function Dialogue:ReadCompletionRewardSummary()')
end=d.find('function Dialogue:HandleQuestComplete()',start)
s=d[start:end] if start>=0 and end>start else ''
e=[]
for q in (
    'pcall(GetQuestItemInfo, "reward", 1)',
    'if ok and not isSecret(name) and not isSecret(quantity)',
    'and not isSecret(itemID)',
    'and type(itemID) == "number" and itemID == itemID',
    'and itemID >= 1 and itemID <= 10000000',
    'and itemID == math.floor(itemID)',
    'and type(GetItemInfo) == "function"',
    'local cacheOK, cacheName = pcall(GetItemInfo, itemID)',
    'if cacheOK and not isSecret(cacheName)',
    'and type(cacheName) == "string" and cacheName ~= ""',
    '"guaranteed-item-cache"',
    '"guaranteed-item-unavailable"',
    '"Review rewards in Blizzard quest window"',
    '"reward-money", GetQuestLogRewardMoney, self.lastQuestID',
    '"\\nComplete using Blizzard quest controls"',
):
    if q not in s:e.append('missing bounded item cache path '+q)
for q in ('GetQuestReward(', 'CompleteQuest(', 'C_GossipInfo.Select',
          'HideUIPanel(', 'QuestFrame:Hide', 'C_Timer.After(',
          'SetScript("OnUpdate"', 'C_Item.RequestLoadItemDataByID('):
    if q in s:e.append('forbidden action/polling in reward path: '+q)
if d.count('pcall(GetItemInfo, itemID)') != 1:e.append('cache read must occur exactly once')
# Guard the release tag generically. Durable checkers must survive later bumps.
toc=(r/'Logres/Logres.toc').read_text(encoding='utf-8')
bootstrap=(r/'Logres/Core/Bootstrap.lua').read_text(encoding='utf-8')
toc_versions=re.findall(r'(?m)^## Version: (0\.0\.\d+-dev)$',toc)
bootstrap_versions=re.findall(r'(?m)^Logres\.VERSION = "(0\.0\.\d+-dev)"$',bootstrap)
if len(toc_versions)!=1 or len(bootstrap_versions)!=1:
    e.append('missing/ambiguous generic runtime version in TOC or Bootstrap')
elif toc_versions[0]!=bootstrap_versions[0]:
    e.append('TOC/Bootstrap runtime versions disagree')
print('Logres P0245 single-read quest item name contract')
print('=================================================')
if e:
    for x in e:print('ERROR:',x)
    raise SystemExit(1)
print('PASS: 0 errors')
