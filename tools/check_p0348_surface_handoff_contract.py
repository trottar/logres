#!/usr/bin/env python3
"""P0348: D-048 surface-specific candidate/stock/restore contract, STATIC ONLY."""
from __future__ import annotations
import re
import sys
from pathlib import Path
R=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(R/'tools'))
import p0324_domain_policy as original
import p0325_migration_dry_run as migration
import p0348_surface_handoff as handoff

def need(cond,reason):
    if not cond: raise AssertionError(reason)

def read(path): return (R/path).read_text(encoding='utf-8')

domains=original.DOMAINS
need(domains == ('NAV','ACT','NPC','STATUS','CAM'),'D048 domain order changed')
need(handoff.STOCK_REQUIRED and handoff.CANDIDATES,'missing surface classes')
need(len(handoff.SURFACE_KEYS)==len(set(handoff.SURFACE_KEYS))==19,'expected 19 unique named surfaces')
need(handoff.STOCK_REQUIRED.isdisjoint(handoff.CANDIDATES),'overlapping surface ownership')
need(set(handoff.SURFACE_KEYS)==handoff.STOCK_REQUIRED|handoff.CANDIDATES,'unclassified surface')
need({d for d,_,_ in handoff.SURFACES}==set(domains),'all D048 domains required')
need({'minimap-and-tracking','special-vehicle-override','pet-controls',
      'quest-transactions','merchant-transactions','flight-transactions',
      'party-and-compact-party','target-of-target','native-aura-fallback',
      'camera-profile'}<=handoff.STOCK_REQUIRED,
     'protected/unsupported native fallback candidate introduced')
need('camera-profile' not in handoff.CANDIDATES,'D047 camera frozen')
all_off=handoff.empty_capabilities()
all_ready={s:True for s in handoff.SURFACE_KEYS}
for mask in range(32):
    requested=original.from_mask(mask)
    off=handoff.evaluate(requested,all_off,all_off)
    on=handoff.evaluate(requested,all_ready,all_ready)
    need(set(off)==set(on)==set(handoff.SURFACE_KEYS),'surface coverage lost')
    for domain,surface,kind in handoff.SURFACES:
        need(off[surface]['requested']==requested[domain] and
             off[surface]['effective']=='blizzard' and not off[surface]['pending'],
             'unproven capability claimed Logres ownership: '+surface)
        wanted='logres' if kind=='logres_candidate' and requested[domain]=='logres' else 'blizzard'
        need(on[surface]['effective']==wanted,'eligible surface mismatch '+surface)
        if kind=='stock_required':
            need(on[surface]['reason']=='stock-required','native information/control must survive '+surface)
    for i,changed in enumerate(domains):
        adjacent=handoff.evaluate(original.from_mask(mask^(1<<i)),all_ready,all_ready)
        need(all(on[s]['effective']==adjacent[s]['effective'] for d,s,_ in handoff.SURFACES
                 if d!=changed),'cross-domain ownership leak '+changed)

# Each surface requires BOTH independent attestations. No global ownership.
for surface in handoff.CANDIDATES:
    owner=next(d for d,s,_ in handoff.SURFACES if s==surface)
    requested={d:'blizzard' for d in domains};requested[owner]='logres'
    capable=dict(all_off);capable[surface]=True
    no_fallback=handoff.evaluate(requested,capable,all_off)
    need(no_fallback[surface]['reason']=='fallback-unproven' and
         no_fallback[surface]['effective']=='blizzard', 'fallback gate bypass '+surface)
    eligible=handoff.evaluate(requested,capable,dict(all_off,**{surface:True}))
    need(eligible[surface]['effective']=='logres' and
         eligible[surface]['fallback']=='native-required','ready activation mismatch '+surface)
    # Moving from acquired Logres to stock with denied restoration is pending.
    current={s:'blizzard' for s in handoff.SURFACE_KEYS};current[surface]='logres'
    request_stock={d:'blizzard' for d in domains}
    pending=handoff.evaluate(request_stock,all_off,all_off,current=current)
    need(pending[surface]['effective']=='logres' and pending[surface]['pending']
         and pending[surface]['reason']=='native-restore-deferred',
         'native restoration happened before it was proven '+surface)
    need(sum(1 for x in pending.values() if x['pending'])==1,'pending isolation leak '+surface)
    restored=dict(all_ready)
    released=handoff.evaluate(request_stock,all_off,all_off,current=current,restored=restored)
    need(released[surface]['effective']=='blizzard' and not released[surface]['pending'],
         'native restoration complete not respected '+surface)

