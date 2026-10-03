# D-034 — Selective Hybrid E and visual-component direction

Status: ACCEPTED — WORKING ART DIRECTION
Date: 2026-10-02

## Decision

Refine D-033's World Ghost hypothesis into a more specific working art anchor:
**Selective Hybrid E**.

Core rule:

**thematic for meaning; restrained for interaction.**

Use stronger authored Logres / Warcraft-native treatment where an element
carries narrative, navigational, or perceptual meaning. Keep repeated,
high-density interaction surfaces simple enough that the world and action
icons remain dominant.

Canonical component inventory:
`../architecture/VISUAL_COMPONENT_INVENTORY.md`.

Supporting visual-system record:
`../architecture/VISUAL_SYSTEM_DIRECTION.md`.

## Selective Hybrid E

The current preferred split is:

Authored / thematic emphasis:
- Compass and navigation identity;
- Active Quest presentation;
- player-health perceptual treatment / health tunnel;
- selected narrative/context accents and restrained heraldic ornament.

Simple / interaction-heavy treatment:
- Primary action buttons;
- Secondary action buttons;
- Utility action buttons;
- pet / stance / form / totem / other high-density controls;
- compact status and information-dense surfaces.

This is not permission to turn the health tunnel into a conventional player
health bar. Player health remains the established peripheral pressure system.
The D-style influence applies to the *art treatment of that effect*, not to a
health-meter redesign.

## Percentage-bar primitive

Future Logres-owned presentation of a value whose meaning is fundamentally a
percentage should normally converge on a **compact bar with percentage text**.

Expected consumers include, where Logres deliberately owns the presentation:
- player primary resource percentage;
- pet health percentage;
- party-member health percentage;
- detached/fallback target health percentage;
- world-target health percentage if/when that capability is implemented;
- later percentage-based resource/condition surfaces accepted by design.

Exceptions / boundaries:
- player health remains the health tunnel/perceptual-pressure system by default;
- discrete class mechanics such as runes, combo points, stance/form state, or
  totems are not forced into percentage bars merely for visual consistency;
- stock Blizzard surfaces remain stock until separately replaced.

This is a presentation direction, not an authorization to inspect
secret-capable values in Lua. Existing secret-safe transport remains
mandatory. A future bar implementation must bind/fill through a native-safe
path and must not branch, compare, stringify, persist, or perform ordinary Lua
arithmetic on secret-capable values.

## Density rule

Art studies must use realistic control density.

The current ordinary action proof can show 36 Logres buttons simultaneously:
12 Primary + 12 Secondary + 12 Utility. Visual concepts that work only with a
small illustrative action row are not sufficient evidence for final styling.

Therefore:
- action-button ornament should remain restrained;
- group-level composition may carry more identity than each individual button;
- interaction feedback must remain immediately legible at full density.

## Art-workstream boundary

D-034 is parallel visual planning.

It does not:
- change G.3 runtime scope;
- modify Lua behavior;
- claim that future bars/world-target/status systems are implemented;
- waive capability, secret-value, combat-lockdown, restoration, or fail-open
  requirements.

Component studies, style boards, texture/effect exploration, and high-fidelity
mockups may proceed now under this direction.
