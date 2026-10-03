# Visual System Direction

Canonical decision:
`../decisions/D-033_PARALLEL_ART_DIRECTION_AND_WORLD_GHOST.md`.

## Purpose

This record captures how Logres should approach visual/style development before
and alongside later Phase H implementation.

It is not an implementation contract for Lua APIs. It is a design-direction
record for mockups, assets, and style-system planning.

## Current style hypothesis — World Ghost

The current preferred direction is **World Ghost**.

Desired qualities:
- simple;
- immersive;
- world-first;
- native to Blizzard / Warcraft visual language;
- lightly mythic with a subtle Logres / Camelot inflection;
- restrained and composed rather than maximal or glossy;
- able to recede so the world remains dominant.

In practical terms this suggests:
- low-visual-weight surfaces;
- subtle framing rather than dense permanent panels;
- quiet textures and transparency;
- limited, purposeful ornament;
- visual effects that feel atmospheric rather than HUD-like.

## Design workflow

Recommended workflow:
1. art-direction boards;
2. whole-screen mockups of the accepted D-032 layout;
3. component-level style studies;
4. reusable visual tokens/assets;
5. gameplay screenshot review and iteration;
6. only then implementation/polish in Lua.

## Design-system categories

The visual system should eventually define consistent treatments for:
- typography;
- color/accent hierarchy;
- opacity hierarchy;
- spacing/padding/rhythm;
- frames/borders/backings;
- button/icon treatment;
- status emphasis;
- contextual motion/fades;
- perceptual effects such as the health tunnel.

## Representative deliverables

Useful parallel deliverables include:
- a full representative screen mockup;
- compass treatments;
- action-cluster treatments;
- resource/status treatments;
- Active Quest presentation;
- Context presentation;
- world-target annotation concepts;
- health-tunnel effect studies.

## Guardrails

- Do not drift into a generic UI-skinning exercise detached from product
  philosophy.
- Do not imitate another game's look directly.
- Do not let ornament crowd out readability or world visibility.
- Do not let visual exploration imply that capability/fallback rules are
  waived.

## Relationship to runtime work

This workstream is intentionally parallelizable.

Mockups and art-direction decisions can advance while runtime capability work is
still focused elsewhere, provided the repo memory clearly separates accepted
visual direction from proven implementation state.


## Current anchor refinement — Selective Hybrid E

D-034 refines World Ghost into a selective hybrid rather than a uniform skin.

Rule:
**thematic for meaning; restrained for interaction.**

Use authored Warcraft/Logres ornament most strongly on:
- Compass/navigation;
- Active Quest;
- player-health perceptual effects;
- selected narrative/context accents.

Keep repeated high-density controls comparatively simple:
- Primary/Secondary/Utility action buttons;
- class/pet/special controls;
- compact status/information surfaces.

The stronger treatment should mostly live at the composition/group level, not
on every repeated button.

## Percentage-bar primitive

Percentage-only Logres-owned readouts should converge on a shared compact bar +
percentage text visual primitive when their presentation is revisited.

The player-health tunnel remains the explicit exception.

Secret-capable percentages still require native-safe transport; visual
standardization must not introduce Lua inspection/arithmetic on those values.

Canonical inventory:
`VISUAL_COMPONENT_INVENTORY.md`.


## Frozen player-health visual contract — D-036

The player-health tunnel is no longer only a generic vignette hypothesis. Its
approved perceptual rule is continuous: remaining health roughly corresponds to
remaining clear/usable visual field, from near-full visibility at 100% to effective
collapse at 0%. Healthy ranges may ease gently; critical ranges collapse much more
directly.

Art uses peripheral darkness, desaturation/loss of clarity, and restrained cold
burgundy injury pressure. Reject blood splatter, veins, red fog, hard circular
apertures, and conventional health-meter treatment.

## Navigation semantic family — D-037

Future compass art must reserve distinct roles for manual waypoint, quest
destination, local radius POI, and tracking. Tracking uses one small generic
Logres-styled repeated glyph regardless of tracked category; it must not literally
copy stock yellow dots.

These semantic roles are accepted. Exact glyph construction remains the next
focused compass design work, and unproven marker sources must not be represented as
implemented capability.
