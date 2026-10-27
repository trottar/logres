#!/usr/bin/env python3
"""P0356: command-invoked F.3 XP diagnostic is owned by QuestXP (STATIC ONLY)."""
from pathlib import Path
import re
R=Path(__file__).resolve().parents[1]
def read(p):return (R/p).read_text(encoding='utf-8')
def need(x,msg):
    if not x:raise AssertionError(msg)
def fn(source,signature):
    need(source.count(signature)==1,'missing/nonunique '+signature)
    a=source.index(signature);b=source.find('\nend\n',a)
    need(b>a,'unbounded function '+signature)
    return source[a:b+5]
C=read('Logres/Core/Commands.lua'); XP=read('Logres/Quest/XP.lua')
T=read('Logres/Logres.toc');B=read('Logres/Core/Bootstrap.lua')
CUR=read('docs/memory/CURRENT.md'); H=read('docs/memory/handoffs/CURRENT_HANDOFF.md')
wrapper=fn(C,'local function runXPCheck()\n')
need(wrapper=='local function runXPCheck()\n'
             '    Logres:GetModule("QuestXP"):RunDevXPCheck(emit)\nend\n',
     'original XP command wrapper must preserve emit')
report=fn(XP,'function XP:RunDevXPCheck(emit)\n')
for token in ('local status = Logres:GetModuleStatus("QuestXP")',
              'local xp = Logres:GetModule("QuestXP")',
              'local debugStatus = xp:GetDebugStatus()',
              'debugStatus.baselineAvailable',
              'type(debugStatus.lastCurrentXP) == "number"',
              'type(debugStatus.lastMaxXP) == "number"',
              'debugStatus.lastCurrentXP >= 0',
              'debugStatus.lastMaxXP > 0',
              'debugStatus.immersionEnabled',
              'debugStatus.pulseShown == false',
              'debugStatus.lastSampleSecret',
              'debugStatus.lastProgressPercent',
              'debugStatus.lastError == nil',
              '"Logres xpcheck: "',
              '(passed and "PASS" or "FAIL")'):
    need(token in report,'F.3 report structural semantics lost '+token)
need(report.count('emit(')==1,'XP report must emit one status result')
need('Logres xpcheck: ' not in C,'Commands must not retain duplicate XP report')
for forbidden in ('UnitXP(', 'UnitXPMax(', 'GetXPExhaustion(',
                  'SetPoint(', 'SetParent(', 'SetAttribute(',
                  'RegisterEvent(', 'hooksecurefunc(',
                  'C_Timer.', ':Show(', ':Hide('):
    need(forbidden not in report,'XP report gained protected/native/live sampling '+forbidden)
need(XP.index('function XP:GetDebugStatus()')<XP.index('function XP:RunDevXPCheck(emit)'),
     'XP status getter must precede read-only report')
for route in ('    runXPCheck()', 'if command == "xpcheck" then',
              '"xpcheck"', '"xpCheck",', '"XP Check"'):
    need(route in C,'Run All/slash/panel route lost '+route)
need('Quest\\XP.lua' in T and 'Core\\Commands.lua' in T and
     T.index('Quest\\XP.lua')<T.index('Core\\Commands.lua'),
     'XP module must load before Commands')
need(len([x for x in T.splitlines() if x.endswith('.lua')])==94,
     'original Lua load inventory changed')
need(len(re.findall(r'Logres:RegisterDevPanelAction\(\s*"',C))==120,
     '120 developer panel registrations changed')
match=re.search(r'(?m)^## Version: (\S+)$',T)
bootstrap=re.search(r'(?m)^Logres.VERSION = "([^"]+)"$',B)
need(bool(match and bootstrap and match.group(1)==bootstrap.group(1) and
          re.fullmatch(r'0\.0\.\d+-dev',match.group(1))),
     'TOC and Bootstrap dynamic development version parity')
legacy=read('tools/check_xp_pulse_contract.py')
for frag in ('XP Check wrapper must delegate to QuestXP',
             'XP report must consume addon-owned status only',
             'if isSecret(currentXP) or isSecret(maxXP) then',
             'Secret', 'UnitXP(', 'GetXPExhaustion('):
    need(frag in legacy,'F.3 historical safety checker was weakened '+frag)
prior=read('tools/check_p0355_primary_ownership_seam_contract.py')
need("glob('check_*.py')))>=226" in prior and
     'original 120 developer actions changed' in prior,
     'P0355 historical inventory policy weakened')
for token in ('P0356','P0355','P0354','P0353','P0352','P0351','P0350',
              'P0349','P0348','P0347','P0346','P0321','UNVERIFIED','D-048',
              'L-019','L-022','L-027','L-028','L-031','cfdc07af'):
    need(token in CUR and token in H,'historic CURRENT/HANDOFF token lost '+token)
for n in range(317,357):
    need(f'P{n:04d}' in H,'P0317..P0356 historical handoff marker missing')
for n in range(317,338):
    need(f'P{n:04d}' in CUR,'P0317..P0337 CURRENT marker missing')
need(len(CUR.encode('utf-8'))<9800 and len(H.encode('utf-8'))<=8000,
     'memory maintenance budget exceeded')
for p in ('docs/memory/investigations/ACTIVE.md','docs/memory/roadmap/STATUS.md',
          'docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md','docs/ROADMAP.md',
          'docs/memory/patches/PATCH_INDEX.md'):
    need('P0356' in read(p),'missing durable checkpoint '+p)
for p in ('docs/memory/evidence/P0356_XP_DIAGNOSTIC_SEAM.md',
          'docs/memory/patches/P0356_XP_DIAGNOSTIC_SEAM.md'):
    d=read(p)
    for word in ('P0356','P0355','P0321','227','UNVERIFIED','OPEN'):
        need(word in d,'evidence provenance incomplete '+p+': '+word)
    need(d.endswith('\n') and not d.endswith('\n\n') and '\r' not in d,
         'record newline hygiene '+p)
need('P0355 R1' in H and 'check_memory_health.py' in H and
     'P0354 R2' in H,'known historical refusal evidence lost')
need(len(list((R/'tools').glob('check_*.py')))>=227,
     'expected #227 static checker')
print('P0356 F.3 XP diagnostic ownership seam: PASS (STATIC; WoW UNVERIFIED)')
