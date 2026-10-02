# Active Investigations

## F.5 — Objective / progress runtime capability proof

Status:
**ACTIVE — DATA SHAPE PASS; SAME-QUEST TRANSITION PENDING**

Canonical:
`F5_OBJECTIVE_PROGRESS_CAPABILITY_PROOF.md`

Runtime-proven objective states:
- nil / unavailable with no active quest;
- empty table on quest `436`;
- populated incomplete rows on quest `237`;
- populated completed row on quest `1338`.

Remaining narrow gap:
- a same-quest objective value transition and fresh recapture.

Naturally unobserved events remain:
- `QUEST_PROGRESS`;
- `QUEST_COMPLETE`;
- `QUEST_TURNED_IN`;
- `QUEST_WATCH_UPDATE`.

Use the existing panel Quest Probe during normal gameplay.
Do not add production objective presentation before transition evidence.

## Closed Phase F slices

F.3 contextual XP:
**CLOSED — RUNTIME + INTEGRATION + VISUAL PASS.**

F.4 additive NPC quest detail presentation:
**CLOSED — RUNTIME + INTEGRATION + VISUAL PASS.**

## Closed TargetFrame restoration investigation

`P0080_TARGETFRAME_RESTORE_FAILURE.md`:
**CLOSED — P0084 RUNTIME PASS.**

The separate TargetFrame visual reappearance investigation remains open and is
not merged with the restoration defect.

## Other tracked non-blocking defects / deferred domains

- `D4_TARGETFRAME_REASSERTION_INTERMITTENT.md`
- `FUTURE_AURA_STATUS_PRESENTATION.md`

## Deferred quest/navigation evidence

- quest IDs `436`, `237`, and `1338` have produced no usable next waypoint;
- quest compass marker remains unsupported.
