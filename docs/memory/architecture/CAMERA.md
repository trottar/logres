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

G.3 implements only World / World (Combat). Known higher/out-of-slice contexts
already represented by proven Logres state are gated out: instance, taxi, NPC
interaction, and resting/City when live combat is not selected. Other later
DynamicCam contexts remain future slices rather than being guessed in G.3.

## Correct zoom semantics

DynamicCam `zoomType = in/out` is a conditional absolute target:
- World: target `5` only when currently farther than 5;
- World (Combat): target `15` only when currently closer than 15;
- ordinary transition duration: `2.5` seconds;
- zoom restore: `never`.

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

P0100 therefore combines state subscription with targeted combat/restriction
events. A cached state publication is not required for live combat reevaluation.
Core State semantics are not changed.

## Ownership boundary

DynamicCam and Logres must never drive camera movement simultaneously.

P0100 queries DynamicCam load status on every reconciliation and also listens for
`ADDON_LOADED` for DynamicCam. If DynamicCam is loaded, Logres stops any active
movement and relinquishes G.3 ownership.

The historical G.2 manual probe and production controller are mutually gated:
the probe refuses while `CameraWorldCombat` is enabled, and the controller
relinquishes if a previously running probe is detected.

## Transition architecture

P0100 production direction:
- event/state-driven context selection;
- `OnUpdate` only while an active transition runs;
- no periodic context polling;
- `GetCameraZoom` + read-only `cameraZoomSpeed`;
- `MoveViewOutStart/Stop` and `MoveViewInStart/Stop`;
- constant movement factor derived from remaining zoom distance / 2.5 seconds;
- target/crossing observation stops movement;
- timeout stops movement and fails open;
- active movement stops before replacement transitions;
- active movement stops on disable, ownership loss, or failure;
- no pre-combat zoom restoration;
- no `SetCVar` or `CameraZoomIn/Out` fallback.

## Diagnostic ownership

P0100 exposes addon-owned status for selected context, active transition,
coexistence gate, live/cached combat distinction, current/start/target/final
zoom, transition elapsed time, no-op/stop/failure counts, and last reason/error.

The developer panel provides non-mutating Check plus explicit Reconcile and
ON/OFF controls. Only Check is included in Run All.

## Implementation sequence

G.1: **COMPLETE — profile captured.**

G.2: **COMPLETE — World/Combat primary camera capability runtime + integration
PASS.**

G.3: **P0100 IMPLEMENTATION PREPARED — RUNTIME PROOF PENDING.**

Rotation, UI hiding, shoulder offsets, spell-detection contexts, broader profile
contexts, and global camera-CVar ownership remain outside P0100.
