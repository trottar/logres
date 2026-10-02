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

P0087 is verified pushed at `4aecb22`.

Production runtime target:
`0.0.34-dev`.

F.6 status:
**IMPLEMENTED — RUNTIME + VISUAL PROOF PENDING.**

## Verified State

- Phase E is complete.
- F.1 and F.2 are complete.
- F.3 contextual XP is complete:
  runtime + integration + visual PASS.
- F.4 additive NPC quest detail presentation is complete:
  runtime + integration + visual PASS.
- F.5 objective/progress capability proof is complete:
  runtime PASS.
- F.5 proves:
  - nil/no-active objective state;
  - empty objective list;
  - populated incomplete rows;
  - populated completed row;
  - same-quest `0/10 -> 1/10` refresh;
  - fresh repeated same-quest recapture;
  - `QUEST_WATCH_UPDATE` observed.
- Environmental deferrals remain:
  - `QUEST_PROGRESS`;
  - `QUEST_COMPLETE`;
  - `QUEST_TURNED_IN`.
- P0088 implements F.6 as a temporary contextual pulse.
- The first P0088 apply was rejected in temporary-tree validation by the
  stale Compass checker, which froze runtime at `0.0.30-dev`; no tracked
  P0088 file was written before failure.
- P0088 does not suppress or mutate the stock Objective Tracker.
- Negative quest-destination samples remain:
  `436`, `237`, `1338`.
- Quest compass marker remains unsupported.

## F.6 Implementation

Module:
`QuestObjectiveProgress`.

Runtime target:
`0.0.34-dev`.

Observation:
- prefer usable super-tracked quest ID;
- safe selected-quest fallback;
- passive `C_QuestLog.GetQuestObjectives`;
- secret-check container, rows, and scalar fields before inspection;
- objective text/content exists only in session memory and presentation, not
  SavedVariables/diagnostic output.

Refresh:
- `QUEST_LOG_UPDATE`;
- `QUEST_WATCH_UPDATE`;
- `SUPER_TRACKING_CHANGED` as rebaseline-only identity refresh;
- `PLAYER_ENTERING_WORLD` as rebaseline-only world refresh.

Presentation:
- first usable sample baselines without a pulse;
- quest identity change rebaselines without a pulse;
- same-quest count/finished change may pulse;
- unchanged repeat refresh does not duplicate the pulse;
- maximum two changed rows per pulse;
- 3-second text-only presentation;
- no mouse interaction;
- Immersion OFF suppresses presentation while safe baselining continues;
- no permanent objective list/background tracker.

Developer panel:
- Objective Progress Check;
- Objective Progress Preview;
- Run All includes Objective Progress Check.

## Next Action

Apply and push P0088.

After verified push:
- deploy `0.0.34-dev`;
- `/reload`;
- Objective Progress Check;
- Objective Progress Preview;
- Immersion OFF/ON preview policy;
- Run All;
- then capture one natural real objective update if convenient.

Runtime acceptance should verify:
1. initialization/check PASS;
2. preview visible while Immersion ON;
3. preview suppressed while Immersion OFF;
4. first real sample does not false-pulse;
5. a real same-quest objective change produces one short pulse;
6. a later unchanged refresh does not duplicate it;
7. quest identity change does not replay stale progress;
8. stock Objective Tracker remains usable;
9. no Lua/taint/protected/secret-value errors.

## Success Criteria

F.6 closes only after:
- static contract PASS;
- runtime initialization/integration PASS;
- at least one real same-quest objective pulse;
- no duplicate pulse on unchanged recapture;
- fail-open behavior remains safe;
- Immersion policy works;
- stock Objective Tracker remains Blizzard-owned and usable;
- user visual acceptance confirms the pulse is concise, temporary, readable, and
  not a permanent tracker.

## Do Not Reopen Without New Evidence

- **Phase E:** complete.
- **F.1/F.2:** complete.
- **F.3 contextual XP:** complete.
- **F.4 additive NPC quest detail presentation:** complete.
- **F.5 objective/progress capability proof:** complete.
- **P0084 TargetFrame restoration correction:** runtime PASS.
- **TargetFrame reappearance issue:** separate tracked defect.
- **Quest destination / compass marker:** unsupported until a real destination
  is runtime-proven.
- **Quest interaction controls:** Blizzard-owned.
- **Stock Objective Tracker:** remains Blizzard-owned.
- **Git authority:** user performs commits/pushes.

## Relevant References

- `docs/memory/investigations/F6_CONTEXTUAL_OBJECTIVE_PROGRESS.md`
- `docs/memory/evidence/P0088_DELIVERY_FAILURE_2026-10-02.md`
- `docs/memory/evidence/F5_SAME_QUEST_TRANSITION_PASS_2026-10-02.md`
- `docs/memory/decisions/D-031_QUEST_EXPERIENCE_CAPABILITY_CONTRACT.md`
- `docs/memory/patches/P0088_IMPLEMENT_OBJECTIVE_PROGRESS.md`
- `docs/memory/roadmap/PHASE_F_QUEST_EXPERIENCE.md`
