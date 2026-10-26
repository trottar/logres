#!/usr/bin/env python3
"""P0353: original H.2 diagnostic moves to its layout owner (STATIC only)."""
from pathlib import Path
import re

R = Path(__file__).resolve().parents[1]
read = lambda path: (R / path).read_text(encoding='utf-8')
C = read('Logres/Core/Commands.lua')
L = read('Logres/Integration/Layout.lua')
T = read('Logres/Logres.toc')
B = read('Logres/Core/Bootstrap.lua')
CUR = read('docs/memory/CURRENT.md')
HAND = read('docs/memory/handoffs/CURRENT_HANDOFF.md')

def need(condition, reason):
    if not condition:
        raise AssertionError(reason)

def extract(src, sig):
    need(src.count(sig) == 1, 'missing/nonunique entry '+sig)
    a = src.index(sig)
    b = src.index('\nend\n', a) + len('\nend\n')
    return src[a:b]

wrapper = extract(C, 'local function runLayoutCheck()\n')
need(wrapper == 'local function runLayoutCheck()\n    Logres.Layout.RunDevLayoutCheck(emit)\nend\n',
     'original command wrapper must forward once with original sink')
report = extract(L, 'function Layout.RunDevLayoutCheck(emit)\n')
need('local LAYOUT_EXPECTED = {\n' in L and 'local LAYOUT_EXPECTED = {' not in C,
     'H.2 expected role register must follow report to layout owner')
start = L.index('local LAYOUT_EXPECTED = {\n')
end = L.index('\n}\n', start) + len('\n}\n')
role_table = L[start:end]
roles = re.findall(r'^\s*\{ "(Logres[^\"]+)", "([^\"]+)" \},$', role_table, re.M)
need(len(roles) == 16 and len({name for name, key in roles}) == 16,
     'original 16 unique Logres-owned roles must remain')
need(all(name.startswith('Logres') and key for name, key in roles),
     'non-addon-owned probe frame may not be added')
need(roles.count(('LogresNativeAccessDock', 'nativeAccess')) == 1 and
     'LogresNativeAccessDock' not in C,
     'P0172 native dock semantic role must exist once in Layout, not Commands')
need(L.index('local LAYOUT_EXPECTED = {') < L.index('function Layout.RunDevLayoutCheck(emit)'),
     'role inventory not in lexical scope of report')
need('status.anchorCount == #LAYOUT_EXPECTED + 3' in report,
     'original status anchor baseline must remain')
need('local frame = _G[definition[1]]' in report and
     'frame.logresLayoutAnchor ~= expected' in report,
     'H.2 cached semantic-anchor comparison changed')
expected_report = (
    'Logres layoutcheck: FAIL ',
    'Logres layoutcheck: %s (anchors=%s binds=%s failures=%s missing=%s mismatched=%s error=%s)',
    'Logres H2 v4 placement: %s (reason=%s anchors=%s)',
    'Logres H2 v4 geometry AUDIT (measured=%s/%s missing=%s deferred=%s reason=%s; layout unchanged)',
    'Logres H2 %s %s actual=(%.1f,%.1f,%.1f,%.1f) planned=(%.1f,%.1f,%.1f,%.1f)',
    'Logres H2 %s %s frame=%s planned=(%.1f,%.1f,%.1f,%.1f)',
)
need(all(report.count(x) == 1 and x not in C for x in expected_report),
     'original report output belongs exclusively in Layout, without duplication')
need([report.index(x) for x in expected_report] ==
     sorted(report.index(x) for x in expected_report),
     'report order changed')
need('local h2 = Logres.Layout.GetH2ScreenMapAudit()' in report and
     'for index = 1, #h2.rows do' in report,
     'per-row read-only geometry report changed')
for token in ('C_Timer.', 'SetScript(', 'RegisterEvent(', 'hooksecurefunc(',
              'SetPoint(', 'SetParent(', 'SetAttribute(', ':Hide(', ':Show(',
              'UnitAura(', 'GetAttribute(', 'IsShown('):
    need(token not in report, 'new unsafe diagnostic operation: '+token)
need(L.index('function Layout.GetDebugStatus()') <
     L.index('function Layout.RunDevLayoutCheck(emit)'),
     'Layout source API/order changed')
