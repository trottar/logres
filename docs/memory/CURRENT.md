---
memory_schema: 1
as_of: 2026-10-01
project: logres
---

# Current State

## Active Objective

**Phase D — Immersion Controller.**

## Current Work Item

**D.3 — Quiet Mode runtime suppression.**

P0050 implementation is prepared.

## Verified State

- Phase 0 complete.
- Phase A complete.
- Phase B complete.
- Phase C complete.
- D.1 complete.
- D.2 complete.
- P0049 pushed at `c06d9cd`.
- runtime before P0050: `0.0.21-dev`.
- P0050 target: `0.0.22-dev`.
- D-025 remains canonical.
- Quiet Mode follows Immersion ON + world policy.
- direct ChatFrame Hide/Show remains forbidden.
- P0050 uses runtime alpha/mouse suppression.
- chat edit boxes use IgnoreParentAlpha while Quiet Mode is active.
- saved ChatWindowShown is not intentionally mutated.
- Player/Target/Party suppression remains capability-gated.
- Primary replacement/routing ownership remains deferred.

## Next Action

Install/review/commit/push P0050.

Because runtime code changes, deploy explicitly:

```bash
cd ~/Projects/logres

WOW_ROOT="/mnt/c/Program Files (x86)/World of Warcraft"
ADDONS="$WOW_ROOT/_classic_beta_/Interface/AddOns"

./tools/deploy_logres.sh "$ADDONS"
```

Then `/reload`.

Runtime proof:
1. confirm `0.0.22-dev`;
2. with Immersion ON in world, passive chat/tabs disappear;
3. old chat/tab areas do not intercept mouse;
4. Quiet Check PASS;
5. Immersion Check PASS;
6. Run All PASS;
7. press Enter and confirm chat edit box is visible;
8. send an intentional chat message successfully;
9. passive chat remains quiet afterward;
10. Immersion OFF restores normal chat/tabs/interactions;
11. Quiet Check PASS;
12. Immersion ON reapplies Quiet Mode;
13. PvP flag alone does not restore chat;
14. if naturally entering an instance, chat restores there and Quiet Mode
    reapplies after returning to world;
15. Blizzard chat-window shown/layout configuration remains intact;
16. no Lua/taint/secret error.

Do not enter an instance solely to manufacture proof.

## Success Criteria

P0050 succeeds when:
- passive world chat is visually quiet under immersion;
- no invisible chat interaction remains;
- intentional outbound chat stays usable;
- OFF restoration is exact;
- chat-update reconciliation does not leak passive chat;
- saved Blizzard chat configuration is preserved;
- context/PvP policy matches D-025.

## Do Not Reopen Without New Evidence

- **Phase C:** complete.
- **D.1:** complete.
- **D.2:** complete.
- **Direct ChatFrame Hide/Show for Quiet Mode:** rejected.
- **Player/Target/Party blanket suppression:** blocked.
- **Primary replacement/routing ownership:** deferred.
- **Auto replies:** not promised.
- **D-020 live action editing:** deferred.
- **Git authority:** user performs commits/pushes.

## Relevant References

- `docs/memory/evidence/D3_P0050_QUIET_MODE_IMPLEMENTATION_2026-10-01.md`
- `docs/memory/evidence/D3_QUIET_MODE_SOURCE_REVIEW_2026-10-01.md`
- `docs/memory/decisions/D-025_QUIET_MODE_RUNTIME_SUPPRESSION.md`
- `docs/memory/investigations/D3_QUIET_MODE_RUNTIME_SUPPRESSION.md`
- `Logres/Immersion/QuietMode.lua`
- `tools/check_quiet_mode_contract.py`
