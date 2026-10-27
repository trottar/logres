#!/usr/bin/env python3
"""P0367 WorldTargetProbe diagnostic ownership; static-only source contract."""
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]

def read(path):
    return (ROOT / path).read_text(encoding='utf-8')

def need(condition, message):
    if not condition:
        raise AssertionError(message)

def fn(source, signature):
    need(source.count(signature) == 1, 'expected exactly one function '+signature)
    start = source.index(signature)
    end = source.find('\nend\n', start)
    need(end > start, 'missing terminal end for '+signature)
    return source[start:end+5]

C=read('Logres/Core/Commands.lua')
P=read('Logres/HUD/WorldTargetProbe.lua')
T=read('Logres/Logres.toc')
B=read('Logres/Core/Bootstrap.lua')
CUR=read('docs/memory/CURRENT.md')
HAND=read('docs/memory/handoffs/CURRENT_HANDOFF.md')
wrap=fn(C,'local function runWorldTargetProbe()\n')
need(wrap == ('local function runWorldTargetProbe()\n'
              '    Logres:GetModule("WorldTargetProbe"):RunDevWorldTargetProbe(emit)\n'
              'end\n'), 'Commands must be exact WorldTargetProbe forwarding wrapper')
report=fn(P,'function Probe:RunDevWorldTargetProbe(emit)\n')
for token in (
    'Logres:GetModuleStatus("WorldTargetProbe")',
    'Logres:GetModule("WorldTargetProbe")',
    'probe:CaptureManual()', 'probe:GetDebugStatus()',
    'captureOK', 'status.initialized == true', 'status.enabled == true',
    'debugStatus.moduleEnabled == true',
    'debugStatus.eventFrameReady == true', 'debugStatus.proxyReady == true',
    'debugStatus.secretCheckerAvailable == true',
    'debugStatus.nameplateAPIAvailable == true',
    'debugStatus.behindCameraAPIAvailable == true',
    'debugStatus.reactionAPIAvailable == true',
    'debugStatus.canAttackAPIAvailable == true',
    'debugStatus.isFriendAPIAvailable == true',
    'debugStatus.isTrivialAPIAvailable == true',
    'debugStatus.combatLockdownAPIAvailable == true',
    'debugStatus.targetChangedRegistered == true',
    'debugStatus.nameplateAddedRegistered == true',
    'debugStatus.nameplateRemovedRegistered == true',
    'debugStatus.behindCameraChangedRegistered == true',
    'debugStatus.enteringWorldRegistered == true',
    'debugStatus.failureCount == 0',
    '"Logres worldtargetprobe: %s (capture=%s',
    'passed and "PASS" or "FAIL"',
    'tostring(debugStatus.attachmentState)',
    'tostring(debugStatus.fallback)',
    'tostring(debugStatus.secretSkipCount)',
    'local lines = probe:GetDiagnosticLines()',
    'for index = 1, #lines do',
    '"Logres worldtargetprobe: "',
    '.. tostring(lines[index])',
):
    need(token in report,'original WorldTargetProbe report token absent '+token)
need(report.count('probe:CaptureManual()')==1 and
     report.count('probe:GetDiagnosticLines()')==1 and
     report.count('emit(string.format(')==1 and report.count('emit(')==2,
     'manual capture or report emissions changed')
# Only search for the UNIQUE report marker globally; other diagnostics share
# generic local names (P0364/P0365 PREWRITE failures).
need('"Logres worldtargetprobe: %s (capture=%s' not in C,
     'original world-target PASS/FAIL formatting still in Commands')
need('local lines = probe:GetDiagnosticLines()' not in wrap,
     'forwarding wrapper must not collect diagnostic detail')
need(P.count('Logres:RegisterModule("WorldTargetProbe"')==1 and
     P.index('function Probe:GetDiagnosticLines()') <
     P.index('function Probe:RunDevWorldTargetProbe(emit)'),
     'report module ownership or method ordering changed')
for forbidden in (
    'C_Timer.', 'RegisterEvent(', 'RegisterUnitEvent(',
    'SetScript(', 'SetAlpha(', 'SetParent(', 'SetAttribute(',
    'SetPoint(', 'ClearAllPoints(', 'hooksecurefunc(',
    'TargetFrame:Hide', 'NamePlateDriverFrame',
    'GetNamePlateForUnit(', 'IsNamePlateUnitBehindCamera(',
    'UnitReaction(', 'UnitCanAttack(', 'UnitIsFriend(',
    'UnitIsTrivial(', 'InCombatLockdown(',
    'issecretvalue(', 'UnitHealth(', 'UnitLevel(',
    'RegisterStateDriver(', ':Hide(', ':Show(',
):
    need(forbidden not in report,
         'report gained forbidden protected/native/secret operation '+forbidden)
for token in (
    'if command == "worldtargetprobe" then',
    '        runWorldTargetProbe()',
    'emit("  /logres worldtargetprobe")',
    '"worldTargetProbe",', '"World Target Probe",',
    '"worldtargetprobe",',
):
    need(token in C,'world target manual slash/panel route missing '+token)
run_all=fn(C,'local function runAllChecks()\n')
need('runWorldTargetProbe()' not in run_all,
     'contextual world-target probe must stay excluded from Run All')
