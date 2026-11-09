#!/usr/bin/env python3
"""P0420: expected anchor placement vs intrinsic owned-frame footprint, read-only."""
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
read = lambda p: (ROOT / p).read_text(encoding='utf-8')
layout = read('Logres/Integration/Layout.lua')
panel = read('Logres/Dev/Panel.lua')
errors = []

def need(test, label):
    if not test:
        errors.append(label)

# Explicit allowlist; never infer a frame's semantic anchor from its name.
expected = {
    'compass': ('navigation', 'TOP'),
    'activeQuest': ('activeQuest', 'TOPRIGHT'),
    'questDialogue': ('questDialogue', 'TOP'),
    'contextObjective': ('contextObjective', 'CENTER'),
    'contextXP': ('contextXP', 'CENTER'),
    'player-debuff': ('playerHarmful', 'CENTER'),
    'resource': ('playerReaction', 'CENTER'),
    'player-buff': ('passiveStatus', 'LEFT'),
    'enemy-debuff': ('targetHarmful', 'CENTER'),
    'enemy': ('targetFallback', 'CENTER'),
    'enemy-buff': ('targetHelpful', 'CENTER'),
    'group': ('allies', 'CENTER'),
    'reportBug': ('reportBug', 'CENTER'),
}
for id_, (key, point) in expected.items():
    left = f'["{id_}"]' if '-' in id_ else id_
    need(f'{left} = {{ key = "{key}", point = "{point}" }}' in layout,
         f'owned frame semantic placement changed: {id_}')

for token in (
    'local H2_INTRINSIC_ANCHORS = {',
    'local function intrinsicExpectedRect(entry, viewport)',
    'if type(InCombatLockdown) ~= "function" or InCombatLockdown() then',
    'local frame = _G[entry[2]] -- P0192 addon-owned frame allowlist only',
    'local rect = readAddonRect(frame)',
    'local approved = H2_APPROVED_ANCHORS[binding.key]',
    'x = x - w / 2',
    'x = x - w',
    'y = y - h / 2',
    'x, y = x - w / 2, y - h / 2',
    'local px, py, pw, ph = intrinsicExpectedRect(entry, viewport)',
    'mode = "intrinsic-anchor"',
    'mode = "design-fallback"',
    'mode = "authored-grid"',
    'designW = entry[5], designH = entry[6]',
    'row.offsetX = (row.x - target.x) * rootWidth / 100',
    'row.offsetY = (row.y - target.y) * rootHeight / 100',
    'row.designDeltaW = (row.w - s[5]) * rootWidth / 100',
    'row.designDeltaH = (row.h - s[6]) * rootHeight / 100',
    'Logres H2 %s position-offset=',
    'design-size-delta=',
    'BLUE = EXPECTED AT APPROVED ANCHOR | GOLD = MEASURED LOGRES FRAME',
    'target.id .. (target.mode == "design-fallback"',
):
    need(token in layout, 'missing safe anchor projection or diagnostic: ' + token)
need('BLUE expected at approved anchors    GOLD measured Logres frames' in panel,
     'H2 panel legend still misrepresents design envelopes as live footprint')
need('Logres.Layout.Bind(root, "passiveStatus", "LEFT", "CENTER")' in read('Logres/HUD/PlayerHelpfulAuras.lua'),
     'player buff frame binding no longer LEFT/CENTER')
need('Logres.Layout.Bind(root, "activeQuest", "TOPRIGHT", "TOPRIGHT")' in read('Logres/Quest/ActiveQuest.lua'),
     'active quest binding no longer TOPRIGHT')
need('Logres.Layout.Bind(frame, "navigation", "TOP", "TOP")' in read('Logres/Navigation/Compass.lua'),
     'compass binding no longer TOP')
need('Logres.Layout.Bind(root, panelConfig.placement.key,' in read('Logres/Quest/Dialogue.lua'),
     'quest dialogue binding source changed')
need('placement = { key = "questDialogue", point = "TOP", relativePoint = "TOP"' in read('Logres/Quest/QuestPanelConfig.lua'),
     'quest dialogue placement semantic changed')
# No hidden hook, protected Blizzard ownership change, or mutation of approved V5.
for bad in ('C_Timer.After', 'C_Timer.NewTicker', 'SetScript("OnUpdate"',
            'PetActionBarFrame:Hide', 'PetFrame:Hide', 'BuffFrame:Hide'):
    need(bad not in layout, 'unsafe timer/hook/native surface mutation: '+bad)
need('function Layout.ApplyApprovedV4()' in layout and
     'local fit, boundsReason = actionBarsFitViewport' in layout,
     'runtime out-of-combat placement fail-open was removed')
need('P0420' in read('docs/memory/CURRENT.md') and
     'P0420' in read('docs/memory/investigations/ACTIVE.md') and
     'P0420' in read('docs/memory/patches/PATCH_INDEX.md') and
     'P0420' in read('docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md'),
     'P0420 evidence or active memory missing')
need('LOGRES_SCREEN_MAP_APPROVED.json' in read('docs/design/layout/SCREEN_MAP_V5.md'),
     'historical approved design authority changed')
print('P0420 H2 semantic anchor projection contract')
for e in errors:
    print('ERROR:', e)
if errors:
    raise SystemExit(1)
print('PASS: explicit binding semantics, safe read-only footprint projection, independent drift metrics, stock fallback preserved')
