---
memory_schema: 1
as_of: 2026-10-21
project: logres
---

# Current State

## Active Objective
Implement Logres-owned local skill selection within the accepted live trainer landscape while preserving Blizzard selection, filters, transactions, and stock UI. Native replacement is not authorized.

## Current Work Item
**P0294 — LOCAL TRAINER SELECTION / PREPARED; WSL AND WOW UNVERIFIED.** GitHub main P0293 `5e50fd2` is verified pushed. User confirmed local filter operation, seven visible rows, native-selected detail correspondence and source fidelity. Scrolling beyond seven is NOT conclusively verified from screenshots. P0294 adds seven narrow live-only click regions, service-index-stable selection, and immediate in-place detail icon/name/requirements/description updates. Hidden filtered selections retain details; returning to a row restores its highlight. Shared P fixture stays inert.

## Verified State
- **P0293 pushed `5e50fd2` / USER RUNTIME PARTIAL PASS:** All sampled / Available only filters work; seven-row layout and source fidelity observed. Scrolling past row 7 lacks conclusive screenshot confirmation. Blizzard native selection/transactions remain authoritative.
- **P0292 pushed `a58cf78` / user read-only partial PASS:** native identity, rank, abilities, availability labels and cost fidelity with native-filter-dependent source. P0291 Forever six-tuple corrected source interpretation.
- P0290 R0/R1 and P0289 R0 patch failures remain preserved in historical evidence; no failure record is removed by this checkpoint.

## Next Action
Apply guarded P0294 ZIP on exact clean P0293 main. Require complete PREWRITE/POSTWRITE checker suites, candidate whitespace, `git diff --check` and manifest. User commits/pushes and assistant verifies remote before advancing. Deploy and `/reload`; with a trainer open use `/logres panel` → H → Live Trainer ON (TEST). Click rows, observe detail and native selection independence; verify scroll, filters, hidden selection continuity, empty state, arrow movement and Live Trainer OFF. Preserve unverified runtime cases explicitly.

## Success Criteria
Logres row clicks select local catalogue identity and synchronously refresh row highlight/detail data, including after filter/scroll, without calling `SelectTrainerService` or native purchase/filter APIs. The stock trainer remains usable; disabled/no-match rows and teardown leave no interactive invisible regions. Selection click regions are restricted to sampled visible rows and inactive in P preview. Static checks alone do not certify WoW behavior.

## Do Not Reopen Without New Evidence
No guessed native category eligibility, protected transaction controls, portrait, polling or blanket stock suppression. P0294 does not make rows excluded by Blizzard's source filter available. No native selection synchronization or purchases; avoid secret-capable value inspection and unsourced runtime PASS.

## Relevant References
- `docs/memory/handoffs/CURRENT_HANDOFF.md`, `docs/memory/evidence/P0294_TRAINER_LOCAL_SELECTION.md`, `docs/memory/patches/P0294_TRAINER_LOCAL_SELECTION.md`
- `docs/memory/evidence/P0293_TRAINER_LOCAL_BROWSE.md`, `docs/memory/decisions/D-046_PREVIEW_FIRST_UI_PIPELINE.md`, `docs/memory/decisions/D-047_SELECTIVE_NPC_PRESENTATION_AND_MODULARITY.md`
- `docs/memory/investigations/ACTIVE.md`, `docs/memory/roadmap/STATUS.md`, `docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md`, `docs/ROADMAP.md`, `docs/memory/patches/PATCH_INDEX.md`