need(C.count('        runWorldTargetProbe()')==1,
     'manual-only WorldTargetProbe invocation duplicated/removed')
need('HUD\\WorldTargetProbe.lua' in T and 'Core\\Commands.lua' in T and
     T.index('HUD\\WorldTargetProbe.lua') < T.index('Core\\Commands.lua'),
     'WorldTargetProbe not preloaded before Commands')
need(len([x for x in T.splitlines() if x.endswith('.lua')])==94,
     'addon load entry inventory changed')
need(len(re.findall(r'Logres:RegisterDevPanelAction\(\s*"',C))==120,
     'developer-panel action registration inventory changed')
tv=re.search(r'(?m)^## Version: (\S+)$',T)
bv=re.search(r'(?m)^Logres.VERSION = "([^"]+)"$',B)
need(bool(tv and bv and tv.group(1)==bv.group(1) and
          re.fullmatch(r'0\.0\.\d+-dev',tv.group(1))),
     'dynamic TOC/Bootstrap version parity invalid')
legacy=read('tools/check_world_target_probe_contract.py')
for token in (
    'callOrdinary must secret-check returned values before nil inspection',
    'readNameplate must query target with includeForbidden=false',
    'readNameplate must never request includeForbidden=true',
    'attachment test must check combat first and immediately detach',
    'probe must not call methods on the returned Blizzard nameplate frame',
    'WorldTargetProbe.lua contains forbidden inspection/mutation/',
    'function Probe:RunDevWorldTargetProbe(emit)',
    'Logres:GetModule("WorldTargetProbe"):RunDevWorldTargetProbe(emit)',
    '"Logres worldtargetprobe: %s',
):
    need(token in legacy,'P0140 historical safety/report check removed '+token)
previous=read('tools/check_p0366_quest_interaction_probe_diagnostic_seam_contract.py')
need("glob('check_*.py'))) >= 237" in previous and
     'P0366 R0 PREWRITE STATIC 27/237 REFUSED' in previous and
     'RunDevQuestInteractionProbe(emit)' in previous,
     'P0366 prior checker seam or failure evidence weakened')
for token in ('P0367','P0366','P0365','P0364','P0363','P0362','P0361',
              'P0360','P0359','P0358','P0357','P0356','P0355','P0354',
              'P0353','P0352','P0351','P0350','P0349','P0348','P0347',
              'P0346','P0321','D-048','UNVERIFIED','L-019','L-022',
              'L-027','L-028','L-031','cfdc07af'):
    need(token in CUR and token in HAND,'CURRENT/HANDOFF continuity missing '+token)
for n in range(317,368):
    need(f'P{n:04d}' in HAND,'historical handoff milestone absent '+str(n))
for n in range(317,338):
    need(f'P{n:04d}' in CUR,'CURRENT historical milestone absent '+str(n))
need(len(CUR.encode('utf-8'))<9800 and len(HAND.encode('utf-8'))<=8000,
     'CURRENT/HANDOFF size budget exceeded')
for path in ('docs/memory/investigations/ACTIVE.md',
             'docs/memory/roadmap/STATUS.md',
             'docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md',
             'docs/ROADMAP.md','docs/memory/patches/PATCH_INDEX.md'):
    note=read(path)
    need('P0367' in note and 'P0366' in note,
         'durable P0367 roadmap/index checkpoint missing '+path)
for path in ('docs/memory/evidence/P0367_WORLD_TARGET_PROBE_DIAGNOSTIC_SEAM.md',
             'docs/memory/patches/P0367_WORLD_TARGET_PROBE_DIAGNOSTIC_SEAM.md'):
    note=read(path)
    for token in ('P0367','P0366','P0321','238','UNVERIFIED','OPEN'):
        need(token in note,'P0367 canonical evidence missing '+token+' '+path)
    need(note.endswith('\n') and not note.endswith('\n\n') and '\r' not in note,
         'P0367 evidence newline hygiene '+path)
for path,label in (
    ('docs/memory/evidence/P0366_QUEST_INTERACTION_PROBE_DIAGNOSTIC_SEAM.md',
     'P0366 R0 PREWRITE STATIC 27/237 REFUSED'),
    ('docs/memory/evidence/P0365_AURA_STATUS_PROBE_DIAGNOSTIC_SEAM.md',
     'P0365 R0 PREWRITE STATIC 202/236 REFUSED'),
    ('docs/memory/evidence/P0364_PLAYER_HELPFUL_AURA_DIAGNOSTIC_SEAM.md',
     'P0364 R0 PREWRITE STATIC 201/235 REFUSED'),
):
    need(label in read(path),'prior PREWRITE refusal evidence erased '+path)
for token in ('P0354 R0','P0354 R1','P0354 R2','P0355 R0',
              'P0355 R1','P0358 R0','P0361 R0 handoff',
              'check_memory_health.py'):
    need(token in HAND,'historical refusal memory erased '+token)
need(len(list((ROOT/'tools').glob('check_*.py')))==238,
     'expected exactly 238 static checkers')
print('P0367 WorldTargetProbe diagnostic owner: PASS (STATIC; WoW UNVERIFIED)')
