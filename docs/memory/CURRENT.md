---
memory_schema: 1
as_of: 2026-10-03
project: logres
---

# Current State

## Active Objective

**Phase G — Cinematic Camera.**

## Current Work Item

**G.5 — Runtime-prove DynamicCam-parity production Taxi zoom with engine-clamped target semantics.**

Latest verified durable checkpoint:
P0116 `c64fcc97698e0dbe98a8d52469444f2ef15a76ec`.

Current pushed runtime:
`0.0.46-dev` — P0116 action visual translation; in-client visual proof pending.

P0117 prepared runtime:
`0.0.47-dev`.

G.4 status:
**CLOSED — RUNTIME + INTEGRATION PASS.**

G.5 status:
**DYNAMICCAM PARITY CONTRACT CORRECTED; TARGET 50 IS REQUESTED, NOT GUARANTEED PHYSICAL; P0117 TAXI ZOOM RUNTIME PROOF NEXT.**

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
- P0116 at `c64fcc97` durably begins production visual translation without
  changing the active G.5 product question: `Logres/Media/Theme.lua` owns runtime
  visual paths/tokens and the proven secure action buttons consume approved
  frame/hover/pressed/checked/activation-flash assets. Runtime visual validation
  remains pending.
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
- P0117 source correction: pinned DynamicCam/LibCamera does not require physical
  reachability of requested Taxi target `50`; it requests the target and accepts
  the engine max-distance clamp. The previous above-default-CVar gate was an
  over-interpretation, not a DynamicCam parity requirement.
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

After P0117 is verified pushed, deploy runtime `0.0.47-dev`.

Use the existing Phase G developer-panel GUI and obtain one normal Taxi-flight
runtime proof:
- automatic context becomes `taxi`;
- requested target remains `50`;
- effective target reflects the current live physical max-distance ceiling;
- duration is `5`;
- engine/geometry limitation is not counted as a Taxi controller failure;
- failures=0, secret=false, error=nil;
- after landing, destination context reconciles normally.

No SetCVar, Taxi rotation, or Taxi UI fade is part of this checkpoint.

## Decision Gate

Pinned DynamicCam + LibCamera resolve the prior interpretation:

- Taxi `50` is the requested conditional-out target;
- DynamicCam does not first make physical zoom 50 reachable;
- the engine may clamp below 50;
- a clamped endpoint is not treated as situation failure.

Therefore above-default max-distance mutation is **not a prerequisite** for the
Taxi zoom action.

P0112 current/default measurements remain valid evidence for later full CVar
parity work, but that work no longer blocks this Taxi slice.

## Success Criteria

This P0117 runtime checkpoint completes when a normal Taxi flight proves:
- Taxi wins the non-instance camera priority slice;
- requested target `50` is retained;
- live effective ceiling is reported when readable;
- the 5-second transition completes without addon-owned error/secret failure;
- Taxi exit returns to the correct destination context.

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
- **Camera-distance mutation:** not required for Taxi zoom parity; still not authorized.
- **Taxi target 50 semantics:** requested target; engine-clamped physical endpoint is valid.
- **Production Taxi ownership:** P0117 prepared; runtime proof pending.
- **Taxi rotation/UI fade:** separately gated.
- **D-036 health tunnel:** accepted/frozen future visual contract.
- **D-037 navigation/minimap direction:** accepted future endpoint; capability-gated.
- **D-030 minimap boundary:** still current runtime authority until replacement proof.
- **Git authority:** user performs commits/pushes.

## Relevant References

- `docs/memory/evidence/G5_P0109_TARGET50_NEGATIVE_2026-10-03.md`
- `docs/memory/evidence/G5_CAMERA_DISTANCE_SOURCE_AUDIT_2026-10-03.md`
- `docs/memory/evidence/G5_P0112_CAMERA_DISTANCE_INFO_2026-10-03.md`
- `docs/memory/evidence/G5_DYNAMICCAM_TAXI_PARITY_CORRECTION_2026-10-03.md`
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
