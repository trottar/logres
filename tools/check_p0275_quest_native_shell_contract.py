#!/usr/bin/env python3
"""P0275 archival contract after P0276 visual REJECTION."""
from pathlib import Path
R = Path(__file__).resolve().parents[1]
read = lambda p: (R / p).read_text(encoding='utf-8')
a = read('Logres/Quest/NativeServiceAccent.lua')
t = read('Logres/Media/Theme.lua')
p = read('Logres/Quest/NativeServicePlacementTrial.lua')
old = read('tools/check_p0274_native_service_accent_contract.py')
errors=[]
def need(ok, s):
    if not ok: errors.append(s)
for s in ('mode = "retired"', 'retired-p0276-native-reskin-pending',
          'nativeMutations = 0', 'ownership = "none"'):
    need(s in a, 'P0275 oversized shell must stay disabled: '+s)
for s in ('CreateFrame(', 'CreateTexture(', 'quest_narrative_panel.tga',
          'root:SetPoint(', 'piece:SetTexture(', 'surface:SetSize('):
    need(s not in a, 'P0275 visual trial must not be active: '+s)
need('theme.questDialogue = {' in t and 'quest_narrative_panel.tga' in t and
     'quest_narrative_divider.tga' in t,
     'KEEP proven real quest theme independent of failed native shell')
need('Quest\\NativeServiceAccent.lua' in read('Logres/Logres.toc'),
     'preserve existing placement compatibility shim')
need('Logres.NPCNativeServiceAccent.Hide()' in p,
     'native restoration still invokes safe facade')
need('P0275' in old and 'retired' in old,
     'P0274 check must be explicitly migrated, not silently removed')
for s in ('P0275 —', 'VISUAL FAIL'):
    need(s in read('docs/memory/evidence/P0276_NATIVE_TRAINER_FEASIBILITY.md'),
         'record P0275 failed visual acceptance: '+s)
for e in errors: print('ERROR:',e)
print('P0275 archival shell failure / P0276 retirement contract')
if errors: raise SystemExit(1)
print('PASS: 0 errors (P0275 screenshot is NEGATIVE visual evidence)')
