#!/usr/bin/env python3
"""P0340 internal A0/A3 prefreeze inventory and installation-doc accuracy gate."""
from pathlib import Path
import importlib.util
import re

R=Path(__file__).resolve().parents[1]
read=lambda p:(R/p).read_text(encoding='utf-8')

def need(ok,why):
    if not ok: raise AssertionError(why)

source=read('tools/alpha_prefreeze_audit.py')
README=read('README.md')
CUR=read('docs/memory/CURRENT.md')
HAND=read('docs/memory/handoffs/CURRENT_HANDOFF.md')
LAUNCH=read('docs/memory/roadmap/LAUNCH_READINESS.md')
E=read('docs/memory/evidence/P0340_ALPHA_PREFREEZE_AUDIT.md')
P=read('docs/memory/patches/P0340_ALPHA_PREFREEZE_AUDIT.md')
STAGE=read('tools/stage_alpha_candidate.py')
TOC=read('Logres/Logres.toc')
BOOT=read('Logres/Core/Bootstrap.lua')

# Source identity: no new addon Lua, camera, native state, dependency or
# runtime packaging changes. P0340 tool reuses the existing P0328 stage model.
for x in ('stage.collect(root)', 'stage.build_bytes(metadata, rows)',
          'archive.testzip() is None', 'archive.read(name) == content',
          'QuestieDB', 'LibCamera', 'README.md', 'PUBLIC RELEASE: NOT APPROVED',
          'P0321 restoration', 'NO-DUMMY-SENTINEL' if False else 'UNVERIFIED'):
    need(x in source, 'P0340 audit source invariant missing '+x)
need('PUBLIC RELEASE: NOT APPROVED' in source and 'client_tested' in source,
     'release and runtime are not auditable claims')
need('does not yet add database compass icons' not in README, 'obsolete QuestieDB README remained')
for item in ('QuestieDB', 'optional', 'docs/DEPENDENCIES.md', 'P0337',
             'INTERNAL', 'not approved'):
    need(item in README, 'README installation/eligibility/distribution omitted '+item)
for item in ('P0340', 'P0339', 'P0338', 'P0321', 'UNVERIFIED',
             'NOV04_GAMEPLAY_REGRESSION_MATRIX.md', 'L-019'):
    need(item in CUR, 'CURRENT historical continuity: '+item)
for item in ('CURRENT.md','P0340', 'L-019', 'P0321'):
    need(item in HAND, 'handoff authority missing '+item)
for n in range(317,341):
    need(f'P{n:04d}' in HAND, 'handoff legacy marker P%04d'%n)
for p in ('docs/memory/investigations/ACTIVE.md','docs/memory/roadmap/STATUS.md',
          'docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md',
          'docs/ROADMAP.md','docs/memory/patches/PATCH_INDEX.md'):
    need('P0340' in read(p), 'checkpoint not indexed '+p)
for t in ('Nov 3', 'P0340', 'L-019', 'NOT APPROVED', 'P0321'):
    need(t in LAUNCH, 'LAUNCH_READINESS audit reference missing '+t)
for doc in (E,P):
    for marker in ('P0340','L-019','UNVERIFIED','P0321','README.md'):
        need(marker in doc, 'P0340 durable record incomplete: '+marker)
    need(doc.endswith('\n') and not doc.endswith('\n\n'), 'P0340 durable record EOF')
need(len(re.findall(r'(?m)^## Version: \S+',TOC))==1,'TOC version missing')
need(re.search(r'(?m)^## Version: (\S+)$',TOC).group(1)==
     re.search(r'(?m)^Logres.VERSION = "([^"]+)"$',BOOT).group(1),
     'TOC / Bootstrap parity')
need(len([line for line in TOC.splitlines() if line.endswith('.lua')])==94,
     'P0340 preserved TOC load inventory')
need('alpha_prefreeze_audit.py' not in TOC and 'check_p0340_alpha_prefreeze_contract.py' not in TOC,
     'offline tools became addon runtime source')

spec=importlib.util.spec_from_file_location('p0340_actual_prefreeze',R/'tools/alpha_prefreeze_audit.py')
need(spec and spec.loader, 'audit source not importable')
module=importlib.util.module_from_spec(spec);spec.loader.exec_module(module)
result=module.audit(R)
need(result['lua_count']==94 and result['media_count']>0 and
     result['stage_members']==result['lua_count']+result['media_count']+3,
     'internal staged file count does not match TOC+media+TOC+notice+stamp')
need(not result['public_approved'] and not result['client_tested'],
     'audit incorrectly classifies release/runtime PASS')
# The current upstream repository is missing a root project license;
# no implicit approval is permitted even when a license arrives later.
need('L-019' in E and 'NOT APPROVED' in LAUNCH, 'L-019 human gate bypassed')
print('P0340 A0/A3 internal source inventory and installation documentation contract')
print('PASS: source-verified staged members, bytes and CRC; client/public release UNVERIFIED')
