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

Runtime-proven Logres camera ownership covers:
- World;
- World (Combat);
- City/resting.

Taxi source/profile semantics are now resolved, but production Taxi ownership is
still gated on target-50 camera capability.

## Context precedence

The current instance boundary remains fail-open and outside the Taxi slice.

Inside the non-instance camera slice, the source-resolved intended order is:
1. Taxi;
2. active NPC interaction remains fail-open until separately replaced;
3. live `UnitAffectingCombat("player")` -> Combat;
4. resting -> City;
5. otherwise -> World.

Pinned DynamicCam source chooses the highest priority active situation:
- Taxi `1000`;
- NPC Interaction `110`;
- World (Combat) `50`;
- City `1`;
- World `0`.

Taxi therefore outranks interaction, combat, City, and World.

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
destination's** `timeToEnter`, so the destination transition is `2.5` seconds.
Taxi's stored `timeToExit = 5` is not the ordinary destination zoom duration.

## Taxi sensor boundary

Logres already owns the raw Taxi fact:
`state.onTaxi = UnitOnTaxi("player")`.

`PLAYER_CONTROL_LOST` and `PLAYER_CONTROL_GAINED` are refresh signals only; they
must never be treated as equivalent to Taxi state.

A.2 runtime evidence already proved a real Taxi true/false transition.

No Taxi poller or duplicate sensor is required.

## Target-50 capability boundary

Pinned DynamicCam source permits a maximum situation zoom target of `50` on
non-mainline clients.

Its reactive-zoom path also constrains camera distance using:

`GetCVar("cameraDistanceMaxZoomFactor") * 15`

The captured profile does not contain an explicit standard runtime override for
`cameraDistanceMaxZoomFactor`; DynamicCam's default derives that setting from the
client default.

Therefore source/profile evidence establishes **intent** to target `50`, but does
not prove current Forever runtime reachability under Logres.

The production Logres controller currently:
- reads `cameraZoomSpeed`;
- uses `GetCameraZoom`;
- drives `MoveView*Start/Stop`;
- does not mutate camera-distance CVar state.

Before Taxi production ownership, a dedicated developer-panel capability probe
must attempt target `50` with that same no-CVar-mutation boundary.

Do not:
- silently clamp Taxi to a lower target;
- mutate `cameraDistanceMaxZoomFactor`;
- introduce the unproven temporary-CVar fallback.

## Taxi rotation boundary

The captured Taxi profile enables rotation speed `-20`.

DynamicCam defaults make the effective Taxi rotation continuous with
`rotateBack = true`, and source starts rotation independently from zoom.

Rotation is therefore separable from Taxi zoom ownership.

The first Taxi production slice remains zoom-only. Continuous-yaw capability,
interruption, cleanup, and restoration require their own proof before Logres may
own Taxi rotation.

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

The production controller queries DynamicCam load status on reconciliation and
runtime evidence proves loaded DynamicCam blocks/relinquishes Logres ownership.

The manual camera probe and production controller remain mutually gated.

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

G.5 target-50 capability must reuse this boundary.

## Diagnostic ownership

The next camera diagnostic is a developer-panel-only Taxi target-50 capability
probe. It must report:
- current zoom;
- target 50;
- current `cameraDistanceMaxZoomFactor`;
- source-derived distance ceiling;
- final/turn/restored zoom;
- targetReached;
- DynamicCam state;
- secret/error state.

Production Taxi diagnostics are designed only after this capability passes.

## Implementation sequence

G.1: **COMPLETE — profile captured.**

G.2: **COMPLETE — primary camera capability runtime + integration PASS.**

G.3: **COMPLETE — World/Combat production ownership runtime + integration PASS.**

G.4: **COMPLETE — City ownership runtime + integration PASS on `0.0.43-dev`.**

G.5: **SOURCE/PROFILE CONTRACT RESOLVED — TARGET-50 CAPABILITY PROBE NEXT.**

Taxi production ownership, Taxi rotation, UI-hide integration, later profile
contexts, startup snap parity, shoulder offsets, and broader camera-CVar
ownership remain separately gated.
