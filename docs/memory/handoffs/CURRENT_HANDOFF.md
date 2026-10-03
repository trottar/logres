# Current Handoff

Authoritative state:
`../CURRENT.md`.

Phase G:
**ACTIVE — G.5.**

Latest verified durable checkpoint:
P0112 `dea48e04dfdb46f0f443222806e0d6bc81afd2e8`.

Current pushed runtime:
`0.0.45-dev`.

Target 50 without max-distance mutation:
**CLOSED — CLEAN NEGATIVE.**

Camera-distance default/metadata proof:
**COMPLETE — READ-ONLY PASS; DEFAULT FACTOR 1 / CEILING 15 DOES NOT SUPPORT TARGET 50.**

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

P0112 runtime `0.0.45-dev` read-only PASS recorded:
- current factor `1.2`, ceiling `18`;
- default factor `1`, ceiling `15`;
- required factor `3.3333333333333`;
- current/default support false/false;
- account-stored=true, character-stored=false;
- locked=false, secure=false, readOnly=false;
- DynamicCam not loaded; secret=false; error=nil.

Next:
resolve product/ownership policy for any temporary above-default account-scoped
camera-distance mutation. No SetCVar probe is authorized yet.

Production Taxi remains fail-open.

Parallel accepted Phase H+ direction remains unchanged:
- D-036 health-tunnel visible-field contract;
- D-037 four navigation roles and future minimap-replacement endpoint;
- D-038 compass focus/depth visual contract;
- D-030 stock minimap remains current runtime authority until replacement proof;
- POI/tracking source capability remains deferred/unproven.

User performs all commits/pushes.
