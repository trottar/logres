#!/usr/bin/env python3
"""P0274 archival contract migrated at P0276: rejected art stays retired."""
from pathlib import Path
import re
R = Path(__file__).resolve().parents[1]
read = lambda p: (R / p).read_text(encoding='utf-8')
a = read('Logres/Quest/NativeServiceAccent.lua')
p = read('Logres/Quest/NativeServicePlacementTrial.lua')
c = read('Logres/Core/Commands.lua')
toc = read('Logres/Logres.toc')
boot = read('Logres/Core/Bootstrap.lua')
errors = []
def need(ok, message):
    if not ok: errors.append(message)
for token in ('Logres.NPCNativeServiceAccent = Accent',
              'function Accent.Show(frame, key)', 'function Accent.Hide()',
              'function Accent.GetAudit()', 'mode = "retired"',
              'nativeMutations = 0', 'mouse = false',
              'retired-p0276-native-reskin-pending'):
    need(token in a, 'P0274 retired facade: ' + token)
for token in ('CreateFrame(', ':SetPoint(', ':SetTexture(', ':SetAlpha(',
              ':Hide(', ':Show(', 'C_Timer.', 'hooksecurefunc(',
              'BuyTrainerService(', 'BuyMerchantItem('):
    need(token not in a, 'rejected P0274/P0275 visual still mutates: ' + token)
for token in ('Logres.NPCNativeServiceAccent.Show(frame, candidate.key)',
              'Logres.NPCNativeServiceAccent.Hide()',
              'accent = Logres.NPCNativeServiceAccent.GetAudit()',
              'styling = "unchanged"', 'nativeTransactions = 0'):
    need(token in p, 'placement/restoration contract: ' + token)
reg = re.findall(r'Logres:RegisterDevPanelAction\(\s*"([^"]+)"\s*,\s*"[^"]+"\s*,\s*"[^"]+"\s*,\s*"([0A-HP])"\s*\)', c, re.S)
need(len(reg) == 108 and sum(x[1] == 'H' for x in reg) == 20 and
     sum(x[1] == 'P' for x in reg) == 35, 'panel action inventory 108/18/34')
need('gossipRestores=%s accent=%s accentShows=%s accentHides=%s accentFailures=%s' in c,
     'preserve placement/decoration diagnostic fields')
need('Quest\\NativeServiceAccent.lua' in toc, 'load retired compatibility shim')
version = re.search(r'^## Version: (\S+)$', toc, re.M)
bver = re.search(r'^Logres\.VERSION = "([^"]+)"$', boot, re.M)
need(bool(version and bver and version.group(1) == bver.group(1)), 'version synchronized')
for evidence in ('P0274_NATIVE_SERVICE_ACCENT.md', 'P0275_NATIVE_QUEST_ART_SHELL.md',
                 'P0276_NATIVE_TRAINER_FEASIBILITY.md'):
    need((R / 'docs/memory/evidence' / evidence).exists(), 'historical evidence missing: '+evidence)
for error in errors: print('ERROR:', error)
print('P0274 archived visual experiment / P0276 retired shim contract')
if errors: raise SystemExit(1)
print('PASS: 0 errors (P0274 cosmetic FAILURE preserved, not a visual PASS)')
