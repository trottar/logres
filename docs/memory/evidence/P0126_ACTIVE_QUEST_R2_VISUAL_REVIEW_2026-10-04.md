# P0126 Active Quest R2 Visual Review — 2026-10-04

Status: **BAR-ONLY PROGRESS APPROVED; OBJECTIVE LABEL FOLLOW-UP REQUESTED**
Runtime candidate: `0.0.57-dev`
Baseline Git HEAD: P0125 `72d2f040`

## Visual result

The bar-only objective treatment is an improvement over the prior persistent
percentage labels.

The user approved removing the visible `%` text and requested one additional
clarity refinement: the persistent row should say what the objective actually is,
for example the equivalent of `Kill X` / `Recover Y`, while still avoiding
persistent exact mechanical counts.

## Existing source support

No new quest API or capability probe is required.

`QuestObjectiveProgress` already owns:
- guarded `objective.text`;
- `StableObjectiveText(row)`, which removes an already-proven leading `N/M`
  prefix when Blizzard includes it;
- `NormalizeObjectiveLabel(row)`, which produces a restrained stable label.

Exact objective wording and exact `fulfilled / required` values remain available
on deliberate hover.

## R3 decision

P0126 R3 should present, for each objective:
1. a count-free objective label from `NormalizeObjectiveLabel(row)`;
2. the existing bar-only progress visualization directly below it;
3. exact wording/counts only on hover.

No invented quest instruction text, no parsing beyond the existing stable
objective-label normalization, and no quest-control/navigation ownership are
introduced.