for route in ('    runLayoutCheck()', 'if command == "layoutcheck" then',
              '"layoutCheck",', '"layoutcheck",',
              'emit("  /logres layoutcheck")'):
    need(route in C, 'command/Run All/panel route missing '+route)
need('Integration\\Layout.lua' in T and 'Core\\Commands.lua' in T and
     T.index('Integration\\Layout.lua') < T.index('Core\\Commands.lua'),
     'Layout must precede Commands in TOC')
need(len([x for x in T.splitlines() if x.endswith('.lua')]) == 94,
     'addon Lua inventory changed')
need(len(re.findall(r'Logres:RegisterDevPanelAction\(\s*"', C)) == 120,
     'panel action inventory changed')
need(re.search(r'(?m)^## Version: (\S+)$', T).group(1) ==
     re.search(r'(?m)^Logres.VERSION = "([^"]+)"$', B).group(1),
     'TOC/bootstrap version parity')
legacy = {
  'tools/check_layout_integration_contract.py': [
      '"function Layout.RunDevLayoutCheck(emit)"',
      '"Logres.Layout.RunDevLayoutCheck(emit)"',
      'Logres layoutcheck: %s (anchors=',
      '"function Layout.Bind("',
      'Logres:RegisterDevPanelAction',
  ],
  'tools/check_h2_unified_placement_contract.py': [
      "'status.anchorCount == #LAYOUT_EXPECTED + 3' not in L",
      "'Logres H2 v4 placement:' not in L",
      "'Logres.Layout.RunDevLayoutCheck(emit)' not in C",
      'restoreOriginalLayoutAnchors',
  ],
  'tools/check_h2_geometry_audit_contract.py': [
      'if required not in layout:',
      'Logres.Layout.RunDevLayoutCheck(emit)',
      'pcall(issecretvalue, value)',
      'function Layout.GetH2ScreenMapAudit()',
  ],
  'tools/check_native_access_contract.py': [
      "'{ \"LogresNativeAccessDock\", \"nativeAccess\" },' not in layout.read_text",
      'NativeAccess:Restore(key, reason)',
      'mainAndPetStockRetained = true',
      'if command == \"nativeuicheck\" then',
  ],
}
for path, markers in legacy.items():
    contents = read(path)
    for marker in markers:
        need(marker in contents, 'historical output/safety checker lost '+path+': '+marker)
for path in ('docs/ROADMAP.md', 'docs/memory/investigations/ACTIVE.md',
             'docs/memory/roadmap/STATUS.md',
             'docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md',
             'docs/memory/patches/PATCH_INDEX.md'):
    need('P0353' in read(path), 'P0353 historical log missing '+path)
for marker in ('P0353','P0352','P0351','P0350','P0349','P0348','P0347',
               'P0346','P0321','D-048','L-019','L-022','L-027','L-028',
               'UNVERIFIED','L-031','cfdc07af'):
    need(marker in CUR and marker in HAND, 'historical memory continuity '+marker)
for n in range(317, 353):
    need(f'P{n:04d}' in HAND, 'handoff missing P%04d' % n)
for n in range(317, 338):
    need(f'P{n:04d}' in CUR, 'CURRENT missing P%04d' % n)
need(len(CUR.encode('utf-8')) < 9800, 'CURRENT maintenance budget')
for p in ('docs/memory/evidence/P0353_LAYOUT_SEAM.md',
          'docs/memory/patches/P0353_LAYOUT_SEAM.md'):
    d = read(p)
    for m in ('P0353','P0352','P0321','224','OPEN','UNVERIFIED'):
        need(m in d, 'new evidence provenance '+p+': '+m)
    need(d.endswith('\n') and not d.endswith('\n\n') and '\r' not in d,
         'record newline hygiene '+p)
need('P0353 R0 PREWRITE REFUSED 1/224' in read('docs/memory/evidence/P0353_LAYOUT_SEAM.md') and
     'check_native_access_contract.py' in read('docs/memory/evidence/P0353_LAYOUT_SEAM.md'),
     'R0 static refusal and historical P0172 correction evidence missing')
need(len(list((R/'tools').glob('check_*.py'))) >= 224,
     'expected new #224 checker')
print('P0353 layout ownership diagnostic seam: PASS (STATIC; WoW UNVERIFIED)')
