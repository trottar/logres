---
memory_schema: 1
as_of: 2026-10-22
project: logres
---

# Current State

## Active Objective
Complete the Logres live trainer's local catalogue navigation while keeping Blizzard's native bulk training and stock controls usable. Preserve visually accepted P0298 icons and guarded single-service purchase.

## Current Work Item
**P0299 — LIVE LOCAL TRAINER SEARCH / PREPARED; WSL AND WOW UNVERIFIED.** GitHub main P0298 `be13ce1` is verified pushed. User screenshot and report support **P0298 ICON RECOVERY VISUAL PASS** and working local selection, filter, scrolling and tested single-service training. User identifies search and Train All as remaining nonfunctional features. Search is currently a decorative `Search (stock)` label; `Visible services` is an inert category placeholder. P0299 adds a live-only mouse/keyboard EditBox with 48-character bounded, case-insensitive plain substring filtering of the **already captured** native service names, composed with the local Available filter and seven-row scroll. It relabels the inert sidebar `Sampled skills`, without pretending it is a selectable category. Hidden selected skill persists and restores when matching; training is disabled while that skill is excluded by the current local filters. Preview P remains inert.

## Verified State
- **P0298 pushed `be13ce1` / USER VISUAL PASS:** screenshot shows restored native texture art on live list and detail icons after P0297 layer regression. P0297 missing/black icon FAIL remains historical evidence.
- **P0296 LIMITED SINGLE-SERVICE PURCHASE PASS:** user reports successful purchase and previous before/after Blizzard list and funds corroborate 6s spent. This does not authorize Train All.
- Local selection, details, All/Available filtering, and wheel scrolling are user-confirmed. Slider thumb drag/track, every teardown path, and full training coverage are not independently established.
- **OPEN:** native/Logres Train All safety and behavior unverified. Blizzard's own Train All remains available; Logres Train All stays disabled. Live `Visible services` was a noninteractive placeholder, not source categories.

## Next Action
Apply P0299 ZIP against clean pinned P0298 `be13ce1`; full prewrite/postwrite `tools/check_*.py` suite, whitespace, memory and version policy, manifest and `git diff --check`. User commits/pushes; verify main. Deploy and `/reload`; at trainer use `/logres panel` → H — Integration and Polish → Live Trainer ON (TEST). Type case-insensitive fragments, combine search with Available only, test no-match, clear/escape/enter, wheel/slider, selected-details continuity and train-action suppression when filtered out. Test H OFF/trainer close with focus. Blizzard stock and Train All remain usable; no further purchase needed.

## Success Criteria
One owned EditBox filters copied trainer spell names only, never touches native filters or service APIs, never changes native service identity, updates seven live rows synchronously, clamps slider offset and removes unused hit regions. Hidden selections recover when the filter is cleared. P fixture, icon art, one-service purchase guard and stock fallback unchanged. Static checks are not WoW PASS.

## Do Not Reopen Without New Evidence
No automated Train All or loop of `BuyTrainerService`, no native filter writes, polling, protected region changes, invented trainer category taxonomy or false claims about scroll/transaction completeness. Preserve P0294 click failure, P0295 rail failure, P0296 gold blocks and P0297 black icons.

## Relevant References
- `docs/memory/evidence/P0299_TRAINER_LOCAL_SEARCH.md`, `docs/memory/patches/P0299_TRAINER_LOCAL_SEARCH.md`
- `docs/memory/evidence/P0298_TRAINER_ICON_DRAW_LAYERS.md`, `docs/memory/evidence/P0296_TRAINER_SCROLL_TRAIN_TEST.md`
- `docs/memory/decisions/D-046_PREVIEW_FIRST_UI_PIPELINE.md`, `docs/memory/decisions/D-047_SELECTIVE_NPC_PRESENTATION_AND_MODULARITY.md`
- `docs/memory/handoffs/CURRENT_HANDOFF.md`, `docs/memory/investigations/ACTIVE.md`, `docs/memory/roadmap/STATUS.md`, `docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md`, `docs/ROADMAP.md`, `docs/memory/patches/PATCH_INDEX.md`
