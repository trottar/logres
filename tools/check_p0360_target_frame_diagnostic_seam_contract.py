#!/usr/bin/env python3
"""P0360: keep D-026 TargetFrame diagnostics owned by TargetFrameReplacement (STATIC)."""
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]

def read(path):
    return (ROOT / path).read_text(encoding='utf-8')

def need(condition, message):
    if not condition:
        raise AssertionError(message)

def function(text, signature):
    need(text.count(signature) == 1, 'missing or duplicate function '+signature)
    a = text.index(signature)
    b = text.find('\nend\n', a)
    need(b > a, 'unterminated function '+signature)
    return text[a:b+5]

C = read('Logres/Core/Commands.lua')
T = read('Logres/Immersion/TargetFrameReplacement.lua')
TOC = read('Logres/Logres.toc')
BOOT = read('Logres/Core/Bootstrap.lua')
CUR = read('docs/memory/CURRENT.md')
HAND = read('docs/memory/handoffs/CURRENT_HANDOFF.md')

wrapper = function(C, 'local function runTargetFrameCheck()\n')
need(wrapper == 'local function runTargetFrameCheck()\n'
        '    Logres:GetModule("TargetFrameReplacement"):RunDevTargetFrameCheck(emit, boolText)\nend\n',
     'Commands TargetFrame diagnostic wrapper changed')
report = function(T, 'function TargetFrameReplacement:RunDevTargetFrameCheck(emit, boolText)\n')
for token in (
    'Logres:GetModuleStatus("TargetFrameReplacement")',
    'Logres:GetModule("TargetFrameReplacement")',
    'replacement:GetDebugStatus()',
    'Logres:GetPreference("immersionEnabled") == true',
    'debugStatus.requestedEnabled == expected',
    'debugStatus.appliedEnabled == expected',
    'debugStatus.pending', 'InCombatLockdown()',
    'debugStatus.targetFrameFound == true',
    'debugStatus.containerFound == true',
    'debugStatus.contentMainFound == true',
    'debugStatus.contextualFound == true',
    'debugStatus.stockPresentationSuppressed == true',
    'debugStatus.stockMouseSuppressed == true',
    'debugStatus.preservedCount == 4',
    'debugStatus.suppressedContextCount == 9',
    'debugStatus.contextualSuppressedCount == 9',
    'debugStatus.interactionReady == true',
    'debugStatus.interactionConfigured == true',
    'debugStatus.unitWatchRegistered == true',
    'debugStatus.interactionMouseOwnedByLogres == true',
    'debugStatus.interactionUnit == "target"',
    'debugStatus.interactionLeftType == "target"',
    'debugStatus.interactionRightType == "togglemenu"',
    'debugStatus.snapshotReady == true',
    'debugStatus.appliedEnabled == false',
    'debugStatus.unitWatchRegistered == false',
    'debugStatus.stockPresentationSuppressed == false',
    'debugStatus.stockMouseSuppressed == false',
    'debugStatus.contextualSuppressedCount == 0',
    'debugStatus.wholeTargetFrameSuppressedByLogres == false',
    'debugStatus.targetOfTargetSuppressedByLogres == false',
    'debugStatus.focusFrameSuppressedByLogres == false',
    'debugStatus.bossFramesSuppressedByLogres == false',
    'debugStatus.partyFramesSuppressedByLogres == false',
    'debugStatus.lastError == nil',
    'Logres targetframecheck: PASS (',
    'Logres targetframecheck: FAIL (',
    'boolText(expected)',
):
    need(token in report, 'original D-026 target diagnostic token lost: '+token)
need(report.count('emit(string.format(') == 2 and
     report.index('Logres targetframecheck: PASS (') <
     report.index('Logres targetframecheck: FAIL ('),
     'original PASS/FAIL emission count or order changed')
for token in ('Logres targetframecheck: PASS (', 'Logres targetframecheck: FAIL ('):
    need(token not in C, 'Commands still owns a duplicate report: '+token)
for forbidden in (
    'C_Timer.', 'SetAlpha(', 'SetPoint(', 'SetParent(',
    'SetAttribute(', 'RegisterEvent(', 'SetScript(',
    'RegisterStateDriver(', 'hooksecurefunc(',
    ':Show(', ':Hide(', 'UnitHealth(', 'UnitPower(',
    'issecretvalue(', 'SetBinding(', 'SaveBindings(',
    'GetAttribute(', 'GetAlpha(', 'GetChildren(',
    'RegisterUnitWatch(', 'UnregisterUnitWatch(',
):
    need(forbidden not in report, 'report gained protected/native operation: '+forbidden)
