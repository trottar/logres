# Current Handoff

Authoritative state:
`../CURRENT.md`.

Phase G:
**ACTIVE — G.5.**

P0108 is verified durable at:
`19efaad6523369020c6789d9e18e006538e3bf68`.

P0109 runtime checkpoint:
`0.0.44-dev`.

G.4:
**CLOSED — RUNTIME + INTEGRATION PASS.**

G.5:
**TARGET-50 CAPABILITY PROBE IMPLEMENTED — RUNTIME PROOF PENDING.**

Canonical source/profile audit:
`../evidence/G5_TAXI_CAMERA_SOURCE_AUDIT_2026-10-03.md`.

P0109 adds only the diagnostic capability gate:
- Phase G `Taxi Target 50 Probe`;
- existing `CameraCapabilityProbe` module/mutual-exclusion path;
- read-only `cameraDistanceMaxZoomFactor`;
- recorded effective ceiling `factor * 15`;
- 5-second MoveView attempt to target 50;
- MoveView restoration to captured start;
- unchanged-CVar / target / secret / error diagnostics;
- no production Taxi ownership change;
- no rotation, UI fade, or CVar mutation.

Next after verified push:
deploy `0.0.44-dev`, use the Phase G GUI to turn production camera OFF, run the
Taxi target-50 probe, click the same probe again after movement to record the
result, then turn production camera ON and export diagnostics.

A negative target-50 result is valid evidence and must be recorded rather than
worked around with a guessed lower target.

User performs all commits/pushes.
