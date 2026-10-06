# Current Handoff

Authoritative state:
`../CURRENT.md`.

Latest verified durable checkpoint:
P0154 `40dec1874a587156c88319a9caed940088e25db7` / candidate `0.0.75-dev`.

## P0154 runtime result

The targeted world-entry motion diagnostic reproduced the failure on loadCount `184`:
- start about `23.148`, target `5`, final `50`;
- `145` samples, with only `1` toward and `1` away displacement and `143` flat;
- observed minimum `0`, maximum `50`;
- final/max easing position error `45`;
- `142` inward MoveView commands and `1` outward command;
- timeout failure preserved in both Phase G check and separate Run All.

P0154 is therefore a diagnostic PASS, not a camera-behavior PASS.

## Narrow cause identified

P0119 deliberately supports crossed-target correction. P0154 proves that the world-entry disturbance caused at least one correction-direction reversal.

`Camera/WorldCombat.lua` currently starts the new MoveView direction on reversal without first stopping the previously active direction. The prior direction is stopped only at transition cleanup. This is a concrete driver defect and can leave opposite camera motions concurrently active.

The external source of the `0 -> 50` world-entry displacement remains unproven.

## P0155 R1 correction

P0155 R1:
- stops the previous MoveView direction before starting the opposite one;
- fails open if that directional stop errors;
- retains P0154 diagnostics and adds a direction-switch count;
- changes no target, duration, timeout, context priority, CVar, event, Taxi, or suppression policy;
- adds no polling, ticker, arbitrary delay, or positional rebase.

After deployment:
1. `/reload`;
2. Phase G -> **Camera World/Combat Check**;
3. Phase 0 -> **Run All**;
4. upload refreshed diagnostics.

If world entry still times out, preserve that result and narrow from the retained motion evidence before any further correction.

## Key references

- `../CURRENT.md`
- `../evidence/P0155_P0154_CAMERA_MOTION_RESULT_2026-10-06.md`
- `../investigations/CAMERA_WORLD_ENTRY_TRANSITION_TIMEOUT_2026-10-06.md`
- `../patches/P0155_CAMERA_DIRECTION_SWITCH_STOP.md`
- `../patches/P0154_WORLD_ENTRY_CAMERA_MOTION_DIAGNOSTIC.md`
- `../roadmap/PHASE_G_CINEMATIC_CAMERA.md`
