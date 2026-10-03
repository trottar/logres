---
memory_schema: 1
as_of: 2026-10-03
project: logres
---

# Current State

## Active Objective

**Phase G — Cinematic Camera.**

## Current Work Item

**G.5 — Resolve product/ownership policy for any above-default Taxi camera-distance CVar.**

Latest verified predecessor checkpoint:
P0115 `4ba6393193c830e5deb08a63bb82fdaf2543aa8d`.

Current runtime tree:
`0.0.46-dev` — P0116 action visual translation; in-client visual proof pending.

G.4 status:
**CLOSED — RUNTIME + INTEGRATION PASS.**

G.5 status:
**P0112 READ-ONLY DEFAULT/METADATA PASS; DEFAULT FACTOR 1 / CEILING 15 CANNOT SUPPORT TARGET 50; PRODUCT/OWNERSHIP POLICY NEXT.**

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
- P0113 at `19c0d1ff` durably records D-038 compass focus/depth visual direction.
- D-039 now accepts the twelve tracked visual reference sheets as the canonical
  World Ghost / Selective Hybrid E visual baseline and records the final Compass
  lane/focus calibration. This is parallel Phase H+ design state, not a G.5
  runtime change.
- `VISUAL_IMPLEMENTATION_STATUS.md` separates approved art from remaining asset
  wiring, runtime ownership, and capability gates; broad component art exploration
  is no longer the main missing work for the covered families.
- P0115 is verified durable at `4ba63931` and preserves the twelve approved
  visual sheets plus D-039.
- P0116 begins production translation without changing the active G.5 product
  question: `Logres/Media/Theme.lua` owns runtime visual paths/tokens and the
  proven secure action buttons consume approved frame/hover/pressed/checked/
  activation-flash assets. Runtime visual validation is still pending.
- P0112 at `dea48e04` is durable on runtime `0.0.45-dev`; its read-only
  Camera Distance Info runtime PASS measured current factor `1.2`, default
  factor `1`, ceilings `18`/`15`, and required target-50 factor
  `3.3333333333333`.
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
- P0112 runtime metadata reports account-stored=true, character-stored=false,
  locked=false, secure=false, readOnly=false, secret=false, error=nil.
- Both `currentSupports50` and `defaultSupports50` are false. Therefore the
  inherited DynamicCam/client default cannot satisfy target 50.
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

Resolve the **product/ownership contract** for any temporary
`cameraDistanceMaxZoomFactor` increase above both the current factor `1.2` and
client default `1`.

No runtime mutation is authorized yet.

Before any SetCVar probe, define:
- whether Logres is allowed to alter this account-stored setting at all;
- exact target factor `50 / 15`;
- capture/restore semantics using the observed pre-ownership value, not default;
- coexistence with user/other-addon changes;
- reload/logout/disable/error/crash persistence behavior;
- combat/protected-state behavior;
- fail-open behavior if ownership or restoration is uncertain.

## Decision Gate

P0112 resolves the prior gate:

- default factor `1` < required `50 / 15`;
- default ceiling `15` cannot reach target 50;
- current factor `1.2` / ceiling `18` also cannot reach target 50;
- the CVar is account-stored and metadata does not mark it locked, secure, or
  read-only.

Therefore the next question is not capability-by-default. It is whether Logres
should deliberately own a persistent account-scoped setting temporarily.

Do not clamp Taxi to 18 and do not call SetCVar until that policy is explicit.

## Success Criteria

The next G.5 contract checkpoint completes when:
- the product decision on temporary above-default max-distance ownership is explicit;
- exact restoration ownership is defined around current value `1.2`;
- interruption/persistence/coexistence boundaries are explicit;
- a smallest safe mutation capability probe is defined, or mutation is rejected.

## Do Not Reopen Without New Evidence

- **G.1:** profile capture complete.
- **G.2:** primary zoom capability PASS.
- **G.3:** World/Combat ownership PASS.
- **G.4:** City ownership PASS.
- **G.5 target 50 without CVar mutation:** clean NEGATIVE on `0.0.44-dev`.
- **Taxi intended target:** 50.
- **Target-50 required factor:** `50 / 15`.
- **Current observed factor:** 1.2; ceiling 18.
- **Client default factor:** 1; ceiling 15.
- **Target-50 default support:** false.
- **CVar metadata:** account-stored=true; character-stored=false; locked=false; secure=false; readOnly=false.
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
- `docs/memory/evidence/G5_P0112_CAMERA_DISTANCE_INFO_2026-10-03.md`
- `docs/memory/investigations/G5_CAMERA_DISTANCE_CVAR_OWNERSHIP.md`
- `docs/memory/investigations/G5_TAXI_CAMERA_OWNERSHIP.md`
- `docs/memory/architecture/CAMERA.md`
- `docs/memory/patches/P0112_G5_CAMERA_DISTANCE_INFO.md`
- `docs/memory/roadmap/PHASE_G_CINEMATIC_CAMERA.md`
- `docs/memory/decisions/D-039_APPROVED_VISUAL_BASELINE.md`
- `docs/memory/decisions/D-040_PRODUCTION_VISUAL_ASSET_TRANSLATION_CONTRACT.md`
- `docs/memory/patches/P0116_PRODUCTION_ACTION_VISUAL_PRIMITIVE.md`
- `docs/memory/architecture/VISUAL_IMPLEMENTATION_STATUS.md`
- `docs/design/approved/README.md`
