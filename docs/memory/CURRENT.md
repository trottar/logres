---
memory_schema: 1
as_of: 2026-10-02
project: logres
---

# Current State

## Active Objective

**Phase F — Quest Experience.**

## Current Work Item

**F.3 — Contextual XP pulse implementation.**

P0079 is verified pushed at `1aad7bad`.

F.2 is complete.

P0080 prepares the first production Phase F presentation slice.

Production runtime target:
`0.0.31-dev`.

## Verified State

- Phase E is complete.
- F.1 is complete under D-031.
- F.2 is complete.
- P0078 runtime evidence proved:
  - normal numeric current/max/rested XP;
  - `PLAYER_XP_UPDATE`;
  - `UPDATE_EXHAUSTION`;
  - quest-detail passive reads;
  - `QUEST_DETAIL`;
  - `QUEST_ACCEPTED`;
  - super-tracked quest identity.
- Populated active-objective rows remain unproven.
- Quest `436` again produced no usable quest destination.
- Quest compass markers remain unsupported until a usable destination is
  runtime-proven.
- The P0078 Restoration Check failure remains real historical evidence.
- P0079 targeted validation did not reproduce it:
  - standalone Restoration Check PASS;
  - subsequent Run All PASS, including Restoration Check.
- Therefore the P0078 failure is retained as:
  **OPEN — INTERMITTENT / UNREPRODUCED under targeted P0079 validation.**
- No restoration/suppression behavior workaround is introduced.

## Next Action

Apply/push P0080.

Then deploy and validate the contextual XP pulse through the developer panel.

Required runtime matrix:
1. **XP Check** after reload;
2. **XP Preview** visually shows a brief centered `+XP · progress%` pulse;
3. gain XP once through ordinary play;
4. verify the real pulse appears and disappears without a permanent bar;
5. **XP Check** shows at least one XP event and production pulse;
6. Immersion OFF -> **XP Preview** is suppressed;
7. Immersion ON -> **XP Preview** displays again;
8. **Run All** passes;
9. no Lua/taint/secret-value errors;
10. Blizzard XP/quest UI remains unchanged.

Persist with `/reload`, export diagnostics, and attach
`LOGRES_DIAGNOSTICS_LATEST.lua`.

## Success Criteria

F.3 succeeds when:
- the module is event-driven, with no OnUpdate/polling;
- XP values are secret-checked before inspection/arithmetic;
- a positive same-level XP delta produces a brief pulse;
- level/range changes rebaseline instead of fabricating a gain;
- Immersion OFF suppresses presentation while still allowing baseline updates;
- the pulse disappears automatically;
- no stock XP bar/UI is suppressed or mutated;
- XP Check and Run All pass;
- no Lua/taint/secret-value errors occur;
- visual presentation is accepted.

## Do Not Reopen Without New Evidence

- **Phase E:** complete.
- **Minimap:** Blizzard-owned / stock by D-030.
- **F.1:** complete / D-031 accepted.
- **F.2:** complete.
- **Contextual XP source/event capability:** proven.
- **Quest detail reads:** proven for tested detail flow.
- **Populated objective rows:** unproven.
- **Quest IDs 436/237 destination output:** negative tested evidence.
- **Quest compass marker:** unsupported until a usable destination is proven.
- **P0078 restoration failure:** retained as intermittent/unreproduced; not
  silently resolved.
- **Git authority:** user performs commits/pushes.

## Relevant References

- `docs/memory/evidence/F2_P0078_QUEST_XP_RUNTIME_EVIDENCE_2026-10-02.md`
- `docs/memory/evidence/P0079_RESTORATION_TARGETED_PASS_2026-10-02.md`
- `docs/memory/evidence/P0078_RESTORATION_SETTLE_FAILURE_2026-10-02.md`
- `docs/memory/investigations/F3_CONTEXTUAL_XP_PULSE.md`
- `docs/memory/decisions/D-031_QUEST_EXPERIENCE_CAPABILITY_CONTRACT.md`
- `docs/memory/roadmap/PHASE_F_QUEST_EXPERIENCE.md`
