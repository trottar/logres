#!/usr/bin/env python3
"""P0329 one-shot gameplay capture source contract; never substitutes for WoW runtime."""
from pathlib import Path
import re

root = Path(__file__).resolve().parents[1]
commands = (root / "Logres/Core/Commands.lua").read_text(encoding="utf-8")
panel = (root / "Logres/Dev/Panel.lua").read_text(encoding="utf-8")
toc = (root / "Logres/Logres.toc").read_text(encoding="utf-8")
bootstrap = (root / "Logres/Core/Bootstrap.lua").read_text(encoding="utf-8")
issues = (root / "docs/memory/investigations/ISSUE_REGISTER.md").read_text(encoding="utf-8")
current = (root / "docs/memory/CURRENT.md").read_text(encoding="utf-8")
handoff = (root / "docs/memory/handoffs/CURRENT_HANDOFF.md").read_text(encoding="utf-8")

def need(ok, what):
    if not ok:
        raise AssertionError(what)

begin = commands.index("function Logres:RunGameplayCapture()")
end = commands.index("local function printPreferences()", begin)
block = commands[begin:end]
for token in ('Logres:GetState()', 'Logres:GetPreferences()',
              'GetDebugStatus', 'StatusAuras', 'Compass', 'HUD',
              'PetActionPresentation', 'module:IsEnabled()', 'pcall('):
    need(token in block, "snapshot misses source-safe boundary: " + token)
for forbidden in ('UnitHealth(', 'UnitHealthPercent(', 'UnitAura(',
                  'GetAuraDataByIndex(', 'GetPoint(', 'SetPoint(',
                  'SetAlpha(', 'SetFrameStrata(', 'OnUpdate', 'C_Timer',
                  'GetPetActionInfo(', 'GetBindingKey('):
    need(forbidden not in block, "snapshot performs forbidden state read/write: " + forbidden)
need('if command == "gameplaycapture" then' in commands and
     'Logres:RunGameplayCapture()' in commands, "namespace slash dispatch missing")
need('local function runGameplayCapture(' not in commands,
     "capture routine must not add a local upvalue to handleCommand")
# The P0178 source checker enforces the same <=60 closure-capture contract.
start=commands.index('local function handleCommand(message)')
end=commands.index('function Logres:RunDevCommand(',start)
locals_before=set(re.findall(r'(?m)^local\s+(?:function\s+)?([A-Za-z_]\w*)', commands[:start]))
locals_before.add('Logres')
captured=[n for n in locals_before if re.search(r'\b'+re.escape(n)+r'\b',commands[start:end])]
need(len(captured) <= 60, 'handleCommand upvalue budget exceeded')
need('"gameplaySnapshot"' in commands and
     '"Gameplay Snapshot"' in commands and
     '"gameplaycapture"' in commands, "phase 0 action missing")
need('panel:BeginDiagnosticRun("gameplaycapture")' in commands,
     "closed-panel slash must save a run without opening a UI")
need('MAX_DIAGNOSTIC_RUNS = 100' in panel and 'MAX_DIAGNOSTIC_LINES = 120' in panel,
     "existing bounded diagnostics store changed")
need('## SavedVariables: LogresDB, LogresDiagnosticsDB' in toc,
     "saved diagnostics backing missing")
v = re.search(r'(?m)^## Version: (\S+)\s*$', toc)
b = re.search(r'(?m)^Logres.VERSION = "([^"]+)"\s*$', bootstrap)
need(v is not None and b is not None and v.group(1) == b.group(1),
     "TOC/Bootstrap runtime version diverged")
need('Core\\Commands.lua' in toc and 'Dev\\Panel.lua' in toc,
     "existing production modules missing")
need(len([s for s in toc.splitlines() if s.endswith('.lua')]) == 94,
     "source inventory unexpectedly changed")
for issue in range(20,33):
    need(f'| L-{issue:03d} |' in issues, f'missing issue L-{issue:03d}')
for marker in tuple(f'P{n:04d}' for n in range(317, 330)) + ('## Next Action',):
    need(marker in current, 'checkpoint continuity lost: ' + marker)
# P0326/P0327 contracts explicitly require these markers in CURRENT_HANDOFF.
# Enforce them in the new checker before the old checkers become a runtime blocker.
for marker in ('CURRENT.md', 'P0326', 'P0327', 'P0328', 'P0329'):
    need(marker in handoff, 'handoff history/authority lost: ' + marker)
for file in ('docs/memory/evidence/P0329_GAMEPLAY_SNAPSHOT.md',
             'docs/memory/patches/P0329_GAMEPLAY_SNAPSHOT.md'):
    s=(root/file).read_text(encoding='utf-8')
    need('UNVERIFIED' in s and s.endswith('\n') and not s.endswith('\n\n') and '\r' not in s,
         'evidence or hygiene gate: ' + file)
print('P0329 gameplay capture / regression intake source contract')
print('PASS: read-only capture route, bounded SavedVariables, version parity, 13 issue IDs')
