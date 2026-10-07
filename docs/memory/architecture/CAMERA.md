# Camera Architecture

## Product intent

Camera behavior is being integrated into Logres rather than requiring a separate
DynamicCam profile.

## Durable profile evidence

G.1 captured the current DynamicCam profile on 2026-10-02.

Canonical evidence:
- `../evidence/G1_DYNAMICCAM_PROFILE_CAPTURE_2026-10-02.md`
- `../evidence/G1_DYNAMICCAM_RPG_PROFILE_2026-10-02.json`

Request another export only if the profile changes or later evidence conflicts.

## Current production ownership

Runtime-proven production Logres camera ownership covers:
- World;
- World (Combat);
- City/resting;
- P0159 profile/context baseline;
- Taxi entry/target `50` twice.

P0159 R1 is durable at `8ddcf098` / `0.0.78-dev`.

The real post-Taxi destination transition remains failed: City start about `49.75597`, target `5`, final `0`, `97` samples, `80` direction switches, and max absolute easing-position error about `49.471`.

This failure is in the shared bespoke zoom engine, not in Taxi or captured-profile context selection.

P0160 R2 therefore replaces the timing/correction path with source-backed LibCamera zoom semantics before any further profile expansion.

## Taxi precedence and zoom intent

Inside the existing non-instance boundary, the source-resolved intended order is:
1. Taxi;
2. interaction remains fail-open until separately replaced;
3. live combat;
4. City/resting;
5. World.

Taxi intended zoom:
- conditional-out absolute target `50`;
- entry `5` seconds;
- restore `never`;
- ordinary exit uses destination entering time.

## Target-50 no-CVar result

Canonical:
`../evidence/G5_P0109_TARGET50_NEGATIVE_2026-10-03.md`.

Runtime `0.0.44-dev` repeatedly observed:
- current factor `1.2`;
- effective ceiling `18`;
- target `50`;
- actual turn zoom `18`;
- target not reached;
- movement/restoration successful;
- CVar unchanged;
- secret=false.

This remains valid capability evidence: physical zoom 50 is not reachable under
the measured no-CVar-mutation ceiling.

It does **not** mean the captured DynamicCam Taxi action cannot be reproduced.
Pinned DynamicCam/LibCamera requests 50 and accepts the engine clamp.

## Camera-distance source model

Canonical:
`../evidence/G5_CAMERA_DISTANCE_SOURCE_AUDIT_2026-10-03.md`.

Pinned DynamicCam maps displayed camera distance as:

`cameraDistanceMaxZoomFactor * 15`

and allows displayed 50 for non-mainline projects.

Therefore target 50 requires factor >= `50 / 15`.

DynamicCam standard max-distance initializes from the client
`GetCVarDefault("cameraDistanceMaxZoomFactor")`.

The captured G.1 profile has no explicit standard max-distance field, and Taxi
has no situation-specific max-distance override.

DynamicCam applies CVar settings independently from situation zoom; Taxi zoom
does not automatically raise max-distance merely because its target is 50.

Pinned LibCamera does not mutate `cameraDistanceMaxZoomFactor`.

## P0112 read-only metadata result

Canonical:
`../evidence/G5_P0112_CAMERA_DISTANCE_INFO_2026-10-03.md`.

Runtime `0.0.45-dev` `Camera Distance Info` PASS recorded:
- source `C_CVar.GetCVarInfo`;
- current factor `1.2`, ceiling `18`;
- default factor `1`, ceiling `15`;
- required target-50 factor `3.3333333333333`;
- current/default support false/false;
- account-stored=true;
- character-stored=false;
- locked=false;
- secure=false;
- readOnly=false;
- DynamicCam not loaded;
- secret=false;
- error=nil.

The client default cannot satisfy target 50. The current value is also
insufficient and differs from default, so future restoration must preserve the
captured pre-ownership current value rather than resetting to default.

## DynamicCam parity correction

Canonical:
`../evidence/G5_DYNAMICCAM_TAXI_PARITY_CORRECTION_2026-10-03.md`.

DynamicCam treats Taxi target `50` as a requested conditional-out target.
LibCamera drives toward that requested value while the engine may clamp visible
distance to the current max-distance ceiling. DynamicCam does not require
literal target reachability for situation success.

Therefore the earlier conclusion that Logres must first make physical zoom 50
reachable is superseded.

For the narrow production Taxi zoom slice, Logres keeps requested target `50`,
records the live factor/ceiling only for diagnostics, and does not mutate the
max-distance CVar.

## Ownership boundary

Camera-distance mutation remains **not authorized** and is no longer required
for the Taxi zoom slice.

The CVar is account-stored according to runtime metadata. A future temporary
write would therefore be deliberate ownership of a persistent user setting,
not merely use of the inherited DynamicCam default.

