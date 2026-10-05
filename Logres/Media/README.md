# Logres production media

Runtime-facing visual assets live under `Logres/Media/`.

`Theme.lua` is the single runtime path/token registry for approved production
visual primitives. Component modules should consume these paths/tokens instead
of hard-coding media paths independently.

## Action

The first translated family is the approved D-039 action-button primitive.

Files:
- `Action/action_frame.tga` — persistent bronze frame/chrome;
- `Action/action_hover.tga` — restrained hover edge emphasis;
- `Action/action_pressed.tga` — stronger pressed/key-activation treatment;
- `Action/action_checked.tga` — persistent checked/toggled accent;
- `Action/action_flash.tga` — brief independent activation flash.

The native WoW action icon remains dominant. Cooldown, range, insufficient
resource, unusable state, count, and hotkey semantics continue to come from the
existing proven action runtime.

Canonical art reference:
`docs/design/approved/03_action_button_primitive.png`.

These 64x64 RGBA TGA files are production derivatives, not replacements for the
approved reference sheet.


## Percentage bar

P0120 translates the approved D-039 resource/percentage-bar primitive into a
reusable normal/compact runtime surface.

Files:
- `Bar/percentage_fill.tga` — neutral textured fill recolored by the native
  StatusBar consumer;
- `Bar/percentage_diamond.tga` — restrained bronze/dark diamond endcap shared by
  normal and compact bars.

`Theme.lua` owns normal/compact geometry, track/border/text tokens, resource
color families, target/ally health colors, and the media paths.

The runtime bar retains visible percentage text. Player health remains excluded:
it continues to use the D-036 health-tunnel/peripheral-pressure path.

Canonical art reference:
`docs/design/approved/02_resource_bar_primitive.png`.


## Cast-state cue

P0121 translates approved D-039 cast-state sheet 05 into one shared heraldic
frame and semantic glyph textures:
- `Cast/cast_frame.tga`;
- `Cast/player_cast.tga`;
- `Cast/player_channel.tga`;
- `Cast/target_cast.tga`;
- `Cast/target_channel.tga`;
- `Cast/interrupted.tga`.

The cue remains symbolic only: shape is primary, color secondary, and no cast
progress/timing/spell text/icon metadata is added. Production lifecycle still
comes from the existing unit-filtered spellcast event path.

Canonical art reference:
`docs/design/approved/05_cast_state_cue_primitive.png`.


## Context message

P0122 translates approved D-039 Context sheet 09 into one shared transient
presentation family for XP and objective-progress pulses.

Files:
- `Context/context_line.tga` — restrained line treatment;
- `Context/context_diamond.tga` — central authored diamond;
- `Context/context_glow.tga` — subtle additive completion emphasis.

`Quest/ContextVisual.lua` owns construction/style only; XP and objective modules
retain their existing data/event producers. A warmer completion palette is used
only from the existing objective `finished` transition.

Canonical art reference:
`docs/design/approved/09_context_message_component.png`.

## Compass

P0123 translates the proven heading/manual-waypoint subset of approved D-039
Compass sheet 12 into production media:

- `Compass/compass_baseline.tga` — weathered brass tape baseline with restrained
  edge recession;
- `Compass/compass_center.tga` — fixed brighter-brass center
  gnomon/spear-notch;
- `Compass/compass_tick_cardinal.tga` — stronger cardinal tick;
- `Compass/compass_tick_intercardinal.tga` — quieter intercardinal tick;
- `Compass/compass_manual_waypoint.tga` — muted steel-blue open destination
  diamond with exact-bearing stem.

`Theme.lua` owns the geometry and runtime paths. The Compass runtime continues to
own only its proven heading and manual user-waypoint sources. P0123 does not add
quest/POI/tracking sources, fabricate waypoint identity, derive pseudo-distance
from map-coordinate deltas, or change the stock-minimap boundary.

Canonical art reference:
`docs/design/approved/12_compass_glyph_and_state_sheet.png`.

## Player-health tunnel

P0124 translates the frozen D-036 / approved sheet-11 health-tunnel direction
into five full-screen alpha-mask layers:

- `Health/health_outer.tga` — soft outer charcoal pressure;
- `Health/health_injury.tga` — cold-burgundy injury pressure;
- `Health/health_critical.tga` — narrower critical aperture;
- `Health/health_near_death.tga` — severe near-death tunnel;
- `Health/health_death.tga` — death-only clear-field collapse.

`Theme.lua` owns the asset paths and tint families. The masks are production
derivatives; the approved reference remains
`docs/design/approved/11_health_tunnel_continuous_progression.png`.

Live health still uses native secret-safe
`UnitHealthPercent -> CurveObject -> Texture:SetAlpha` transport. The assets do
not authorize Lua inspection or threshold branching on live health.

## Active Quest

P0126 translates approved D-039 sheet 10 into an optional one-focus upper-right
quest presentation.

Files:
- `Quest/active_quest_panel.tga` — dark aged-parchment / bronze authored panel;
- `Quest/active_quest_divider.tga` — restrained heraldic divider;
- `Quest/active_quest_glyph.tga` — compact Logres quest-focus glyph.

`Theme.lua` owns the asset paths, geometry, and color tokens. Objective percentage
rows reuse the existing shared percentage-bar assets/tokens.

Canonical art reference:
`docs/design/approved/10_active_quest_component.png`.

Exact objective wording and mechanical counts are inspection-only. The assets do
not authorize quest-control ownership, Objective Tracker suppression, or quest
navigation.
