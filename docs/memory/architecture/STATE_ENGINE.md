# State Engine Architecture

## Principle

Logres separates **state detection** from **presentation policy**.

State detection answers facts.
Presentation policy later decides what those facts mean visually.

## Authority boundary

The authoritative mutable state table is private to `Core/State.lua`.

Consumers use:

```lua
local state = Logres:GetState()
```

and optionally:

```lua
local unsubscribe = Logres:SubscribeState(function(current, previous, changes, reason)
end)
```

See D-009 for the canonical consumer contract.

## A.2 canonical snapshot

```lua
{
    initialized = boolean,
    revision = number,

    context = "unknown" | "world" | "instance",
    combat = boolean,
    pvpFlagged = boolean,
    inInstance = boolean,
    instanceType = string,

    mounted = boolean,
    resting = boolean,
    onTaxi = boolean,

    interacting = boolean,
    interactionType = number,

    changedBy = string,
}
```

All values are scalar.

## Sensor semantics

### mounted

Player-controlled mount state.

Implementation:

```text
IsMounted() and not UnitOnTaxi("player")
```

Taxi is deliberately excluded.

### resting

Literal:

```text
IsResting()
```

Do not reinterpret as city/inn/safe.

### onTaxi

Literal:

```text
UnitOnTaxi("player")
```

`PLAYER_CONTROL_LOST/GAINED` are refresh signals only.

### interacting / interactionType

Interaction Manager event-latch state.

`PLAYER_INTERACTION_MANAGER_FRAME_SHOW(type)`:
- stores `type`;
- refreshes state.

`PLAYER_INTERACTION_MANAGER_FRAME_HIDE(type)`:
- clears only when `type` matches the currently active interaction type;
- refreshes state.

No undocumented current-type getter is assumed.

On `PLAYER_ENTERING_WORLD`, the latch resets to none as a conservative world-transition baseline.

## Refresh events

Existing:
- `PLAYER_LOGIN`;
- `PLAYER_ENTERING_WORLD`;
- `ZONE_CHANGED_NEW_AREA`;
- combat/restriction signals;
- player flags.

A.2 adds:
- `PLAYER_MOUNT_DISPLAY_CHANGED`;
- player-filtered `UNIT_AURA`;
- `PLAYER_UPDATE_RESTING`;
- `PLAYER_CONTROL_LOST`;
- `PLAYER_CONTROL_GAINED`;
- Interaction Manager SHOW/HIDE.

## Revision semantics

Unchanged from D-009:
- first initialization -> revision 1;
- +1 per actual canonical transition;
- no-op observations do not increment or publish.

## Orthogonal-state constraint

Do not collapse:

```text
mounted + onTaxi + resting + interacting
```

into `traveling`, `cityMode`, or other combinatorial modes.

Consumers compose facts.

## Development validation

### `/logres statecheck`

Validates state consumer contract.

### `/logres sensorcheck`

Compares snapshot values to current APIs for:
- mounted;
- resting;
- taxi.

Also verifies interaction boolean/type consistency.

It does not claim to prove that no untracked interaction exists, because there is no universal documented current-interaction getter.

## Current deferrals

- flying/airborne;
- vehicle;
- druid travel form;
- generic loss of control.

These remain outside A.2 unless a future owner requires them.
