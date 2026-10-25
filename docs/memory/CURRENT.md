---
memory_schema: 1
as_of: 2026-10-24
project: logres
---

# Current State

## Active Objective
Prepare an evidence-gated public-alpha-quality WoW Forever Logres, followed by D-048 five-independent-domain 1.0. Preserve D-046 same-renderer preview-first, native Blizzard fallback, and frozen D-047 Camera/DynamicCam. November 4 is a contingent runtime opportunity, not a client PASS or release date.

## Current Work Item
**P0334 — L-023 player and target PvP status-modifier badges; PREPARED / WSL and WoW UNVERIFIED.** Verified GitHub `main` P0333 at `68c09555242ac11dcf8296531a51017f31c43174` (2026-10-25), 204 PREWRITE/POSTWRITE static-check manifest; L-021/L-024 pet labels and single active outline are committed but WoW UNVERIFIED until November 4. P0334 adds two noninteractive PvP labels to the existing player resource and sparse target identity HUD using independently guarded `UnitIsPVP` flags; secret/unknown values never trigger visual claims. Both labels share the preview/live renderer; `pvppreview on|off` and P-tab buttons permit deterministic visual acceptance before runtime completion. No native control, secure action, health/aura, camera, D-048 saved preference, UI suppression or quest behavior mutation. Expected 205 complete static checkers. PvP remains a presentation modifier, not Immersion OFF.

## Verified State
- Verified GitHub `main` P0333 push `68c0955` (2026-10-25), manifest records 204/204 PREWRITE and POSTWRITE static checks. Pet keybind/active outline runtime remains UNVERIFIED.
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
Apply P0334 to exact clean pushed P0333 `68c0955` with all 205 PREWRITE shadow and 205 POSTWRITE static checks, strict blob/table guard, rollback and diff/manifest hygiene. User owns commit/push; verify GitHub `main` before advancing. Then continue bounded Phase H fixes: L-027 native XP/quest task pop-ups and L-030–L-032 compass issues; L-022 focused quest artifact is screenshot/reproduction gated. WoW Forever closed until November 4: no immediate deployment, `/reload`, PvP gameplay or panel requests. At actual client reentry follow P0321 gossip restoration runbook first, then preview both PvP badges, check player/target transitions and inspect secret/Lua errors. D-046 visual preview must be accepted before a full gameplay PASS.

## Success Criteria
Two small PvP modifier badges use the same production HUD renderer for synthetic preview and ordinary live flag display, anchored to resource and sparse target; full Immersion remains intact. Never branch on `UnitIsPVP` until pcall and `issecretvalue` prove ordinary boolean. Unknown/secret causes additive badge-only fallback; stock presentation is untouched. Event-driven updates on flags, faction, target changes and world entry; no polling. Full 205 PRE/POST static checks establish source safety only. Preview appearance, PvP contexts, combat behavior and visual layering remain **UNVERIFIED** until November 4.

## Do Not Reopen Without New Evidence
Do not change P0321 gossip parking, frozen camera, protected action routing, pet secure state, native UI suppression, fifth-domain live preferences, user save migration, quest 237 or unverified merchant/flight ownership in P0329. No periodic hooks, secret-value introspection or blanket visual frame suppression. Preserve D-046 preview-first, D-048 five systems, optional QuestieDB, no exact player HP, sparse target, Blizzard aura/group fallback, and all existing release blockers and negative evidence.

## Relevant References
- `docs/memory/evidence/P0334_PVP_BADGES.md` and `docs/memory/patches/P0334_PVP_BADGES.md` — L-023 source correction, preview and runtime gates.
- `docs/memory/investigations/ISSUE_REGISTER.md` (L-020–L-032); `docs/memory/evidence/P0329_GAMEPLAY_SNAPSHOT.md`; `docs/memory/patches/P0329_GAMEPLAY_SNAPSHOT.md`
- `docs/memory/roadmap/NOV04_VALIDATION_RUNBOOK.md`; `docs/memory/roadmap/LAUNCH_READINESS.md`
- `docs/memory/architecture/P0328_ALPHA_STAGE_READINESS.md`; `docs/memory/evidence/P0321_GOSSIP_SINGLE_WINDOW.md`
- `docs/memory/decisions/D-046_PREVIEW_FIRST_UI_PIPELINE.md`; `docs/memory/decisions/D-047_SELECTIVE_NPC_PRESENTATION_AND_MODULARITY.md`; `docs/memory/decisions/D-048_FIVE_INDEPENDENT_SYSTEMS.md`
- `docs/memory/handoffs/CURRENT_HANDOFF.md`; `docs/memory/investigations/ACTIVE.md`; `docs/memory/roadmap/STATUS.md`; `docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md`; `docs/ROADMAP.md`
