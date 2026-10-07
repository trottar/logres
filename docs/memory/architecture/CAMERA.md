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
- City/resting conditional zoom;
- captured-profile ordinary context selection;
- normal Taxi outbound target `50`;
- normal Taxi landing return to target `5`;
- source-backed LibCamera zoom rebasing in both outbound and return directions.

P0160 R2 is durable at `ae75989b` / `0.0.79-dev`.

The accepted Taxi sample replaced the earlier oscillation:
- outbound `~4.0096 -> 50`, final `50`, failures `0`;
- landing `50 -> 5`, final `~4.9806`, failures `0`;
- direction switches `0` both ways;
- source rebases `2` both ways.

The user visually confirmed the camera zoomed out and returned close after landing.

P0161 adds the captured-profile rotation/settings layer and is runtime-accepted for the observed Taxi/settings/shoulder-offset scope at `2a959094` / `0.0.80-dev`. P0162 R3 adds the final non-presentation reactive mouse-wheel layer and is runtime-accepted at `4628f49e` / `0.0.81-dev`.

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

P0160 established temporary `cameraZoomSpeed` ownership for LibCamera's source final correction with exact restoration.

P0161 adds a broader but still bounded camera-setting ownership contract.

Profile-owned while Logres camera ownership is active:
- the exact stored standard dynamic-pitch and target-focus settings;
- zoom-based shoulder offset;
- the explicit City `cameraDistanceMaxZoomFactor = 1` situation override.

The canonical SavedVariables profile does **not** store a standard max-distance value. Logres therefore does not invent one. It captures the live pre-ownership max-distance token and uses the ordinary numeric value, when safely readable, as the non-City baseline. City temporarily targets factor `1`; leaving City returns toward the captured baseline.

Before mutation P0161 captures every owned CVar token. On module disable, DynamicCam coexistence block, or any relinquish path, Logres stops rotation/settings work and passes the exact captured tokens back to `SetCVar`.

Secret-capable tokens are opaque restoration tokens only. Logres does not compare, format, count, or numerically inspect a secret token.

No periodic context polling or arbitrary setting reassertion is introduced. The only per-frame settings observation is the source-backed zoom-based shoulder curve while Logres owns camera behavior.

Concurrent external mutation while Logres owns these settings is not treated as a second ownership source. DynamicCam itself is explicitly coexistence-blocked; Logres restores its pre-ownership snapshot when ownership ends.

## Taxi rotation / UI boundaries

P0161 owns the captured Taxi continuous yaw `-20` and source-backed rotate-back behavior.

The same rotation layer also covers Teleport, NPC Interaction, Fishing, and Gathering according to the canonical profile.

Taxi and other DynamicCam UI hide/fade behavior remains presentation policy and is deferred to Phase H.

P0162 now owns reactive mouse-wheel zoom with exact hook restoration and same-context manual persistence. DynamicCam UI fading remains Phase H presentation policy.

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

G.4: **COMPLETE — City conditional-zoom ownership PASS.**

G.5 target-50 source/capability work:
**COMPLETE — source semantics resolved; requested target may be engine-clamped.**

G.5 shared zoom driver:
**COMPLETE FOR OBSERVED NORMAL TAXI — P0160 R2 RUNTIME PASS** at `ae75989b` / `0.0.79-dev`.

Observed Taxi:
- `~4.0096 -> 50` PASS;
- landing `50 -> ~4.9806` PASS;
- source rebase exercised both ways;
- zero direction-switch oscillation;
- zero camera failures.

G.6:
**COMPLETE FOR CLAIMED OBSERVED SCOPE — P0162 RUNTIME PASS** at `4628f49e` / `0.0.81-dev`.

Phase G is complete with Teleport/NPC/Fishing/Gathering and unobserved AFK behavior preserved as environmental deferrals. Phase H suppression/coexistence is now primary, followed by authored layout and final polish.

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

Layer 1 owns context + conditional zoom. AFK intentionally owns no zoom action. Fishing's upstream delay is an exit hold, not an activation delay.

## P0160 R2 source-backed zoom engine

Canonical runtime acceptance:
`../evidence/P0161_P0160_ZOOM_DRIVER_PASS_2026-10-07.md`.

P0160 R2 is durable at `ae75989b` / `0.0.79-dev`.

Its audited LibCamera zoom mechanics pass the observed base + normal-Taxi path. The accepted sample exercised position/time rebasing in both directions and did not require the final correction branch.

G.5 Taxi zoom convergence is closed for observed scope.

## P0161 captured rotation/settings layer

Canonical source audit:
`../evidence/P0161_PROFILE_BEHAVIOR_SOURCE_AUDIT_2026-10-07.md`.

P0161 adapts the audited DynamicCam/LibCamera rotation semantics:
- Taxi continuous yaw `-20`;
- Teleport continuous yaw `+15`;
- NPC yaw `-45`;
- Fishing yaw/pitch `+10/+10`;
- Gathering yaw/pitch `-15/+15`;
- inherited `rotateBack=true`.

P0161 also applies the exact captured standard dynamic-pitch/focus settings and the captured shoulder curves.

The explicit City max-distance factor `1` is now authorized as a situation-specific profile value. The absent standard max-distance field is not reconstructed; Logres captures/restores the live pre-ownership value outside City.

Reactive mouse-wheel zoom remains the final non-presentation Camera parity slice.

DynamicCam UI fading remains Phase H presentation policy.

## P0162 reactive mouse-wheel layer

Canonical source audit:
`../evidence/P0162_REACTIVE_ZOOM_SOURCE_AUDIT_2026-10-07.md`.

P0162 captures exact pre-ownership `CameraZoomIn`/`CameraZoomOut` functions, installs a bounded adapter while Logres owns camera context, and restores the captured functions only if the globals still point to Logres wrappers. A newer external hook is preserved rather than overwritten.

The adapter preserves DynamicCam zero-increment suppression, non-wheel pass-through, quick-step accumulation, direction reset, first-person `0.05` escape, live max-distance clamp, short-hop native fallback, and stale-target correction. It reuses P0160 motion with `OutQuad`; ordinary situation transitions remain `InOutQuad`.

A manual-zoom context marker prevents same-context reconciliation from immediately undoing the user's reactive wheel choice. It clears when the camera context changes. No CVar ownership expansion, timer/polling, UI fade, or stock suppression is added.

Runtime acceptance on `0.0.81-dev` / loadCount `193` exercised active/hooked `OutQuad`, quick accumulation, direction reset, native pass-through, stale-target correction, same-context manual persistence, and OFF/ON release/reacquire. Final diagnostics recorded `wheel=36`, `quick=9`, `resets=2`, `native=4`, `corrections=15`, conflicts `0`, secrets `0`, failures `0`; integrated Run All remained clean.
