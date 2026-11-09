#!/usr/bin/env python3
"""P0416/P0418 authored action-layout contract: historical request plus current runtime mapping."""
import json
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]

def read(path: str) -> str:
    return (ROOT / path).read_text(encoding="utf-8")

errors = []

def need(ok: bool, why: str) -> None:
    if not ok:
        errors.append(why)

# Historical authored-request artifact from P0416 remains intact.
hist = json.loads(read("docs/design/layout/ACTION_BARS_V1.json"))
expected_hist = [
    ("bar1", "primary", "3x4", 13, 75, 1),
    ("bar2", "secondary", "2x6", 5, 75, 1),
    ("bar3", "utility", "6x2", 90, 85, 1),
    ("bar4", "secondary", "6x2", 10, 95, 1),
    ("bar5", "utility", "6x2", 90, 95, 1),
]
need(hist.get("schema") == "logres-action-layout-request/v1",
     "historical P0416 action layout schema drift")
need(hist.get("baseline") == "43efc89b8651d278630d48517fb6101ca4d14a74",
     "historical P0416 action layout baseline drift")
need(hist.get("coordinates") == "UIParent normalized center percentages",
     "historical action layout coordinate convention drift")
need([
    (x.get("source"), x.get("role"), x.get("grid"),
     x.get("xPercent"), x.get("yPercent"), x.get("scale"))
    for x in hist.get("bars", [])
] == expected_hist, "historical P0416 approved source/role/grid/center/scale drift")

# Preserve the historical P0418 V5 geometry as evidence. P0421 adds an
# independent V6 authoring map; only its changed centers are live now.
archived_v5 = json.loads(read("docs/design/layout/SCREEN_MAP_V5.json"))
archived = {row["id"]: row for row in archived_v5.get("components", [])}
for source, role, grid, x, y, scale in (
    ("bar1", "primary", "3x4", 13, 75, 1),
    ("bar2", "secondary", "2x6", 5, 75, 1),
    ("bar3", "utility", "6x2", 88, 85, 1),
    ("bar4", "secondary", "6x2", 10, 95, 1),
    ("bar5", "utility", "6x2", 88, 95, 1),
):
    need((archived[source]["x"], archived[source]["y"]) == (x, y),
         "historical P0418 V5 action center drift: " + source)
need(archived_v5.get("baseline") == "d11b76ab786f3b08151c426e52502a3415fb4877",
     "historical P0418 V5 baseline drift")

approved = json.loads(read("docs/design/layout/SCREEN_MAP_V6.json"))
components = {row["id"]: row for row in approved.get("components", [])}
expected_runtime = [
    ("bar1", "primary", "3x4", 13, 75, 1),
    ("bar2", "secondary", "2x6", 4, 75.16, 1),
    ("bar3", "utility", "6x2", 89, 85, 1),
    ("bar4", "secondary", "6x2", 10, 95, 1),
    ("bar5", "utility", "6x2", 89, 95, 1),
]
need(approved.get("coordinateSpace") == "viewport percentages, intrinsic component centers; origin top-left",
     "V6 center coordinate convention drift")
need(approved.get("baseline") == "bd55e34e823abadd093930aa184fcd14e0f64ab0",
     "V6 source baseline drift")
for source, role, grid, x, y, scale in expected_runtime:
    row = components.get(source)
    need(row is not None, "approved screen map missing action bar: " + source)
    if row is not None:
        need((row.get("x"), row.get("y")) == (x, y),
             "approved screen map action center drift: " + source)

layout = read("Logres/Integration/Layout.lua")
primary = read("Logres/Actions/Primary.lua")
sides = read("Logres/Actions/SecondaryUtility.lua")
context = read("Logres/Actions/Context.lua")
toc = read("Logres/Logres.toc")
for source, role, grid, x, y, scale in expected_runtime:
    key = {"bar1": "primary", "bar2": "secondary", "bar3": "utility"}.get(source, source)
    columns, rows = map(int, grid.split("x"))
    pattern = (
        rf'(?m)^    {key} = \{{ role = "{role}", columns = {columns}, rows = {rows},\s*\n'
        rf'\s*xPercent = {x}, yPercent = {y}, scale = {scale} \}},$'
    )
    need(re.search(pattern, layout) is not None,
         "runtime profile mapping drift: " + source)
    anchor = {
        "bar1": "primaryActions",
        "bar2": "secondaryActions",
        "bar3": "utilityActions",
        "bar4": "bar4Actions",
        "bar5": "bar5Actions",
    }[source]
    anchor_pattern = (
        rf'(?m)^    {anchor} = \{{ id = [^\n]+ACTION_BAR_LAYOUT\.{key}\.xPercent, '
        rf'y = ACTION_BAR_LAYOUT\.{key}\.yPercent \}},$'
    )
    need(re.search(anchor_pattern, layout) is not None,
         "profile not wired to H.2 semantic anchor: " + source)

for snippet in (
    "function Layout.GetActionBarSpec(key)",
    "return { role = source.role, columns = source.columns,",
    "local fit, boundsReason = actionBarsFitViewport(viewport.width, viewport.height)",
    "if not fit then",
    "pcall(restoreOriginalLayoutAnchors)",
    "action-bounds:",
    "action-overlap:",
    "type(InCombatLockdown)",
    "PLAYER_REGEN_ENABLED",
    "UI_SCALE_CHANGED",
    "DISPLAY_SIZE_CHANGED",
    "viewport.width * rule.x / 100",
    "-viewport.height * rule.y / 100",
):
    need(snippet in layout, "layout/restore gate missing: " + snippet)
for snippet in (
    'Logres.Layout.GetActionBarSpec("primary")',
    "local COLUMNS = PRIMARY_GRID.columns",
    "local ROWS = PRIMARY_GRID.rows",
    'button:SetID(index)',
    'Logres.Layout.Bind(cluster, "primaryActions", "CENTER", "CENTER")',
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
    match = re.search(rf'(?m)^    {key} = \{{\n(.*?)^    \}},', sides, re.DOTALL | re.MULTILINE)
    section = match.group(1) if match else ""
    for fragment in (
        f'firstActionSlot = {slots[0]}',
        f'lastActionSlot = {slots[1]}',
        f'bindingPrefix = "{binding}"',
    ):
        need(fragment in section,
             "action-slot or stock binding map changed: " + key + " " + fragment)
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
for path in (
    'docs/memory/CURRENT.md',
    'docs/memory/patches/PATCH_INDEX.md',
    'docs/memory/investigations/ISSUE_LEDGER.md',
    'docs/memory/evidence/P0416_FIVE_BAR_AUTHORED_LAYOUT.md',
    'docs/memory/evidence/P0418_APPROVED_SCREEN_MAP_TRANSLATION.md',
    'docs/memory/patches/P0416_FIVE_BAR_AUTHORED_LAYOUT.md',
    'docs/memory/PRE_HANDOFF_AUDIT.md',
):
    contents = read(path)
    need('P0416' in contents or 'P0418' in contents,
         "durable memory missing P0416/P0418: " + path)

print('P0416/P0418 authored action layout contract')
for e in errors:
    print('ERROR:', e)
if errors:
    raise SystemExit(1)
print('PASS: historical request retained, runtime centers approved, secure sources and OOC geometry gate preserved')
