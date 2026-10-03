# D-033 — Parallel art direction and World Ghost hypothesis

Status: ACCEPTED
Date: 2026-10-02

## Decision

Phase H+ visual direction work may proceed in parallel to ongoing Lua/runtime
capability work.

This workstream is primarily design rather than secure-runtime implementation.
It can therefore advance through mockups, style studies, asset exploration,
and visual-system definition without waiting for the active G.2 camera proof to
finish.

Canonical supporting record:
`../architecture/VISUAL_SYSTEM_DIRECTION.md`.

## Current preferred working direction

The current preferred visual hypothesis is **World Ghost**.

Meaning:
- simple;
- immersive;
- Warcraft-native rather than imported from another game;
- consistent with the project's Logres / Camelot naming and tone;
- restrained rather than busy;
- low visual weight where possible, with UI feeling ghosted into the world
  rather than dominating it.

This is a working art-direction hypothesis, not a frozen final asset pack.
It must still be tested and refined through actual mockups and gameplay-facing
visual review.

## Parallel deliverables

Parallel non-Lua work may include:
- art-direction boards / moodboards;
- full-screen mockups using the accepted D-032 layout;
- typography, color, spacing, and motion tokens;
- reusable frame/border/effect asset studies;
- health-tunnel and other perceptual-effect visual treatments;
- screenshot review and comparative direction choices.

## Product boundary

This does not change the active runtime work item.

- G.2 remains the current objective.
- No Lua/runtime completion may be claimed from mockups alone.
- Visual direction should inform later implementation, not bypass capability
  gates.

## Workflow

Formal visual-design training is not required to direct this process.

The user may act as product/art director by selecting between comparative
options and refining them iteratively, for example:
- darker / lighter;
- more or less ornament;
- more or less ghosted;
- stronger or weaker Warcraft texture language.

The assistant's role is to help externalize those options into concrete design
artifacts and then preserve the resulting direction durably.


## 2026-10-02 refinement — D-034

D-034 keeps World Ghost as the underlying philosophy but narrows the current
working visual anchor to Selective Hybrid E:
- authored/thematic treatment on meaning-heavy surfaces;
- simple treatment on repeated/high-density interaction surfaces;
- canonical component taxonomy for art studies;
- compact bar + percentage text as the future default primitive for
  percentage-based Logres-owned values, except player health.
