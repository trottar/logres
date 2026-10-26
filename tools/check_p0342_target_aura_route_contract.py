#!/usr/bin/env python3
"""P0342: L-028 one-shot cached native/ordinary harmful owner diagnostic."""
from pathlib import Path
import re

R = Path(__file__).resolve().parents[1]
read = lambda p: (R / p).read_text(encoding='utf-8')
C = read('Logres/Core/Commands.lua')
S = read('Logres/HUD/StatusAuras.lua')
T = read('Logres/Logres.toc')
B = read('Logres/Core/Bootstrap.lua')
M = read('docs/memory/roadmap/NOV04_GAMEPLAY_REGRESSION_MATRIX.md')
CUR = read('docs/memory/CURRENT.md')
need_current_budget_marker = 9800
H = read('docs/memory/handoffs/CURRENT_HANDOFF.md')
E = read('docs/memory/evidence/P0342_TARGET_AURA_ROUTE.md')
P = read('docs/memory/patches/P0342_TARGET_AURA_ROUTE.md')

def need(ok, message):
    if not ok: raise AssertionError(message)

capture = C[C.index('function Logres:RunGameplayCapture()'):C.index('local function printPreferences()')]
summary = 'Logres gameplaycapture Auras: targetHarmful=%s targetHelpful=%s secretSkips=%s failures=%s duplicatesUnknown=%s refreshes=%s'
route = 'Logres gameplaycapture Auras route: nativeReady=%s nativeActive=%s ordinaryFallbackShown=%s ordinaryFallbackRows=%s (cached Logres status; NOT native icon visibility proof)'
need(capture.count(summary) == 1, 'original gameplay aura summary was lost/duplicated')
need(capture.count(route) == 1, 'new diagnostic must be a single additive line')
status_block = capture[capture.index('local aura = readCaptureStatus("StatusAuras"'):capture.index('local pet = Logres:GetModule("PetActionPresentation")')]
for expected in ('if aura then', 'boolText(aura.nativeReady)',
                 'boolText(aura.nativeActive)', 'boolText(aura.targetHarmfulShown)',
                 'tostring(aura.targetHarmfulVisible)', 'NOT native icon visibility proof'):
    need(expected in status_block,
         'cached read-only provenance missing: ' + expected)
for unsafe in ('UnitAura(', 'GetAuraDataByIndex(', 'UnitHealth(', 'GetPoint(',
               'SetPoint(', 'SetEnabled(', 'SetShown(', 'UpdateAllAuras(',
               'C_Timer.', 'hooksecurefunc(', 'SetFrameStrata('):
    need(unsafe not in capture, 'capture must not read native aura/secret state or mutate UI: ' + unsafe)
status = S[S.index('function StatusAuras:GetDebugStatus()'):S.index('function StatusAuras:OnInitialize()')]
for expected in ('nativeReady = self.nativeDebuffs ~= nil',
                 'nativeActive = self.nativeDebuffs ~= nil and self.nativeActive == true',
                 'targetHarmfulShown = self.lanes.target.root:IsShown()',
                 'targetHarmfulVisible = self.lanes.target.visible'):
    need(expected in status, 'source-owned cached field missing: ' + expected)
need('P0342' in M and 'nativeActive' in M and 'L-028' in M, 'Nov 4 route matrix omitted')
need(len(CUR.encode('utf-8')) < need_current_budget_marker,
     'P0342 exact candidate CURRENT.md maintenance budget over 9800 bytes')
for p in (CUR,H,E,P):
    need('P0342' in p and 'P0321' in p and 'UNVERIFIED' in p, 'memory/client gate omitted')
for n in range(317,343):
    need(f'P{n:04d}' in H, 'historical handoff marker missing P%04d' % n)
for marker in ('P0337', 'cfdc07af', 'P0338', 'L-031', 'UNVERIFIED'):
    need(marker in CUR and marker in H,
         'P0342 retained P0338 CURRENT/HANDOFF marker: ' + marker)
for f in ('docs/ROADMAP.md','docs/memory/investigations/ACTIVE.md',
          'docs/memory/roadmap/STATUS.md','docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md',
          'docs/memory/patches/PATCH_INDEX.md'):
    need('P0342' in read(f), 'roadmap index missing: ' + f)
a = re.search(r'(?m)^## Version: (\S+)$', T)
b = re.search(r'(?m)^Logres.VERSION = "([^"]+)"$', B)
need(a and b and a.group(1) == b.group(1), 'dynamic TOC/Bootstrap version parity')
need(len([line for line in T.splitlines() if line.endswith('.lua')]) == 94,
     'loaded Lua inventory drift')
need('R0 PREWRITE' in E and '25/213' in E and '10000-byte' in E and 'no tracked write' in E and 'R1 PREWRITE' in E and '1/213' in E and 'L-031' in E,
     'P0342 R0 assistant failure and memory budget guard not recorded')
for f in (E,P):
    need(f.endswith('\n') and not f.endswith('\n\n') and '\r' not in f, 'record hygiene')
print('P0342 one-shot target harmful presentation route: PASS (STATIC; WoW UNVERIFIED)')
