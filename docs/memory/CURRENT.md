---
memory_schema: 1
as_of: 2026-10-01
project: logres
---

# Current State

## Active Objective

**Phase B — Core HUD.**

## Current Work Item

**B.2 — Resource Presentation.**

P0021 prepares the production primary-resource percentage.

Secret-safe path:

```text
UnitPowerPercent("player", nil, false, nativeScaleTo100Curve)
    -> FontString:SetFormattedText("%.0f%%", secretPercent)
```

No Lua arithmetic/comparison/stringification is performed on the resource percentage.

## Verified State

- Phase A complete.
- B.1 complete.
- P0020 B.1 closure pushed at `893ab6c`.
- current runtime baseline before P0021: `0.0.8-dev`.
- current Forever docs confirm `UnitPowerPercent` on Forever 1.60.1.
- native percentage curves use normalized 0–1 input.
- `FontString:SetFormattedText` accepts secret arguments.
- `UNIT_POWER_FREQUENT` and `UNIT_MAXPOWER` provide the required update signals.
- P0021 source/static checks are prepared; runtime proof pending.

## Next Action

Install/review/commit/push P0021.

Because runtime code changes, deploy explicitly:

```bash
WOW_ROOT="/mnt/c/Program Files (x86)/World of Warcraft"
ADDONS="$WOW_ROOT/_classic_beta_/Interface/AddOns"

./tools/deploy_logres.sh "$ADDONS"
```

Then:

```text
/reload
/logres status
/logres statecheck
/logres preferencecheck
/logres lifecyclecheck
/logres hudcheck
```

Confirm version:
`0.0.9-dev`

Runtime B.2:
1. confirm a lower-center percentage is visible;
2. spend/gain the current primary resource and confirm it updates;
3. `/logres immersion off` hides HUD/resource;
4. `/logres immersion on` restores HUD/resource with current percentage;
5. report any Lua/secret error;
6. report whether the text placement/size is usable as a first pass.

No travel is required.

## Success Criteria

B.2 succeeds when:
- primary resource percentage renders;
- it updates while resource changes;
- no secret-value/Lua errors occur;
- immersion off/on hides/restores it;
- no conventional resource bar exists;
- HUD structural check remains green;
- current-character primary-resource path is runtime proven;
- untested form/class switching is recorded rather than assumed.

## Do Not Reopen Without New Evidence

- **B.1:** complete.
- **Resource secret path:** D-012 + D-008.
- **No Lua scaling:** native curve handles 0–100 conversion.
- **No resource bar:** percentage-only default.
- **Secondary resources:** outside initial B.2.
- **Deployment:** full deploy block required.
- **Git authority:** user performs commits/pushes.

## Relevant References

- `docs/memory/decisions/D-012_RESOURCE_PRESENTATION_CONTRACT.md`
- `docs/memory/investigations/B2_RESOURCE_PRESENTATION.md`
- `docs/memory/decisions/D-008_SECRET_SAFE_HEALTH_AND_RESOURCE_PATH.md`
- `docs/memory/architecture/HUD.md`
- `Logres/HUD/HUD.lua`
- `tools/check_hud_contract.py`
