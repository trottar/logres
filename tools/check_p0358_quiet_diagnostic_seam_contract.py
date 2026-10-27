#!/usr/bin/env python3
"""P0358: D.3 Quiet Mode diagnostic is owned by QuietMode (STATIC; no runtime proof)."""
from pathlib import Path
import re
R=Path(__file__).resolve().parents[1]
def read(p):return (R/p).read_text(encoding='utf-8')
def need(ok,msg):
    if not ok:raise AssertionError(msg)
def fn(s,head):
    need(s.count(head)==1,'unique function required '+head)
    a=s.index(head);b=s.find('\nend\n',a)
    need(b>a,'unbounded function '+head)
    return s[a:b+5]
C=read('Logres/Core/Commands.lua')
Q=read('Logres/Immersion/QuietMode.lua')
T=read('Logres/Logres.toc')
B=read('Logres/Core/Bootstrap.lua')
CUR=read('docs/memory/CURRENT.md')
H=read('docs/memory/handoffs/CURRENT_HANDOFF.md')
w=fn(C,'local function runQuietModeCheck()\n')
need(w=='local function runQuietModeCheck()\n'
       '    Logres:GetModule("QuietMode"):RunDevQuietCheck(emit, boolText)\nend\n',
     'Commands must retain original Quiet Mode forwarding')
report=fn(Q,'function QuietMode:RunDevQuietCheck(emit, boolText)\n')
for marker in (
    'Logres:GetModuleStatus("QuietMode")',
    'Logres:GetModule("QuietMode")',
    'quietMode:GetDebugStatus()',
    'Logres:GetPreferences()', 'Logres:GetState()',
    'preferences.immersionEnabled == true',
    'state.context == "world"',
    'debugStatus.requestedEnabled == expected',
    'debugStatus.appliedEnabled == expected',
    'debugStatus.chatFrameCount >= 1',
    'debugStatus.suppressedChatFrameCount',
    'debugStatus.persistentShownMatches == true',
    'debugStatus.savedConfigurationMutation == false',
    'debugStatus.regionSnapshotCount == 0',
    'debugStatus.editBoxSnapshotCount == 0',
    'status.initialized == true',
    'status.enabled == true',
    'debugStatus.lastError == nil',
    'Logres quietcheck: PASS (',
    'Logres quietcheck: FAIL (',
    'boolText(expected)', 'boolText(debugStatus.appliedEnabled)',
):need(marker in report,'Quiet PASS/FAIL status semantics lost '+marker)
need(report.count('emit(string.format(')==2 and
     report.index('Logres quietcheck: PASS (')<report.index('Logres quietcheck: FAIL ('),
     'Quiet report must retain ordered PASS/FAIL emits')
for forbidden in ('C_Timer.', 'RegisterEvent(', 'SetScript(', 'SetPoint(',
                  'SetParent(', 'SetAttribute(', 'SetCVar(', 'SendChatMessage(',
                  'HideUIPanel(', 'ShowUIPanel(', 'issecretvalue(',
                  ':Hide(', ':Show(', 'hooksecurefunc(', 'UnitHealth('):
    need(forbidden not in report,'read-only report gained unsafe behavior '+forbidden)
need('Logres quietcheck: PASS (' not in C and 'Logres quietcheck: FAIL (' not in C,
     'duplicate Quiet report remains in Commands')
need(Q.index('function QuietMode:GetDebugStatus()')<Q.index('function QuietMode:RunDevQuietCheck('),
     'Quiet status owner must precede read-only report')
for route in ('    runQuietModeCheck()', 'if command == "quietcheck" then',
              '"Quiet Check"', '"quietcheck"', '"quietCheck",'):
    need(route in C,'Run All/slash/panel route lost '+route)
need(C.index('    runImmersionCheck()')<C.index('    runQuietModeCheck()')<
     C.index('    runPlayerFrameCheck()'),'Quiet Run All order changed')
need('Immersion\\QuietMode.lua' in T and 'Core\\Commands.lua' in T and
     T.index('Immersion\\QuietMode.lua')<T.index('Core\\Commands.lua'),
     'Quiet module must load before Commands')
need(len([x for x in T.splitlines() if x.endswith('.lua')])==94,
     'Lua load count changed')
need(len(re.findall(r'Logres:RegisterDevPanelAction\(\s*"',C))==120,
     'developer actions count changed')
tv=re.search(r'(?m)^## Version: (\S+)$',T)
bv=re.search(r'(?m)^Logres.VERSION = "([^"]+)"$',B)
need(bool(tv and bv and tv.group(1)==bv.group(1) and
          re.fullmatch(r'0\.0\.\d+-dev',tv.group(1))),
     'runtime version parity')
legacy=read('tools/check_quiet_mode_contract.py')
for marker in ('SetChatWindowShown(', 'SendChatMessage(',
               'function QuietMode:RunDevQuietCheck(emit, boolText)',
               'function QuietMode:RequestEnabled(enabled, reason)',
               'QuietMode must load before ImmersionController and Commands'):
    need(marker in legacy,'D.3 historical safety or owner check removed '+marker)
prior=read('tools/check_p0357_objective_progress_seam_contract.py')
need("glob('check_*.py')))>=228" in prior and
     'Progress report must use addon-owned status only' in
         read('tools/check_objective_progress_contract.py'),
     'P0357 checker count floor or F.6 safety weakened')
for token in ('P0358','P0357','P0356','P0355','P0354','P0353','P0352',
              'P0351','P0350','P0349','P0348','P0347','P0346','P0321',
              'D-048','UNVERIFIED','L-019','L-022','L-027','L-028',
              'L-031','cfdc07af'):
    need(token in CUR and token in H,'current/handoff continuity '+token)
for n in range(317,359):need(f'P{n:04d}' in H,'handoff milestone missing P%04d'%n)
for n in range(317,338):need(f'P{n:04d}' in CUR,'CURRENT milestone missing P%04d'%n)
need(len(CUR.encode('utf-8'))<9800 and len(H.encode('utf-8'))<=8000,
     'memory budget exceeded')
for path in ('docs/memory/investigations/ACTIVE.md','docs/memory/roadmap/STATUS.md',
             'docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md','docs/ROADMAP.md',
             'docs/memory/patches/PATCH_INDEX.md'):
    need('P0358' in read(path),'durable checkpoint missing '+path)
for path in ('docs/memory/evidence/P0358_QUIET_DIAGNOSTIC_SEAM.md',
             'docs/memory/patches/P0358_QUIET_DIAGNOSTIC_SEAM.md'):
    doc=read(path)
    for marker in ('P0358','P0357','P0321','229','UNVERIFIED','OPEN'):
        need(marker in doc,'durable provenance absent '+path+': '+marker)
    need(doc.endswith('\n') and not doc.endswith('\n\n') and '\r' not in doc,
         'evidence newline hygiene '+path)
need(all(x in H for x in ('P0354 R0','P0354 R1','P0354 R2',
                          'P0355 R0','P0355 R1','check_memory_health.py')),
     'refused-candidate history lost')
need(len(list((R/'tools').glob('check_*.py')))==229,
     'expected 229 static checkers')
print('P0358 Quiet Mode diagnostic seam: PASS (STATIC; WoW UNVERIFIED)')
