#!/usr/bin/env python3
"""P0357: F.6 read-only objective-progress diagnostic ownership seam (STATIC)."""
from pathlib import Path
import re
R=Path(__file__).resolve().parents[1]
def rd(p):return (R/p).read_text(encoding='utf-8')
def need(ok,msg):
    if not ok:raise AssertionError(msg)
def fn(text,start):
    need(text.count(start)==1,'missing or duplicated function '+start)
    a=text.index(start);b=text.find('\nend\n',a)
    need(b>a,'unterminated '+start)
    return text[a:b+5]
C=rd('Logres/Core/Commands.lua')
P=rd('Logres/Quest/Progress.lua')
T=rd('Logres/Logres.toc')
B=rd('Logres/Core/Bootstrap.lua')
CUR=rd('docs/memory/CURRENT.md')
H=rd('docs/memory/handoffs/CURRENT_HANDOFF.md')
w=fn(C,'local function runObjectiveProgressCheck()\n')
need(w=='local function runObjectiveProgressCheck()\n'
        '    Logres:GetModule("QuestObjectiveProgress"):RunDevObjectiveProgressCheck(emit)\nend\n',
     'command wrapper must preserve original sink and call')
report=fn(P,'function Progress:RunDevObjectiveProgressCheck(emit)\n')
for marker in (
    'Logres:GetModuleStatus("QuestObjectiveProgress")',
    'Logres:GetModule("QuestObjectiveProgress")',
    'local debugStatus = progress:GetDebugStatus()',
    'debugStatus.superTrackedAPIAvailable == true',
    'debugStatus.selectedQuestAPIAvailable == true',
    'debugStatus.currentQuestID == nil',
    'debugStatus.baselineRowCount == 0',
    'debugStatus.currentQuestID > 0',
    'debugStatus.baselineRowCount >= 0',
    'debugStatus.immersionEnabled == true',
    'debugStatus.pulseShown == false',
    'status.initialized == true',
    'status.enabled == true',
    'debugStatus.moduleEnabled == true',
    'debugStatus.questLogEventRegistered == true',
    'debugStatus.questWatchEventRegistered == true',
    'debugStatus.superTrackingEventRegistered == true',
    'debugStatus.worldEventRegistered == true',
    'debugStatus.lastError == nil',
    'tostring(debugStatus.currentQuestID)',
    'tostring(debugStatus.lastSecret)',
    '"Logres objectiveprogresscheck: %s ',
    'passed and "PASS" or "FAIL"',
):need(marker in report,'original report field/policy missing '+marker)
need(report.count('emit(string.format(')==1,'original one-line emission changed')
need('Logres objectiveprogresscheck: ' not in C,'duplicate diagnostic output remains in Commands')
for forbidden in (
    'C_QuestLog.', 'C_SuperTrack.', 'GetQuestObjectives(',
    'GetSelectedQuest(', 'GetSuperTrackedQuestID(',
    'ObjectiveTrackerFrame', 'UnitHealth(', 'UnitAura(',
    'C_Timer.', 'SetScript(', 'RegisterEvent(', 'SetPoint(',
    'SetParent(', 'SetAttribute(', ':Hide(', ':Show(',
    'hooksecurefunc(', 'GetAttribute(',
):need(forbidden not in report,'report gained live/protected/native operation '+forbidden)
need(P.index('function Progress:GetDebugStatus()')<P.index('function Progress:RunDevObjectiveProgressCheck(emit)'),
     'Progress status owner must load before its diagnostic')
for token in (
    '    runObjectiveProgressCheck()',
    'if command == "objectiveprogresscheck" then',
    '"objectiveProgressCheck",',
    '"objectiveprogresscheck"',
    '"Objective Progress Check"',
    'local function runObjectiveProgressPreview()',
):need(token in C,'original command, Run All or panel route lost '+token)
need('Quest\\Progress.lua' in T and 'Core\\Commands.lua' in T and
     T.index('Quest\\Progress.lua')<T.index('Core\\Commands.lua'),
     'Progress must load before Commands')
need(len([x for x in T.splitlines() if x.endswith('.lua')])==94,
     'Lua load inventory changed')
need(len(re.findall(r'Logres:RegisterDevPanelAction\(\s*"',C))==120,
     'developer panel inventory changed')
tv=re.search(r'(?m)^## Version: (\S+)$',T)
bv=re.search(r'(?m)^Logres.VERSION = "([^"]+)"$',B)
need(bool(tv and bv and tv.group(1)==bv.group(1) and
          re.fullmatch(r'0\.0\.\d+-dev',tv.group(1))),
     'runtime version parity')
legacy=rd('tools/check_objective_progress_contract.py')
for marker in (
    'Progress diagnostic wrapper must delegate to module',
    'Progress report must use addon-owned status only',
    'if isSecret(objectives) then',
    'C_QuestLog.SetSelectedQuest',
    'ObjectiveTrackerFrame',
    'GetQuestObjectives(',
    'GetSuperTrackedQuestID(',
):need(marker in legacy,'original F.6 protection or relocated report checker missing '+marker)
prior=rd('tools/check_p0356_xp_diagnostic_seam_contract.py')
need("glob('check_*.py')))>=227" in prior and
     'XP report must consume addon-owned status only' in rd('tools/check_xp_pulse_contract.py'),
     'P0356 historical count floor or XP safety policy lost')
for token in ('P0357','P0356','P0355','P0354','P0353','P0352','P0351',
              'P0350','P0349','P0348','P0347','P0346','P0321','D-048',
              'UNVERIFIED','L-019','L-022','L-027','L-028','L-031','cfdc07af'):
    need(token in CUR and token in H,'CURRENT/HANDOFF continuity missing '+token)
for n in range(317,358):need(f'P{n:04d}' in H,'handoff milestone missing P%04d'%n)
for n in range(317,338):need(f'P{n:04d}' in CUR,'CURRENT milestone missing P%04d'%n)
need(len(CUR.encode('utf-8'))<9800 and len(H.encode('utf-8'))<=8000,
     'historical memory budget exceeded')
for path in ('docs/memory/investigations/ACTIVE.md',
             'docs/memory/roadmap/STATUS.md',
             'docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md',
             'docs/ROADMAP.md','docs/memory/patches/PATCH_INDEX.md'):
    need('P0357' in rd(path),'durable index/roadmap missing '+path)
for path in ('docs/memory/evidence/P0357_OBJECTIVE_PROGRESS_SEAM.md',
             'docs/memory/patches/P0357_OBJECTIVE_PROGRESS_SEAM.md'):
    source=rd(path)
    for token in ('P0357','P0356','P0321','228','UNVERIFIED','OPEN'):
        need(token in source,'durable evidence provenance missing '+path+': '+token)
    need(source.endswith('\n') and not source.endswith('\n\n') and '\r' not in source,
         'evidence file newline hygiene '+path)
need(all(x in H for x in ('P0354 R0','P0354 R1','P0354 R2',
                          'P0355 R0','P0355 R1','check_memory_health.py')),
     'historical refused candidates erased')
need(len(list((R/'tools').glob('check_*.py')))==228,
     'expected 228 static checkers')
print('P0357 F.6 objective progress diagnostic ownership: PASS (STATIC; WoW UNVERIFIED)')
