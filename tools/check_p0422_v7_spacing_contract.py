#!/usr/bin/env python3
"""P0422: exact V7 final spacing refinement contract."""
import json, re
from pathlib import Path
ROOT = Path(__file__).resolve().parents[1]
read=lambda p:(ROOT/p).read_text(encoding='utf-8')
layout=read('Logres/Integration/Layout.lua')
current=read('docs/memory/CURRENT.md')
status=read('docs/memory/roadmap/STATUS.md')
active=read('docs/memory/investigations/ACTIVE.md')
phase=read('docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md')
roadmap=read('docs/ROADMAP.md')
pre=read('docs/memory/PRE_HANDOFF_AUDIT.md')
patch=read('docs/memory/patches/PATCH_INDEX.md')
issue=read('docs/memory/investigations/ISSUE_LEDGER.md')
toc=read('Logres/Logres.toc')
boot=read('Logres/Core/Bootstrap.lua')
v6=json.loads(read('docs/design/layout/SCREEN_MAP_V6.json'))
v7=json.loads(read('docs/design/layout/SCREEN_MAP_V7.json'))
req=json.loads(read('docs/design/layout/SCREEN_MAP_V7_REFINEMENTS.json'))
errors=[]
def need(ok,msg):
    if not ok: errors.append(msg)
need(v7.get('schema')=='logres-screen-map/v7','V7 schema drift')
need(v7.get('baseline')=='ac373444999aabc8309b212e746f213de9fb6384','V7 baseline drift')
need(v7.get('reference')=='docs/design/layout/SCREEN_MAP_V6.json' and v7.get('changes')==2,'V7 provenance drift')
need(req.get('baseline')==v7.get('baseline') and req.get('reference')=='docs/design/layout/SCREEN_MAP_V6.json','V7 refinement request provenance drift')
need(len(req.get('changes',[]))==2 and {c['id'] for c in req['changes']}=={'allies','petActions'},'V7 must adjust only allies/petActions')
v6c={c['id']:c for c in v6['components']}
v7c={c['id']:c for c in v7['components']}
for cid in ('allies','petActions'):
    need(v7c[cid]['x']==v6c[cid]['x']+1 and v7c[cid]['y']==v6c[cid]['y'],'V7 right-shift mismatch: '+cid)
for cid,row in v6c.items():
    if cid not in ('allies','petActions'):
        need(v7c[cid]==row,'unexpected V7 component drift: '+cid)
# Historical V7 request and map are immutable; the P0423 runtime V8
# correction restores petActions without rewriting P0422 evidence.
need(v7c['allies']['x'] == 24 and v7c['petActions']['x'] == 10,
     'historical V7 shift lost')
v8 = json.loads(read('docs/design/layout/SCREEN_MAP_V8.json'))
v8c = {c['id']: c for c in v8['components']}
need(v8.get('reference') == 'docs/design/layout/SCREEN_MAP_V7.json' and
     v8.get('changes') == 1, 'V8 did not preserve V7 as its parent')
for cid, row in v7c.items():
    if cid == 'petActions':
        need(v8c[cid]['x'] == row['x'] - 1 and v8c[cid]['y'] == row['y'],
             'V8 pet-actions restore not based on V7')
    else:
        need(v8c[cid] == row, 'unexpected V8 map drift: ' + cid)
for token in (
    'allies = { id = "group", x = 24.0, y = 50.0 }',
    'classPet = { id = "petActions", x = 9.0, y = 50.0 }',
    'approved-screen-map-v8',
):
    need(token in layout,'V8 runtime correction missing: '+token)
# preserve key safe patterns
for token in (
    'local fit, boundsReason = actionBarsFitViewport(viewport.width, viewport.height)',
    'if not fit then',
    'pcall(restoreOriginalLayoutAnchors)',
    'type(InCombatLockdown) ~= "function" or InCombatLockdown()',
    'local H2_INTRINSIC_ANCHORS = {',
):
    need(token in layout,'safety seam removed: '+token)
for disallowed in ('C_Timer.After','C_Timer.NewTicker','SetScript("OnUpdate"','SetBinding('):
    need(disallowed not in layout,'unsafe runtime pattern introduced: '+disallowed)
# version parity
m1=re.search(r'(?m)^## Version: (\S+)$',toc)
m2=re.search(r'(?m)^Logres.VERSION = "([^"]+)"$',boot)
need(m1 and m2 and m1.group(1)==m2.group(1), 'runtime version parity drift')
# continuity
for text in (current,status,active,phase,roadmap,pre,patch,issue,read('docs/memory/evidence/P0422_V7_FINAL_SPACING_REFINEMENT.md'),read('docs/memory/patches/P0422_V7_FINAL_SPACING_REFINEMENT.md')):
    need('P0422' in text,'P0422 continuity missing')
print('P0422 final V7 pet/party spacing contract')
for e in errors: print('ERROR:',e)
if errors: raise SystemExit(1)
print('PASS: historical V7 preserved, V8 restores pet actions, safety seams and memory remain')
