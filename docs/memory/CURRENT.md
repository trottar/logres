---
memory_schema: 1
as_of: 2026-10-01
project: logres
---

# Current State

## Active Objective

**Phase C — Action Interface.**

## Current Work Item

**C.2 — Primary Action Cluster.**

P0032 runtime failed on secure action execution.

P0033 fix is prepared.

## Verified State

- Phase 0 complete.
- Phase A complete.
- Phase B complete.
- C.1 complete.
- P0032 pushed at `9f9f97d`.
- P0032 cluster rendering: PASS.
- P0032 range tint: PASS.
- P0032 mouse action execution: FAIL.
- P0032 routed key execution: FAIL.
- P0032 automatic override routing interfered with normal action keys.
- P0033 changes key routing to fail-open/opt-in.
- P0033 removes duplicate internal `1–12` labels.
- stock Blizzard action bars remain visible.

## Next Action

Install/review/commit/push P0033.

Because runtime code changes, deploy explicitly:

```bash
cd ~/Projects/logres

WOW_ROOT="/mnt/c/Program Files (x86)/World of Warcraft"
ADDONS="$WOW_ROOT/_classic_beta_/Interface/AddOns"

./tools/deploy_logres.sh "$ADDONS"
```

Then `/reload`.

Confirm:
- version `0.0.15-dev`;
- Run All / Action Check PASS;
- no duplicate `1–12` labels.

Test both:
1. Action Keys OFF: normal stock keys work;
2. mouse-click Logres actions;
3. Action Keys ON: existing keys execute via Logres;
4. Action Keys OFF: routing releases cleanly;
5. ordinary combat mouse + keyboard execution;
6. cooldown/range/count presentation.

Report any protected-action, taint, Lua, or secret error.

## Success Criteria

C.2 succeeds when:
- Logres mouse execution works;
- opt-in existing-key execution works;
- routing can be safely released;
- ordinary combat execution works;
- existing presentation remains correct;
- no protected/taint/Lua/secret error occurs;
- stock action bars remain available.

## Do Not Reopen Without New Evidence

- **P0032 execution:** failed.
- **P0032 presentation/range:** partially proven.
- **Automatic critical-input takeover before proof:** rejected by L-011.
- **Stock action bars:** remain visible.
- **Combat-time page remap:** still deferred until combat ends.
- **Git authority:** user performs commits/pushes.

## Relevant References

- `docs/memory/evidence/C2_P0032_RUNTIME_FAILURE_2026-10-01.md`
- `docs/memory/LEARNINGS.md`
- `docs/memory/decisions/D-018_SECURE_ACTION_INTERFACE_CONTRACT.md`
- `docs/memory/investigations/C2_PRIMARY_ACTION_CLUSTER.md`
- `Logres/Actions/Primary.lua`
- `tools/check_action_contract.py`
