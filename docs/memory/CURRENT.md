---
memory_schema: 1
as_of: 2026-10-24
project: logres
---

# Current State

## Active Objective
Prepare an evidence-gated public-alpha-quality WoW Forever Logres, followed by D-048 five-independent-domain 1.0. Preserve D-046 same-renderer preview-first, native Blizzard fallback, and frozen D-047 Camera/DynamicCam. November 4 is a contingent runtime opportunity, not a client PASS or release date.

## Current Work Item
**P0330 — L-026 dead/ghost health-tunnel corpse-navigation correction; PREPARED / FULL WSL + WoW UNVERIFIED.** Verified GitHub `main` P0329 at `126d16526ebc68525abed4565d3812d9332fec76` (2026-10-24), manifest 200/200 PREWRITE/POSTWRITE; P0329 read-only gameplay diagnostics and L-020–L-032 issue intake are committed, with no client proof after beta closed. P0330 preserves the approved living D-036 health curve and adds event-driven corpse-travel mask clearing, an initial/reload ordinary death/ghost observation guarded with `issecretvalue`, `PLAYER_DEAD`/`PLAYER_ALIVE`/`PLAYER_UNGHOST` transitions, and cached diagnostics. No health value inspection, native UI, secure action, camera, D-048 preference or saved-schema changes. Baseline P0329, expected 201 static checks. This is a candidate correction, not a verified in-client fix; November 4 remains the environmental gate.

## Verified State
- Verified remote `main` P0329 `126d165` (2026-10-24) includes 200/200 checker manifest; gameplay snapshot and L-020–L-032 intake are committed, but WoW runtime is DEFERRED until November 4.
- P0328 internal-only alpha staging and November 4 runbook are pushed, **not validated in WoW**, and no public release is approved. P0328's CURRENT text was stale about the P0328 push; P0329 reconciles that fact.
- Source-history compatibility: P0317, P0318, P0319, P0320 (native-backed gossip), P0322, P0323, P0324, P0325 (five-domain models), and P0326, P0327 (native merchant/flight preparation) remain separately evidenced; no new client PASS is implied.
- P0321 GossipFrame single-window parking was pushed `9a180c8` but WoW runtime remains **UNVERIFIED / DEFERRED until November 4**. P0317–P0320 gossip/quest links have positive observations only in tested scopes; Quest 237 is reserved. Merchant/flight native services remain Blizzard-owned and flight frame identity unresolved.
- The five D-048 live selectors and saved-variable migration **do not exist**: schema 3 still stores `immersionEnabled` and `activeQuestEnabled`; Camera/DynamicCam remains frozen D-047. Existing pet, action, target and compass boundaries remain accepted unless runtime evidence proves a defect.
- L-020–L-032 are user-reported needs and regressions. P0329 offers capture only; L-021–L-032 are OPEN / not fixed. Live player HP and secret-capable aura values are never read or serialized by the new command.
- License/distribution gate L-019 remains unresolved; LibCamera notice retained, optional QuestieDB not bundled. Internal stage ZIP is not an approved release.

## Next Action
Apply P0330 to clean exact pushed P0329 `126d165` with 201 PREWRITE shadow/201 POSTWRITE static checks, candidate/diff hygiene and rollback; user alone commits/pushes and GitHub `main` must then be re-verified. Continue Phase H gameplay fixes while WoW Forever is closed: next bounded source-level implementation targets L-025/L-029 menu/tunnel/keybind strata, followed by L-028 target-aura reconciliation and remaining pet/quest/compass reports. November 4 client access is contingent: first follow `docs/memory/roadmap/NOV04_VALIDATION_RUNBOOK.md` for P0321 gossip restoration, then validate L-026 normal living low HP versus dead/ghost, release to graveyard, resurrection, preview/immersion transitions, reload while ghost and Lua/secret errors. No WoW deployment or commands should be requested before actual client access. Record a negative or deferred result explicitly, not a PASS.

## Success Criteria
One-shot capture from gameplay and from existing panel; captures cached state/preference, initialized HUD, compass, status-aura and pet ownership summaries without protected/native inspection, periodic polling, camera or gameplay writes. Panel/slash records persist to the existing bounded diagnostics DB. Static checks only establish source contract; WoW behavior and every remaining reported issue need runtime verification. No claim that a user-reported bug is fixed without in-client evidence.

## Do Not Reopen Without New Evidence
Do not change P0321 gossip parking, frozen camera, protected action routing, pet secure state, native UI suppression, fifth-domain live preferences, user save migration, quest 237 or unverified merchant/flight ownership in P0329. No periodic hooks, secret-value introspection or blanket visual frame suppression. Preserve D-046 preview-first, D-048 five systems, optional QuestieDB, no exact player HP, sparse target, Blizzard aura/group fallback, and all existing release blockers and negative evidence.

## Relevant References
- `docs/memory/investigations/ISSUE_REGISTER.md` (L-020–L-032); `docs/memory/evidence/P0329_GAMEPLAY_SNAPSHOT.md`; `docs/memory/patches/P0329_GAMEPLAY_SNAPSHOT.md`
- `docs/memory/roadmap/NOV04_VALIDATION_RUNBOOK.md`; `docs/memory/roadmap/LAUNCH_READINESS.md`
- `docs/memory/architecture/P0328_ALPHA_STAGE_READINESS.md`; `docs/memory/evidence/P0321_GOSSIP_SINGLE_WINDOW.md`
- `docs/memory/decisions/D-046_PREVIEW_FIRST_UI_PIPELINE.md`; `docs/memory/decisions/D-047_SELECTIVE_NPC_PRESENTATION_AND_MODULARITY.md`; `docs/memory/decisions/D-048_FIVE_INDEPENDENT_SYSTEMS.md`
- `docs/memory/handoffs/CURRENT_HANDOFF.md`; `docs/memory/investigations/ACTIVE.md`; `docs/memory/roadmap/STATUS.md`; `docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md`; `docs/ROADMAP.md`
