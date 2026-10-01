# A.2 — Additional Context Sensors

Status: COMPLETE WITH ENVIRONMENTAL DEFERRAL  
Phase: A.2  
Opened: 2026-09-30  
Closed: 2026-09-30

## Implemented sensors

```text
mounted
resting
onTaxi
interacting
interactionType
```

Source evidence:
`../evidence/A2_CONTEXT_SENSOR_SOURCE_AUDIT_2026-09-30.md`

Runtime evidence:
`../evidence/A2_CONTEXT_SENSOR_RUNTIME_PROOF_2026-09-30.md`

## Runtime result

### resting

Runtime verified:
- true in Ironforge;
- false after leaving the resting area during taxi travel.

### onTaxi

Runtime verified during a real flight-path trip.

### interaction

Runtime verified through open/close interaction behavior.

### mounted

The ordinary mounted=true path remains unverified because the current beta/character test environment does not permit a practical mount test.

Status:
**DEFERRED BY ENVIRONMENT**

This is not an implementation failure.

The taxi test did verify the important design rule that taxi travel is tracked independently from ordinary mounting.

## Durable semantics

- mounted = player-controlled mount, excluding taxi;
- resting = literal `IsResting()`;
- onTaxi = literal `UnitOnTaxi("player")`;
- interaction type = PlayerInteractionManager SHOW/HIDE payload;
- no generic `traveling` mega-state.

## Deferred/rejected sensor set

Rejected:
- generic traveling.

Deferred:
- flying/airborne;
- vehicle;
- druid travel form;
- generic loss of control.

## Completion judgment

A.2 is complete because:
- every implemented sensor except mounted=true has runtime evidence;
- the remaining mount true-path is blocked by the current test environment rather than by an unresolved API/architecture question;
- the state contract and semantics are sufficient for downstream work.

Do not keep A.2 open indefinitely for an environment the user cannot currently produce.

## Retry condition for mounted=true

Reopen only when:
- the test environment permits ordinary mounting;
- or a later owning phase naturally exercises a mount-capable character/build.

## Next

Proceed to **A.3 — User-Controlled State**.
