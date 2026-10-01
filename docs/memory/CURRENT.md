---
memory_schema: 1
as_of: 2026-10-01
project: logres
---

# Current State

## Active Objective

**Phase C — Action Interface.**

## Current Work Item

**C.3 — Secondary / Utility Clusters.**

P0036 implementation is prepared.

## Verified State

- Phase 0 complete.
- Phase A complete.
- Phase B complete.
- C.1 complete.
- C.2 complete.
- P0035 pushed at `fccaabd`.
- primary secure cluster remains proven.
- cast/channel cue color loss remains open visual debt.
- P0036 static action contract passes.
- Secondary candidate domain: slots 61–72 /
  MULTIACTIONBAR1BUTTON1–12.
- Utility candidate domain: slots 49–60 /
  MULTIACTIONBAR2BUTTON1–12.
- stock bars remain visible.

## Next Action

Install/review/commit/push P0036.

Because runtime code changes, deploy explicitly:

```bash
cd ~/Projects/logres

WOW_ROOT="/mnt/c/Program Files (x86)/World of Warcraft"
ADDONS="$WOW_ROOT/_classic_beta_/Interface/AddOns"

./tools/deploy_logres.sh "$ADDONS"
```

Then `/reload`.

Confirm:
- version `0.0.16-dev`;
- Run All / Action Check PASS;
- three clusters visible.

Runtime:
1. Primary mouse/key regression check;
2. Secondary maps expected stock Action Bar 2 actions;
3. Utility maps expected stock Action Bar 3 actions;
4. mouse execution on both new clusters;
5. Secondary Keys ON/OFF routing if keys exist;
6. Utility Keys ON/OFF routing if keys exist;
7. cooldown/range/count/usability behavior;
8. ordinary combat execution;
9. no protected/taint/Lua/secret error;
10. layout/readability with Phase B HUD.

If current Forever slot or binding mapping differs from D-019, record the
exact mismatch rather than forcing the source-derived assumption.

## Success Criteria

C.3 succeeds when:
- both fixed-slot domains map correctly;
- mouse execution works on both;
- keyboard routing is proven where bindings are available;
- release/fail-open behavior works;
- Primary remains regression-free;
- shared action-button primitive causes no regression;
- no protected/taint/Lua/secret errors occur;
- layout is usable;
- stock bars remain visible.

## Do Not Reopen Without New Evidence

- **C.1:** complete.
- **C.2:** complete.
- **P0032 failure:** retained.
- **Cast cue colors:** open visual debt.
- **C.3 slot/binding mapping:** source-derived until runtime-proven.
- **Bars 4–8:** not represented.
- **Dynamic visibility:** C.4.
- **Stock bars:** remain visible.
- **Git authority:** user performs commits/pushes.

## Relevant References

- `docs/memory/evidence/C3_SECONDARY_UTILITY_SOURCE_REVIEW_2026-10-01.md`
- `docs/memory/decisions/D-019_SECONDARY_UTILITY_CLUSTER_CONTRACT.md`
- `docs/memory/investigations/C3_SECONDARY_UTILITY_CLUSTERS.md`
- `docs/memory/architecture/ACTION_CLUSTERS.md`
- `Logres/Actions/Button.lua`
- `Logres/Actions/Primary.lua`
- `Logres/Actions/SecondaryUtility.lua`
- `tools/check_action_contract.py`
