#!/usr/bin/env python3
"""P0384 quest-button input geometry provenance, addon-owned only."""
from pathlib import Path
import re
r=Path(__file__).resolve().parents[1]
s=(r/'Logres/Quest/Dialogue.lua').read_text()
p=(r/'Logres/Dev/Panel.lua').read_text()
e=(r/'docs/memory/evidence/P0384_COMPLETION_GEOMETRY_PROVENANCE.md').read_text()
assert 'local function captureCompletionInputMap(button, phase)' in s
part=s[s.index('local function captureCompletionInputMap(button, phase)'):s.index('function Dialogue:CompletionInputStatus()')]
for token in ('readOwnedFrameValue(button.label, "GetTop")','readOwnedFrameValue(button, "GetTop")',
              'readOwnedFrameValue(button, "GetEffectiveScale")','pcall(GetCursorPosition)',
              'pcall(issecretvalue, rawX)','pcall(issecretvalue, rawY)',
              'phase == "enter" or phase == "down"','self.lastCompletionEnterMap = map',
              'self.lastCompletionDownMap = map'):
    assert token in part,token
assert part.index('pcall(issecretvalue, rawX)') < part.index('type(rawX) == "number"')
assert part.index('pcall(issecretvalue, rawY)') < part.index('type(rawY) == "number"')
for forbidden in ('QuestFrame', 'GetMouseFocus', 'GetMouseFoci', 'SetScript("OnUpdate"', 'CompleteQuest('):
    assert forbidden not in part,forbidden
assert 'enterMap = self.lastCompletionEnterMap' in s
assert 'downMap = self.lastCompletionDownMap' in s
assert s.index('self.lastCompletionEnterMap = nil') < s.index('local completion, reason, secret = self:ReadCompletion()')
for token in ('completionEnterMap', 'completionDownMap', 'pickTraceStatus(inputReport.enterMap, mapFields)',
              'pickTraceStatus(inputReport.downMap, mapFields)', '"cursorX", "cursorY"'):
    assert token in p, token
assert 'REPORT BUG' in e and 'L-005' in e and 'L-001' in e
x=re.search(r'(?m)^## Version: (\S+)$',(r/'Logres/Logres.toc').read_text())
y=re.search(r'Logres.VERSION = "([^"]+)"',(r/'Logres/Core/Bootstrap.lua').read_text())
assert x and y and x.group(1)==y.group(1)
print('P0384 quest completion geometry capture: PASS (STATIC ONLY, WoW UNVERIFIED)')
