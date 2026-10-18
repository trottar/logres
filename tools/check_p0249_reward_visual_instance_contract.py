#!/usr/bin/env python3
"""P0249: reward visual instances must dispatch to the defined Visual methods."""
from pathlib import Path
import re
r=Path(__file__).resolve().parents[1]
v=(r/'Logres/Quest/RewardVisual.lua').read_text(encoding='utf-8')
d=(r/'Logres/Quest/Dialogue.lua').read_text(encoding='utf-8')
e=[]
start=v.find('function Visual.New(root, objectiveText)')
end=v.find('function Visual:Reset()',start)
ctor=v[start:end] if start>=0 and end>start else ''
for part in ('local self = setmetatable(',
             '{ root = root, objectiveText = objectiveText, slots = {} }',
             '{ __index = Visual }',
             'return self'):
    if part not in ctor: e.append('instance method inheritance missing: '+part)
for part in ('function Visual:Reset()', 'function Visual:Present(cards, footer)'):
    if part not in v: e.append('method missing: '+part)
for part in ('self.rewardVisual = Logres.QuestRewardVisual.New(root, objectiveText)',
             'if self.rewardVisual then self.rewardVisual:Reset() end',
             'self.rewardVisual:Present('):
    if part not in d: e.append('integration missing: '+part)
if v.count('setmetatable(') != 1: e.append('constructor should have one explicit metatable assignment')
for forbidden in ('GetQuestReward(', 'CompleteQuest(', 'SetScript("OnClick"', 'SetScript("OnUpdate"'):
    if forbidden in v:e.append('protected or polling operation in visual: '+forbidden)
print('Logres P0249 quest reward visual instance dispatch contract')
print('==========================================================')
if e:
    for issue in e:print('ERROR:',issue)
    raise SystemExit(1)
print('PASS: 0 errors')
