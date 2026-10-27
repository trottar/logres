#!/usr/bin/env python3
"""P0359: preserve D-026 read-only PlayerFrame diagnostic in owning module (STATIC)."""
from pathlib import Path
import re
R=Path(__file__).resolve().parents[1]
def read(p):return (R/p).read_text(encoding='utf-8')
def need(ok,msg):
    if not ok:raise AssertionError(msg)
def fn(source,signature):
    need(source.count(signature)==1,'missing or duplicated '+signature)
    i=source.index(signature);j=source.find('\nend\n',i)
    need(j>i,'unbounded '+signature)
    return source[i:j+5]
C=read('Logres/Core/Commands.lua')
P=read('Logres/Immersion/PlayerFrameReplacement.lua')
T=read('Logres/Logres.toc')
B=read('Logres/Core/Bootstrap.lua')
CUR=read('docs/memory/CURRENT.md')
HAND=read('docs/memory/handoffs/CURRENT_HANDOFF.md')
w=fn(C,'local function runPlayerFrameCheck()\n')
need(w=='local function runPlayerFrameCheck()\n'
       '    Logres:GetModule("PlayerFrameReplacement"):RunDevPlayerFrameCheck(emit, boolText)\nend\n',
     'Commands must retain original forwarding and emission helpers')
report=fn(P,'function PlayerFrameReplacement:RunDevPlayerFrameCheck(emit, boolText)\n')
for marker in (
    'Logres:GetModuleStatus("PlayerFrameReplacement")',
    'Logres:GetModule("PlayerFrameReplacement")',
    'replacement:GetDebugStatus()',
    'Logres:GetPreference("immersionEnabled") == true',
    'debugStatus.requestedEnabled == expected',
    'debugStatus.appliedEnabled == expected',
    'debugStatus.pending',
    'InCombatLockdown()',
    'debugStatus.playerFrameFound == true',
    'debugStatus.containerFound == true',
    'debugStatus.contentMainFound == true',
    'debugStatus.containerAlpha == 0',
    'debugStatus.contentMainAlpha == 0',
    'debugStatus.playerFrameMouseEnabled == false',
    'debugStatus.interactionReady == true',
    'debugStatus.interactionConfigured == true',
    'debugStatus.interactionMouseOwnedByLogres == true',
    'debugStatus.interactionUnit == "player"',
    'debugStatus.interactionLeftType == "target"',
    'debugStatus.interactionRightType == "togglemenu"',
    'debugStatus.snapshotReady == true',
    'debugStatus.stockPresentationSuppressed == false',
    'debugStatus.stockMouseSuppressed == false',
    'debugStatus.wholePlayerFrameSuppressedByLogres == false',
    'debugStatus.directPlayerChildrenSuppressedByLogres == false',
    'debugStatus.targetFrameSuppressedByLogres == false',
    'debugStatus.partyFramesSuppressedByLogres == false',
    'debugStatus.lastError == nil',
    'Logres playerframecheck: PASS (',
    'Logres playerframecheck: FAIL (',
    'boolText(expected)',
):need(marker in report,'original D-026 presentation/preservation status missing '+marker)
need(report.count('emit(string.format(')==2 and
     report.index('Logres playerframecheck: PASS (')<report.index('Logres playerframecheck: FAIL ('),
     'PASS/FAIL emission count/order changed')
need('Logres playerframecheck: PASS (' not in C and
     'Logres playerframecheck: FAIL (' not in C,
     'Commands still owns report output')
for banned in ('C_Timer.', 'SetAlpha(', 'SetPoint(', 'SetParent(',
               'SetAttribute(', 'RegisterEvent(', 'SetScript(',
               'RegisterStateDriver(', 'hooksecurefunc(',
               ':Show(', ':Hide(', 'UnitHealth(', 'UnitPower(',
               'issecretvalue(', 'SetBinding(', 'SaveBindings('):
    need(banned not in report,'diagnostic gained native/protected mutation '+banned)
need(P.index('function PlayerFrameReplacement:GetDebugStatus()')<
     P.index('function PlayerFrameReplacement:RunDevPlayerFrameCheck('),
     'debug getter must precede report')
