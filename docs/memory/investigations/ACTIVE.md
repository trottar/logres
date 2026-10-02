# Active Investigations

## F.6 — Contextual objective progress pulse

Status: **ACTIVE — LIVE SOURCE PASS; LIVE PREVIEW PASS; LABEL DUPLICATION FAIL; PRODUCTION PULSE UNPROVEN**

Canonical: `F6_CONTEXTUAL_OBJECTIVE_PROGRESS.md`

P0089 live source freshness: **PASS**.

P0090:
- durable at `afcc37c`;
- current-objective Preview PASS;
- Immersion Preview policy PASS;
- two Run All executions PASS;
- duplicate-count presentation FAIL.

Observed:
- `4/10 Stonesplinter Skullthumper slain  ·  4/10`;
- `3/10 Stonesplinter Seer slain  ·  3/10`.

Cause: `objective.text` already includes the current count prefix and shared `FormatRow()` appends the same count again.

P0091 strips an exact matching leading count token before appending the canonical Logres count. No source/event/baseline/polling changes.

Production F.6 pulse: **UNPROVEN** on the current runtime.

Do not modify production event logic without evidence of a production pulse failure.

Stock Objective Tracker remains Blizzard-owned.

## Closed Phase F slices

F.3 contextual XP: **CLOSED — RUNTIME + INTEGRATION + VISUAL PASS.**
F.4 additive NPC quest detail presentation: **CLOSED — RUNTIME + INTEGRATION + VISUAL PASS.**
F.5 objective/progress capability proof: **CLOSED — RUNTIME PASS.**

## Other tracked non-blocking defects / deferred domains

- `D4_TARGETFRAME_REASSERTION_INTERMITTENT.md`
- `FUTURE_AURA_STATUS_PRESENTATION.md`

## Deferred quest/navigation evidence

- quest IDs `436`, `237`, and `1338` have produced no usable next waypoint;
- quest compass marker remains unsupported.
