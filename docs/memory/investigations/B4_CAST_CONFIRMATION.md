# B.4 — Cast Confirmation

Status: IMPLEMENTATION PREPARED; RUNTIME PROOF NEXT
Opened: 2026-10-01

## Goal

Add minimal cast/channel cues for:
- the player;
- the current target.

No conventional cast bars.

## Source resolution

Forever spellcast APIs/events are subject to `SecretWhenUnitSpellCastRestricted`.

For non-player units, spellcast query/event payload information may therefore be secret.

P0025 avoids querying cast metadata entirely.

Instead:
- player spellcast events are registered on a unit-filtered `"player"` frame;
- target spellcast events are registered on a unit-filtered `"target"` frame;
- handlers consume only the event name;
- `unitTarget`, `castGUID`, `spellID`, `interruptedBy`, and other event payloads are ignored.

This gives Logres the cast lifecycle signal without inspecting restricted target cast data.

## Event set

P0025 listens for:
- `UNIT_SPELLCAST_START`;
- `UNIT_SPELLCAST_STOP`;
- `UNIT_SPELLCAST_FAILED`;
- `UNIT_SPELLCAST_FAILED_QUIET`;
- `UNIT_SPELLCAST_INTERRUPTED`;
- `UNIT_SPELLCAST_CHANNEL_START`;
- `UNIT_SPELLCAST_CHANNEL_STOP`.

No progress/timing events are required because Logres does not show cast progress.

## Visual states

### Player

Cue sits immediately left of the existing resource percentage.

- cast: warm amber;
- channel: cool blue;
- interrupted/failed: brief red snap;
- stop/channel-stop: hidden.

### Current target

Cue sits immediately right of the sparse target block.

- cast: warm orange;
- channel: violet;
- interrupted/failed: brief red snap;
- stop/channel-stop: hidden;
- target change: forcibly hidden.

## Interruption snap

`C_Timer.After(0.18, ...)` clears the brief red interruption state.

A generation counter prevents an old interruption timer from hiding a newly started cast.

## Important limitation

Because P0025 does not query restricted cast state, acquiring a target already in the middle of a cast may not immediately show a cue.

The cue is guaranteed from subsequent spellcast lifecycle events while that unit is the current target.

This limitation is preferred to inspecting secret target cast metadata.

Revisit only if a native secret-safe visibility mechanism is proven necessary.

## Runtime plan

After deploy:
1. confirm `0.0.11-dev`;
2. existing checks + `/logres hudcheck` pass;
3. player normal cast -> amber cue appears, then disappears;
4. player channel -> blue cue appears, then disappears, if current character has an accessible channel;
5. interrupt/fail a player cast if practical -> red snap;
6. immersion off/on during a cast -> cue follows HUD root;
7. target cue geometry/event path is tested if a convenient caster exists;
8. otherwise record target-cast true-path `DEFERRED BY ENVIRONMENT`.

No travel is required solely to locate an enemy caster.

## Exit

B.4 completes when:
- player cue is runtime proven;
- target cue implementation is structurally present;
- target true-path is either proven or environmentally deferred;
- no conventional cast bar is introduced;
- no secret-value/Lua error occurs.
