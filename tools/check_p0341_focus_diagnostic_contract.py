#!/usr/bin/env python3
"""P0341: cached addon-owned generic compass focus diagnostics, source-only gate."""
from pathlib import Path
import re

ROOT=Path(__file__).resolve().parents[1]
read=lambda p:(ROOT/p).read_text(encoding='utf-8')
C=read('Logres/Core/Commands.lua')
COMPASS=read('Logres/Navigation/Compass.lua')
CURRENT=read('docs/memory/CURRENT.md')
HANDOFF=read('docs/memory/handoffs/CURRENT_HANDOFF.md')
MATRIX=read('docs/memory/roadmap/NOV04_GAMEPLAY_REGRESSION_MATRIX.md')
TOC=read('Logres/Logres.toc')
BOOT=read('Logres/Core/Bootstrap.lua')
OLD=read('tools/check_p0339_nov04_gameplay_matrix_contract.py')
EVIDENCE=read('docs/memory/evidence/P0341_FOCUSED_MARKER_DIAGNOSTICS.md')
RECORD=read('docs/memory/patches/P0341_FOCUSED_MARKER_DIAGNOSTICS.md')

def need(ok,reason):
    if not ok: raise AssertionError(reason)

# Only already sampled, initialized, Logres-owned GetDebugStatus fields.
status=COMPASS[COMPASS.index('function Compass:GetDebugStatus()'):]
for token in ('focusedMarkerKind = self.focusedMarkerKind',
              'focusedMarkerDistanceAvailable = self.focusedMarkerDistanceAvailable == true',
              'focusedMarkerDistanceYards = self.focusedMarkerDistanceYards'):
    need(token in status,'no addon-owned focus cache: '+token)

capture=C[C.index('function Logres:RunGameplayCapture()'):C.index('local function printPreferences()')]
need('readCaptureStatus("Compass", function(module)' in capture,
     'snapshot must remain on guarded, already-initialized module status')
need(capture.count('Logres gameplaycapture Compass focused marker:')==1,
     'exactly one cached generic marker snapshot emission required')
for token in ('boolText(compass.focusedMarkerDistanceAvailable)',
              'tostring(compass.focusedMarkerKind or "none")',
              'tostring(compass.focusedMarkerDistanceYards or "unavailable")'):
    need(token in capture,'unsafe/incomplete snapshot reporting: '+token)
for forbidden in ('UnitHealth(', 'UnitAura(', 'GetAuraDataByIndex(', 'GetPoint(',
                  'SetPoint(', 'SetAlpha(', 'SetFrameStrata(', 'C_Timer',
                  'GetBindingKey(', 'GetPetActionInfo('):
    need(forbidden not in capture,'snapshot performs unsupported read/mutation: '+forbidden)
start=C.index('local function runCompassCheck()')
end=C.index('local CONTEXT_POLICY_ALPHA =',start)
check=C[start:end]
need(check.count('Logres compass focused marker:')==1,
     'Compass Check must show one dedicated cached marker output')
for token in ('boolText(debugStatus.focusedMarkerDistanceAvailable)',
              'tostring(debugStatus.focusedMarkerKind or "none")',
              'tostring(debugStatus.focusedMarkerDistanceYards or "unavailable")'):
    need(token in check,'Compass Check report missing addon-owned cached field: '+token)
need('Logres compass focused quest:' in check,
     'original focused-quest diagnostic must survive unchanged')
need('does **not** currently print' not in MATRIX,
     'P0339 diagnostic statement is now obsolete')
need('focusedMarkerKind' in MATRIX and 'focusedMarkerDistanceYards' in MATRIX and
     'P0341' in MATRIX and 'cached' in MATRIX,
     'P0341 focus-validation instructions missing or overclaiming')
need("'Logres compass focused marker:' in C" in OLD and
     "'does **not** currently print' in M" not in OLD,
     'P0339 historical checker must be deliberately migrated, not disabled')
for token in ('P0341','P0340','P0339','P0338','P0321',
              'UNVERIFIED','L-022','L-027','L-019'):
    need(token in CURRENT and token in HANDOFF,'CURRENT/handoff continuity: '+token)
for i in range(317,342):
    need(f'P{i:04d}' in HANDOFF, 'historical handoff token missing P%04d'%i)
for p in ('docs/memory/investigations/ACTIVE.md','docs/memory/roadmap/STATUS.md',
          'docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md',
          'docs/ROADMAP.md','docs/memory/patches/PATCH_INDEX.md'):
    need('P0341' in read(p),'durable milestone missing '+p)
for doc in (EVIDENCE,RECORD):
    need('P0341' in doc and 'UNVERIFIED' in doc and 'P0321' in doc,
         'evidence/runtime limitations lost')
    need(doc.endswith('\n') and not doc.endswith('\n\n'),'evidence EOF format')
toc_version = re.search(r'(?m)^## Version: (\S+)$', TOC)
bootstrap_version = re.search(r'(?m)^Logres.VERSION = "([^"]+)"$', BOOT)
need(toc_version is not None and bootstrap_version is not None and
     toc_version.group(1) == bootstrap_version.group(1),
     'source diagnostic TOC/Bootstrap version parity')
need(len([l for l in TOC.splitlines() if l.endswith('.lua')])==94,
     'TOC Lua load inventory drift')
need('Core\\Commands.lua' in TOC and 'Navigation\\Compass.lua' in TOC,
     'runtime diagnostics disconnected from loaded source')
print('P0341 focus-marker output sourced from cached Compass debug status: PASS (STATIC; WoW UNVERIFIED)')
