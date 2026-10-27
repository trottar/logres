#!/usr/bin/env python3
"""P0354: retain original HUD structural diagnostic and command routes (STATIC only)."""
from pathlib import Path
import re
R=Path(__file__).resolve().parents[1]
def read(path):return (R/path).read_text(encoding='utf-8')
C=read('Logres/Core/Commands.lua')
H=read('Logres/HUD/HUD.lua')
T=read('Logres/Logres.toc')
B=read('Logres/Core/Bootstrap.lua')
CUR=read('docs/memory/CURRENT.md')
HAND=read('docs/memory/handoffs/CURRENT_HANDOFF.md')
def need(ok,message):
    if not ok:raise AssertionError(message)
def extract(s,head):
    need(s.count(head)==1,'missing/duplicate '+head)
    start=s.index(head)
    end=s.index('\nend\n',start)+len('\nend\n')
    return s[start:end]
wrapper=extract(C,'local function runHUDCheck()\n')
need(wrapper=='local function runHUDCheck()\n'
     '    Logres:GetModule("HUD"):RunDevHUDCheck(emit, boolText)\nend\n',
     'Commands must retain exact HUD forwarding')
report=extract(H,'function HUD:RunDevHUDCheck(emit, boolText)\n')
need(report.count('emit(string.format(')==2,'PASS and FAIL emission count changed')
for marker in (
  'local status = Logres:GetModuleStatus("HUD")',
  'local hud = Logres:GetModule("HUD")',
  'local debugStatus = hud:GetDebugStatus()',
  'debugStatus.rootShown == debugStatus.immersionEnabled',
  'status.initialized == true',
  'status.enabled == true',
  'debugStatus.moduleEnabled == true',
  'debugStatus.bandCount == 5',
  'debugStatus.textureCount == 5',
  'debugStatus.curvesReady == true',
  'debugStatus.resourceTextReady == true',
  'debugStatus.resourceCurveReady == true',
  'debugStatus.targetFrameReady == true',
  'debugStatus.targetEventFrameReady == true',
  'debugStatus.playerCastCueReady == true',
  'debugStatus.targetCastCueReady == true',
  'debugStatus.allyRowCount == 5',
  'debugStatus.allyRosterEventFrameReady == true',
  'and visibilityMatchesPreference',
  'boolText(debugStatus.immersionEnabled)',
  'boolText(debugStatus.rootShown)',
  'tostring(visibilityMatchesPreference)',
):need(marker in report,'original HUD diagnostics missing '+marker)
for marker in (
  'Logres hudcheck: PASS (bands=5 textures=5 tunnel=true curves=true resourceText=true resourceCurve=true target=true casts=true allies=5 immersion=%s visible=%s)',
  'Logres hudcheck: FAIL (initialized=%s enabled=%s moduleEnabled=%s bands=%s textures=%s curves=%s resourceText=%s resourceCurve=%s targetFrame=%s targetName=%s targetHealth=%s targetEvents=%s playerCast=%s targetCast=%s playerCastEvents=%s targetCastEvents=%s allyRows=%s allyEvents=%s allyRoster=%s immersion=%s visible=%s visibilityMatches=%s)',
):need(report.count(marker)==1 and marker not in C,'HUD report must have one owner '+marker)
need(H.index('function HUD:GetDebugStatus()')<H.index('function HUD:RunDevHUDCheck('),
     'HUD debug status owner must precede check')
for banned in ('C_Timer.', 'RegisterEvent(', 'SetScript(', 'UnitHealth(', 'UnitHealthPercent(',
               'UnitPower(', 'UnitPowerPercent(', 'GetAttribute(', 'SetAttribute(',
               'SetParent(', 'SetPoint(', ':Show(', ':Hide(', 'hooksecurefunc('):
    need(banned not in report,'new unsafe HUD diagnostic operation '+banned)
for marker in ('local function runHUDCheck()', '    runHUDCheck()',
               'if command == "hudcheck" then','"hudcheck"','"hud",'):
    need(marker in C,'HUD command, Run All, panel lost '+marker)
need(C.index('    runLifecycleCheck()')<C.index('    runHUDCheck()')<C.index('    runActionCheck()'),
     'original Run All order changed')
