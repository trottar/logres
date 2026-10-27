#!/usr/bin/env python3
"""P0361: D.2 immersion report owner and dispatch behavior, static only."""
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]

def read(path):
    return (ROOT / path).read_text(encoding='utf-8')

def need(value, message):
    if not value:
        raise AssertionError(message)

def function(source, signature):
    need(source.count(signature) == 1, 'missing/duplicated function ' + signature)
    i = source.index(signature)
    j = source.find('\nend\n', i)
    need(j > i, 'unterminated function ' + signature)
    return source[i:j + 5]

C = read('Logres/Core/Commands.lua')
I = read('Logres/Immersion/Controller.lua')
T = read('Logres/Logres.toc')
B = read('Logres/Core/Bootstrap.lua')
CUR = read('docs/memory/CURRENT.md')
HAND = read('docs/memory/handoffs/CURRENT_HANDOFF.md')
wrapper = function(C, 'local function runImmersionCheck()\n')
need(wrapper == 'local function runImmersionCheck()\n'
     '    Logres:GetModule("ImmersionController"):RunDevImmersionCheck(emit, boolText)\nend\n',
     'Commands must be pure immersion diagnostic dispatcher')
report = function(I, 'function ImmersionController:RunDevImmersionCheck(emit, boolText)\n')
for token in (
    'Logres:GetModuleStatus("ImmersionController")',
    'Logres:GetModule("ImmersionController")',
    'controller:GetDebugStatus()',
    'Logres:GetPreferences()', 'Logres:GetState()',
    'preferences.immersionEnabled == true',
    'state.context == "world"',
    'debugStatus.immersionEnabled',
    'debugStatus.context',
    'debugStatus.actionReplacementDesired',
    'debugStatus.actionReplacementRequested',
    'debugStatus.actionReplacementApplied',
    'debugStatus.actionReplacementPending',
    'debugStatus.quietModeImplemented == true',
    'debugStatus.quietModeDesired',
    'debugStatus.quietModeRequested',
    'debugStatus.quietModeApplied',
    'debugStatus.playerFrameSuppressionImplemented == true',
    'debugStatus.playerFrameSuppressionDesired',
    'debugStatus.playerFrameSuppressionRequested',
    'debugStatus.playerFrameSuppressionApplied',
    'debugStatus.playerFrameSuppressionPending',
    'debugStatus.targetFrameSuppressionImplemented == true',
    'debugStatus.targetFrameSuppressionDesired',
    'debugStatus.targetFrameSuppressionRequested',
    'debugStatus.targetFrameSuppressionApplied',
    'debugStatus.targetFrameSuppressionPending',
    'debugStatus.partyFrameSuppressionDesired == false',
    'debugStatus.primaryActionRoutingOwned == false',
    'debugStatus.lastActionError == nil',
    'debugStatus.lastQuietError == nil',
    'debugStatus.lastPlayerError == nil',
    'debugStatus.lastTargetError == nil',
    'InCombatLockdown()',
    'Logres immersioncheck: PASS (',
    'Logres immersioncheck: FAIL (',
    'boolText(debugStatus.immersionEnabled)',
    'tostring(debugStatus.lastReconcileReason)',
):
    need(token in report, 'original D.2 report invariant lost: ' + token)
need(report.count('emit(string.format(') == 2, 'PASS/FAIL emission count changed')
need(report.index('Logres immersioncheck: PASS (') < report.index('Logres immersioncheck: FAIL ('),
     'PASS/FAIL report ordering changed')
need('Logres immersioncheck: PASS (' not in C and 'Logres immersioncheck: FAIL (' not in C,
     'duplicated immersion diagnostic in Commands')
need(I.index('function ImmersionController:GetDebugStatus()') <
     I.index('function ImmersionController:RunDevImmersionCheck('),
     'owner report must follow GetDebugStatus')
for forbidden in (
    'C_Timer.', 'RegisterEvent(', 'SetScript(', 'SetPoint(', 'SetParent(',
    'SetAttribute(', 'SetAlpha(', 'RegisterStateDriver(', 'hooksecurefunc(',
    ':Show(', ':Hide(', 'UnitHealth(', 'UnitPower(', 'issecretvalue(',
    'SetBinding(', 'SaveBindings(', 'SetPreference(', 'RequestEnabled(',
    'GetAttribute(', 'GetAlpha(', 'GetChildren(',
):
    need(forbidden not in report, 'diagnostic gained native/protected mutation or secret read: ' + forbidden)
for token in ('    runImmersionCheck()', 'if command == "immersioncheck" then',
              '"Immersion Check"', '"immersioncheck"', '"immersionCheck",',
              '"D"', '    runStockReplacementCheck()', '    runQuietModeCheck()'):
    need(token in C, 'Run All/slash/panel semantics lost: ' + token)
