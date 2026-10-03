# G.5 — Taxi Camera Ownership

Status: **TARGET-50 NO-CVAR NEGATIVE — READ-ONLY CAMERA-DISTANCE DEFAULT/METADATA PROBE NEXT**
Opened: 2026-10-03
Contract review resolved: 2026-10-03
Target-50 no-CVar runtime result: 2026-10-03

## Objective

Replace the current Taxi fail-open exclusion only after Logres can reproduce the
captured Taxi behavior without silently taking unproven camera-distance CVar,
rotation, or UI-presentation ownership.

## Resolved Taxi contract

- activation is existing `state.onTaxi`, sourced from `UnitOnTaxi("player")`;
- Taxi priority `1000` outranks interaction `110`, live combat `50`, City `1`,
  and World `0`;
- intended Taxi conditional-out target is absolute zoom `50`;
- ordinary Taxi entry uses `5` seconds;
- ordinary Taxi exit uses destination entering transition under restore `never`;
- Taxi rotation is separately gated;
- Taxi UI hide/fade remains presentation policy;
- instance and DynamicCam fail-open boundaries remain intact.

## P0109 capability result

Target 50 with current factor 1.2:
**CLEAN NEGATIVE**.

Canonical evidence:
`../evidence/G5_P0109_TARGET50_NEGATIVE_2026-10-03.md`.

## Camera-distance source result

Canonical audit:
`../evidence/G5_CAMERA_DISTANCE_SOURCE_AUDIT_2026-10-03.md`.

Important correction to the next-step hypothesis:

The captured Taxi target 50 does not itself prove DynamicCam raises the
camera-distance maximum.

DynamicCam's standard setting inherits `GetCVarDefault`, and neither the captured
standard profile nor Taxi situation stores an explicit max-distance override.

Therefore the actual inherited Forever default must be measured before Logres
considers CVar mutation.

## Current production behavior

Taxi remains fail-open/out-of-slice.

Do not:
- substitute target 18;
- mutate max-distance yet;
- add Taxi rotation;
- add Taxi UI fade.

## Next

Use P0112 Phase G `Camera Distance Info` and classify the read-only result.
