#!/usr/bin/env python3
"""P0295: deterministic addon-owned row hit priority over inert rows and wheel."""
from pathlib import Path
import re
R = Path(__file__).resolve().parents[1]
read = lambda path: (R / path).read_text(encoding="utf-8")
v = read("Logres/Quest/TrainerLiveTrial.lua")
l = read("Logres/Quest/TrainerLandscape.lua")
p = read("tools/check_p0294_trainer_local_selection_contract.py")
e = read("docs/memory/evidence/P0295_TRAINER_ROW_HIT_PRIORITY.md")
c = read("docs/memory/CURRENT.md")
errors = []
def need(x, why):
    if not x: errors.append(why)
start = v.find('local function attachBrowseControls(root, model, controls)')
end = v.find('function Trial.Toggle(mode)', start)
need(start >= 0 and end > start, "missing live browse controller")
segment = v[start:end] if start >= 0 and end > start else ""
for token in ('wheel:SetFrameLevel(root:GetFrameLevel() + 4)',
              'local hit = CreateFrame("Frame", nil, wheel)',
              'hit:SetFrameLevel(wheel:GetFrameLevel() + 2)',
              'hit:SetScript("OnMouseUp"',
              'hit:SetScript("OnMouseWheel"',
              'hit:EnableMouse(true)', 'hit:EnableMouseWheel(true)',
              'browse.rowHits[i] = hit',
              'geometry.list.top + (i - 1) * geometry.list.pitch'):
    need(token in segment, "missing bounded owned hit-level contract: " + token)
need(segment.find('wheel:SetFrameLevel') < segment.find('local hit = CreateFrame'),
     'wheel must be given explicit priority before row hits')
for tok in ('row.serviceIndex == browse.selectedServiceIndex',
            'browse.selectedServiceIndex = chosen.serviceIndex',
            'entry.serviceIndex == row.serviceIndex',
            'Logres.NPCTrainerLandscape.UpdateLiveRows(browse.controls, model)',
            'if rows[i] and not rows[i].disabled and rows[i].serviceIndex then',
            'function Trial.Disable(why)',
            'watcher:RegisterEvent("PLAYER_REGEN_DISABLED")',
            'root:EnableMouse(false)'):
    need(tok in v, 'lost local identity, update or fail-open behavior: '+tok)
for forbidden in ('SelectTrainerService(', 'BuyTrainerService(',
                  'SetTrainerServiceTypeFilter(', 'SetScript("OnUpdate"',
                  'hooksecurefunc(', 'C_Timer.After('):
    need(forbidden not in v and forbidden not in l, 'forbidden native mutation/polling: '+forbidden)
need('return Landscape.Render(owner, Landscape.Fixture())' in l, 'P fixture changed')
need('hit:SetScript("OnMouseUp"' in p and 'P0294' in p,
     'historical P0294 checker lost')
for word in ('FAIL', 'P0294', 'P0295', 'Blizzard', 'wheel', 'click',
             'unverified', 'Visible services'):
    need(word.lower() in e.lower(), 'missing failure evidence: '+word)
need(len(c.encode()) < 10000 and c.count('## Next Action') == 1,
     'CURRENT.md health violated')
toc = read('Logres/Logres.toc'); boot = read('Logres/Core/Bootstrap.lua')
a = re.search(r'(?m)^## Version: (\S+)$', toc)
b = re.search(r'(?m)^Logres\.VERSION = "([^"]+)"$', boot)
need(bool(a and b and a.group(1) == b.group(1)), 'runtime version parity')
print('P0295 owned trainer row hit-level repair contract')
for err in errors: print('ERROR:', err)
if errors: raise SystemExit(1)
print('PASS: explicit owned input hierarchy, catalogue identity, wheel and stock fallback')
