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

P0091 is verified pushed at `a2c5e863`.

Current pushed runtime:
`0.0.37-dev`.

P0092 runtime target:
`0.0.38-dev`.

F.6 status:
**LIVE SOURCE PASS; LIVE PREVIEW PASS; PRODUCTION IDENTITY DEFECT PROVEN;
PULSE FIX RETEST PENDING.**

## Verified State

- Phase E is complete.
- F.1 and F.2 are complete.
- F.3 contextual XP is complete: runtime + integration + visual PASS.
- F.4 additive NPC quest detail presentation is complete: runtime + integration + visual PASS.
- F.5 objective/progress capability proof is complete: runtime PASS.
- P0089 live objective-source freshness is PASS.
- P0090 current-objective Preview path and Immersion Preview policy are PASS.
- P0091 is durable at `a2c5e863`, runtime `0.0.37-dev`.
- P0091 runtime diagnostics prove:
  - Objective Progress Check PASS;
  - current-objective Preview returned `shown-current`;
  - Immersion OFF returned `suppressed-immersion-off`;
  - Immersion ON returned `shown-current`;
  - two consecutive Run All executions passed;
  - quest `237` remained a usable two-row objective source;
  - no fixed secret/error result occurred.
- The final P0091 Quest Probe captured quest 237 at:
  - Skullthumper `5/10`;
  - Seer `4/10`;
  - QUEST_LOG_UPDATE count `94`;
  - QUEST_WATCH_UPDATE count `9`.
- The P0091 diagnostic did not capture a post-change Objective Progress Check,
  so the runtime counters alone do not prove an automatic pulse.
- Current source and runtime evidence together prove a narrower defect:
  Forever count-based `objective.text` changes with the count prefix, while
  `FindChangedRows()` still requires raw `previous.text == current.text`.
- Therefore count-based same-objective transitions such as
  `4/10 Stonesplinter ... -> 5/10 Stonesplinter ...` cannot reach the
  count-change branch.
- P0092 gives objective comparison a stable count-prefix-free identity while
  preserving index matching, source/event ownership, baseline behavior, timers,
  Immersion policy, and no-polling policy.
- P0091 single-count visual acceptance remains unrecorded in durable evidence;
  P0092 retest must confirm it together with the real automatic pulse.
- Stock Objective Tracker remains Blizzard-owned.
- Quest compass marker remains unsupported.

## Next Action

Apply and push P0092.

After verified push:
- deploy `0.0.38-dev`;
- `/reload`;
- run Objective Progress Check once to confirm quest 237 is baselined;
- run Objective Progress Preview and confirm each count appears exactly once;
- make one natural same-quest objective change;
- observe exactly one automatic production pulse;
- immediately run Objective Progress Check before any reload;
- immediately run Quest Probe;
- do not make another objective change for several seconds and confirm no
  duplicate automatic pulse;
- run Run All once;
- `/reload`;
- export `LOGRES_DIAGNOSTICS_LATEST.lua`.

Do not repeat the P0091 broken-identity test.

## Success Criteria

F.6 closes only after:
- static contract PASS;
- live source freshness PASS;
- live current-objective Preview PASS;
- each objective count renders exactly once;
- stable count-prefix-free same-objective identity works;
- corrected placement visual PASS;
- one real same-quest objective change produces exactly one automatic pulse;
- Objective Progress Check records the corresponding change/pulse;
- Quest Probe confirms the corresponding live objective update;
- no duplicate pulse on unchanged refresh;
- previously proven Immersion policy remains intact;
- stock Objective Tracker remains Blizzard-owned and usable;
- no Lua, taint, protected-action, or secret-value errors.

## Do Not Reopen Without New Evidence

- **Phase E:** complete.
- **F.1/F.2:** complete.
- **F.3 contextual XP:** complete.
- **F.4 additive NPC quest detail presentation:** complete.
- **F.5 objective/progress capability proof:** complete.
- **F.6 live objective-source freshness:** PASS.
- **F.6 current-objective Preview path:** PASS.
- **P0084 TargetFrame restoration correction:** runtime PASS.
- **TargetFrame reappearance issue:** separate tracked defect.
- **Quest destination / compass marker:** unsupported until a real destination is runtime-proven.
- **Quest interaction controls:** Blizzard-owned.
- **Stock Objective Tracker:** remains Blizzard-owned.
- **Git authority:** user performs commits/pushes.

## Relevant References

- `docs/memory/investigations/F6_CONTEXTUAL_OBJECTIVE_PROGRESS.md`
- `docs/memory/evidence/F6_P0090_LIVE_PREVIEW_DUPLICATE_COUNT_FAIL_2026-10-02.md`
- `docs/memory/evidence/F6_P0091_STABLE_IDENTITY_DEFECT_2026-10-02.md`
- `docs/memory/decisions/D-031_QUEST_EXPERIENCE_CAPABILITY_CONTRACT.md`
- `docs/memory/patches/P0091_FIX_OBJECTIVE_PROGRESS_LABELS.md`
- `docs/memory/patches/P0092_FIX_OBJECTIVE_PROGRESS_IDENTITY.md`
- `docs/memory/roadmap/PHASE_F_QUEST_EXPERIENCE.md`
