# B.1 — HUD Root + Player Health Vignette

Status: IMPLEMENTATION PREPARED; RUNTIME PROOF NEXT
Opened: 2026-09-30

## Goal

Move the secret-safe player-health transport proven by I-001 into the real production HUD module.

## Production path

```text
UnitHealthPercent("player", true, curve)
    -> secret curve-evaluated alpha
    -> Texture:SetAlpha(secret)
```

No Lua health threshold logic.

## Implementation

P0018 adds:
- `Logres/HUD/HUD.lua`;
- real `HUD` lifecycle module;
- full-screen `LogresHUDRoot`;
- four native curve-driven edge bands;
- 16 procedural edge textures;
- player UNIT_HEALTH / UNIT_MAXHEALTH refresh;
- `immersionEnabled` presentation gating;
- `/logres hudcheck`;
- `tools/check_hud_contract.py`.

## Visual model

The initial layer model maps the intended thresholds in native curves:
- ~70%: dark outer edge begins;
- ~50%: red layer begins;
- ~30%: wider critical pressure begins;
- ~15%: widest near-death layer begins.

These thresholds are encoded as curve points, not Lua comparisons.

## Runtime plan

After deploy:

```text
/reload
/logres status
/logres statecheck
/logres preferencecheck
/logres lifecyclecheck
/logres hudcheck
```

Confirm version:
`0.0.7-dev`

Then:
1. observe healthy screen — vignette should be absent;
2. take ordinary safe damage until edge pressure becomes clearly visible;
3. if practical, take somewhat more damage but do not intentionally approach death;
4. while still injured, `/logres immersion off` — vignette should hide;
5. `/logres immersion on` — current injury vignette should return;
6. heal/eat — vignette should reduce and disappear as health recovers.

## Evidence discipline

If:
- curve creation errors;
- SetAlpha rejects the secret value;
- health events do not update;
- immersion toggling leaves stale visuals;
- the visual thresholds are clearly unusable;

record the exact result before changing architecture.

Visual tuning is not the same as transport failure.

## Exit

B.1 can complete when:
- the production secret-safe path works;
- the HUD module/lifecycle/persistence boundaries behave;
- the visual is usable enough for continued development;
- any art/tuning limitations are explicitly recorded.
