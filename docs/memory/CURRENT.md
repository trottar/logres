---
memory_schema: 1
as_of: 2026-09-30
project: logres
---

# Current State

## Active Objective

**Phase B — Core HUD.** Build Logres' identity-defining awareness layer on top of the completed Phase A contracts.

## Current Work Item

**B.1 — HUD root + player health vignette.**

The first Phase B patch should create the real HUD module and move the already-proven secret-safe player-health transport into production Logres code.

Required architecture:
- register a `HUD` module through D-011;
- own HUD frames/textures through that module;
- use D-008 secret-safe health flow;
- avoid Lua arithmetic/comparison on health;
- integrate `immersionEnabled` without adding user preference to observed State;
- no conventional player health bar/numbers;
- no action clusters yet.

## Verified State

- Phase 0 — Foundation complete.
- Phase A — Core State Engine complete.
- A.1 observed-state contract runtime proven.
- A.2 context sensors runtime proven, with ordinary mounted=true deferred by environment.
- A.3 preference contract/persistence runtime proven.
- A.4 module lifecycle runtime proven after P0015 diagnostic fix.
- A.5 real PvP flag transition runtime proven.
- integrated Phase A evidence matrix is complete.
- P0016 Phase A.5 activation pushed at `7296d1f`.
- current runtime version remains `0.0.6-dev`.
- D-008 proves the required secret-safe health-vignette transport in Forever.
- Phase B is now active.

## Next Action

Prepare B.1 implementation.

Before coding:
1. use D-002 and D-008 as hard constraints;
2. define the HUD module/frame ownership boundary;
3. choose the smallest production version of the edge vignette that proves the secret-safe transport;
4. keep initial art assets procedural/native where practical so architecture can be validated before asset polish;
5. make immersion off/on testable without travel;
6. include full deploy commands because B.1 will change runtime addon code.

A practical first runtime test should not require deliberately reaching near-death health. It should prove:
- module loads;
- healthy state is unobtrusive;
- taking ordinary damage changes the vignette;
- healing reduces/removes it;
- immersion off hides it;
- immersion on restores behavior;
- no Lua/secret-value errors occur.

## Success Criteria

B.1 succeeds when:
- a real HUD module exists;
- screen-edge health vignette is production code, not only audit code;
- health transport uses native secret-safe path;
- no conventional player health bar/numbers are introduced;
- immersion preference cleanly disables/enables presentation;
- lifecycle cleanup is correct;
- static checks enforce key secret-safe constraints where practical;
- runtime proof covers ordinary damage/heal behavior without unnecessary risk;
- failures/visual limitations are durable.

## Do Not Reopen Without New Evidence

- **Phase A:** complete.
- **mounted=true:** environmental deferral remains valid.
- **Observed state:** consume Phase A contract; do not duplicate.
- **Preferences:** consume D-010 contract.
- **Lifecycle:** consume D-011 contract.
- **Health:** D-002 + D-008 are authoritative.
- **Enemy disclosure:** D-003 remains authoritative.
- **Actions:** Phase C, not B.1.
- **Deployment:** runtime-code patch instructions must include full deploy block.
- **Git authority:** user performs commits/pushes.

## Relevant References

- `docs/memory/roadmap/PHASE_B_CORE_HUD.md`
- `docs/memory/evidence/A5_PHASE_A_TRANSITION_VALIDATION_2026-09-30.md`
- `docs/memory/decisions/D-002_PLAYER_HEALTH_PRESENTATION.md`
- `docs/memory/decisions/D-008_SECRET_SAFE_HEALTH_AND_RESOURCE_PATH.md`
- `docs/memory/decisions/D-003_ENEMY_INFORMATION_DISCLOSURE.md`
- `docs/memory/architecture/HUD.md`
- `docs/memory/architecture/SYSTEM.md`
- `docs/memory/architecture/API_BOUNDARIES.md`
