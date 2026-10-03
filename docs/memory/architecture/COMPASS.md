# Compass Architecture

## Product intent

A Skyrim-like interaction pattern rendered with a Warcraft-native aesthetic:
- horizontal directional strip;
- central heading;
- restrained objective/waypoint markers;
- no minimap dependence for ordinary immersion only after sufficient Logres
  navigation capability is proven.

## Context

The compass belongs to Immersion Mode.

Default:
- Immersion ON + world/exploration: available when source capability exists;
- Immersion OFF: hidden;
- instances/restricted navigation contexts: automatically hidden/suspended;
- restoration after leaving an instance should be silent and smooth.

The compass consumes existing State. It does not create its own world/instance
authority.

## D-029 heading contract

The first production heading source is:
`GetPlayerFacing()`.

Forever/reference semantics:
- radians;
- 0 = north;
- counterclockwise-positive;
- unavailable in restricted instance content.

Presentation converts to conventional clockwise degrees:

`headingDegrees = (360 - degrees(facing)) % 360`

The first runtime slice uses heading only.

Player position is not required for a cardinal/intercardinal compass tape.

## E.2 presentation

E.2 adds:
- top-center horizontal heading tape;
- cardinal/intercardinal labels;
- module-local throttled facing refresh;
- addon-owned availability/presentation diagnostics.

Eligibility:
- Compass module enabled;
- Immersion ON;
- existing State context = `world`;
- `GetPlayerFacing()` returns a usable non-secret number.

If facing is unavailable, the compass suspends rather than retaining or
fabricating the prior heading.

## Position / waypoint boundary

Later waypoint bearings may use:
- `C_Map.GetBestMapForUnit("player")`;
- `C_Map.GetPlayerMapPosition`;
- map/world coordinate conversion;
- user/super-tracked quest waypoint data where runtime-proven.

Waypoint math must be separately runtime-proven.

Do not infer a destination bearing from source availability alone.

## Future marker taxonomy — D-037

Future Phase H+ navigation uses four semantic marker roles when their sources are
capability-proven:
1. manual waypoint — explicit player destination; authored muted-blue Logres glyph;
2. quest destination — separate quest/heraldic marker; no presentation without a
   proven quest bearing;
3. local radius POI — nearby service/place awareness within a realistic local
   radius; exact Forever categories and positions must be enumerated/proven;
4. tracking — one generic Logres-styled repeated tracker glyph independent of
   tracked category; not literal stock yellow dots.

The player's selected tracking mode supplies the category meaning; the assumed
Forever selection semantics and individual result positions remain unproven until
the dedicated capability audit.

D-038 now resolves the accepted working glyph/focus treatment; exact pixel values,
focus-angle thresholds, scale curves, and source capability remain later calibration.

## D-038 visual/focus contract

Compass structure:
- transparent/world-first top-center tape;
- thin weathered antique-brass baseline;
- cardinal directions stronger than intercardinal;
- fixed brighter-brass center gnomon / spear-notch;
- quiet local contrast only, not a visible backing panel;
- clean heading-only presentation is the normal no-marker state.

Marker silhouettes:
- manual waypoint: open muted-blue destination diamond with exact-bearing stem;
- quest destination: aged pale-gold heraldic pennon/shield with exact-bearing stem;
- local POI: small neutral open wayfinder seal / roundel;
- tracking: tiny repeated muted-amber faceted diamond / four-point pip.

Bearing truth:
- marker horizontal attachment points remain true to bearing;
- collision handling uses vertical lanes instead of horizontal jitter;
- manual/quest destinations remain individually legible;
- dense POI/tracking evidence may use restrained same-role stacking/clustering;
- lower-priority repeated tracking yields before obscuring stronger semantic markers.

Center focus:
- one safely identified navigation candidate near the fixed center may expose a
  contextual identity label;
- where comparable physical/world distance is capability-proven, the nearest
  candidate wins before angular alignment;
- angular alignment is the fallback/secondary discriminator; semantic priority may
  break a remaining practical tie;
- name opacity fades continuously as angular deviation from center increases;
- logical focus may use wider hysteresis to prevent flicker while visible opacity
  remains continuous;
- unavailable identity or incomparable distance is never fabricated.

Depth treatment:
- manual and quest destinations may use restrained bounded distance-dependent scale
  when safe comparable distance exists;
- local POI scale stays mostly stable;
- tracking remains effectively fixed-size;
- focus may add only a small opacity/scale/material emphasis.

Edge/motion treatment:
- markers recede and disappear toward the visible tape edge;
- no clamped edge arrows or fabricated off-screen guidance;
- no bounce/spring overshoot or stale last-known marker;
- smoothing may hide update stepping only when it preserves directional truth.

Only manual waypoint capability is currently runtime-proven. Quest/POI/tracking
identity, bearing, and comparable-distance inputs remain gated by D-037 and the
future capability audit.

## Minimap boundary

D-030 remains the current runtime authority: the Blizzard minimap stays stock and
Blizzard-owned.

D-037 now defines the intended future endpoint: ordinary minimap awareness may move
into the Logres compass/navigation system only after the missing information and
control surfaces are deliberately replaced or explicitly dispositioned,
runtime-proven, reversible, and fail-open.

A heading tape plus attractive markers is not sufficient evidence by itself. Local
POI positions, tracking results, quest destination, ping/click behavior, zone
context, zoom/map expectations, and other current Forever minimap utility must be
audited before suppression.

Until that complete gate passes, unsupported Logres marker roles are simply omitted
and Blizzard navigation remains available.
