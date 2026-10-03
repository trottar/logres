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

Runtime-proven Logres ownership now covers:
- World;
- World (Combat);
- City/resting.

Taxi is the next contract-review slice. Later contexts remain separately
capability-gated.

## Proven context precedence

Existing production safety exclusions remain first:
- instance;
- taxi;
- active NPC interaction.

Within the proven World/City/Combat slice:
- live `UnitAffectingCombat("player")` -> Combat;
- otherwise resting -> City;
- otherwise -> World.

This preserves the accepted DynamicCam priority relationship for those contexts.

Taxi remains an exclusion until G.5 resolves whether and how Logres should own
that situation.

## Correct zoom semantics

DynamicCam `zoomType = in/out` is a conditional absolute target:
- World: target 5 only when currently farther away;
- City: target 5 only when currently farther away;
- World (Combat): target 15 only when currently closer.

Ordinary transition duration for all three proven contexts is 2.5 seconds.
Zoom restore is `never`.

City exit runtime evidence confirms fresh destination evaluation rather than a
remembered pre-City restore.

Canonical audits/evidence:
- `../evidence/G2_DYNAMICCAM_ZOOM_SOURCE_AUDIT_2026-10-02.md`
- `../evidence/G4_CITY_CAMERA_SOURCE_AUDIT_2026-10-03.md`
- `../evidence/G4_P0105_RUNTIME_PASS_2026-10-03.md`

## City-specific scope boundary

The City profile also stores UI hide/fade at opacity 0.65 and
`cameraDistanceMaxZoomFactor = 1`.

Neither is part of proven G.4 camera motion:
- UI fade remains presentation policy;
- camera-distance CVar ownership remains a separate capability/parity item.

DynamicCam's first-situation-after-login transition-time 0 behavior also remains
a separately gated global initialization question.

## Taxi contract-review boundary

Captured Taxi situation `160` stores:
- on-taxi activation;
- priority `1000`;
- enter/exit `5`;
- conditional-out target `50`;
- rotation speed `-20`;
- UI hide/fade;
- profile-wide restore remains `never`.

G.5 must verify source precedence and transition semantics and determine whether
target 50 can be supported without unproven global camera-distance mutation.

Rotation and UI hide/fade must not be silently imported into the first Taxi
runtime slice. Each requires an explicit capability/presentation decision.

## Combat signal distinction

World (Combat) selection uses live `UnitAffectingCombat("player")`, never cached
`State.combat` as an equivalent predicate. `InCombatLockdown()` remains a
separate restriction/protection signal.

## Ownership boundary

DynamicCam and Logres must never drive camera movement simultaneously.

The production controller queries DynamicCam load status on every reconciliation
and handles late DynamicCam load. Runtime evidence proves loaded DynamicCam
blocks/relinquishes Logres ownership.

The historical manual camera probe and production controller remain mutually
gated.

## Transition architecture

Proven production direction:
- event/state-driven context selection;
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

G.5 must reuse this architecture unless new Taxi-specific capability evidence
requires an explicit, separately proven extension.

## Diagnostic ownership

The production controller exposes addon-owned context, transition, coexistence,
live/cached combat distinction, resting state, zoom, counters, and last
reason/error state.

G.4 runtime evidence is complete. G.5 diagnostics should be designed only after
the Taxi contract is explicit.

## Implementation sequence

G.1: **COMPLETE — profile captured.**

G.2: **COMPLETE — World/Combat primary camera capability runtime + integration PASS.**

G.3: **COMPLETE — production World/Combat ownership runtime + integration PASS.**

G.4: **COMPLETE — City ownership runtime + integration PASS on `0.0.43-dev`.**

G.5: **ACTIVE — TAXI CONTRACT REVIEW; NO RUNTIME CODE YET.**

Rotation, UI-hide integration, shoulder offsets, startup snap parity, later
profile contexts, and broader camera-CVar ownership remain separately gated.
