---
memory_schema: 1
as_of: 2026-10-24
project: logres
---

# Current State

## Active Objective
Prepare an evidence-gated public-alpha-quality WoW Forever Logres, followed by D-048 five-independent-domain 1.0. Preserve D-046 same-renderer preview-first, native Blizzard fallback, and frozen D-047 Camera/DynamicCam. November 4 is a contingent runtime opportunity, not a client PASS or release date.

## Current Work Item
**P0331 — L-025/L-029 gameplay/menu layering and keybind/tunnel order; PREPARED / WSL and WoW UNVERIFIED.** Verified pushed P0330 `1f48bbef79af2611f93063e253ca062a2a69fe18` (2026-10-24), 201 static checker manifest. P0330 L-026 death/ghost tunnel correction is source-complete but client UNVERIFIED until November 4. P0331 lowers only ten Logres-owned gameplay roots to BACKGROUND (including action-cluster and feedback siblings), with HUD frame level 20 above action feedback level 10 for L-029. Migrates the P0040 historical action-feedback checker to deliberate new strata. Protects native menu/stock dock HIGH, no secure action, health secrets, combat/protected mutation, camera, saves, P0321 native gossip or D-048 switches. Expected 202 static checkers. Remaining L-028 harmful aura correctness is next offline defect.

## Verified State
- P0330 `1f48bbe` verified pushed, 201/201 checker manifest; death/ghost behavior remains UNVERIFIED while client is closed.
- Verified remote `main` P0329 `126d165` (2026-10-24) includes 200/200 checker manifest; gameplay snapshot and L-020–L-032 intake are committed, but WoW runtime is DEFERRED until November 4.
- P0328 internal-only alpha staging and November 4 runbook are pushed, **not validated in WoW**, and no public release is approved. P0328's CURRENT text was stale about the P0328 push; P0329 reconciles that fact.
- Source-history compatibility: P0317, P0318, P0319, P0320 (native-backed gossip), P0322, P0323, P0324, P0325 (five-domain models), and P0326, P0327 (native merchant/flight preparation) remain separately evidenced; no new client PASS is implied.
- P0321 GossipFrame single-window parking was pushed `9a180c8` but WoW runtime remains **UNVERIFIED / DEFERRED until November 4**. P0317–P0320 gossip/quest links have positive observations only in tested scopes; Quest 237 is reserved. Merchant/flight native services remain Blizzard-owned and flight frame identity unresolved.
- The five D-048 live selectors and saved-variable migration **do not exist**: schema 3 still stores `immersionEnabled` and `activeQuestEnabled`; Camera/DynamicCam remains frozen D-047. Existing pet, action, target and compass boundaries remain accepted unless runtime evidence proves a defect.
- L-020–L-032 are user-reported needs and regressions. P0329 offers capture only; L-021–L-032 are OPEN / not fixed. Live player HP and secret-capable aura values are never read or serialized by the new command.
- License/distribution gate L-019 remains unresolved; LibCamera notice retained, optional QuestieDB not bundled. Internal stage ZIP is not an approved release.

## Next Action
Apply P0331 to exact clean pushed P0330 `1f48bbe`, run full 202 PREWRITE shadow + 202 POSTWRITE static checks, hygiene and manifest; user commits/pushes; verify main. Then pursue a narrow L-028 target-aura identity/scan correction based on existing source and offline fixtures; avoid unproven secret introspection or global deduplication. WoW Forever closed until November 4: no immediate deployment or `/reload`. On return follow P0321 native gossip runbook first, then L-026 corpse-run acceptance and L-025/L-029 WorldMapFrame/native-menu/action-feedback/tooltips usability. Record any real Lua/taint/protected failure and preserve fail-open stock.

## Success Criteria
P0331 authored gameplay roots have source-guarded BACKGROUND strata; a D-036 health mask in HUD frame level 20 is above independent keybind/activation feedback level 10, while native quest/dialogue/fallback controls are untouched. Full 202 PREWRITE/POSTWRITE checkers and diff hygiene are required before commit. Actual WorldMapFrame and other menu occlusion, tooltip/click safety, low-health visibility and action execution remain UNVERIFIED until client access; no blanket claim of resolved L-025/L-029. P0330 death/ghost, P0329 diagnostic and P0321 gossip remain separate runtime acceptance gates.

## Do Not Reopen Without New Evidence
Do not change P0321 gossip parking, frozen camera, protected action routing, pet secure state, native UI suppression, fifth-domain live preferences, user save migration, quest 237 or unverified merchant/flight ownership in P0329. No periodic hooks, secret-value introspection or blanket visual frame suppression. Preserve D-046 preview-first, D-048 five systems, optional QuestieDB, no exact player HP, sparse target, Blizzard aura/group fallback, and all existing release blockers and negative evidence.

## Relevant References
- `docs/memory/investigations/ISSUE_REGISTER.md` (L-020–L-032); `docs/memory/evidence/P0329_GAMEPLAY_SNAPSHOT.md`; `docs/memory/patches/P0329_GAMEPLAY_SNAPSHOT.md`
- `docs/memory/roadmap/NOV04_VALIDATION_RUNBOOK.md`; `docs/memory/roadmap/LAUNCH_READINESS.md`
- `docs/memory/architecture/P0328_ALPHA_STAGE_READINESS.md`; `docs/memory/evidence/P0321_GOSSIP_SINGLE_WINDOW.md`
- `docs/memory/decisions/D-046_PREVIEW_FIRST_UI_PIPELINE.md`; `docs/memory/decisions/D-047_SELECTIVE_NPC_PRESENTATION_AND_MODULARITY.md`; `docs/memory/decisions/D-048_FIVE_INDEPENDENT_SYSTEMS.md`
- `docs/memory/handoffs/CURRENT_HANDOFF.md`; `docs/memory/investigations/ACTIVE.md`; `docs/memory/roadmap/STATUS.md`; `docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md`; `docs/ROADMAP.md`
