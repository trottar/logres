---
memory_schema: 1
as_of: 2026-10-22
project: logres
---

# Current State

## Active Objective
Finish default trainer presentation with a verified event-driven NPC session, then establish safe Blizzard presentation restoration. Preserve the accepted portrait-free trainer and shared NPC foundations. After trainer: native gossip, merchant, flight master.

## Current Work Item
**P0305 — TRAINER READINESS EVENT REPAIR / PREPARED; WSL AND WOW UNVERIFIED.** GitHub main P0304 `a493b9f` verified pushed. User reports automatic Logres opening FAIL when interacting with a trainer normally; manual H Live Trainer ON still works. P0304 session attempted opening during normalized interaction changes and native OnShow, but a lazy native trainer may not yet exist/be shown when the first callback runs, and native frame creation may miss initial OnShow hooking. P0305 adds source-scoped TRAINER_SHOW and TRAINER_UPDATE readiness reconciliation plus a bounded audit. Hypothesis remains UNVERIFIED until a normal in-game interaction succeeds.

## Verified State
- P0303 at `4f7f9b5` was pushed and user-confirmed no regression in search/filter/selection/scroll/hover/Goodbye or previously tested transactions.
- P0304 `a493b9f` is pushed but **AUTO OPEN RUNTIME FAIL**: user reports no Logres panel on ordinary trainer interaction. H manual activation remains working; no screenshot or audit of readiness events yet. Do not call P0304 automatic entry PASS.
- Previously confirmed user runtime scope: single and Train All purchases, icons, selection, local filtering, search, scroll and hover. Do not require new purchases to test an entry fix.
- Blizzard ClassTrainerFrame must remain shown for the current native service and purchase guards. P0305 performs no native hiding, alpha mutation, protected setter, camera or transaction change.

## Next Action
Apply P0305 guarded ZIP on exact clean P0304 `a493b9f`, requiring full shadow PREWRITE/POSTWRITE checker suites, version/memory/whitespace validation and manifest. User commits/pushes, then verify remote main. Deploy and `/reload`, visit a trainer normally **without H ON**. Logres should open once alongside stock. Check Goodbye suppresses re-entry for the visit, and close/reopen trainer starts a fresh session; H ON/OFF must still work. If auto entry still fails, gather `Logres.NPCServiceSession.GetAudit()` through existing diagnostics and mark runtime FAIL rather than adding speculative polling.

## Success Criteria
P0305 bridges the verified Forever TRAINER_SHOW/TRAINER_UPDATE readiness events to the existing service-neutral session without timers or broad frame hooks. Trainer is auto-opened at most once when native is actually ready; unmatched/unsupported state leaves stock UI fully usable. Per-visit dismissal, combat and stock fallback unchanged. UI visuals, P fixture, source snapshots and purchases unchanged.

## Do Not Reopen Without New Evidence
Do not suppress Blizzard stock root before proving safe recovery and continued native service access. Do not count a static pass as runtime success or replace missed signals with C_Timer, OnUpdate or blanket OnShow reassertion. Preserve P0304 runtime failure and earlier R0 static failures; do not fabricate a specific client event order from the reported symptom alone.

## Relevant References
- `docs/memory/evidence/P0305_TRAINER_READY_EVENT_REPAIR.md`, `docs/memory/patches/P0305_TRAINER_READY_EVENT_REPAIR.md`
- `docs/memory/evidence/P0304_NPC_SESSION_AUTO_TRAINER.md`, `docs/memory/evidence/P0303_NPC_SERVICE_CATALOGUE.md`
- `docs/memory/decisions/D-046_PREVIEW_FIRST_UI_PIPELINE.md`, `docs/memory/decisions/D-047_SELECTIVE_NPC_PRESENTATION_AND_MODULARITY.md`
- `docs/memory/handoffs/CURRENT_HANDOFF.md`, `docs/memory/investigations/ACTIVE.md`, `docs/memory/roadmap/STATUS.md`, `docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md`, `docs/ROADMAP.md`, `docs/memory/patches/PATCH_INDEX.md`
