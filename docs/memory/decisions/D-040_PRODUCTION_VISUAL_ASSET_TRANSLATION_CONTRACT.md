# D-040 — Production Visual Asset Translation Contract

Status: **ACCEPTED**
Date: 2026-10-03

## Decision

Approved D-039 reference sheets are design authorities, not runtime texture
atlases.

Production-ready addon media is derived into:

`Logres/Media/`

Runtime modules consume paths and shared visual geometry through:

`Logres/Media/Theme.lua`

rather than reaching into `docs/design/approved/` or independently hard-coding
parallel asset paths.

## First translated family — action buttons

P0116 translates the approved action-button primitive into five runtime layers:

- persistent base frame;
- restrained hover emphasis;
- stronger pressed treatment;
- persistent checked/toggled treatment;
- brief activation flash.

The native WoW action icon remains the dominant content.

The existing proven action semantics remain unchanged:
- secure execution;
- page/slot routing;
- key routing;
- cooldown DurationObject transport;
- count transport;
- usability/range coloring;
- contextual cluster alpha;
- stock Bar 2–3 replacement/restoration.

No new protected mutation is introduced by visual translation.

## Geometry

The first production action tokens intentionally preserve the proven runtime
button geometry:
- secure hit box: 38 x 38;
- gap: 5;
- icon inset: 4;
- decorative art may overscan the hit box by 2 pixels.

This is not final 36-button density calibration. D-039 explicitly keeps exact
hotkey/count typography and final density/spacing as later in-client polish.

## Fail-open behavior

The procedural dark backing remains beneath the production frame. If a media
texture cannot render, action icons and secure buttons remain usable rather than
disappearing behind a new presentation dependency.

Visual media must not become authority for action execution or availability.

## Asset verification

Production derivative assets are checked by
`tools/check_action_visual_contract.py`.

That checker verifies:
- required action media exists at the canonical runtime paths;
- exact P0116 production-asset hashes;
- `Theme.lua` owns those paths;
- the theme loads before `Actions/Button.lua`;
- approved state layers replace the stock pushed-frame art path;
- the existing secure/action-feedback contracts remain separate.

## Scope

D-040 establishes the reusable production-media organization for later approved
families. It does not imply that future bars, compass glyphs, health masks, quest
surfaces, or aura assets are already implemented.

Each family still receives a narrow translation/wiring checkpoint and in-client
visual proof.
