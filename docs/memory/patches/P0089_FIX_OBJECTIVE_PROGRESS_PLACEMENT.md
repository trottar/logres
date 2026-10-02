# P0089 — Fix Objective Progress Placement

Date: 2026-10-02
Result: INSTALLED / PUSHED — LIVE SOURCE PASS; PREVIEW REGRESSION (`1781c038`)

## Baseline

P0088 verified pushed:
`228b4676479d211ed61bd0a11c3fea9a8d2f3f52`.

## Runtime

`0.0.34-dev -> 0.0.35-dev`.

## Trigger

P0088 runtime/integration checks passed, but visual inspection showed the F.6
objective-progress text overlapping the lower-center Logres action cluster.

## Presentation correction

Presentation:
- width `520`;
- height `32`;
- bottom of pulse anchored to top of addon-owned `LogresHUDTarget`;
- 6px gap;
- UI-center `y=-5` fallback.

Preview was changed to the explicitly synthetic:
`PREVIEW · Objective progress · 3/10`.

Production contract remained unchanged:
- active quest identity selection;
- objective source;
- secret handling;
- baseline-first behavior;
- same-quest comparison;
- refresh events;
- 3-second lifetime;
- Immersion policy;
- stock Objective Tracker ownership.

No polling, ticker, delayed reread, broad hook, or watch/super-track mutation.

## Delivery history

Two P0089 artifacts were rejected by temporary-tree validation before tracked
mutation:
1. invalid generated Python in a checker;
2. checker false negative caused by demanding single-line SetPoint formatting.

Those failures are preserved in:
`../evidence/P0089_DELIVERY_FAILURE_2026-10-02.md`.

The durable pushed runtime correction at `1781c038` did **not** replace
`tools/check_objective_progress_contract.py`; earlier memory text claiming that
the pushed checker used multiline-anchor structural regex was inaccurate and is
superseded by this record.

## Runtime result

Live objective source:
**PASS.**

Quest 237 advanced naturally:
- Skullthumper `3/10 -> 4/10`;
- Seer remained `3/10`.

Relevant event counters:
- QUEST_LOG_UPDATE `85 -> 86`;
- QUEST_WATCH_UPDATE `6 -> 7`.

Production automatic pulse:
**UNPROVEN** for that exact update because no post-change Objective Progress
Check was captured before reload.

Preview:
**USABILITY REGRESSION CONFIRMED.**

The explicit generic sample avoids pretending to be live, but is not useful
when validating a real active multi-objective quest.

P0090 corrects Preview to show current live objective rows when safely
available, while leaving production logic unchanged.

Evidence:
`../evidence/F6_P0089_LIVE_SOURCE_PASS_PREVIEW_REGRESSION_2026-10-02.md`.
