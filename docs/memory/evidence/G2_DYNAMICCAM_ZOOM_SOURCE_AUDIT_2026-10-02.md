# G.2 DynamicCam Zoom Source Audit — 2026-10-02

Status: SOURCE-RESOLVED; FOREVER RUNTIME PROBE NEXT
Date: 2026-10-02
Logres baseline: P0094 `9db11d2b`
DynamicCam source: `ae586a9c973c3f868c10440358d4a6e8c2fab5ff`
LibCamera source: `c0b23135a0b24fbca24b41cb53dd7afc9114e352`

## Trigger

G.1 correctly preserved the raw `RPG` profile values, but P0094's
human-readable interpretation described `zoomType = in/out` as zooming **by**
the stored value.

Current DynamicCam source proves that interpretation is wrong.

This record supersedes that derived wording while preserving the raw G.1 JSON
unchanged.

## Correct `zoomType` semantics

DynamicCam's UI description states:

- `Out`: set zoom only when the camera is currently closer than the stored
  value;
- `In`: set zoom only when the camera is currently farther than the stored
  value.

`SituationManager.lua` implements exactly that:

- `in` changes the target only when `currentZoom > zoomValue`;
- `out` changes the target only when `currentZoom < zoomValue`;
- in either case the destination becomes `zoomValue` itself.

Therefore the current `RPG` profile means:

### 004 — World

Stored:
- `zoomType = in`;
- `zoomValue = 5`;
- `timeToEnter = 2.5`.

Behavior:
- if current zoom is greater than `5`, transition to zoom `5`;
- if current zoom is already `5` or closer, do not zoom out to reach 5.

### 006 — World (Combat)

Stored:
- `zoomType = out`;
- `zoomValue = 15`;
- `timeToEnter = 2.5`.

Behavior:
- if current zoom is less than `15`, transition to zoom `15`;
- if current zoom is already `15` or farther, do not zoom in to reach 15.

The values are conditional absolute targets, not deltas.

## Transition-time semantics

DynamicCam uses the entering situation's `timeToEnter` for an ordinary
situation change.

The `RPG` profile has `zoomRestoreSetting = never`, so World/Combat transitions
do not use stored prior-zoom restoration.

Consequently:
- World -> World (Combat): target 15 when needed, over `2.5` seconds;
- World (Combat) -> World: target 5 when needed, over `2.5` seconds.

The stored `timeToExit = 0` values are real profile data but do not define
these ordinary World/Combat zoom-transition durations.

On DynamicCam's first situation application after login/reload,
`ChangeSituation()` forces transition time `0`.

`zoomTimeIsMax` is absent from the stored profile and defaults to false, so
ordinary World/Combat transitions use the selected transition time rather than
the optional shortened "Don't slow" behavior.

## Primary camera path

For ordinary situation zoom, DynamicCam calls:

`LibCamera:SetZoom(targetZoom, transitionTime, easingZoom)`.

LibCamera's primary `SetZoom` path:

1. stops any prior LibCamera zoom;
2. reads `GetCameraZoom()`;
3. runs a frame-based easing controller;
4. reads `cameraZoomSpeed`;
5. drives `MoveViewOutStart()` or `MoveViewInStart()` with a speed factor;
6. calls matching stop functions on completion or interruption.

The primary path reads `cameraZoomSpeed`; it does not normally mutate the CVar.

Frame updates here are animation control, not context polling.

## LibCamera corrective fallback

If the primary easing misses its target beyond tolerance, LibCamera may call
`SetZoomUsingCVar()`.

That fallback temporarily:
- changes `cameraZoomSpeed`;
- calls `CameraZoomIn()` / `CameraZoomOut()`;
- restores the old speed from `StopZooming()`.

G.2 does not adopt or test that fallback yet.

The first proof is the primary `MoveView*` path only. If that cannot reach and
restore a small target reliably on Forever, the fallback becomes a separate
capability question rather than being copied automatically.

## Interruption / fail-open contract

Source establishes a minimum contract:

- stop an active transition before beginning another;
- stop both movement directions on cleanup;
- do not leave a temporary speed/CVar change behind;
- keep the current camera usable when ownership is relinquished unless an
  accepted profile rule says otherwise.

Because the current profile's zoom restoration policy is `never`, Logres must
not invent a restore-to-pre-combat zoom behavior for World/Combat production.

## DynamicCam coexistence

Two addons must not drive the camera simultaneously.

For G.2 runtime proof:
- automatic Logres camera ownership remains absent;
- the probe is manual only;
- the probe refuses to run while DynamicCam is loaded;
- DynamicCam is disabled for the isolated proof session;
- after proof, DynamicCam can be re-enabled until Logres production camera
  ownership is deliberately implemented.

## Runtime proof required

Source review cannot establish Forever combat safety for the camera calls.

P0095 therefore adds a developer-panel `Camera Zoom Probe` that:
- uses only the primary `GetCameraZoom` + `MoveView*` path;
- reads but never mutates `cameraZoomSpeed`;
- makes one small reversible zoom movement;
- returns to the captured starting zoom;
- records whether the run began in combat;
- must pass once out of combat and once in combat;
- refuses to run while DynamicCam is loaded.

## Result

**SOURCE REVIEW PASS. RUNTIME PROOF PENDING.**
