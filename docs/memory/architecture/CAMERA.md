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
fail-open because target 50 is not reachable under the current accepted
no-camera-distance-CVar-mutation boundary.

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

This intended Taxi order is not yet active in production.

## Correct zoom semantics

DynamicCam `zoomType = in/out` is a conditional absolute target:
- World: target 5 only when currently farther away;
- City: target 5 only when currently farther away;
- World (Combat): target 15 only when currently closer;
- Taxi: intended target 50 only when currently closer.

Proven ordinary transition duration:
- World / City / Combat: `2.5` seconds.

Source-resolved Taxi duration:
- entering Taxi: `5` seconds.

Zoom restore is `never`.

For ordinary Taxi exit to World/City/Combat, DynamicCam uses the entering
destination's `timeToEnter`; Taxi's stored `timeToExit = 5` is not the ordinary
destination zoom duration.

## Taxi sensor boundary

Logres already owns the raw Taxi fact:
`state.onTaxi = UnitOnTaxi("player")`.

`PLAYER_CONTROL_LOST` and `PLAYER_CONTROL_GAINED` are refresh signals only.

A.2 runtime evidence already proved a real Taxi true/false transition.

No Taxi poller or duplicate sensor is required.

## Target-50 capability result

Canonical runtime evidence:
`../evidence/G5_P0109_TARGET50_NEGATIVE_2026-10-03.md`.

P0109 runtime `0.0.44-dev` produced two independent clean negative runs:
- `cameraDistanceMaxZoomFactor = 1.2`;
- source-derived effective ceiling `18`;
- intended target `50`;
- outbound camera stopped at `18`;
- `targetReached=false`;
- movement succeeded;
- return-to-start restoration succeeded;
- CVar remained unchanged;
- no secret-value result;
- DynamicCam was not loaded.

Therefore target 50 is not available through the proven MoveView path without a
camera-distance CVar change.

No additional no-CVar target-50 retries are required without new evidence.

The probe's aggregate failure string is broader than the measured result; the
explicit diagnostic fields identify target reach as the only failed criterion.

## Camera-distance ownership boundary

Camera-distance CVar mutation is not yet accepted.

Active investigation:
`../investigations/G5_CAMERA_DISTANCE_CVAR_OWNERSHIP.md`.

Before any `SetCVar` capability test, source review must establish:
- valid client range and clamping;
- persistence/reset behavior;
- combat/protected-state behavior;
- safe restoration semantics;
- DynamicCam/LibCamera ownership behavior;
- failure handling.

Do not:
- silently clamp Taxi to 18;
- infer another substitute target;
- add periodic CVar reassertion;
- take global camera-distance ownership without an explicit restoration contract.

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
running.

The target-50 probe refuses while:
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

Any future camera-distance test must be separately capability-gated rather than
silently folded into production.

## Diagnostic ownership

Phase G developer-panel diagnostics include:
- Camera World/Combat controls;
- historical Camera Zoom Probe;
- Taxi Target 50 Probe.

The Taxi probe remains excluded from Run All because it deliberately moves the
camera.

## Implementation sequence

G.1: **COMPLETE — profile captured.**

G.2: **COMPLETE — primary camera capability runtime + integration PASS.**

G.3: **COMPLETE — World/Combat production ownership runtime + integration PASS.**

G.4: **COMPLETE — City ownership runtime + integration PASS on `0.0.43-dev`.**

G.5 target-50 without CVar mutation:
**COMPLETE — CLEAN NEGATIVE on `0.0.44-dev`.**

G.5 camera-distance ownership:
**ACTIVE — SOURCE/CONTRACT REVIEW.**

Taxi production ownership, Taxi rotation, UI-hide integration, later profile
contexts, startup snap parity, shoulder offsets, and broader camera-CVar
ownership remain separately gated.
