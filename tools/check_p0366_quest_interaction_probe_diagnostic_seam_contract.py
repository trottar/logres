#!/usr/bin/env python3
"""P0366 P0129 manual QuestInteractionProbe diagnostic ownership, static only."""
from pathlib import Path
import re

ROOT=Path(__file__).resolve().parents[1]

def read(path):
    return (ROOT / path).read_text(encoding='utf-8')

def need(ok,message):
    if not ok:
        raise AssertionError(message)

def fn(src,signature):
    need(src.count(signature)==1,'missing/duplicate function '+signature)
    i=src.index(signature)
    j=src.find('\nend\n',i)
    need(j>i,'unterminated function '+signature)
    return src[i:j+5]

C=read('Logres/Core/Commands.lua')
P=read('Logres/Quest/InteractionProbe.lua')
T=read('Logres/Logres.toc')
B=read('Logres/Core/Bootstrap.lua')
CUR=read('docs/memory/CURRENT.md')
HAND=read('docs/memory/handoffs/CURRENT_HANDOFF.md')
wrap=fn(C,'local function runQuestInteractionProbe()\n')
need(wrap==('local function runQuestInteractionProbe()\n'
            '    Logres:GetModule("QuestInteractionProbe"):RunDevQuestInteractionProbe(emit)\n'
            'end\n'), 'Commands must retain only exact manual forwarding wrapper')
report=fn(P,'function Probe:RunDevQuestInteractionProbe(emit)\n')
for token in (
    'Logres:GetModuleStatus("QuestInteractionProbe")',
    'Logres:GetModule("QuestInteractionProbe")',
    'probe:CaptureManual()', 'probe:GetDebugStatus()',
    'captureOK == true',
    'status.initialized == true', 'status.enabled == true',
    'debugStatus.moduleEnabled == true',
    'debugStatus.eventFrameReady == true',
    'debugStatus.gossipShowRegistered == true',
    'debugStatus.gossipClosedRegistered == true',
    'debugStatus.questDetailRegistered == true',
    'debugStatus.questProgressRegistered == true',
    'debugStatus.questCompleteRegistered == true',
    'debugStatus.questFinishedRegistered == true',
    'debugStatus.mutationCallCount == 0',
    '"Logres questinteractionprobe: %s (capture=%s',
    'passed and "PASS" or "FAIL"',
    'tostring(captureOK)', 'tostring(captureState)',
    'tostring(debugStatus.mutationCallCount)',
    'local lines = probe:GetDiagnosticLines()',
    'for index = 1, #lines do',
    '"Logres questinteractionprobe: "',
    '.. tostring(lines[index])',
):
    need(token in report,'original P0129 report invariant absent '+token)
need(report.count('probe:CaptureManual()')==1 and
     report.count('probe:GetDiagnosticLines()')==1 and
     report.count('emit(string.format(')==1 and
     report.count('emit(')==2,
     'manual capture/summary/detail emission count changed')
# P0364/P0365 R0 demonstrated why generic local statements cannot be
# forbidden throughout Commands: other diagnostics legitimately share them.
need('"Logres questinteractionprobe: %s (capture=%s' not in C,
     'unique QuestInteractionProbe status report duplicated in Commands')
need('local lines = probe:GetDiagnosticLines()' not in wrap,
     'QuestInteractionProbe wrapper must not collect contextual details')
need(P.count('Logres:RegisterModule("QuestInteractionProbe"')==1 and
     P.index('function Probe:GetDiagnosticLines()')<
     P.index('function Probe:RunDevQuestInteractionProbe(emit)'),
     'report must follow preloaded original probe methods')
for forbidden in (
    'C_Timer.','SetScript(', 'RegisterEvent(', 'RegisterUnitEvent(',
    'SetAlpha(', 'SetParent(', 'SetAttribute(', 'hooksecurefunc(',
    'AcceptQuest(', 'DeclineQuest(', 'CompleteQuest(',
    'GetQuestReward(', 'C_GossipInfo.Select', 'HideUIPanel(',
    'SetPreference(', 'issecretvalue(', 'UnitAura(', 'UnitHealth(',
    'RegisterStateDriver(', ':Hide(', ':Show(',
):
    need(forbidden not in report,
         'unexpected native/protected/secret operation in report '+forbidden)
for token in (
    'if command == "questinteractionprobe" then',
    '        runQuestInteractionProbe()',
    'emit("  /logres questinteractionprobe")',
    '"questInteractionProbe",',
    '"Quest Interaction Probe",',
    '"questinteractionprobe",',
):
    need(token in C,'existing manual slash or panel route changed '+token)
run_all=fn(C,'local function runAllChecks()\n')
need('runQuestInteractionProbe()' not in run_all,
     'contextual quest interaction probe must remain excluded from checkall')
need(C.count('        runQuestInteractionProbe()')==1,
     'existing manual-only dispatch duplicated or removed')
