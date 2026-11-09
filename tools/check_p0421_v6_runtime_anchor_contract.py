#!/usr/bin/env python3
"""P0421: exact source-exported V6 center translation, preserved safe action routing."""
import json
import math
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
def read(rel):
    return (ROOT / rel).read_text(encoding="utf-8")

request = json.loads(read('docs/design/layout/SCREEN_MAP_V6_REFINEMENTS.json'))
base = json.loads(read('docs/design/layout/SCREEN_MAP_V5.json'))
approved = json.loads(read('docs/design/layout/SCREEN_MAP_V6.json'))
layout = read('Logres/Integration/Layout.lua')
errors=[]
def need(ok, msg):
    if not ok:
        errors.append(msg)

def eq(a,b):
    return isinstance(a,(int,float)) and isinstance(b,(int,float)) and math.isclose(a,b,rel_tol=0,abs_tol=1e-7)

need(request.get('schema') == 'logres-screen-map-adjustment/v2', 'uploaded adjustment schema drift')
need(request.get('baseline') == 'bd55e34e823abadd093930aa184fcd14e0f64ab0',
     'uploaded adjustment baseline mismatch')
need(request.get('reference') == 'docs/design/layout/SCREEN_MAP_V5.json',
     'uploaded adjustment reference mismatch')
need(approved.get('schema') == 'logres-screen-map/v6' and
     approved.get('source') == 'LOGRES_SCREEN_MAP_REFINEMENTS_P0421.json' and
     approved.get('changes') == 15 and
     approved.get('baseline') == request.get('baseline'),
     'V6 provenance or change-count drift')

v5={c['id']:c for c in base['components']}
v6={c['id']:c for c in approved['components']}
need(len(v5)==len(v6)==19 and set(v5)==set(v6), 'the 19 approved regions changed')
need(len(request['changes'])==15 and len({c['id'] for c in request['changes']})==15,
     'P0421 requires precisely 15 distinct user changes')
key_for={
    'bar2':'secondaryActions', 'bar3':'utilityActions', 'bar5':'bar5Actions',
    'petActions':'classPet', 'compass':'navigation', 'activeQuest':'activeQuest',
    'targetHarmful':'targetHarmful', 'targetFallback':'targetFallback',
    'targetHelpful':'targetHelpful', 'allies':'allies',
    'playerHarmful':'playerHarmful', 'playerReaction':'playerReaction',
    'passiveStatus':'passiveStatus', 'contextXP':'contextXP',
    'questDialogue':'questDialogue',
}
need({c['id'] for c in request['changes']} == set(key_for),
     'unexpected approved region changed')

h2 = layout.split('local H2_APPROVED_ANCHORS = {',1)[1].split('local h2Placement = ',1)[0]
profile = layout.split('local ACTION_BAR_LAYOUT = {',1)[1].split('function Layout.GetActionBarSpec',1)[0]

def anchor_coords(key):
    pat=(r'(?m)^    '+re.escape(key)+r' = \{ id = "[^"]+", x = '
         r'([0-9.]+), y = ([0-9.]+) \},$')
    m=re.search(pat,h2)
    return (float(m.group(1)), float(m.group(2))) if m else None

# Preserve the exact prior P0420 anchors needed to translate non-center widgets.
prior_anchors={
    'navigation':(50.1,6.55), 'activeQuest':(97.8,5.4),
    'questDialogue':(50.0,28.0), 'passiveStatus':(77.0,75.0),
}
for change in request['changes']:
    id_=change['id']
    key=key_for[id_]
    prev=change['from']; target=change['to']; delta=change['delta']
    need(change['anchor']==key, 'user-selected anchor changed: '+id_)
    for axis in ('x','y'):
        need(eq(change['approvedV5'][axis],v5[id_][axis]),
             'V5 reference provenance drift: '+id_+'/'+axis)
        need(eq(delta[axis],target[axis]-prev[axis]),
             'user delta does not equal to-from: '+id_+'/'+axis)
        need(eq(v6[id_][axis],target[axis]),
             'V6 desired center altered: '+id_+'/'+axis)
        need(eq(v6[id_]['w' if axis=='x' else 'h'],v5[id_]['w' if axis=='x' else 'h']),
             'V6 secretly changes design envelope size: '+id_)
    if key in prior_anchors:
        ox,oy=prior_anchors[key]
        expected=(ox+delta['x'],oy+delta['y'])
    else:
        expected=(target['x'],target['y'])
    if id_ not in ('bar2','bar3','bar5'):
        actual=anchor_coords(key)
        need(actual is not None and all(eq(a,b) for a,b in zip(actual,expected)),
             f'live semantic anchor {key} does not implement approved center shift: {actual} expected {expected}')

