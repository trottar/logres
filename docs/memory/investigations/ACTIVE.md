# Active Investigations

## F.6 — Contextual objective progress pulse

Status:
**ACTIVE — CONTRACT ACCEPTED; IMPLEMENTATION NEXT**

Canonical:
`F6_CONTEXTUAL_OBJECTIVE_PROGRESS.md`

F.5 runtime evidence now proves enough passive objective behavior for a narrow
production pulse.

Use:
- `QUEST_LOG_UPDATE` as primary proven refresh;
- `QUEST_WATCH_UPDATE` as additional proven refresh;
- `SUPER_TRACKING_CHANGED` for identity/baseline changes.

Do not require:
- `QUEST_PROGRESS`;
- `QUEST_COMPLETE`;
- `QUEST_TURNED_IN`.

Stock Objective Tracker remains Blizzard-owned.

## Closed Phase F slices

F.3 contextual XP:
**CLOSED — RUNTIME + INTEGRATION + VISUAL PASS.**

F.4 additive NPC quest detail presentation:
**CLOSED — RUNTIME + INTEGRATION + VISUAL PASS.**

F.5 objective/progress capability proof:
**CLOSED — RUNTIME PASS.**

Evidence:
`../evidence/F5_SAME_QUEST_TRANSITION_PASS_2026-10-02.md`

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
