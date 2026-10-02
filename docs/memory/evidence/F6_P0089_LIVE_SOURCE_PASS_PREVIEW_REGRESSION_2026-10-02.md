# F.6 P0089 Live Source PASS / Preview Regression — 2026-10-02

Status: LIVE SOURCE PASS; PREVIEW REGRESSION; PRODUCTION PULSE UNPROVEN
Date: 2026-10-02
P0089 runtime commit: `1781c038637cef750061e20635e4c1310dcecc96`
Runtime: `0.0.35-dev`

## Runtime identity

Forever:
- client `1.60.1`;
- build `70170`;
- interface `16001`.

Latest capture reached Logres load count `81`.

## Baseline objective state

Quest Probe captured quest `237`:
**In Defense of the King's Lands**

Objectives:
1. Stonesplinter Skullthumper slain — `3/10`;
2. Stonesplinter Seer slain — `3/10`.

At that point:
- QUEST_LOG_UPDATE count: `85`;
- QUEST_WATCH_UPDATE count: `6`.

## Natural same-quest update

A later Quest Probe, still on quest `237`, captured:
1. Stonesplinter Skullthumper slain — `4/10`;
2. Stonesplinter Seer slain — `3/10`.

Relevant event counters became:
- QUEST_LOG_UPDATE: `86`;
- QUEST_WATCH_UPDATE: `7`.

Therefore:
- same-quest live objective source refresh: **PASS**;
- QUEST_LOG_UPDATE refresh evidence: **PASS**;
- QUEST_WATCH_UPDATE refresh evidence: **PASS**;
- prior possible stale-source concern: **CLOSED**.

## Production pulse status

The session did not record Objective Progress Check after the `3/10 -> 4/10`
natural change and before the final reload.

Therefore the exported diagnostic does not establish whether
`meaningfulChangeCount` or `pulseCount` advanced for that update.

Classification:
**PRODUCTION PULSE UNPROVEN.**

Do not change production event logic from this result alone.

## Preview regression

P0089 source intentionally changed Objective Progress Preview to:

`PREVIEW · Objective progress · 3/10`.

User feedback:
the generic Preview is less useful because the active quest has multiple real
objectives and one had just changed.

The older quest-looking Preview was also hardcoded, so reverting to that sample
would recreate misleading fake-live behavior.

Classification:
**PREVIEW USABILITY REGRESSION — CONFIRMED.**

## P0090 correction

Preview should:
- passively read the current active quest;
- passively read current objective rows;
- format up to two live rows using the same presentation formatter as
  production;
- never mutate the production baseline;
- fall back to the explicit synthetic sample only when current data is
  unavailable.

No production event/source/baseline change is authorized by this evidence.
