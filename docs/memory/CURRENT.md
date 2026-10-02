---
memory_schema: 1
as_of: 2026-10-02
project: logres
---

# Current State

## Active Objective

**Phase F — Quest Experience.**

## Current Work Item

**F.5 — Objective / progress runtime capability proof.**

P0084 is verified pushed at `a74329a`.

Production runtime remains:
`0.0.33-dev`.

## Verified State

- Phase E is complete.
- F.1 and F.2 are complete.
- F.3 contextual XP is complete:
  runtime + integration + visual PASS.
- F.4 additive NPC quest detail presentation is complete:
  runtime + integration + visual PASS.
- P0083 proved the real quest-detail path:
  - `QUEST_DETAIL`;
  - quest ID `436`;
  - title/body/objective text;
  - production presentation;
  - `QUEST_ACCEPTED` cleanup;
  - Immersion OFF suppression;
  - Immersion ON recovery.
- P0084 corrected the TargetFrame restoration defect identified in P0083.
- P0084 runtime proof:
  - `0.0.33-dev`;
  - Target Frame Check PASS with
    `contextualSuppressed=9`, `preserved=4`;
  - two standalone Restoration Checks PASS;
  - three consecutive Run All executions PASS;
  - no recurrence of the `SetIgnoreParentAlpha` secret-value failure.
- User reported F.4:
  **visual passed**.
- The P0080 TargetFrame restoration investigation is CLOSED by P0084 runtime
  proof.
- The separate historical TargetFrame reappearance issue remains tracked
  independently.
- Populated active-objective rows remain unproven.
- `QUEST_PROGRESS`, `QUEST_COMPLETE`, `QUEST_TURNED_IN`, and
  `QUEST_WATCH_UPDATE` remain registered but naturally unobserved in the
  existing capability evidence.
- Quest IDs `436` and `237` remain negative destination samples; quest compass
  marker remains unsupported.

## Next Action

F.5 uses the existing **Quest Probe** before any new production code.

When normal gameplay naturally provides suitable states, capture:
1. an active quest with one or more populated objective rows;
2. a later objective/progress state for that quest;
3. completion and/or turn-in state if naturally encountered.

Do not travel or manufacture gameplay solely to satisfy the probe.

After meaningful evidence:
- `/reload` to flush SavedVariables;
- export `LOGRES_DIAGNOSTICS_LATEST.lua`;
- evaluate which objective/progress paths are actually runtime-proven.

No new objective presentation and no stock Objective Tracker suppression is
authorized until this evidence exists.

## Success Criteria

F.5 succeeds when runtime evidence is sufficient to distinguish, without
fabrication:
- unavailable/not-loaded objective data;
- empty objective lists;
- populated active objectives;
- completed objectives where naturally observable;
- relevant progress/completion/turn-in event behavior.

Any unobserved transition remains an environmental deferral rather than PASS.

## Do Not Reopen Without New Evidence

- **Phase E:** complete.
- **F.1/F.2:** complete.
- **F.3 contextual XP:** complete.
- **F.4 additive NPC quest detail presentation:** complete.
- **P0084 TargetFrame restoration correction:** runtime PASS.
- **TargetFrame reappearance issue:** separate tracked defect.
- **Quest destination / compass marker:** unsupported until a real destination
  is runtime-proven.
- **Quest interaction controls:** Blizzard-owned.
- **Stock Objective Tracker:** remains Blizzard-owned.
- **Git authority:** user performs commits/pushes.

## Relevant References

- `docs/memory/evidence/F4_P0084_RUNTIME_AND_VISUAL_PASS_2026-10-02.md`
- `docs/memory/investigations/F5_OBJECTIVE_PROGRESS_CAPABILITY_PROOF.md`
- `docs/memory/investigations/F4_NPC_QUEST_DETAIL_PRESENTATION.md`
- `docs/memory/investigations/P0080_TARGETFRAME_RESTORE_FAILURE.md`
- `docs/memory/decisions/D-031_QUEST_EXPERIENCE_CAPABILITY_CONTRACT.md`
