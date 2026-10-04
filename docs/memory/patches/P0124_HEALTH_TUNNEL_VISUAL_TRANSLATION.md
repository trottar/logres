# P0124 — Organic Player-Health Tunnel + Deterministic Preview Matrix

Date: 2026-10-04
Result: **PREPARED — RUNTIME + VISUAL PROOF PENDING**
Baseline: `1721eb4dac7bb90057de5666767f2736bc48fdc6`
Runtime: `0.0.53-dev -> 0.0.54-dev`

## Purpose

Replace the B.1 procedural rectangular player-health bands with the approved
D-036 / D-039 organic peripheral tunnel while preserving the already-proven
secret-safe live-health transport.

This checkpoint also records P0123 Compass runtime + visual PASS.

Camera work remains frozen. P0124 does not modify Camera source, Phase G/G.5
investigations/evidence, `CURRENT.md`, or `CURRENT_HANDOFF.md`.

## Production health-tunnel media

P0124 adds five full-screen alpha-mask derivatives under `Logres/Media/Health/`:

- `health_outer.tga` — broad soft charcoal edge pressure;
- `health_injury.tga` — wider cold-burgundy injury pressure;
- `health_critical.tga` — substantially narrower critical aperture;
- `health_near_death.tga` — severe narrow central tunnel;
- `health_death.tga` — death-only effective clear-field collapse.

The first four masks are soft, slightly irregular superellipse-like apertures.
They avoid a hard circular hole, gore, blood splatter, veins, warning chrome, and
red fog. The death layer exists only to satisfy D-036's 0% effective-collapse
endpoint without making the near-death aperture itself a full-screen opaque fill.

`Theme.lua` owns asset paths and tint families.

## Live secret-safe path

The live production path remains:

```text
UnitHealthPercent("player", true, nativeCurve)
    -> Texture:SetAlpha(secret)
```

Lua still does not:

- compare live health thresholds;
- stringify/log live health;
- persist live health;
- perform arithmetic on the secret-capable live value.

The five native curves perform the health-to-alpha mapping inside the client and
their opaque results are forwarded directly to the matching texture.

## Deterministic preview matrix

D-036's calibration anchors are now directly previewable without deliberate
damage.

Supported ordinary developer-supplied preview values:

`100 / 80 / 70 / 60 / 50 / 40 / 30 / 20 / 15 / 5 / 0`

Command:

```text
/logres healthpreview <percent>
/logres healthpreview off
```

The Phase-B developer panel exposes the complete calibration matrix directly:

- 100%;
- 80%;
- 70%;
- 60%;
- 50%;
- 40%;
- 30%;
- 20%;
- 15%;
- 5%;
- 0%;
- Live/off.

The panel is the normal validation path; manual slash-command entry is not
required for the health progression.

Preview percentages are ordinary developer inputs used only by an isolated
presentation sampler. They never query, inspect, transform, or replace live
player health.

The legacy `/logres hudpreview on|off` remains available and maps `on` to the
30% deterministic preview for compatibility.

## Validation gate

In client:

1. `/logres hudcheck` PASS on `0.0.54-dev`.
2. In Phase B of the developer panel, click every Health preview state from 100% through 0%, then Health Live.
3. Confirm 100% is effectively clear and ordinary injury enters softly from the
   periphery.
4. Confirm 50–30% progressively narrows the usable field without becoming a
   decorative frame or red fog.
5. Confirm 20–5% creates severe but still readable critical tunnel pressure.
6. Confirm 0% effectively collapses the clear field.
7. `/logres healthpreview off` restores the real live-health path immediately.
8. Immersion OFF hides the tunnel; ON restores the current live-health state.
9. Normal safe damage/healing, if naturally convenient, confirms the live path
   still moves in the same direction.
10. Any Lua, secret-value, taint, or protected-action error is a failure.

Deliberately forcing near-death gameplay is not required because the preview
matrix exists specifically to avoid that validation requirement.
