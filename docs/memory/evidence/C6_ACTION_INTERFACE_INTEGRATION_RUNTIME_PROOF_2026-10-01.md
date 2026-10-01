# C.6 Action Interface Integration Runtime Proof — 2026-10-01

Status: VERIFIED
Runtime baseline: `0.0.20-dev`
Documentation baseline: `e3c8602c91341db4f2559300e93bd8680d9fffac`

## Result

The user ran the integrated Phase C validation and reported:

> Everything works, but I did need to manually turn on action key again.

The integrated action interface therefore passes for the tested workflow.

## Verified integrated behavior

The accepted C.6 result includes:
- normal world action presentation;
- contextual Primary / Secondary / Utility weighting;
- mouse secure execution;
- routed keyboard execution;
- action activation feedback;
- combat behavior;
- PvP modifier behavior;
- selective stock Bar 2–3 replacement;
- stock Bar 2–3 restoration;
- coexistence with the Phase B HUD.

No protected-action, taint, Lua, or secret-value error was reported.

## Primary Action Keys after reload

The manual `Action Keys ON` step is **expected current behavior**, not a
regression.

Current Primary routing is intentionally session-only and defaults OFF after
reload.

Reason:
- Blizzard Primary remains visible and usable;
- MainActionBar suppression is not yet supported;
- Logres therefore must not automatically seize `ACTIONBUTTON1–12` on reload
  merely because the addon loaded.

Current behavior:

```text
reload
-> Blizzard Primary remains available
-> Logres Primary routing OFF
-> player may opt into Action Keys ON for Logres-routed Primary feedback
```

This preserves the fail-open principle established by L-011.

## Replacement routing distinction

Secondary/Utility routing differs when selective stock replacement is active.

`Stock Replace ON` owns the matching Secondary/Utility routing because those
stock surfaces are being replaced.

Primary has no equivalent replacement ownership yet.

Therefore:
- manual Primary Action Keys after reload: expected;
- automatic Secondary/Utility routing under Bar 2–3 replacement: required.

## Future gate

When Logres eventually supports Primary stock replacement, Primary routing must
become automatic and atomic with that replacement transaction.

It must **not** simply become globally automatic on reload before Primary stock
replacement and special-state fallback are proven.

## Deferred capabilities remain deferred

C.6 does not claim:
- MainActionBar suppression;
- vehicle/override/form replacement;
- Bars 4–5 replacement;
- persistent stock replacement;
- live action move/swap/remove editing.

## Conclusion

**C.6 — COMPLETE.**

**Phase C — Action Interface — COMPLETE.**