need(C.index('    runStockReplacementCheck()') <
     C.index('    runImmersionCheck()') < C.index('    runQuietModeCheck()'),
     'Run All Phase D ordering changed')
need('Immersion\\Controller.lua' in T and 'Core\\Commands.lua' in T and
     T.index('Immersion\\Controller.lua') < T.index('Core\\Commands.lua'),
     'Immersion owner must load before command routing')
need(len([line for line in T.splitlines() if line.endswith('.lua')]) == 94,
     'unexpected Lua TOC inventory')
need(len(re.findall(r'Logres:RegisterDevPanelAction\(\s*"', C)) == 120,
     'developer-panel inventory changed')
tv = re.search(r'(?m)^## Version: (\S+)$', T)
bv = re.search(r'(?m)^Logres.VERSION = "([^"]+)"$', B)
need(bool(tv and bv and tv.group(1) == bv.group(1) and
          re.fullmatch(r'0\.0\.\d+-dev', tv.group(1))),
     'runtime-version parity/format changed')
legacy = read('tools/check_immersion_controller_contract.py')
for token in ('PlayerFrame:Hide(', 'TargetFrame:Hide(',
              'PartyFrame:Hide(', 'CompactPartyFrame:Hide(',
              'primaryActionRoutingOwned = false',
              'quietModeImplemented = true',
              '"local function runImmersionCheck()"',
              'Phase D replacement/controller load order is incorrect'):
    need(token in legacy, 'historical immersion/native fallback checker weakened: ' + token)
prior = read('tools/check_p0360_target_frame_diagnostic_seam_contract.py')
need("glob('check_*.py'))) >= 231" in prior and
     'TargetFrame:Hide(' in read('tools/check_target_frame_replacement_contract.py'),
     'P0360 historical checker inventory floor or stock safety lost')
for token in ('P0361', 'P0360', 'P0359', 'P0358', 'P0357', 'P0356',
              'P0355', 'P0354', 'P0353', 'P0352', 'P0351', 'P0350',
              'P0349', 'P0348', 'P0347', 'P0346', 'P0321',
              'D-048', 'UNVERIFIED', 'L-019', 'L-022', 'L-027',
              'L-028', 'L-031', 'cfdc07af'):
    need(token in CUR and token in HAND, 'CURRENT/HANDOFF continuity lost ' + token)
for n in range(317, 362):
    need(f'P{n:04d}' in HAND, f'handoff milestone P{n:04d} lost')
for n in range(317, 338):
    need(f'P{n:04d}' in CUR, f'CURRENT milestone P{n:04d} lost')
need(len(CUR.encode('utf-8')) < 9800 and len(HAND.encode('utf-8')) <= 8000,
     'CURRENT/HANDOFF budget exceeded')
for p in ('docs/memory/investigations/ACTIVE.md', 'docs/memory/roadmap/STATUS.md',
          'docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md', 'docs/ROADMAP.md',
          'docs/memory/patches/PATCH_INDEX.md'):
    need('P0361' in read(p) and 'P0360' in read(p),
         'durable roadmap/index checkpoint lost ' + p)
for p in ('docs/memory/evidence/P0361_IMMERSION_DIAGNOSTIC_SEAM.md',
          'docs/memory/patches/P0361_IMMERSION_DIAGNOSTIC_SEAM.md'):
    content = read(p)
    for token in ('P0361', 'P0360', 'P0321', '232', 'UNVERIFIED', 'OPEN'):
        need(token in content, 'checkpoint evidence missing ' + token)
    need(content.endswith('\n') and not content.endswith('\n\n') and '\r' not in content,
         'evidence newline hygiene ' + p)
need(all(t in HAND for t in ('P0354 R0', 'P0354 R1', 'P0354 R2',
                             'P0355 R0', 'P0355 R1', 'P0358 R0',
                             'check_memory_health.py', 'P0361 R0 handoff')),
     'known failed candidate or R0 handoff evidence lost')
need('P0361 R0 handoff' in read('docs/memory/evidence/P0361_IMMERSION_DIAGNOSTIC_SEAM.md') and
     'R0 SUPERSEDED' in read('docs/memory/evidence/P0361_IMMERSION_DIAGNOSTIC_SEAM.md'),
     'P0361 initial delivery failure not durably preserved')
need(len(list((ROOT / 'tools').glob('check_*.py'))) >= 232,
     'checker #232 missing')
print('P0361 D.2 Immersion diagnostic ownership: PASS (STATIC; WoW UNVERIFIED)')
