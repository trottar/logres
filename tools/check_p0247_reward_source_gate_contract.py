#!/usr/bin/env python3
"""P0247 read-only reward source-gate diagnostic contract; future version-safe."""
from pathlib import Path
r=Path(__file__).resolve().parents[1]
d=(r/'Logres/Quest/Dialogue.lua').read_text(encoding='utf-8')
c=(r/'Logres/Core/Commands.lua').read_text(encoding='utf-8')
a=d.find('function Dialogue:ReadCompletionRewardSummary()')
b=d.find('function Dialogue:HandleQuestComplete()',a)
s=d[a:b] if a>=0 and b>a else ''
e=[]
for q in ('self.lastCompletionItemGate = "reward-source-unavailable"',
          '"item-call-failed"', '"name-secret"', '"quantity-secret"',
          '"quantity-invalid"', '"name-ordinary"', '"item-id-secret"',
          '"item-id-invalid"', '"cache-api-unavailable"',
          '"cache-events-unavailable"', '"cache-eligible"',
          '"cache-call-failed"', '"cache-name-secret"', '"cache-empty"',
          '"cache-name-ready"', 'pcall(GetQuestItemInfo, "reward", 1)',
          'pcall(GetItemInfo, itemID)',
          'if ok and not isSecret(name) and not isSecret(quantity)',
          'if isSecret(name) then', 'elseif isSecret(quantity) then',
          'elseif isSecret(itemID) then',
          'if not cacheOK then', 'elseif isSecret(cacheName) then',
          '"guaranteed-item-unavailable"',
          '"Review rewards in Blizzard quest window"'):
    if q not in s:e.append('missing source-gate invariant: '+q)
if s.count('pcall(GetQuestItemInfo, "reward", 1)')!=1:
    e.append('only one quest item source read')
if s.count('pcall(GetItemInfo, itemID)')!=1:
    e.append('only one ordinary item cache read')
for forbidden in ('GetQuestReward(', 'CompleteQuest(', 'HideUIPanel(',
                  'C_GossipInfo.Select', 'SetScript("OnUpdate"',
                  'C_Timer.After('):
    if forbidden in s:e.append('forbidden quest action/polling '+forbidden)
if 'lastCompletionItemGate = self.lastCompletionItemGate' not in d:
    e.append('missing debug state')
if 'self.lastCompletionItemGate = "not-observed"' not in d:
    e.append('missing initialized state')
if 'gate=%s stock=retained' not in c or 'tostring(debugStatus.lastCompletionItemGate)' not in c:
    e.append('missing developer-panel field')
# Policy: never freeze one historical runtime tag in a durable checker.
import re
toc=(r/'Logres/Logres.toc').read_text(encoding='utf-8')
boot=(r/'Logres/Core/Bootstrap.lua').read_text(encoding='utf-8')
tv=re.findall(r'(?m)^## Version: (0\.0\.\d+-dev)$',toc)
bv=re.findall(r'(?m)^Logres\.VERSION = "(0\.0\.\d+-dev)"$',boot)
if len(tv)!=1 or len(bv)!=1 or tv[0]!=bv[0]:
    e.append('generic TOC/Bootstrap version mismatch')
print('Logres P0247 reward source-gate diagnostic contract')
print('===============================================')
if e:
    for x in e:print('ERROR:',x)
    raise SystemExit(1)
print('PASS: 0 errors')
