---
memory_schema: 1
as_of: 2026-10-22
project: logres
---

# Current State

## Active Objective
Complete default Logres trainer presentation and recoverable Blizzard native UI replacement, preserving the approved landscape. Then native gossip, merchant, flight master, reusing D-046/D-047 NPC infrastructure.

## Current Work Item
**P0304 — event-driven shared NPC session and default trainer entry / PREPARED, full WSL and WoW runtime UNVERIFIED.** Verified GitHub main P0303 `4f7f9b5`; user reports the catalogue extraction still works in-game (**scoped P0303 regression PASS**). P0304 introduces a service-neutral NPC presentation lifecycle: trainer opens automatically on guarded native frame OnShow or normalized interaction state, with a per-visit Goodbye/OFF dismissal gate. Blizzard trainer remains visible and interactive in this checkpoint. This is NOT native suppression or full production replacement.

## Verified State
- Verified P0303 pushed at `4f7f9b59a5a12fd485094054a9fad748e7762cca`; user states all previously tested trainer features still work. Prior P0303 R0 PREWRITE failure 2/174 was repaired by R1 and remains recorded.
- User-confirmed Trainer single-skill purchase and full Train All purchase; search, filters, selected details, icon paint, seven-row browse, hover and Goodbye also passed their exercised runtime cases. Longer sessions, all filter/slider and protected transitions remain unverified.
- `NPCServiceCatalogue.Filter/Window/Find` are now shared with the trainer. D-046 requires the same fixture/render pipeline; D-047 requires modular NPC service adapters and fail-open stock. Current layout is accepted; no portraits or invented new UI designs.
- Blizzard ClassTrainerFrame remains visible in P0303. Existing single/bulk purchase guards require its `IsShown()==true`. No evidence yet supports hiding the native root while retaining those transactions.

## Next Action
Apply P0304 guarded ZIP on exact clean P0303 main; require all PREWRITE/POSTWRITE static checkers, memory headings, LF/EOF, whitespace and manifest PASS. User commits/pushes, verify new main. Deploy and `/reload`; open class trainer without clicking H Live Trainer ON. Confirm automatic Logres display beside working stock, search, scroll and selection. Goodbye and H OFF should dismiss Logres for that NPC visit and must not re-open on ordinary state changes; close/reopen trainer should display Logres again. Check combat/transition when naturally encountered, without contrived gameplay. After runtime proof, implement a separately capability-gated native stock visual parking/hide-restoration trial before enabling default suppression.

## Success Criteria
Event-driven single-service auto entry and per-visit dismissal with no polling, native frame setter, speculative camera changes, or new purchase APIs. Defer safely if native UI is unavailable, protected, hidden or in combat. Existing manual H controls, shared preview/live renderer, purchase guard and Blizzard full stock fallback remain intact.

## Do Not Reopen Without New Evidence
Do not call P0304 full Blizzard replacement or claim safe hidden-native purchases. Never conceal an unproven native frame using alpha-only invisible clickable children or persistent OnShow re-hide hooks. Preserve all historical negative evidence and explicit user-approved trainer appearance. NPC sequence after trainer: native gossip, then merchants, then flight masters.

## Relevant References
- `docs/memory/evidence/P0304_NPC_SESSION_AUTO_TRAINER.md`, `docs/memory/patches/P0304_NPC_SESSION_AUTO_TRAINER.md`
- `docs/memory/evidence/P0303_NPC_SERVICE_CATALOGUE.md`, `docs/memory/evidence/P0301_TRAINER_BULK_TRANSACTION.md`
- `docs/memory/decisions/D-046_PREVIEW_FIRST_UI_PIPELINE.md`, `docs/memory/decisions/D-047_SELECTIVE_NPC_PRESENTATION_AND_MODULARITY.md`
- `docs/memory/handoffs/CURRENT_HANDOFF.md`, `docs/memory/investigations/ACTIVE.md`, `docs/memory/roadmap/STATUS.md`, `docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md`, `docs/ROADMAP.md`, `docs/memory/patches/PATCH_INDEX.md`
