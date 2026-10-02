# Active Investigations

## F.6 — Contextual objective progress pulse

Status:
**ACTIVE — IMPLEMENTED; RUNTIME + VISUAL PROOF PENDING**

Canonical:
`F6_CONTEXTUAL_OBJECTIVE_PROGRESS.md`

P0088 implements:
- passive super-tracked/selected quest identity;
- passive objective recapture;
- baseline-first/no-false-pulse policy;
- meaningful same-quest count/finished change detection;
- temporary bounded text presentation;
- Immersion OFF suppression;
- developer-panel Check/Preview;
- Run All integration.

Refresh events:
- `QUEST_LOG_UPDATE`;
- `QUEST_WATCH_UPDATE`;
- `SUPER_TRACKING_CHANGED` rebaseline only;
- `PLAYER_ENTERING_WORLD` rebaseline only.

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

## Other tracked non-blocking defects / deferred domains

- `D4_TARGETFRAME_REASSERTION_INTERMITTENT.md`
- `FUTURE_AURA_STATUS_PRESENTATION.md`

## Deferred quest/navigation evidence

- quest IDs `436`, `237`, and `1338` have produced no usable next waypoint;
- quest compass marker remains unsupported.
