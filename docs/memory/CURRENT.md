---
memory_schema: 1
as_of: 2026-10-22
project: logres
---

# Current State

## Active Objective
Finalize the consistent Logres trainer experience with recoverable Blizzard native fallback and modular service-specific transactions/lifecycle. Then implement NPC gossip, merchants and flight masters, in that order.

## Current Work Item
**P0311 — profession Goodbye and read-only native filter context / PREPARED; WSL STATIC and WoW UNVERIFIED.** GitHub main P0310 `cb1a83f` verified. User supplied screenshots showing P0310 synthetic P empty preview and live Grimnur Fishing empty state, with Logres parchment, disabled row and usable Blizzard: **visual and auto-entry PASS**. P0311 adds separate profession-only guarded `CloseTrainer` after successful Logres dismissal/restoration, and a read-only, ordinary source-filter observation for empty sessions. No profession native parking or new action ownership is authorized.

## Verified State
- P0310 user-screenshot PASS: panel-integrated inert Trainer Empty Preview and live zero-source Fishing Logres shell. Native Blizzard remains visible. No transaction tested.
- P0309 Enchanting single service trained and learned through Logres USER PASS; class trainer operation user PASS. P0308 class Logres-only visibility and true native-close Goodbye PASS. Earlier class Train All and single training are scoped PASS; class purchase specifically while native frame parked remains UNVERIFIED.
- Fishing at Grimnur returned type 7, ordinary profession yes, total services 0. Native Blizzard frame nevertheless shows **Journeyman Fishing — Already known**. Therefore zero source rows do not prove unknown or fully learned professions. Other unowned profession cases remain UNTESTED.

## Next Action
Apply guarded P0311 on exact clean P0310 main. Require full 182-checker PREWRITE/POSTWRITE, `git diff --check`, manifest, user commit/push and independent main verification. Deploy and `/reload`. At a profession trainer with normal Logres open, click Goodbye; BOTH Logres and Blizzard should close, then reopen on next interaction. Confirm no native popup/taint/errors. In source-empty Fishing, filter hint appears only when ordinary Known filter is OFF; otherwise neutral text remains. Verify class Goodbye unaffected. No further purchase needed.

## Success Criteria
Separate ordinary profession-family/native frame/combat/API gates; at most one CloseTrainer request on explicit Goodbye AFTER the restoration-first `Trial.Disable` succeeds. Native Blizzard stock remains visible before Goodbye for professions, including empty sources. Source-filter reads never mutate Blizzard filters or imply a specific owned rank. Inert P fixture and exact live renderer/layout retained. No new panel action or hidden native click regions.

## Do Not Reopen Without New Evidence
Do not equate native `services=0` with profession ownership or lack thereof, infer a Learn Profession action, read protected/secret presentation values, or hide native profession information until equivalent source-backed coverage and restoration are proven. Do not generalize one Enchanting purchase to all professions. Keep prior historical patch/checker/runtime failures intact.

## Relevant References
- `docs/memory/evidence/P0311_PROFESSION_CLOSE_FILTER_CONTEXT.md`, `docs/memory/patches/P0311_PROFESSION_CLOSE_FILTER_CONTEXT.md`
- `docs/memory/evidence/P0310_TRAINER_EMPTY_CATALOGUE.md`, `docs/memory/evidence/P0309_PROFESSION_SINGLE_TRANSACTION.md`
- `docs/memory/decisions/D-046_PREVIEW_FIRST_UI_PIPELINE.md`, `docs/memory/decisions/D-047_SELECTIVE_NPC_PRESENTATION_AND_MODULARITY.md`
- `docs/memory/handoffs/CURRENT_HANDOFF.md`, `docs/memory/investigations/ACTIVE.md`, `docs/memory/roadmap/STATUS.md`, `docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md`, `docs/ROADMAP.md`, `docs/memory/patches/PATCH_INDEX.md`
