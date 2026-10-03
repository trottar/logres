# P0109 — G.5 Taxi Target-50 Capability Probe

Date: 2026-10-03
Result: **PREPARED R2 — RUNTIME DIAGNOSTIC; PROOF PENDING**
Baseline: `19efaad6523369020c6789d9e18e006538e3bf68`
Runtime: `0.0.43-dev -> 0.0.44-dev`

## Purpose

Answer one narrow G.5 question:

Can the current Forever camera reach the captured Taxi absolute target `50`
through the already-proven MoveView path without mutating
`cameraDistanceMaxZoomFactor`?

Production Taxi ownership remains unchanged until the answer is known.

## Runtime change

`Logres/Camera/Probe.lua` keeps the existing `CameraCapabilityProbe` module and
adds a second manual mode rather than introducing another camera mover.

Taxi target mode:
- absolute target `50`;
- 5-second outbound leg;
- MoveView return to captured starting zoom;
- read-only `cameraDistanceMaxZoomFactor`;
- source-derived effective ceiling `factor * 15`;
- final CVar re-read and unchanged check;
- targetReached / moved / restored / secret / error diagnostics.

The historical small reversible Camera Zoom Probe remains intact.

## Safety / coexistence

The target-50 probe:
- requires the production camera controller to be OFF;
- refuses while DynamicCam is loaded or load status is unknown;
- reuses the module already observed by the production controller's
  `camera-probe-running` gate;
- stops camera movement before each leg and on finish/failure;
- adds no context polling, events, subscriptions, or timers;
- does not call `SetCVar`, `CameraZoomIn`, or `CameraZoomOut`.

If the camera already begins within target tolerance, the probe blocks and asks
for a closer manual starting position.

## Developer panel

Adds Phase G action:

`Taxi Target 50 Probe`

This is intentionally not included in Run All because it moves the camera.

The action follows the existing two-click diagnostic pattern:
1. first click starts the outbound + restore sequence;
2. after movement finishes, second click reports/persists the completed result.

## Production boundary

P0109 does **not**:
- remove the production Taxi fail-open exclusion;
- implement Taxi context ownership;
- add Taxi rotation;
- add Taxi UI fade;
- mutate `cameraDistanceMaxZoomFactor`;
- change World/City/Combat behavior.

## Static contract

Adds:
`tools/check_camera_taxi_target_probe_contract.py`

The checker enforces:
- target 50 / 5-second probe constants;
- read-only distance-factor observation;
- MoveView path;
- restore/result fields;
- GUI action and Phase G registration;
- exclusion from Run All;
- continued production Taxi fail-open;
- absence of CVar mutation and CameraZoom fallback.

The existing developer-panel checker is extended to recognize the new Phase G
action.

## Delivery correction — R2

The first P0109 apply wrote the intended worktree and then stopped because the
new checker used two impossible exact-string expectations:
- a multiline Lua comparison was required as one line;
- a dynamically formatted PASS/FAIL result was required as a literal rendered
  string.

P0109 R2 corrects the checker only and records the delivery failure at:

`../evidence/P0109_DELIVERY_CHECKER_FALSE_NEGATIVE_2026-10-03.md`

No runtime camera behavior changed between the failed first apply and R2.

The first handoff also incorrectly used `set -e` directly in the interactive
zsh. R2 handoff commands do not enable errexit in the caller shell.

## Runtime acceptance

After verified push/deployment, use the developer-panel GUI:
1. DynamicCam disabled;
2. Phase G -> `Camera World/Combat OFF`;
3. manually zoom clearly below 50;
4. Phase G -> `Taxi Target 50 Probe`;
5. wait for outbound + return movement;
6. Phase G -> `Taxi Target 50 Probe` again;
7. Phase G -> `Camera World/Combat ON`;
8. flush/export developer-panel diagnostics.

Interpretation:
- PASS -> target 50 is usable under the accepted no-CVar-mutation boundary;
- clean targetReach FAIL -> negative capability evidence; open camera-distance
  ownership separately;
- restoration/CVar/secret/API/Lua failure -> probe/runtime defect to investigate.

## Deployment

Runtime code changes.

WoW redeploy is required after verified push.
