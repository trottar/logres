# A.2 — Additional Context Sensors

Status: ACTIVE — IMPLEMENTATION PREPARED; RUNTIME PROOF NEXT  
Phase: A.2  
Opened: 2026-09-30

## Accepted sensors

Implemented by P0010:

```text
mounted
resting
onTaxi
interacting
interactionType
```

Source evidence:
`../evidence/A2_CONTEXT_SENSOR_SOURCE_AUDIT_2026-09-30.md`

## Semantics

- mounted = player-controlled mount, excluding taxi;
- resting = literal `IsResting()`;
- onTaxi = literal `UnitOnTaxi("player")`;
- interaction type = PlayerInteractionManager SHOW/HIDE payload.

## Implementation details

Refresh signals:
- mount display;
- player aura;
- resting update;
- control lost/gained;
- interaction manager show/hide.

Interaction state is event-latched because no universal documented current-type getter is assumed.

A mismatched HIDE does not clear a newer active type.

## Development diagnostic

P0010 adds:

```text
/logres sensorcheck
```

It compares current snapshot values with direct mounted/resting/taxi APIs and checks interaction field consistency.

## Runtime plan — optimized for current player location

The user reported being in Ironforge, next to a flight path, with a Thunderbrew hearth.

Use the existing location rather than creating a travel-heavy matrix.

1. `/reload`
2. `/logres statecheck`
3. `/logres sensorcheck`
4. `/logres status`
5. mount/dismount where permitted, checking status
6. open/close any nearby ordinary interaction frame and check status
7. take any convenient short flight path:
   - during flight: `onTaxi=true`;
   - `mounted=false` by Logres semantics
8. after landing: verify taxi returns false
9. resting true/false observations are accepted wherever naturally encountered; no dedicated detour required.

## Completion rule

A.2 does not require every sensor true-path to be forced artificially.

Minimum desired runtime evidence:
- diagnostic passes;
- mounted transition;
- taxi transition if convenient (currently convenient);
- one interaction transition if nearby;
- resting current state agrees with direct API.

Any missing true-path is explicitly deferred.

## Deferred sensors

- generic traveling: rejected;
- flying/airborne;
- vehicle;
- druid travel form;
- generic loss of control.
