# Current Handoff

Authoritative state: `../CURRENT.md`.

P0091 is verified pushed at `a2c5e863`.

Current pushed runtime:
`0.0.37-dev`.

P0092 runtime target:
`0.0.38-dev`.

Active work:
**F.6 — Contextual objective progress pulse.**

P0091 runtime integration:
- Objective Progress Check PASS;
- current-objective Preview `shown-current`;
- Immersion OFF suppression PASS;
- Immersion ON restoration PASS;
- two Run All executions PASS;
- quest 237 rows available;
- no fixed secret/error result.

Latest Quest Probe:
- Skullthumper `5/10`;
- Seer `4/10`;
- QUEST_LOG_UPDATE `94`;
- QUEST_WATCH_UPDATE `9`.

Production pulse counters were not captured after that natural progress.

However the production failure is now source-proven:
- Forever count-based `objective.text` includes the count prefix;
- the prefix changes when progress changes;
- P0091 `FindChangedRows()` still requires raw
  `previous.text == current.text`;
- therefore count increments cannot enter the count-change branch.

P0092:
- derives a stable objective identity by stripping only the exact current
  count prefix from each safe row;
- compares stable identity at the same objective index;
- keeps P0091 display normalization;
- no event/source/baseline/polling change.

Next proof:
baseline -> single-count Preview -> one natural objective change ->
automatic pulse -> Objective Progress Check -> Quest Probe -> no duplicate.

User performs all commits/pushes.
