# Current Handoff

Authoritative state:
`../CURRENT.md`.

Latest verified durable checkpoint:
P0153 `7ad9be7ecc24c1136bf9a843689f90fb377b2012`; P0152 runtime code remains `00aef4a9` / `0.0.74-dev`.

## Accepted P0152 result

P0152 R12 remains accepted: pet controls are default-on, working, state-aware, and retain stock PetActionBar fallback. Exact visual ornament refinement is deferred.

## Reproduced camera defect

The P0153 targeted retest reproduced the `PLAYER_ENTERING_WORLD` Camera World/Combat timeout. Phase G **Camera World/Combat Check** failed after `/reload` with start about `8.524`, target `5`, final/current about `12.632`, elapsed about `3.258s`, and `failures=1`. Phase 0 **Run All** immediately repeated the same camera failure while the other listed checks passed.

Classification: **REPRODUCED RUNTIME FAILURE**.

The camera moved outward while the requested transition was inward. Static source review says Logres' MoveView direction mapping matches audited LibCamera, but the competing runtime motion source is not proven.

## P0154 diagnostic

P0154 instruments the existing P0119 transition without changing behavior. It records:
- sample count;
- frames moving toward/away/flat relative to target;
- min/max observed zoom;
- current/max easing position error;
- last observed motion direction/delta;
- last MoveView command direction/factor;
- inward/outward command counts.

After deployment:
1. `/reload` normally;
2. Phase G -> **Camera World/Combat Check**;
3. Phase 0 -> **Run All**;
4. upload refreshed diagnostics.

Do not use slash-command duplicates when the panel action exists. Do not add polling, delays, broad hooks, or speculative camera correction before this evidence is captured.

## Key references

- `../CURRENT.md`
- `../evidence/P0154_WORLD_ENTRY_CAMERA_TIMEOUT_REPRODUCED_2026-10-06.md`
- `../investigations/CAMERA_WORLD_ENTRY_TRANSITION_TIMEOUT_2026-10-06.md`
- `../patches/P0154_WORLD_ENTRY_CAMERA_MOTION_DIAGNOSTIC.md`
- `../roadmap/PHASE_G_CINEMATIC_CAMERA.md`