need('HUD\\HUD.lua' in T and 'Core\\Commands.lua' in T and
     T.index('HUD\\HUD.lua')<T.index('Core\\Commands.lua'),
     'HUD loaded after Commands')
need(len([x for x in T.splitlines() if x.endswith('.lua')])==94,
     'Lua load inventory changed')
need(len(re.findall(r'Logres:RegisterDevPanelAction\(\s*"',C))==120,
     'panel action count changed')
toc_version = re.search(r'(?m)^## Version: (\S+)$', T)
bootstrap_version = re.search(r'(?m)^Logres.VERSION = "([^"]+)"$', B)
need(toc_version is not None and bootstrap_version is not None and
     toc_version.group(1) == bootstrap_version.group(1) and
     re.fullmatch(r'0\.0\.\d+-dev', toc_version.group(1)) is not None,
     'TOC / Bootstrap development version parity')
legacy=read('tools/check_hud_contract.py')
need('"/logres hudcheck"' in legacy and
     'UnitHealth("player"' in legacy and
     'resourceText:GetText' in legacy,
     'original secret-safe HUD checker weakened')
prior=read('tools/check_p0352_lifecycle_seam_contract.py')
need("C.index('    runHUDCheck()')" in prior,
     'historical Run All lifecycle ordering checker removed')
for marker in ('P0354','P0353','P0352','P0351','P0350','P0349','P0348',
               'P0347','P0346','P0321','D-048','UNVERIFIED','L-019','L-022',
               'L-027','L-028','L-031','cfdc07af'):
    need(marker in CUR and marker in HAND,'memory continuity lost '+marker)
for n in range(317,354):
    need(f'P{n:04d}' in HAND,'historical handoff missing P%04d'%n)
for n in range(317,338):
    need(f'P{n:04d}' in CUR,'historical CURRENT missing P%04d'%n)
need(len(CUR.encode('utf-8'))<9800,'CURRENT maintenance budget exceeded')
need(len(HAND.encode('utf-8'))<=8000,'active handoff must stay below 8 KB soft budget')
archive=read('docs/memory/handoffs/P0353_FULL_HANDOFF_ARCHIVE.md')
need(archive.startswith('# P0353 —') and 'P0353 R0' in archive and
     'cfdc07af' in archive, 'historical handoff must be archived before compaction')
need('P0354 R2' in HAND and 'check_memory_health.py' in HAND and
     'P0354 R1' in HAND and 'P0354 R0' in HAND,
     'all P0354 PREWRITE failures must remain in current handoff')
for p in ('docs/ROADMAP.md','docs/memory/investigations/ACTIVE.md',
          'docs/memory/roadmap/STATUS.md',
          'docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md',
          'docs/memory/patches/PATCH_INDEX.md'):
    need('P0354' in read(p),'historical log missing P0354 '+p)
for p in ('docs/memory/evidence/P0354_HUD_DIAGNOSTIC_SEAM.md',
          'docs/memory/patches/P0354_HUD_DIAGNOSTIC_SEAM.md'):
    s=read(p)
    for marker in ('P0354','P0353','P0321','225','UNVERIFIED','OPEN'):
        need(marker in s,'evidence marker missing '+p+' '+marker)
    need(s.endswith('\n') and not s.endswith('\n\n') and '\r' not in s,
         'record newline hygiene '+p)
need('P0353 R0' in read('docs/memory/evidence/P0353_LAYOUT_SEAM.md'),
     'P0353 negative results lost')
need('P0354 R0 PREWRITE guard refusal' in read('docs/memory/evidence/P0354_HUD_DIAGNOSTIC_SEAM.md') and
     '38dc4f574b8fd40a929dd287b3ec2798732cf4b4' in read('docs/memory/evidence/P0354_HUD_DIAGNOSTIC_SEAM.md') and
     'P0354 R0 refusal' in read('docs/memory/patches/P0354_HUD_DIAGNOSTIC_SEAM.md'),
     'P0354 R0 refusal must remain explicit durable evidence')
need(len(list((R/'tools').glob('check_*.py'))) >= 225, 'P0354 historical checker floor lost')
print('P0354 HUD diagnostic seam: PASS (STATIC; WoW UNVERIFIED)')
