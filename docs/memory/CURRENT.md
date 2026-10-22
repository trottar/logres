---
memory_schema: 1
as_of: 2026-10-21
project: logres
---

# Current State

## Active Objective
Add bounded, Logres-owned filtering and scrolling to the accepted read-only trainer landscape while keeping native trainer source filters, selection and transactions Blizzard-owned. The visual fixture remains accepted; no protected replacement is authorized.

## Current Work Item
**P0293 — LOCAL TRAINER SAMPLE BROWSING / PREPARED; WSL AND WOW UNVERIFIED.** GitHub `main` verified at P0292 `a58cf78`. User screens with and without Blizzard's Unavailable filter show P0292 live name, identity, rank, icon, cost and status fidelity; two native-filter source cases are visually correct. P0292 does not provide Logres-controlled filtering or scroll past the initial seven rows. P0293 retains one guarded snapshot (up to 64 source entries), lets users locally toggle All sampled / Available only, and wheel/arrow-scroll a reusable seven-row window. The source set still reflects Blizzard's CURRENT native filter settings; Logres never changes those settings. No Logres selection or purchase interactions.

## Verified State
- **P0292 pushed `a58cf78` / user screenshots LIVE READ-ONLY PARTIAL PASS:** Briarthorn trainer name, ranks, costs, prerequisite abilities, statuses and description appear; native Unavailable filter ON/OFF yields different source counts. No screenshot establishes clicking native purchase through Logres, full trainer enumeration, or protected replacement.
- **P0291 pushed `0afc236` / data PASS:** Forever six-tuple and bounded optional ability requirements supported. Earlier P0285–P0287 tuple assumptions were wrong; failure evidence is preserved.
- **P0290 R0 and R1 implementation-package FAIL:** memory size and diff EOF errors respectively; R2 guarded prewrite whitespace. P0289 R0 linked registry checker FAIL; R1 corrected first-page H Live Trainer ON/OFF. Details are in archived evidence.

## Next Action
Apply P0293 guarded ZIP on exact pushed P0292 main. Require prewrite 164+ checks, postwrite checks and git diff --check. User commits/pushes, then verify remote. Deploy to WoW and `/reload`; at a trainer use `/logres panel` → H → Live Trainer ON (TEST). Mouse-wheel the Logres list, use its scroll rail arrows and toggle the small Filters control between All sampled and Available only. Compare against unchanged Blizzard window. Finish with Live Trainer OFF. No general audit or forced purchase.

## Success Criteria
The single source snapshot can display rows 8+ without remaking a panel and hide unavailable entries locally. Only Logres-owned narrow filter and list interaction regions receive mouse input; Blizzard's window/filter/Train/Train All remain unchanged and available. Parent trainer landscape remains noninteractive elsewhere and recovers on trainer close/combat/world change. Secret gating and identity/index mapping persist. Static checks are not runtime PASS.

## Do Not Reopen Without New Evidence
Do not infer that Logres's All sampled can restore entries hidden by a Blizzard filter. Do not map row positions to native service indices, intercept protected training, replace native controls, poll, or suppress Blizzard stock UI. Preserve reported environmental/runtime failures and any observed taint.

## Relevant References
- `docs/memory/handoffs/CURRENT_HANDOFF.md`
- `docs/memory/evidence/P0293_TRAINER_LOCAL_BROWSE.md`, `docs/memory/patches/P0293_TRAINER_LOCAL_BROWSE.md`
- `docs/memory/evidence/P0292_TRAINER_INFORMATION_COMPLETENESS.md`, `docs/memory/evidence/P0290_TRAINER_PARTIAL_SOURCE_RECOVERY.md`
- `docs/memory/decisions/D-046_PREVIEW_FIRST_UI_PIPELINE.md`, `docs/memory/decisions/D-047_SELECTIVE_NPC_PRESENTATION_AND_MODULARITY.md`
- `docs/memory/investigations/ACTIVE.md`, `docs/memory/roadmap/STATUS.md`, `docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md`, `docs/memory/patches/PATCH_INDEX.md`, `docs/ROADMAP.md`
