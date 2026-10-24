---
memory_schema: 1
as_of: 2026-10-24
project: logres
---

# Current State

## Active Objective
Prepare an evidence-gated public-alpha-quality WoW Forever Logres, followed by D-048 five-independent-domain 1.0. Preserve D-046 same-renderer preview-first, native Blizzard fallback, and frozen D-047 Camera/DynamicCam. November 4 is a contingent runtime opportunity, not a client PASS or release date.

## Current Work Item
**P0332 — L-028 canonical target-harmful fallback source and expanded bounded DoT selection; PREPARED / WSL and WoW UNVERIFIED.** Verified pushed P0331 `dce2355cd960dab457f933982ca39d45c0610c98` (October 24, 2026), with 202 PREWRITE/POSTWRITE static-check manifest. P0331 L-025/L-029 menu overlay correction and P0330 L-026 corpse navigation remain client UNVERIFIED until November 4. P0332 replaces three overlapping ordinary fallback target HARMFUL filter views with one canonical HARMFUL pass: 16 indexed reads maximum and five icons maximum, positively ordinary player/pet-owned entries preferred, unknown IDs not deduped by texture/spell. Existing native AuraContainer, stock target auras, player harmful priority, target helpful, secret/protected ownership, camera and all D-048 preferences unchanged. Historical P0175 checker migrated; expected 203 complete static checks. No claim the active native renderer is corrected without client evidence.

## Verified State
- Verified P0331 push `dce2355` (2026-10-24), 202-checker manifest; L-025/L-029 layering remains WoW UNVERIFIED.
- P0330 `1f48bbe` verified pushed, 201/201 checker manifest; death/ghost behavior remains UNVERIFIED while client is closed.
- Verified remote `main` P0329 `126d165` (2026-10-24) includes 200/200 checker manifest; gameplay snapshot and L-020–L-032 intake are committed, but WoW runtime is DEFERRED until November 4.
- P0328 internal-only alpha staging and November 4 runbook are pushed, **not validated in WoW**, and no public release is approved. P0328's CURRENT text was stale about the P0328 push; P0329 reconciles that fact.
- Source-history compatibility: P0317, P0318, P0319, P0320 (native-backed gossip), P0322, P0323, P0324, P0325 (five-domain models), and P0326, P0327 (native merchant/flight preparation) remain separately evidenced; no new client PASS is implied.
- P0321 GossipFrame single-window parking was pushed `9a180c8` but WoW runtime remains **UNVERIFIED / DEFERRED until November 4**. P0317–P0320 gossip/quest links have positive observations only in tested scopes; Quest 237 is reserved. Merchant/flight native services remain Blizzard-owned and flight frame identity unresolved.
- The five D-048 live selectors and saved-variable migration **do not exist**: schema 3 still stores `immersionEnabled` and `activeQuestEnabled`; Camera/DynamicCam remains frozen D-047. Existing pet, action, target and compass boundaries remain accepted unless runtime evidence proves a defect.
- L-020–L-032 are user-reported needs and regressions. P0329 offers capture only; L-021–L-032 are OPEN / not fixed. Live player HP and secret-capable aura values are never read or serialized by the new command.
- License/distribution gate L-019 remains unresolved; LibCamera notice retained, optional QuestieDB not bundled. Internal stage ZIP is not an approved release.

## Next Action
Apply P0332 on clean exact P0331 `dce2355` with all 203 PREWRITE shadow and 203 POSTWRITE checkers, diff hygiene, rollback and manifest. User commits/pushes; verify main. Then address L-021/L-024 pet hotkey/active outline and remaining reported functionality with bounded implementation patches, not repeat-only diagnostics. Forever closed until November 4; no WoW deployment or /reload now. At first client access follow P0321 gossip restoration, then L-026/L-025/L-029 visual tests and L-028 target aura native-versus-legacy source differentiation, screenshots, tooltips and secret skips. Preserve negative results and explicit deferrals.

## Success Criteria
The ordinary target harmful fallback draws from one canonical HARMFUL index space, scans at most 16 and renders at most five, preferring positively ordinary player-origin; no duplicate icons solely from overlapping filters, no spell/icon/name deduplication of unrelated DoTs. Secret checks, existing Blizzard native aura fallback, stock presentation and visual identity preserved. A synthetic fixture and full 203 PRE/POST static checks establish only source intent. Exact harmful/native behavior remains WoW UNVERIFIED until November 4.

## Do Not Reopen Without New Evidence
Do not change P0321 gossip parking, frozen camera, protected action routing, pet secure state, native UI suppression, fifth-domain live preferences, user save migration, quest 237 or unverified merchant/flight ownership in P0329. No periodic hooks, secret-value introspection or blanket visual frame suppression. Preserve D-046 preview-first, D-048 five systems, optional QuestieDB, no exact player HP, sparse target, Blizzard aura/group fallback, and all existing release blockers and negative evidence.

## Relevant References
- `docs/memory/investigations/ISSUE_REGISTER.md` (L-020–L-032); `docs/memory/evidence/P0329_GAMEPLAY_SNAPSHOT.md`; `docs/memory/patches/P0329_GAMEPLAY_SNAPSHOT.md`
- `docs/memory/roadmap/NOV04_VALIDATION_RUNBOOK.md`; `docs/memory/roadmap/LAUNCH_READINESS.md`
- `docs/memory/architecture/P0328_ALPHA_STAGE_READINESS.md`; `docs/memory/evidence/P0321_GOSSIP_SINGLE_WINDOW.md`
- `docs/memory/decisions/D-046_PREVIEW_FIRST_UI_PIPELINE.md`; `docs/memory/decisions/D-047_SELECTIVE_NPC_PRESENTATION_AND_MODULARITY.md`; `docs/memory/decisions/D-048_FIVE_INDEPENDENT_SYSTEMS.md`
- `docs/memory/handoffs/CURRENT_HANDOFF.md`; `docs/memory/investigations/ACTIVE.md`; `docs/memory/roadmap/STATUS.md`; `docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md`; `docs/ROADMAP.md`
