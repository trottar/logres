#!/usr/bin/env python3
"""P0365 P0136 AuraStatusProbe status ownership: STATIC; WoW UNVERIFIED."""
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]

def read(path):
    return (ROOT / path).read_text(encoding='utf-8')

def need(condition, message):
    if not condition:
        raise AssertionError(message)

def function(source, signature):
    need(source.count(signature) == 1, 'missing/duplicate diagnostic scope: ' + signature)
    i = source.index(signature)
    j = source.find('\nend\n', i)
    need(j > i, 'unterminated diagnostic scope: ' + signature)
    return source[i:j+5]

C = read('Logres/Core/Commands.lua')
P = read('Logres/HUD/AuraStatusProbe.lua')
T = read('Logres/Logres.toc')
B = read('Logres/Core/Bootstrap.lua')
CUR = read('docs/memory/CURRENT.md')
HAND = read('docs/memory/handoffs/CURRENT_HANDOFF.md')
wrapper = function(C, 'local function runAuraStatusProbe()\n')
need(wrapper == ('local function runAuraStatusProbe()\n'
                 '    Logres:GetModule("AuraStatusProbe"):RunDevAuraStatusProbe(emit)\nend\n'),
     'Commands must retain the same manual probe forwarding route')
report = function(P, 'function Probe:RunDevAuraStatusProbe(emit)\n')
for token in (
    'Logres:GetModuleStatus("AuraStatusProbe")',
    'Logres:GetModule("AuraStatusProbe")',
    'probe:CaptureManual()',
    'probe:GetDebugStatus()',
    'local captureOK = type(capture) == "table"',
    'status.initialized == true',
    'status.enabled == true',
    'debugStatus.moduleEnabled == true',
    'debugStatus.unitAuraRegistered == true',
    'debugStatus.targetChangedRegistered == true',
    'debugStatus.enteringWorldRegistered == true',
    'debugStatus.secretCheckerAvailable == true',
    'debugStatus.predicateAvailable == true',
    'debugStatus.queryAvailable == true',
    'debugStatus.unitExistsAvailable == true',
    'debugStatus.failureCount == 0',
    '"Logres aurastatusprobe: %s (capture=%s',
    'passed and "PASS" or "FAIL"',
    'tostring(debugStatus.ordinaryAuraCount)',
    'tostring(debugStatus.secretSkipCount)',
    'tostring(debugStatus.secretFieldCount)',
    'tostring(debugStatus.failureCount)',
    'tostring(debugStatus.targetAvailable)',
    'local lines = probe:GetDiagnosticLines()',
    'for index = 1, #lines do',
    '"Logres aurastatusprobe: "',
    '.. tostring(lines[index])',
):
    need(token in report, 'original P0136 report behavior lost: ' + token)
need(report.count('probe:CaptureManual()') == 1 and
     report.count('probe:GetDiagnosticLines()') == 1 and
     report.count('emit(string.format(') == 1 and
     report.count('emit(') == 2,
     'manual capture/status/detail print count changed')
# P0365 R0 PREWRITE 202/236 erroneously scanned the entire Commands file
# for a local diagnostics-line collection shared by five OTHER manual probes.
# The actual AuraStatusProbe wrapper and unique report label are the boundary.
need('Logres aurastatusprobe: %s (capture=%s' not in C,
     'AuraStatusProbe PASS/FAIL report duplicated in Commands')
need('local lines = probe:GetDiagnosticLines()' not in wrapper,
     'AuraStatusProbe wrapper must not collect diagnostic detail lines')
need(P.index('function Probe:GetDiagnosticLines()') <
     P.index('function Probe:GetDebugStatus()') <
     P.index('function Probe:RunDevAuraStatusProbe(emit)'),
     'owner diagnostics must follow probe core methods')
for forbidden in (
    'C_Timer.', 'RegisterEvent(', 'RegisterUnitEvent(',
    'SetScript(', 'SetAlpha(', 'SetParent(', 'SetPoint(',
    'SetAttribute(', 'RegisterStateDriver(', 'hooksecurefunc(',
    'C_UnitAuras.', 'UnitAura(', 'GetAuraDataByIndex(',
    'UnitHealth(', 'UnitPower(', 'issecretvalue(', ':Hide(', ':Show(',
    'CancelUnitBuff(', 'SaveBindings(', 'SetBinding(',
):
    need(forbidden not in report, 'new native/protected/secret behavior: '+forbidden)
for token in (
    'if command == "aurastatusprobe" then',
    '        runAuraStatusProbe()',
    'emit("  /logres aurastatusprobe")',
    '"auraStatusProbe",',
    '"Aura Status Probe",',
    '"aurastatusprobe",',
):
    need(token in C, 'manual slash or developer-panel route lost: '+token)
run_all = function(C, 'local function runAllChecks()\n')
need('runAuraStatusProbe()' not in run_all,
     'contextual/manual probe incorrectly added to Run All')
need(C.count('        runAuraStatusProbe()') == 1,
     'manual aura status probe route missing or duplicated')
