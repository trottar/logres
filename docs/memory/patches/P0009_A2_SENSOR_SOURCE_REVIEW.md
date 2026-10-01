# P0009 — A.2 context sensor source review

Date: 2026-09-30  
Result: PREPARED — not durable until user commits/pushes

## Intent

Complete the source/documentation gate required by CURRENT before modifying `Core/State.lua` for A.2.

## Accepted sensors

- mounted;
- resting;
- onTaxi;
- interacting;
- interactionType.

## Key semantics

### mounted

Player-controlled mount only; exclude taxi.

### resting

Literal Blizzard resting state.

### onTaxi

Literal flight-path state; control events are refresh signals only.

### interaction

Preserve PlayerInteractionManager enum type from SHOW/HIDE event payload.

## Rejected/deferred

Rejected:
- generic `traveling`.

Deferred:
- flying/airborne;
- vehicle;
- druid travel form;
- generic loss-of-control.

## Evidence

Adds:
`evidence/A2_CONTEXT_SENSOR_SOURCE_AUDIT_2026-09-30.md`

Canonical investigation:
`investigations/A2_CONTEXT_SENSORS.md`

## Runtime

No new runtime claim is made.

P0009 is documentation/source evidence only.

## Next

Implement accepted fields through D-009 and add low-cost runtime diagnostics.
