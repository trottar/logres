# Current Handoff

Authoritative state: `../CURRENT.md`.

P0090 is verified pushed at `afcc37c`.

Current pushed runtime: `0.0.36-dev`.
P0091 runtime target: `0.0.37-dev`.

Active work: **F.6 — Contextual objective progress pulse.**

P0090 runtime:
- current-objective Preview path PASS (`shown-current`);
- Immersion suppression/restoration PASS;
- two Run All executions PASS;
- no fixed secret/error result in Objective Progress Check.

Visual defect: **CONFIRMED — DUPLICATE COUNT PRESENTATION.**

Observed:
- `4/10 Stonesplinter Skullthumper slain  ·  4/10`;
- `3/10 Stonesplinter Seer slain  ·  3/10`.

Cause: Forever objective text already carries the leading count and shared `FormatRow()` appends it again.

P0091 normalizes the presentation label only. Production source/events/baseline/change detection remain unchanged.

Production pulse: **STILL UNPROVEN** on P0090.

Next proof: single-count Preview -> natural objective change -> automatic pulse -> Objective Progress Check -> Quest Probe.

User performs all commits/pushes.
