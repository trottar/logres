# P0104 — Resolve G.4 City Camera Contract

Date: 2026-10-03
Result: INSTALLED / PUSHED — DOCS/SOURCE EVIDENCE ONLY (`0b676083`)

## Baseline

P0103 verified pushed:
`4adf400a4b2ee66a29a398f14364610288a6b4b9`.

Runtime remains:
`0.0.42-dev`.

## Purpose

Resolve the City/resting camera contract from the already-captured DynamicCam
profile, upstream source semantics, and current Logres state/controller
architecture before writing runtime code.

## Source result

Canonical audit:
`../evidence/G4_CITY_CAMERA_SOURCE_AUDIT_2026-10-03.md`.

Resolved facts:
- City `001` is resting, priority 1;
- World (Combat) is live combat, priority 50, and therefore wins over City;
- City is conditional-in target 5;
- ordinary City entry is 2.5 seconds;
- ordinary changes use the entering situation's transition time;
- zoom restore is never;
- existing Logres resting state/event publication is sufficient;
- existing G.3 MoveView, coexistence, interruption, and fail-open architecture is
  the correct base for the smallest City slice.

## Explicit deferrals

P0104 does not authorize runtime ownership of:
- DynamicCam City UI hide/fade;
- City `cameraDistanceMaxZoomFactor = 1` or broader camera CVar policy;
- reactive zoom;
- DynamicCam's global first-situation instant transition special case;
- later DynamicCam situations, rotation, or shoulder offsets.

The reactive-zoom values explicitly stored for City are equivalent to the
captured effective standard settings, and City cameraZoomSpeed equals standard
15.5; neither creates a City-specific runtime delta for the first slice.

## Next implementation

Extend the existing production controller with `city` selected after live combat
and before World, target 5, same 2.5-second transition architecture. Extend
addon-owned diagnostics and static contract coverage accordingly.

Runtime proof will target automatic City entry, >5 transition, <=5 no-op, exit
fresh evaluation, Run All, DynamicCam coexistence, and clean error/secret state.
Combat+resting overlap is not to be manufactured solely for proof.

## Deployment

Docs/source-evidence only.

**No WoW redeploy is required.**

## Verified push

P0104 is durable on `main` at `0b6760838441a896b97a656099e38e6c6f399bfd`.
