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
Hearth/Teleport, NPC Interaction, Fishing, AFK, and Gathering. No explicit
enabled instance camera situation is present.

G.3 runtime-proves World / World (Combat). G.4 source/profile review resolves the
City/resting slice, and P0105 prepares that extension on runtime `0.0.43-dev`;
later contexts remain separately capability-gated.

## Context precedence

For the accepted City extension, existing proven safety exclusions remain first:
instance, taxi, and active NPC interaction relinquish camera ownership.

Within the World/City/Combat slice:
- live `UnitAffectingCombat("player")` -> Combat;
- otherwise resting -> City;
- otherwise -> World.

This preserves DynamicCam's source priority relationship: Combat priority 50,
City priority 1, World priority 0.

## Correct zoom semantics

DynamicCam `zoomType = in/out` is a conditional absolute target:
- World: target 5 only when currently farther away;
- City: target 5 only when currently farther away;
- World (Combat): target 15 only when currently closer.

Ordinary transition duration for all three accepted contexts is 2.5 seconds.
Zoom restore is `never`.

DynamicCam ordinary context changes use the entering situation's
`timeToEnter`. Therefore leaving City for World or Combat uses the destination
context's transition rather than a City-exit restore.

Canonical audits:
- `../evidence/G2_DYNAMICCAM_ZOOM_SOURCE_AUDIT_2026-10-02.md`
- `../evidence/G4_CITY_CAMERA_SOURCE_AUDIT_2026-10-03.md`

## City-specific scope boundary

The City profile also stores UI hide/fade at opacity 0.65 and
`cameraDistanceMaxZoomFactor = 1`.

Neither is automatically part of G.4 camera motion:
- UI fade is presentation policy that must be reconciled with the Immersion
  Controller / Quiet Mode / Phase H direction;
- camera-distance CVar ownership remains a separate capability and parity item.

City's stored reactive-zoom values are effectively the same as the captured
standard settings, and City `cameraZoomSpeed = 15.5` matches standard. No
City-specific reactive-zoom or speed ownership is required for the first slice.

DynamicCam's first-situation-after-login transition-time 0 behavior is a global
initialization special case. G.4 does not introduce it through City and thereby
change already-proven G.3 behavior.

## Combat signal distinction

World (Combat) selection uses live `UnitAffectingCombat("player")`, never cached
`State.combat` as an equivalent predicate. `InCombatLockdown()` remains a
separate restriction/protection signal.

P0100 combines state subscription with targeted combat/restriction events. Core
State semantics remain unchanged.

## Ownership boundary

DynamicCam and Logres must never drive camera movement simultaneously.

The production controller queries DynamicCam load status on every reconciliation
and handles late DynamicCam load. G.3 runtime evidence proves loaded DynamicCam
blocks/relinquishes Logres ownership.

The historical manual camera probe and production controller remain mutually
gated.

## Transition architecture

Proven production direction reused by G.4:
- event/state-driven context selection;
- existing state subscription supplies resting transitions;
- `OnUpdate` only while an active transition runs;
- no periodic context polling;
- `GetCameraZoom` + read-only `cameraZoomSpeed`;
- `MoveViewOutStart/Stop` and `MoveViewInStart/Stop`;
- constant movement factor derived from remaining zoom distance / transition time;
- target/crossing observation stops movement;
- timeout stops movement and fails open;
- active movement stops before replacement transitions;
- active movement stops on disable, ownership loss, or failure;
- no remembered zoom restoration;
- no `SetCVar` or `CameraZoomIn/Out` fallback.

## Diagnostic ownership

The production controller exposes addon-owned context, transition, coexistence,
live/cached combat distinction, zoom, counters, and last reason/error state.

P0105 makes `city` and resting state observable through this same diagnostic
surface and adds a dedicated static contract enforcing live-combat-before-City
ordering. Runtime proof remains pending.

## Implementation sequence

G.1: **COMPLETE — profile captured.**

G.2: **COMPLETE — World/Combat primary camera capability runtime + integration PASS.**

G.3: **COMPLETE — production World/Combat ownership runtime + integration PASS.**

G.4: **IMPLEMENTATION PREPARED — RUNTIME PROOF PENDING.**

Rotation, UI-hide integration, shoulder offsets, startup snap parity, later
profile contexts, and broader camera-CVar ownership remain outside the accepted
G.4 slice and must be separately capability-gated.
