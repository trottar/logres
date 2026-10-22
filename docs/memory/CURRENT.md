---
memory_schema: 1
as_of: 2026-10-22
project: logres
---

# Current State

## Active Objective
Complete Logres-owned trainer transactions and prepare an evidence-backed native presentation replacement while preserving usable Blizzard stock fallback.

## Current Work Item
**P0301 — GUARDED CLASS-TRAINER TRAIN ALL / PREPARED; WSL AND WOW UNVERIFIED.** Verified GitHub main P0300 `73e3396` pushed. User confirms the Quest-style trainer Goodbye is visible and working. Existing live trainer icons, name search, local filters, selection, seven-row navigation and one user-observed single-skill purchase work within the tested scope. P0301 adds explicit live-only Train All through a separately guarded bulk controller; no native frame suppression is included. This replaces the earlier blanket deferral with a concrete, user-initiated capability test.

## Verified State
- P0300 Goodbye USER PASS; current GitHub baseline `73e3396`. The P0300 memory-health R0 failure and R1 repair remain recorded.
- P0299 search/filter USER PASS; P0298 icons USER PASS; P0295 local selection USER PASS; one P0296 single-service purchase USER PASS. Not every teardown, slider gesture or multi-service purchase is proven.
- External WoW Forever addon `tweaks-forever` has a source-backed class-trainer Train All that iterates available `BuyTrainerService(index)` requests. Logres independently guards the full native list, same NPC, non-profession trainer, bounded service identity, costs and funds. This is engineering evidence, not P0301 runtime PASS.
- Blizzard stock Train All remains available; Logres still does NOT own hidden/protected native fallback or native UI suppression.

## Next Action
Apply P0301 guarded ZIP against exact clean P0300 `73e3396`; full candidate checker suite before and after writes, whitespace/memory/version gates and manifest. User commits/pushes; independently verify main. Deploy and `/reload`, trainer → `/logres panel` → H — Integration and Polish → Live Trainer ON (TEST). Confirm live Train All quote/count/cost versus stock, class trainer only, deliberate click and native result only if user actually wishes to purchase all offered skills. Check changed-source/funds deferral and stock fallback when feasible without contrived gameplay. Any Lua/taint/secret error is a failure and must be recorded before advancing. After bulk runtime proof, next gate is native presentation suppression/restoration, not another generic data audit.

## Success Criteria
Complete bounded native class-trainer quote and one user-initiated Train All request; no automatic invocation, retries, profession purchases, invisible stock clicks, native selection/filter writes or polling. Fresh quote and every purchase revalidate trainer and service identity/cost/funds. Stop on changed state, record partial requests and retain Blizzard UI. Preserve all existing single-skill, search, rendering and inert P-preview behavior.

## Do Not Reopen Without New Evidence
Never claim atomic, server-confirmed bulk training from a successful Lua pcall. Never hide Blizzard trainer until secure interaction/recovery is separately proved. No automatic purchases, guessed native categories, protected mutation, unsupported timer-driven retry or stock frame reparenting. Keep historical negative results intact.

## Relevant References
- `docs/memory/evidence/P0301_TRAINER_BULK_TRANSACTION.md`, `docs/memory/patches/P0301_TRAINER_BULK_TRANSACTION.md`
- `docs/memory/evidence/P0300_TRAINER_GOODBYE.md`, `docs/memory/evidence/P0296_TRAINER_SCROLL_TRAIN_TEST.md`
- `docs/memory/decisions/D-046_PREVIEW_FIRST_UI_PIPELINE.md`, `docs/memory/decisions/D-047_SELECTIVE_NPC_PRESENTATION_AND_MODULARITY.md`
- `docs/memory/handoffs/CURRENT_HANDOFF.md`, `docs/memory/investigations/ACTIVE.md`, `docs/memory/roadmap/STATUS.md`, `docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md`, `docs/ROADMAP.md`, `docs/memory/patches/PATCH_INDEX.md`
