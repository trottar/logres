# P0087 — Close F.5 / Open F.6

Date: 2026-10-02
Result: PREPARED — DOCS-ONLY CHECKPOINT

## Baseline

P0086 verified pushed:
`d4e8c39837210d38e73447f4800cc5448d1e956d`

## F.5 closing evidence

Quest `237` supplied the required same-quest update:

- previous Seer objective: `0/10`, done=false;
- later Seer objective: `1/10`, done=false;
- second later probe retained `1/10`.

This proves fresh same-quest recapture without stale prior-value retention.

Event evidence:
- `QUEST_LOG_UPDATE` proven;
- `QUEST_WATCH_UPDATE` observed once;
- `QUEST_PROGRESS`, `QUEST_COMPLETE`, and `QUEST_TURNED_IN` remain
  environmental deferrals.

F.5:
**CLOSED — RUNTIME PASS.**

## F.6 open

F.6:
**Contextual objective progress pulse.**

Contract:
- passive/event-driven;
- baseline-first;
- pulse only on meaningful same-quest objective count/finished changes;
- temporary text-only presentation;
- no permanent tracker;
- Immersion OFF suppression with safe baseline tracking;
- no stock Objective Tracker suppression;
- no watch/super-track mutation;
- fail open on missing/secret/invalid/uncached data.

Developer-panel implementation should include:
- Objective Progress Check;
- Objective Progress Preview;
- Run All integration.

## Runtime

Unchanged:
`0.0.33-dev`.

Docs-only patch.
No WoW redeploy required.

## Delivery repair

The first P0087 apply failed during temporary-tree memory validation because the
proposed `CURRENT.md` omitted the required Success Criteria heading.

No tracked P0087 target file was written.

The repair restores the required heading and adds exact artifact-level
validation for all seven canonical CURRENT headings before packaging.

Evidence:
`../evidence/P0087_DELIVERY_FAILURE_2026-10-02.md`.

