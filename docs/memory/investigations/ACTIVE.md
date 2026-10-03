# Active Investigations

## G.2 — World/Combat camera zoom capability

Status:
**ACTIVE — SOURCE REVIEW / RUNTIME PROOF PENDING**

Canonical:
`G2_WORLD_COMBAT_CAMERA_CAPABILITY.md`

Profile evidence:
`../evidence/G1_DYNAMICCAM_PROFILE_CAPTURE_2026-10-02.md`

Target:
- World: zoom in by 5, enter 2.5, exit 0;
- World (Combat): zoom out by 15, enter 2.5, exit 0.

G.2 must prove the exact current DynamicCam zoom API/CVar path and establish
safe transition interruption/restoration on Forever.

Do not add production camera behavior before that proof.

## Closed Phase G investigations

G.1 DynamicCam profile capture:
**CLOSED — PASS.**

Current `RPG` profile is preserved durably.

## Closed Phase F

F.3 contextual XP:
**CLOSED — RUNTIME + INTEGRATION + VISUAL PASS.**

F.4 additive NPC quest detail presentation:
**CLOSED — RUNTIME + INTEGRATION + VISUAL PASS.**

F.5 objective/progress capability proof:
**CLOSED — RUNTIME PASS.**

F.6 contextual objective progress pulse:
**CLOSED — RUNTIME + VISUAL PASS.**

## Other tracked non-blocking defects / deferred domains

- `D4_TARGETFRAME_REASSERTION_INTERMITTENT.md`
- `FUTURE_AURA_STATUS_PRESENTATION.md`

## Deferred quest/navigation evidence

- quest IDs `436`, `237`, and `1338` have produced no usable next waypoint;
- quest compass marker remains unsupported.
