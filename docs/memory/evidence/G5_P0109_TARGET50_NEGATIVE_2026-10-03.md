# G.5 P0109 Taxi Target-50 Capability Negative — 2026-10-03

Status: **CLEAN NEGATIVE CAPABILITY RESULT**
Runtime: `0.0.44-dev`
Implementation checkpoint: P0109 `affb1ace6b7561ce9c2046b74273948dfbb5c4b5`
Date: 2026-10-03

## Question

Can the current Forever camera reach the captured Taxi absolute zoom target `50`
through the proven MoveView path without changing
`cameraDistanceMaxZoomFactor`?

## Environment

Diagnostic export reported:
- client `1.60.1`;
- build `70205`;
- interface `16001`;
- Logres runtime `0.0.44-dev`.

DynamicCam was not loaded during the accepted probe runs.

The production World/Combat/City camera controller was explicitly disabled before
the target probe and re-enabled afterward.

## Run 1

Start:
- zoom `5.2230567932129`;
- target `50`;
- `cameraZoomSpeed = 24.5`;
- `cameraDistanceMaxZoomFactor = 1.2`;
- source-derived effective ceiling `18`;
- combat=false;
- lockdown=false.

Result:
- turn zoom `18`;
- final/restored zoom `5.1796183586121`;
- `targetReached=false`;
- `moved=true`;
- `restored=true`;
- `cvarUnchanged=true`;
- factor final `1.2`;
- `secret=false`;
- DynamicCam=false via `C_AddOns`;
- outbound elapsed `5.7679999999818`;
- return elapsed `3.1000000000058`.

## Run 2

Start:
- zoom `5.1796183586121`;
- target `50`;
- `cameraZoomSpeed = 24.5`;
- `cameraDistanceMaxZoomFactor = 1.2`;
- source-derived effective ceiling `18`;
- combat=false;
- lockdown=false.

Result:
- turn zoom `18`;
- final/restored zoom `5.1616683006287`;
- `targetReached=false`;
- `moved=true`;
- `restored=true`;
- `cvarUnchanged=true`;
- factor final `1.2`;
- `secret=false`;
- DynamicCam=false via `C_AddOns`;
- outbound elapsed `5.7559999999939`;
- return elapsed `1.8990000000049`.

## Interpretation

The two runs independently stopped at exactly the source-derived ceiling `18`.

The MoveView path itself worked and restoration worked. The distance CVar did not
change and no secret-value condition was observed.

Therefore the intended Taxi target `50` is unavailable under the current accepted
no-camera-distance-CVar-mutation boundary.

The emitted aggregate error text was:

`movement/target/restoration tolerance failed`

That text is broader than the measured failure. The explicit result fields show:
- movement PASS;
- restoration PASS;
- CVar unchanged PASS;
- target reach FAIL.

Treat the explicit fields as authoritative for this capability result.

## Classification

**NEGATIVE CAPABILITY RESULT — NOT A PRODUCTION CONTROLLER DEFECT.**

No additional target-50 no-CVar retries are required without new evidence.

Production Taxi ownership remains fail-open.

Do not replace target 50 with 18 or another guessed target.

## Next question

Open source/contract review for deliberate camera-distance CVar ownership:
`../investigations/G5_CAMERA_DISTANCE_CVAR_OWNERSHIP.md`.

No CVar mutation is authorized by this evidence checkpoint.
