#!/usr/bin/env python3
"""P0368 static-only November 4 candidate version/approval gate.

Not a client test, installation test, distribution approval, or Lua runtime check.
"""
from pathlib import Path
import re

ROOT=Path(__file__).resolve().parents[1]

def read(path):
    return (ROOT/path).read_text(encoding='utf-8')

def need(ok,reason):
    if not ok: raise AssertionError(reason)

M=read('docs/memory/roadmap/NOV04_GAMEPLAY_REGRESSION_MATRIX.md')
R=read('docs/memory/roadmap/NOV04_VALIDATION_RUNBOOK.md')
L=read('docs/memory/roadmap/LAUNCH_READINESS.md')
I=read('docs/memory/investigations/ISSUE_REGISTER.md')
C=read('docs/memory/CURRENT.md')
H=read('docs/memory/handoffs/CURRENT_HANDOFF.md')
T=read('Logres/Logres.toc')
B=read('Logres/Core/Bootstrap.lua')
P=read('tools/check_p0367_world_target_probe_diagnostic_seam_contract.py')
mt=re.search(r'(?m)^## Version: (\S+)$',T)
mb=re.search(r'(?m)^Logres.VERSION = "([^"]+)"$',B)
need(bool(mt and mb and mt.group(1)==mb.group(1) and
          re.fullmatch(r'0\.0\.\d+-dev',mt.group(1))),
     'live TOC/Bootstrap version parity invalid')
# Never freeze a historical client version in a future-dated test plan.
need(not re.search(r'\b0\.0\.\d+-dev\b',M),
     'November 4 regression matrix contains a stale exact dev version')
for token in ('Logres/Logres.toc','Logres/Core/Bootstrap.lua',
              'current verified main','actual installed','P0321',
              'Gossip Stock Status','Gossip Stock Toggle','READ-ONLY',
              'NOT EXECUTED','PUBLIC RELEASE NOT APPROVED'):
    need(token.lower() in M.lower(),'matrix preflight/approval token missing '+token)
need('November 4, 2026' in M and 'NOT EXECUTED' in M,
     'contingent test date or untested boundary lost')
for token in ('gossipstockstatus','gossipstocktoggle','nativeframeaudit',
              'nativeservicepolicycheck','UNVERIFIED','DEFERRED',
              'release', 'L-019'):
    need(token.lower() in R.lower() or (token=='L-019' and 'license' in R.lower()),
         'runtime runbook safety/provenance missing '+token)
for token in ('P0368','L-019','P0321','PUBLIC RELEASE NOT APPROVED',
              'internal','alpha','November 4'):
    need(token.lower() in L.lower(), 'launch gate disclosure missing '+token)
need('L-019' in I and 'L-014' in I and
     'NOT IMPLEMENTED' in I and 'distribution blocker' in I.lower(),
     'license/five-switch issue ownership missing')
for token in ('tools/alpha_prefreeze_audit.py',
              'tools/stage_alpha_candidate.py'):
    need((ROOT/token).is_file(), 'offline internal staging preflight missing '+token)
need("glob('check_*.py')))==238" not in P and
     "glob('check_*.py'))) >= 238" in P,
     'P0367 checker inventory not migrated to floor')
for token in ('P0368','P0367','P0366','P0365','P0364','P0363','P0362',
              'P0361','P0360','P0359','P0358','P0357','P0356','P0355',
              'P0354','P0353','P0352','P0351','P0350','P0349','P0348',
              'P0347','P0346','P0321','D-048','UNVERIFIED','L-019',
              'L-022','L-027','L-028','L-031','cfdc07af'):
    need(token in C and token in H,'current/handoff historical marker missing '+token)
for n in range(317,369):
    need(f'P{n:04d}' in H,'handoff milestone lost '+str(n))
for n in range(317,338):
    need(f'P{n:04d}' in C,'CURRENT milestone lost '+str(n))
need(len(C.encode('utf-8'))<9800 and len(H.encode('utf-8'))<=8000,
     'current/handoff memory size cap')
for path in ('docs/memory/investigations/ACTIVE.md',
             'docs/memory/roadmap/STATUS.md',
             'docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md',
             'docs/ROADMAP.md','docs/memory/patches/PATCH_INDEX.md'):
    text=read(path)
    need('P0368' in text and 'P0367' in text,
         'durable roadmap checkpoint missing '+path)
for path in ('docs/memory/evidence/P0368_NOV04_FREEZE_GATE.md',
             'docs/memory/patches/P0368_NOV04_FREEZE_GATE.md'):
    text=read(path)
    for token in ('P0368','P0367','P0321','L-019','239',
                  'UNVERIFIED','NOT APPROVED'):
        need(token in text,'new evidence missing '+token+' '+path)
    need(text.endswith('\n') and not text.endswith('\n\n') and
         '\r' not in text, 'new evidence LF hygiene '+path)
    need('P0368 R0 candidate-construction REFUSED (NameError: CHECK is not defined)' in text,
         'P0368 R0 generator failure evidence missing '+path)
for path,marker in (
 ('docs/memory/evidence/P0366_QUEST_INTERACTION_PROBE_DIAGNOSTIC_SEAM.md',
  'P0366 R0 PREWRITE STATIC 27/237 REFUSED'),
 ('docs/memory/evidence/P0365_AURA_STATUS_PROBE_DIAGNOSTIC_SEAM.md',
  'P0365 R0 PREWRITE STATIC 202/236 REFUSED'),
 ('docs/memory/evidence/P0364_PLAYER_HELPFUL_AURA_DIAGNOSTIC_SEAM.md',
  'P0364 R0 PREWRITE STATIC 201/235 REFUSED'),
):
    need(marker in read(path), 'prior refusal evidence lost '+path)
for token in ('P0354 R0','P0354 R1','P0354 R2','P0355 R0',
              'P0355 R1','P0358 R0','P0361 R0 handoff','check_memory_health.py'):
    need(token in H,'historical refused handoff lost '+token)
need(len(list((ROOT/'tools').glob('check_*.py')))==239,
     'expected 239 checker inventory')
print('P0368 November 4 internal-alpha freeze gate: PASS (STATIC, WoW UNVERIFIED)')
