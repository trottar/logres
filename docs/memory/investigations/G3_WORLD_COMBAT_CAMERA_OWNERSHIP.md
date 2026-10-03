# G.3 — Production World/Combat Camera Ownership

Status: CLOSED — RUNTIME + INTEGRATION PASS
Opened: 2026-10-02
Closed: 2026-10-03

G.1 profile evidence:
`../evidence/G1_DYNAMICCAM_PROFILE_CAPTURE_2026-10-02.md`

G.2 runtime PASS:
`../evidence/G2_P0096_RUNTIME_PASS_2026-10-02.md`

Final G.3 runtime PASS:
`../evidence/G3_P0102_RUNTIME_PASS_2026-10-03.md`

## Objective

Replace the isolated manual G.2 capability probe with deliberate production
ownership for the narrow World / World (Combat) camera slice.

Do not broaden this checkpoint into the rest of the DynamicCam profile.

## Context contract

World (Combat): not in an instance and live `UnitAffectingCombat("player")` is
true. It has higher priority than World and resting/City.

World: not resting and not in an instance when World (Combat) is not selected.

Known higher/out-of-slice states are relinquish conditions in G.3:
- taxi;
- active NPC interaction;
- instance;
- resting/City when live combat is not selected.

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

P0100 reevaluates on `PLAYER_REGEN_DISABLED`, `PLAYER_REGEN_ENABLED`, and
`ADDON_RESTRICTION_STATE_CHANGED`. This is targeted event handling, not polling.

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

P0100 does not use temporary `SetCVar`, `CameraZoomIn/Out` fallback, or timer
polling.

## Interruption and fail-open contract

Production ownership stops active movement before replacement transitions, on
controller disable, on ownership loss, when DynamicCam becomes loaded, or when a
camera/controller operation fails. No speculative restoration is performed.

## DynamicCam and probe coexistence

DynamicCam loaded means Logres does not own G.3 movement. The historical
CameraCapabilityProbe and production controller are mutually gated.

## Diagnostics

Addon-owned status includes selected context/ownership, active transition,
current/start/target/final zoom, elapsed time and target result, live combat,
lockdown, cached combat/mismatch, DynamicCam load status, counters, and last
reason/stop/block/error/secret state.

Developer-panel actions are Check, Reconcile, ON, and OFF. Check is included in
Run All; Reconcile is intentionally excluded because it may move the camera.

## First runtime observation retained

The first P0100 production validation occurred while the player was resting.
Status reported `outside-slice:resting`, context none, ownership false,
DynamicCam false, camera API available, and no secret/error result.

Classification remains:
**ENVIRONMENTAL DEFERRAL — EXPECTED RESTING RELINQUISH.**

That observation is retained even though later runtime evidence closes G.3.

Canonical evidence:
`../evidence/G3_P0100_RESTING_DEFERRAL_PANEL_OVERFLOW_2026-10-02.md`.

## Final runtime acceptance — PASS

Final accepted evidence on runtime `0.0.42-dev` proves:
- World transition from zoom 15 toward target 5 completed near 5.236;
- World at zoom 1.243 produced no-op and did not zoom outward;
- live combat automatically moved from about 5.244 toward target 15 and
  completed near 14.770;
- combat at 15 produced no-op, including with lockdown true;
- combat exit via `PLAYER_REGEN_ENABLED` reevaluated World and moved from about
  14.770 toward target 5, with no remembered restoration;
- disabling during an active transition recorded `stop=module-disabled` and a
  later enable began a fresh transition from the current zoom;
- Run All completed on `0.0.42-dev` with Camera World/Combat Check PASS;
- DynamicCam loaded produced `context=none`, `owns=false`, `transition=false`,
  and `blocked=dynamiccam-loaded`;
- accepted addon-owned results retained `failures=0`, `secret=false`, and
  `error=nil`.

No Lua, taint, protected-action, or secret-value failure was reported during the
accepted validation sequence.

Classification:
**CLOSED — RUNTIME + INTEGRATION PASS.**

## Scope exclusions

G.3 does not implement City behavior, taxi behavior, NPC interaction camera
behavior, fishing/gathering/hearth/AFK behavior, rotation, shoulder offsets,
DynamicCam UI hiding, global camera CVar ownership, the temporary-CVar fallback,
or a core State.combat redesign.
