# B.1 Health Vignette Runtime Proof — 2026-10-01

Status: VERIFIED
Final tested baseline: `5ae500d2fa5deb676d0ab2668df548270543025b`

## Background

P0018 introduced the production HUD health-vignette path but its first visual tuning was not perceptible during ordinary injury.

That result remains preserved in:

`B1_HEALTH_VIGNETTE_RUNTIME_PASS01_2026-09-30.md`

P0019 retained the same secret-safe transport while strengthening curve outputs/source color and adding a fixed preview command.

## Runtime result

The user reported that P0019 works.

Observed:
- the rough Logres edge rectangles are visible;
- the vignette progresses as health decreases;
- `/logres immersion off` hides the vignette while injured;
- `/logres immersion on` restores the current injury presentation;
- healing causes the vignette to recede/disappear.

No new runtime error was reported in the tested scope.

## Secret-safe transport

Production path remains:

```text
UnitHealthPercent("player", true, curve)
    -> secret native curve result
    -> Texture:SetAlpha(secret)
```

The runtime progression establishes that this transport works in the production HUD module, not only in the earlier API audit.

No Lua threshold comparison/arithmetic over player health was introduced.

## Preference/lifecycle integration

Runtime behavior verifies:
- HUD presentation is controlled by `immersionEnabled`;
- disabling immersion hides the root presentation without corrupting health state;
- re-enabling immersion refreshes the current health presentation;
- Phase A preference/lifecycle boundaries remain usable by the real HUD module.

## Visual quality

The current health vignette uses procedural solid rectangular edge bands.

The user described them as rough rectangles.

Classification:

**VISUAL POLISH DEBT — NOT B.1 ARCHITECTURE FAILURE**

Future work may replace/tune:
- solid rectangles;
- edge shapes;
- gradients/masks;
- near-death treatment;
- exact color/opacity.

The secret-safe transport and module boundary should remain unchanged unless new evidence requires otherwise.

## P0018 negative result

P0018 remains a durable tuning failure:
- transport architecture was technically plausible;
- initial production alpha/color tuning was not perceptible enough.

P0019 resolved the usability issue sufficiently to prove B.1.

## Conclusion

B.1 success criteria are satisfied.

**B.1 — HUD root + player health vignette: COMPLETE.**
