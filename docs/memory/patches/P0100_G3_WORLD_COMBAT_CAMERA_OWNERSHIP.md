# P0100 — G.3 Production World/Combat Camera Ownership

Date: 2026-10-02
Result: PREPARED — RUNTIME PROOF PENDING

## Baseline

P0099 verified pushed:
`10c7255f7e04c73108c22d457bed6178002c0ae6`.

## Runtime

`0.0.40-dev -> 0.0.41-dev`.

## Purpose

Implement the smallest production controller for the evidence-backed World /
World (Combat) camera slice without broadening into the rest of DynamicCam.

## Production controller

Adds:
`Logres/Camera/WorldCombat.lua`.

`CameraWorldCombat` is auto-enabled and selects:
- World (Combat) from live `UnitAffectingCombat("player")` when not excluded by
  higher/out-of-slice proven state;
- World when not resting and not in an instance after higher contexts are
  excluded.

Known proven exclusion gates in P0100:
- instance;
- taxi;
- active NPC interaction;
- resting/City when not in live combat.

Later DynamicCam contexts remain future work and are not guessed.

## Cached-state timing correction

G.2 proved cached State.combat can remain false during genuine live combat.

Therefore P0100 does not rely on state subscription alone for combat context.
It also reevaluates on:
- `PLAYER_REGEN_DISABLED`;
- `PLAYER_REGEN_ENABLED`;
- `ADDON_RESTRICTION_STATE_CHANGED`.

Each reevaluation samples live `UnitAffectingCombat("player")`.
This is targeted event handling, not polling, and core State is unchanged.

## Movement

Production transition:
- conditional World target `5`;
- conditional World (Combat) target `15`;
- duration `2.5` seconds;
- read-only `cameraZoomSpeed`;
- `GetCameraZoom` + `MoveView*Start/Stop` only;
- OnUpdate only while transition active;
- timeout/interruption stops movement and fails open;
- zoom restore remains `never`.

No `SetCVar`, `CameraZoomIn/Out`, or timer polling is introduced.

## Coexistence

DynamicCam load status is checked before ownership. `ADDON_LOADED` for
DynamicCam also triggers reconciliation so a late load relinquishes Logres
movement.

The historical G.2 manual probe now refuses while production camera ownership is
enabled. The production controller also blocks if an already-running probe is
observed.

## Diagnostics

Adds developer-panel actions:
- Camera World/Combat Check;
- Camera World/Combat Reconcile;
- Camera World/Combat ON;
- Camera World/Combat OFF.

Check is non-mutating and is included in Run All. Reconcile may move the camera
and is excluded from Run All.

Adds:
`tools/check_camera_world_combat_contract.py`.

The static checker enforces the live combat predicate, conditional targets,
2.5-second transition, primary MoveView path, event-driven architecture,
coexistence/probe gates, no temporary-CVar fallback, runtime version, and dev
panel integration.

## Runtime acceptance

Required after verified push/deploy:
- World target PASS from >5;
- World no-op at <=5;
- automatic live-combat target PASS from <15;
- combat no-op at >=15;
- combat exit evaluates World without remembered pre-combat restore;
- disable/ownership loss stops active movement;
- DynamicCam loaded produces blocked/relinquished Logres state;
- Run All PASS including Camera World/Combat Check;
- no Lua/taint/protected/secret errors.

G.3 remains open until that evidence is recorded.
