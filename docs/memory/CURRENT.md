---
memory_schema: 1
as_of: 2026-10-02
project: logres
---

# Current State

## Active Objective

**Phase F — Quest Experience.**

## Current Work Item

**F.3 — Contextual XP pulse, blocked by reproduced TargetFrame restoration failure.**

P0080 is verified pushed at `cde9b726`.

Production runtime remains:
`0.0.31-dev`.

## Verified State

- Phase E is complete.
- F.1 and F.2 are complete.
- P0080 F.3 runtime evidence proves:
  - XP Check PASS after reload;
  - normal non-secret current/max XP baseline;
  - XP Preview reports shown under Immersion ON;
  - one real XP event occurred;
  - delta `124`;
  - progress `89.1%`;
  - production pulse count `1`;
  - pulse auto-hidden by the later XP Check;
  - Immersion OFF suppresses XP Preview;
  - Immersion ON restores XP Preview;
  - XP Check remained PASS throughout.
- Contextual XP runtime behavior is therefore proven except for final visual
  acceptance and integrated validation closure.
- P0080 Run All reproduced the prior restoration failure.
- P0079 diagnostics narrow the failure to TargetFrame restoration:
  - expected Immersion OFF;
  - TargetFrame `requested=false`;
  - TargetFrame `applied=true`;
  - snapshot retained;
  - unit watch retained;
  - Logres interaction mouse ownership retained;
  - stock presentation/mouse suppression retained;
  - Action, Quiet, and Player restoration were already false/off as expected.
- The state shape proves `TargetFrameReplacement:DisableReplacement()` entered
  the restore path but did not complete stock restoration/interaction teardown.
- P0079's mismatch summary did not include the TargetFrame/controller error text,
  so the exact failing native restore operation is still unknown.
- No restoration behavior fix is authorized until that error is captured.

## Next Action

Apply/push P0081 and redeploy Logres.

Use the developer panel:
1. **Run All** once;
2. if Restoration Check passes, run **Run All** a second time;
3. if it still passes, run standalone **Restoration Check** once;
4. `/reload`;
5. export `LOGRES_DIAGNOSTICS_LATEST.lua`.

P0081 adds only error/reason/result text to an existing failure diagnostic.

If the failure recurs, use the emitted TargetFrame error to identify the exact
restore operation before changing behavior.

## Success Criteria

P0081 succeeds when:
- no restoration/suppression behavior changes;
- no retry/polling/reassertion/hook is introduced;
- a reproduced mismatch includes:
  - TargetFrame last reason;
  - TargetFrame last error;
  - controller last TargetFrame result;
  - controller last TargetFrame error;
- the diagnostic remains panel-persisted;
- no Lua/taint/secret-value errors occur.

F.3 remains open until:
- the restoration defect is resolved or correctly reclassified from new
  evidence;
- Run All passes;
- the XP pulse receives visual acceptance.

## Do Not Reopen Without New Evidence

- **Phase E:** complete.
- **F.1/F.2:** complete.
- **XP data/event path:** proven.
- **P0080 XP production event:** proven (`delta=124`, one pulse).
- **Quest IDs 436/237 destination output:** negative tested evidence.
- **Quest compass marker:** unsupported until a usable destination is proven.
- **TargetFrame restoration failure:** reproduced in P0078 and P0080; P0079
  standalone/integrated targeted run temporarily did not reproduce it.
- **Git authority:** user performs commits/pushes.

## Relevant References

- `docs/memory/evidence/F3_P0080_XP_RUNTIME_AND_TARGET_RESTORE_FAILURE_2026-10-02.md`
- `docs/memory/evidence/P0078_RESTORATION_SETTLE_FAILURE_2026-10-02.md`
- `docs/memory/evidence/P0079_RESTORATION_TARGETED_PASS_2026-10-02.md`
- `docs/memory/investigations/F3_CONTEXTUAL_XP_PULSE.md`
- `docs/memory/investigations/P0080_TARGETFRAME_RESTORE_FAILURE.md`
