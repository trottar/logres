# B.4 Cast Source Resolution — 2026-10-01

Status: SOURCE-RESOLVED; RUNTIME PROOF PENDING

## Forever availability

Current API references identify the following on Forever:
- `UnitCastingInfo`;
- `UnitChannelInfo`;
- `UNIT_SPELLCAST_START`;
- `UNIT_SPELLCAST_STOP`;
- `UNIT_SPELLCAST_FAILED`;
- `UNIT_SPELLCAST_INTERRUPTED`;
- `UNIT_SPELLCAST_CHANNEL_START`;
- `UNIT_SPELLCAST_CHANNEL_STOP`;
- `C_Timer.After`.

## Secret restriction

Spellcast queries and spellcast event payloads may be secret under `SecretWhenUnitSpellCastRestricted`.

This is especially relevant to current-target/enemy cast information.

## P0025 design consequence

Logres does not use `UnitCastingInfo` or `UnitChannelInfo` in the production B.4 cue.

Instead it registers cast lifecycle events with the unit filter and reacts only to the event type.

No event payload fields are read.

This produces:
- active cast/channel state;
- stop state;
- interruption/failure state;

without:
- cast progress;
- cast timing;
- spell-name disclosure;
- secret payload inspection.

## Runtime coverage

Player self-cast/channel metadata had already been observed successfully during I-001.

Current-target true-path remains unobserved because the current environment has no convenient enemy caster.

This is an allowed environmental deferral after implementation.