# Unchanged four regions retain V5 center and envelope.
for key in set(v5)-set(key_for):
    need(v6[key]==v5[key], 'unchanged region modified: '+key)

for key, role, grid, x, y in [
    ('primary','primary',(3,4),13,75),
    ('secondary','secondary',(2,6),4,75.16),
    ('utility','utility',(6,2),89,85),
    ('bar4','secondary',(6,2),10,95),
    ('bar5','utility',(6,2),89,95),
]:
    pat=rf'(?m)^    {key} = \{{ role = "{role}", columns = {grid[0]}, rows = {grid[1]},\s*\n\s*xPercent = {x}, yPercent = {y}, scale = 1 \}},$'
    need(re.search(pat,profile) is not None, 'five-bar role/grid/scale/center changed: '+key)
    need(f'"{key}"' in layout, 'source key absent: '+key)

# Source-equivalent conservative viewport checks; static geometry, not runtime proof.
for width,height in ((1917,1198),(1536,960)):
    boxes=[]
    for key,columns,rows,x,y in [
        ('primary',3,4,13,75),('secondary',2,6,4,75.16),
        ('utility',6,2,89,85),('bar4',6,2,10,95),('bar5',6,2,89,95),
    ]:
        w=columns*42+(columns-1)*5
        h=rows*42+(rows-1)*5
        l,r=width*x/100-w/2,width*x/100+w/2
        t,b=height*y/100-h/2,height*y/100+h/2
        margin=3
        need(l>=margin and r<=width-margin and t>=margin and b<=height-margin,
             f'authoring action bounds fail viewport {width}x{height}: {key}')
        for other,ol,orr,ot,ob in boxes:
            need(not (l<orr+2 and r>ol-2 and t<ob+2 and b>ot-2),
                 f'authoring action overlap viewport {width}x{height}: {key}:{other}')
        boxes.append((key,l,r,t,b))

for token in (
    'local fit, boundsReason = actionBarsFitViewport(viewport.width, viewport.height)',
    'if not fit then', 'pcall(restoreOriginalLayoutAnchors)',
    'type(InCombatLockdown) ~= "function" or InCombatLockdown()',
    '"PLAYER_REGEN_ENABLED"', '"UI_SCALE_CHANGED"',
    '"DISPLAY_SIZE_CHANGED"',
    'viewport.width * rule.x / 100', '-viewport.height * rule.y / 100',
    'local H2_INTRINSIC_ANCHORS = {',
    'local approved = H2_APPROVED_ANCHORS[binding.key]',
    'mode = "intrinsic-anchor"',
    'row.offsetX = (row.x - target.x) * rootWidth / 100',
    'row.offsetY = (row.y - target.y) * rootHeight / 100',
):
    need(token in layout, 'OOC fail-open/projection seam removed: '+token)
for disallowed in ('C_Timer.After', 'C_Timer.NewTicker', 'SetScript("OnUpdate"',
                   'PetActionBarFrame:Hide', 'PetFrame:Hide', 'SetBinding('):
    need(disallowed not in layout, 'unsafe runtime pattern introduced: '+disallowed)

# No new Lua load entry; version parity dynamic, no exact version pin.
toc=read('Logres/Logres.toc');bootstrap=read('Logres/Core/Bootstrap.lua')
need(len([line for line in toc.splitlines() if line.endswith('.lua')]) == 96,
     'TOC load list changed')
tv=re.search(r'(?m)^## Version: (\S+)$',toc)
bv=re.search(r'(?m)^Logres.VERSION = "([^"]+)"$',bootstrap)
need(tv and bv and tv[1]==bv[1], 'TOC/bootstrap runtime version mismatch')
need('P0421' in read('docs/memory/CURRENT.md') and
     read('docs/memory/roadmap/STATUS.md').startswith('## P0421') and
     read('docs/ROADMAP.md').startswith('## P0421') and
     read('docs/memory/investigations/ACTIVE.md').startswith('## P0421') and
     read('docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md').startswith('## P0421') and
     'P0421' in read('docs/memory/PRE_HANDOFF_AUDIT.md') and
     'P0421' in read('docs/memory/patches/PATCH_INDEX.md') and
     'P0421' in read('docs/memory/investigations/ISSUE_LEDGER.md'),
     'P0421 repository continuity incomplete')

print('P0421 approved V6 runtime-anchor refinement contract')
for error in errors:
    print('ERROR:',error)
if errors:
    raise SystemExit(1)
print('PASS: 15 exact centers, semantic delta anchors, five immutable grid/role sources, OOC fit/fallback, V5 provenance and continuity')
