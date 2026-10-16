---
memory_schema: 1
as_of: 2026-10-16
project: logres
---

# Current State

## Active Objective
Phase H.3: translate all twelve approved sheets from `docs/design/approved/` into production visuals without re-opening accepted P0214–P0216 treatments. D-039 and D-045 v4 are authoritative. P0216 is verified on `main` at `905c847`; user confirms action-cluster transparency, wider player-resource bar and clear completion ornament look great, with later all-screen refinement deferred.

## Current Work Item
**P0217 visual candidate**, version `0.0.126-dev`: harmonize the six top-right native-access tabs and three PET STOCK/BUFFS/TARGET fallback buttons using sheet-03-derived small bronze frame TGA assets; add restrained target-name and pet/ally-row authored hairlines and distinguish pet from other ally names. No change to button hitboxes, callbacks, control policy, unit sources, percentage values, H.2 v4 anchors, accepted P0214 action art, P0215 quest/bar images, P0216 improvements, or Blizzard interaction/suppression rules.

## Verified State
- GitHub `main` `905c847` (P0216) verified. User screenshot accepts visual changes. Uploaded `0.0.125-dev` loadCount 286: out-of-combat Run All completes, Layout 13/13 measured, Action Check PASS, native access PASS, Active Quest `complete=true ready=true`, UI ownership 17 PASS/18 intentionally STOCK/0 FAIL. No WoW runtime evidence for P0217 yet.
- Last screenshots: top-right native dock remains flat text tabs with stock red-look fallback buttons; target and pet/ally labels use basic tint with no linked authored ornament. These are **visual gaps**, not failures of unit/data or stock fallback ownership.
- P0215 R0 prewrite memory-heading failure remains recorded; P0211 pet native duplicate resolution accepted only for tested states. Historical protected/combat/aura failures and deferrals remain in prior evidence.

## Next Action
Apply guarded P0217 on pushed P0216, run complete `tools/check_*.py` shadow suite and `git diff --check`. Deploy to WoW and `/reload`. Developer panel: Phase H Native Access Check, H.2 Map / Layout Check; Phase B HUD Check, Phase C Action Check, Phase 0 Run All. Visually check top-right six tabs and three native fallback controls, including click/open/return behavior, target/pet/ally rows without clipped text, pet targeting and Immersion OFF/ON. If no actual party, group appearance remains environmentally deferred. Report failure before committing.

## Success Criteria
- Dock uses restrained authored bronze control frames rather than bare flat rectangles / Blizzard red generic button textures; PET STOCK, BUFFS and TARGET remain visible, clickable, and fail-open to usable Blizzard presentation.
- Enemy name remains sparse above its percent bar; pet/ally name accents readable at default UI scale without adding exact HP, level, classification, or restricted source queries.
- No changed placement, bar geometry or protected action, and no Lua/secret/taint/regression observed in tested contexts.

## Do Not Reopen Without New Evidence
P0211 pet secure startup ownership, P0214 action-button art, P0215/P0216 quest/resource styles, screen-map v4 anchors, combat-native fallback, aura membership, class mechanics, or secret-derived values. Do not infer untested runtime PASS from static checks.

## Relevant References
- `docs/memory/evidence/P0217_H3_NATIVE_DOCK_TARGET_ALLY_ART.md`
- `docs/memory/patches/P0217_H3_NATIVE_DOCK_TARGET_ALLY_ART.md`
- `docs/design/approved/README.md`
- `docs/memory/decisions/D-039_APPROVED_VISUAL_BASELINE.md`
- `docs/memory/decisions/D-040_PRODUCTION_VISUAL_ASSET_TRANSLATION_CONTRACT.md`
- `docs/memory/decisions/D-045_H2_SCREEN_MAP_V4.md`
- `docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md`
