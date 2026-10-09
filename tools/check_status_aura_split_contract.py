#!/usr/bin/env python3
"""P0175 R2: independent target harmful/helpful presentation; no false live proof."""
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
s=(ROOT/'Logres/HUD/StatusAuras.lua').read_text(encoding='utf-8')
c=(ROOT/'Logres/Core/Commands.lua').read_text(encoding='utf-8')
errors=[]
for token in (
    'harmfulRows = {}, helpfulRows = {}',
    'bucket = result.harmfulRows',
    'bucket = result.helpfulRows',
    'bucket[#bucket + 1] = aura',
    'result.rows[#result.rows + 1] = aura',
    'targetHelpful = createLane(',
    'renderLane(self.lanes.target, snapshot.harmfulRows, active)',
    'renderLane(self.lanes.targetHelpful, snapshot.helpfulRows, active)',
    'targetHarmfulVisible = self.lanes.target.visible',
    'targetHelpfulVisible = self.lanes.targetHelpful.visible',
    'targetHarmfulShown = self.lanes.target.root:IsShown()',
    'targetHelpfulShown = self.lanes.targetHelpful.root:IsShown()',
    '{ filter = "HARMFUL", kind = "harmful" }',
    '{ filter = "HELPFUL", kind = "helpful" }',
    'C_Secrets.ShouldUnitAuraIndexBeSecret',
    'C_UnitAuras.GetAuraDataByIndex',
):
    if token not in s:errors.append('missing source '+token)
for token in (
    'playerHarmfulEvidence=%s',
    'targetHarmful=%s/%s',
    'targetHelpful=%s/%s',
    'harmfulEvidence=%s',
    'and d.targetHarmfulShown ==',
    'and d.targetHelpfulShown ==',
    '"statusAuraPreviewOn"',
    '"statusAuraPreviewOff"',
):
    if token not in c:errors.append('missing command '+token)
for token in ('SetScript("OnUpdate"','C_Timer.After','C_Timer.NewTicker','SetParent(',
              'BuffFrame:Hide','DebuffFrame:Hide','TargetFrame:Hide','CancelUnitBuff'):
    if token in s:errors.append('forbidden '+token)
assert s.index('if isSecret(predicate) then')<s.index('if predicate ~= false then')<s.index('C_UnitAuras.GetAuraDataByIndex,')<s.index('if isSecret(aura) then')
assert c.count('"statusAuraCheck",')==1
assert c.count('"statusAuraPreviewOn",')==1
assert c.count('"statusAuraPreviewOff",')==1
print('P0175 R2 split enemy aura category contract')
print('==========================================')
if errors:
 for e in errors:print('ERROR: '+e)
 raise SystemExit(1)
print('PASS: 0 errors')