need(T.index('function TargetFrameReplacement:GetDebugStatus()') <
     T.index('function TargetFrameReplacement:RunDevTargetFrameCheck('),
     'diagnostic owner must follow existing debug status')
for token in (
    '    runTargetFrameCheck()',
    'if command == "targetframecheck" then',
    '"Target Frame Check"', '"targetframecheck"',
    '"targetFrameCheck",',
    'target.contextualSuppressedCount',
    'targetSuppressedExpected',
):
    need(token in C, 'existing Run All/slash/panel/target status lost: '+token)
need(C.index('    runPlayerFrameCheck()') <
     C.index('    runTargetFrameCheck()') <
     C.index('    runRestorationCheck()'),
     'D.4 Run All order changed')
need('Immersion\\TargetFrameReplacement.lua' in TOC and
     'Core\\Commands.lua' in TOC and
     TOC.index('Immersion\\TargetFrameReplacement.lua') < TOC.index('Core\\Commands.lua'),
     'TargetFrame owner load order changed')
need(len([x for x in TOC.splitlines() if x.endswith('.lua')]) == 94,
     'Lua inventory changed')
need(len(re.findall(r'Logres:RegisterDevPanelAction\(\s*"', C)) == 120,
     'developer-panel action inventory changed')
tv = re.search(r'(?m)^## Version: (\S+)$', TOC)
bv = re.search(r'(?m)^Logres.VERSION = "([^"]+)"$', BOOT)
need(bool(tv and bv and tv.group(1) == bv.group(1) and
          re.fullmatch(r'0\.0\.\d+-dev', tv.group(1))),
     'runtime development version parity changed')
legacy = read('tools/check_target_frame_replacement_contract.py')
for token in (
    'TargetFrame:Hide(', 'TargetFrame:SetAlpha(',
    '"SecureUnitButtonTemplate"',
    '"local function runTargetFrameCheck()"',
    'TargetFrameReplacement:RunDevTargetFrameCheck(emit, boolText)',
    'target.contextualSuppressedCount',
    'targetSuppressedExpected',
    'TargetFrame diagnostic still inspects ',
    'RegisterUnitWatch(self.interaction)',
    'UnregisterUnitWatch(self.interaction)',
    'preserved contextual children must not be mutated',
):
    need(token in legacy, 'historical target replacement contract weakened: '+token)
prior = read('tools/check_p0359_player_frame_diagnostic_seam_contract.py')
need("glob('check_*.py')))>=230" in prior and
     'PlayerFrame:Hide(' in read('tools/check_player_frame_replacement_contract.py'),
     'P0359 historical floor or PlayerFrame safety lost')
for token in ('P0360','P0359','P0358','P0357','P0356','P0355','P0354',
              'P0353','P0352','P0351','P0350','P0349','P0348','P0347','P0346',
              'P0321','D-048','UNVERIFIED','L-019','L-022','L-027','L-028',
              'L-031','cfdc07af'):
    need(token in CUR and token in HAND,'CURRENT/HANDOFF continuity missing '+token)
for n in range(317,361):
    need(f'P{n:04d}' in HAND, 'historical handoff milestone missing: P%04d'%n)
for n in range(317,338):
    need(f'P{n:04d}' in CUR, 'historical CURRENT milestone missing: P%04d'%n)
need(len(CUR.encode('utf-8')) < 9800 and len(HAND.encode('utf-8')) <= 8000,
     'historical memory budget exceeded')
for path in ('docs/memory/investigations/ACTIVE.md','docs/memory/roadmap/STATUS.md',
             'docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md','docs/ROADMAP.md',
             'docs/memory/patches/PATCH_INDEX.md'):
    need('P0360' in read(path), 'durable roadmap/index update missing '+path)
for path in ('docs/memory/evidence/P0360_TARGET_FRAME_DIAGNOSTIC_SEAM.md',
             'docs/memory/patches/P0360_TARGET_FRAME_DIAGNOSTIC_SEAM.md'):
    source = read(path)
    for token in ('P0360','P0359','P0321','231','UNVERIFIED','OPEN'):
        need(token in source, 'new evidence marker missing '+path+': '+token)
    need(source.endswith('\n') and not source.endswith('\n\n') and '\r' not in source,
         'evidence newline hygiene '+path)
need(all(x in HAND for x in ('P0354 R0','P0354 R1','P0354 R2',
                            'P0355 R0','P0355 R1','P0358 R0',
                            'check_memory_health.py')),
     'known refused-candidate evidence lost')
need(len(list((ROOT/'tools').glob('check_*.py'))) == 231,
     'expected 231 static checkers')
print('P0360 D-026 TargetFrame diagnostic seam: PASS (STATIC; WoW UNVERIFIED)')
