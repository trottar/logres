# P0146 Evidence — P0145 Manual-Waypoint Distance / Bounded Depth Runtime Result

Date: 2026-10-05
Runtime: `0.0.70-dev`
Durable implementation commit: `60244841d0ecfa35b58c7db60293145b8962b6dc`
Classification: **RUNTIME + INTEGRATION PASS FOR P0145 CHANGED SCOPE; P0123 OFF-TAPE BASELINE RETAINED**

## Purpose

Close the P0145 runtime gate for the newly added same-map manual-waypoint distance
and bounded depth-scale path without widening navigation ownership.

## Populated same-map samples

Recorded `Compass Check` PASS samples:

1. `waypoint=true`, bearing `198.4`, relative `-1.7`, marker true,
   distance `115.8` yards, depth `1.050`, render scale `1.108`,
   `distanceReason=distance-available`.
2. `waypoint=true`, bearing `168.3`, relative `4.5`, marker true,
   distance `45.5` yards, depth `1.050`, render scale `1.082`,
   `distanceReason=distance-available`.
3. `waypoint=true`, bearing `170.2`, relative `6.7`, marker true,
   distance `51.7` yards, depth `1.050`, render scale `1.062`,
   `distanceReason=distance-available`.
4. After a later reload/session, `waypoint=true`, bearing `164.5`, relative `1.9`,
   marker true, distance `116.0` yards, depth `1.050`, render scale `1.106`,
   `distanceReason=distance-available`.

All observed populated samples stayed inside the accepted P0145 bounds:
- distance is non-negative;
- depth scale is within `0.90–1.05`;
- visible combined render scale is within `0.90–1.12`.

## Clear-state fallback

After the user waypoint was removed, `Compass Check` reported PASS with:
- `waypoint=false`;
- `bearing=nil`;
- `relative=nil`;
- `marker=false`;
- `distanceAPI=true`;
- `distance=false`;
- `yards=nil`;
- `depth=1.000`;
- `renderScale=nil`;
- `distanceReason=waypoint-absent`;
- `waypointReason=waypoint-absent`.

This closes the stale-distance / stale-marker concern for the observed removal path.

## Integrated result

Before the final targeted clear-state capture, integrated `Run All` completed on
`0.0.70-dev` with `compasscheck: PASS` and no recorded Lua, secret-value, taint,
protected-action, or source failure in the reported checks.

A second full `Run All` was not required solely for the clear-state diagnostic
because the targeted check directly exercised the missing branch and passed.

## Off-tape boundary

P0145 did not capture a new off-tape diagnostic row.

The canonical runtime evidence for off-tape suppression remains P0123:
- real waypoint relative `115.5` degrees;
- `marker=false`.

P0145's new depth/render-scale application is downstream of the existing
`magnitude > VISIBLE_HALF_ANGLE` return. Therefore this checkpoint records:
- P0123 as the actual runtime evidence for off-tape behavior;
- P0145 as runtime evidence for the changed distance/depth and clear-state paths;
- no claim that P0145 independently re-sampled off-tape behavior.

## Capability conclusion

Accepted:
- manual user waypoint bearing;
- ordinary same-map comparable yard distance when required inputs are ordinary;
- restrained bounded depth scale;
- fail-open clear state without stale distance/marker presentation.

Still not authorized/proven:
- quest destination production markers;
- current-navigation production markers;
- AreaPOI/service production markers;
- detected tracking-result markers;
- manual waypoint identity text;
- exact distance text;
- stock minimap suppression.

P0142/D-043 and P0143 deferrals remain authoritative for those domains.
