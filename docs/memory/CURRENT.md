---
memory_schema: 1
as_of: 2026-10-24
project: logres
---

# Current State

## Active Objective
Prepare a reliable public-alpha-quality WoW Forever Logres and quality-gated 1.0 using D-048's five independently selectable NAV/ACT/NPC/STATUS/CAM systems, with stock fallback and preservation of accepted runtime functionality. November 4 is a proposed opportunity to validate in-client; Forever public-launch date is unconfirmed.

## Current Work Item
**P0325 — backward-compatible five-domain migration DRY-RUN / PURE PYTHON + DOCS + STATIC CONTRACT ONLY, PREPARED.** Verified pushed P0324 `bc56185` on GitHub main. P0323's 94-module ownership audit and P0324's 32 requested-state offline fixtures are durable. P0325 does not implement a saved-schema migration or a live selector. It proposes staged opt-in `legacy` bridge behavior without inferring camera ownership. After P0325 GitHub verification, the next narrow task is merchant/flight source and service-handoff review; any actual five-domain Lua activation remains gated by Forever proof.

## Verified State
- P0324 pushed `bc56185`: pure `tools/p0324_domain_policy.py` fixture with **32** masks, capability fallback, pending native restoration and legacy passthrough; no addon-loaded code. P0323 pushed `386a7ef` source audit; P0322 pushed `272130e` D-048 decision/launch issue register. Earlier P0322 R0 checker-version failure remains recorded.
- P0317/P0318/P0319/P0320 maintain scoped positive user evidence for dialogue, gossip choices and quest-title links. P0321 pushed `9a180c8`, but gossip native root parking/restoration remains **WoW UNVERIFIED / DEFERRED until November 4**. Native merchant/flight transactions and quest detail remain Blizzard-owned; Quest 237 remains reserved.
- `Core/Database.lua` schema 3 and `Core/Preferences.lua` still persist only `immersionEnabled` and `activeQuestEnabled`. Immersion still drives ACT/player/target suppression, Quiet Mode, and compass; NPC dialogue also conditions presentation on it. No five live toggles or migration. D-047 freezes Camera/DynamicCam.
- P0325 adds standalone offline planning/tests only, not an automatic `LogresDB` change. Existing `ISSUE_REGISTER.md` L-001–L-018 statuses and all previous runtime/negative evidence remain authoritative.

## Next Action
Apply P0325 only on exact clean pushed P0324 `bc56185`, require **196/196 PREWRITE and POSTWRITE** checkers plus exact-candidate diff hygiene, manifest and `git diff --check`; user commits/pushes then verify GitHub main. **No WoW redeploy** for this offline checkpoint. After P0325, read-only merchant/flight native-source assessment (P0326 candidate) can proceed while awaiting November 4 gossip parking/restoration and baseline regression tests. Never interpret a pure migration proposal as production ownership or restore evidence.

## Success Criteria
All four legacy Boolean combinations preserve schema-3 contents, optional five-domain opt-ins are independent and explicit, all 32 full requested-mode combinations match P0324, and no auto CAM inference occurs. Offline input/output is immutable and not linked into `Logres.toc`; no runtime Lua, saved data, camera, action/pet, NPC parking, stock UI, schema or version change. Later migration must be separately designed and tested within WoW.

## Do Not Reopen Without New Evidence
No mass automatic five-boolean migration, runtime system switches, native suppression, protected execution, P0321 gossip parking rewrite, camera profile/CVar changes or polling. Preserve player health identity, sparse enemy target, stock minimap/party/auras, native quest and transaction details, Quest 237, PvP modifier and all L-001–L-018 deferrals. Frozen accepted runtime behavior outranks speculative modular tidiness.

## Relevant References
- `docs/memory/architecture/P0325_MIGRATION_DRY_RUN.md`, `docs/memory/evidence/P0325_MIGRATION_DRY_RUN.md`, `docs/memory/patches/P0325_MIGRATION_DRY_RUN.md`
- `docs/memory/architecture/P0324_POLICY_FIXTURE.md`, `docs/memory/architecture/P0323_MODULE_OWNERSHIP_AUDIT.md`, `docs/memory/decisions/D-048_FIVE_INDEPENDENT_SYSTEMS.md`
- `docs/memory/roadmap/LAUNCH_READINESS.md`, `docs/memory/investigations/ISSUE_REGISTER.md`, `docs/memory/evidence/P0321_GOSSIP_SINGLE_WINDOW.md`
- `docs/memory/decisions/D-046_PREVIEW_FIRST_UI_PIPELINE.md`, `docs/memory/decisions/D-047_SELECTIVE_NPC_PRESENTATION_AND_MODULARITY.md`, `docs/memory/handoffs/CURRENT_HANDOFF.md`, `docs/memory/investigations/ACTIVE.md`, `docs/memory/roadmap/STATUS.md`, `docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md`, `docs/ROADMAP.md`
