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

P0032 prepares the first live secure action cluster.

## Verified State

- Phase 0 Foundation complete.
- Phase A Core State Engine complete.
- Phase B Core HUD complete.
- C.1 secure action source review complete.
- P0031 pushed at `6d0a5b1`.
- runtime baseline before P0032: `0.0.13-dev`.
- P0032 runtime version: `0.0.14-dev`.
- D-018 secure-action contract is authoritative.
- P0032 static action contract passes.
- stock Blizzard action bars remain visible.
- P0029 slash-output fallback regression was discovered by source inspection and fixed in P0032.

## Next Action

Install/review/commit/push P0032.

Because runtime code changes, deploy explicitly:

```bash
cd ~/Projects/logres

WOW_ROOT="/mnt/c/Program Files (x86)/World of Warcraft"
ADDONS="$WOW_ROOT/_classic_beta_/Interface/AddOns"

./tools/deploy_logres.sh "$ADDONS"
```

Then `/reload`.

Use the in-game developer panel:
- Run All;
- Action Check.

Confirm:
- `0.0.14-dev`;
- Action Check PASS;
- 12-button 4x3 cluster visible.

Runtime proof:
1. compare Logres actions/icons with current primary Blizzard page;
2. mouse-click a safe Logres action;
3. use the action's existing keyboard key;
4. trigger cooldown;
5. observe count/charge if naturally present;
6. observe usability/range tint if convenient;
7. fight normally and confirm mouse + key execution still work;
8. report any protected-action/taint/Lua/secret errors;
9. keep Blizzard action bars visible.

Also test the repaired slash fallback once:

```text
/logres status
```

It should print normally rather than recurse.

Optional:
out-of-combat primary page change should remap the Logres cluster.

Do not require a combat-time page-change scenario for C.2.

## Success Criteria

C.2 succeeds when:
- 12 secure buttons render correctly;
- mouse execution works;
- existing primary action key execution works;
- icons/cooldown/count presentation is error-free;
- actions continue working in ordinary combat;
- no forbidden protected mutation occurs;
- no secret-value error occurs;
- stock Blizzard action bars remain available;
- repaired slash fallback prints normally.

## Do Not Reopen Without New Evidence

- **Phase B:** complete.
- **C.1:** complete.
- **Secure action contract:** D-018 canonical.
- **Saved bindings:** never rewritten automatically.
- **Stock action bars:** remain visible in C.2.
- **Combat-time action paging:** known C.2 limitation; requires later secure driver work.
- **Drag/drop editing:** deferred.
- **Deployment:** full deploy block required.
- **Git authority:** user performs commits/pushes.

## Relevant References

- `docs/memory/decisions/D-018_SECURE_ACTION_INTERFACE_CONTRACT.md`
- `docs/memory/investigations/C2_PRIMARY_ACTION_CLUSTER.md`
- `docs/memory/architecture/ACTION_CLUSTERS.md`
- `docs/memory/evidence/P0029_SLASH_FALLBACK_REGRESSION_2026-10-01.md`
- `Logres/Actions/Primary.lua`
- `tools/check_action_contract.py`
