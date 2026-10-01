# A.2 — Additional Context Sensors

Status: ACTIVE — SOURCE REVIEW COMPLETE; IMPLEMENTATION NEXT  
Phase: A.2  
Opened: 2026-09-30

## Question

Which additional orthogonal facts should the Core State Engine expose now, and what current Forever APIs/events justify them?

## Accepted sensors

Source review accepts:

```text
mounted
resting
onTaxi
interacting
interactionType
```

Canonical source evidence:

`../evidence/A2_CONTEXT_SENSOR_SOURCE_AUDIT_2026-09-30.md`

## Semantics

### mounted

Player-controlled mount state.

Derived from:
- `IsMounted()`;
- excluding taxi with `not UnitOnTaxi("player")`.

### resting

Literal `IsResting()` state.

Do not reinterpret as "city".

### onTaxi

Literal `UnitOnTaxi("player")` flight-path state.

`PLAYER_CONTROL_LOST/GAINED` are refresh signals, not authority.

### interacting / interactionType

Event-driven PlayerInteractionManager state.

SHOW payload establishes the current type.
HIDE clears only the matching active type.

`interactionType` preserves Blizzard's enum value rather than inventing a Logres category.

## Deferred/rejected

Rejected:
- generic `traveling`.

Deferred:
- flying/airborne;
- vehicle;
- druid travel form;
- generic loss of control.

## Implementation constraints

- preserve D-009 snapshot/subscription contract;
- state authority remains private;
- no HUD behavior;
- no mega-state;
- noisy `UNIT_AURA` refresh must filter to player;
- interaction state must not depend on undocumented `GetCurrentInteractionType`;
- no dedicated taxi trip required for completion.

## Next implementation

Add the five fields to the canonical state snapshot and event wiring.

Add a development sensor diagnostic that can verify current API/state consistency without travel.

Then perform minimal runtime proof:
- `/reload`;
- sensor consistency diagnostic;
- mount/dismount locally;
- interaction/resting only when convenient.

Record taxi true-path as deferred if not naturally encountered.
