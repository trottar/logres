# B.1 — HUD Root + Player Health Vignette

Status: ACTIVE — P0018 VISUAL FAILURE; P0019 FIX PREPARED
Opened: 2026-09-30

## Goal

Move the secret-safe player-health transport proven by I-001 into the real production HUD module.

## P0018 result

P0018 was pushed at:

`fa342adaf21230d1ad56a83e627084b386a60527`

Runtime observation:
the intended vignette was not perceptible through ordinary injury.

The only red pulse noticed occurred at very low health and may have been Blizzard's own effect.

Therefore B.1 remains open.

Canonical evidence:
`../evidence/B1_HEALTH_VIGNETTE_RUNTIME_PASS01_2026-09-30.md`

## Curve scale

Verified:
health percentage curve input is normalized 0–1.

P0018's 0.70/0.50/0.30/0.15 x points were correctly scaled.

## P0019 hypothesis

The P0018 visual amplitudes/colors were too weak.

P0019:
- strengthens edge alpha curves;
- strengthens the injury-red color;
- keeps the same secret-safe transport;
- adds a fixed `/logres hudpreview on|off` presentation.

## P0019 runtime plan

At full health:

```text
/logres hudpreview on
```

A clear static multi-band edge treatment must appear.

Then:

```text
/logres hudpreview off
```

It must disappear and return control to health-driven curves.

Only after preview proves geometry:
- take ordinary safe damage;
- observe whether health-driven edge pressure now appears in the intended 70–50 / 50–30 progression;
- test immersion off/on while injured;
- heal and observe recession.

No near-death test required.

## Decision tree

### Preview invisible

Investigate frame/root/draw-layer presentation.

### Preview visible, health-driven invisible

Investigate health event / curve / secret SetAlpha production path.

### Preview visible, health-driven visible

P0018 was a visual tuning failure. Continue B.1 refinement from P0019.

## Exit

B.1 remains open until the production health-driven vignette is visibly proven.
