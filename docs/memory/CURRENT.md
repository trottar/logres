---
memory_schema: 1
as_of: 2026-10-24
project: logres
---

# Current State

## Active Objective
Prepare an evidence-gated public-alpha-quality WoW Forever Logres, followed by D-048 five-independent-domain 1.0. Preserve D-046 same-renderer preview-first, protected/native Blizzard fallback, and frozen D-047 Camera/DynamicCam. November 4 is an anticipated client-access test opportunity, not a confirmed launch date or runtime PASS.

## Current Work Item
**P0328 — internal alpha staging preflight and November 4 ordered validation runbook; PREPARED / full WSL and WoW UNVERIFIED.** GitHub `main` verified pushed P0327 `67c58185e2d05ce469ff7cdf7cc132f28814cf96`. P0328 adds a tools-only deterministic internal staging checker/ZIP generator, durable A0/A3 release evidence, exact in-game verification order and an open project licensing/distribution gate. No runtime Lua, addon version, schema, media, camera or native UI changes. Next: apply/commit/push P0328 with 199 PREWRITE and POSTWRITE checks; verify `main`; then progress remaining pre-beta release QA without granting runtime PASS.

## Verified State
- P0322 D-048 five-domain product contract; P0323 94-loaded-Lua ownership audit; P0324 pure 32-mode policy fixture; P0325 nonmutating legacy migration preview; P0326 merchant/flight source audit; P0327 eight inert merchant/flight models are pushed. Five live selectors and saved-variable migration **DO NOT EXIST**: schema 3 still stores only `immersionEnabled` and `activeQuestEnabled`.
- P0317/P0318/P0319/P0320 NPC gossip/dialogue/quest links have positive observations only in their tested scopes. P0321 single-window native GossipFrame parking/restore was pushed `9a180c8` but remains WoW **UNVERIFIED / DEFERRED until November 4**. Quest 237 reserved; native quest and transaction controls retained.
- Merchant `MerchantFrame` is a source candidate; `FlightMapFrame` versus `TaxiFrame` remains **UNRESOLVED**. Neither merchant nor flight is registered with the trainer-only NPC service session. Native buy/sell/repair and travel remain Blizzard-owned. Camera frozen D-047.
- The repository has `Logres/Logres.toc`, `tools/deploy_logres.sh`, optional QuestieDB dependency documentation, source-level LibCamera attribution and ignored `dist/`. **No root-level Logres LICENSE/COPYING has been verified**; the owner must explicitly decide public redistribution terms. P0328 is internal-only staging and does NOT approve publishing, client compatibility, or secure/UI correctness.

## Next Action
Apply P0328 at exact clean pushed P0327 `67c5818`, run 199/199 static checkers in both PREWRITE shadow and POSTWRITE working tree, prewrite hygiene, `git diff --check` and manifest; user commits/pushes and remote verification follows. **No WoW redeploy** for P0328. Use `python3 tools/stage_alpha_candidate.py --check` to inspect local source staging; an explicit `--output dist/<name>.zip` creates an INTERNAL-ONLY ZIP for local QA, not publication. Before any public release resolve project license/credits, installation documentation, supported client and runtime gates. On November 4 follow `docs/memory/roadmap/NOV04_VALIDATION_RUNBOOK.md`, starting with P0321 H Gossip Stock Status/Toggle, then read-only native service checks and broader regressions.

## Success Criteria
Deterministic, source-bounded internal addon staging includes all 94 TOC Lua files, runtime media and LibCamera license notice; excludes QuestieDB distribution, tools, docs, manifests, tracked machine paths and development ZIPs. Reject path traversal, duplicate entries, symlinks, version mismatches and accidental overwrites; label all staged archives internal only. Show unresolved licensing and runtime release blockers. Maintain truthful PASS/FAIL/DEFERRED/UNREPRODUCED in the November 4 test matrix; no source/fixture/static PASS promoted to client PASS.

## Do Not Reopen Without New Evidence
No public distribution or license assertion, no automatic QuestieDB bundle, no Lua runtime, camera/CVar/DynamicCam, native parking, merchant/flight service registration, secure controls, combat hooks, settings migration or live five switches in P0328. Do not claim P0321 or merchant/flight client PASS. Preserve no exact player HP, sparse target, minimap/party/auras and action fallback, PvP modifier, Quest 237, L-001–L-019 issues and all failures/deferrals. No speculative polling or broad hooks.

## Relevant References
- `docs/memory/architecture/P0328_ALPHA_STAGE_READINESS.md`, `docs/memory/evidence/P0328_ALPHA_STAGE_READINESS.md`, `docs/memory/patches/P0328_ALPHA_STAGE_READINESS.md`, `docs/memory/roadmap/NOV04_VALIDATION_RUNBOOK.md`
- `docs/memory/roadmap/LAUNCH_READINESS.md`, `docs/memory/investigations/ISSUE_REGISTER.md`, `docs/DEPENDENCIES.md`, `README.md`
- `docs/memory/architecture/P0327_MERCHANT_FLIGHT_FIXTURE.md`, `docs/memory/architecture/P0326_MERCHANT_FLIGHT_AUDIT.md`, `docs/memory/evidence/P0321_GOSSIP_SINGLE_WINDOW.md`
- `docs/memory/decisions/D-046_PREVIEW_FIRST_UI_PIPELINE.md`, `docs/memory/decisions/D-047_SELECTIVE_NPC_PRESENTATION_AND_MODULARITY.md`, `docs/memory/decisions/D-048_FIVE_INDEPENDENT_SYSTEMS.md`
- `docs/memory/handoffs/CURRENT_HANDOFF.md`, `docs/memory/investigations/ACTIVE.md`, `docs/memory/roadmap/STATUS.md`, `docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md`, `docs/ROADMAP.md`
