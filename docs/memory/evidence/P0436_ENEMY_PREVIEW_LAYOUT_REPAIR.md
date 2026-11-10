# P0436 — HUD fixture-only preview and combat-row alignment (2026-11-10)

## Baseline and observed symptoms

Main P0435 `9df287e50925d41989e2d62dad0f7f51ca1e428c`,
tree `8ba29774830af11592029a8258c5228c311ce0df`. The user supplied a
Forever screenshot of the P0435 fixture. Enemy graphics, target 100%, aggro
50%, and left/right buff/debuff spacing look as intended, but two fixture
bugs are visible: the HUD Preview action applies a false low-HP red vignette,
and the scaled secondary aggro fixture appears on the upper row. The separate
Settings screenshot confirms Screen-space Enemy Frame OFF, but the fallback
hint is clipped. No gameplay aggro, live attachment, or persistence proof.

## Narrow source correction

- `HUD:SetPreviewEnabled` toggles only `SetEnemyDisplayPreview`; it no longer
  calls `SetHealthPreviewPercent(30)` or manipulates an explicit health preview.
  `/logres healthpreview` remains the sole health simulation control. Real
  health continues to drive the existing tunnel-vision curve.
- An unscaled addon-owned `aggroSlot` is positioned at combat-row Y=-252,
  matching the full-size target row. Its child fixture has SetScale(0.5)
  before attachment to that slot and SetAlpha(0.5), preserving the unit's
  harmful/helpful V8 offsets through inherited scale/opacity.
- Shorten the Screen-space Enemy Frame help line to avoid text/button overlap.
  The saved Boolean remains OFF on fresh/existing settings and cannot suppress
  the canonical target fallback until a safe overhead replacement exists.

## Safety and verification limits

No combat lockdown mutation, Blizzard nameplate ancestry/child changes, CVars,
forced nameplates, new scanning, secret-value inspection, or live aggro routing.
D-042/L-011 remain DEFERRED pending positive safe attachment proof and
per-unit ordinary aggro validation. Positive combat anchor access in P0432 is
not attachment proof. The P0435 screenshot is a scoped visual PASS only.

Author-check, guarded WSL application and screenshot retest are independent.
P0436 static checker and mock geometry can verify source contracts, not in-game
pixel placement or genuine aggro. Verify live user health vignette unaffected,
50% fixture aligned under combat heading, saved OFF persistence, and fallback.
Record any failure in issue ledger before advancing.
