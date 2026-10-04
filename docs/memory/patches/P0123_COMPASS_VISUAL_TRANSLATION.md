# P0123 — Compass Heading / Manual Waypoint Visual Translation

Date: 2026-10-04
Result: **PREPARED — RUNTIME + VISUAL PROOF PENDING**
Baseline: `62353ecfc6eb3c3adc61b8d11af251f05637a6a3`
Runtime: `0.0.52-dev -> 0.0.53-dev`

## Purpose

Translate approved D-039 sheet `12_compass_glyph_and_state_sheet.png` into the
already-proven heading/manual-waypoint Compass runtime without expanding source
ownership.

Camera work remains frozen for this visual pass. P0123 does not modify Camera
source, Phase G/G.5 investigations/evidence, `CURRENT.md`, or
`CURRENT_HANDOFF.md`.

## Production media

P0123 adds Theme-owned production assets for:

- weathered brass heading baseline with edge recession;
- fixed brighter-brass center gnomon / spear-notch;
- stronger cardinal tick;
- quieter intercardinal tick;
- muted steel-blue open-diamond manual waypoint with an exact-bearing stem.

Runtime paths live under `Logres/Media/Compass/`.

## Runtime wiring

Existing proven runtime semantics remain authoritative:

- heading source remains `GetPlayerFacing()`;
- heading tape remains world-context / Immersion-ON only;
- manual waypoint source remains the existing user-waypoint API path;
- true horizontal bearing remains unchanged;
- instance/unavailable-source fail-open behavior remains unchanged;
- Blizzard minimap remains stock.

P0123 replaces procedural heading/tick/manual-waypoint geometry with the
production media family and Theme-owned geometry/color tokens.

The manual waypoint moves into the approved major-destination lane above the
tape. Its proven angular deviation may drive:

- edge opacity recession;
- restrained near-center focus scale (~7% maximum).

P0123 deliberately does **not** derive distance from map-coordinate deltas. Safe
comparable world distance has not been proven, so the approved distance/depth
scale behavior remains deferred.

No manual destination identity label is invented because the current proven
source does not provide an accepted identity string.

## Capability boundary

This checkpoint does not add:

- quest destination source/bearing;
- local POI source/bearing;
- tracking source/bearing;
- world-distance comparison;
- center identity text;
- minimap suppression;
- off-screen/clamped guidance.

Those remain gated by D-037/D-038 and the dedicated future capability audit.

## P0122 synchronization

P0122 is durable at `62353ecf` on runtime `0.0.52-dev`.

Captured diagnostics prove:

- XP preview PASS;
- live XP producer/check PASS;
- objective preview PASS;
- live objective producer/check PASS;
- full `checkall` completion with no reported Lua/secret/taint failure.

The dedicated objective-completion visual variant remains naturally deferred.

Canonical evidence:
`../evidence/P0122_CONTEXT_MESSAGE_RUNTIME_PREVIEW_PASS_2026-10-04.md`.

## Validation gate

In client:

1. Phase E -> Compass Check must PASS.
2. Heading-only world state shows the authored baseline, center gnomon, and
   cardinal/intercardinal tick hierarchy.
3. Rotate normally and confirm the tape remains directionally truthful and
   visually smooth.
4. Create a normal user waypoint through the stock map:
   - muted-blue open diamond appears above the tape;
   - stem remains attached to the true bearing;
   - marker recedes toward tape edges;
   - marker receives only restrained emphasis near center.
5. Clear the user waypoint and confirm the marker disappears promptly.
6. Immersion OFF hides the Compass; ON restores normal world behavior.
7. Entering an ineligible context, if naturally available, still suspends the
   Compass rather than retaining stale navigation presentation.
8. No quest/POI/tracking marker appears from unproven sources.
9. Any Lua, secret-value, taint, or protected-action error is a failure.

Distance-dependent waypoint scale and centered identity text are not acceptance
conditions for this checkpoint because their required inputs are not proven.
