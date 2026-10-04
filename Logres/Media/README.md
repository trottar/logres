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
