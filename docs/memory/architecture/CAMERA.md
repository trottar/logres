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

G.3 production ownership covers World / World (Combat) and is runtime-proven.
Known higher/out-of-slice contexts remain gated until their own slice is
accepted. G.4 now reviews City/resting behavior before extending ownership.

## Correct zoom semantics

DynamicCam `zoomType = in/out` is a conditional absolute target:
- World: target `5` only when currently farther away;
- World (Combat): target `15` only when currently closer.

G.3 ordinary World/Combat transition duration is `2.5` seconds and zoom restore
is `never`.

Canonical source audit:
`../evidence/G2_DYNAMICCAM_ZOOM_SOURCE_AUDIT_2026-10-02.md`.

## G.2 runtime capability evidence

G.2 is closed with runtime + integration PASS. P0096 proved the primary path in
two genuine live-combat runs on `0.0.40-dev` and retained the important
`cachedCombat=false` / `mismatch=true` result.

Canonical runtime evidence:
`../evidence/G2_P0096_RUNTIME_PASS_2026-10-02.md`.

## Combat signal distinction

World (Combat) selection uses live `UnitAffectingCombat("player")`, never cached
`State.combat` as an equivalent predicate. `InCombatLockdown()` remains a
separate restriction/protection signal.

P0100 combines state subscription with targeted combat/restriction events. A
cached state publication is not required for live combat reevaluation. Core
State semantics are not changed.

## Ownership boundary

DynamicCam and Logres must never drive camera movement simultaneously.

P0100 queries DynamicCam load status on every reconciliation and listens for
`ADDON_LOADED` for DynamicCam. Final G.3 runtime evidence on `0.0.42-dev` proved
that DynamicCam loaded yields `context=none`, `owns=false`, `transition=false`,
and `blocked=dynamiccam-loaded`.

The historical G.2 manual probe and production controller are mutually gated.

## Transition architecture

Proven G.3 production direction:
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
- no pre-combat zoom restoration;
- no `SetCVar` or `CameraZoomIn/Out` fallback.

Final G.3 evidence also proved an active World transition records
`stop=module-disabled` when the controller is disabled, then a later enable
starts a fresh transition from the current zoom.

## Diagnostic ownership

The production controller exposes addon-owned status for selected context,
active transition, coexistence gate, live/cached combat distinction,
current/start/target/final zoom, transition elapsed time, no-op/stop/failure
counts, and last reason/error.

The phase-tabbed developer panel provides non-mutating Check plus explicit
Reconcile and ON/OFF controls. Only Check is included in Run All.

## Implementation sequence

G.1: **COMPLETE — profile captured.**

G.2: **COMPLETE — World/Combat primary camera capability runtime + integration PASS.**

G.3: **COMPLETE — production World/Combat ownership runtime + integration PASS.**

G.4: **ACTIVE — City camera ownership contract review.**

Rotation, UI-hide integration, shoulder offsets, spell-detection contexts,
broader profile contexts, and global camera-CVar ownership remain outside the
proven G.3 slice and must be separately capability-gated.
