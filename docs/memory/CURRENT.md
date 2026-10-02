---
memory_schema: 1
as_of: 2026-10-02
project: logres
---

# Current State

## Active Objective

**Phase F — Quest Experience.**

## Current Work Item

**F.6 — Contextual objective progress pulse.**

P0090 is verified pushed at `afcc37c`.

Current pushed runtime:
`0.0.36-dev`.

P0091 runtime target:
`0.0.37-dev`.

F.6 status:
**LIVE SOURCE PASS; LIVE PREVIEW PASS; PRESENTATION LABEL DUPLICATION FAIL; PRODUCTION PULSE STILL UNPROVEN.**

## Verified State

- Phase E is complete.
- F.1 and F.2 are complete.
- F.3 contextual XP is complete: runtime + integration + visual PASS.
- F.4 additive NPC quest detail presentation is complete: runtime + integration + visual PASS.
- F.5 objective/progress capability proof is complete: runtime PASS.
- P0089 is durable at `1781c038`.
- P0090 is durable at `afcc37c`.
- P0090 runtime `0.0.36-dev` proved:
  - Objective Progress Preview returned `shown-current`;
  - Immersion OFF suppressed Preview;
  - Immersion ON restored current-objective Preview;
  - two consecutive Run All executions passed;
  - Objective Progress Check reported no fixed error or secret-value issue.
- User screenshot exposed a presentation defect:
  - `4/10 Stonesplinter Skullthumper slain  ·  4/10`;
  - `3/10 Stonesplinter Seer slain  ·  3/10`.
- Root cause is source-proven: Forever `objective.text` already contains the leading count token while `Progress:FormatRow()` appends the same `fulfilled/required` count again.
- Preview and production change pulses share `FormatRow()`, so the duplication affects both presentation paths.
- P0091 strips only an exact matching leading current count token followed by whitespace before appending the canonical Logres count once.
- P0091 does not change quest identity, objective source, event handling, baseline/change detection, timers, Immersion policy, polling policy, or Blizzard ownership.
- Production same-quest pulse remains unproven because P0090 validation did not include a natural objective change after the new runtime loaded.
- Stock Objective Tracker remains Blizzard-owned.
- Quest compass marker remains unsupported.

## Next Action

Apply and push P0091.

After verified push:
- deploy `0.0.37-dev`;
- `/reload`;
- super-track quest 237 or another count-based active quest;
- Objective Progress Preview should show each count exactly once;
- confirm placement remains clear of the action cluster;
- continue one natural objective change;
- observe exactly one automatic production pulse;
- immediately run Objective Progress Check before `/reload`;
- run Quest Probe to confirm the same updated live count;
- confirm no duplicate pulse without another objective change;
- `/reload`;
- export `LOGRES_DIAGNOSTICS_LATEST.lua`.

## Success Criteria

F.6 closes only after:
- static contract PASS;
- live source freshness PASS;
- live current-objective Preview PASS;
- objective count renders exactly once;
- corrected placement visual PASS;
- at least one real same-quest production pulse;
- Objective Progress Check records the corresponding change/pulse;
- Quest Probe confirms the corresponding live objective update;
- no duplicate pulse on unchanged recapture;
- Immersion policy works;
- stock Objective Tracker remains Blizzard-owned and usable;
- no Lua, taint, protected-action, or secret-value errors;
- user visual acceptance confirms the pulse is concise, temporary, readable, and not a permanent tracker.

## Do Not Reopen Without New Evidence

- **Phase E:** complete.
- **F.1/F.2:** complete.
- **F.3 contextual XP:** complete.
- **F.4 additive NPC quest detail presentation:** complete.
- **F.5 objective/progress capability proof:** complete.
- **F.6 live objective-source freshness:** PASS.
- **F.6 P0090 current-objective Preview path:** PASS.
- **P0084 TargetFrame restoration correction:** runtime PASS.
- **TargetFrame reappearance issue:** separate tracked defect.
- **Quest destination / compass marker:** unsupported until a real destination is runtime-proven.
- **Quest interaction controls:** Blizzard-owned.
- **Stock Objective Tracker:** remains Blizzard-owned.
- **Git authority:** user performs commits/pushes.

## Relevant References

- `docs/memory/investigations/F6_CONTEXTUAL_OBJECTIVE_PROGRESS.md`
- `docs/memory/evidence/F6_P0090_LIVE_PREVIEW_DUPLICATE_COUNT_FAIL_2026-10-02.md`
- `docs/memory/decisions/D-031_QUEST_EXPERIENCE_CAPABILITY_CONTRACT.md`
- `docs/memory/patches/P0090_LIVE_OBJECTIVE_PREVIEW.md`
- `docs/memory/patches/P0091_FIX_OBJECTIVE_PROGRESS_LABELS.md`
- `docs/memory/roadmap/PHASE_F_QUEST_EXPERIENCE.md`
