---
memory_schema: 1
as_of: 2026-10-22
project: logres
---

# Current State

## Active Objective
Finish the approved Logres trainer as the default service across verified trainer families, with reusable D-046/D-047 NPC components and reliable Blizzard fallback. Then implement gossip, merchants, flight masters, in that order.

## Current Work Item
**P0307 R1 — read-only profession trainer family diagnostic / PREPARED; WSL and WoW UNVERIFIED.** GitHub `main` verified P0306 `5acc447`. User reports class trainer opens Logres automatically with Blizzard whole-root parking working in-game; screenshot shows fishing trainer Grimnur Stonebrand remains stock-only. This is a cross-family behavior difference, not yet a proven defect: P0306 parking was intentionally authorized for class trainers only and P0301 bulk training explicitly excludes `IsTradeskillTrainer`. P0307 adds an opt-in H-panel read-only family audit, not speculative routing or buying. The first P0307 applier stopped PREWRITE: 178 prepared checkers versus an incorrect >=179 threshold; no tracked writes. R1 requires an exact baseline-plus-one checker filename set instead.

## Verified State
- User's P0306 screenshot: single visible Logres class-trainer panel; duplicate Blizzard window no longer seen. User: "Class trainer works as expected no issues." **Scoped P0306 native parking visual PASS**. Exact restoration lifecycle and a purchase while stock is parked are still not independently verified.
- User's Grimnur Stonebrand Fishing Trainer screenshot: stock Blizzard trainer visible; Logres trainer not shown. **Observed profession-family fallback**, not authorization to suppress or train from Logres.
- Earlier user-confirmed class single skill and Train All purchases, shared catalogue, hover, Goodbye, manual and automatic class-trainer entry retain their scoped PASS history. No fishing trainer purchase is claimed.
- D-046 source/fixture/view/interaction separation and D-047 selective NPC integration remain binding. Camera untouched.

## Next Action
Apply corrected P0307 R1 guarded archive to exact clean P0306 main with all PREWRITE/POSTWRITE `tools/check_*.py`, whitespace, version and manifest PASS. User commits/pushes; verify GitHub main; deploy/reload. At Grimnur with the stock Fishing Trainer open, `/logres panel` -> H — Integration and Polish -> **Trainer Family Check (READ-ONLY)**. Inspect the emitted normalized interaction type, `IsTradeskillTrainer` answer, native root readiness, service count, six-field API shape and NPC session status. Prefer the saved Logres diagnostics export if sharing detailed results. One parallel class-trainer check only if ambiguity remains. Use actual evidence to authorize a service-specific visual adapter reusing the accepted Logres landscape; keep profession purchases and native stock parking gated until separately proven.

## Success Criteria
One user-triggered bounded, non-mutating source-family diagnostic distinguishes a profession session mismatch from missing native source capability, without changing successful class-trainer UI, purchases, auto-open, native parking, Quest, synthetic previews or camera. No frame writes, polling, purchases, native hiding or broad hooks. A profession source that is absent/secret/protected is DEFERRED, not a fabricated pass.

## Do Not Reopen Without New Evidence
Do not treat the stock Fishing Trainer as proof all profession trainers are unsupported. Do not use the class bulk transaction controller for professions; it intentionally checks `IsTradeskillTrainer() == false`. Do not guess an interaction enum, inspect secret-capable values, hide stock controls before replacement, or redesign the accepted portrait-free translucent parchment. Preserve P0304 auto-entry failure and P0303 prewrite failure as historical evidence; no invented flight paths.

## Relevant References
- `docs/memory/evidence/P0307_TRAINER_FAMILY_DIAGNOSTIC.md`, `docs/memory/patches/P0307_TRAINER_FAMILY_DIAGNOSTIC.md`
- `docs/memory/evidence/P0306_TRAINER_NATIVE_PARKING.md`, `docs/memory/evidence/P0305_TRAINER_READY_EVENT_REPAIR.md`
- `docs/memory/decisions/D-046_PREVIEW_FIRST_UI_PIPELINE.md`, `docs/memory/decisions/D-047_SELECTIVE_NPC_PRESENTATION_AND_MODULARITY.md`
- `docs/memory/handoffs/CURRENT_HANDOFF.md`, `docs/memory/investigations/ACTIVE.md`, `docs/memory/roadmap/STATUS.md`, `docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md`, `docs/ROADMAP.md`, `docs/memory/patches/PATCH_INDEX.md`
