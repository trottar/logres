---
memory_schema: 1
as_of: 2026-10-24
project: logres
---

# Current State

## Active Objective
Prepare a reliable public-alpha-quality WoW Forever Logres and a quality-gated 1.0, honoring D-048's five independently selectable NAV/ACT/NPC/STATUS/CAM systems, D-046 preview-first implementation and native fallback. November 4 is a proposed client validation opportunity, not proof or an established public-launch date.

## Current Work Item
**P0326 — merchant and flight-master read-only NPC source/handoff audit, PREPARED / full WSL static UNVERIFIED; no addon-runtime changes.** Verified pushed P0325 `c596fe24462d1cabd6c8027f46f713ba0d10da8f` on GitHub main. P0325 remains isolated migration dry-run only; P0326 identifies existing source candidates, reusable non-transactional UI, native fallback and runtime proof gates. See `docs/memory/architecture/P0326_MERCHANT_FLIGHT_AUDIT.md`.

## Verified State
- P0322 D-048 architecture and issue register, P0323 94-source ownership map, P0324 32-policy fixture, and P0325 legacy migration dry-run are all pushed. **No live five-toggle settings or saved schema migration exists**; current schema 3 and `immersionEnabled` / `activeQuestEnabled` remain intact.
- P0317–P0320 gossip/dialogue/quest links have positive observations within tested scope. P0321 pushed `9a180c8`, but gossip stock-root parking and restoration remain **WoW UNVERIFIED / DEFERRED until November 4**; Quest 237 reserved.
- `NPCNativeServicePolicy` retains merchant/repair and flight transactions under Blizzard; `NPCNativeServiceCapabilities` names `MerchantFrame`, `FlightMapFrame`, `TaxiFrame` as candidates. `ServiceElementIndex` uses `TaxiFrame` for flight artwork candidates, but actual Forever root identity is **UNRESOLVED**. `NPCServiceSession` has a trainer registration only, not merchant/flight; distinct gossip/trainer parking must not be extended without proof.
- `ISSUE_REGISTER.md` L-003/L-004 merchant/flight remain **FEATURE GAP / runtime untested**. Camera/DynamicCam is frozen under D-047; no runtime NPC, camera, TOC or preference changes in P0326.

## Next Action
Apply P0326 on exact clean pushed P0325 `c596fe2`, requiring 197/197 PREWRITE and POSTWRITE static checkers, exact candidate diff hygiene, `git diff --check`, manifest; user commits/pushes then GitHub verify. **No WoW redeploy** for this documentation/static-contract checkpoint. Next work may design inert merchant/flight fixtures or compare service-specific source contracts. On November 4 prioritize P0321 Gossip Stock Status/Toggle and native restoration, then use H **Native Service Frame Audit** and **Native NPC Services Check** read-only while naturally interacting with merchant/flight, retaining native transactions/travel; investigate failures before any new native mutation.

## Success Criteria
Every merchant/flight claim is classified source candidate, existing production behavior, or runtime-unknown; discrepancies between `FlightMapFrame` and `TaxiFrame` are explicit. Shared presenter/session boundaries, protected/secret safety, native restore, preserved Blizzard transactions and D-047 camera freeze are recorded. The docs-only applier changes neither Lua, addon version, schema, Quest 237, gameplay controllers nor runtime tested state.

## Do Not Reopen Without New Evidence
Do not claim P0321 single-window PASS, merchant purchases or flight travel Logres-owned, native merchant/flight root proven, or five live switches implemented. No premature NPCServiceSession registration, merchant/flight parking, broad OnShow/OnHide hooks, timer/polling, native child/geometry introspection for secret proof, camera rewrites, or protected action changes. Preserve stock merchant/flight usable, quest details, aura/party/minimap and pet fallback. P0317 P0318 P0319 P0320 P0321 P0322 P0323 P0324 P0325 histories and negative evidence remain intact.

## Relevant References
- `docs/memory/architecture/P0326_MERCHANT_FLIGHT_AUDIT.md`, `docs/memory/evidence/P0326_MERCHANT_FLIGHT_AUDIT.md`, `docs/memory/patches/P0326_MERCHANT_FLIGHT_AUDIT.md`
- `docs/memory/architecture/P0325_MIGRATION_DRY_RUN.md`, `docs/memory/architecture/P0324_POLICY_FIXTURE.md`, `docs/memory/architecture/P0323_MODULE_OWNERSHIP_AUDIT.md`, `docs/memory/decisions/D-046_PREVIEW_FIRST_UI_PIPELINE.md`, `docs/memory/decisions/D-047_SELECTIVE_NPC_PRESENTATION_AND_MODULARITY.md`, `docs/memory/decisions/D-048_FIVE_INDEPENDENT_SYSTEMS.md`
- `docs/memory/investigations/ISSUE_REGISTER.md`, `docs/memory/evidence/P0321_GOSSIP_SINGLE_WINDOW.md`, `docs/memory/roadmap/LAUNCH_READINESS.md`, `docs/memory/handoffs/CURRENT_HANDOFF.md`, `docs/memory/investigations/ACTIVE.md`, `docs/memory/roadmap/STATUS.md`, `docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md`, `docs/ROADMAP.md`
