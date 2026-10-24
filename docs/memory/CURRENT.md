---
memory_schema: 1
as_of: 2026-10-23
project: logres
---

# Current State

## Active Objective
Prepare a **reliable public-alpha-quality Forever Logres** and later quality-gated 1.0 around the D-048 five independently selectable systems: NAV, ACT, NPC, STATUS, CAM. Protect all previously accepted runtime behavior and stock fallback. November 4 is a proposed **runtime re-entry opportunity**, not runtime PASS or a confirmed public-launch date.

## Current Work Item
**P0323 — repository-wide READ-ONLY source modularity/ownership audit, DOCS + STATIC CONTRACT ONLY / PREPARED.** Verified pushed P0322 `272130eb9e80c3c51ebe5da08598453cdfc56a88` on `main`; D-048 and launch/issue records are durable. Audited all **94 Lua entries** from `Logres/Logres.toc` in `docs/memory/architecture/P0323_MODULE_OWNERSHIP_AUDIT.md`. Next after P0323 verification: P0324 isolated five-domain pure policy fixtures and 32 requested-state combinations; **no production five-toggle wiring** until separate native restoration proof.

## Verified State
- P0322 pushed `272130e`: D-048 five systems, alpha/1.0 internal release gates, consolidated `ISSUE_REGISTER.md` and new static contract durable. P0322 R0 checker-version failure preserved in evidence, R1 pushed; this does not imply WoW runtime verification.
- P0317–P0320 have positive user-observed scope for NPC dialogues/options/quest titles. P0321 single-window gossip parking is committed as `9a180c8` but **WoW UNVERIFIED / DEFERRED until November 4**. Merchant and flight-master remain the primary untested NPC service regimes and fully native transaction owners.
- Current `immersionEnabled` and `activeQuestEnabled` are the only persisted player choices in `Core/Preferences.lua`; schema 3 in `Core/Database.lua`. Immersion currently drives action stock replacement, player/target suppression and Quiet Mode; compass follows it. Five independent live switches do **NOT** yet exist.
- P0323 maps loaded Lua into the five domains/shared infrastructure, distinguishes pure presentation seams from native/protected surfaces, and identifies monolithic orchestration without claiming any runtime refactor. Camera is frozen D-047; quest 237 reserved; all issue-register failures/deferrals retained.

## Next Action
Apply P0323 to exact clean pushed P0322 `272130e`; require 194/194 PREWRITE and POSTWRITE static checker suite, diff hygiene and manifest, then user commit/push and GitHub verify. **No WoW redeploy for docs-only.** Next P0324 may introduce **pure model/test fixtures only** for requested/effective/fallback/pending states and 32 domain configurations; don't change `Immersion/Controller.lua`, secure ACT/pet, gossip/trainer native parking, `Camera/*.lua` or saved preferences in an untested candidate. On November 4, first validate P0321 stock parking and restoration, then naturally available merchant/flight handoffs, followed by high-priority baseline regressions.

## Success Criteria
The new audit includes each of the **94 TOC Lua entries once**, accurate domain/shared mapping, known dependency/fallback ownership, ranked safe seams, and explicit no-runtime-change scope; preserves P0317 P0318 P0319 P0320 P0321 P0322 continuity, D-046/D-047/D-048 decisions and L-001–L-018 issue-register classifications. Future five-domain selectors must be independent, distinguish requested vs effective/native fallback, preserve SavedVariables migration, and prove safe stock restoration before runtime exposure.

## Do Not Reopen Without New Evidence
Do not declare P0321 single-window PASS, rewrite working controllers, alter DynamicCam or camera, hide missing native quest/merchant/flight/party/target aura controls, expose exact player HP or exact enemy level, implement polling or generic protected hooks, or conflate source/static inspection with client evidence. No runtime Lua, TOC, version, deployment, media or settings schema changes in P0323.

## Relevant References
- `docs/memory/architecture/P0323_MODULE_OWNERSHIP_AUDIT.md`, `docs/memory/evidence/P0323_MODULE_OWNERSHIP_AUDIT.md`, `docs/memory/patches/P0323_MODULE_OWNERSHIP_AUDIT.md`
- `docs/memory/decisions/D-048_FIVE_INDEPENDENT_SYSTEMS.md`, `docs/memory/roadmap/LAUNCH_READINESS.md`, `docs/memory/investigations/ISSUE_REGISTER.md`
- `docs/memory/decisions/D-046_PREVIEW_FIRST_UI_PIPELINE.md`, `docs/memory/decisions/D-047_SELECTIVE_NPC_PRESENTATION_AND_MODULARITY.md`
- `docs/memory/handoffs/CURRENT_HANDOFF.md`, `docs/memory/investigations/ACTIVE.md`, `docs/memory/roadmap/STATUS.md`, `docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md`, `docs/ROADMAP.md`
