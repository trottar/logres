#!/usr/bin/env python3
"""P0352: preserve effectful lifecycle probe through the existing module owner."""
from pathlib import Path
import re

R = Path(__file__).resolve().parents[1]
read = lambda path: (R / path).read_text(encoding="utf-8")
C = read("Logres/Core/Commands.lua")
M = read("Logres/Core/Modules.lua")
T = read("Logres/Logres.toc")
B = read("Logres/Core/Bootstrap.lua")
CUR = read("docs/memory/CURRENT.md")
H = read("docs/memory/handoffs/CURRENT_HANDOFF.md")

def need(ok, reason):
    if not ok:
        raise AssertionError(reason)

def extract(source, signature):
    need(source.count(signature) == 1, "missing/duplicate function " + signature)
    a = source.index(signature)
    b = source.index("\nend\n", a) + len("\nend\n")
    return source[a:b]

wrapper = extract(C, "local function runLifecycleCheck()\n")
need(wrapper == "local function runLifecycleCheck()\n"
                "    Logres:RunDevLifecycleCheck(emit, lifecycleProbe, lifecycleProbeModule)\nend\n",
     "Commands lifecycle wrapper must forward original probe, module, emit")
report = extract(M, "function Logres:RunDevLifecycleCheck(emit, lifecycleProbe, lifecycleProbeModule)\n")
need(C.count("Logres:RunDevLifecycleCheck(emit, lifecycleProbe, lifecycleProbeModule)") == 1,
     "lifecycle must have one command delegation")
need(M.count("function Logres:RunDevLifecycleCheck(emit, lifecycleProbe, lifecycleProbeModule)") == 1,
     "lifecycle report must have exactly one owner")
for token in (
    'Logres lifecyclecheck: PASS (init=%s enable=%s disable=%s cleanup=%s prefCallbacksWhileEnabled=2 prefCallbacksWhileDisabled=0)',
    'Logres lifecyclecheck: FAIL (beforeInit=%s beforeEnabled=%s initializedAgain=%s enabled=%s/%s disabled=%s/%s init=%s->%s enable=%s->%s disable=%s->%s cleanup=%s->%s prefEnabled=%s prefDisabled=%s afterEnabled=%s afterCleanup=%s)',
):
    need(report.count(token) == 1 and token not in C,
         "PASS/FAIL report must be owned only by Modules: " + token)
need(report.count('emit(string.format(') == 2, "original PASS and FAIL emission count")
for token in (
    'local moduleName = lifecycleProbeModule.name',
    'Logres:GetModuleStatus(moduleName)',
    'Logres:InitializeModule(moduleName)',
    'Logres:EnableModule(moduleName)',
    'Logres:DisableModule(moduleName)',
    'callbacksWhileEnabled == 2',
    'callbacksWhileDisabled == 0',
    'after.cleanupCount == 0',
    'lifecycleProbe.cleanupCount == cleanupBefore + 1',
    '"DEV_LIFECYCLECHECK_ENABLED_CHANGE"',
    '"DEV_LIFECYCLECHECK_ENABLED_RESTORE"',
    '"DEV_LIFECYCLECHECK_DISABLED_CHANGE"',
    '"DEV_LIFECYCLECHECK_DISABLED_RESTORE"',
):
    need(token in report, "effectful lifecycle test semantics removed: " + token)
need(report.index('"DEV_LIFECYCLECHECK_ENABLED_CHANGE"') <
     report.index('"DEV_LIFECYCLECHECK_ENABLED_RESTORE"') <
     report.index('Logres:DisableModule(moduleName)') <
     report.index('"DEV_LIFECYCLECHECK_DISABLED_CHANGE"') <
     report.index('"DEV_LIFECYCLECHECK_DISABLED_RESTORE"'),
     "original enable/disable/restore ordering changed")
for banned in ('C_Timer.', 'SetScript(', 'RegisterEvent(', 'GetAttribute(',
               'IsShown(', ':Hide(', ':Show(', 'SetParent(', 'SetPoint(',
               'hooksecurefunc('):
    need(banned not in report, "diagnostic gained protected/UI/polling operation: " + banned)
