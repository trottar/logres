# P0095 — G.2 Camera Zoom Capability Probe

Date: 2026-10-02
Result: INSTALLED / PUSHED — OOC CAMERA PATH PASS; COMBAT CLASSIFICATION DEFECT (`b65ea1af`)

## Baseline

P0094 verified pushed:
`9db11d2b61f49be48a4b488af1285b2e4439aca0`.

## Runtime

`0.0.38-dev -> 0.0.39-dev`.

## Source correction

DynamicCam `in/out` modes are conditional targets:

- World: target 5 only when currently farther than 5;
- World (Combat): target 15 only when currently closer than 15.

Ordinary transitions use 2.5 seconds and zoom restoration is `never`.

DynamicCam source:
`ae586a9c973c3f868c10440358d4a6e8c2fab5ff`.

LibCamera source:
`c0b23135a0b24fbca24b41cb53dd7afc9114e352`.

## Probe

Adds:
`Logres/Camera/Probe.lua`.

Panel action:
`Camera Zoom Probe`.

The action is two-click:

1. first click starts one reversible asynchronous movement;
2. after movement finishes, second click reports and persists PASS/FAIL.

The probe:
- refuses while DynamicCam is loaded;
- is manual only;
- is excluded from Run All;
- reads camera zoom secret-safely;
- reads `cameraZoomSpeed` without changing it;
- uses only `MoveViewInStart/Stop` and `MoveViewOutStart/Stop`;
- moves 0.75 zoom units and returns to the captured start zoom;
- records whether it began in combat;
- stops movement on every completion/failure path;
- does not use `SetCVar`;
- does not use `CameraZoomIn/Out`;
- does not subscribe to state or register automatic events.

## Static contract

Adds:
`tools/check_camera_probe_contract.py`.

The checker rejects:
- automatic context/event ownership;
- tickers/timers used as polling;
- `SetCVar`;
- the unproven camera fallback;
- accidental inclusion in Run All.

## Delivery repair

The first P0095 delivery stopped safely during temporary-tree validation because
`tools/check_camera_probe_contract.py` required two quote-delimited tokens that
did not match the intended longer runtime format string.

P0095 R2 corrects the checker only; runtime camera behavior is unchanged.

Durable failure record:
`../evidence/P0095_DELIVERY_CHECKER_FALSE_NEGATIVE_2026-10-02.md`.

## Runtime acceptance

DynamicCam must be disabled for the isolated proof.

Required:

1. out-of-combat two-click probe -> PASS, restored=true;
2. in-combat two-click probe -> PASS, restored=true;
3. Run All -> PASS;
4. no Lua/taint/protected/secret errors.

Only then may G.2 specify production World/Combat camera ownership.

## P0095 runtime result

Two reversible camera runs passed target/movement/restoration with DynamicCam
disabled and no secret/error result.

Both reported `combat=false`.

Cause: the probe classified combat from cached `Logres:GetState().combat`, not
DynamicCam's live `UnitAffectingCombat("player")` predicate.

P0096 owns the diagnostic correction.
