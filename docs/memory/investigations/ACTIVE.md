# Active Investigations

## G.3 — Production World/Combat camera ownership

Status:
**ACTIVE — IMPLEMENTATION NEXT**

Canonical:
`G3_WORLD_COMBAT_CAMERA_OWNERSHIP.md`

G.2 runtime evidence:
`../evidence/G2_P0096_RUNTIME_PASS_2026-10-02.md`

Accepted production contract:
- World -> conditional target 5;
- World (Combat) -> conditional target 15;
- ordinary transition 2.5 seconds;
- zoom restore never;
- combat selection uses live `UnitAffectingCombat("player")`;
- lockdown remains a separate restriction signal;
- use the proven primary MoveView path;
- no temporary-CVar fallback;
- stop movement on interruption/disable/failure;
- DynamicCam and Logres must not move the camera simultaneously.

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
