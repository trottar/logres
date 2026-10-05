# P0145 — Manual Waypoint Comparable Distance / Bounded Depth

Date: 2026-10-05
Baseline: `47534363bd5754306c31d5e860739289504417de`
Runtime: `0.0.70-dev`
Commit: `60244841d0ecfa35b58c7db60293145b8962b6dc`
Result: **INSTALLED / PUSHED — RUNTIME + INTEGRATION PASS FOR CHANGED SCOPE; P0123 OFF-TAPE BASELINE RETAINED**

## Purpose

Use only the already-proven manual user-waypoint role to exercise the comparable
same-map distance path left untested by P0143, then apply D-038's restrained
bounded depth treatment without expanding navigation ownership.

## Source contract

P0142/D-043 and the pinned Forever source remain authoritative.

Relevant exact source facts from
`Gethe/wow-ui-source@e3ecc27b64d30fdc735a3f6579b866858f9f9df1`:
- `C_Map.GetUserWaypoint()` returns a `UiMapPoint`;
- `UiMapPoint.uiMapID` identifies the source map;
- `C_Map.GetUserWaypointPositionForMap(uiMapID)` returns a normalized map position when available;
- `C_Map.GetPlayerMapPosition(uiMapID, "player")` returns the player normalized position;
- `C_Map.GetMapWorldSize(uiMapID)` returns width/height in yards.

P0143 runtime-proves ordinary current-map/player position and map world size on the
current Forever client, but no destination existed in that sample.

## Runtime implementation

P0145 keeps the P0123 bearing path unchanged.

Distance is a separate fail-open side channel:
1. query the user waypoint normally;
2. secret-check the returned waypoint object as before;
3. read `waypoint.uiMapID` and secret-check that field before any comparison;
4. preserve current-map bearing through `GetUserWaypointPositionForMap(currentMapID)`;
5. compute distance only when waypoint source map ID equals current player map ID;
6. call `C_Map.GetMapWorldSize(currentMapID)` and secret-check width/height before type tests or arithmetic;
7. compute `sqrt((dx*width)^2 + (dy*height)^2)` only from ordinary numeric values;
8. on any distance-only absence/secret/mismatch/invalid state, reset depth to `1.0` without clearing the proven waypoint bearing/marker.

No new polling cadence is added. P0145 reuses the existing P0123 Compass refresh
path and `USER_WAYPOINT_UPDATED` behavior.

## Depth treatment

Theme-owned initial calibration:
- near threshold: `120` yards;
- far threshold: `1200` yards;
- near distance scale: `1.05`;
- far distance scale: `0.90`;
- linear interpolation between thresholds;
- final scale after the existing near-center focus boost is capped to `0.90–1.12`.

The player sees only marker scale. There is no exact-distance text, persistent
identity, glow box, bounce, or new label.

## Diagnostics

`Compass:GetDebugStatus()` adds addon-owned:
- `waypointSourceMapID`;
- `waypointDistanceAPIAvailable`;
- `waypointDistanceAvailable`;
- `waypointDistanceYards`;
- `waypointDepthScale`;
- `waypointRenderScale`;
- `lastWaypointDistanceReason`;
- `lastWaypointDistanceError`.

`Compass Check` validates those fields without re-reading map APIs and remains part
of integrated `Run All`.

## Static contracts

P0145 adds `tools/check_manual_waypoint_depth_contract.py` and updates the older
P0123 visual checker so later capability-proven distance/depth diagnostics are no
longer forbidden while manual labels and unproven navigation sources remain
forbidden.

The one-time applier preflights every checker path before writes and is
transactional over patch-owned files.

## Explicit non-scope

P0145 does not add or authorize:
- quest destination markers;
- current-navigation markers;
- AreaPOI/service markers;
- detected tracking-result markers;
- waypoint identity text;
- exact distance text;
- minimap CVar/settings/zoom/ping mutation;
- Blizzard pin/frame inspection;
- stock minimap suppression.

## Initial artifact rollback / R1 correction

