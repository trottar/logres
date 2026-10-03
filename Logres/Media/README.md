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
