#!/usr/bin/env python3
"""P0349: preserved nativeuicheck report through read-only ownership adapter."""
from pathlib import Path
import re
R=Path(__file__).resolve().parents[1]
read=lambda p:(R/p).read_text(encoding='utf-8')
C=read('Logres/Core/Commands.lua')
A=read('Logres/Core/UIOwnershipAudit.lua')
TOC=read('Logres/Logres.toc')
B=read('Logres/Core/Bootstrap.lua')
CUR=read('docs/memory/CURRENT.md')
HAND=read('docs/memory/handoffs/CURRENT_HANDOFF.md')
E=read('docs/memory/evidence/P0349_NATIVE_AUDIT_SEAM.md')
P=read('docs/memory/patches/P0349_NATIVE_AUDIT_SEAM.md')
def need(ok,reason):
    if not ok:raise AssertionError(reason)

old='local function runNativeAccessCheck()\n'
start=C.index(old)
end=C.index('\nend\n',start)+len('\nend\n')
wrapper=C[start:end]
need(wrapper==('local function runNativeAccessCheck()\n'
               '    Logres.UIOwnershipAudit.RunNativeAccessCheck(emit)\nend\n'),
     'original command-local wrapper must delegate exactly once with original emit sink')
need(C.count('Logres.UIOwnershipAudit.RunNativeAccessCheck(emit)')==1,
     'duplicate or missing command adapter')
need(A.count('function Audit.RunNativeAccessCheck(emit)')==1,
     'exactly one diagnostic implementation in read-only ownership module')
a=A.index('function Audit.RunNativeAccessCheck(emit)')
b=A.index('\nend\n',a)+len('\nend\n')
body=A[a:b]
need(body.startswith('function Audit.RunNativeAccessCheck(emit)\n'),
     'report signature or emitter changed')
need('function Audit.Capture()' in A and a<A.index('function Audit.Capture()'),
     'ownership audit capture must remain available and diagnostic defined before it')
lines=['Logres nativeuicheck: %s','Logres native-surfaces: %s',
       'Logres petbar-reshow: AUDIT','Logres petcombat: QUARANTINED']
need(all(body.count(x)==1 for x in lines), 'one of four report lines missing or duplicated')
need([body.index(x) for x in lines]==sorted(body.index(x) for x in lines),
     'report output order changed')
need(body.count('emit(string.format(')==4,'four historical report emissions required')
for marker in ('Logres:GetModuleStatus("NativeAccess")',
               'Logres:GetModule("NativeAccess")',
               'Logres:GetModule("NativeSurfaceReplacement")',
               'Logres:GetModule("PetCombatCandidate")',
               'result.castGateArmed == result.castGateExpected',
               '"DEFERRED" or "FAIL"',
               'PetCombatCandidate', 'petActionDeferredRefold',
               'mainPetStock=true castStockOnDemand=true',
               'These are event counters, not a read of protected stock visibility.'):
    need(marker in body,'native report value, fallback or provenance lost '+marker)
for banned in (':Hide(', ':Show(', 'SetParent(', 'SetShown(',
               'SetEnabled(', 'UpdateAllAuras(', 'GetAuraDataByIndex(',
               'UnitAura(', 'GetAttribute(', 'C_Timer.', 'SetScript(',
               'RegisterEvent(', 'hooksecurefunc(', 'GetPoint(', 'IsShown('):
    need(banned not in body,'read-only report gained unsafe Blizzard inspection/mutation '+banned)
need(A.count('Logres.UIOwnershipAudit = Audit')==1 and
     'function Audit.Capture()' in A,
     'existing ownership audit surface registration/Capture must remain')
need('local function runNativeAccessCheck()' in C and
     C.count('    runNativeAccessCheck()')>=1 and
     'if command == "nativeuicheck" then' in C and
     '"nativeAccessCheck",' in C,
     'Run All or command/action dispatch lost')
need('Logres:GetModule("NativeAccess")' in C,
     'historical P0172 command source marker lost')
need('Core\\UIOwnershipAudit.lua' in TOC and 'Core\\Commands.lua' in TOC
     and TOC.index('Core\\UIOwnershipAudit.lua') < TOC.index('Core\\Commands.lua'),
     'ownership module no longer loads before command dispatch')
