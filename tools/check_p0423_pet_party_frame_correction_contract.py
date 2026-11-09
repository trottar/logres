#!/usr/bin/env python3
"""P0423: restore pet action BAR, retain 1% shift of pet/party STATUS frame."""
import json, re
from pathlib import Path
ROOT = Path(__file__).resolve().parents[1]
def read(rel): return (ROOT / rel).read_text(encoding='utf-8')
v6=json.loads(read('docs/design/layout/SCREEN_MAP_V6.json'))
v7=json.loads(read('docs/design/layout/SCREEN_MAP_V7.json'))
v8=json.loads(read('docs/design/layout/SCREEN_MAP_V8.json'))
req=json.loads(read('docs/design/layout/SCREEN_MAP_V8_REFINEMENTS.json'))
layout=read('Logres/Integration/Layout.lua')
errors=[]
def need(ok,msg):
    if not ok:errors.append(msg)
c6={x['id']:x for x in v6['components']}
c7={x['id']:x for x in v7['components']}
c8={x['id']:x for x in v8['components']}
need(len(c8)==len(c7)==len(c6)==19 and set(c8)==set(c7)==set(c6),'component inventory drift')
need(v8.get('schema')=='logres-screen-map/v8' and
     v8.get('baseline')=='b8428a36fd091a7b70ed413afdd3434e082f1767' and
     v8.get('reference')=='docs/design/layout/SCREEN_MAP_V7.json' and
     v8.get('changes')==1,'V8 source authority mismatch')
need(len(req.get('changes',[]))==1 and req['changes'][0]=={
    'id':'petActions','anchor':'classPet',
    'from':{'x':10,'y':50},'to':{'x':9,'y':50},
    'delta':{'x':-1,'y':0}},'V8 one-element request drift')
need(req.get('unchanged')=={'id':'allies','anchor':'allies','x':24,'y':50},
     'allies status-frame preservation missing')
need(c6['petActions']['x']==9 and c7['petActions']['x']==10 and c8['petActions']['x']==9,
     'pet-action bar not restored to P0421')
need(c6['allies']['x']==23 and c7['allies']['x']==24 and c8['allies']['x']==24,
     'pet/party frame does not retain intended +1%')
for cid,row in c7.items():
    if cid!='petActions':
        need(c8[cid]==row,'unintended HUD geometry change: '+cid)
need('allies = { id = "group", x = 24.0, y = 50.0 },' in layout,
     'live party frame shifted unexpectedly')
need('classPet = { id = "petActions", x = 9.0, y = 50.0 },' in layout,
     'live pet actions not restored')
need('h2Placement.reason = "approved-screen-map-v8"' in layout,
     'H.2 layout diagnostic does not report V8')
for token in (
 'local fit, boundsReason = actionBarsFitViewport(viewport.width, viewport.height)',
 'pcall(restoreOriginalLayoutAnchors)',
 'type(InCombatLockdown) ~= "function" or InCombatLockdown()',
 'local H2_INTRINSIC_ANCHORS = {',
 'viewport.width * rule.x / 100', '-viewport.height * rule.y / 100',
):
    need(token in layout,'protected geometry or fallback seam lost: '+token)
for disallowed in ('C_Timer.After','C_Timer.NewTicker','SetBinding(',
                  'PetActionBarFrame:Hide','PetFrame:Hide'):
    need(disallowed not in layout,'unsafe layout mutation: '+disallowed)
toc=read('Logres/Logres.toc');boot=read('Logres/Core/Bootstrap.lua')
tv=re.search(r'(?m)^## Version: (\S+)$',toc)
bv=re.search(r'(?m)^Logres.VERSION = "([^"]+)"$',boot)
need(tv and bv and tv[1]==bv[1],'runtime version parity drift')
need(len([line for line in toc.splitlines() if line.endswith('.lua')])==96,
     'original secure Lua load inventory drift')
for path in ('docs/memory/CURRENT.md','docs/memory/PRE_HANDOFF_AUDIT.md',
             'docs/memory/patches/PATCH_INDEX.md',
             'docs/memory/investigations/ISSUE_LEDGER.md',
             'docs/memory/roadmap/STATUS.md',
             'docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md',
             'docs/memory/investigations/ACTIVE.md','docs/ROADMAP.md'):
    need('P0423' in read(path),'P0423 memory continuity missing: '+path)
print('P0423 pet status vs action bar correction contract')
for err in errors:print('ERROR:',err)
if errors:raise SystemExit(1)
print('PASS: pet bar at V6, status frame at V7, other regions unchanged, secure safeguards intact')
