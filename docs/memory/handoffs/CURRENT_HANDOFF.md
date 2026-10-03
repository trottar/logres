# Current Handoff

Authoritative state:
`../CURRENT.md`.

Phase G:
**ACTIVE — G.5.**

Latest verified durable checkpoint:
P0113 `19c0d1ffcdc0cf2df59a2e648cfa9caab1c4d347`.

Current pushed runtime:
`0.0.44-dev`.

P0112 prepared runtime:
`0.0.45-dev`.

Target 50 without max-distance mutation:
**CLOSED — CLEAN NEGATIVE.**

Camera-distance source contract:
**RESOLVED — READ-ONLY FOREVER DEFAULT/METADATA PROBE NEXT.**

Canonical source audit:
`../evidence/G5_CAMERA_DISTANCE_SOURCE_AUDIT_2026-10-03.md`.

Key source result:
- DynamicCam's displayed max-distance mapping is factor × 15;
- target 50 needs factor >= 50/15;
- DynamicCam standard max-distance inherits `GetCVarDefault`;
- G.1 captured no explicit standard max-distance value;
- Taxi has no max-distance override;
- LibCamera does not raise the max-distance CVar.

Therefore do not jump from current factor 1.2 to a mutation policy.

P0112 adds read-only Phase G GUI action:
`Camera Distance Info`.

It reports current/default factors, ceilings, support threshold, storage/security
metadata, DynamicCam state, and secret/error state without moving the camera or
calling SetCVar.

Next after verified push:
deploy `0.0.45-dev`, click `Camera Distance Info` in Phase G, flush/export
diagnostics.

Production Taxi remains fail-open.

Parallel accepted Phase H+ direction remains unchanged:
- D-036 health-tunnel visible-field contract;
- D-037 four navigation roles and future minimap-replacement endpoint;
- D-030 stock minimap remains current runtime authority until replacement proof;
- POI/tracking source capability remains deferred/unproven.

User performs all commits/pushes.
