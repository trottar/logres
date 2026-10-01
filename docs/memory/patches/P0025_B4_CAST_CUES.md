# P0025 — B.4 cast/channel cues

Date: 2026-10-01
Result: PREPARED — runtime proof pending

## Intent

Implement both required B.4 cues:
- player;
- current target.

No cast bars.

## Security model

Target spellcast payloads may be secret.

P0025:
- uses unit-filtered target events;
- ignores all target spellcast payload fields;
- does not call UnitCastingInfo/UnitChannelInfo.

## Visual states

Player:
- amber cast;
- blue channel.

Target:
- orange cast;
- violet channel.

Both:
- red interruption/failure snap;
- hide on stop/channel stop.

## Event set

- UNIT_SPELLCAST_START
- UNIT_SPELLCAST_STOP
- UNIT_SPELLCAST_FAILED
- UNIT_SPELLCAST_FAILED_QUIET
- UNIT_SPELLCAST_INTERRUPTED
- UNIT_SPELLCAST_CHANNEL_START
- UNIT_SPELLCAST_CHANNEL_STOP

Target change force-clears target cue.

## Version

`0.0.10-dev -> 0.0.11-dev`

## Runtime proof

Player:
- cast;
- channel if readily available;
- interruption/failure if practical;
- immersion behavior.

Target:
- test if convenient caster exists;
- otherwise environmental deferral with retry condition.

No travel solely for target-caster proof.
