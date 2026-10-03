# Active Investigations

## G.2 — World/Combat camera zoom capability

Status:
**ACTIVE — SOURCE REVIEW PASS; FOREVER RUNTIME PROBE PENDING**

Canonical:
`G2_WORLD_COMBAT_CAMERA_CAPABILITY.md`

Source evidence:
`../evidence/G2_DYNAMICCAM_ZOOM_SOURCE_AUDIT_2026-10-02.md`

Correct profile semantics:
- World -> conditional target 5 when farther than 5;
- World (Combat) -> conditional target 15 when closer than 15;
- ordinary transition 2.5 seconds;
- zoom restore never.

P0094's previous `by 5/by 15` wording is closed as incorrect.

P0095 adds a manual reversible primary-path probe.
No automatic camera ownership yet.

Required runtime evidence:
- one out-of-combat PASS;
- one in-combat PASS;
- restoration PASS;
- DynamicCam disabled during both runs.

## Closed Phase G investigations

G.1 DynamicCam profile capture:
**CLOSED — PASS.**

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