need('local lifecycleProbe = {' in C and
     'local lifecycleProbeModule = Logres:RegisterModule("DevLifecycleProbe", {' in C and
     'autoEnable = false' in C and
     'self:OwnCleanup(function()' in C and
     'self:SubscribePreferences(function()' in C,
     "probe registration must remain in same Commands TOC/load position")
need(C.index('local lifecycleProbe = {') <
     C.index('local lifecycleProbeModule = Logres:RegisterModule("DevLifecycleProbe"') <
     C.index('local function runLifecycleCheck()'),
     "Commands probe registration order changed")
need(M.index('function Logres:EnableDefaultModules()') <
     M.index('function Logres:RunDevLifecycleCheck(emit, lifecycleProbe, lifecycleProbeModule)'),
     "module owner missing established startup API")
for token in ('local function runLifecycleCheck()', '    runLifecycleCheck()',
              'if command == "lifecyclecheck" then', '"lifecyclecheck"',
              '"lifecycle",'):
    need(token in C, "Run All/slash/panel route lost: " + token)
need(C.index('    runPreferenceCheck()') < C.index('    runLifecycleCheck()') <
     C.index('    runHUDCheck()'), "original Run All ordering changed")
need('Core\\Modules.lua' in T and 'Core\\Commands.lua' in T and
     T.index('Core\\Modules.lua') < T.index('Core\\Commands.lua') <
     T.index('Core\\Lifecycle.lua'), "TOC module order changed")
need(len([x for x in T.splitlines() if x.endswith('.lua')]) == 94,
     "94 Lua entry inventory changed")
need(re.search(r'(?m)^## Version: (\S+)$', T).group(1) ==
     re.search(r'(?m)^Logres.VERSION = "([^"]+)"$', B).group(1),
     "TOC/Bootstrap version parity")
need(len(re.findall(r'Logres:RegisterDevPanelAction\(\s*"', C)) == 120,
     "120 existing developer actions must remain")
legacy = read('tools/check_module_contract.py')
need('Logres:RegisterModule("DevLifecycleProbe"' in legacy and
     '"/logres lifecyclecheck"' in legacy,
     "historical module contract must retain startup probe")
legacy = read('tools/check_status_aura_disabled_contract.py')
need("'local function runLifecycleCheck()'" in legacy and
     "'    runLifecycleCheck()'" in legacy,
     "P0175 lifecycle preference/status regression checks weakened")
prior = read('tools/check_p0351_preference_seam_contract.py')
need('RunDevPreferenceCheck(emit, boolText)' in prior,
     "P0351 historical preference test contract lost")
for token in ('P0352', 'P0351', 'P0350', 'P0349', 'P0348', 'P0347',
              'P0346', 'P0321', 'D-048', 'UNVERIFIED', 'L-019',
              'L-022', 'L-027', 'L-028', 'L-031', 'cfdc07af'):
    need(token in CUR and token in H, 'memory continuity ' + token)
for n in range(317, 352):
    need(f'P{n:04d}' in H, 'historical handoff P%04d missing' % n)
for n in range(317, 338):
    need(f'P{n:04d}' in CUR, 'historical CURRENT P%04d missing' % n)
need(len(CUR.encode('utf-8')) < 9800, 'CURRENT source budget breached')
for path in ('docs/ROADMAP.md', 'docs/memory/investigations/ACTIVE.md',
             'docs/memory/roadmap/STATUS.md',
             'docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md',
             'docs/memory/patches/PATCH_INDEX.md'):
    need('P0352' in read(path), 'roadmap/index not updated ' + path)
for path in ('docs/memory/evidence/P0352_LIFECYCLE_SEAM.md',
             'docs/memory/patches/P0352_LIFECYCLE_SEAM.md'):
    d = read(path)
    for token in ('P0352', 'P0351', 'P0321', '223', 'UNVERIFIED', 'OPEN'):
        need(token in d, 'evidence incomplete ' + path + ' ' + token)
    need(d.endswith('\n') and not d.endswith('\n\n') and '\r' not in d,
         'record hygiene ' + path)
need(len(list((R / 'tools').glob('check_*.py'))) >= 223,
     'checker #223 missing')
print('P0352 lifecycle diagnostic seam: PASS (STATIC; WoW UNVERIFIED)')
