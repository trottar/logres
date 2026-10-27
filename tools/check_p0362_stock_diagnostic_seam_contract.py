#!/usr/bin/env python3
"""P0362: Bar 2-5 stock replacement report ownership; static-only contract."""
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]

def read(p):
    return (ROOT / p).read_text(encoding='utf-8')

def need(ok, message):
    if not ok:
        raise AssertionError(message)

def fn(s, signature):
    need(s.count(signature) == 1, 'missing/duplicated function ' + signature)
    i = s.index(signature)
    j = s.find('\nend\n', i)
    need(j > i, 'unbounded function ' + signature)
    return s[i:j + 5]

C = read('Logres/Core/Commands.lua')
S = read('Logres/Actions/StockReplacement.lua')
T = read('Logres/Logres.toc')
B = read('Logres/Core/Bootstrap.lua')
CUR = read('docs/memory/CURRENT.md')
HAND = read('docs/memory/handoffs/CURRENT_HANDOFF.md')
wrapper = fn(C, 'local function runStockReplacementCheck()\n')
need(wrapper == 'local function runStockReplacementCheck()\n'
     '    Logres:GetModule("StockActionReplacement"):RunDevStockReplacementCheck(emit, boolText)\nend\n',
     'Commands must preserve original wrapper and diagnostic helpers')
report = fn(S, 'function StockReplacement:RunDevStockReplacementCheck(emit, boolText)\n')
for token in (
    'Logres:GetModuleStatus("StockActionReplacement")',
    'Logres:GetModule("StockActionReplacement")',
    'replacement:GetDebugStatus()',
    'Logres:GetPreference("immersionEnabled") == true',
    'local lifecycleConsistent =',
    'debugStatus.requestedEnabled == expectedEnabled',
    'debugStatus.appliedEnabled == expectedEnabled',
    'debugStatus.pending == false',
    'debugStatus.lastError == nil',
    'debugStatus.snapshotReady == expectedEnabled',
    'local appliedConsistent = true',
    'debugStatus.secondaryAlpha == 0',
    'debugStatus.utilityAlpha == 0',
    'debugStatus.secondaryFrameMouseEnabled == false',
    'debugStatus.utilityFrameMouseEnabled == false',
    'debugStatus.secondaryButtonMouseEnabledCount == 0',
    'debugStatus.utilityButtonMouseEnabledCount == 0',
    'debugStatus.secondaryRoutingEnabled == true',
    'debugStatus.secondaryBindingsApplied == true',
    'debugStatus.utilityRoutingEnabled == true',
    'debugStatus.utilityBindingsApplied == true',
    'debugStatus.bar4Alpha == 0',
    'debugStatus.bar5Alpha == 0',
    'debugStatus.bar4FrameMouseEnabled == false',
    'debugStatus.bar5FrameMouseEnabled == false',
    'debugStatus.bar4ButtonMouseEnabledCount == 0',
    'debugStatus.bar5ButtonMouseEnabledCount == 0',
    'debugStatus.bar4RoutingEnabled == true',
    'debugStatus.bar4BindingsApplied == true',
    'debugStatus.bar5RoutingEnabled == true',
    'debugStatus.bar5BindingsApplied == true',
    'debugStatus.mainActionBarSuppressed == false',
    'debugStatus.unsupportedBarsSuppressed == false',
    'and lifecycleConsistent', 'and appliedConsistent',
    'Logres stockreplacecheck: PASS (',
    'Logres stockreplacecheck: FAIL (',
    'Logres stockreplacecheck extras: bar4 alpha=',
    'Logres stockreplacecheck startup: deferrals=%s retries=%s lastEvent=%s',
    'boolText(expectedEnabled)',
):
    need(token in report, 'original stock replacement status lost: ' + token)
need(report.count('emit(string.format(') == 5,
     'PASS/FAIL and supplemental output emission count changed')
need(report.index('Logres stockreplacecheck: PASS (') <
     report.index('Logres stockreplacecheck extras:') <
     report.index('Logres stockreplacecheck: FAIL ('),
     'stock diagnostic output ordering changed')
need(report.count('Logres stockreplacecheck startup: deferrals=') == 2,
     'PASS and FAIL startup status reports changed')
for token in ('Logres stockreplacecheck: PASS (', 'Logres stockreplacecheck: FAIL (',
              'Logres stockreplacecheck startup: deferrals=',
              'local lifecycleConsistent ='):
    need(token not in C, 'report implementation duplicated in Commands: ' + token)
for forbidden in (
    'C_Timer.', 'OnUpdate', 'RegisterEvent(', 'SetScript(', 'SetPoint(',
    'SetParent(', 'SetAttribute(', 'SetAlpha(', 'RegisterStateDriver(',
    'hooksecurefunc(', ':Show(', ':Hide(', 'UnitHealth(', 'UnitPower(',
    'issecretvalue(', 'SetBinding(', 'SaveBindings(', 'SetPreference(',
    'RequestEnabled(', 'GetAttribute(', 'GetAlpha(', 'IsMouseEnabled(',
    'GetChildren(', 'EnableMouse(',
):
    need(forbidden not in report, 'diagnostic gained protected/native operation: ' + forbidden)
