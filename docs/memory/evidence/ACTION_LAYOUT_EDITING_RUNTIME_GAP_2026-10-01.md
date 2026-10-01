# Action Layout Editing Runtime Gap — 2026-10-01

Status: OPEN PRODUCT CAPABILITY / DEFERRED FROM C.5
Date: 2026-10-01

## Observation

While testing the Logres action interface, the user observed:

- actions/spells can be added to the underlying action slots represented by
  Logres;
- Logres does not currently provide a complete way to remove or move an action
  directly from the Logres action controls.

The missing interaction includes future support for:
- pick up / drag;
- move;
- swap;
- clear/remove;
- reorder.

## Classification

This is **not** a secure-execution failure.

Current action activation, routing, range, cooldown, context policy, and
selective stock replacement remain valid.

This is a missing live action-layout/editor capability.

## Product requirement

The future Logres action-layout editor must allow players to manage action
placement without requiring permanent dependence on visible Blizzard action
bars.

At minimum:
- edit only when protected-action rules allow it;
- support move/swap/clear semantics;
- preserve saved keybindings unless the user explicitly changes bindings;
- keep layout geometry separate from action-slot contents;
- provide a safe stock fallback while Logres editing is incomplete.

## Replacement implication

Session-only C.5 replacement may remain complete because:
- replacement defaults fail-open after reload;
- stock Bars 2–3 can be restored through the developer replacement control.

Before persistent/final stock suppression is treated as a finished player
experience, Logres must either:
- provide the required live action editing workflow;
- or provide an explicit, reliable stock-edit mode.

## Ownership

Canonical product direction:
`../decisions/D-020_ACTION_LAYOUT_CUSTOMIZATION_DIRECTION.md`

This capability is deferred from current C.5/C.6 secure replacement proof and
belongs to later action-layout/profile/editor implementation.
