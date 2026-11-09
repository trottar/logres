#!/usr/bin/env python3
"""P0416 authored five-bar profile: check source/role/geometry, not WoW runtime."""
import json
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]
read = lambda p: (ROOT / p).read_text(encoding="utf-8")
errors = []
def need(ok, why):
    if not ok:
        errors.append(why)

spec = json.loads(read("docs/design/layout/ACTION_BARS_V1.json"))
expected = [
    ("bar1", "primary", "3x4", 13, 75, 1),
    ("bar2", "secondary", "2x6", 5, 75, 1),
    ("bar3", "utility", "6x2", 90, 85, 1),
    ("bar4", "secondary", "6x2", 10, 95, 1),
    ("bar5", "utility", "6x2", 90, 95, 1),
]
need(spec.get("schema") == "logres-action-layout-request/v1",
     "approved layout schema drift")
need(spec.get("baseline") == "43efc89b8651d278630d48517fb6101ca4d14a74",
     "approved layout baseline drift")
need(spec.get("coordinates") == "UIParent normalized center percentages",
     "coordinate convention drift")
rows = spec.get("bars", [])
need([(x.get("source"), x.get("role"), x.get("grid"),
       x.get("xPercent"), x.get("yPercent"), x.get("scale"))
      for x in rows] == expected, "approved source/role/grid/center/scale drift")

layout = read("Logres/Integration/Layout.lua")
primary = read("Logres/Actions/Primary.lua")
sides = read("Logres/Actions/SecondaryUtility.lua")
context = read("Logres/Actions/Context.lua")
toc = read("Logres/Logres.toc")
for source, role, grid, x, y, scale in expected:
    key = {"bar1": "primary", "bar2": "secondary", "bar3": "utility"}.get(source, source)
    columns, height = map(int, grid.split("x"))
    pattern = (r"(?m)^    " + key + r" = \{ role = \"" + role
               + r"\", columns = " + str(columns) + r", rows = "
               + str(height) + r",\s*\n\s*xPercent = " + str(x)
               + r", yPercent = " + str(y) + r", scale = "
               + str(scale) + r" \},$")
    need(re.search(pattern, layout) is not None,
         "runtime profile mapping drift: " + source)
    anchor = {"bar1": "primaryActions", "bar2": "secondaryActions",
              "bar3": "utilityActions", "bar4": "bar4Actions",
              "bar5": "bar5Actions"}[source]
    need(re.search(r"(?m)^    " + anchor + r" = \{ id = [^\n]+"
                   + r"ACTION_BAR_LAYOUT\." + key + r"\.xPercent, y = ACTION_BAR_LAYOUT\."
                   + key + r"\.yPercent \},$", layout) is not None,
         "profile not wired to H.2 semantic anchor: " + source)

for snippet in (
    "function Layout.GetActionBarSpec(key)",
    "return { role = source.role, columns = source.columns,",
    "local fit, boundsReason = actionBarsFitViewport(viewport.width, viewport.height)",
    "if not fit then", "pcall(restoreOriginalLayoutAnchors)",
    "action-bounds:", "action-overlap:",
    "type(InCombatLockdown)", "PLAYER_REGEN_ENABLED",
    "UI_SCALE_CHANGED", "DISPLAY_SIZE_CHANGED",
    "viewport.width * rule.x / 100", "-viewport.height * rule.y / 100",
):
    need(snippet in layout, "layout/restore gate missing: " + snippet)
for snippet in (
    'Logres.Layout.GetActionBarSpec("primary")',
    "local COLUMNS = PRIMARY_GRID.columns", "local ROWS = PRIMARY_GRID.rows",
    'button:SetID(index)', 'Logres.Layout.Bind(cluster, "primaryActions", "CENTER", "CENTER")',
):
    need(snippet in primary, "primary source/routing contract missing: " + snippet)
for key, slots, binding in (
    ("secondary", (61, 72), "MULTIACTIONBAR1BUTTON"),
    ("utility", (49, 60), "MULTIACTIONBAR2BUTTON"),
    ("bar4", (25, 36), "MULTIACTIONBAR3BUTTON"),
    ("bar5", (37, 48), "MULTIACTIONBAR4BUTTON"),
):
    need(('    ' + key + ' = Logres.Layout.GetActionBarSpec("' + key + '")') in sides,
         "side source missing role/grid mapping: " + key)
    # Inspect only the relevant static config section, not source/bar order assumptions.
    match = re.search(r"(?m)^    " + key + r" = \{\n(.*?)^    \},", sides, re.DOTALL | re.MULTILINE)
    section = match.group(1) if match else ""
    for fragment in (f'firstActionSlot = {slots[0]}', f'lastActionSlot = {slots[1]}',
                     f'bindingPrefix = "{binding}"'):
        need(fragment in section, "action-slot or stock binding map changed: " + key + " " + fragment)
need("ActionButton.Create(\n            config.buttonPrefix .. index,\n            frame,\n            index,\n            columns" in sides,
     "side secure button grid is no longer rendered from the source role")
need('primary.cluster:SetAlpha(policy.primary)' in context and
     'Logres.Layout.GetActionBarSpec(source).role' in context and
     'sides.clusters[source].frame:SetAlpha(policy[role])' in context,
     "role-based context alpha not applied to all source clusters")
need(all(x not in context for x in ('.frame:Hide(', '.frame:Show(', 'SetAlpha(0)',
                                     'SetBinding(', 'UseAction(')),
     "context introduced action/visibility/binding mutation")
need(len([line for line in toc.splitlines() if line.endswith('.lua')]) == 96,
     "original 96 Lua TOC entries changed")
need('Action_Bars' not in toc and "LayoutProfile.lua" not in toc,
     "new runtime Lua editing module introduced")
need('for token in (\'Logres.Layout.GetActionBarSpec("primary")\'' in
     read('tools/check_h2_unified_placement_contract.py'),
     "P0195 historic contract migration absent")
need('sides.clusters[source].frame:SetAlpha(policy[role])' in
     read('tools/check_action_context_contract.py'),
     "C.4 historic alpha contract migration absent")
for path in ('docs/memory/CURRENT.md', 'docs/memory/patches/PATCH_INDEX.md',
             'docs/memory/investigations/ISSUE_LEDGER.md',
             'docs/memory/evidence/P0416_FIVE_BAR_AUTHORED_LAYOUT.md',
             'docs/memory/patches/P0416_FIVE_BAR_AUTHORED_LAYOUT.md',
             'docs/memory/PRE_HANDOFF_AUDIT.md'):
    need('P0416' in read(path), "durable memory missing P0416: " + path)

print('P0416 five-bar approved action layout contract')
for e in errors:
    print('ERROR:', e)
if errors:
    raise SystemExit(1)
print('PASS: exact user mapping, secure sources, role alpha, OOC geometry gate, memory')
