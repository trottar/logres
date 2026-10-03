# Current Handoff

Authoritative state:
`../CURRENT.md`.

Phase G:
**ACTIVE — G.5.**

Remote P0107 is verified durable at:
`ab83882f28f98b3d90cc6bee65e5d7c45928c536`.

Current pushed runtime:
`0.0.43-dev`.

G.4:
**CLOSED — RUNTIME + INTEGRATION PASS.**

G.5:
**SOURCE/PROFILE CONTRACT RESOLVED — TARGET-50 CAPABILITY PROBE NEXT.**

Canonical G.5 audit:
`../evidence/G5_TAXI_CAMERA_SOURCE_AUDIT_2026-10-03.md`.

Resolved Taxi contract:
- use existing runtime-proven `state.onTaxi`;
- Taxi priority `1000` outranks interaction `110`, combat `50`, City `1`, World `0`;
- instance remains the outer fail-open boundary;
- Taxi is conditional-out absolute target `50`;
- Taxi entry is `5` seconds;
- ordinary Taxi exit uses the destination situation's entering transition under
  restore `never`;
- rotation is separable and remains capability-gated;
- UI hide/fade remains presentation policy;
- DynamicCam/probe coexistence and fail-open behavior remain unchanged.

Blocking capability question:
current Forever reachability of target `50` without mutating
`cameraDistanceMaxZoomFactor`.

Next:
prepare one **developer-panel GUI** capability probe that reads the CVar, attempts
target `50` through the proven MoveView path, restores starting zoom, and records
target/secret/error state.

Do not implement production Taxi ownership until that probe passes.

User performs all commits/pushes.
