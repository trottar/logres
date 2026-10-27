#!/usr/bin/env python3
"""P0355: preserve P0173 primary stock ownership diagnostic and route (STATIC)."""
from pathlib import Path
import re

R = Path(__file__).resolve().parents[1]
def read(p):
    return (R/p).read_text(encoding='utf-8')
def need(ok,msg):
    if not ok:
        raise AssertionError(msg)
def function(s,signature):
    need(s.count(signature)==1,'missing/duplicate diagnostic: '+signature)
    i=s.index(signature)
    j=s.index('\nend\n',i)+len('\nend\n')
    return s[i:j]

C=read('Logres/Core/Commands.lua')
P=read('Logres/Actions/Primary.lua')
B=read('Logres/Core/Bootstrap.lua')
T=read('Logres/Logres.toc')
CUR=read('docs/memory/CURRENT.md')
HAND=read('docs/memory/handoffs/CURRENT_HANDOFF.md')
wrapper=function(C,'local function runPrimaryOwnershipCheck()\n')
need(wrapper=='local function runPrimaryOwnershipCheck()\n'
             '    Logres:GetModule("PrimaryActions"):RunDevPrimaryOwnershipCheck(emit)\nend\n',
     'Commands wrapper changed or original emitter not forwarded')
report=function(P,'function Primary:RunDevPrimaryOwnershipCheck(emit)\n')
need('local Primary = Logres:RegisterModule("PrimaryActions", {' in P and
     'function Primary:GetStockOwnershipGate()' in P and
     P.index('function Primary:GetStockOwnershipGate()')<P.index('function Primary:RunDevPrimaryOwnershipCheck(emit)'),
     'P0173 read-only gate must precede its diagnostic in owner')
for required in (
    'local moduleStatus = Logres:GetModuleStatus("PrimaryActions")',
    'local primary = Logres:GetModule("PrimaryActions")',
    'local result = primary:GetStockOwnershipGate()',
    'moduleStatus.initialized == true',
    'moduleStatus.enabled == true',
    'result.sourcePresent',
    'result.stockButtons == 12',
    'result.flagsUnresolved == 0',
    'local classification = measured and "PASS" or "DEFERRED"',
    'result.flagsTotal - result.flagsUnresolved',
    'tostring(result.candidateNormal), tostring(result.status)',
    '"Logres primaryownership modes: " .. result.flagDetails',
):
    need(required in report,'P0173 report meaning changed: '+required)
for message in (
    'Logres primaryownershipcheck: %s (normal=%s special=%s stock=%s buttons=%s flags=%s/%s route=%s paging=%s candidate=%s suppressAuthorized=false stockPreserved=true reason=%s)',
    'Logres primaryownership modes: ',
):
    need(report.count(message)==1 and message not in C,
         'P0173 output must be owned once by Primary: '+message)
need(report.count('emit(string.format(')==1 and
     report.count('emit("Logres primaryownership modes: ') == 1,
     'original two-line report emissions missing')
need(report.index('emit(string.format(') < report.index('emit("Logres primaryownership modes: '),
     'original report line order changed')
for bad in ('C_Timer.', 'OnUpdate', 'SetScript(', 'RegisterEvent(',
            'RegisterStateDriver(', 'SetOverrideBinding', 'SetBinding(',
            'SetAttribute(', 'SetParent(', 'SetPoint(', ':Hide(', ':Show(',
            'GetAttribute(', 'issecretvalue(', 'UnitHealth('):
    need(bad not in report,'unsafe or unrelated behavior introduced into diagnostic: '+bad)
for marker in ('    runPrimaryOwnershipCheck()',
               'if command == "primaryownershipcheck" then',
               '"primaryOwnershipCheck",',
               '"primaryownershipcheck",'):
    need(marker in C,'slash, Run All or developer panel route lost: '+marker)
need(C.index('    runActionCheck()')<C.index('    runPrimaryOwnershipCheck()')<
     C.index('    runStockReplacementCheck()'),
     'Run All primary ownership report ordering changed')
need('Actions\\Primary.lua' in T and 'Core\\Commands.lua' in T and
     T.index('Actions\\Primary.lua')<T.index('Core\\Commands.lua'),
     'Primary must be loaded before Commands')
