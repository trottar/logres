---
memory_schema: 1
as_of: 2026-10-24
project: logres
---

# Current State

## Active Objective
Prepare public-alpha-quality WoW Forever Logres and quality-gated 1.0 with D-048 five independently selectable NAV/ACT/NPC/STATUS/CAM domains, safe native fallback, and preserved accepted runtime functionality. November 4 is a proposed client-test opportunity, not runtime PASS.

## Current Work Item
**P0324 — isolated pure five-domain policy specification and regression fixtures; PREPARED / WSL static and WoW UNVERIFIED.** Verified pushed P0323 `386a7ef` on GitHub main. Its 94-loaded-file ownership audit is durable. P0324 adds no addon-loaded code, no player-facing switches and no SavedVariables migration: only a standalone Python policy evaluator, its 32-combination test contract and canonical records. Next: apply under exact clean P0323 and verify full 195 PREWRITE+POSTWRITE checks, commit/push, then proceed to separately scoped policy/migration design and service preparation.

## Verified State
- P0323 pushed `386a7ef` and inventories all 94 Lua TOC entries into the five domains or SHARED. Cross-domain Immersion coupling is documented, not yet removed.
- P0322 accepted D-048, launch gates and issue register; P0322 R0 checker-version PREWRITE failure preserved. P0317/P0318/P0319/P0320 retain positive user evidence for observed gossip and quest-link interactions. P0321 pushed `9a180c8` but gossip parking/restoration remains **WoW UNVERIFIED / DEFERRED until November 4**.
- The production `Core/Preferences.lua` still defines `immersionEnabled` and `activeQuestEnabled`, with schema 3 in `Core/Database.lua`; `Immersion/Controller.lua` still coordinates actions, player/target suppression and Quiet Mode, and compass follows Immersion. Five independent live toggles **DO NOT EXIST**.
- D-047 freezes camera/DynamicCam. Native merchant and flight transaction surfaces remain Blizzard-owned. Native quest handoff and Quest 237 remain preserved. Other open bugs and deferrals remain classified in `ISSUE_REGISTER.md`.

## Next Action
Apply P0324 on clean exact pushed P0323 `386a7ef`, requiring full **195/195 PREWRITE and POSTWRITE** static checks, prewrite whitespace and `git diff --check`, generated manifest, user commit/push and GitHub verification. P0324 is source-independent and test-only: **no WoW redeploy**. After P0324, use deterministic policy behavior to prepare a migration decision and eventual guarded production Lua separately; no native suppression, secure ACT/pet, gossip/trainer parking, camera or global Immersion runtime changes before actual Forever restoration proof. November 4: P0321 Gossip Stock Status/Toggle, gossip/quest native handoff/restoration, merchant/flight native service access, then high-priority baseline checks.

## Success Criteria
Precisely five named independent requested modes, **32** deterministic configurations, incomplete-source fallback, partial-native retention and deferred-restore semantics, four legacy immersion/Active Quest combinations preserved without migration or alias writes. All models are inert Python fixtures outside `Logres/Logres.toc`; requested/effective/fallback/pending are *simulated policy outputs*, never claims of Blizzard observation. The alpha/1.0 plan and all previous evidence remain intact.

## Do Not Reopen Without New Evidence
No live five-toggle implementation, schema bump, TOC/runtime version, camera or native frame change in this checkpoint. Do not conflate Python model PASS with Lua execution or safe Blizzard restoration. Do not alter proven player-health information disclosure, sparse target, stock minimap/party/auras/quest controls or protected pet/action ownership. No polling or blanket hooks. P0321 remains runtime UNVERIFIED until Forever proof.

## Relevant References
- `docs/memory/architecture/P0324_POLICY_FIXTURE.md`, `docs/memory/evidence/P0324_FIVE_DOMAIN_POLICY.md`, `docs/memory/patches/P0324_FIVE_DOMAIN_POLICY.md`
- `docs/memory/architecture/P0323_MODULE_OWNERSHIP_AUDIT.md`, `docs/memory/decisions/D-048_FIVE_INDEPENDENT_SYSTEMS.md`, `docs/memory/roadmap/LAUNCH_READINESS.md`, `docs/memory/investigations/ISSUE_REGISTER.md`
- `docs/memory/decisions/D-046_PREVIEW_FIRST_UI_PIPELINE.md`, `docs/memory/decisions/D-047_SELECTIVE_NPC_PRESENTATION_AND_MODULARITY.md`, `docs/memory/evidence/P0321_GOSSIP_SINGLE_WINDOW.md`
- `docs/memory/handoffs/CURRENT_HANDOFF.md`, `docs/memory/investigations/ACTIVE.md`, `docs/memory/roadmap/STATUS.md`, `docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md`, `docs/ROADMAP.md`
