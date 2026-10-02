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

P0086 is verified pushed at `d4e8c39`.

Production runtime remains:
`0.0.33-dev`.

## Verified State

- Phase E is complete.
- F.1 and F.2 are complete.
- F.3 contextual XP is complete:
  runtime + integration + visual PASS.
- F.4 additive NPC quest detail presentation is complete:
  runtime + integration + visual PASS.
- P0084 TargetFrame restoration correction is runtime-proven.
- F.5 objective/progress capability proof is COMPLETE.
- F.5 runtime-proven data states:
  - no active quest -> objective state unavailable / nil;
  - quest `436` -> objective table present but empty;
  - quest `237` -> populated incomplete rows;
  - quest `1338` -> populated completed row.
- Same-quest update behavior is now runtime-proven on quest `237`:
  - baseline Seer objective: `0/10`, done=false;
  - later same-quest sample: `1/10`, done=false;
  - repeated later sample retained `1/10`, proving fresh recapture rather than
    stale baseline reuse.
- During that transition:
  - `QUEST_LOG_UPDATE` reached 50;
  - `QUEST_WATCH_UPDATE` advanced from 0 to 1;
  - `QUEST_PROGRESS` remained 0;
  - `QUEST_COMPLETE` remained 0;
  - `QUEST_TURNED_IN` remained 0.
- `QUEST_PROGRESS`, `QUEST_COMPLETE`, and `QUEST_TURNED_IN` remain environmental
  deferrals and are not required production triggers.
- Negative quest-destination samples remain:
  `436`, `237`, `1338`.
- Quest compass marker remains unsupported.
- The first P0087 docs-only apply was rejected by the repository memory
  checker because the proposed CURRENT.md omitted the required Success
  Criteria heading; validation stopped in the temporary tree before any
  tracked-file mutation.

## F.6 Contract

F.6 is a **temporary contextual objective-progress pulse**, not a permanent
objective tracker.

Observation:
- use passive quest-log objective reads already runtime-proven in F.5;
- prefer current super-tracked quest ID, with selected quest as safe fallback;
- use only secret-safe scalar objective fields;
- do not persist quest text/objective content.

Update triggers:
- `QUEST_LOG_UPDATE` is the primary proven refresh event;
- `QUEST_WATCH_UPDATE` is an additional proven refresh event;
- `SUPER_TRACKING_CHANGED` changes identity/baseline but does not itself imply
  objective progress;
- do not require unobserved `QUEST_PROGRESS`, `QUEST_COMPLETE`, or
  `QUEST_TURNED_IN`.

Presentation:
- first usable sample for a quest establishes a baseline and shows nothing;
- quest identity changes rebaseline and show nothing;
- a changed objective count or finished flag may produce a short pulse;
- show only the changed objective information needed by the player;
- no permanent list;
- no mouse interaction;
- Immersion OFF suppresses presentation while observation/baseline remains safe;
- absent, secret, invalid, uncached, nil, or empty data fails open without
  fabricating progress.

Stock ownership:
- Blizzard Objective Tracker remains fully available;
- Logres does not mutate quest watch/super-track state;
- quest log and interaction controls remain Blizzard-owned.

## Next Action

Implement F.6 according to the accepted contextual-pulse contract.

Required developer-panel surfaces:
- Objective Progress Check;
- Objective Progress Preview;
- Run All integration for the check.

Runtime acceptance must prove:
1. clean initialization/baseline with no false pulse;
2. a real same-quest objective change produces one short pulse;
3. no stale pulse on quest identity change;
4. Immersion OFF suppresses presentation;
5. stock Objective Tracker remains unchanged/usable;
6. no Lua/taint/protected/secret-value errors.

## Success Criteria

F.6 implementation is ready for runtime validation when:
- the first usable sample establishes a baseline without a false pulse;
- a same-quest objective count or finished-state change produces one bounded,
  temporary pulse;
- a repeated refresh with no additional objective change produces no duplicate
  pulse;
- a quest identity change rebaselines without replaying prior progress;
- Immersion OFF suppresses presentation while safe observation/baselining
  continues;
- missing, nil, empty, secret, invalid, or uncached objective data fails open;
- Blizzard Objective Tracker remains unchanged and usable;
- Logres does not mutate quest watch or super-track state;
- developer-panel Objective Progress Check/Preview and Run All integration are
  present;
- runtime validation observes no Lua, taint, protected-action, or secret-value
  errors.

F.6 does not authorize stock Objective Tracker suppression.

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

- `docs/memory/evidence/F5_SAME_QUEST_TRANSITION_PASS_2026-10-02.md`
- `docs/memory/evidence/P0087_DELIVERY_FAILURE_2026-10-02.md`
- `docs/memory/investigations/F5_OBJECTIVE_PROGRESS_CAPABILITY_PROOF.md`
- `docs/memory/investigations/F6_CONTEXTUAL_OBJECTIVE_PROGRESS.md`
- `docs/memory/decisions/D-031_QUEST_EXPERIENCE_CAPABILITY_CONTRACT.md`
- `docs/memory/roadmap/PHASE_F_QUEST_EXPERIENCE.md`
