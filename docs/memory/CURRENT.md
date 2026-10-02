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

P0085 is verified pushed at `f6a30d8`.

Production runtime remains:
`0.0.33-dev`.

F.5 status:
**PARTIAL PASS — OBJECTIVE DATA SHAPES PROVEN; SAME-QUEST TRANSITION PENDING.**

## Verified State

- Phase E is complete.
- F.1 and F.2 are complete.
- F.3 contextual XP is complete:
  runtime + integration + visual PASS.
- F.4 additive NPC quest detail presentation is complete:
  runtime + integration + visual PASS.
- P0084 TargetFrame restoration correction is runtime-proven.
- F.5 now runtime-proves the objective data shapes required by D-031:
  - no active quest -> objective state unavailable / `nil`;
  - quest `436` -> objective table present but empty;
  - quest `237` -> populated incomplete rows:
    - Stonesplinter Skullthumper slain `0/10`, done=false;
    - Stonesplinter Seer slain `0/10`, done=false;
  - quest `1338` -> populated completed row:
    - Bring Stormpike's Request to Furen Longbeard in Stormwind
      `1/1`, done=true.
- Quest `237` reported:
  `complete=false`, `failed=false`, `ready=false`.
- Quest `1338` reported:
  `complete=true`, `failed=false`, `ready=true`.
- Across the new samples:
  - `QUEST_LOG_UPDATE` advanced;
  - `SUPER_TRACKING_CHANGED` advanced;
  - `QUEST_PROGRESS` remained 0;
  - `QUEST_COMPLETE` remained 0;
  - `QUEST_TURNED_IN` remained 0;
  - `QUEST_WATCH_UPDATE` remained 0.
- Therefore the data model is proven, but a same-quest objective update transition is
  not yet proven.
- Quest IDs `436`, `237`, and `1338` are now negative waypoint samples.
- Quest compass marker remains unsupported.

## Next Action

Use the existing **Quest Probe** for one same-quest objective transition during
normal gameplay.

Preferred currently-proven candidate:
quest `237`, which already has a captured `0/10` baseline.

When naturally continuing that quest:
1. leave quest `237` active/super-tracked if convenient;
2. after one Stonesplinter Skullthumper or Seer kill changes the objective count,
   run **Quest Probe**;
3. if the quest later completes naturally, run **Quest Probe** again;
4. if it is turned in naturally, run **Quest Probe** again;
5. `/reload`;
6. export `LOGRES_DIAGNOSTICS_LATEST.lua`.

Any equivalent active quest with a before/after objective-row change is valid.

Do not travel, repeat content, or manufacture gameplay solely for proof.

## Success Criteria

F.5 may close when runtime evidence proves:
- unavailable/not-loaded objective data;
- empty objective list;
- populated incomplete objectives;
- populated completed objectives;
- a same-quest objective update that replaces the prior value rather than
  retaining stale data.

Completion/turn-in/watch-specific events remain environmental deferrals if they
are not naturally emitted; they are not promoted to PASS merely because the
corresponding final data state is observable.

No production objective presentation and no stock Objective Tracker suppression
is authorized until the same-quest update behavior is proven.

## Do Not Reopen Without New Evidence

- **Phase E:** complete.
- **F.1/F.2:** complete.
- **F.3 contextual XP:** complete.
- **F.4 additive NPC quest detail presentation:** complete.
- **P0084 TargetFrame restoration correction:** runtime PASS.
- **F.5 objective data shapes:** runtime PASS.
- **F.5 same-quest update behavior:** pending.
- **TargetFrame reappearance issue:** separate tracked defect.
- **Quest destination / compass marker:** unsupported until a real destination
  is runtime-proven.
- **Quest interaction controls:** Blizzard-owned.
- **Stock Objective Tracker:** remains Blizzard-owned.
- **Git authority:** user performs commits/pushes.

## Relevant References

- `docs/memory/evidence/F5_OBJECTIVE_DATA_SHAPES_2026-10-02.md`
- `docs/memory/investigations/F5_OBJECTIVE_PROGRESS_CAPABILITY_PROOF.md`
- `docs/memory/decisions/D-031_QUEST_EXPERIENCE_CAPABILITY_CONTRACT.md`
- `docs/memory/roadmap/PHASE_F_QUEST_EXPERIENCE.md`
