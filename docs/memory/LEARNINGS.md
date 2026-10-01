# Project Learnings

Reusable lessons belong here when they generalize beyond one immediate patch or investigation.

## L-001 — Preserve negative results

A failed implementation is valuable if it rules out a path, exposes an API boundary, identifies a visual failure, or falsifies an assumption.

Future work must be able to distinguish:
- never tried;
- tried and failed;
- tried and deferred;
- superseded;
- successful only under limited conditions.

Therefore negative results are retained in canonical records rather than omitted from history.

## L-002 — Design intent and API feasibility are different authorities

A design decision states what Logres wants the experience to be. An API investigation states what WoW Forever permits. Neither silently overwrites the other.

When they conflict:
1. preserve the intended experience;
2. record the technical restriction;
3. investigate approximations;
4. make an explicit superseding decision if compromise is required.

## L-003 — Do not let conventional MMO UI defaults erase intentional uncertainty

A conventional implementation may reveal level, elite status, exact HP, cast timing, or other metadata simply because the API provides it.

In Logres, availability is not sufficient justification for display. The disclosure policy must be deliberate.

## L-004 — Assume Lua 5.1-era compatibility unless runtime proves otherwise

The first runtime probe failed because `table.pack` was unavailable.

For Logres and its tooling, prefer compatibility helpers for standard-library features that are not guaranteed in WoW's Lua environment. A tool that fails before measuring the game API is a probe failure, not an API result.

## L-005 — Secret does not mean undisplayable

On Forever 1.60.1, player health/power percentages were secret even in ordinary open-world, out-of-combat snapshots.

Nevertheless:
- secret percentage -> `string.format` -> secret string -> `FontString:SetText` worked;
- secret normalized health -> `StatusBar:SetValue` worked;
- secret normalized health -> `Texture:SetAlpha` worked;
- the same display path continued to work during combat lockdown.

Therefore the correct architecture is to move secret values through permitted native transformations/display aspects, not to attempt to recover ordinary numbers.

## L-006 — Combat events and settled combat state are not identical moments

In the first runtime pass, `PLAYER_REGEN_DISABLED` fired before `InCombatLockdown()` had become true. Restriction state then changed through intermediate observations before later snapshots showed active lockdown.

State-engine code must read current state and tolerate event ordering rather than assuming a single event means all related restrictions have already settled.
