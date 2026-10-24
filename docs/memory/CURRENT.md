---
memory_schema: 1
as_of: 2026-10-24
project: logres
---

# Current State

## Active Objective
Prepare an evidence-gated public-alpha-quality WoW Forever Logres, followed by D-048 five-independent-domain 1.0. Preserve D-046 same-renderer preview-first, native Blizzard fallback, and frozen D-047 Camera/DynamicCam. November 4 is a contingent runtime opportunity, not a client PASS or release date.

## Current Work Item
**P0329 R2 — gameplay-accessible read-only snapshot and thirteen-item regression intake; PREPARED, WSL/WoW UNVERIFIED.** Verified GitHub `main` has pushed P0328 at `ff46fd8035428cd7ea9297e7ddf03631da2ea767` (2026-10-24). P0329 provides `0 — Gameplay Snapshot` in the existing developer panel plus `/logres gameplaycapture`, recording bounded addon-owned state in `LogresDiagnosticsDB`. It indexes new user reports L-020–L-032 without claiming they are reproduced or fixed. Bumps runtime metadata to `0.0.223-dev`; no gameplay behavior, secure actions, native frame ownership, aura presentation, compass or camera mutation. Expected checker count: 200. **R0 PREWRITE REFUSED** at historical `check_p0318_native_gossip_choices_contract.py`: original CURRENT compressed P0317–P0320 rather than retaining exact individual historical markers; no tracked writes. R1 restored P0317–P0327 in CURRENT but **PREWRITE REFUSED again at checker 163/200** (`check_p0326_merchant_flight_audit_contract.py`): its rewritten CURRENT_HANDOFF omitted literal `P0326`. P0327's adjacent contract also requires `P0327` in that handoff. Both R0/R1 stopped before tracked writes. R2 preserves the explicit handoff history and strengthens the local compatibility gate. The complete 200-checker suite is still required.

## Verified State
- P0328 internal-only alpha staging and November 4 runbook are pushed, **not validated in WoW**, and no public release is approved. P0328's CURRENT text was stale about the P0328 push; P0329 reconciles that fact.
- Source-history compatibility: P0317, P0318, P0319, P0320 (native-backed gossip), P0322, P0323, P0324, P0325 (five-domain models), and P0326, P0327 (native merchant/flight preparation) remain separately evidenced; no new client PASS is implied.
- P0321 GossipFrame single-window parking was pushed `9a180c8` but WoW runtime remains **UNVERIFIED / DEFERRED until November 4**. P0317–P0320 gossip/quest links have positive observations only in tested scopes; Quest 237 is reserved. Merchant/flight native services remain Blizzard-owned and flight frame identity unresolved.
- The five D-048 live selectors and saved-variable migration **do not exist**: schema 3 still stores `immersionEnabled` and `activeQuestEnabled`; Camera/DynamicCam remains frozen D-047. Existing pet, action, target and compass boundaries remain accepted unless runtime evidence proves a defect.
- L-020–L-032 are user-reported needs and regressions. P0329 offers capture only; L-021–L-032 are OPEN / not fixed. Live player HP and secret-capable aura values are never read or serialized by the new command.
- License/distribution gate L-019 remains unresolved; LibCamera notice retained, optional QuestieDB not bundled. Internal stage ZIP is not an approved release.

## Next Action
Apply P0329 R2 on **clean exact pushed P0328 `ff46fd8`**, run expected **200 PREWRITE and 200 POSTWRITE** static checks, candidate hygiene, Git diff hygiene and manifest; user commits/pushes and then verify GitHub `main`. Runtime-code deployment is mandatory before eventual WoW testing: launch `0 — Gameplay Snapshot` using `/logres panel`, or `/logres gameplaycapture` from gameplay without opening the panel. Export `LogresDiagnosticsDB` after `/reload`/logout. On November 4 first validate P0321 native gossip restoration as ordered in `docs/memory/roadmap/NOV04_VALIDATION_RUNBOOK.md`; capture an ordinary gameplay snapshot and, when issues arise naturally, a second symptom-time snapshot with screenshot/client context. Then prioritize L-026 death tunnel and L-025 UI-over-menu ordering, followed by L-028 aura correctness, with separate evidence-gated patches.

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
