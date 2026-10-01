---
memory_schema: 1
as_of: 2026-10-01
project: logres
---

# Current State

## Active Objective

**Phase C — Action Interface.**

## Current Work Item

**C.4 — Contextual Visibility / Secure Paging.**

P0039 runtime implementation is prepared.

## Verified State

- Phase 0 complete.
- Phase A complete.
- Phase B complete.
- C.1 complete.
- C.2 complete.
- C.3 complete.
- P0038 pushed at `1dbc3cf`.
- runtime baseline before P0039: `0.0.16-dev`.
- P0039 version: `0.0.17-dev`.
- D-021 is canonical.
- P0039 static action/context contracts pass.
- contextual policy uses non-zero alpha only.
- Primary normal execution uses secure ID/actionpage driver.
- Primary presentation follows the same normal-page driver.
- special paging coverage remains `normal-pages-only`.
- stock Blizzard bars remain visible.
- cast/channel cue color regression remains open visual debt.

## Next Action

Install/review/commit/push P0039.

Because runtime code changes, deploy explicitly:

```bash
cd ~/Projects/logres

WOW_ROOT="/mnt/c/Program Files (x86)/World of Warcraft"
ADDONS="$WOW_ROOT/_classic_beta_/Interface/AddOns"

./tools/deploy_logres.sh "$ADDONS"
```

Then `/reload`.

Use the diagnostics panel:
- Run All;
- Action Check.

Confirm version:
`0.0.17-dev`.

Test:
1. world idle alpha weighting;
2. faded Secondary/Utility remain usable;
3. combat raises Secondary/Utility;
4. PvP modifier outside combat if convenient;
5. instance idle if naturally available;
6. normal Primary page switching;
7. icon/presentation follows page;
8. mouse/key execution matches displayed action;
9. normal page switching does not require combat end;
10. no protected/taint/Lua/secret errors.

Do not force bonus/form/vehicle/override/possess scenarios.

Those remain explicit capability gates with stock fallback.

## Success Criteria

C.4 P0039 succeeds when:
- world/combat context alpha works;
- PvP alpha works if available or is explicitly deferred;
- instance alpha works if available or is explicitly deferred;
- faded controls remain usable;
- normal Primary paging is secure and presentation-synchronized;
- no protected/taint/Lua/secret error occurs;
- unsupported special states retain safe stock fallback.

## Do Not Reopen Without New Evidence

- **C.1:** complete.
- **C.2:** complete.
- **C.3:** complete.
- **D-020:** current geometry provisional.
- **D-021:** canonical C.4 contract.
- **Alpha zero:** rejected.
- **Special paging:** not claimed in P0039.
- **Stock bars:** remain visible.
- **Cast cue colors:** open visual debt.
- **Git authority:** user performs commits/pushes.

## Relevant References

- `docs/memory/evidence/C4_CONTEXT_VISIBILITY_SECURE_PAGING_SOURCE_REVIEW_2026-10-01.md`
- `docs/memory/decisions/D-021_ACTION_CONTEXT_AND_SECURE_PAGING_CONTRACT.md`
- `docs/memory/investigations/C4_CONTEXTUAL_VISIBILITY_SECURE_PAGING.md`
- `docs/memory/architecture/ACTION_CLUSTERS.md`
- `Logres/Actions/Context.lua`
- `Logres/Actions/Primary.lua`
- `Logres/Actions/Button.lua`
- `tools/check_action_context_contract.py`
