# A.2 Context Sensor Runtime Proof — 2026-09-30

Status: VERIFIED WITH ONE ENVIRONMENTAL DEFERRAL  
Scope: Additional context sensors  
Baseline commit: `a1f119a44a2474fcd44e60047dadc7fe6ede624c`

## Test environment

The user tested P0010 in and around Ironforge with a nearby flight path.

The current test character was level 14.

The user reported that the current beta environment will not permit reaching a state where an ordinary player mount can be tested during this beta session.

Therefore the mounted=true path could not be exercised.

This is an environmental limitation, not an observed addon failure.

## General result

The user reported:
- no issues observed;
- the tested context sensors behaved correctly.

No Lua errors were reported in the tested scope.

## Resting — RUNTIME VERIFIED

In Ironforge:
- Logres correctly reported resting true.

During the flight, after leaving the resting area:
- resting changed to false.

This confirms:
- the current `IsResting()`-based state is reflected by Logres;
- `PLAYER_UPDATE_RESTING` / other active refresh flow was sufficient in the tested transition;
- resting is correctly treated as a raw orthogonal fact rather than a permanent city label.

Result:

**PASS**

## Taxi — RUNTIME VERIFIED

The user took a flight path and reported that taxi state behaved correctly.

The test covered the true path and the later return from taxi after the flight.

Result:

**PASS**

Architecture consequence:
- `onTaxi` is suitable as an independent state fact;
- taxi behavior does not need to be collapsed into a generic traveling state.

## Mounted-vs-taxi separation — RUNTIME VERIFIED FOR TAXI CONTEXT

During the taxi test, the observed state looked correct under the intended semantics.

Logres defines:

```text
mounted = IsMounted() and not onTaxi
```

The taxi scenario therefore exercised the critical separation between:
- taxi travel;
- ordinary player-controlled mounting.

Result:

**PASS IN TAXI CONTEXT**

This does not prove the ordinary mounted=true path.

## Interaction — RUNTIME VERIFIED

The user exercised a nearby interaction and reported that interaction state behaved correctly.

The tested flow covered:
- interaction open;
- interaction state/type present;
- close;
- return to non-interacting state.

Result:

**PASS**

This supports the event-latched PlayerInteractionManager SHOW/HIDE implementation.

## Mounted=true — DEFERRED BY ENVIRONMENT

The ordinary mount true-path was not tested.

Reason:
- the current character is level 14;
- the user reports the current beta level cap/test environment does not permit reaching a usable mount-test state.

Status:

**DEFERRED BY ENVIRONMENT**

Retry condition:
- a future build/test character can actually mount;
- or Phase G naturally gains access to a mount-capable test environment.

Until then:
- source/documentation support remains available;
- false-state and taxi-exclusion logic remain covered;
- do not claim runtime proof of `mounted=true`.

## Failures

No implementation failure was observed within the tested A.2 scope.

The untested mounted=true path is not counted as a failure.

## Conclusion

A.2 has sufficient evidence to close.

Verified:
- resting true/false transition;
- taxi transition;
- taxi/mount semantic separation in taxi context;
- interaction open/close state.

Deferred:
- ordinary mounted=true path due environment.

**A.2 — Additional Context Sensors: COMPLETE WITH ENVIRONMENTAL DEFERRAL.**
