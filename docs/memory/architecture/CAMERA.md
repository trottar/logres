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

## Current configured contexts

The captured `RPG` profile enables City, World, World (Combat), Taxi,
Hearth/Teleport, NPC Interaction, Fishing, AFK, and Gathering.

Runtime-proven production Logres camera ownership covers:
- World;
- World (Combat);
- City/resting.

Taxi source/profile semantics are resolved. Production Taxi ownership remains
gated on target-50 runtime capability.

## Context precedence

The current instance boundary remains fail-open and outside the Taxi slice.

Inside the non-instance camera slice, the source-resolved intended Taxi order is:
1. Taxi;
2. active NPC interaction remains fail-open until separately replaced;
3. live `UnitAffectingCombat("player")` -> Combat;
4. resting -> City;
5. otherwise -> World.

Pinned DynamicCam source priorities:
- Taxi `1000`;
- NPC Interaction `110`;
- World (Combat) `50`;
- City `1`;
- World `0`.

P0109 does not yet put Taxi into this production order; the current production
Taxi branch remains fail-open until capability proof passes.

## Correct zoom semantics

DynamicCam `zoomType = in/out` is a conditional absolute target:
- World: target 5 only when currently farther away;
- City: target 5 only when currently farther away;
- World (Combat): target 15 only when currently closer;
- Taxi: target 50 only when currently closer.

Proven ordinary transition duration:
- World / City / Combat: `2.5` seconds.

Source-resolved Taxi duration:
- entering Taxi: `5` seconds.

Zoom restore is `never`.

For ordinary Taxi exit to World/City/Combat, DynamicCam uses the **entering
destination's** `timeToEnter`; Taxi's stored `timeToExit = 5` is not the
ordinary destination zoom duration.

## Taxi sensor boundary

Logres already owns the raw Taxi fact:
`state.onTaxi = UnitOnTaxi("player")`.

`PLAYER_CONTROL_LOST` and `PLAYER_CONTROL_GAINED` are refresh signals only.

A.2 runtime evidence already proved a real Taxi true/false transition.

No Taxi poller or duplicate sensor is required.

## Target-50 capability boundary

Pinned DynamicCam source permits a maximum situation zoom target of `50` on
non-mainline clients.

Its camera logic also exposes effective distance through:

`GetCVar("cameraDistanceMaxZoomFactor") * 15`

The captured profile does not prove the effective current Forever runtime value.

The production Logres controller does not mutate camera-distance CVar state.

P0109 therefore adds a diagnostic-only target-50 mode to the existing
`CameraCapabilityProbe`:
- read-only distance-factor observation;
- recorded effective ceiling;
- 5-second MoveView attempt to 50;
- MoveView return to captured starting zoom;
- final factor re-read and unchanged check;
- target/movement/restoration/secret/error diagnostics.

The probe never calls `SetCVar`, `CameraZoomIn`, or `CameraZoomOut`.

Production Taxi ownership remains gated until this runtime result is classified.

Do not:
- silently clamp Taxi to a lower target;
- mutate `cameraDistanceMaxZoomFactor`;
- introduce the unproven temporary-CVar fallback.

## Taxi rotation boundary

The captured Taxi profile enables rotation speed `-20`.

DynamicCam defaults make the effective Taxi rotation continuous with
`rotateBack = true`, and source starts rotation independently from zoom.

Rotation is separable from Taxi zoom ownership and remains separately gated.

## UI hide/fade boundary

Taxi UI hide/fade is presentation policy, not camera motion.

It remains outside the first Taxi camera slice and must be reconciled with
Immersion Controller / Quiet Mode / Phase H policy.

## Combat signal distinction

World (Combat) selection uses live `UnitAffectingCombat("player")`, never cached
`State.combat` as an equivalent predicate. `InCombatLockdown()` remains a
separate restriction/protection signal.

## Ownership boundary

DynamicCam and Logres must never drive camera movement simultaneously.

The production controller blocks while the shared `CameraCapabilityProbe` is
running. P0109 deliberately reuses that module so the target-50 mode inherits
the existing mutual-exclusion boundary.

The target-50 probe itself also refuses while:
- production camera ownership is enabled;
- DynamicCam is loaded;
- DynamicCam load status cannot be proven.

## Transition architecture

Proven production direction:
- event/state-driven context selection;
- `OnUpdate` only while an active transition runs;
- no periodic context polling;
- `GetCameraZoom` + read-only camera CVars;
- `MoveViewOutStart/Stop` and `MoveViewInStart/Stop`;
- stop active movement before replacement transitions;
- stop on disable, ownership loss, or failure;
- no remembered zoom restoration;
- no accepted `SetCVar` / `CameraZoomIn/Out` fallback.

P0109 uses the same movement boundary for isolated target-50 capability proof.

## Diagnostic ownership

Phase G developer-panel diagnostics now include:
- existing Camera World/Combat controls;
- historical small Camera Zoom Probe;
- `Taxi Target 50 Probe`.

The Taxi probe records:
- probe kind/phase;
- current/start/target/turn/final zoom;
- `cameraZoomSpeed`;
- `cameraDistanceMaxZoomFactor` before/after;
- source-derived effective ceiling;
- CVar unchanged;
- targetReached / moved / restored;
- DynamicCam state;
- combat/lockdown diagnostic context;
- secret/error state.

The Taxi capability probe remains excluded from Run All because it deliberately
moves the camera.

## Implementation sequence

G.1: **COMPLETE — profile captured.**

G.2: **COMPLETE — primary camera capability runtime + integration PASS.**

G.3: **COMPLETE — World/Combat production ownership runtime + integration PASS.**

G.4: **COMPLETE — City ownership runtime + integration PASS on `0.0.43-dev`.**

G.5: **TARGET-50 CAPABILITY PROBE IMPLEMENTED — RUNTIME PROOF PENDING on `0.0.44-dev`.**

Taxi production ownership, Taxi rotation, UI-hide integration, later profile
contexts, startup snap parity, shoulder offsets, and broader camera-CVar
ownership remain separately gated.
