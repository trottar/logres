#!/usr/bin/env python3
"""P0252 quest completion visual parity without changing guarded claim ownership."""
from pathlib import Path
import re
r=Path(__file__).resolve().parents[1]
d=(r/'Logres/Quest/Dialogue.lua').read_text(encoding='utf-8')
c=(r/'Logres/Quest/CompletionControl.lua').read_text(encoding='utf-8')
t=(r/'Logres/Logres.toc').read_text(encoding='utf-8')
b=(r/'Logres/Core/Bootstrap.lua').read_text(encoding='utf-8')
e=[]
for token in ('local function createOfferButton(', 'self.completionButton = acceptButton',
    'self.acceptButton.label:SetText("Complete Quest")',
    'self.completionActionRoot = offerActionRoot',
    'local ownedFooter = rewardFooter:gsub(',
    '"\\nComplete using Blizzard quest controls", ""',
    'self.rewardVisual:Present(self.completionRewardCards, ownedFooter)',
    'self.objectiveText:SetText(ownedFooter)',
    'self.completionControl:Activate()', 'function Dialogue:HandleCompletionAction()',
    'return self.completionControl:Click()'):
    if token not in d: e.append('missing visual/fallback invariant: '+token)
if 'Complete Quest below' in d:e.append('duplicated completion direction remains')
if d.count('createOfferButton(')!=3:e.append('expected exactly one shared factory and two invocations')
if 'function Control:Gate()' not in c or 'self:Restore("claim-invoked")' not in c or 'pcall(_G.QuestRewardCompleteButton_OnClick)' not in c:
    e.append('native restoration-before-claim path missing')
if 'Quest\\CompletionControl.lua' not in t or 'Quest\\RewardVisual.lua\nQuest\\Dialogue.lua' not in t:
    e.append('quest load order changed')
match_t=re.search(r'^## Version: (\S+)$',t,re.M)
match_b=re.search(r'^Logres\.VERSION = "([^"]+)"$',b,re.M)
if not match_t or not match_b or match_t.group(1)!=match_b.group(1):
    e.append('TOC/Bootstrap runtime-version parity mismatch')
print('Logres P0252 completion action visual parity contract')
print('====================================================')
for err in e:print('ERROR:',err)
if e:raise SystemExit(1)
print('PASS: 0 errors')
