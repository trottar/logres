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
