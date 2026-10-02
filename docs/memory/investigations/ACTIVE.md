# Active Investigations

## F.3 — Contextual XP pulse

Status:
**ACTIVE — XP RUNTIME PROVEN; BLOCKED BY TARGETFRAME RESTORATION FAILURE**

Canonical:
`F3_CONTEXTUAL_XP_PULSE.md`

P0080 XP runtime:
- XP Check PASS;
- real positive XP delta PASS;
- production pulse PASS;
- Immersion policy PASS.

Visual acceptance remains pending.

## P0080 TargetFrame restoration failure

Status:
**OPEN — REPRODUCED / TARGETFRAME RESTORE PATH IDENTIFIED**

Canonical:
`P0080_TARGETFRAME_RESTORE_FAILURE.md`

The failure reproduced during P0080 Run All.

P0079 detail proves TargetFrame remained applied/suppressed after an OFF request
while Action/Quiet/Player had restored.

P0081 exposes the existing TargetFrame/controller error text before any
behavioral fix.

## Other tracked non-blocking defects / deferred domains

- `D4_TARGETFRAME_REASSERTION_INTERMITTENT.md`
- `FUTURE_AURA_STATUS_PRESENTATION.md`

Do not merge the restore failure with TargetFrame reappearance without evidence.

## Deferred quest/navigation evidence

- populated active-objective rows remain unproven;
- quest IDs `436` and `237` have produced no usable next waypoint;
- quest compass marker remains unsupported.
