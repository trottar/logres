---
memory_schema: 1
as_of: 2026-10-24
project: logres
---

# Current State

## Active Objective
Prepare an evidence-gated public-alpha-quality WoW Forever Logres, followed by D-048 five-independent-domain 1.0. Preserve D-046 same-renderer preview-first, native Blizzard fallback, and frozen D-047 Camera/DynamicCam. November 4 is a contingent runtime opportunity, not a client PASS or release date.

## Current Work Item
**P0333 — L-021/L-024 pet action keybind labels and single active-spell outline; PREPARED / WSL and WoW UNVERIFIED.** Verified pushed P0332 `cbc2015a87a91035b25e6ea65585164ef495f470` (2026-10-24), after R0 baseline-parser refusal repaired in R1; the P0332 native target-aura path remains client UNVERIFIED. P0333 fixes Logres pet UI labels via guarded `BONUSACTIONBUTTONn` source and event-driven `UPDATE_BINDINGS`/secure-arm refresh; suppresses only the generic checked art when a dedicated active pet outline exists, retaining undecorated fallback. Custom active presentation no longer requires both autocast booleans. No secure binding/action mutation, camera, native stock controls, D-048 switches or save changes. Expected 204 full static checkers and version 0.0.227-dev. WoW beta closed until November 4.

## Verified State
- Verified GitHub main P0332 `cbc2015` pushed (2026-10-24); full static execution recorded in P0332 manifest, source fallback corrected; native aura client behavior UNVERIFIED.
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
Apply P0333 on clean exact pushed P0332 `cbc2015` with 204 PREWRITE shadow/204 POSTWRITE full suite, transactional rollback, candidate and Git whitespace, manifest; user commits/pushes, verify GitHub main. Next Phase H offline work L-023 player/target PvP symbols; then L-022/L-027 quest visual/native popups and compass L-030–L-032. November 4 prioritize P0321 native gossip restoration, then scoped P0330–P0333 visuals/controls and failures. No WoW deploy or /reload while client unavailable. Do not re-open protected pet routing.

## Success Criteria
For ten Logres secure pet-action slots, ordinary current Blizzard bonus-action binding keys appear in existing hotkey plates, unbound or secret keys remain blank, and UPDATE_BINDINGS refreshes them without overriding bindings. Active custom overlay alone owns decorated active outline; undecorated checked fallback retained; ordinary active states survive unavailable autocast metadata, which does not fabricate autocast. Source regression/equivalence checked offline; pet secure actions and Blizzard native accessibility unchanged. WoW behavior unverified until November 4.

## Do Not Reopen Without New Evidence
Do not change P0321 gossip parking, frozen camera, protected action routing, pet secure state, native UI suppression, fifth-domain live preferences, user save migration, quest 237 or unverified merchant/flight ownership in P0329. No periodic hooks, secret-value introspection or blanket visual frame suppression. Preserve D-046 preview-first, D-048 five systems, optional QuestieDB, no exact player HP, sparse target, Blizzard aura/group fallback, and all existing release blockers and negative evidence.

## Relevant References
- `docs/memory/investigations/ISSUE_REGISTER.md` (L-020–L-032); `docs/memory/evidence/P0329_GAMEPLAY_SNAPSHOT.md`; `docs/memory/patches/P0329_GAMEPLAY_SNAPSHOT.md`
- `docs/memory/roadmap/NOV04_VALIDATION_RUNBOOK.md`; `docs/memory/roadmap/LAUNCH_READINESS.md`
- `docs/memory/architecture/P0328_ALPHA_STAGE_READINESS.md`; `docs/memory/evidence/P0321_GOSSIP_SINGLE_WINDOW.md`
- `docs/memory/decisions/D-046_PREVIEW_FIRST_UI_PIPELINE.md`; `docs/memory/decisions/D-047_SELECTIVE_NPC_PRESENTATION_AND_MODULARITY.md`; `docs/memory/decisions/D-048_FIVE_INDEPENDENT_SYSTEMS.md`
- `docs/memory/handoffs/CURRENT_HANDOFF.md`; `docs/memory/investigations/ACTIVE.md`; `docs/memory/roadmap/STATUS.md`; `docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md`; `docs/ROADMAP.md`
