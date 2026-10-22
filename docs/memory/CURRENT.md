---
memory_schema: 1
as_of: 2026-10-22
project: logres
---

# Current State

## Active Objective
Restore Logres-owned local skill clicking in the accepted live trainer landscape, with catalogue-identity detail updates, native Blizzard transaction ownership and fail-open fallback. No native trainer replacement is authorized.

## Current Work Item
**P0295 — LIVE ROW INPUT PRIORITY REPAIR / PREPARED; WSL AND WOW UNVERIFIED.** Verified GitHub `main` P0294 `43802394`. User screenshots show **P0294 RUNTIME PARTIAL PASS / SELECTION FAIL**: filters toggle between 64 sampled and 5 available; list scrolling works; clicking Logres spell rows does not select. P0294 added separate row hit frames without establishing priority over the existing full-list mousewheel frame. The overlapping input layer is a source-supported hypothesis, not yet proven as the sole runtime cause. P0295 makes the row hit regions children of that wheel surface, with explicit addon-owned frame levels above the wheel and rendered rows. No data model or transaction API changes.

## Verified State
- **P0294 pushed `43802394` / USER RUNTIME SELECTION FAIL:** Local All sampled / Available only filtering PASS; scrolling PASS by user report; row clicks FAIL. No claim of purchase, native interaction, or lifecycle replacement. Existing native selection still determines the initial detail pane.
- **P0293 pushed `5e50fd2` / USER RUNTIME PARTIAL PASS:** 64-row snapshot, native source fidelity, seven visible rows and local filtering. Native filters limit the source before Logres samples it.
- **Sidebar category gap OPEN:** `Visible services` is a noninteractive placeholder in the live adapter. True source-backed grouping is not implemented; synthetic P categories remain visual fixtures.

## Next Action
Apply guarded P0295 ZIP against exact clean P0294 `43802394`; require full PREWRITE and POSTWRITE static suite, memory and version-policy checks, candidate whitespace check, manifest and `git diff --check`. User pushes; independently verify new main. Deploy and `/reload`; use `/logres panel` → H — Integration and Polish → Live Trainer ON (TEST). Click at least three different rows, check immediate selected highlight and detail text/icon, wheel on rows, arrows, filter transitions, OFF and trainer close. Blizzard's trainer selected skill and transactions must stay unchanged. No forced purchases/combat.

## Success Criteria
Addon-owned row regions receive clicks ahead of the list-wheel surface while retaining wheel input, using native service identity rather than row offset. Hidden-filtered selection persists and restores highlight. Zero native selection/filter/purchase writes; no interactive hit regions after OFF or native context exit. Synthetic P remains inert. Static PASS is not runtime PASS.

## Do Not Reopen Without New Evidence
Do not fix input with polling, blanket Blizzard suppression, protected frame mutation, native service selection or invented purchases. Do not mistake the `Visible services` placeholder for genuine categorization. Preserve the failure in P0295 evidence and verify in WoW before advancing.

## Relevant References
- `docs/memory/evidence/P0295_TRAINER_ROW_HIT_PRIORITY.md`, `docs/memory/patches/P0295_TRAINER_ROW_HIT_PRIORITY.md`
- `docs/memory/evidence/P0294_TRAINER_LOCAL_SELECTION.md`, `docs/memory/evidence/P0293_TRAINER_LOCAL_BROWSE.md`
- `docs/memory/decisions/D-046_PREVIEW_FIRST_UI_PIPELINE.md`, `docs/memory/decisions/D-047_SELECTIVE_NPC_PRESENTATION_AND_MODULARITY.md`
- `docs/memory/handoffs/CURRENT_HANDOFF.md`, `docs/memory/investigations/ACTIVE.md`, `docs/memory/roadmap/STATUS.md`, `docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md`, `docs/ROADMAP.md`, `docs/memory/patches/PATCH_INDEX.md`
