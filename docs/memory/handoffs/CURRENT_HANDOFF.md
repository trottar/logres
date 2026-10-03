# Current Handoff

Authoritative state:
`../CURRENT.md`.

Phase G:
**ACTIVE — G.5.**

Latest verified durable checkpoint:
P0118 `6fad23f595a4abc9f5f2bd3fd6f12b825ef204e2`.

Current pushed runtime:
`0.0.48-dev` — action-keybind polish; visual proof pending.

P0117 camera runtime result:
Taxi entry PASS / landing transition FAIL on `0.0.47-dev`.

P0119 prepared runtime:
`0.0.49-dev` — shared frame-shaped camera transition correction.

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

P0117 is pushed at `82bdb4f3` on runtime `0.0.47-dev`:
requested=50, effective=min(50, live ceiling), entry=5s, no SetCVar.

P0117 runtime result:
Taxi entry PASS; landing City transition FAIL. The observed `18 -> 5` transition
overshot to final zoom `0` / first person. Earlier `0.0.43-dev` diagnostics show
the same latent shared transition-driver failure.

P0119 prepares frame-shaped MoveView velocity plus crossed-target correction.

Next after verified push:
deploy `0.0.49-dev`, repeat one normal Taxi flight, and verify landing settles
near the destination target rather than zoom `0`.

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
  boundary; P0116 core action presentation/feedback is runtime + visual PASS.
  P0118 refines action-button readability only: stronger dark tag fill, compact
  modifier labels, and modest size increase; detailed P0116 state coverage remains
  deferred.

User performs all commits/pushes.
