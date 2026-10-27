#!/usr/bin/env python3
"""P0364: preserve helpful player aura diagnostic in its module owner; static only."""
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]


def read(path):
    return (ROOT / path).read_text(encoding='utf-8')


def need(condition, message):
    if not condition:
        raise AssertionError(message)


def function(source, signature):
    need(source.count(signature) == 1, 'missing/duplicated function: ' + signature)
    a = source.index(signature)
    b = source.find('\nend\n', a)
    need(b > a, 'unterminated function: ' + signature)
    return source[a:b + 5]


C = read('Logres/Core/Commands.lua')
H = read('Logres/HUD/PlayerHelpfulAuras.lua')
T = read('Logres/Logres.toc')
B = read('Logres/Core/Bootstrap.lua')
CUR = read('docs/memory/CURRENT.md')
HAND = read('docs/memory/handoffs/CURRENT_HANDOFF.md')

wrapper = function(C, 'local function runPlayerHelpfulAuraCheck()\n')
need(wrapper == 'local function runPlayerHelpfulAuraCheck()\n'
     '    Logres:GetModule("PlayerHelpfulAuras"):RunDevHelpfulAuraCheck(emit)\nend\n',
     'Commands report wrapper/emit routing changed')
report = function(H, 'function HelpfulAuras:RunDevHelpfulAuraCheck(emit)\n')
for token in (
    'Logres:GetModuleStatus("PlayerHelpfulAuras")',
    'Logres:GetModule("PlayerHelpfulAuras")',
    'module:Refresh("diagnostic-check")',
    'local debugStatus = module:GetDebugStatus()',
    'debugStatus.immersionEnabled == true',
    'debugStatus.visibleCount > 0',
    'debugStatus.rootShown == expectedShown',
    'debugStatus.presentationShown',
    'status.initialized == true',
    'status.enabled == true',
    'debugStatus.moduleEnabled == true',
    'debugStatus.rootReady == true',
    'debugStatus.slotCount == 4',
    'debugStatus.unitAuraRegistered == true',
    'debugStatus.worldRegistered == true',
    'debugStatus.sourceAvailable == true',
    'refreshOK == true',
    'debugStatus.failureCount == 0',
    'and visibilityCoherent',
    'Logres helpfulauracheck: %s (refresh=%s reason=%s root=%s expected=%s',
    'passed and "PASS" or "FAIL"',
    'tostring(debugStatus.secretSkipCount)',
    'tostring(debugStatus.secretFieldCount)',
    'tostring(debugStatus.lastPresentationReason)',
    'tostring(debugStatus.lastError)',
):
    need(token in report, 'original P0137 report invariant lost: '+token)
need(report.count('emit(string.format(') == 1 and
     report.count('module:Refresh("diagnostic-check")') == 1 and
     report.count('module:GetDebugStatus()') == 1,
     'diagnostic report/refresh order changed')
need('Logres helpfulauracheck: %s (' not in C,
     'Commands duplicates module-owned report')
for unsafe in (
    'C_Timer.', 'RegisterEvent(', 'RegisterUnitEvent(', 'SetScript(',
    'SetAlpha(', 'SetPoint(', 'SetParent(', 'SetAttribute(',
    'RegisterStateDriver(', 'hooksecurefunc(', 'GameTooltip:',
    'C_UnitAuras.', 'UnitAura(', 'UnitHealth(', 'UnitPower(',
    'issecretvalue(', 'GetAuraDataByIndex(', 'SetBinding(',
    'SaveBindings(', 'SetPreference(', 'CancelUnitBuff(',
):
    need(unsafe not in report, 'diagnostic acquired native/secret operation '+unsafe)
need(H.index('function HelpfulAuras:GetDebugStatus()') <
     H.index('function HelpfulAuras:RunDevHelpfulAuraCheck('),
     'debug-state owner must precede report')
for token in (
    'local function runPlayerHelpfulAuraPreview(argument)',
    '    runPlayerHelpfulAuraCheck()',
    'if command == "helpfulauracheck" then',
    'if command == "helpfulaurapreview" then',
    '"playerHelpfulAuraCheck",',
    '"Player Helpful Aura Check"',
    '"helpfulauracheck"',
    '"H"',
    '"playerHelpfulAuraPreview",',
    '"Player Helpful Aura Preview"',
    '"helpfulaurapreview"',
):
    need(token in C, 'existing check/preview/Phase H route lost: '+token)
# Scope the order assertion to Run All, not the entire Commands source.
# Other helpers can legitimately invoke a diagnostic before Run All is defined.
run_all = function(C, 'local function runAllChecks()\n')
run_all_calls = (
    '    runQuestOfferStockSuppressionCheck()\n',
    '    runPlayerHelpfulAuraCheck()\n',
    '    runStatusAuraCheck()\n',
)
need(all(run_all.count(call) == 1 for call in run_all_calls) and
     all(run_all.index(a) < run_all.index(b)
         for a, b in zip(run_all_calls, run_all_calls[1:])),
     'Run All quest/helpful/status order changed')
