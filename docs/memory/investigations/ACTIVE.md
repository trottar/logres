# Active Investigations

## G.2 — World/Combat camera zoom capability

Status:
**ACTIVE — PRIMARY PATH OOC PASS; COMBAT CLASSIFICATION FIX PENDING RETEST**

Canonical:
`G2_WORLD_COMBAT_CAMERA_CAPABILITY.md`

Source evidence:
`../evidence/G2_DYNAMICCAM_ZOOM_SOURCE_AUDIT_2026-10-02.md`

P0095 runtime evidence:
`../evidence/G2_P0095_COMBAT_CLASSIFICATION_FAIL_2026-10-02.md`

Source semantics:
- World -> conditional target 5;
- World (Combat) -> conditional target 15;
- ordinary transition 2.5 seconds;
- zoom restore never.

P0095:
- primary camera movement PASS twice;
- restoration PASS twice;
- both diagnostic runs classified `combat=false`.

Cause:
P0095 classified combat from cached `State.combat`; DynamicCam situation 006
uses live `UnitAffectingCombat("player")`.

P0096 corrects the diagnostic classifier only and records live lockdown plus
cached combat separately.

Required next evidence:
- one probe with live `combat=true`;
- movement/target/restoration PASS;
- no camera/security error.

## Closed Phase G investigations

G.1 DynamicCam profile capture:
**CLOSED — PASS.**

## Other tracked non-blocking defects / deferred domains

- `D4_TARGETFRAME_REASSERTION_INTERMITTENT.md`
- `FUTURE_AURA_STATUS_PRESENTATION.md`
