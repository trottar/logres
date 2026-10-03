---
memory_schema: 1
as_of: 2026-10-03
project: logres
---

# Current State

## Active Objective

**Phase G — Cinematic Camera.**

## Current Work Item

**G.5 — Read the Forever camera-distance default/metadata before deciding CVar ownership.**

Latest verified durable checkpoint:
P0113 `19c0d1ffcdc0cf2df59a2e648cfa9caab1c4d347`.

Current pushed runtime:
`0.0.44-dev`.

P0112 prepared runtime:
`0.0.45-dev`.

G.4 status:
**CLOSED — RUNTIME + INTEGRATION PASS.**

G.5 status:
**TARGET-50 NO-CVAR CAPABILITY CLOSED NEGATIVE; CAMERA-DISTANCE SOURCE CONTRACT RESOLVED; READ-ONLY DEFAULT/METADATA PROBE PENDING.**

## Verified State

- Phase F is complete.
- G.1 captured the current DynamicCam `RPG` profile durably.
- G.2 primary MoveView camera capability is runtime + integration PASS.
- G.3 World/Combat production ownership is runtime + integration PASS.
- G.4 City/resting ownership is runtime + integration PASS on `0.0.43-dev`.
- P0109 runtime `0.0.44-dev` proved twice that current factor `1.2` yields
  effective ceiling `18`; target 50 was not reached while movement, restoration,
  unchanged-CVar, and secret-safety checks succeeded.
- P0110 at `51c6fbc` durably records that clean negative and keeps Taxi
  fail-open.
- P0111 at `bd0a9da3` durably records the parallel D-036/D-037 future visual and
  navigation direction without changing runtime.
- G.5 source audit now resolves the next architectural question:
  - DynamicCam's non-mainline UI permits displayed camera distance 50;
  - displayed distance is factor times 15;
  - target 50 therefore requires factor at least `50 / 15`;
  - DynamicCam standard `cameraDistanceMaxZoomFactor` defaults from
    `GetCVarDefault("cameraDistanceMaxZoomFactor")`;
  - the captured G.1 profile does not store an explicit standard max-distance
    factor;
  - Taxi does not store a situation-specific max-distance override;
  - DynamicCam does not auto-raise max-distance merely because Taxi zoom target
    is 50;
  - pinned LibCamera does not own `cameraDistanceMaxZoomFactor`.
- Therefore P0109's measured current value `1.2` is insufficient to decide
  whether Logres should ever mutate the CVar. The missing runtime fact is the
  inherited **client default and CVar metadata**.
- P0112 adds a read-only Phase G developer-panel action:
  `Camera Distance Info`.
- The action prefers `C_CVar.GetCVarInfo` and safely reports current/default
  factor, effective ceilings, required factor, storage/lock/secure/read-only
  flags, DynamicCam load state, and secret/error state.
- A fallback uses only read-only current/default APIs if GetCVarInfo is
  unavailable.
- P0112 does not call `SetCVar`, does not move the camera, and does not change
  production Taxi ownership.
- Taxi rotation and Taxi UI hide/fade remain separately gated.
- D-035 quest interaction ownership remains a valid future endpoint with Blizzard
  fail-open controls until each replacement capability is proven.
- D-036 freezes the future player-health tunnel visual contract: remaining health
  roughly maps to remaining clear/usable visual field, with severe critical collapse.
- D-037 accepts four future navigation marker roles — manual waypoint, quest
  destination, local radius POI, and tracking — while preserving D-030: the stock
  minimap remains until the complete replacement surface is capability-proven.
- Local POI/tracking position sources and exact Forever tracking semantics remain
  hypothetical/unproven and are deferred to a dedicated Phase H+ capability audit.

## Next Action

After P0112 is verified pushed, deploy runtime `0.0.45-dev`.

Use the Phase G developer-panel GUI:
`Camera Distance Info`

No camera controller disable, camera positioning, Taxi ride, or DynamicCam
disable is required because this diagnostic is read-only.

Then flush/export the developer-panel diagnostic.

## Decision Gate

Use the runtime `default` value, not assumption:

- if default factor is at least `50 / 15`, investigate the smallest safe
  temporary max-distance ownership capability;
- if default factor is below `50 / 15`, preserve that as evidence that
  DynamicCam's inherited standard setting itself cannot make target 50 physically
  reachable without an additional max-distance policy.

In either case:
- do not silently clamp Taxi to 18;
- do not call `SetCVar` yet;
- do not enable production Taxi ownership yet.

## Success Criteria

This checkpoint completes when runtime evidence safely records:
- current factor;
- default factor;
- current/default effective ceilings;
- required target-50 factor;
- current/default support result;
- storage/lock/secure/read-only metadata where available;
- DynamicCam state;
- secret/error state.

## Do Not Reopen Without New Evidence

- **G.1:** profile capture complete.
- **G.2:** primary zoom capability PASS.
- **G.3:** World/Combat ownership PASS.
- **G.4:** City ownership PASS.
- **G.5 target 50 without CVar mutation:** clean NEGATIVE on `0.0.44-dev`.
- **Taxi intended target:** 50.
- **Target-50 required factor:** `50 / 15`.
- **Current observed factor:** 1.2; ceiling 18.
- **Camera-distance mutation:** still not authorized.
- **Production Taxi ownership:** still fail-open.
- **Taxi rotation/UI fade:** separately gated.
- **D-036 health tunnel:** accepted/frozen future visual contract.
- **D-037 navigation/minimap direction:** accepted future endpoint; capability-gated.
- **D-030 minimap boundary:** still current runtime authority until replacement proof.
- **Git authority:** user performs commits/pushes.

## Relevant References

- `docs/memory/evidence/G5_P0109_TARGET50_NEGATIVE_2026-10-03.md`
- `docs/memory/evidence/G5_CAMERA_DISTANCE_SOURCE_AUDIT_2026-10-03.md`
- `docs/memory/investigations/G5_CAMERA_DISTANCE_CVAR_OWNERSHIP.md`
- `docs/memory/investigations/G5_TAXI_CAMERA_OWNERSHIP.md`
- `docs/memory/architecture/CAMERA.md`
- `docs/memory/patches/P0112_G5_CAMERA_DISTANCE_INFO.md`
- `docs/memory/roadmap/PHASE_G_CINEMATIC_CAMERA.md`
