#!/usr/bin/env python3
"""P0426 docs-only screenshot-acceptance and compass intake contract."""
from pathlib import Path
import re
R = Path(__file__).resolve().parents[1]
def read(p): return (R/p).read_text(encoding='utf-8')
C=read('docs/memory/CURRENT.md')
L=read('docs/memory/investigations/ISSUE_LEDGER.md')
E=read('docs/memory/evidence/P0426_NPC_VISUAL_AND_COMPASS_INTAKE.md')
D=read('docs/DEPENDENCIES.md')
P=read('docs/design/navigation/COMPASS_IDENTITY_AND_PROVIDER_FRESHNESS.md')
assert len(C.encode('utf-8')) < 9800, 'CURRENT budget'
assert '**P0427**' in C.split('## Current Work Item')[1].split('## Verified State')[0] and 'P0426' in C, 'active/historical checkpoint'
for rel in ('docs/memory/investigations/ACTIVE.md',
            'docs/memory/roadmap/STATUS.md',
            'docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md',
            'docs/ROADMAP.md'):
    assert read(rel).startswith('## P0427 —') and '## P0426 —' in read(rel), rel
for lid,status in (('L-003','PARTIAL'),('L-030','PARTIAL'),
                   ('L-033','OPEN'),('L-043','OPEN'),('L-044','OPEN')):
    row=next((r for r in L.splitlines() if r.startswith('| '+lid+' |')), None)
    assert row and '| '+status+' |' in row, f'{lid} missing or altered status'
for token in ('VISUAL PASS','UNVERIFIED','L-030','L-043','L-044',
              'P0427','P0428','5af8d14b496f4d96cedc3e09fc3f4dc51a2d64b5'):
    assert token in E or token in P, token
for token in ('v1.0.13','_forever_','f07c6cb18a723c8fba824038ffaaf5de23ab5c8ecd1d9235b122f06a59666f0c',
              'QuestieDB-1.0.13-Forever.zip','questiedb/files/9514215',
              'UNVERIFIED'):
    assert token in D, token
assert '_classic_beta_' not in D, 'obsolete beta installation path'
assert 'Possible repair' in E and 'distance unavailable' in P
assert 'No Lua, TOC' in read('docs/memory/patches/P0426_NPC_VISUAL_AND_COMPASS_INTAKE.md')
print('P0426 PASS: documentation-only visual acceptance, issue intake, provider release and memory gates')
