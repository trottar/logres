# C.2 — Primary Action Cluster

Status: P0032 RUNTIME FAILED; P0033 FIX PREPARED
Opened: 2026-10-01

## P0032 result

Baseline:
`9f9f97d`

Passed:
- cluster rendering;
- ordinary action presentation;
- out-of-range tint.

Failed:
- mouse secure action execution;
- automatic routed key execution.

The automatic routing failure also made the normal primary keys unusable.

Canonical failure:
`../evidence/C2_P0032_RUNTIME_FAILURE_2026-10-01.md`

## P0033 fix

Secure buttons now use:
- `type = action`;
- `typerelease = actionrelease`;
- `AnyUp`;
- `LeftButtonDown`;
- `RightButtonDown`;
- self/focus/mouseover cast checks.

Internal `1–12` labels are removed.

## Key-routing safety

Default:
**Action Keys OFF**

The stock ACTIONBUTTON commands remain active normally.

Logres reads and displays the existing key labels but does not intercept them.

Developer panel adds:
- Action Keys ON;
- Action Keys OFF.

Action Keys ON installs temporary override clicks out of combat.

Action Keys OFF clears them out of combat.

A requested routing change during combat is deferred until
`PLAYER_REGEN_ENABLED`.

## Retry

Test both execution paths in the same pass:

1. confirm `0.0.15-dev`;
2. Run All / Action Check PASS;
3. confirm duplicate `1–12` labels are gone;
4. with Action Keys OFF, confirm normal stock keys work;
5. click Logres actions directly;
6. turn Action Keys ON;
7. test existing keyboard bindings through Logres;
8. turn Action Keys OFF and confirm normal stock keys remain usable;
9. repeat mouse/key execution in ordinary combat;
10. confirm range/cooldown/count presentation;
11. report any protected/taint/Lua/secret error.

## Exit

C.2 remains open until mouse + keyboard secure execution both pass.
