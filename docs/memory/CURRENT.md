---
memory_schema: 1
as_of: 2026-10-02
project: logres
---

# Current State

## Active Objective

**Phase F — Quest Experience.**

## Current Work Item

**F.3 — Contextual XP pulse; runtime/integration proven, visual acceptance pending.**

P0081 is verified pushed at `ef8fa310`.

Production runtime remains:
`0.0.31-dev`.

## Verified State

- Phase E is complete.
- F.1 and F.2 are complete.
- P0080 F.3 runtime evidence proves:
  - XP Check PASS after reload;
  - normal non-secret current/max XP baseline;
  - one real XP event;
  - positive delta `124`;
  - progress `89.1%`;
  - production pulse count `1`;
  - pulse auto-hide;
  - Immersion OFF preview suppression;
  - Immersion ON preview recovery.
- P0080 Run All reproduced the historical TargetFrame restoration failure.
- P0079 narrowed the reproduced mismatch to TargetFrame restoration.
- P0081 added the missing TargetFrame/controller reason/error fields without
  changing restoration behavior.
- P0081 targeted validation did **not** reproduce the failure:
  - five Run All executions PASS;
  - one standalone Restoration Check PASS;
  - every observed Restoration Check in those runs PASS;
  - no TargetFrame error fields emitted because no mismatch occurred.
- The P0078/P0080 restoration failures remain real historical evidence.
- Current classification:
  **OPEN — INTERMITTENT / UNREPRODUCED under repeated P0081 targeted runs.**
- No retry, polling, broad hook, periodic reassertion, or restoration behavior
  workaround is justified from current evidence.
- F.3 integrated validation is no longer blocked by restoration failure.
- F.3 still requires explicit user visual acceptance of the XP pulse before it
  can close.

## Next Action

Obtain final visual acceptance for the contextual XP pulse.

If the user confirms that:
- the preview/real pulse appeared in the intended centered location;
- `+N XP · progress%` was readable and appropriately brief;
- the pulse disappeared instead of becoming a persistent bar;
- Blizzard XP/quest UI remained unchanged;
- no Lua/taint/secret-value errors were observed;

then close F.3 in the next durable checkpoint.

If visual presentation needs changes, keep F.3 open and patch only that
presentation issue.

## Success Criteria

F.3 succeeds when:
- event-driven XP behavior remains proven;
- positive same-range XP gain produces the brief pulse;
- Immersion OFF suppresses presentation;
- no permanent XP bar is introduced;
- no stock XP/quest UI is suppressed;
- Run All passes;
- no Lua/taint/secret-value errors occur;
- user visually accepts the pulse.

All non-visual runtime/integration criteria are currently satisfied.

## Do Not Reopen Without New Evidence

- **Phase E:** complete.
- **F.1/F.2:** complete.
- **XP data/event path:** proven.
- **P0080 XP production event:** proven (`delta=124`, one pulse).
- **P0081 targeted restoration runs:** five Run All PASS + one standalone
  Restoration Check PASS.
- **TargetFrame restoration defect:** retained as intermittent/unreproduced;
  historical P0078/P0080 failures remain preserved.
- **Quest IDs 436/237 destination output:** negative tested evidence.
- **Quest compass marker:** unsupported until a usable destination is proven.
- **Git authority:** user performs commits/pushes.

## Relevant References

- `docs/memory/evidence/F3_P0080_XP_RUNTIME_AND_TARGET_RESTORE_FAILURE_2026-10-02.md`
- `docs/memory/evidence/P0081_TARGET_RESTORE_TARGETED_PASS_2026-10-02.md`
- `docs/memory/evidence/P0078_RESTORATION_SETTLE_FAILURE_2026-10-02.md`
- `docs/memory/evidence/P0079_RESTORATION_TARGETED_PASS_2026-10-02.md`
- `docs/memory/investigations/F3_CONTEXTUAL_XP_PULSE.md`
- `docs/memory/investigations/P0080_TARGETFRAME_RESTORE_FAILURE.md`
