# Current Handoff

Authoritative state:
`../CURRENT.md`.

Phase G:
**ACTIVE — G.5.**

P0109 is verified durable at:
`affb1ace6b7561ce9c2046b74273948dfbb5c4b5`.

Current pushed runtime:
`0.0.44-dev`.

G.4:
**CLOSED — RUNTIME + INTEGRATION PASS.**

G.5:
**TARGET-50 CAPABILITY CLEAN NEGATIVE; CAMERA-DISTANCE OWNERSHIP REVIEW NEXT.**

Canonical negative runtime evidence:
`../evidence/G5_P0109_TARGET50_NEGATIVE_2026-10-03.md`.

Observed twice:
- factor `1.2`;
- effective ceiling `18`;
- target `50`;
- turn zoom `18`;
- `targetReached=false`;
- `moved=true`;
- `restored=true`;
- `cvarUnchanged=true`;
- `secret=false`;
- DynamicCam not loaded.

This proves target 50 is unavailable under the current no-CVar-mutation boundary.
Production Taxi ownership therefore remains fail-open.

Next:
source/contract audit of `cameraDistanceMaxZoomFactor` ownership, range,
persistence, restoration, combat/protected behavior, and DynamicCam/LibCamera
semantics.

Do not mutate the CVar, clamp Taxi to 18, add rotation, or add Taxi UI fade yet.

User performs all commits/pushes.
