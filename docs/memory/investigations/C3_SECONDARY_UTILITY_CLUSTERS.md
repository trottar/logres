# C.3 — Secondary / Utility Clusters

Status: IMPLEMENTATION PREPARED; RUNTIME PROOF NEXT
Opened: 2026-10-01

## Goal

Extend the proven secure action architecture into Logres' broader action
constellation without prematurely suppressing Blizzard's stock bars.

## Source resolution

Canonical evidence:
`../evidence/C3_SECONDARY_UTILITY_SOURCE_REVIEW_2026-10-01.md`

Canonical decision:
`../decisions/D-019_SECONDARY_UTILITY_CLUSTER_CONTRACT.md`

## P0036 implementation

### Shared primitive

Adds:

```text
Actions/Button.lua
```

It owns reusable:
- secure action button creation;
- click/release attributes;
- icon/cooldown/count widgets;
- native action-button registration;
- icon/count/cooldown/usability/range updates.

Primary keeps its proven:
- action-page orchestration;
- pending page refresh;
- primary binding-routing control.

### Secondary

Fixed:
- slots 61–72;
- `MULTIACTIONBAR1BUTTON1–12`;
- left 3 x 4 cluster;
- default key routing OFF.

### Utility

Fixed:
- slots 49–60;
- `MULTIACTIONBAR2BUTTON1–12`;
- right 3 x 4 cluster;
- default key routing OFF.

### Geometry

```text
Secondary      Primary       Utility
   3 x 4         4 x 3         3 x 4
```

Anchors:
- Secondary x=-190 y=-260;
- Primary x=0 y=-260;
- Utility x=190 y=-260.

Static weighting:
- Primary alpha 1.00;
- Secondary alpha 0.88;
- Utility alpha 0.76.

Dynamic visibility remains C.4.

## Key-routing controls

Developer panel now includes:
- Secondary Keys ON;
- Secondary Keys OFF;
- Utility Keys ON;
- Utility Keys OFF.

Each routing domain is independent.

Default is fail-open:
stock bindings are active until the user explicitly enables Logres routing.

Combat-time requests defer until `PLAYER_REGEN_ENABLED`.

## Diagnostics

`Action Check` now validates:
- Primary;
- Secondary;
- Utility;
- expected slot ranges;
- button registration;
- stock-bar non-suppression.

The control panel height is increased to keep the larger control set usable.

## Runtime proof

After deployment:
1. confirm version `0.0.16-dev`;
2. Run All / Action Check PASS;
3. confirm three-cluster constellation is visible;
4. verify Primary still works by mouse and key;
5. verify Secondary visually corresponds to stock Action Bar 2 slots/actions;
6. verify Utility visually corresponds to stock Action Bar 3 slots/actions;
7. mouse-click at least one safe action in Secondary;
8. mouse-click at least one safe action in Utility;
9. turn Secondary Keys ON and test any existing bound key;
10. turn Secondary Keys OFF and confirm routing releases;
11. turn Utility Keys ON/OFF and test equivalently;
12. verify cooldown/range/count/usability updates;
13. fight normally and verify secure mouse/key actions continue working;
14. report protected/taint/Lua/secret errors;
15. judge overlap/readability with Phase B HUD.

If no keys are currently bound to one of the selected stock multi-bars:
- do not fabricate a PASS;
- record keyboard true-path unavailable;
- a temporary normal WoW keybind may be assigned if convenient;
- stock UI remains available.

If slots 61–72 / 49–60 do not correspond to the expected Forever bars:
record the exact mismatch and correct D-019.

## Stock UI

No Blizzard action bar is suppressed.

Bars 4–8 remain outside the first C.3 proof.

## Exit

C.3 completes when both fixed-slot clusters are runtime-proven and Primary
remains regression-free.
