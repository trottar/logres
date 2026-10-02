# Active Investigations

## F.6 — Contextual objective progress pulse

Status:
**ACTIVE — LIVE SOURCE PASS; LIVE PREVIEW PASS; PRODUCTION IDENTITY DEFECT
PROVEN; PULSE FIX RETEST PENDING**

Canonical:
`F6_CONTEXTUAL_OBJECTIVE_PROGRESS.md`

P0089 live source freshness:
**PASS.**

P0090 current-objective Preview:
**PASS.**

P0091:
- durable at `a2c5e863`;
- runtime `0.0.37-dev`;
- Preview path PASS;
- Immersion Preview policy PASS;
- two Run All executions PASS;
- latest quest 237 probe captured `5/10` Skullthumper and `4/10` Seer.

Production detection defect:
**PROVEN.**

Forever count-based objective text changes with the leading count token.
Current `FindChangedRows()` requires raw text equality before it checks
`fulfilled` / `required`, so a real count transition changes the identity gate
and prevents the change branch from running.

P0092:
- stable count-prefix-free objective identity;
- same-index comparison retained;
- no source/event/baseline/timer/polling changes.

Do not add polling/retry/reassertion.

Stock Objective Tracker remains Blizzard-owned.

## Closed Phase F slices

F.3 contextual XP:
**CLOSED — RUNTIME + INTEGRATION + VISUAL PASS.**

F.4 additive NPC quest detail presentation:
**CLOSED — RUNTIME + INTEGRATION + VISUAL PASS.**

F.5 objective/progress capability proof:
**CLOSED — RUNTIME PASS.**

## Other tracked non-blocking defects / deferred domains

- `D4_TARGETFRAME_REASSERTION_INTERMITTENT.md`
- `FUTURE_AURA_STATUS_PRESENTATION.md`

## Deferred quest/navigation evidence

- quest IDs `436`, `237`, and `1338` have produced no usable next waypoint;
- quest compass marker remains unsupported.
