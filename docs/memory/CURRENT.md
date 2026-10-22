---
memory_schema: 1
as_of: 2026-10-22
project: logres
---

# Current State

## Active Objective
Restore visible live trainer spell icons after P0297's dark-backplate regression without modifying native trainer data, selected-service identity, purchasing, or the accepted preview composition.

## Current Work Item
**P0298 — LIVE TRAINER ICON DRAW-LAYER ISOLATION / PREPARED; WSL AND WOW UNVERIFIED.** GitHub main P0297 `aea974a` independently verified pushed. User screenshot (`0.0.198-dev`) establishes **P0297 RUNTIME ICON FAIL:** most or all live spell list icons and selected detail icon appear nearly black after changing gold backing to opaque dark parchment. The icons were at least partly visible in P0296 despite two intermittent yellow/gold boxes. Source shows backing, icon art and four overpainted edge textures all created at `ARTWORK` with unspecified sublevels. P0298 separates ONLY live spell artwork into explicit BACKGROUND/OVERLAY sublayers, keeping the original texture IDs and frame geometry; this is a targeted layering hypothesis, not runtime proof.

## Verified State
- **P0297 pushed `aea974a` / USER VISUAL FAIL:** live trainer icon imagery now nearly black; names/costs/selected details still appear, Blizzard stock icons normal. Cause may include invalid/translucent native art; do not assume layering is the complete cause.
- **P0296 pushed `1a75351` / ONE USER-REPORTED PURCHASE PASS:** Blizzard list and funds changed consistently with a 6s purchase; other transactions remain untested. P0295 local selection, local filtering and wheel scrolling were user-confirmed.
- P0296 gold/yellow icons on two entries, slider drag/track behavior and the noninteractive `Visible services` category are still OPEN. Earlier failure records remain authoritative.

## Next Action
Apply the P0298 guarded ZIP on exact clean P0297 `aea974a`; require full PREWRITE/POSTWRITE check suites, version/memory/whitespace gates and manifest. User commits/pushes; verify remote. Deploy and `/reload`, open ordinary trainer and use `/logres panel` → H — Integration and Polish → Live Trainer ON (TEST). Compare live spell and selected-detail icons to Blizzard stock for several available and unavailable skills. Test local selection/filter/wheel, OFF and trainer close. Do not perform another purchase. If icons are still black, record the negative result and investigate bounded native texture IDs and rendering in a separate read-only diagnostic.

## Success Criteria
Live spell artwork is visible in front of its backing with thin gold edges; all P preview icons remain unchanged. P0295/P0296 filtering, wheel/slider, selected details and single-skill purchase code remain intact, and stock UI remains usable. Static PASS does not imply WoW visual PASS.

## Do Not Reopen Without New Evidence
No speculative polling, texture-ID reinterpretation, blanket native suppression, protected mutation or repeated purchases. Do not claim icon recovery until visually confirmed. Preserve P0297 total-icon-loss FAIL and P0296 intermittent gold-box FAIL independently.

## Relevant References
- `docs/memory/evidence/P0298_TRAINER_ICON_DRAW_LAYERS.md`, `docs/memory/patches/P0298_TRAINER_ICON_DRAW_LAYERS.md`
- `docs/memory/evidence/P0297_TRAINER_ICON_BACKPLATE.md`, `docs/memory/evidence/P0296_TRAINER_SCROLL_TRAIN_TEST.md`
- `docs/memory/decisions/D-046_PREVIEW_FIRST_UI_PIPELINE.md`, `docs/memory/decisions/D-047_SELECTIVE_NPC_PRESENTATION_AND_MODULARITY.md`
- `docs/memory/handoffs/CURRENT_HANDOFF.md`, `docs/memory/investigations/ACTIVE.md`, `docs/memory/roadmap/STATUS.md`, `docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md`, `docs/ROADMAP.md`, `docs/memory/patches/PATCH_INDEX.md`
