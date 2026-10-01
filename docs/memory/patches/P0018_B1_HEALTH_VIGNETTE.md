# P0018 — B.1 production health vignette

Date: 2026-09-30
Result: PREPARED — runtime proof pending

## Intent

Move the I-001 secret-safe player-health proof into real Logres production HUD code.

## Runtime code

Adds:

`Logres/HUD/HUD.lua`

Registers:
`HUD`

## Secret-safe transport

```text
UnitHealthPercent("player", true, curve)
    -> Texture:SetAlpha(secret)
```

No Lua arithmetic/comparison/stringification over player health.

## Visual implementation

Initial procedural model:
- 4 edge bands;
- 16 textures;
- native linear curves encode 70/50/30/15-ish danger progression;
- wider inner layers appear only as native curve output rises.

This is architecture-first visual treatment. Exact styling remains tunable.

## Events

Player-only:
- UNIT_HEALTH;
- UNIT_MAXHEALTH.

## Preference

`immersionEnabled=false` hides the HUD root.

Re-enabling immersion shows the root and refreshes current health.

## Development validation

Adds:

```text
/logres hudcheck
```

and:

`tools/check_hud_contract.py`

The checker rejects obvious fallback to:
- UnitHealth arithmetic;
- UnitHealthMax arithmetic;
- health persistence;
- Lua inspection of the secret-derived alpha.

## Version

`0.0.6-dev -> 0.0.7-dev`

## Runtime proof

After deployment:
- confirm version 0.0.7-dev;
- all existing contract checks pass;
- hudcheck passes;
- healthy state has no visible edge pressure;
- ordinary safe damage produces the vignette;
- immersion off hides it;
- immersion on restores current injury presentation;
- healing reduces/removes it.

Do not deliberately test near-death.

## Runtime claim

None yet.
