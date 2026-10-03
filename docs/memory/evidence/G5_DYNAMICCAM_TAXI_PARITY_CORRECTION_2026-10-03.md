# G.5 DynamicCam Taxi Parity Correction — 2026-10-03

Status: **SOURCE-RESOLVED — PRIOR TARGET-50 REACHABILITY GATE SUPERSEDED**
Date: 2026-10-03
Logres baseline: P0116 `c64fcc97`
Pinned DynamicCam: `ae586a9c973c3f868c10440358d4a6e8c2fab5ff`
Pinned LibCamera: `c0b23135a0b24fbca24b41cb53dd7afc9114e352`

## Trigger

The project had been treating the captured Taxi `zoomType=out`, `zoomValue=50`
as a requirement that physical camera zoom must actually reach 50 before
production Taxi ownership could be implemented.

That interpretation was too strong.

Phase G's product objective is to translate the user's established DynamicCam
behavior into Logres, so pinned DynamicCam plus LibCamera is the behavioral
reference.

## DynamicCam situation behavior

Pinned DynamicCam:
- resolves Taxi `viewZoom.zoomValue` as the requested conditional-out target;
- passes that target to LibCamera with the configured situation transition time;
- does not preflight physical reachability under
  `cameraDistanceMaxZoomFactor`;
- does not make physical target reachability a situation-success gate.

The captured RPG Taxi situation stores:
- conditional-out target `50`;
- transition time `5` seconds;
- rotation `-20`;
- UI hide/fade;
- no Taxi-specific max-distance override.

## LibCamera behavior

Pinned LibCamera drives toward the requested target through the normal MoveView
camera path for the requested transition.

It does not raise `cameraDistanceMaxZoomFactor` to make target `50` physically
reachable. The client is therefore free to clamp the visible camera distance to
its current ceiling.

DynamicCam's Taxi `50` is consequently a **requested target**, not a promise that
physical camera zoom 50 will be reached.

## Existing Forever evidence remains valid

P0109 and P0112 remain authoritative measurements:
- current factor `1.2`, physical ceiling `18`;
- client default factor `1`, physical ceiling `15`;
- neither physically reaches 50;
- the CVar is account-stored and was not reported locked, secure, or read-only.

Those measurements remain useful for later broader DynamicCam CVar migration.
They are no longer a blocker for the narrow Taxi zoom action.

## Correct Logres parity contract

For the narrow Taxi zoom slice:
- activation remains authoritative `state.onTaxi`;
- instance remains the outer fail-open boundary;
- Taxi outranks interaction, live combat, City, and World;
- requested target remains `50`;
- ordinary Taxi transition duration remains `5` seconds;
- Logres does **not** call `SetCVar`;
- the live max-distance factor is read only to record the current physical
  ceiling for diagnostics;
- the diagnostic effective endpoint is
  `min(50, cameraDistanceMaxZoomFactor * 15)`;
- motion continues toward requested target `50` for the Taxi transition even
  when the engine clamps physical distance below it;
- an engine/geometry-limited endpoint is not a Taxi controller failure;
- Taxi exit immediately reevaluates destination context under the existing
  restore-never semantics;
- rotation and UI hide/fade remain separately gated.

## Superseded interpretation

P0109 and P0112 remain valid runtime evidence.

Superseded only:
the derived conclusion that production Taxi zoom must wait until Logres can make
physical zoom 50 reachable.

Above-default max-distance ownership is therefore no longer a prerequisite for
this Taxi slice. No max-distance mutation is authorized here.

## Delivery history

A provisional camera patch initially used P0115 while parallel visual work was
also in flight. Its first applier failed before tracked writes because it used a
global unique text anchor that occurred in both `FinishTransition()` and
`OnUpdate()`.

The corrected provisional camera P0115 R2 was not applied before the durable
visual P0115 was pushed at `4ba63931`.

Camera work was then rebased as a provisional P0116, but before it was applied,
the durable production action-visual P0116 was pushed at `c64fcc97`.

P0117 is the first camera artifact based on both durable visual checkpoints.
It scopes repeated source replacements to owning function blocks, verifies exact
baseline blobs, and rolls back patch-owned files on post-write validation
failure.

## Implementation authorization

P0117 is authorized to extend the existing production camera controller with
Taxi zoom under this source-parity contract.

No max-distance mutation.
No Taxi rotation.
No Taxi UI fade.
No new polling.
