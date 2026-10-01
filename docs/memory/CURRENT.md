---
memory_schema: 1
as_of: 2026-10-01
project: logres
---

# Current State

## Active Objective

**Phase C — Action Interface.**

## Current Work Item

**C.5 — Stock Action-Bar Replacement.**

P0044 runtime implementation is prepared.

## Verified State

- Phase 0 complete.
- Phase A complete.
- Phase B complete.
- C.1 complete.
- C.2 complete.
- C.3 complete.
- C.4 complete.
- P0043 pushed at `66ea513`.
- runtime before P0044: `0.0.19-dev`.
- P0044 target: `0.0.20-dev`.
- first replacement scope is Bars 2–3 only.
- MainActionBar remains unsuppressed.
- Bars 4–5 remain unsuppressed.
- stock settings remain untouched.
- replacement defaults OFF after reload.

## Next Action

Install/review/commit/push P0044.

Because runtime code changes, deploy explicitly:

```bash
cd ~/Projects/logres

WOW_ROOT="/mnt/c/Program Files (x86)/World of Warcraft"
ADDONS="$WOW_ROOT/_classic_beta_/Interface/AddOns"

./tools/deploy_logres.sh "$ADDONS"
```

Then `/reload`.

Confirm `0.0.20-dev`.

Use:
- Run All;
- Stock Replace Check;
- Stock Replace ON;
- Stock Replace OFF.

Proof:
1. OFF baseline PASS;
2. ON hides only stock Bars 2–3;
3. Primary and Bars 4–5 remain visible;
4. no invisible stock mouse zones;
5. Secondary/Utility keys route through Logres with activation feedback;
6. OFF restores stock Bars 2–3 and prior routing;
7. combat ON/OFF request defers until combat ends;
8. no protected/taint/Lua/secret errors.

Do not change Blizzard Edit Mode/action-bar configuration during this first
proof.

## Success Criteria

P0044 succeeds when:
- selective ON/OFF is reversible;
- routing and suppression remain coupled;
- stock mouse interaction is removed while suppressed;
- restoration is exact;
- combat deferral works;
- unsupported bars remain accessible;
- no protected/taint/Lua/secret regression occurs.

## Do Not Reopen Without New Evidence

- **C.1–C.4:** complete.
- **D-023:** first replacement scope is canonical.
- **MainActionBar suppression:** deferred.
- **Bars 4–5 suppression:** deferred.
- **Persistence:** deferred until restoration proof.
- **Stock settings:** untouched.
- **Cast cue colors:** open visual debt.
- **Git authority:** user performs commits/pushes.

## Relevant References

- `docs/memory/evidence/C5_P0044_SELECTIVE_REPLACEMENT_IMPLEMENTATION_2026-10-01.md`
- `docs/memory/decisions/D-023_SELECTIVE_STOCK_ACTION_REPLACEMENT.md`
- `docs/memory/investigations/C5_STOCK_ACTION_BAR_REPLACEMENT.md`
- `Logres/Actions/StockReplacement.lua`
- `tools/check_stock_replacement_contract.py`