need(len([x for x in TOC.splitlines() if x.endswith('.lua')])==94,
     'original 94 addon Lua load inventory changed')
need(re.search(r'(?m)^## Version: (\S+)$',TOC).group(1)==
     re.search(r'(?m)^Logres.VERSION = "([^"]+)"$',B).group(1),
     'TOC/Bootstrap version parity lost')
for marker in ('P0349','P0348','P0347','P0346','P0321','D-048','UNVERIFIED',
               'L-022','L-027','L-028','L-019'):
    need(marker in CUR and marker in HAND,'CURRENT/HANDOFF continuity '+marker)
for marker in ('P0337','cfdc07af','P0338','L-031','UNVERIFIED'):
    need(marker in CUR and marker in HAND,'historical P0338 continuity '+marker)
for n in range(317,349):
    need(f'P{n:04d}' in HAND,'historical handoff marker lost P%04d'%n)
for n in range(317,338):
    need(f'P{n:04d}' in CUR,'CURRENT milestone marker lost P%04d'%n)
need(len(CUR.encode('utf-8'))<9800,'CURRENT health budget exceeded')
for p in ('docs/ROADMAP.md','docs/memory/investigations/ACTIVE.md',
          'docs/memory/roadmap/STATUS.md',
          'docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md',
          'docs/memory/patches/PATCH_INDEX.md'):
    need('P0349' in read(p),'missing patch index '+p)
for s in (E,P):
    need(all(x in s for x in ('P0349','P0348','P0321','OPEN','UNVERIFIED','220')),
         'record provenance/runtime caveat lost')
    need(s.endswith('\n') and not s.endswith('\n\n') and '\r' not in s,'record hygiene')
need(len(list((R/'tools').glob('check_*.py')))>=220,'expected 220 source checkers')
# Historical checker assertions must follow the code to its audited owner.
legacy={
 'tools/check_native_pet_aura_replacement_contract.py':
  "if 'Logres native-surfaces:' not in read('Logres/Core/UIOwnershipAudit.lua')",
 'tools/check_native_pet_reshow_recovery_contract.py':
  "if 'Logres petbar-reshow: AUDIT' not in (root/'Logres/Core/UIOwnershipAudit.lua').read_text()",
 'tools/check_pet_combat_candidate_contract.py':
  'source = A if name in ("quarantine diagnostics", "rejections reported") else C',
 'tools/check_native_cast_gate_contract.py':
  "if token not in a: errors.append('missing truthful diagnostic: '+token)",
 'tools/check_interaction_native_contract.py':
  "if token not in audit: errors.append('native check missing: '+token)",
 'tools/check_native_reshow_contract.py':
  "if token not in a: errors.append(f'missing truthful diagnostics: {token}')",
}
for filename,token in legacy.items():
    need(token in read(filename),'historical evidence assertion did not follow moved report '+filename)
need('Logres/Core/Commands.lua' in read('tools/check_native_pet_reshow_recovery_contract.py')
     and 'command == "petcombat"' in read('tools/check_pet_combat_candidate_contract.py')
     and 'NativeSurfaceReplacement.lua' in read('tools/check_native_pet_aura_replacement_contract.py')
     and 'NativeAccess.lua' in read('tools/check_native_cast_gate_contract.py')
     and 'Logres/Immersion/NativeAccess.lua' in read('tools/check_interaction_native_contract.py')
     and 'NativeAccess.lua' in read('tools/check_native_reshow_contract.py'),
     'prior native stock/quarantine safety evidence checker was hollowed out')
need('P0349 R0 PREWRITE REFUSED 2/220' in E and
     'check_interaction_native_contract.py' in E and
     'check_native_reshow_contract.py' in E,
     'R0 failure/migration evidence omitted')
need('P0347 R0' in read('docs/memory/evidence/P0347_SUBSCRIPTION_LIFECYCLE.md'),
     'historical rejected PREWRITE evidence lost')
print('P0349 native ownership diagnostic seam: PASS (STATIC; WoW UNVERIFIED)')
