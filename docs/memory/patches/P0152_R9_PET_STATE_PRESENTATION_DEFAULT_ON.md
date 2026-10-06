# P0152 R9 — Pet State Presentation + Default-On Overlay

Date: 2026-10-06
Status: **RUNTIME/VISUAL FAIL — NO VISIBLE PRESENTATION CHANGE**

## Runtime report driving R9

The current P0152 pet buttons execute, but their persistent state is not legible:
Defensive and Passive appear identical regardless of selection, and an autocast-
enabled ability such as Torment lacks an obvious persistent indicator. The Logres
pet-action cluster also appears only after manual developer-panel activation; it
should be present by default when the addon/pet surface is available.

Two prior correction delivery attempts refused before tracked writes and are
preserved as evidence:

- `../evidence/P0152_R7_STATE_PRESENTATION_DELIVERY_BASELINE_FAIL_2026-10-06.md`;
- `../evidence/P0152_R8_DELIVERY_PROBE_MARKER_FAIL_2026-10-06.md`.

## R9 design

R9 does not overwrite `Logres/Actions/Button.lua` or
`Logres/HUD/PetActionExecutionProbe.lua`.

It inserts `Logres/HUD/PetActionPresentation.lua` immediately **before** the probe
in TOC order. That guarantees the shared `ActionButton.Create` factory is wrapped
before any P0152 probe-created button can exist, whether creation happens during
file load or later module initialization.

The overlay is presentation-only:

- ordinary `isActive=true` -> strong amber inner border plus upper-right pip;
- ordinary `autoCastAllowed=true && autoCastEnabled=true` -> separate orange outer
  border plus lower-left pip;
- secret, invalid, unavailable, or unreadable state -> added indicators hide
  fail-open;
- pet invalidation events and `PostClick` refresh the presentation;
- no `OnUpdate`, timer, polling, pet-action mutation, Blizzard pet-bar suppression,
  or `PetFrame` suppression is added.

R9 deliberately does not call `CheckButton:SetChecked`; active state is represented
only by addon-owned textures so the correction cannot perturb secure button checked
semantics.

## Default-on behavior

After module enable, the overlay listens for `PLAYER_ENTERING_WORLD` and player
`UNIT_PET`. Out of combat it silently dispatches the already-existing bounded
`petactionexecprobe arm` route. If the lifecycle event occurs during combat, the
request is deferred to `PLAYER_REGEN_ENABLED` rather than mutating protected setup
in combat.

This makes the current P0152 Logres pet cluster default-on without requiring the
user to open the developer panel, while retaining the panel as diagnostic/control
tooling. Blizzard's stock pet bar remains available as fallback.

## Validation gate

After deployment and `/reload`, with the pet naturally present and **without**
opening the developer panel first:

1. Logres pet buttons appear automatically.
2. Exactly the active command mode is visually obvious; changing Defensive/Passive
   moves the amber active treatment.
3. A naturally autocast-enabled ability shows the distinct orange autocast
   treatment.
4. Existing left-click execution and supported right-click autocast behavior remain
   functional.
5. Blizzard stock pet controls remain usable.
6. `petactionexecprobe check` and `checkall` pass with no Lua, secret-value, taint,
   or protected-action error.

Until that runtime/visual gate passes, P0152 remains open.
