#!/usr/bin/env python3
"""P0380 docs-only integrated repair plan, negative evidence and ledger extension."""
from pathlib import Path
import re
R = Path(__file__).resolve().parents[1]
def read(p): return (R/p).read_text(encoding='utf-8')
def need(ok, why):
    if not ok: raise AssertionError('P0380: ' + why)
C=read('docs/memory/CURRENT.md')
H=read('docs/memory/handoffs/CURRENT_HANDOFF.md')
L=read('docs/memory/investigations/ISSUE_LEDGER.md')
P=read('docs/memory/roadmap/P0381_INTEGRATED_GAMEPLAY_IMPLEMENTATION_PLAN.md')
E=read('docs/memory/evidence/P0380_INTEGRATED_GAMEPLAY_REPAIR.md')
T=read('Logres/Logres.toc')
B=read('Logres/Core/Bootstrap.lua')
Q=read('tools/check_p0374_issue_ledger_contract.py')
need(len(C.encode('utf-8')) < 9800 and len(H.encode('utf-8')) < 8000, 'historic size ceilings')
for text, label in [(C,'current'),(H,'handoff'),(P,'plan'),(E,'evidence')]:
    for marker in ('P0379','P0380','P0381','L-002','L-005'):
        need(marker in text, label+' missing '+marker)
for marker in ('P0354 R0','P0354 R1','P0354 R2','P0355 R1','P0358 R0','P0361 R0 handoff','check_memory_health.py','cfdc07af','P0379 R0','P0379 R1','ISSUE_LEDGER.md'):
    need(marker in H, 'handoff historical refusal '+marker)
for n in range(317,354):need(f'P{n:04d}' in H, 'handoff history P'+str(n))
for n in range(317,338):need(f'P{n:04d}' in C, 'current history P'+str(n))
for marker in ('P0373','P0374','P0375','P0376','P0377','P0378','L-021','L-033','L-034','L-035','L-037','L-038'):
    need(marker in C, 'CURRENT historical marker lost '+marker)
rows=[x for x in L.splitlines() if re.match(r'^\| L-\d{3} \|',x)]
need(len(rows)>=40, 'original 40 issue rows must remain')
need([int(x.split(' | ')[0][4:]) for x in rows[:40]]==list(range(1,41)), 'missing/reordered ledger ID')
status={x.split(' | ')[0][2:]:x.split(' | ')[2] for x in rows}
for lid,expected in [('L-001','OPEN'),('L-002','OPEN'),('L-005','PARTIAL'),('L-019','BLOCKED'),('L-021','RESOLVED-SCOPE'),('L-025','PARTIAL'),('L-033','OPEN'),('L-034','OPEN'),('L-039','OPEN')]:
    need(status.get(lid)==expected, 'issue status silently changed '+lid)
for lid in ('L-002','L-005','L-025','L-039'):
    row=next(x for x in rows if x.startswith('| '+lid+' |'))
    need('P0380' in row and 'P0380_INTEGRATED_GAMEPLAY_REPAIR.md' in row,
         'live intake/evidence missing '+lid)
need('range(1, 42)' in Q and 'L-001..L-041' in Q,'historic checker row extension missing')
toc_version = re.search(r'(?m)^## Version: (\S+)$', T)
bootstrap_version = re.search(r'Logres\.VERSION = "([^"]+)"', B)
need(toc_version and bootstrap_version and
     toc_version.group(1) == bootstrap_version.group(1),
     'runtime TOC/Bootstrap version parity broken')
for marker in ('285be528','249 PREWRITE','249 POSTWRITE','session 25','completion-input-enter','completion-input-leave','zero','UNVERIFIED','OPEN'):
    need(marker in E,'evidence lacks '+marker)
need('Forever' in P and '_forever_' in P and 'PREWRITE' in P,'P0381 runtime safety/validation missing')
for path in ('docs/memory/investigations/ACTIVE.md','docs/memory/roadmap/STATUS.md',
             'docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md','docs/ROADMAP.md',
             'docs/memory/patches/PATCH_INDEX.md'):
    need((R/path).is_file() and 'P0380' in read(path),'roadmap/historical index missing '+path)
print('P0380 integrated gameplay memory plan: PASS (STATIC; NO WOW RUNTIME CHANGE)')
