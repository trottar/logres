# D-014 — Cast presentation contract

Status: ACCEPTED
Date: 2026-10-01

## Decision

B.4 covers both:
- player self casting/channeling;
- current-target casting/channeling.

Both use the same minimal Logres visual language.

## No conventional cast bars

Logres does not use a conventional progress cast bar by default.

The intended presentation is a compact glyph/rune/cast cue near the central HUD language.

The cue communicates that a cast/channel is active without turning timing into a dominant horizontal meter.

## Player cast cue

Player self casting/channeling should:
- appear when a cast/channel starts;
- remain active while casting/channeling;
- disappear or resolve on completion;
- snap/fade differently on interruption/failure where practical;
- visually distinguish channeling if useful.

The initial implementation may use simple animation/state changes before final art polish.

## Current-target cast cue

The current target should receive a similarly restrained cast cue.

It should:
- appear when the current target begins casting/channeling;
- disappear when the cast/channel ends or the target changes;
- remain visually distinct from the player's own cue;
- avoid restoring a conventional enemy cast bar.

This is a deliberate product feature, not an optional later add-on.

## Runtime coverage

Player cast/channel APIs were already runtime observed during I-001.

Current-target cast/channel true-path runtime evidence is not yet available.

If the current test environment has no convenient enemy caster, target-cast runtime proof may be classified:

**DEFERRED BY ENVIRONMENT**

This defers proof, not implementation intent.

Retry when:
- an enemy/current target naturally casts or channels;
- a later combat/instance test provides a caster.

Do not require dungeon travel solely to manufacture this proof.

## Scope

B.4 may implement:
- player cue;
- current-target cue;
- cast/channel lifecycle events;
- completion/interruption visual states.

B.4 does not require:
- spell timing numbers;
- cast progress bars;
- enemy spell database logic;
- broad nameplate cast replacement.