need('HUD\\PlayerHelpfulAuras.lua' in T and 'Core\\Commands.lua' in T and
     T.index('HUD\\PlayerHelpfulAuras.lua') < T.index('Core\\Commands.lua'),
     'module no longer loads before Commands')
need(len([x for x in T.splitlines() if x.endswith('.lua')]) == 94,
     'original 94 Lua load entries changed')
need(len(re.findall(r'Logres:RegisterDevPanelAction\(\s*"', C)) == 120,
     'original 120 developer-panel actions changed')
tv = re.search(r'(?m)^## Version: (\S+)$', T)
bv = re.search(r'(?m)^Logres.VERSION = "([^"]+)"$', B)
need(bool(tv and bv and tv.group(1) == bv.group(1) and
          re.fullmatch(r'0\.0\.\d+-dev', tv.group(1))),
     'TOC/Bootstrap development version not matched')
legacy = read('tools/check_player_helpful_auras_contract.py')
for token in (
    'C_Secrets.ShouldUnitAuraIndexBeSecret',
    'if isSecret(predicateResult) then',
    'if isSecret(aura) then',
    'if isSecret(icon) then',
    'C_UnitAuras.GetAuraDataByIndex',
    'UNIT_AURA update payload arguments are deliberately discarded',
    'BuffFrame:Hide',
    'TargetFrame:Hide',
    'PlayerHelpfulAuras.lua must load after AuraStatusProbe and before Commands',
    '"function HelpfulAuras:RunDevHelpfulAuraCheck(emit)"',
    '"local function runPlayerHelpfulAuraCheck()"',
    'RunDevHelpfulAuraCheck(emit)',
):
    need(token in legacy, 'historical aura secret/native contract weakened '+token)
prior = read('tools/check_p0363_quest_offer_stock_diagnostic_seam_contract.py')
need("glob('check_*.py'))) >= 234" in prior and
     'QuestFrame subtree walk' in prior and
     'RunDevQuestOfferStockSuppressionCheck(emit)' in prior,
     'prior P0363 safety checker or inventory floor weakened')
for token in (
    'P0364','P0363','P0362','P0361','P0360','P0359','P0358',
    'P0357','P0356','P0355','P0354','P0353','P0352','P0351',
    'P0350','P0349','P0348','P0347','P0346','P0321',
    'D-048','UNVERIFIED','L-019','L-022','L-027','L-028',
    'L-031','cfdc07af',
):
    need(token in CUR and token in HAND, 'CURRENT/HANDOFF continuity lost '+token)
for n in range(317, 365):
    need('P%04d' % n in HAND, 'historical handoff milestone missing P%04d' % n)
for n in range(317, 338):
    need('P%04d' % n in CUR, 'historical CURRENT milestone missing P%04d' % n)
need(len(CUR.encode('utf-8')) < 9800 and len(HAND.encode('utf-8')) <= 8000,
     'CURRENT/HANDOFF memory budget exceeded')
for path in (
    'docs/memory/investigations/ACTIVE.md',
    'docs/memory/roadmap/STATUS.md',
    'docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md',
    'docs/ROADMAP.md',
    'docs/memory/patches/PATCH_INDEX.md',
):
    need('P0364' in read(path) and 'P0363' in read(path),
         'new roadmap/index checkpoint absent '+path)
for path in (
    'docs/memory/evidence/P0364_PLAYER_HELPFUL_AURA_DIAGNOSTIC_SEAM.md',
    'docs/memory/patches/P0364_PLAYER_HELPFUL_AURA_DIAGNOSTIC_SEAM.md',
):
    note = read(path)
    for token in ('P0364','P0363','P0321','235','UNVERIFIED','OPEN'):
        need(token in note, 'evidence marker missing '+token+' in '+path)
    need('P0364 R0 PREWRITE STATIC 201/235 REFUSED' in note,
         'P0364 R0 PREWRITE failure evidence not preserved '+path)
    need(note.endswith('\n') and not note.endswith('\n\n') and '\r' not in note,
         'evidence LF hygiene '+path)
for marker in ('P0354 R0','P0354 R1','P0354 R2','P0355 R0',
               'P0355 R1','P0358 R0','P0361 R0 handoff',
               'check_memory_health.py'):
    need(marker in HAND, 'historical PREWRITE/handoff negative evidence lost '+marker)
need(len(list((ROOT/'tools').glob('check_*.py'))) == 235,
     'expected 235 static checkers')
print('P0364 Player Helpful Aura diagnostic owner: PASS (STATIC; WoW UNVERIFIED)')
