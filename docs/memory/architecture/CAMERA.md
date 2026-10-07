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
- observed normal-world transition behavior through P0156.

Taxi zoom ownership is implemented but the normal-Taxi landing retest remains
pending.

P0159 broadens the same production controller to the captured RPG profile's
remaining source-backed context/zoom situations: Hearth/Teleport, AFK,
Gathering, NPC Interaction, and Fishing. Runtime acceptance is required before
those new branches are called proven.

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
**P0119/P0156 SHARED DRIVER DURABLE; NORMAL-TAXI LANDING RETEST PENDING.**

G.6 current:
**P0159 CAPTURED-PROFILE CONTEXT+ZOOM PARITY PREPARED.**

The earlier Camera sequencing freeze is superseded. Camera remains ahead of
Phase H until the captured profile's deliberate camera behaviors are migrated in
consolidated layers.

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
