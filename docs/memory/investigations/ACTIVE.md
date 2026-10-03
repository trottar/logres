# Active Investigations

## G.3 — Production World/Combat camera ownership

Status:
**ACTIVE — P0100 PUSHED; RUNTIME PROOF PENDING**

Canonical:
`G3_WORLD_COMBAT_CAMERA_OWNERSHIP.md`

G.2 runtime evidence:
`../evidence/G2_P0096_RUNTIME_PASS_2026-10-02.md`

P0100 production implementation:
- auto-enabled `CameraWorldCombat` controller;
- World -> conditional target 5;
- World (Combat) -> conditional target 15;
- ordinary transition 2.5 seconds;
- zoom restore never;
- live `UnitAffectingCombat("player")` selects combat;
- targeted combat/restriction event reevaluation prevents dependence on cached
  state publication;
- primary MoveView path only;
- no temporary-CVar fallback;
- explicit interruption/disable/ownership-loss stop;
- DynamicCam coexistence gate;
- historical G.2 probe mutually gated from production ownership;
- addon-owned developer diagnostics and non-mutating Run All check.

P0100 is durable at `31a2a7f`.

Required next evidence is production runtime validation on `0.0.41-dev`.

## Closed Phase G investigations

G.1 DynamicCam profile capture:
**CLOSED — PASS.**

G.2 World/Combat camera zoom capability:
**CLOSED — RUNTIME + INTEGRATION PASS.**

Canonical G.2 record:
`G2_WORLD_COMBAT_CAMERA_CAPABILITY.md`

## Other tracked non-blocking defects / deferred domains

- `D4_TARGETFRAME_REASSERTION_INTERMITTENT.md`
- `FUTURE_AURA_STATUS_PRESENTATION.md`