need(S.index('function StockReplacement:GetDebugStatus()') <
     S.index('function StockReplacement:RunDevStockReplacementCheck('),
     'diagnostic owner must follow original GetDebugStatus')
for token in ('    runStockReplacementCheck()',
              'if command == "stockreplacecheck" then',
              'if command == "stockreplace" then',
              '"Stock Replace Check"', '"Stock Replace ON"', '"Stock Replace OFF"',
              '"stockreplacecheck"', '"stockReplaceCheck",',
              'replacement:IsRoutingManaged(key)',
              'local function handleStockReplacement(argument)'):
    need(token in C, 'Run All/slash/panel/stock routing changed: ' + token)
need(C.index('    runPrimaryOwnershipCheck()') <
     C.index('    runStockReplacementCheck()') <
     C.index('    runImmersionCheck()'), 'Run All stock replacement order changed')
need('Actions\\StockReplacement.lua' in T and 'Core\\Commands.lua' in T and
     T.index('Actions\\StockReplacement.lua') < T.index('Core\\Commands.lua'),
     'StockReplacement owner load order changed')
need(len([x for x in T.splitlines() if x.endswith('.lua')]) == 94,
     'Lua TOC inventory changed')
need(len(re.findall(r'Logres:RegisterDevPanelAction\(\s*"', C)) == 120,
     'developer action inventory changed')
tv = re.search(r'(?m)^## Version: (\S+)$', T)
bv = re.search(r'(?m)^Logres.VERSION = "([^"]+)"$', B)
need(bool(tv and bv and tv.group(1) == bv.group(1) and
          re.fullmatch(r'0\.0\.\d+-dev', tv.group(1))),
     'dynamic TOC/Bootstrap runtime-version parity changed')
legacy = read('tools/check_stock_replacement_contract.py')
for token in ('MainActionBar:Hide(', 'OverrideActionBar:Hide(',
              'SetBinding(', 'SaveBindings(',
              'snapshot.frame:SetAlpha(0)',
              'snapshot.frame:EnableMouse(false)',
              '"function StockReplacement:RunDevStockReplacementCheck(emit, boolText)"',
              '"local function runStockReplacementCheck()"',
              'StockReplacement must load after Context and before Commands'):
    need(token in legacy, 'historical stock safety/report contract weakened: ' + token)
startup = read('tools/check_stock_startup_recovery_contract.py')
for token in ('self.pending and self.requestedEnabled',
              'self.retryCount = self.retryCount + 1',
              'self.lastRetryEvent = event',
              'self:ApplyRequestedState()',
              "check=scope(STOCK.read_text(encoding='utf-8'),",):
    need(token in startup, 'P0170 startup retry or owner check removed: ' + token)
prior = read('tools/check_p0361_immersion_diagnostic_seam_contract.py')
need("glob('check_*.py'))) >= 232" in prior and
     'ImmersionController:RunDevImmersionCheck(emit, boolText)' in prior,
     'P0361 ownership or historical checker floor weakened')
for token in ('P0362', 'P0361', 'P0360', 'P0359', 'P0358', 'P0357',
              'P0356', 'P0355', 'P0354', 'P0353', 'P0352', 'P0351',
              'P0350', 'P0349', 'P0348', 'P0347', 'P0346', 'P0321',
              'D-048', 'UNVERIFIED', 'L-019', 'L-022', 'L-027', 'L-028',
              'L-031', 'cfdc07af'):
    need(token in CUR and token in HAND,
         'CURRENT/HANDOFF historical continuity lost: ' + token)
for n in range(317, 363):
    need(f'P{n:04d}' in HAND, f'handoff milestone P{n:04d} missing')
for n in range(317, 338):
    need(f'P{n:04d}' in CUR, f'CURRENT milestone P{n:04d} missing')
need(len(CUR.encode('utf-8')) < 9800 and len(HAND.encode('utf-8')) <= 8000,
     'historical CURRENT/HANDOFF memory budgets exceeded')
for p in ('docs/memory/investigations/ACTIVE.md', 'docs/memory/roadmap/STATUS.md',
          'docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md', 'docs/ROADMAP.md',
          'docs/memory/patches/PATCH_INDEX.md'):
    need('P0362' in read(p) and 'P0361' in read(p),
         'durable roadmap/index P0362 checkpoint missing: ' + p)
for p in ('docs/memory/evidence/P0362_STOCK_DIAGNOSTIC_SEAM.md',
          'docs/memory/patches/P0362_STOCK_DIAGNOSTIC_SEAM.md'):
    s = read(p)
    for t in ('P0362', 'P0361', 'P0321', '233', 'UNVERIFIED', 'OPEN'):
        need(t in s, 'P0362 evidence marker missing: ' + t)
    need(s.endswith('\n') and not s.endswith('\n\n') and '\r' not in s,
         'P0362 evidence newline hygiene ' + p)
need('P0361 R0 handoff' in HAND and 'check_memory_health.py' in HAND and
     'P0358 R0' in HAND and 'cfdc07af' in HAND,
     'earlier refused packaging/historical evidence erased')
need(len(list((ROOT / 'tools').glob('check_*.py'))) == 233,
     'expected 233 static checkers')
print('P0362 stock diagnostic ownership: PASS (STATIC; WoW UNVERIFIED)')