need('HUD\\AuraStatusProbe.lua' in T and 'Core\\Commands.lua' in T and
     T.index('HUD\\AuraStatusProbe.lua') < T.index('Core\\Commands.lua'),
     'AuraStatusProbe must load before commands')
need(len([x for x in T.splitlines() if x.endswith('.lua')]) == 94,
     'Lua load inventory changed')
need(len(re.findall(r'Logres:RegisterDevPanelAction\(\s*"', C)) == 120,
     'developer panel inventory changed')
tv = re.search(r'(?m)^## Version: (\S+)$', T)
bv = re.search(r'(?m)^Logres.VERSION = "([^"]+)"$', B)
need(bool(tv and bv and tv.group(1) == bv.group(1) and
          re.fullmatch(r'0\.0\.\d+-dev', tv.group(1))),
     'TOC/Bootstrap version parity/format changed')
legacy = read('tools/check_aura_status_probe_contract.py')
for token in (
    'C_Secrets.ShouldUnitAuraIndexBeSecret',
    'C_UnitAuras.GetAuraDataByIndex',
    'scalarRecord must secret-check before nil/type inspection',
    'readAuraIndex must preflight and secret-check predicate',
    'UNIT_AURA event handler must discard update payload arguments',
    'AuraStatusProbe.lua contains forbidden bulk/delta/',
    '"runAuraStatusProbe()"',
    'function Probe:RunDevAuraStatusProbe(emit)',
    'Logres:GetModule("AuraStatusProbe"):RunDevAuraStatusProbe(emit)',
    '"Logres aurastatusprobe: %s',
):
    need(token in legacy, 'historical P0136 safety or owner check weakened: ' + token)
prior = read('tools/check_p0364_player_helpful_aura_diagnostic_seam_contract.py')
need("glob('check_*.py'))) >= 235" in prior and
     "run_all = function(C, 'local function runAllChecks()\\n')" in prior,
     'P0364 historical checker scope or inventory floor weakened')
for token in ('P0365','P0364','P0363','P0362','P0361','P0360',
              'P0359','P0358','P0357','P0356','P0355','P0354',
              'P0353','P0352','P0351','P0350','P0349','P0348',
              'P0347','P0346','P0321','D-048','UNVERIFIED',
              'L-019','L-022','L-027','L-028','L-031','cfdc07af'):
    need(token in CUR and token in HAND,
         'CURRENT/HANDOFF continuity lost '+token)
for n in range(317, 366):
    need(f'P{n:04d}' in HAND, f'historical milestone P{n:04d} lost')
for n in range(317, 338):
    need(f'P{n:04d}' in CUR, f'CURRENT historical milestone P{n:04d} lost')
need(len(CUR.encode('utf-8')) < 9800 and len(HAND.encode('utf-8')) <= 8000,
     'CURRENT/HANDOFF size policy exceeded')
for path in ('docs/memory/investigations/ACTIVE.md',
             'docs/memory/roadmap/STATUS.md',
             'docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md',
             'docs/ROADMAP.md','docs/memory/patches/PATCH_INDEX.md'):
    need('P0365' in read(path) and 'P0364' in read(path),
         'new roadmap/index evidence missing '+path)
for path in ('docs/memory/evidence/P0365_AURA_STATUS_PROBE_DIAGNOSTIC_SEAM.md',
             'docs/memory/patches/P0365_AURA_STATUS_PROBE_DIAGNOSTIC_SEAM.md'):
    s = read(path)
    for token in ('P0365','P0364','P0321','236','UNVERIFIED','OPEN'):
        need(token in s, 'new checkpoint evidence missing '+path+': '+token)
    need(s.endswith('\n') and not s.endswith('\n\n') and '\r' not in s,
         'new checkpoint LF hygiene '+path)
for record in (
    'docs/memory/evidence/P0365_AURA_STATUS_PROBE_DIAGNOSTIC_SEAM.md',
    'docs/memory/patches/P0365_AURA_STATUS_PROBE_DIAGNOSTIC_SEAM.md',
):
    need('P0365 R0 PREWRITE STATIC 202/236 REFUSED' in read(record),
         'P0365 R0 PREWRITE false positive must remain documented: ' + record)
need('P0364 R0 PREWRITE STATIC 201/235 REFUSED' in
     read('docs/memory/evidence/P0364_PLAYER_HELPFUL_AURA_DIAGNOSTIC_SEAM.md'),
     'P0364 checker false positive evidence erased')
for marker in ('P0354 R0','P0354 R1','P0354 R2','P0355 R0','P0355 R1',
               'P0358 R0','P0361 R0 handoff','check_memory_health.py'):
    need(marker in HAND, 'historical negative evidence missing '+marker)
need(len(list((ROOT / 'tools').glob('check_*.py'))) >= 236,
     'expected checker #236 absent')
print('P0365 AuraStatusProbe diagnostic seam: PASS (STATIC; WoW UNVERIFIED)')
