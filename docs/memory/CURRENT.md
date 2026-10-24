---
memory_schema: 1
as_of: 2026-10-24
project: logres
---

# Current State

## Active Objective
Prepare a reliable public-alpha-quality WoW Forever Logres, then quality-gated 1.0, around D-048 five independent NAV/ACT/NPC/STATUS/CAM selections. Preserve D-046 preview-first architecture, Blizzard information/transaction fallback, and frozen D-047 Camera/DynamicCam. November 4 is a proposed runtime re-entry, not PASS or a confirmed launch date.

## Current Work Item
**P0327 — isolated merchant/flight synthetic service model fixtures; PREPARED / full WSL static and WoW runtime UNVERIFIED.** Verified pushed P0326 `7949d7cb79a491db6ca0c2264694a31588db05e8` on GitHub `main`; merchant/flight native-source audit is durable. P0327 adds only offline Python models, checker and memory—not live Lua visuals or NPC service controllers. After user push verify, the next main gate is November 4 native gossip/merchant/flight evidence and later same-renderer in-game visual acceptance.

## Verified State
- P0322 D-048 five-system goal and issue register, P0323 94-file ownership audit, P0324 32-combination policy fixture, P0325 offline legacy migration draft, and P0326 merchant/flight source audit are pushed. Current live preferences remain `immersionEnabled` and `activeQuestEnabled`, saved schema 3; **five independent live toggles DO NOT EXIST**.
- P0317/P0318/P0319/P0320 gossip/dialogue/quest-link interactions have limited positive user observations. P0321 pushed `9a180c8`, but its native gossip parking/restoration is **WoW UNVERIFIED / DEFERRED until November 4**. Quest 237 remains reserved.
- P0326 proved only candidate merchant `MerchantFrame` and unresolved flight `FlightMapFrame` versus `TaxiFrame`; native merchant/flight transaction/travel controls remain Blizzard-owned. `NPCServiceSession` has trainer registration only; separate gossip/trainer parking remains restricted.
- P0327 prepares **8 authored model scenarios** (two services, four states), all disabled/nonactionable and requiring Blizzard native controls. It neither creates a production renderer nor satisfies D-046 in-game P — Previews visual acceptance. Issues L-003/L-004 remain **FEATURE GAP / runtime untested**.

## Next Action
Apply P0327 on exact clean pushed P0326 `7949d7c`, with **198/198 PREWRITE and POSTWRITE** static checkers, exact-candidate whitespace, `git diff --check` and manifest. User commits/pushes; verify GitHub main. **No WoW redeploy.** On November 4 first validate P0321 Gossip Stock Status/Toggle, choice and quest handoffs, Goodbye and native restoration; then H **Native Service Frame Audit** and **Native NPC Services Check** read-only with naturally accessible merchant/flight. Preserve normal purchases/flight travel under Blizzard. Follow with same-renderer in-game P — Previews for synthetic presentation and only later guarded live adapter if evidence allows.

## Success Criteria
Eight deterministic, source-independent, nonactionable service presentations; native merchant/flight controls retained in every state; no invented item IDs, costs, route connectivity, eligibility, fares or service identity; no new live Lua/TOC/version/schema/camera changes. Source/fixture PASS must remain distinct from WoW visual/runtime PASS. D-046/D-047/D-048 and L-001–L-018 history preserved.

## Do Not Reopen Without New Evidence
No native merchant/flight frame parking, session registration, price/fare/purchase/travel hooks, secret inspection, stock suppression, camera/CVar rewrites, global five-switch activation, speculative broad hooks or polling. Preserve Blizzard quest details, party, minimap, target aura, pet/secure controls, sparse target, no conventional player health bar, PvP modifier and Quest 237. Historical P0317 P0318 P0319 P0320 P0321 P0322 P0323 P0324 P0325 P0326 and their negative/deferral evidence remain intact.

## Relevant References
- `docs/memory/architecture/P0327_MERCHANT_FLIGHT_FIXTURE.md`, `docs/memory/evidence/P0327_MERCHANT_FLIGHT_FIXTURE.md`, `docs/memory/patches/P0327_MERCHANT_FLIGHT_FIXTURE.md`
- `docs/memory/architecture/P0326_MERCHANT_FLIGHT_AUDIT.md`, `docs/memory/decisions/D-046_PREVIEW_FIRST_UI_PIPELINE.md`, `docs/memory/decisions/D-047_SELECTIVE_NPC_PRESENTATION_AND_MODULARITY.md`, `docs/memory/decisions/D-048_FIVE_INDEPENDENT_SYSTEMS.md`
- `docs/memory/architecture/P0325_MIGRATION_DRY_RUN.md`, `docs/memory/investigations/ISSUE_REGISTER.md`, `docs/memory/evidence/P0321_GOSSIP_SINGLE_WINDOW.md`, `docs/memory/roadmap/LAUNCH_READINESS.md`, `docs/memory/handoffs/CURRENT_HANDOFF.md`, `docs/memory/investigations/ACTIVE.md`, `docs/memory/roadmap/STATUS.md`, `docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md`, `docs/ROADMAP.md`