The first P0145 artifact never reached runtime. Its transaction wrote the prepared
candidate, then the new static checker failed with seven self-consistency errors:
- six required depth-constant checks expected one-line assignments while the
  generated Lua deliberately wrapped those assignments across lines;
- the `uiMapID` ordering check searched for `local rawWaypointSourceMapID`, while
  the generated safe read was `local waypointMapOK, rawWaypointSourceMapID =
  pcall(...)`.

The implementation already secret-checked `rawWaypointSourceMapID` before type
inspection/storage; the checker failed to recognize its own generated form. The
applier transaction restored all tracked files and removed any partial manifest.
No WoW deployment or runtime validation occurred.

R1 corrects the checker to match assignment semantics independent of line wrapping
and to validate the actual pcall -> secret check -> type check -> storage order.
R1 also adds a pre-write shadow-tree gate: newly generated Compass/Theme/Commands
candidates are checked by the exact P0145, compass, and compass-visual checkers
before any tracked file is written. This failed artifact is classified as an
**artifact validation failure**, not runtime evidence against the feature.

## R1 rollback / R2 diff-hygiene correction

R1 passed the new prepared-candidate semantic checker gate and every repository
static checker, then `git diff --check` rejected the prepared tree before manifest
creation. The cause was the generic `append` transform helper: each appended memory
fragment already ended in `\n`, and the helper unconditionally added another
newline. That introduced a new blank line at EOF in four tracked memory files.
Git reports that condition as `blank-at-eof` and exits non-zero.

The transaction again restored all tracked files; no WoW deployment/runtime proof
occurred. R2 changes append normalization to exactly one terminal newline and adds
a pre-write `git diff --no-index --check` comparison between the authoritative
baseline bytes and the exact prepared candidate. Return code `1` is accepted as an
ordinary clean difference; whitespace/conflict-marker errors fail before writes.
The post-write repository `git diff --check` remains mandatory and now captures its
diagnostics on failure.

## Runtime gate

After deployment and `/reload`:
1. place a normal user waypoint on the current map;
2. run **Phase E -> Compass Check**;
3. require `distance=true`, a non-negative yard value, bounded depth scale, no errors;
4. rotate to confirm existing truthful bearing and off-tape suppression remain intact;
5. clear the waypoint and confirm clean fallback/no stale marker;
6. run **Phase 0 -> Run All**.

Any Lua, secret-value, taint, protected-action, or source failure is FAIL.
## Final runtime result

P0145 is durable at `60244841d0ecfa35b58c7db60293145b8962b6dc` on
`0.0.70-dev`.

Observed populated `Compass Check` samples reported ordinary same-map distances
`115.8`, `45.5`, `51.7`, and `116.0` yards. Depth remained `1.050` in those
samples and visible render scale remained within the accepted `0.90–1.12` bound.

After clearing the user waypoint, `Compass Check` passed with
`waypoint=false`, `marker=false`, `distance=false`, `yards=nil`, `depth=1.000`,
`renderScale=nil`, and `waypoint-absent` reasons. Integrated `Run All` had already
completed cleanly on the same runtime before that targeted clear-state capture.

P0145 did not capture a fresh off-tape diagnostic row. P0123 remains the actual
runtime authority for off-tape suppression (`relative=115.5`, `marker=false`).
P0145's new scale path is downstream of the existing off-tape return, so this
record does not invent a new runtime sample.

Classification:
**RUNTIME + INTEGRATION PASS FOR P0145 CHANGED SCOPE.**

Quest/current-navigation, AreaPOI/service, tracking-result roles, identity text,
exact distance text, and stock minimap suppression remain outside this checkpoint.
## P0147 acceptance correction

The final P0145 classification above is partially superseded. All populated
`0.0.70-dev` samples were inside the original 120-yard near threshold, so they
proved distance arithmetic and the near endpoint only; they did not prove that
depth scale changes across distance bands. The user reported no visible size change
during the original test.

P0147 therefore reopens only the distance-dependent depth/visual acceptance while
retaining P0145's same-map distance and clean clear-state PASS. See
`../evidence/P0147_P0145_DEPTH_VALIDATION_CORRECTION_2026-10-05.md`.
