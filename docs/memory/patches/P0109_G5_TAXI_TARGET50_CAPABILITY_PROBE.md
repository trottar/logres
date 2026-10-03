# P0109 — G.5 Taxi Target-50 Capability Probe

Date: 2026-10-03
Result: **INSTALLED / PUSHED — CLEAN NEGATIVE CAPABILITY RESULT**
Commit: `affb1ace6b7561ce9c2046b74273948dfbb5c4b5`
Baseline: `19efaad6523369020c6789d9e18e006538e3bf68`
Runtime: `0.0.43-dev -> 0.0.44-dev`

## Purpose

Answer one narrow G.5 question:

Can the current Forever camera reach the captured Taxi absolute target `50`
through the already-proven MoveView path without mutating
`cameraDistanceMaxZoomFactor`?

## Runtime implementation

P0109 extends the existing `CameraCapabilityProbe` with a Phase G
`Taxi Target 50 Probe`.

The probe:
- reads but does not mutate `cameraDistanceMaxZoomFactor`;
- records effective ceiling `factor * 15`;
- attempts target 50 over 5 seconds;
- returns to captured starting zoom;
- checks CVar unchanged;
- records target/movement/restoration/secret/error state;
- remains mutually exclusive with production camera ownership and DynamicCam.

Production Taxi ownership remains unchanged.

## Delivery correction — R2

The first P0109 apply wrote the intended worktree and stopped on two checker false
negatives. R2 corrected checker expectations and recorded that delivery failure
at:

`../evidence/P0109_DELIVERY_CHECKER_FALSE_NEGATIVE_2026-10-03.md`

No runtime camera behavior changed between the first write and R2.

## Runtime evidence

Canonical result:
`../evidence/G5_P0109_TARGET50_NEGATIVE_2026-10-03.md`.

Two independent runs on `0.0.44-dev` recorded:
- factor `1.2`;
- effective ceiling `18`;
- intended target `50`;
- actual turn zoom `18`;
- `targetReached=false`;
- `moved=true`;
- `restored=true`;
- `cvarUnchanged=true`;
- `secret=false`;
- DynamicCam not loaded.

The controller was disabled for the probe and re-enabled afterward.

## Result

**CLEAN NEGATIVE CAPABILITY RESULT.**

Target 50 cannot be reached under the current no-camera-distance-CVar-mutation
boundary.

This is not a production camera-controller failure.

The aggregate probe error text is broader than the actual failed criterion; the
explicit telemetry shows movement and restoration passed and target reach failed.

## Next

Open the separate camera-distance CVar ownership investigation.

Do not:
- clamp Taxi to 18;
- mutate the CVar without a source-resolved ownership contract;
- enable production Taxi ownership;
- add Taxi rotation or UI fade.
