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

P0089 runtime implementation is verified pushed at `1781c038`.

Current pushed runtime:
`0.0.35-dev`.

P0090 runtime target:
`0.0.36-dev`.

F.6 status:
**LIVE SOURCE PASS; PREVIEW REGRESSION CONFIRMED; PRODUCTION PULSE STILL UNPROVEN.**

## Verified State

- Phase E is complete.
- F.1 and F.2 are complete.
- F.3 contextual XP is complete:
  runtime + integration + visual PASS.
- F.4 additive NPC quest detail presentation is complete:
  runtime + integration + visual PASS.
- F.5 objective/progress capability proof is complete:
  runtime PASS.
- P0088 is durable at `228b467`.
- P0089 presentation/runtime code is durable at `1781c038`.
- P0089 runtime target is `0.0.35-dev`.
- P0089 retains the passive F.6 production contract:
  - super-tracked quest identity with selected fallback;
  - passive `C_QuestLog.GetQuestObjectives`;
  - `QUEST_LOG_UPDATE`;
  - `QUEST_WATCH_UPDATE`;
  - identity/world rebaseline;
  - no polling;
  - no stock Objective Tracker mutation.
- P0089 corrected the prior action-cluster placement:
  `520x32`, 6px above addon-owned `LogresHUDTarget`, with center fallback.
- P0089 also changed Objective Progress Preview to an explicitly synthetic
  string:
  `PREVIEW · Objective progress · 3/10`.
- User runtime evidence on `0.0.35-dev` proves the live quest source refreshed:
  - quest 237 began at Skullthumper `3/10`, Seer `3/10`;
  - later Skullthumper advanced to `4/10` while Seer remained `3/10`;
  - `QUEST_LOG_UPDATE` advanced `85 -> 86`;
  - `QUEST_WATCH_UPDATE` advanced `6 -> 7`.
- Therefore the earlier possible stale-source concern is closed:
  **LIVE SOURCE FRESHNESS PASS.**
- The same capture does not prove whether the production F.6 pulse fired for the
  `3/10 -> 4/10` change because no Objective Progress Check was recorded after
  that natural change and before the final reload.
- User feedback confirms the synthetic Preview is less useful than the earlier
  quest-looking sample:
  **PREVIEW USABILITY REGRESSION — CONFIRMED.**
- The old sample was also synthetic, so it must not be restored as fake live
  data.
- P0090 fixes only Preview semantics:
  use current live objective rows when safely available; use the explicit
  synthetic sample only as a fallback.
- P0090 does not change production change detection, event ownership, baseline
  logic, polling behavior, or Blizzard ownership.
- Stock Objective Tracker remains Blizzard-owned.
- Quest compass marker remains unsupported.

## Next Action

Apply and push P0090.

After verified push:
- deploy `0.0.36-dev`;
- `/reload`;
- super-track quest 237 or another active multi-objective quest naturally;
- Objective Progress Preview should show the actual current objective rows,
  not the generic sample;
- if no usable active quest exists, Preview may show the explicit synthetic
  fallback;
- continue one natural objective change;
- observe the automatic production pulse;
- immediately run Objective Progress Check before `/reload`;
- run Quest Probe to confirm the corresponding live objective count;
- confirm no duplicate pulse without another objective change;
- `/reload`;
- export `LOGRES_DIAGNOSTICS_LATEST.lua`.

## Success Criteria

F.6 closes only after:
- static contract PASS;
- live source freshness PASS;
- current-objective Preview behavior PASS;
- corrected placement visual PASS;
- at least one real same-quest production pulse;
- Objective Progress Check records the corresponding change/pulse;
- Quest Probe confirms the corresponding live objective update;
- no duplicate pulse on unchanged recapture;
- Immersion policy works;
- stock Objective Tracker remains Blizzard-owned and usable;
- no Lua, taint, protected-action, or secret-value errors;
- user visual acceptance confirms the pulse is concise, temporary, readable,
  and not a permanent tracker.

## Do Not Reopen Without New Evidence

- **Phase E:** complete.
- **F.1/F.2:** complete.
- **F.3 contextual XP:** complete.
- **F.4 additive NPC quest detail presentation:** complete.
- **F.5 objective/progress capability proof:** complete.
- **F.6 live objective-source freshness:** PASS on P0089 runtime.
- **P0084 TargetFrame restoration correction:** runtime PASS.
- **TargetFrame reappearance issue:** separate tracked defect.
- **Quest destination / compass marker:** unsupported until a real destination
  is runtime-proven.
- **Quest interaction controls:** Blizzard-owned.
- **Stock Objective Tracker:** remains Blizzard-owned.
- **Git authority:** user performs commits/pushes.

## Relevant References

- `docs/memory/investigations/F6_CONTEXTUAL_OBJECTIVE_PROGRESS.md`
- `docs/memory/evidence/F6_P0088_RUNTIME_VISUAL_FAIL_2026-10-02.md`
- `docs/memory/evidence/F6_P0089_LIVE_SOURCE_PASS_PREVIEW_REGRESSION_2026-10-02.md`
- `docs/memory/evidence/P0089_DELIVERY_FAILURE_2026-10-02.md`
- `docs/memory/evidence/P0090_WORKFLOW_REALIGNMENT_2026-10-02.md`
- `docs/memory/evidence/F5_SAME_QUEST_TRANSITION_PASS_2026-10-02.md`
- `docs/memory/decisions/D-031_QUEST_EXPERIENCE_CAPABILITY_CONTRACT.md`
- `docs/memory/patches/P0088_IMPLEMENT_OBJECTIVE_PROGRESS.md`
- `docs/memory/patches/P0089_FIX_OBJECTIVE_PROGRESS_PLACEMENT.md`
- `docs/memory/patches/P0090_LIVE_OBJECTIVE_PREVIEW.md`
- `docs/memory/roadmap/PHASE_F_QUEST_EXPERIENCE.md`