need(len([x for x in T.splitlines() if x.endswith('.lua')])==94,
     'original 94 Lua entries changed')
need(len(re.findall(r'Logres:RegisterDevPanelAction\(\s*"',C))==120,
     'original 120 developer actions changed')
versionT=re.search(r'(?m)^## Version: (\S+)$',T)
versionB=re.search(r'(?m)^Logres.VERSION = "([^"]+)"$',B)
need(versionT is not None and versionB is not None and
     versionT.group(1)==versionB.group(1) and
     re.fullmatch(r'0\.0\.\d+-dev',versionT.group(1)) is not None,
     'dynamic TOC/Bootstrap development-version parity')
legacy=read('tools/check_primary_ownership_contract.py')
for token in ('MainActionBar:Hide(', 'stockSuppressionAuthorized = false',
              'function Primary:RunDevPrimaryOwnershipCheck(emit)',
              'primary:GetStockOwnershipGate()',
              'Logres:GetModule("PrimaryActions"):RunDevPrimaryOwnershipCheck(emit)',
              'if command == "primaryownershipcheck" then',
              'controller must retain primary ownership gate'):
    need(token in legacy,'P0173 safety or migrated report contract removed: '+token)
need('Logres:GetModule("PrimaryActions"):RunDevPrimaryOwnershipCheck(emit)' in C and
     'suppressAuthorized=false stockPreserved=true' not in C,
     'duplicate P0173 output or missing forwarding')
for p in ('docs/ROADMAP.md', 'docs/memory/investigations/ACTIVE.md',
          'docs/memory/roadmap/STATUS.md',
          'docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md',
          'docs/memory/patches/PATCH_INDEX.md'):
    need('P0355' in read(p),'roadmap/index P0355 checkpoint absent: '+p)
for marker in ('P0355','P0354','P0353','P0352','P0351','P0350','P0349',
               'P0348','P0347','P0346','P0321','D-048','UNVERIFIED',
               'L-019','L-022','L-027','L-028','L-031','cfdc07af'):
    need(marker in CUR and marker in HAND,'historical memory continuity: '+marker)
for marker in ('P0354 R0', 'P0354 R1', 'P0354 R2', 'P0355 R0'):
    need(marker in HAND, 'handoff refused-candidate evidence lost: '+marker)
for n in range(317,356):
    need(f'P{n:04d}' in HAND,'historical handoff milestone lost: '+str(n))
for n in range(317,338):
    need(f'P{n:04d}' in CUR,'historical CURRENT milestone lost: '+str(n))
need(len(CUR.encode('utf-8'))<9800 and len(HAND.encode('utf-8'))<=8000,
     'historical memory size policy exceeded')
for p in ('docs/memory/evidence/P0355_PRIMARY_OWNERSHIP_SEAM.md',
          'docs/memory/patches/P0355_PRIMARY_OWNERSHIP_SEAM.md'):
    s=read(p)
    for marker in ('P0355','P0354','P0321','226','UNVERIFIED','OPEN'):
        need(marker in s,'new durable source evidence marker missing: '+marker)
    need(s.endswith('\n') and not s.endswith('\n\n') and '\r' not in s,
         'record newline hygiene '+p)
need('P0355 R0' in read('docs/memory/evidence/P0355_PRIMARY_OWNERSHIP_SEAM.md') and
     'P0355 R0' in read('docs/memory/patches/P0355_PRIMARY_OWNERSHIP_SEAM.md'),
     'P0355 R0 PREWRITE preflight refusal not preserved in durable evidence')
need('P0354 R2' in read('docs/memory/evidence/P0354_HUD_DIAGNOSTIC_SEAM.md') and
     'P0353 R0' in read('docs/memory/evidence/P0353_LAYOUT_SEAM.md') and
     read('docs/memory/handoffs/P0353_FULL_HANDOFF_ARCHIVE.md').startswith('# P0353'),
     'negative results/archive erased')
need(len(list((R/'tools').glob('check_*.py')))==226,
     'expected 226 static contracts')
print('P0355 primary ownership diagnostic seam: PASS (STATIC; WoW UNVERIFIED)')
