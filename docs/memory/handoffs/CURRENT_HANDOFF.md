# Current Handoff

Authoritative state:
`../CURRENT.md`.

Phase G:
**ACTIVE — G.5.**

Latest verified durable checkpoint:
P0116 `c64fcc97698e0dbe98a8d52469444f2ef15a76ec`.

Current pushed runtime:
`0.0.46-dev` — P0116 action visual translation; in-client visual proof pending.

P0117 prepared runtime:
`0.0.47-dev`.

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

DynamicCam parity correction:
requested Taxi target `50` is not a physical-reachability guarantee. Pinned
LibCamera accepts the engine max-distance clamp.

P0117 prepares runtime `0.0.47-dev` production Taxi zoom:
requested=50, effective=min(50, live ceiling), entry=5s, no SetCVar.

Next after verified push:
deploy, use Phase G GUI, obtain one normal Taxi-flight automatic ownership proof,
then verify destination context after landing.

Production Taxi: P0117 prepared; runtime proof pending.

Parallel accepted Phase H+ direction remains unchanged:
- D-036 health-tunnel visible-field contract;
- D-037 four navigation roles and future minimap-replacement endpoint;
- D-038 compass focus/depth visual contract;
- D-030 stock minimap remains current runtime authority until replacement proof;
- POI/tracking source capability remains deferred/unproven;
- D-039 preserves the twelve approved visual reference sheets as the canonical
  visual baseline;
- `../architecture/VISUAL_IMPLEMENTATION_STATUS.md` is the implementation audit
  for translating those designs into addon assets/runtime.
- D-040 establishes `Logres/Media/Theme.lua` as the production visual token/path
  boundary; P0116 wires the approved action-button frame/state family and awaits
  in-client visual proof.

User performs all commits/pushes.
