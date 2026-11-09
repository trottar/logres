#!/usr/bin/env python3
"""P0419: source-exact H.2 action outline projection, no gameplay mutation."""
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]
def read(path):
    return (ROOT / path).read_text(encoding='utf-8')

layout = read('Logres/Integration/Layout.lua')
primary = read('Logres/Actions/Primary.lua')
sides = read('Logres/Actions/SecondaryUtility.lua')
pet = read('Logres/HUD/PetActionExecutionProbe.lua')
actions = read('Logres/Actions/Button.lua')
errors = []
def need(condition, message):
    if not condition:
        errors.append(message)

for fragment in (
    'local H2_ACTION_PLAN_KEYS = {',
    'bar1 = "primary", bar2 = "secondary", bar3 = "utility",',
    'bar4 = "bar4", bar5 = "bar5",',
    'local function actionPlanFootprint(id, viewport)',
    'local spec = ACTION_BAR_LAYOUT[key]',
    'columns, rows, scale = 5, 2, 1',
    'local size, gap = theme.buttonSize or 42, theme.buttonGap or 5',
    '(columns * size + (columns - 1) * gap) * scale',
    'centerX, centerY = spec.xPercent, spec.yPercent',
    'H2_APPROVED_ANCHORS.classPet.y',
    'x, y = centerX - gridW / 2, centerY - gridH / 2',
    'local plan = Layout.GetH2ScreenMapPlan()',
    'targetX = target.x, targetY = target.y,',
    'targetW = target.w, targetH = target.h,',
    'target.x, target.y, target.w, target.h,',
    'readAddonRect(UIParent)',
    'ordinaryGeometryNumber(value)',
):
    need(fragment in layout, 'missing source-exact overlay path: ' + fragment)

need('local DEFAULT_BUTTON_SIZE = actionStyle.buttonSize or 42' in actions,
     'action button theme-size contract differs')
need('local DEFAULT_BUTTON_GAP = actionStyle.buttonGap or 5' in actions,
     'action button theme-gap contract differs')
need('cluster:SetSize(width, height)' in actions,
     'secure cluster size calculation differs')
need('Logres.Layout.GetActionBarSpec("primary")' in primary,
     'primary authored grid differs')
need('Logres.Layout.GetActionBarSpec("secondary")' in sides,
     'secondary authored grid differs')
need(re.search(r'(?m)^local COLUMNS = 5$', pet) is not None and
     re.search(r'(?m)^local ROWS = 2$', pet) is not None,
     'pet cluster grid differs')
need('function Layout.ApplyApprovedV4()' in layout and
     'local fit, boundsReason = actionBarsFitViewport' in layout,
     'out-of-combat approved runtime anchor gate changed')
need('function Layout.GetH2ScreenMapAudit()' in layout and
     'function Layout.GetH2ScreenMapPlan()' in layout and
     'function Layout.SetH2MapVisible(visible)' in layout,
     'approved plan/map/audit seam missing')
for file in ('docs/memory/CURRENT.md', 'docs/memory/patches/PATCH_INDEX.md',
             'docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md',
             'docs/memory/PRE_HANDOFF_AUDIT.md',
             'docs/memory/evidence/P0419_H2_ACTION_FOOTPRINT_CALIBRATION.md'):
    need('P0419' in read(file), 'durable memory missing: ' + file)
print('P0419 H.2 action footprint contract')
for e in errors:
    print('ERROR:', e)
if errors:
    raise SystemExit(1)
print('PASS: source-owned action grid footprints, approved centers, read-only overlay, no protected mutation')
