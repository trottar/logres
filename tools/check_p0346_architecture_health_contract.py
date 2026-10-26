#!/usr/bin/env python3
"""P0346: read-only architecture inventory, bounded diagnostics and history."""
from pathlib import Path
import importlib.util
import re

ROOT = Path(__file__).resolve().parents[1]
read = lambda p: (ROOT / p).read_text(encoding='utf-8')
path = ROOT / 'tools/architecture_health_audit.py'
spec = importlib.util.spec_from_file_location('logres_architecture_health_audit', path)
audit = importlib.util.module_from_spec(spec)
spec.loader.exec_module(audit)

def need(ok,why):
    if not ok: raise AssertionError(why)

report=audit.inspect(ROOT)
faults=audit.verify(report)
need(not faults, 'architecture static audit refused: '+str(faults))
need(report['loaded_lua_count']==94 and not report['orphan_lua_paths'] and not report['missing_loaded_paths'],
     '94 loaded modules must include every Lua file once')
need(report['dev_panel_actions']>=120 and report['dev_panel_phases']['P']==38 and
     report['dev_panel_actions']==report['dev_panel_unique_ids'],
     'historical developer-panel registry/galleries must remain unchanged')
need(report['commands_bytes']>0 and report['commands_percent_loaded_source']>=0,
     'dispatcher source metrics must remain measurable; do not require permanent bloat')
need('not runtime capability' in report['meaning'], 'runtime-claim boundary missing')
need(report['toc_version']==report['bootstrap_version'], 'version metadata mismatch')

# Real dynamic source paths, no addon Lua executed; negative fixtures catch gaps.
for field in ('missing_loaded_paths','orphan_lua_paths','duplicate_loaded_paths','dev_panel_duplicate_ids'):
    simulated=dict(report); simulated[field]=['synthetic.lua']
    need(any(field in f for f in audit.verify(simulated)),
         'audit must reject source or panel inventory failure: '+field)
simulated=dict(report)
simulated['dev_panel_phases']=dict(report['dev_panel_phases'], P=39)
need(any('preview' in f for f in audit.verify(simulated)), 'extra P action must be rejected')
simulated=dict(report);simulated['bootstrap_version']='0.0.invalid'
need(any('parity' in f for f in audit.verify(simulated)), 'version mismatch must be rejected')

C=read('docs/memory/CURRENT.md');H=read('docs/memory/handoffs/CURRENT_HANDOFF.md')
E=read('docs/memory/evidence/P0346_ARCHITECTURE_HEALTH_AUDIT.md')
P=read('docs/memory/patches/P0346_ARCHITECTURE_HEALTH_AUDIT.md')
D=read('docs/memory/architecture/P0346_ARCHITECTURE_GAP_REGISTER.md')
for marker in ('P0346','P0345','P0344','P0343','P0342','P0338','P0321','UNVERIFIED','L-022','L-027','L-028','L-019'):
    need(marker in C and marker in H,'CURRENT/HANDOFF continuity '+marker)
for marker in ('P0337','cfdc07af','P0338','L-031','UNVERIFIED'):
    need(marker in C and marker in H,'P0338 historical continuity '+marker)
need(len(C.encode('utf-8'))<9800, 'CURRENT maintenance budget')
for i in range(317,346):need(f'P{i:04d}' in H,'handoff historical marker missing '+str(i))
for marker in ('241','120','38','94','D-048','P0323','L-019','P0321','OPEN','UNVERIFIED',
               'Commands.lua','Blizzard','Do not'):
    need(marker in D,'audited architecture decision/risk gap missing '+marker)
for marker in ('P0346','P0321','UNVERIFIED','216','217','D-048'):
    need(marker in E and marker in P, 'record provenance/safety gate missing '+marker)
for f in ('docs/ROADMAP.md','docs/memory/investigations/ACTIVE.md',
          'docs/memory/roadmap/STATUS.md','docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md',
          'docs/memory/patches/PATCH_INDEX.md'):
    need('P0346' in read(f), 'memory and patch index not synchronized '+f)
for doc in (E,P,D):
    need(doc.endswith('\n') and not doc.endswith('\n\n') and '\r' not in doc,
         'durable evidence EOF hygiene')
need('P0346' in read('docs/memory/architecture/P0346_ARCHITECTURE_GAP_REGISTER.md'),
     'architecture record unavailable')
need(len([p for p in (ROOT/'tools').glob('check_*.py')])==217,
     '217 expected total feature checkers')
# No Lua, panel, TOC, or saved-variable edits occur in this docs/tools checkpoint.
need('p0324_domain_policy.py' not in read('Logres/Logres.toc'),
     'future five-domain fixture must remain offline and inert')
need(re.search(r'(?m)^Logres.VERSION = "([^"]+)"$',read('Logres/Core/Bootstrap.lua')) is not None,
     'original runtime metadata lost')
print('P0346 architecture health inventory/negative drift tests: PASS (STATIC; WoW UNVERIFIED)')
