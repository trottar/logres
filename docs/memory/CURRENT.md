---
memory_schema: 1
as_of: 2026-10-22
project: logres
---

# Current State

## Active Objective
Finish the tested Logres class-trainer replacement safely while extracting service-neutral NPC primitives. After trainer completion, implement native gossip first, merchant second, flight master third, all using the approved Logres trainer visual vocabulary.

## Current Work Item
**P0303 R1 — NPC catalogue extraction / PREPARED; WSL and WoW UNVERIFIED.** Verified GitHub `main` is P0302 `05f8afc`. User reports P0302 hover PASS and successful real Train All purchase of every offered spell: **scoped P0301 bulk-transaction runtime PASS** (user report). P0303 extracts addon-owned filtering, bounded windowing and stable identity lookup into a neutral module. No new visual or native frame changes.

## Verified State
- P0303 R0 stopped before tracked writes: 2/174 PREWRITE checkers failed (trainer TOC adjacency and evidence UNVERIFIED marker). R1 fixes both; no static or WoW PASS inferred.
- Trainer search, filter, seven-row scrolling, local selection/details, spell art, single purchase, Train All, hover and Goodbye were user-confirmed within tested scopes.
- The earlier P0301 screenshot verified the quote against Blizzard (four skills, 39s); latest user independently confirms actual Train All acquisition. No complete transaction audit or all edge cases is inferred.
- Blizzard's trainer window currently remains visible alongside the explicitly activated H live trial; default opening/suppression and safe stock recovery remain OPEN.
- D-046 fixture/model/shared-renderer/guarded-source/interaction and D-047 selective NPC integration rules remain authoritative. Accepted visual design is the existing portrait-free landscape, not new mockups.

## Next Action
Apply guarded P0303 to exact clean P0302 main. Require full prewrite/postwrite `tools/check_*.py`, version, memory, EOF and `git diff --check` PASS, then user commit/push and remote verification. Deploy/reload and verify no regression in trainer search, All/Available, row/slider browsing, selected details, hover, Goodbye and native stock. After PASS implement automatic trainer presentation and capability-gated native stock suppression/restoration, retaining stock fallback. Then proceed to gossip, merchant, flight master.

## Success Criteria
`NPCServiceCatalogue.Filter/Window/Find` are source-neutral and used by trainer without new native reads; service indices remain independent of visible offsets. P fixture, seven-row visuals, click regions, search, costs, purchases, combat deferrals and Blizzard stock behavior unchanged. Runtime PASS is required for graduation, not just static checks.

## Do Not Reopen Without New Evidence
Do not redesign approved trainer art, introduce portraits, hide Blizzard's trainer while dependent native data/transaction capabilities are unproved, invent flight routes, or copy speculative generic NPC UI. Preserve recorded negative evidence and unverified lifecycle/slider cases; no polling/unsafe protected or secret-value inspection.

## Relevant References
- `docs/memory/evidence/P0303_NPC_SERVICE_CATALOGUE.md`, `docs/memory/patches/P0303_NPC_SERVICE_CATALOGUE.md`
- `docs/memory/evidence/P0302_TRAINER_HOVER_FEEDBACK.md`, `docs/memory/evidence/P0301_TRAINER_BULK_TRANSACTION.md`
- `docs/memory/decisions/D-046_PREVIEW_FIRST_UI_PIPELINE.md`, `docs/memory/decisions/D-047_SELECTIVE_NPC_PRESENTATION_AND_MODULARITY.md`
- `docs/memory/handoffs/CURRENT_HANDOFF.md`, `docs/memory/investigations/ACTIVE.md`, `docs/memory/roadmap/STATUS.md`, `docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md`, `docs/ROADMAP.md`, `docs/memory/patches/PATCH_INDEX.md`
