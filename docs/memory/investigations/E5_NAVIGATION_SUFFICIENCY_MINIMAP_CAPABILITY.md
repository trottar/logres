# E.5 — Navigation Sufficiency / Minimap Capability

Status: CLOSED — MINIMAP REMAINS BLIZZARD-OWNED
Opened: 2026-10-02
Closed: 2026-10-02

Canonical decision:
`../decisions/D-030_MINIMAP_REMAINS_BLIZZARD_OWNED.md`

Evidence:
`../evidence/E5_MINIMAP_CAPABILITY_REVIEW_2026-10-02.md`

## Question

Does Logres replace enough of the Blizzard minimap/navigation information and
control surface to justify suppressing any part of the stock minimap?

## Result

No.

Logres runtime-proven navigation replaces:
- cardinal/intercardinal heading presentation;
- manual user-waypoint direction within the compass;
- world/Immersion gating;
- clean fail-open omission when navigation inputs are unavailable.

Logres does not deliberately replace:
- quest/objective navigation;
- route/path guidance;
- local POI/tracking information;
- minimap ping/click interaction;
- zoom controls;
- zone/territory context;
- other Blizzard-owned minimap utilities not separately proven/replaced.

The suppression architecture requires a replacement, runtime proof, restoration
definition, and understood control/security behavior before a Blizzard surface
is suppressible.

That gate is not satisfied.

## Decision

The minimap remains stock and Blizzard-owned through Phase E.

No minimap suppression implementation is opened.

## Exit

E.5 is complete.

This explicit stock-ownership decision satisfies the remaining Phase E
minimap-ownership exit criterion.

Phase E may close without performing an unsafe suppression experiment.
