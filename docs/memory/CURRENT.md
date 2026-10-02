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

P0088 is verified pushed at `228b467`.

Production runtime target:
`0.0.35-dev`.

F.6 status:
**RUNTIME/INTEGRATION PASS; VISUAL FAIL; P0089 REPAIR 2 RETEST PENDING.**

## Verified State

- Phase E is complete.
- F.1 and F.2 are complete.
- F.3 contextual XP is complete:
  runtime + integration + visual PASS.
- F.4 additive NPC quest detail presentation is complete:
  runtime + integration + visual PASS.
- F.5 objective/progress capability proof is complete:
  runtime PASS.
- P0088 F.6 runtime/integration evidence on `0.0.34-dev`:
  - Objective Progress Check PASS;
  - Immersion OFF/ON Preview policy PASS;
  - two consecutive Run All executions PASS;
  - Objective Progress diagnostics reported `secret=false` and no fixed error.
- P0088 real production objective pulse remains unproven:
  diagnostics reported `changes=0`, `pulses=0`.
- P0088 visual acceptance FAIL:
  objective text overlapped the lower-center action cluster.
- Possible post-kill Seer objective freshness issue:
  OPEN / UNPROVEN because the visible `1/10` was also the static Preview sample.
- P0089 delivery attempt 1 failed in temporary-tree validation:
  invalid generated Python checker.
- P0089 delivery attempt 2 failed in temporary-tree validation:
  checker demanded single-line SetPoint literals while transformed Lua used
  correct multiline calls.
- Neither P0089 failure wrote tracked target files or produced runtime evidence.
- P0089 Repair 2 changes presentation only:
  - `520x32`;
  - anchor just above addon-owned `LogresHUDTarget`;
  - 6px gap;
  - UI-center `y=-5` fallback;
  - visibly synthetic Preview.
- P0089 does not change passive quest source/event/baseline logic.
- Stock Objective Tracker remains Blizzard-owned.
- Negative quest-destination samples remain:
  `436`, `237`, `1338`.
- Quest compass marker remains unsupported.

## Next Action

Apply and push P0089 Repair 2.

After verified push:
- deploy `0.0.35-dev`;
- `/reload`;
- Objective Progress Preview for placement;
- Immersion OFF/ON Preview policy;
- Run All twice;
- **Quest Probe** for the actual live objective count;
- continue one natural objective change;
- verify one real F.6 production pulse;
- Quest Probe again for the updated live count;
- confirm no duplicate pulse without another objective change;
- `/reload`;
- export `LOGRES_DIAGNOSTICS_LATEST.lua`.

Do not use Objective Progress Preview as a live quest-count check.

If Quest Probe remains stale relative to Blizzard's stock Objective Tracker,
preserve that as a real source/freshness failure before adding any retry,
polling, or new hook.

## Success Criteria

F.6 closes only after:
- static contract PASS;
- runtime initialization/integration PASS;
- corrected visual placement PASS;
- at least one real same-quest objective pulse;
- Quest Probe confirms the corresponding live objective update;
- no duplicate pulse on unchanged recapture;
- fail-open behavior remains safe;
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
- `docs/memory/evidence/P0089_DELIVERY_FAILURE_2026-10-02.md`
- `docs/memory/evidence/F5_SAME_QUEST_TRANSITION_PASS_2026-10-02.md`
- `docs/memory/decisions/D-031_QUEST_EXPERIENCE_CAPABILITY_CONTRACT.md`
- `docs/memory/patches/P0088_IMPLEMENT_OBJECTIVE_PROGRESS.md`
- `docs/memory/patches/P0089_FIX_OBJECTIVE_PROGRESS_PLACEMENT.md`
- `docs/memory/roadmap/PHASE_F_QUEST_EXPERIENCE.md`
