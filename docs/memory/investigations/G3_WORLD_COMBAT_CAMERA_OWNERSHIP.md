# G.3 — Production World/Combat Camera Ownership

Status: ACTIVE — P0100 IMPLEMENTATION PREPARED; RUNTIME PROOF PENDING
Opened: 2026-10-02

G.1 profile evidence:
`../evidence/G1_DYNAMICCAM_PROFILE_CAPTURE_2026-10-02.md`

G.2 source audit:
`../evidence/G2_DYNAMICCAM_ZOOM_SOURCE_AUDIT_2026-10-02.md`

G.2 runtime PASS:
`../evidence/G2_P0096_RUNTIME_PASS_2026-10-02.md`

## Objective

Replace the isolated manual G.2 capability probe with deliberate production
ownership for the narrow World / World (Combat) camera slice.

Do not broaden this checkpoint into the rest of the DynamicCam profile.

## Context contract

World (Combat): not in an instance and live `UnitAffectingCombat("player")` is
true. It has higher priority than World.

World: not resting and not in an instance when World (Combat) is not selected.

Known higher/out-of-slice states already proven in the Logres state engine are
also treated as relinquish conditions in P0100:
- taxi;
- active NPC interaction;
- instance.

Resting/City relinquishes when live combat is not selected. Fishing, gathering,
hearth/teleport, AFK, and other later DynamicCam situations remain future slices;
P0100 does not invent their predicates.

## Zoom contract

World:
- read current zoom;
- if current zoom > 5, target 5;
- otherwise no-op.

World (Combat):
- read current zoom;
- if current zoom < 15, target 15;
- otherwise no-op.

Ordinary transition: `2.5` seconds.

Zoom restoration: `never`.

Combat exit evaluates the World rule normally; it does not restore a remembered
pre-combat zoom.

## Signal contract

Combat selection uses live `UnitAffectingCombat("player")`; cached
`Logres:GetState().combat` is diagnostic only.

P0096 runtime evidence showed those values can disagree in real combat.

Because the core state publisher emits only when tracked state changes, P0100
also reevaluates on `PLAYER_REGEN_DISABLED`, `PLAYER_REGEN_ENABLED`, and
`ADDON_RESTRICTION_STATE_CHANGED`. This is targeted event handling, not polling,
and avoids redesigning core State.

`InCombatLockdown()` remains a separate diagnostic/restriction signal.

## Movement contract

P0100 uses:
- `GetCameraZoom()`;
- read-only `cameraZoomSpeed`;
- `MoveViewOutStart()` / `MoveViewOutStop()`;
- `MoveViewInStart()` / `MoveViewInStop()`;
- frame updates only while an active transition runs.

Movement factor is derived from current-to-target zoom distance divided by the
2.5-second profile transition time and the current camera zoom speed.

P0100 does not use:
- temporary `SetCVar("cameraZoomSpeed", ...)`;
- `CameraZoomIn()` / `CameraZoomOut()` fallback;
- `C_Timer` polling.

## Interruption and fail-open contract

Production ownership stops active movement:
- before a replacement transition;
- when the controller is disabled;
- when the selected context leaves the G.3 slice;
- when DynamicCam becomes loaded;
- if a camera/controller operation fails.

No speculative restoration is performed. Timeout/failure leaves the current
camera usable.

## DynamicCam and probe coexistence

DynamicCam loaded means Logres does not own G.3 movement.

`ADDON_LOADED` for DynamicCam triggers immediate reconciliation so a late load
also relinquishes active movement.

The historical `CameraCapabilityProbe` refuses to start while the production
controller is enabled. The production controller also blocks if it observes an
already-running probe.

## P0100 diagnostics

Addon-owned status includes:
- selected context / ownership;
- active transition context/direction;
- current/start/target/final zoom;
- transition elapsed time and target result;
- live combat, lockdown, cached combat, mismatch;
- DynamicCam loaded/status source;
- reconcile/transition/no-op/stop/block/failure counters;
- last action/reason/stop/block/error/secret state.

Developer-panel actions:
- Camera World/Combat Check;
- Camera World/Combat Reconcile;
- Camera World/Combat ON;
- Camera World/Combat OFF.

Check is non-mutating and included in Run All. Reconcile may move the camera and
is excluded from Run All.

## Scope exclusions

P0100 does not implement City behavior, taxi behavior, NPC interaction camera
behavior, fishing/gathering/hearth/AFK behavior, rotation, shoulder offsets,
DynamicCam UI hiding, global camera CVar ownership, the temporary-CVar fallback,
or a core State.combat redesign.

## Runtime acceptance

G.3 remains open until current-runtime evidence shows:
- World transition PASS when current zoom is farther than 5;
- World no-op when already 5 or closer;
- automatic live-combat transition PASS when current zoom is closer than 15;
- combat no-op when already 15 or farther;
- clean combat-exit World behavior with no remembered pre-combat restoration;
- active movement stops on disable/ownership loss;
- DynamicCam loaded causes Logres to remain blocked/relinquished;
- Run All PASS including Camera World/Combat Check;
- no Lua, taint, protected-action, or secret-value errors.
