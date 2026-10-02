# Active Investigations

## F.6 — Contextual objective progress pulse

Status:
**ACTIVE — LIVE SOURCE PASS; PREVIEW REGRESSION; PRODUCTION PULSE UNPROVEN**

Canonical:
`F6_CONTEXTUAL_OBJECTIVE_PROGRESS.md`

P0088:
- runtime/integration PASS within tested scope;
- visual FAIL due action-cluster overlap.

P0089:
- durable runtime at `1781c038`;
- presentation moved off the lower action lane;
- Preview changed to explicit synthetic sample.

Latest runtime source evidence:
**PASS.**

Quest 237:
- Skullthumper `3/10 -> 4/10`;
- Seer remained `3/10`.

Relevant event evidence:
- QUEST_LOG_UPDATE `85 -> 86`;
- QUEST_WATCH_UPDATE `6 -> 7`.

Therefore:
**LIVE OBJECTIVE SOURCE IS FRESH.**

Production F.6 pulse for that change:
**UNPROVEN** because no post-change Objective Progress Check was captured before
reload.

Preview usability:
**FAIL / REGRESSION.**
The generic synthetic sample is visually clear but not useful for validating a
real active multi-objective quest.

P0090 correction:
- current live objective rows when safely available;
- synthetic fallback only when live rows are unavailable;
- no baseline mutation from Preview;
- no source/event/baseline/polling changes.

Do not modify production event logic without evidence of a production pulse
failure.

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