for marker in ('    runPlayerFrameCheck()',
               'if command == "playerframecheck" then',
               '"Player Frame Check"',
               '"playerframecheck"',
               '"playerFrameCheck",'):
    need(marker in C,'Run All/slash/panel route lost '+marker)
need(C.index('    runQuietModeCheck()')<C.index('    runPlayerFrameCheck()')<
     C.index('    runTargetFrameCheck()'),
     'D.4 Run All ordering changed')
need('Immersion\\PlayerFrameReplacement.lua' in T and 'Core\\Commands.lua' in T and
     T.index('Immersion\\PlayerFrameReplacement.lua')<T.index('Core\\Commands.lua'),
     'module load order changed')
need(len([x for x in T.splitlines() if x.endswith('.lua')])==94,
     'Lua entry count changed')
need(len(re.findall(r'Logres:RegisterDevPanelAction\(\s*"',C))==120,
     'developer panel inventory changed')
tv=re.search(r'(?m)^## Version: (\S+)$',T)
bv=re.search(r'(?m)^Logres.VERSION = "([^"]+)"$',B)
need(bool(tv and bv and tv.group(1)==bv.group(1) and
          re.fullmatch(r'0\.0\.\d+-dev',tv.group(1))),
     'dynamic TOC/Bootstrap version parity missing')
legacy=read('tools/check_player_frame_replacement_contract.py')
for marker in ('PlayerFrame:Hide(', 'CompactPartyFrame:Hide(',
               '"SecureUnitButtonTemplate"',
               '"function PlayerFrameReplacement:RunDevPlayerFrameCheck(emit, boolText)"',
               'Logres:GetModule("PlayerFrameReplacement"):RunDevPlayerFrameCheck(emit, boolText)',
               'PlayerFrameReplacement must load before ImmersionController/Commands'):
    need(marker in legacy,'D-026 historical safety/route checker weakened '+marker)
prior=read('tools/check_p0358_quiet_diagnostic_seam_contract.py')
need("glob('check_*.py')))>=229" in prior and
     'SetChatWindowShown(' in read('tools/check_quiet_mode_contract.py'),
     'P0358 checker count floor or Quiet Mode safety lost')
for token in ('P0359','P0358','P0357','P0356','P0355','P0354','P0353',
              'P0352','P0351','P0350','P0349','P0348','P0347','P0346',
              'P0321','D-048','UNVERIFIED','L-019','L-022','L-027',
              'L-028','L-031','cfdc07af'):
    need(token in CUR and token in HAND,'CURRENT/HANDOFF continuity lost '+token)
for n in range(317,360):need(f'P{n:04d}' in HAND,'missing milestone P%04d'%n)
for n in range(317,338):need(f'P{n:04d}' in CUR,'CURRENT missing P%04d'%n)
need(len(CUR.encode('utf-8'))<9800 and len(HAND.encode('utf-8'))<=8000,
     'memory budget exceeded')
for path in ('docs/memory/investigations/ACTIVE.md','docs/memory/roadmap/STATUS.md',
             'docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md','docs/ROADMAP.md',
             'docs/memory/patches/PATCH_INDEX.md'):
    need('P0359' in read(path),'durable checkpoint missing '+path)
for path in ('docs/memory/evidence/P0359_PLAYER_FRAME_DIAGNOSTIC_SEAM.md',
             'docs/memory/patches/P0359_PLAYER_FRAME_DIAGNOSTIC_SEAM.md'):
    source=read(path)
    for marker in ('P0359','P0358','P0321','230','UNVERIFIED','OPEN'):
        need(marker in source,'evidence provenance missing '+path+': '+marker)
    need(source.endswith('\n') and not source.endswith('\n\n') and '\r' not in source,
         'new evidence newline hygiene '+path)
need(all(x in HAND for x in ('P0354 R0','P0354 R1','P0354 R2',
          'P0355 R0','P0355 R1','P0358 R0','check_memory_health.py')),
     'historical refused candidates erased')
need(len(list((R/'tools').glob('check_*.py')))>=230,
     'expected 230 static checkers')
print('P0359 PlayerFrame diagnostic seam: PASS (STATIC; WoW UNVERIFIED)')
