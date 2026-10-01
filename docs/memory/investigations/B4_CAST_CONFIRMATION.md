# B.4 — Cast Confirmation

Status: ACTIVE
Opened: 2026-10-01

## Goal

Add minimal cast/channel cues for:
- the player;
- the current target.

No conventional cast bars.

## Corrected scope

Earlier roadmap text said enemy cast UI remained deferred unless later justified.

That wording was incorrect relative to the intended product direction.

B.4 explicitly includes current-target cast/channel presentation.

Only the runtime proof of the target-caster true path may defer when the environment provides no caster.

## Player cue

Initial direction:
- small rune/glyph near the existing player resource text;
- visible while casting/channeling;
- simple active animation or brightness change;
- completion disappearance;
- interruption/failure snap/fade if practical.

## Target cue

Initial direction:
- similarly restrained cue associated with the sparse target block;
- visible while current target casts/channels;
- no horizontal timing bar;
- disappears on completion/interruption/target loss.

## Existing evidence

I-001 already proved player:
- `UnitCastingInfo("player")`;
- `UnitChannelInfo("player")`;
- cast/channel event paths.

Current-target cast metadata was not captured.

## Source questions before implementation

Resolve:
1. exact player cast/channel event set;
2. exact target cast/channel event set;
3. current `UnitCastingInfo("target")` / `UnitChannelInfo("target")` behavior on Forever;
4. whether cast/channel metadata can become secret and which parts may safely be forwarded;
5. minimal visual state machine for start/stop/interrupted/failed/channel;
6. cue placement relative to player resource and target block.

## Runtime strategy

Player side:
- must be tested immediately with available player casts/channels.

Target side:
- implement the target-cast path;
- test if a nearby/current target naturally casts;
- otherwise mark true-path runtime proof `DEFERRED BY ENVIRONMENT`;
- do not remove target-cast support;
- do not require travel solely to obtain a caster.

## Exit

B.4 completes when:
- player cue is production-proven;
- target cue is implemented;
- target cue is either runtime-proven or carries an explicit environmental deferral with retry condition;
- no conventional cast bar is introduced.
