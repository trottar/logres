# C.5 P0044 Selective Replacement Implementation — 2026-10-01

Status: IMPLEMENTATION PREPARED; RUNTIME PROOF NEXT
Date: 2026-10-01

## Scope

P0044 implements D-023 for:
- stock Bar 2 / `MultiBarBottomLeft`;
- stock Bar 3 / `MultiBarBottomRight`.

Not suppressed:
- MainActionBar;
- OverrideActionBar;
- Bars 4–5;
- stance/possess/special action surfaces.

## Replacement behavior

ON:
- captures stock alpha/mouse state;
- captures prior Secondary/Utility routing;
- enables matching Logres routing first;
- then makes stock Bars 2–3 transparent and mouse-inert.

OFF:
- restores captured stock alpha/mouse state;
- restores prior Secondary/Utility routing.

Combat ON/OFF requests defer until `PLAYER_REGEN_ENABLED`.

Replacement defaults OFF after reload.

Manual Secondary/Utility Keys OFF is blocked while replacement owns that
routing domain.

## Runtime proof

1. confirm `0.0.20-dev`;
2. Run All PASS with replacement OFF;
3. Stock Replace ON;
4. Bars 2–3 disappear;
5. Primary and Bars 4–5 remain visible;
6. former Bar 2–3 regions do not intercept mouse;
7. Secondary/Utility keys route through Logres and show activation feedback;
8. Stock Replace Check PASS;
9. Stock Replace OFF restores Bars 2–3 and prior routing;
10. combat-time ON/OFF requests defer and apply after combat;
11. no protected/taint/Lua/secret errors.

Do not edit Blizzard action-bar layout/settings during this first proof.
