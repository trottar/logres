# P0121 — Cast-State Cue Visual Translation

Date: 2026-10-04  
Result: **PREPARED — RUNTIME + VISUAL PROOF PENDING**  
Baseline: `6c5f8901d3f5b7434b76f05af1f22a0add8c1b10`  
Runtime: `0.0.50-dev -> 0.0.51-dev`

## Purpose

Translate approved D-039 sheet `05_cast_state_cue_primitive.png` into production
runtime media while preserving the already-proven event-driven cast lifecycle.

This is visual asset wiring only. Camera/Taxi source and Phase G/G.5 memory are
not modified.

## Production media

P0121 adds one shared heraldic frame plus five semantic glyph assets:
- player cast — amber angular glyph;
- player channel — blue flowing/swirl glyph;
- target cast — orange/red angular glyph;
- target channel — violet flowing/swirl glyph;
- interrupted/failed — red shattered glyph.

The production cue is deliberately compact and readable at HUD scale. Shape is
the primary distinction between cast/channel/interruption; color is secondary.

## Runtime boundary

The existing production behavior remains authoritative:
- `UNIT_SPELLCAST_*` lifecycle events only;
- player event frame filtered to `player`;
- target event frame filtered to `target`;
- target payload fields remain ignored;
- interrupted/failed remains a brief terminal snap;
- no cast timing, progress, spell text, spell icon, or cast metadata query;
- no `UnitCastingInfo` / `UnitChannelInfo` dependency.

P0121 replaces only the old procedural border/inner/core color squares with
Theme-owned production frame/glyph textures.

## P0120 synchronization

P0120 is durable at `6c5f8901` and is recorded as **CORE RUNTIME + VISUAL PASS —
SIMPLIFIED PRODUCTION BASELINE ACCEPTED**. Additional ornament matching the
approved resource-bar sheet remains deferred polish.

## Validation gate

In client:
1. Phase B -> HUD Check must PASS.
2. Normal player cast shows the amber angular cue and clears on stop.
3. A player channel, when naturally available, shows the blue flowing cue.
4. Interrupt/failure, when naturally available, shows the brief red shattered snap.
5. Target cast/channel may be validated opportunistically; lack of a convenient
   caster is DEFERRED rather than FAIL.
6. No cast timer/progress/text/icon surface appears.
7. Immersion OFF hides the cue surfaces; ON restores normal event behavior.
8. Any Lua, secret-value, taint, or protected-action error is a failure.
