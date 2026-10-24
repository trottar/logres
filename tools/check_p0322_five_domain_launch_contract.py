#!/usr/bin/env python3
"""P0322: release roadmap / ownership claims stay honest; docs-only contract."""
from pathlib import Path
ROOT = Path(__file__).resolve().parents[1]
def read(path): return (ROOT / path).read_text(encoding='utf-8')
files = {
    'decision': 'docs/memory/decisions/D-048_FIVE_INDEPENDENT_SYSTEMS.md',
    'launch': 'docs/memory/roadmap/LAUNCH_READINESS.md',
    'issues': 'docs/memory/investigations/ISSUE_REGISTER.md',
    'current': 'docs/memory/CURRENT.md',
    'handoff': 'docs/memory/handoffs/CURRENT_HANDOFF.md',
    'record': 'docs/memory/patches/P0322_FIVE_SYSTEMS_LAUNCH_ROADMAP.md',
    'evidence': 'docs/memory/evidence/P0322_FIVE_SYSTEMS_LAUNCH_ROADMAP.md',
}
s = {k: read(v) for k, v in files.items()}
errors = []
def need(ok, reason):
    if not ok: errors.append(reason)
for key in ('NAV', 'ACT', 'NPC', 'STATUS', 'CAM'):
    need(key in s['decision'], 'five-domain decision missing ' + key)
    need(key in s['launch'], 'launch roadmap missing ' + key)
need('32 configurations' in s['decision'], 'five-selector test matrix missing')
need('immersionEnabled' in s['decision'] and 'activeQuestEnabled' in s['decision'], 'migration source state missing')
for val in ('alpha', '1.0', 'November 4', 'P0323', 'P0321', 'UNVERIFIED', 'fallback'):
    need(val.lower() in s['launch'].lower(), 'launch gate missing ' + val)
for val in ('merchant', 'flight', 'P0321', 'TargetFrame', 'QuestieDB', 'EDIT'):
    need(val.lower() in s['issues'].lower(), 'known issue missing ' + val)
for val in ('P0317', 'P0318', 'P0319', 'P0320', 'P0321', 'P0322', '9a180c8', 'UNVERIFIED'):
    need(val in s['current'], 'CURRENT history/status missing ' + val)
for val in ('## Active Objective', '## Current Work Item', '## Verified State', '## Next Action', '## Success Criteria', '## Do Not Reopen Without New Evidence', '## Relevant References'):
    need(s['current'].splitlines().count(val) == 1, 'CURRENT heading contract: '+val)
need('CURRENT.md' in s['handoff'], 'handoff authority missing')
need('R0/R1' in s['record'] and 'R2' in s['record'], 'previous failed artifacts not retained')
need('no Lua' in s['record'] and 'UNVERIFIED' in s['evidence'], 'docs-only / runtime boundary missing')
for name, v in s.items():
    need(v.endswith('\n') and not v.endswith('\n\n'), 'terminal newlines ' + name)
    need('\r' not in v, 'CR line ending ' + name)
need('immersionEnabled = true' in read('Logres/Core/Database.lua'), 'original saved preference baseline altered')
need('activeQuestEnabled' in read('Logres/Core/Preferences.lua'), 'original preference baseline altered')
# Compare current runtime metadata without pinning a historical version literal.
# The applier separately enforces a clean exact-HEAD baseline and docs-only outputs.
import re
toc = re.search(r'(?m)^## Version: (\S+)$', read('Logres/Logres.toc'))
bootstrap = re.search(r'(?m)^Logres\.VERSION = "([^"]+)"$', read('Logres/Core/Bootstrap.lua'))
need(bool(toc and bootstrap and toc.group(1) == bootstrap.group(1)),
     'docs-only checkpoint requires unchanged TOC/Bootstrap version parity')
print('P0322 five independently selectable Logres systems and launch readiness contract')
for item in errors: print('ERROR:', item)
if errors: raise SystemExit(1)
print('PASS: policy, alpha/1.0 gates, historic failures, runtime deferral, unchanged runtime version')