need('Quest\\InteractionProbe.lua' in T and 'Core\\Commands.lua' in T and
     T.index('Quest\\InteractionProbe.lua')<T.index('Core\\Commands.lua'),
     'QuestInteractionProbe no longer loads before Commands')
need(len([x for x in T.splitlines() if x.endswith('.lua')])==94,
     'Lua load inventory changed')
need(len(re.findall(r'Logres:RegisterDevPanelAction\(\s*"',C))==120,
     'developer-panel action count changed')
tv=re.search(r'(?m)^## Version: (\S+)$',T)
bv=re.search(r'(?m)^Logres.VERSION = "([^"]+)"$',B)
# The baseline/target are guarded by the one-time applier. A durable static
# checker must validate parity and version format, not pin one dev version.
need(bool(tv and bv and tv.group(1)==bv.group(1) and
          re.fullmatch(r'0\.0\.\d+-dev', tv.group(1))),
     'TOC/Bootstrap dynamic version parity invalid')
legacy=read('tools/check_quest_interaction_probe_contract.py')
for token in (
    'scalarRecord must secret-check before nil comparison/type inspection',
    'captureRows must secret-check',
    'InteractionProbe.lua contains forbidden mutation/',
    'C_GossipInfo.SelectAvailableQuest(',
    'C_GossipInfo.SelectOption(',
    '"runQuestInteractionProbe()"',
    'function Probe:RunDevQuestInteractionProbe(emit)',
    'Logres:GetModule("QuestInteractionProbe"):RunDevQuestInteractionProbe(emit)',
    '"Logres questinteractionprobe: %s',
):
    need(token in legacy,'P0129 historical safety or report assertion weakened '+token)
prior=read('tools/check_p0365_aura_status_probe_diagnostic_seam_contract.py')
need("glob('check_*.py'))) >= 236" in prior and
     'local lines = probe:GetDiagnosticLines()' in prior and
     'P0365 R0 PREWRITE STATIC 202/236 REFUSED' in prior,
     'P0365 historical corrected checker or negative evidence missing')
for token in ('P0366','P0365','P0364','P0363','P0362','P0361','P0360',
              'P0359','P0358','P0357','P0356','P0355','P0354','P0353',
              'P0352','P0351','P0350','P0349','P0348','P0347','P0346',
              'P0321','D-048','UNVERIFIED','L-019','L-022','L-027',
              'L-028','L-031','cfdc07af'):
    need(token in CUR and token in HAND,'CURRENT/HANDOFF milestone lost '+token)
for n in range(317,367):
    need(f'P{n:04d}' in HAND, f'handoff historical milestone P{n:04d} lost')
for n in range(317,338):
    need(f'P{n:04d}' in CUR, f'CURRENT historical milestone P{n:04d} lost')
need(len(CUR.encode('utf-8'))<9800 and len(HAND.encode('utf-8'))<=8000,
     'CURRENT/HANDOFF memory size budget exceeded')
for path in ('docs/memory/investigations/ACTIVE.md',
             'docs/memory/roadmap/STATUS.md',
             'docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md',
             'docs/ROADMAP.md','docs/memory/patches/PATCH_INDEX.md'):
    note=read(path)
    need('P0366' in note and 'P0365' in note,
         'P0366 durable roadmap/index history not recorded '+path)
for path in ('docs/memory/evidence/P0366_QUEST_INTERACTION_PROBE_DIAGNOSTIC_SEAM.md',
             'docs/memory/patches/P0366_QUEST_INTERACTION_PROBE_DIAGNOSTIC_SEAM.md'):
    s=read(path)
    for token in ('P0366','P0365','P0321','237','UNVERIFIED','OPEN'):
        need(token in s,'P0366 evidence marker missing '+token+' '+path)
    need('P0366 R0 PREWRITE STATIC 27/237 REFUSED' in s,
         'P0366 R0 version-pin checker refusal evidence missing '+path)
    need(s.endswith('\n') and not s.endswith('\n\n') and '\r' not in s,
         'P0366 evidence LF hygiene '+path)
for path,label in (
    ('docs/memory/evidence/P0365_AURA_STATUS_PROBE_DIAGNOSTIC_SEAM.md',
     'P0365 R0 PREWRITE STATIC 202/236 REFUSED'),
    ('docs/memory/evidence/P0364_PLAYER_HELPFUL_AURA_DIAGNOSTIC_SEAM.md',
     'P0364 R0 PREWRITE STATIC 201/235 REFUSED'),
):
    need(label in read(path),'historical static-checker failure erased '+path)
for marker in ('P0354 R0','P0354 R1','P0354 R2',
               'P0355 R0','P0355 R1','P0358 R0',
               'P0361 R0 handoff','check_memory_health.py'):
    need(marker in HAND,'historical refusal continuity lost '+marker)
need(len(list((ROOT/'tools').glob('check_*.py'))) == 237,
     'expected exactly 237 static checkers')
print('P0366 quest interaction manual diagnostic ownership: PASS (STATIC; WoW UNVERIFIED)')
