# P0120 Shared Percentage-Bar Runtime / Visual Evidence — 2026-10-04

Status: **CORE RUNTIME + VISUAL PASS — SIMPLIFIED PRODUCTION BASELINE ACCEPTED**

Durable implementation: `6c5f8901d3f5b7434b76f05af1f22a0add8c1b10`  
Runtime: `0.0.50-dev`

## Observed result

After deployment, the user reported that the shared percentage-bar implementation
"worked great" and explicitly accepted the simpler production treatment for now,
with the more ornate approved-sheet treatment deferred to later visual refinement.

The uploaded diagnostics recorded the deployed `0.0.50-dev` build and:

```text
Logres hudcheck: PASS (bands=4 textures=16 curves=true resourceText=true resourceCurve=true target=true casts=true allies=5 immersion=true visible=true)
```

Immersion OFF/ON was also exercised repeatedly without a reported Lua, secret-value,
taint, or protected-action failure.

## Interpretation

PASS is recorded for the P0120 shared percentage-bar production baseline:
- player primary-resource percentage bar is usable and visually accepted;
- detached target-health percentage bar is usable and visually accepted;
- reusable normal/compact primitive is integrated without introducing a player
  health bar;
- percentage text remains visible;
- immersion hide/restore remains intact;
- the intentionally simpler production geometry is accepted as the current
  baseline rather than treated as a defect.

The exact ornamental richness of the approved resource-bar sheet is **deferred
polish**, not a runtime gap. The later whole-screen calibration pass may add more
of that ornament if it improves the assembled interface.

Pet/party compact-bar behavior remains structurally covered by the same primitive
and existing proven ally update path. This evidence does not claim a new separate
party-composition runtime test unless one was naturally present during the visual
check.
