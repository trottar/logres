#!/usr/bin/env python3
"""P0418 approved whole-screen map translation contract."""
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
read = lambda p: (ROOT / p).read_text(encoding='utf-8')
layout = read('Logres/Integration/Layout.lua')
panel = read('Logres/Dev/Panel.lua')
current = read('docs/memory/CURRENT.md')
status = read('docs/memory/roadmap/STATUS.md')
active = read('docs/memory/investigations/ACTIVE.md')
issue = read('docs/memory/investigations/ISSUE_LEDGER.md')
patch = read('docs/memory/patches/PATCH_INDEX.md')
pre = read('docs/memory/PRE_HANDOFF_AUDIT.md')
toc = read('Logres/Logres.toc')
boot = read('Logres/Core/Bootstrap.lua')
plan = json.loads(read('docs/design/layout/SCREEN_MAP_V5.json'))
errors=[]
def need(ok, msg):
    if not ok:
        errors.append(msg)

need(plan.get('source') == 'LOGRES_SCREEN_MAP_APPROVED.json', 'approved source drift')
need(plan.get('coordinateSpace') == 'viewport percentages, component centers', 'coordinate space drift')
ids = [item.get('id') for item in plan.get('components', [])]
need(ids == ['compass','activeQuest','playerReaction','playerHarmful','targetFallback','targetHarmful','targetHelpful','allies','petActions','bar2','bar1','bar4','bar3','bar5','passiveStatus','contextObjective','contextXP','questDialogue','reportBug'], 'approved component order drift')
for token in (
    'questDialogue = { id = "questDialogue", x = 50.0, y = 28.0 }',
    'contextObjective = { id = "contextObjective", x = 50.0, y = 50.0 }',
    'contextXP = { id = "contextXP", x = 50.0, y = 63.0 }',
    'reportBug = { id = "reportBug", x = 95.0, y = 35.0 }',
    'classPet = { id = "petActions", x = 10.0, y = 55.0 }',
    'passiveStatus = { id = "player-buff", x = 77.0, y = 75.0 }',
    '{ "reportBug", "LogresBugReportButton", 91.0, 33.25, 8.0, 3.5 }',
    '{ "contextObjective", "LogresQuestObjectiveProgress", 40.0, 47.5, 20.0, 5.0 }',
    '{ "contextXP", "LogresQuestXPPulse", 40.0, 61.0, 20.0, 4.0 }',
    '{ "questDialogue", "LogresQuestDialogue", 35.0, 28.0, 30.0, 30.0 }',
    'reportBug = {',
    'LogresLayoutReportBug',
):
    need(token in layout, 'layout translation token missing: ' + token)
need('Logres.Layout.Bind(bugButton, "reportBug", "CENTER", "CENTER")' in panel,
     'Report Bug not rebound to its own anchor')
need('P0418' in current and '## P0418' in status and '## P0418' in active,
     'active memory not updated for P0418')
for path_text in (issue, patch, pre, read('docs/memory/evidence/P0418_APPROVED_SCREEN_MAP_TRANSLATION.md'), read('docs/memory/patches/P0418_APPROVED_SCREEN_MAP_TRANSLATION.md')):
    need('P0418' in path_text, 'durable P0418 memory/doc missing')
need('## Version:' in toc and 'Logres.VERSION = "' in boot,
     'version markers missing')
import re
need(re.search(r'(?m)^## Version: (\S+)$', toc).group(1) == re.search(r'(?m)^Logres.VERSION = "([^"]+)"$', boot).group(1),
     'TOC/bootstrap version parity drift')
print('P0418 approved whole-screen map translation contract')
for err in errors:
    print('ERROR:', err)
if errors:
    raise SystemExit(1)
print('PASS: approved map authority, translated anchors, bug-button routing, memory and version advance are present')
