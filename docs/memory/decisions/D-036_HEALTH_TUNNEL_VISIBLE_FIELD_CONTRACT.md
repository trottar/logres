# D-036 — Health Tunnel Visible-Field Contract

Status: ACCEPTED — FROZEN VISUAL CONTRACT
Date: 2026-10-03

## Decision

Player health remains a perceptual world-visibility system, not a conventional
health meter.

The accepted visual endpoint is a continuous health-tunnel progression in which
remaining health roughly corresponds to the remaining clear/usable visual field:

**100% health -> approximately full clear field**

through

**0% health -> effectively collapsed clear field / death transition.**

The relationship is intentionally perceptual rather than a literal pixel mask.
High-health ranges may ease gently so ordinary injury is noticeable without
unnecessarily obscuring play. As health becomes critical, the relationship
becomes much more direct and the usable field collapses aggressively.

## Accepted perceptual mapping

The approved working targets are approximately:

| Health | Clear / comfortable visual field |
| ---: | ---: |
| 100% | ~100% |
| 80% | ~85–90% |
| 70% | ~80–85% |
| 60% | ~70–75% |
| 50% | ~60–65% |
| 40% | ~45–50% |
| 30% | ~30–35% |
| 20% | ~20–25% |
| 15% | ~10–15% |
| 5% | ~5–8% |
| 0% | effectively collapsed |

These are visual calibration targets, not authorization for Lua to inspect or
branch on health percentages.

## Shape and composition

The final art direction replaces the current procedural rectangular-band look
with an organic peripheral tunnel/vignette:
- pressure begins at the outer edge and moves inward;
- the center gameplay field stays clean as long as possible;
- the contour is soft and slightly irregular rather than a perfect circle;
- asymmetry may be present but should remain visually balanced;
- critical/near-death states narrow the usable center dramatically;
- the effect must not become a decorative frame.

Reject:
- hard circular apertures;
- blood splatter;
- veins;
- scratches/gore motifs;
- red fog covering the scene;
- giant warning ornaments;
- centered numeric health warnings.

## Color and perceptual channels

Primary progression channels are:
- decreasing clear-field area;
- increasing peripheral darkness;
- increasing peripheral desaturation / loss of clarity;
- restrained injury color;
- optional restrained motion only at critical states.

Color direction:
- healthy / outer pressure: charcoal to near-black;
- injury: dark, cold, muted crimson/burgundy embedded in the darkness;
- critical: deeper crimson/burgundy plus heavier charcoal;
- near death: predominantly black/charcoal with restrained burgundy near the
  remaining clear field.

Injury color must remain visually distinct from:
- Rage red-orange;
- hostile target red;
- bright generic damage-screen red.

The effect must not depend on red alone. Darkness, visible-field width,
desaturation, peripheral clarity, and critical motion provide redundant cues.

## Motion

Accepted motion policy:
- healthy / ordinary injury: no decorative motion;
- critical: at most extremely restrained slow pressure/breathing;
- near death: a slow, low-amplitude pulse may be used;
- no rapid flashing, shake, or high-frequency alarm animation.

## Runtime relationship

The existing B.1 secret-safe transport remains authoritative:

`UnitHealthPercent` -> native `CurveObject` -> secret-capable `Texture:SetAlpha`.

Lua must not:
- compare health thresholds;
- stringify or log secret-capable health;
- persist the value;
- perform ordinary arithmetic on it.

The current four production layers and their approximate trigger regions remain
valid implementation evidence, but their procedural rectangular bands are visual
polish debt. D-036 freezes the intended art/perceptual endpoint, not a specific
Lua implementation technique.

Any implementation of the continuous visible-field treatment must preserve the
native secret-safe transport and capability/fail-open rules.

## Scope

D-036 freezes the player-health visual direction.

It does not:
- add a conventional player health bar;
- add numeric player health;
- authorize new secret-value handling;
- require deliberate near-death gameplay solely for validation;
- claim that the final masks/assets are already implemented.
