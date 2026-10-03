---
memory_schema: 1
as_of: 2026-10-03
project: logres
---

# Current State

## Active Objective

**Phase G — Cinematic Camera.**

## Current Work Item

**G.5 — Correct P0117 landing overshoot with a frame-shaped MoveView driver; retest Taxi.**

Latest verified durable checkpoint:
P0118 `6fad23f595a4abc9f5f2bd3fd6f12b825ef204e2`.

Current pushed runtime:
`0.0.48-dev` — action-keybind polish; visual proof pending.

Parallel camera evidence:
P0117 Taxi entry PASS / landing transition FAIL on `0.0.47-dev`.

P0119 prepared runtime:
`0.0.49-dev` — shared frame-shaped camera transition correction.

G.4 status:
**CLOSED — RUNTIME + INTEGRATION PASS.**

G.5 status:
**P0117 TAXI ENTRY PASS / LANDING TRANSITION FAIL; P0119 FRAME-SHAPED DRIVER RETEST NEXT.**

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
  frame/hover/pressed/checked/activation-flash assets. Core in-client runtime +
  visual validation is PASS; checked/cooldown/range/resource/unusable state coverage
  remains deferred. P0118 refines only action-button presentation: stronger keybind tag contrast, compact modifier labels, and modest size increase.
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
- P0117 runtime on `0.0.47-dev` proves automatic Taxi entry but landing City
  `18 -> 5` overshot to final zoom `0` / first person.
- Earlier `0.0.43-dev` diagnostics show the same City failure, proving a latent
  shared transition-driver defect rather than a Taxi-specific ownership defect.
- P0118 at `6fad23f` is durable on `0.0.48-dev`; its action-keybind polish is
  parallel and does not change the G.5 camera result.
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

After P0119 is verified pushed, deploy runtime `0.0.49-dev`.

Use one normal Taxi flight:
- confirm Taxi entry remains `context=taxi`, owns=true, requested=50, duration=5;
- land normally;
- allow the destination City/World transition to settle;
- confirm the destination camera finishes near its requested target instead of
  zoom `0`;
- confirm failures=0, secret=false, error=nil;
- export diagnostics.

P0118 action-keybind visual proof remains a parallel concern and is not a G.5
acceptance condition.

No SetCVar, Taxi rotation, or Taxi UI fade is part of this checkpoint.

## Decision Gate

P0117 resolves two separate facts:

- DynamicCam parity for Taxi target `50` is valid: requested 50 may be
  engine-clamped.
- The existing Logres constant-rate MoveView transition driver is not robust:
  large inward transitions can overshoot far beyond their target before the next
  observation frame.

Pinned LibCamera already uses frame-shaped MoveView velocity. P0119 therefore
corrects the shared transition driver rather than adding Taxi-specific landing
special cases.

## Success Criteria

P0119 completes this corrective checkpoint when a normal Taxi flight proves:
- Taxi entry remains correct;
- destination transition no longer lands in first person;
- City/World target convergence is within tolerance;
- no addon failure/secret error is introduced.

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
- **P0117 Taxi entry:** PASS on `0.0.47-dev`.
- **P0117 landing transition:** FAIL — City `18 -> 5` ended at zoom `0`.
- **Single constant-rate MoveView driver:** REJECTED by runtime evidence.
- **Production Taxi ownership:** not closed until P0119 retest passes.
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
- `docs/memory/evidence/G5_P0117_TAXI_LANDING_OVERSHOOT_2026-10-03.md`
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
