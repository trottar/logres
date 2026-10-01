# P0010 — A.2 context sensors

Date: 2026-09-30  
Result: PREPARED — runtime proof pending

## Intent

Implement the A.2 sensor set selected by P0009.

## Fields added

- mounted;
- resting;
- onTaxi;
- interacting;
- interactionType.

## Semantics

### mounted

`IsMounted()` excluding taxi.

### resting

`IsResting()`.

### onTaxi

`UnitOnTaxi("player")`.

### interaction

Event-latched Interaction Manager SHOW/HIDE type.

## Events added

- PLAYER_MOUNT_DISPLAY_CHANGED;
- UNIT_AURA, filtered to player;
- PLAYER_UPDATE_RESTING;
- PLAYER_CONTROL_LOST;
- PLAYER_CONTROL_GAINED;
- PLAYER_INTERACTION_MANAGER_FRAME_SHOW;
- PLAYER_INTERACTION_MANAGER_FRAME_HIDE.

## Interaction negative constraint

No universal undocumented current-interaction getter is introduced.

A mismatched HIDE cannot erase a newer active type.

## Diagnostic

Adds:

`/logres sensorcheck`

It verifies current snapshot consistency against direct mounted/resting/taxi APIs.

## Runtime strategy

The user is already near the Ironforge flight path.

Use:
- local mount/dismount;
- nearby NPC interaction;
- one convenient taxi leg.

During taxi:
- `onTaxi=true`;
- `mounted=false`.

No dedicated long travel is required.

## Runtime claim

None yet.

## Validation

```text
python3 tools/check_memory_health.py
python3 tools/check_addon_structure.py
python3 tools/check_state_contract.py
git diff --check
```
