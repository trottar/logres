# Current Handoff

Authoritative state:
`../CURRENT.md`.

Latest verified durable checkpoint:
P0159 R1 `8ddcf09844961adec7bc90621f0f5ca294f15aef`.

## P0159 runtime result

Clean:
- ordinary Camera Profile Check;
- profile secretSkips=0 / readFailures=0;
- separate Run All;
- Taxi context/target `50` twice at current/final about `49.75597`.

Failure:
- landing City start about `49.75597`;
- target `5`;
- final `0`;
- elapsed about `3.278s`;
- 97 samples;
- 55 inward / 40 outward commands;
- 80 direction switches;
- range `0 -> 50`;
- max absolute position error about `49.471`;
- failures=1.

This is a shared zoom-engine failure, not a P0159 predicate/priority failure.

## Source audit

DynamicCam delegates camera motion to LibCamera.

Audited LibCamera commit:
`c0b23135a0b24fbca24b41cb53dd7afc9114e352`.

The current Logres driver independently reconstructed only pieces of that engine.

LibCamera's ordinary eased zoom includes:
- first-frame begin time/value;
- InOutQuad easing;
- finite-difference easing velocity;
- position/time rebase when error exceeds 0.5;
- final two-frame direct correction;
- a final 0.1-second correction using temporary `cameraZoomSpeed` ownership and CameraZoomIn/Out;
- restoration of the previous cameraZoomSpeed.

LibCamera does not mutate cameraDistanceMaxZoomFactor.

## P0160 R2

P0160 R2 replaces the bespoke timing/correction path with those source-backed semantics while preserving:
- Logres secret-safe reads;
- DynamicCam coexistence/fail-open ownership;
- stop-before-reverse;
- requested/effective target diagnostics;
- no max-distance mutation.

The initial P0160 artifact refused during shadow preflight because its historical motion-checker rewrite expected an obsolete exact output string. No tracked files were written.

P0160 R1 also refused in shadow preparation because its STATUS.md transform expected a stale Phase H table row. The observed worktree status again contained no tracked changes. R2 corrects that verified baseline anchor and preserves both delivery failures.

Candidate:
`0.0.79-dev`.

## Runtime gate

1. `/reload`;
2. Phase G -> **Camera Profile Check**;
3. Phase 0 -> **Run All**;
4. normal Taxi flight;
5. Camera Profile Check in flight;
6. Camera Profile Check after landing/settle;
7. upload diagnostics.

Do not proceed to rotation/shoulder/settings parity unless the post-Taxi destination zoom converges cleanly near `5`.

## Key references

- `../CURRENT.md`
- `../evidence/P0160_LIBCAMERA_ZOOM_SOURCE_AUDIT_2026-10-07.md`
- `../evidence/P0160_P0159_TAXI_LANDING_FAILURE_2026-10-07.md`
- `../patches/P0160_R2_LIBCAMERA_ZOOM_DRIVER.md`
- `../investigations/G6_DYNAMICCAM_PROFILE_PARITY.md`
- `../architecture/CAMERA.md`
- `../roadmap/PHASE_G_CINEMATIC_CAMERA.md`
