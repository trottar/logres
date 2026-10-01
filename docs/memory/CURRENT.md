---
memory_schema: 1
as_of: 2026-10-01
project: logres
---

# Current State

## Active Objective

**Phase D — Immersion Controller.**

## Current Work Item

**D.4 — Target selective replacement runtime proof.**

P0056 produced a verified secret-boolean diagnostic failure.
P0057 secret-safe diagnostic hotfix is prepared.

## Verified State

- Phase 0 complete.
- Phase A complete.
- Phase B complete.
- Phase C complete.
- D.1 complete.
- D.2 complete.
- D.3 complete.
- D.4 Player selective replacement runtime PASS.
- D.4 Target source review complete.
- P0056 pushed at `4d7b6b1`.
- P0056 runtime version `0.0.24-dev`.
- `/logres status` works on P0056.
- `/logres targetframecheck` FAILS on P0056:
  secret boolean branch in `TargetFrameReplacement.lua`.
- exact failure is durable evidence.
- root cause: diagnostic branching on `IsIgnoringParentAlpha()`.
- P0057 target: `0.0.25-dev`.
- P0057 treats captured secret-capable values as opaque restoration tokens.
- P0057 target diagnostics use Logres-owned non-secret state instead of
  protected readback.
- Target runtime proof remains OPEN.
- target-of-target remains Blizzard-owned.
- Focus/boss target frames remain untouched.
- Party/CompactPartyFrame suppression remains deferred.
- D.3 instance Quiet Mode transition remains environmental deferral.
- Primary replacement/routing ownership remains deferred.
- D-020 live action editing remains deferred.
- cast cue color regression remains open visual debt.

## Next Action

Install/review/commit/push P0057.

Because runtime code changes, deploy explicitly:

```bash
cd ~/Projects/logres

WOW_ROOT="/mnt/c/Program Files (x86)/World of Warcraft"
ADDONS="$WOW_ROOT/_classic_beta_/Interface/AddOns"

./tools/deploy_logres.sh "$ADDONS"
```

Then `/reload`.

Run:
1. `/logres status` and confirm `0.0.25-dev`;
2. `/logres targetframecheck`;
3. `/logres immersioncheck`;
4. Run All.

Then continue the P0056 visual/interaction proof:
- stock target shell absent under immersion;
- Logres target interaction works;
- auras remain usable;
- OFF restores stock target;
- combat transition defers safely.

## Success Criteria

P0057 succeeds when diagnostics no longer branch on secret-capable target frame
state and Target Frame Check can run to completion.

D.4 Target runtime proof still requires the visual/interaction/restoration
checks after the diagnostic fix.

## Do Not Reopen Without New Evidence

- **P0056 targetframecheck result:** verified failure.
- **Root cause:** secret boolean diagnostic branch.
- **Whole TargetFrame suppression:** rejected.
- **Target-of-target:** separately Blizzard-owned.
- **Party suppression:** deferred.
- **Git authority:** user performs commits/pushes.

## Relevant References

- `docs/memory/evidence/D4_P0056_TARGETFRAMECHECK_SECRET_BOOLEAN_FAILURE_2026-10-01.md`
- `docs/memory/investigations/D4_TARGET_RUNTIME_PROOF.md`
- `docs/memory/decisions/D-027_TARGET_SELECTIVE_SUPPRESSION.md`
- `Logres/Immersion/TargetFrameReplacement.lua`
- `tools/check_target_frame_replacement_contract.py`
