# Active Investigations

## F.3 — Contextual XP pulse

Status:
**ACTIVE — RUNTIME + INTEGRATION PASS; VISUAL ACCEPTANCE PENDING**

Canonical:
`F3_CONTEXTUAL_XP_PULSE.md`

P0080 runtime-proven:
- XP Check PASS;
- real positive XP delta PASS;
- production pulse PASS;
- Immersion policy PASS;
- auto-hide PASS.

P0081 integrated validation:
- five Run All PASS;
- one standalone Restoration Check PASS.

Visual acceptance remains the only F.3 exit item.

## P0080 TargetFrame restoration failure

Status:
**OPEN — INTERMITTENT / UNREPRODUCED UNDER P0081 TARGETED RUNS**

Canonical:
`P0080_TARGETFRAME_RESTORE_FAILURE.md`

Historical reproduced failures:
- P0078;
- P0080.

P0081:
- diagnostic-only change;
- five Run All PASS;
- one standalone Restoration Check PASS;
- no recurrence;
- no error string captured.

Do not add retries, polling, periodic reassertion, broad hooks, or other
behavior workarounds without a reproducible failing operation.

## Other tracked non-blocking defects / deferred domains

- `D4_TARGETFRAME_REASSERTION_INTERMITTENT.md`
- `FUTURE_AURA_STATUS_PRESENTATION.md`

Do not merge the restoration failure with TargetFrame reappearance without
evidence.

## Deferred quest/navigation evidence

- populated active-objective rows remain unproven;
- quest IDs `436` and `237` have produced no usable next waypoint;
- quest compass marker remains unsupported.
