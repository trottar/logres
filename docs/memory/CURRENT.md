---
memory_schema: 1
as_of: 2026-09-30
project: logres
---

# Current State

## Active Objective

**Phase A — Core State Engine.** Establish the stable state/lifecycle contract and the minimal orthogonal context sensors required by later Logres modules.

## Current Work Item

**A.2 — Additional Context Sensors.**

The A.2 source review is complete enough to define the implementation.

Accepted fields:
- `mounted`;
- `resting`;
- `onTaxi`;
- `interacting`;
- `interactionType`.

Rejected/deferred:
- generic `traveling` rejected;
- flying/airborne deferred;
- vehicle deferred;
- druid travel form deferred;
- generic loss-of-control state deferred.

No HUD behavior belongs in A.2.

## Verified State

- Phase 0 — Foundation complete.
- A.1 complete and runtime proven.
- P0008 A.1 closure pushed at `c7dd8e8`.
- current documentation marks `IsMounted`, `IsResting`, and `UnitOnTaxi` available on Forever 1.60.1.
- current documentation marks PlayerInteractionManager SHOW/HIDE events available on Forever with `Enum.PlayerInteractionType` payload.
- current documentation marks `C_PlayerInteractionManager.IsInteractingWithNpcOfType` available on Forever.
- current maintained Forever-aware DynamicCam uses:
  - mounted via `IsMounted()` excluding `UnitOnTaxi("player")`;
  - `PLAYER_MOUNT_DISPLAY_CHANGED` / `UNIT_AURA`;
  - resting via `PLAYER_UPDATE_RESTING` / `IsResting()`;
  - taxi via `PLAYER_CONTROL_LOST` / `PLAYER_CONTROL_GAINED` / `UnitOnTaxi("player")`.
- these A.2 findings are source/documentation evidence, not yet Logres runtime proof.

## Next Action

Prepare the A.2 implementation patch.

Implementation requirements:
1. add the five accepted fields through the existing D-009 contract;
2. preserve state authority privacy;
3. filter `UNIT_AURA` to the player;
4. treat `PLAYER_CONTROL_LOST/GAINED` only as taxi refresh signals;
5. use Interaction Manager SHOW/HIDE payload as interaction-type authority;
6. clear interaction only when HIDE matches the current type;
7. add a travel-free sensor consistency diagnostic;
8. do not require a dedicated taxi trip.

## Success Criteria

A.2 succeeds when:
- accepted sensors are implemented with the documented semantics;
- fields publish through D-009;
- no combinatorial mega-states are introduced;
- static checks pass;
- travel-free consistency check passes;
- mounted transition is runtime proven locally;
- interaction/resting true paths are tested when convenient or explicitly deferred with rationale;
- taxi true path may be deferred until naturally encountered / Phase G;
- failures and partial verification are recorded.

## Do Not Reopen Without New Evidence

- **A.1:** complete.
- **State authority:** private to `Core/State.lua`.
- **State access:** `GetState()` / `SubscribeState()`.
- **Revision:** actual canonical transitions only.
- **No generic traveling state:** use orthogonal facts.
- **mounted:** excludes taxi.
- **resting:** literal `IsResting`, not a city alias.
- **onTaxi:** authority is `UnitOnTaxi("player")`, not control-loss events.
- **interaction:** preserve Blizzard interaction type rather than inventing a mega-category.
- **Git authority:** user performs commits/pushes.

## Relevant References

- `docs/memory/investigations/A2_CONTEXT_SENSORS.md`
- `docs/memory/evidence/A2_CONTEXT_SENSOR_SOURCE_AUDIT_2026-09-30.md`
- `docs/memory/decisions/D-009_STATE_CONSUMER_CONTRACT.md`
- `docs/memory/architecture/STATE_ENGINE.md`
- `docs/memory/roadmap/PHASE_A_CORE_STATE_ENGINE.md`
- `Logres/Core/State.lua`
