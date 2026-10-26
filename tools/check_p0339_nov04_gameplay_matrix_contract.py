#!/usr/bin/env python3
"""P0339: source-verified November 4 P0330-P0338 runtime acceptance matrix."""
from pathlib import Path
import re
import sys

ROOT = Path(__file__).resolve().parents[1]
read = lambda path: (ROOT/path).read_text(encoding='utf-8')
M = read('docs/memory/roadmap/NOV04_GAMEPLAY_REGRESSION_MATRIX.md')
RUN = read('docs/memory/roadmap/NOV04_VALIDATION_RUNBOOK.md')
C = read('Logres/Core/Commands.lua')
CUR = read('docs/memory/CURRENT.md')
H = read('docs/memory/handoffs/CURRENT_HANDOFF.md')
ISSUE = read('docs/memory/investigations/ISSUE_REGISTER.md')
E = read('docs/memory/evidence/P0339_GAMEPLAY_RUNTIME_MATRIX.md')
P = read('docs/memory/patches/P0339_GAMEPLAY_RUNTIME_MATRIX.md')
T = read('Logres/Logres.toc')
BOOT = read('Logres/Core/Bootstrap.lua')

def need(ok, message):
    if not ok:
        raise AssertionError(message)

# Source-owned command registration, not guessed UI labels or inert controls.
actions = {
    ('0', 'Gameplay Snapshot', 'gameplaycapture'),
    ('B', 'HUD Check', 'hudcheck'),
    ('C', 'Action Check', 'actioncheck'),
    ('C', 'Pet Action Probe Check', 'petactionexecprobe check'),
    ('E', 'Compass Check', 'compasscheck'),
    ('F', 'XP Check', 'xpcheck'),
    ('F', 'Objective Progress Check', 'objectiveprogresscheck'),
    ('H', 'Gossip Stock Status (READ-ONLY)', 'gossipstockstatus'),
    ('H', 'Gossip Stock Toggle', 'gossipstocktoggle'),
    ('H', 'Layout Check', 'layoutcheck'),
    ('H', 'Pet State Diagnostic', 'petstate'),
    ('H', 'Status Aura Check', 'statusauracheck'),
    ('H', 'Navigation Source Probe', 'navigationsourceprobe'),
    ('P', 'PvP Badges ON', 'pvppreview on'),
    ('P', 'PvP Badges OFF', 'pvppreview off'),
    ('P', 'Compass Art ON', 'compassartpreview on'),
    ('P', 'Compass Art OFF', 'compassartpreview off'),
}
pattern = re.compile(
    r'Logres:RegisterDevPanelAction\(\s*"[^"]+",\s*"([^"]+)",\s*"([^"]+)",\s*"([0A-H P])"\s*\)',
    re.M
)
# Explicit format maps label+slash command to actual tab.
registered={(tab,label,command) for label,command,tab in pattern.findall(C)}
need(len(registered) > 80, 'Commands.lua dev-panel action registry not recovered')
for tab, label, command in sorted(actions):
    need((tab,label,command) in registered, f'P0339 matrix guessed action: {tab} {label} {command}')
    need(label in M and '/logres '+command in M, f'P0339 matrix omitted verified action: {label}')
for index in range(330,339):
    need('P%04d'%index in M, f'P0339 missing historical gameplay issue P{index:04d}')
for issue in ('L-021','L-023','L-024','L-025','L-026','L-027','L-028','L-029','L-030','L-031','L-032'):
    need(issue in M and '| '+issue+' |' in ISSUE, f'P0339 issue continuity: {issue}')
need(M.index('2. Open `/logres panel`') < M.index('| **P0330') and
     M.index('P0321',M.index('## Mandatory ordering')) < M.index('| **P0330'),
     'P0321 primary test order lost')
for safety in ('Quest 237', 'P0338', 'NOT EXECUTED', 'UNREPRODUCED',
               'DEFERRED', 'FAIL', 'PASS', '/fstack', 'LogresDiagnosticsDB',
               'L-019', 'D-046', 'D-047', 'D-048', 'distance unavailable'):
    if safety == 'D-046':
        # D-046 is covered in CURRENT and evidence but not essential matrix prose.
        need(safety in CUR or safety in E, 'D-046 authority lost')
    else:
        need(safety in M, 'P0339 safety/evidence marker missing: '+safety)
need('Logres compass focused marker:' in C and
     'Logres gameplaycapture Compass focused marker:' in C and
     'focusedMarkerKind' in M and 'P0341' in M,
     'P0341 generic focus diagnostics must be reflected in both source paths and matrix')
need('NOV04_GAMEPLAY_REGRESSION_MATRIX.md' in RUN, 'runbook must link matrix')
need('NOV04_GAMEPLAY_REGRESSION_MATRIX.md' in CUR, 'CURRENT must link matrix')
need('P0339' in H and 'CURRENT.md' in H, 'handoff authority/checkpoint lost')
for index in range(317,339):
    need(f'P{index:04d}' in H, f'P0339 handoff historical marker P{index:04d} missing')
for p in ('docs/memory/investigations/ACTIVE.md','docs/memory/roadmap/STATUS.md',
          'docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md',
          'docs/ROADMAP.md','docs/memory/patches/PATCH_INDEX.md'):
    need('P0339' in read(p), 'P0339 roadmap/patch record missing '+p)
for s in (E,P,M):
    need('UNVERIFIED' in s or 'NOT EXECUTED' in s, 'P0339 deferred scope missing')
    need(s.endswith('\n') and not s.endswith('\n\n'), 'record EOF hygiene')
need(re.search(r'^## Version: (\S+)$',T,re.M).group(1) ==
     re.search(r'^Logres.VERSION = "([^"]+)"$',BOOT,re.M).group(1),
     'TOC/Bootstrap parity')
need(len([line for line in T.splitlines() if line.endswith('.lua')])==94,
     'P0339 docs-only: loaded Lua inventory changed')
print('P0339 Nov04 source-verified panel/evidence matrix: PASS (STATIC; client UNVERIFIED)')
