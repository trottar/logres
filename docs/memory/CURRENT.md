---
memory_schema: 1
as_of: 2026-10-01
project: logres
---

# Current State

## Active Objective

**Phase B — Core HUD.**

## Current Work Item

**B.3 — Target Presentation.**

B.2 is complete.

The production primary-resource percentage is runtime proven on P0021:
- visible lower-center percentage;
- updates while resource changes;
- immersion off hides it;
- immersion on restores it;
- no secret-value/Lua error reported.

B.3 now owns sparse current-target presentation.

## Verified State

- Phase A complete.
- B.1 player health vignette complete.
- B.2 primary resource percentage complete.
- P0021 pushed at `66b27a3`.
- current runtime version: `0.0.9-dev`.
- target level/classification are technically available from prior audit evidence.
- product policy intentionally withholds numeric level and elite/rare classification by default.
- target health/power percentages are secret-capable.

## Next Action

Design/source-check B.3 before implementing it.

Resolve:
1. target-name API/event path on Forever;
2. secret-safe target health percentage formatting;
3. minimal target update events;
4. whether target resource percentage belongs in the initial patch or should remain optional;
5. no-target/target-change visibility behavior;
6. initial anchor relative to player resource/cast-confirmation space.

Hard rule:
do not expose numeric level or elite/rare classification in default target UI.

Do not build a conventional target frame.

When B.3 runtime code is prepared, include the full deploy block before in-game validation.

## Success Criteria

B.3 succeeds when:
- no target -> presentation absent;
- target acquisition shows sparse name + health percentage;
- target health updates correctly;
- target changes/clears cleanly;
- immersion off/on hides/restores presentation;
- default UI exposes no numeric level/classification;
- no portrait-heavy frame or health bar is added;
- no secret-value/Lua errors occur.

## Do Not Reopen Without New Evidence

- **B.1:** complete.
- **B.2:** complete.
- **Player resource:** current-character primary-resource path proven.
- **Target disclosure:** D-003 is authoritative.
- **Target health/power:** secret-capable.
- **Actions:** Phase C.
- **Deployment:** full deploy block required for runtime-code tests.
- **Git authority:** user performs commits/pushes.

## Relevant References

- `docs/memory/evidence/B2_RESOURCE_PRESENTATION_RUNTIME_PROOF_2026-10-01.md`
- `docs/memory/investigations/B3_TARGET_PRESENTATION.md`
- `docs/memory/decisions/D-003_ENEMY_INFORMATION_DISCLOSURE.md`
- `docs/memory/decisions/D-008_SECRET_SAFE_HEALTH_AND_RESOURCE_PATH.md`
- `docs/memory/architecture/HUD.md`
- `docs/memory/evidence/I001_RUNTIME_PASS_02_2026-09-30.md`