If a later mutation capability is justified, it must separately define:
- old-value capture;
- restore ownership;
- concurrent user/other-addon change handling;
- combat/protected behavior;
- disable/logout/reload behavior;
- fail-open state.

No periodic reassertion is permitted without evidence.

## Taxi rotation / UI boundaries

Taxi rotation speed `-20` remains a separate continuous-yaw capability.

Taxi UI hide/fade remains presentation policy.

Neither is part of the camera-distance checkpoint.

## Diagnostic ownership

Phase G includes:
- Camera World/Combat controls;
- Camera Zoom Probe;
- Taxi Target 50 Probe;
- Camera Distance Info.

Camera Distance Info is read-only and does not require production camera
ownership to be disabled.

## Implementation sequence

G.1: **COMPLETE — profile captured.**

G.2: **COMPLETE — primary camera capability PASS.**

G.3: **COMPLETE — World/Combat production ownership PASS.**

G.4: **COMPLETE — City ownership PASS on `0.0.43-dev`.**

G.5 target 50 without max-distance mutation:
**COMPLETE — CLEAN NEGATIVE on `0.0.44-dev`.**

G.5 camera-distance default/metadata proof:
**COMPLETE — READ-ONLY PASS on `0.0.45-dev`; DEFAULT FACTOR 1 / CEILING 15 CANNOT SUPPORT TARGET 50.**

G.5 DynamicCam parity correction:
**RESOLVED — REQUESTED TARGET 50 MAY BE ENGINE-CLAMPED.**

G.5 P0117 runtime:
**TAXI ENTRY PASS / LANDING TRANSITION FAIL on `0.0.47-dev`.**

G.5 current:
**P0159 TAXI ENTRY PASS / DESTINATION ZOOM FAIL; P0160 R2 SOURCE-BACKED LIBCAMERA ZOOM DRIVER PREPARED.**

G.6 current:
**P0159 R1 DURABLE; CONTEXT/ZOOM SELECTION PARTIALLY RUNTIME-PROVEN; REMAINING PROFILE PARITY QUEUED BEHIND ZOOM-ENGINE PASS.**

The custom transition driver is no longer the architectural target. The audited LibCamera source is the zoom-motion authority for P0160 R2.

The earlier blanket no-SetCVar rule is narrowed: temporary `cameraZoomSpeed` ownership is allowed only for the source final correction with exact restoration. `cameraDistanceMaxZoomFactor` remains outside Logres ownership.

## P0117 landing overshoot failure

Canonical:
`../evidence/G5_P0117_TAXI_LANDING_OVERSHOOT_2026-10-03.md`.

The landing City transition from zoom `18` toward `5` reached `0` / first person.
Earlier `0.0.43-dev` diagnostics show the same City overshoot, so the defect
predates Taxi production ownership. P0119 replaces the one-shot constant-rate
MoveView drive with frame-shaped velocity and bounded correction.


## P0159 captured-profile parity layer

P0159 uses the already-captured RPG profile rather than asking for another export.

Priority order:
Taxi 1000 -> Teleport 130 -> AFK/Gathering 120 -> NPC Interaction 110 ->
World Combat 50 -> Fishing 20 -> City 1 -> World 0.

Layer 1 owns context + zoom only. AFK intentionally owns no zoom action. Fishing's
upstream delay is an exit hold, not an activation delay.

Layer 2 will address source-backed rotation plus shoulder/global camera-setting
ownership/restoration. DynamicCam UI hide/fade is presentation policy and must be
reconciled with Phase H suppression/coexistence.

The max-distance CVar remains outside Logres ownership.


## P0160 R2 source-backed zoom engine

Canonical source audit:
`../evidence/P0160_LIBCAMERA_ZOOM_SOURCE_AUDIT_2026-10-07.md`.

Audited source:
`mpstark/LibCamera@c0b23135a0b24fbca24b41cb53dd7afc9114e352`.

P0160 R2 ports the ordinary LibCamera SetZoom mechanics into the production controller instead of continuing bespoke fixes.

Source semantics adopted:
- InOutQuad;
- 1/60 finite-difference easing velocity;
- actual-position/easing-time rebase above 0.5 error;
- rebase precision 0.005 / max 100 iterations;
- direct final-two-frame correction;
- final 0.1-second CameraZoom correction;
- temporary cameraZoomSpeed capture/set/restore.

Logres-specific safety retained:
- secret checks before interpreting CVar/zoom values;
- pcall around mutable calls;
- exact restoration token;
- DynamicCam fail-open coexistence;
- stop-before-reverse;
- no max-distance CVar mutation;
- no timer/ticker polling.

The next profile layer after runtime acceptance is rotation plus camera-setting ownership/restoration, not another bespoke zoom adjustment.
