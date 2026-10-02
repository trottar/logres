---
memory_schema: 1
as_of: 2026-10-02
project: logres
---

# Current State

## Active Objective

**Phase F — Quest Experience.**

## Current Work Item

**F.4 — Additive NPC quest detail presentation, with narrow TargetFrame restoration correction.**

P0083 is verified pushed at `484323bb`.

P0083 F.4 runtime path is proven, but integrated Run All exposed the exact
TargetFrame restoration defect. P0084 corrects that defect.

Runtime target:
`0.0.33-dev`.

## Verified State

- Phase E is complete.
- F.1, F.2, and F.3 are complete.
- F.3 contextual XP is runtime/integration/visual PASS.
- P0083 F.4 runtime evidence proves:
  - Quest Dialogue Preview shown;
  - real `QUEST_DETAIL`;
  - quest ID `436`;
  - body/objective present;
  - production presentation;
  - `QUEST_ACCEPTED` cleanup;
  - Immersion OFF suppression;
  - Immersion ON recovery;
  - Quest Dialogue Check PASS.
- F.4 visual acceptance is not yet recorded.
- P0083 Run All captured the exact TargetFrame restore error:
  `SetIgnoreParentAlpha` rejected a secret-capable restoration token outside
  untainted execution.
- P0084 removes IgnoreParentAlpha mutation from TargetFrame replacement.
- Preserved contextual surfaces are left untouched:
  Auras, RaidTargetIcon, QuestIcon, PingIconFrame.
- Nine unwanted contextual children are alpha-suppressed individually and
  restored from opaque alpha tokens.
- No polling, retry, periodic reassertion, or broad Blizzard hook is added.
- P0084 preparation encountered three static delivery/preflight failures; all are recorded and produced no new runtime evidence.

## Next Action

Apply/push P0084.

Then deploy `0.0.33-dev` and validate:
1. Target Frame Check;
2. Restoration Check twice;
3. Run All twice;
4. Quest Dialogue Check;
5. Quest Dialogue Preview;
6. no Lua/taint/secret errors;
7. stock TargetFrame restoration works;
8. preserved target context remains available when naturally present.

F.4 then still requires explicit visual acceptance before closure.

## Success Criteria

P0084 succeeds when:
- no IgnoreParentAlpha runtime path remains in TargetFrame replacement;
- preserved contextual children are not mutated;
- nine unwanted contextual children are selectively alpha-suppressed;
- exact captured alpha tokens restore before Logres interaction is removed;
- repeated Restoration Check and Run All pass;
- no Lua/taint/secret error occurs.

F.4 succeeds when its proven runtime path also receives visual acceptance.

## Do Not Reopen Without New Evidence

- **Phase E:** complete.
- **F.1/F.2:** complete.
- **F.3 contextual XP:** complete / visual PASS.
- **P0083 F.4 runtime path:** proven.
- **F.4 visual acceptance:** pending.
- **TargetFrame restore failure class:** root cause identified in P0083.
- **Separate TargetFrame reappearance issue:** unrelated absent new evidence.
- **Populated objective rows:** unproven.
- **Quest destination / compass marker:** unsupported until runtime-proven.
- **Quest interaction controls:** Blizzard-owned.
- **Git authority:** user performs commits/pushes.

## Relevant References

- `docs/memory/evidence/F4_P0083_QUEST_DIALOGUE_RUNTIME_AND_TARGET_RESTORE_ROOT_CAUSE_2026-10-02.md`
- `docs/memory/evidence/P0084_DELIVERY_FAILURE_2026-10-02.md`
- `docs/memory/investigations/F4_NPC_QUEST_DETAIL_PRESENTATION.md`
- `docs/memory/investigations/P0080_TARGETFRAME_RESTORE_FAILURE.md`
- `docs/memory/decisions/D-027_TARGET_SELECTIVE_SUPPRESSION.md`
