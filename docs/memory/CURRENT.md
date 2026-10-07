---
memory_schema: 1
as_of: 2026-10-07
project: logres
---

# Current State

## Active Objective

**Finish captured DynamicCam `RPG` camera parity using the audited DynamicCam/LibCamera source rather than extending the bespoke Logres zoom driver, then enter Phase H integration/layout and final polish.**

The canonical profile is already stored in repository evidence. Do not request another export unless the user's profile changes.

P0159 R1 is verified durable at `8ddcf09844961adec7bc90621f0f5ca294f15aef` on runtime `0.0.78-dev`.

## Current Work Item

**P0160 R2 — replace the bespoke zoom timing/correction path with the audited LibCamera source behavior.**

P0159 runtime evidence resolves two different facts:

- profile/context ownership and Taxi entry are working;
- the post-Taxi destination zoom driver is not.

Observed normal Taxi:
- context `taxi`;
- requested/effective target `50`;
- current/final about `49.75597`;
- failures `0`.

Observed landing City transition:
- start about `49.75597`;
- target `5`;
- final `0`;
- elapsed about `3.278s`;
- `97` samples;
- `55` inward / `40` outward commands;
- `80` direction switches;
- observed range `0 -> 50`;
- max absolute easing-position error about `49.471`;
- failures `1`.

The current custom driver has therefore diverged materially from the open-source motion engine used by DynamicCam.

P0160 R2 ports the ordinary LibCamera zoom behavior from audited commit
`c0b23135a0b24fbca24b41cb53dd7afc9114e352`:

- source `InOutQuad` easing;
- source easing-velocity approximation;
- source position/time rebase at error `> 0.5`;
- source rebase precision `0.005`, maximum `100` iterations;
- source final target correction using a temporary `cameraZoomSpeed` override and one `CameraZoomIn` / `CameraZoomOut` request;
- exact restoration of the captured pre-correction `cameraZoomSpeed`;
- existing Logres secret checks, DynamicCam coexistence, stop-before-reverse, and fail-open ownership retained.

This checkpoint does **not** mutate `cameraDistanceMaxZoomFactor`. It also does not yet add rotation, shoulder/dynamic-pitch/focus settings, reactive mouse-wheel zoom, or DynamicCam UI fades.

The initial P0160 artifact is a delivery failure only: it refused in shadow preflight because its historical P0154 checker rewrite used an obsolete exact output anchor. It made no tracked writes.

P0160 R1 is also a delivery failure only: after that correction, shadow preparation reached `docs/memory/roadmap/STATUS.md` and refused because the applier expected a stale Phase H table row. The observed worktree status contained no tracked changes. P0160 R2 corrects that exact verified baseline anchor and preserves both failures.

## Verified State

P0159 R1 base/profile check is clean on loadCount `189`:
- world target `5`;
- profile secret skips `0`;
- profile read failures `0`;
- profile error `nil`;
- separate Run All clean.

Taxi entry is runtime-proven twice at about `49.75597 / 50`.

The landing City failure is reproduced and blocks further Camera parity until the shared zoom engine is corrected.

The DynamicCam source audit establishes:
- DynamicCam delegates zoom motion to LibCamera;
- LibCamera contains the first-frame timing, easing velocity, position-time rebase, stop behavior, and final correction semantics that Logres had been reconstructing incrementally;
- the source final correction temporarily owns only `cameraZoomSpeed` and restores it;
- LibCamera does not mutate `cameraDistanceMaxZoomFactor`.

The earlier blanket “no SetCVar in Camera” rule is narrowed: **P0160 R2 may temporarily own `cameraZoomSpeed` only for the source-backed final correction, with exact restoration. `cameraDistanceMaxZoomFactor` remains outside Logres ownership.**

## Next Action

Apply and deploy P0160 R2 (`0.0.79-dev`), then:

1. `/reload`.
2. Phase G -> **Camera Profile Check**.
3. Phase 0 -> **Run All** separately.
4. Take one normal Taxi flight.
5. During the flight: Phase G -> **Camera Profile Check**.
6. After landing and settling: Phase G -> **Camera Profile Check** again.
7. Upload refreshed `LOGRES_DIAGNOSTICS_LATEST.lua`.

The landing result is the decisive gate. It must converge near `5` without the prior `0 <-> 50` reversal pattern.

If clean, proceed directly to the remaining source/profile parity layer: rotations plus camera-setting ownership/restoration. UI fading remains a Phase H presentation-policy integration point.

## Success Criteria

P0160 R2 succeeds when:
- ordinary world/profile baseline remains clean;
- Taxi entry remains clean at target `50`;
- post-Taxi City/World converges near target `5`, not first-person `0`;
- the source position/time rebase is observable when needed;
- source final correction may temporarily change only `cameraZoomSpeed` and restores the exact captured value;
- `cameraDistanceMaxZoomFactor` is never mutated;
- no periodic polling, ticker, or arbitrary delay is introduced;
- prior high-frequency reversal behavior does not recur;
- all repository static checks and `git diff --check` pass;
- runtime shows no Lua, taint, protected-action, secret-value, or restoration error.

## Do Not Reopen Without New Evidence

- no conventional player health bar;
- no `cameraDistanceMaxZoomFactor` mutation;
- no periodic camera/context polling;
- no rotation, shoulder-offset/dynamic-pitch/focus settings, reactive mouse-wheel zoom, or DynamicCam UI fade in P0160 R2;
- P0152 pet execution/state presentation remains accepted;
- stock minimap, Party/CompactPartyFrame, target aura/status, target-of-target, and unsupported class/special surfaces remain available until their replacement gates are satisfied;
- player harmful/urgent and populated target aura production remain deferred;
- positive world-target nameplate attachment remains deferred;
- individual tracking-result positions remain source-blocked by D-043;
- possess/override/vehicle/extra-action surfaces remain separate domains.

## Relevant References

- `docs/memory/evidence/P0160_LIBCAMERA_ZOOM_SOURCE_AUDIT_2026-10-07.md`
- `docs/memory/evidence/P0160_P0159_TAXI_LANDING_FAILURE_2026-10-07.md`
- `docs/memory/patches/P0160_R2_LIBCAMERA_ZOOM_DRIVER.md`
- `docs/memory/patches/P0159_DYNAMICCAM_PROFILE_CONTEXT_ZOOM_PARITY.md`
- `docs/memory/evidence/G1_DYNAMICCAM_RPG_PROFILE_2026-10-02.json`
- `docs/memory/evidence/G6_DYNAMICCAM_PROFILE_PARITY_AUDIT_2026-10-06.md`
- `docs/memory/investigations/G6_DYNAMICCAM_PROFILE_PARITY.md`
- `docs/memory/architecture/CAMERA.md`
- `docs/memory/roadmap/PHASE_G_CINEMATIC_CAMERA.md`
- `docs/memory/roadmap/STATUS.md`
- `docs/ROADMAP.md`