# Frozen/stock ownership cannot be silently passed in as current Logres.
current={s:'blizzard' for s in handoff.SURFACE_KEYS}
current['camera-profile']='logres'
try: handoff.evaluate(original.from_mask(0),all_off,all_off,current=current)
except ValueError: pass
else: raise AssertionError('frozen camera illegal Logres owner accepted')
for bad in ({},{'NAV':'logres'}, {d:'not-a-mode' for d in domains}):
    try: handoff.evaluate(bad,all_off,all_off)
    except ValueError: pass
    else: raise AssertionError('malformed request accepted '+repr(bad))
for invalid in (None,1,{}, {'compass':True}):
    try: handoff.evaluate(original.from_mask(31),invalid,all_off)
    except ValueError: pass
    else: raise AssertionError('incomplete capability attestation accepted')

legacy={'immersionEnabled':False,'activeQuestEnabled':True,'custom':{'preserve':[1,2,3]}}
original_value=migration.preview(legacy)
need(original_value['saved_settings']==legacy and not original_value['writes_saved_variables']
     and original_value['schema']==3 and original_value['domain_requests']['CAM']=='legacy',
     'P0325 preservation model changed')
need(read('Logres/Core/Database.lua').count('local CURRENT_SCHEMA = 3')==1,
     'saved schema changed without migration authorization')
source=read('tools/p0348_surface_handoff.py')
for banned in ('CreateFrame(', 'C_Timer', 'SetPreference(', 'RegisterEvent(',
               'InCombatLockdown(', 'GetAuraDataByIndex(', 'GetPoint(',
               'LogresDB', 'UpdateAllAuras(', 'GetCurrentMapAreaID('):
    need(banned not in source,'offline fixture contains client access: '+banned)
need('p0348_surface_handoff.py' not in read('Logres/Logres.toc'), 'offline model must not load in WoW')
toc=read('Logres/Logres.toc');bootstrap=read('Logres/Core/Bootstrap.lua')
need(len([x for x in toc.splitlines() if x.endswith('.lua')])==94,'loaded Lua count changed')
need(re.search(r'(?m)^## Version: (\S+)$',toc).group(1)==
     re.search(r'(?m)^Logres.VERSION = "([^"]+)"$',bootstrap).group(1),
     'runtime version parity lost')
CUR=read('docs/memory/CURRENT.md');HAND=read('docs/memory/handoffs/CURRENT_HANDOFF.md')
for x in ('P0348','P0347','P0346','P0345','P0344','P0343','P0321','L-022','L-027','L-028','L-019','D-048','UNVERIFIED'):
    need(x in CUR and x in HAND, 'CURRENT/HANDOFF continuity '+x)
need(len(CUR.encode('utf-8'))<9800,'CURRENT budget exceeded')
for n in range(317,348):need(f'P{n:04d}' in HAND,'handoff missing P%04d'%n)
for n in range(317,338):need(f'P{n:04d}' in CUR,'current missing P%04d'%n)
for p in ('docs/memory/evidence/P0348_SURFACE_HANDOFF.md',
          'docs/memory/patches/P0348_SURFACE_HANDOFF.md',
          'docs/memory/architecture/P0348_SURFACE_OWNERSHIP_MATRIX.md'):
    s=read(p)
    for term in ('P0348','P0347','P0321','D-048','UNVERIFIED','OPEN','Blizzard'):
        need(term in s,'missing safety/evidence '+p+' '+term)
    need(s.endswith('\n') and not s.endswith('\n\n'),'record hygiene '+p)
for p in ('docs/ROADMAP.md','docs/memory/investigations/ACTIVE.md',
          'docs/memory/roadmap/STATUS.md','docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md',
          'docs/memory/patches/PATCH_INDEX.md'):
    need('P0348' in read(p),'patch index missing '+p)
need('P0347 R0' in read('docs/memory/evidence/P0347_SUBSCRIPTION_LIFECYCLE.md'),
     'prior rejected checker failure evidence missing')
print('P0348 D-048 surface-level handoff model PASS: 32 request masks, 19 surfaces,')
print(str(len(handoff.CANDIDATES))+' candidate-level independent gates/restore deferrals; STATIC ONLY / WoW UNVERIFIED')
