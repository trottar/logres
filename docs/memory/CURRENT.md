---
memory_schema: 1
as_of: 2026-09-30
project: logres
---

# Current State

## Active Objective

**Phase B — Core HUD.** Build Logres' identity-defining awareness layer on top of the completed Phase A contracts.

## Current Work Item

**B.1 — HUD root + player health vignette.**

P0018 prepares the first real HUD module.

Implementation:
- `HUD` module via D-011;
- `LogresHUDRoot`;
- four native curve-driven edge bands;
- 16 procedural textures;
- secret health transported directly from `UnitHealthPercent(..., curve)` to `Texture:SetAlpha`;
- player health event refresh;
- `immersionEnabled` visibility integration;
- `/logres hudcheck`;
- static secret-boundary checker.

No conventional health bar or numeric player health is added.

## Verified State

- Phase 0 complete.
- Phase A complete.
- P0017 Phase A closure pushed at `840b40f`.
- D-008 runtime evidence proves custom curves + secret texture alpha work on Forever.
- current public API documentation still shows `UnitHealthPercent(unit, usePredicted, curve)` and `C_CurveUtil.CreateCurve()` on Forever 1.60.1.
- P0018 source/static validation is prepared but production HUD runtime proof is pending.

## Next Action

Install/review/commit/push P0018.

Because runtime addon code changes, explicitly deploy:

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

Confirm version `0.0.7-dev`.

Visual proof:
1. at healthy health, vignette should be effectively absent;
2. take ordinary safe damage until the edge effect becomes visible;
3. while injured, turn immersion off and confirm it hides;
4. turn immersion on and confirm current injury effect returns;
5. heal/eat and confirm the effect recedes/disappears.

Do not intentionally approach near death for this test.

## Success Criteria

B.1 succeeds when:
- `HUD` module loads and `/logres hudcheck` passes;
- existing state/preference/lifecycle checks remain green;
- healthy state is unobtrusive;
- ordinary damage visibly increases edge pressure;
- healing reduces/removes the effect;
- immersion off/on cleanly hides/restores presentation;
- no secret-value/Lua errors occur;
- no player health numbers/bar are introduced;
- any visual tuning limitation is recorded separately from transport correctness.

## Do Not Reopen Without New Evidence

- **Phase A:** complete.
- **Health path:** D-008 native secret-safe transport only.
- **No Lua health thresholds:** thresholds live in native curves.
- **Player health UI:** vignette, not conventional bar/numbers.
- **Preferences:** D-010.
- **Lifecycle:** D-011.
- **Actions:** Phase C, not B.1.
- **Deployment:** full deploy block required for runtime-code tests.
- **Git authority:** user performs commits/pushes.

## Relevant References

- `docs/memory/investigations/B1_HEALTH_VIGNETTE.md`
- `docs/memory/decisions/D-002_PLAYER_HEALTH_PRESENTATION.md`
- `docs/memory/decisions/D-008_SECRET_SAFE_HEALTH_AND_RESOURCE_PATH.md`
- `docs/memory/architecture/HUD.md`
- `docs/memory/evidence/I001_RUNTIME_PASS_02_2026-09-30.md`
- `Logres/HUD/HUD.lua`
- `tools/check_hud_contract.py`
