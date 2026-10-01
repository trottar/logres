# State Engine Architecture

## Principle

Logres separates **state detection** from **presentation policy**.

State detection answers facts:
- Is the player in combat lockdown?
- In an instance?
- What instance type?
- PvP flagged?

Presentation policy later answers:
- Should the compass exist?
- How opaque is an action cluster?
- Which target information is shown?
- Which camera behavior applies?

## Phase 0.3 implementation

The real skeleton exposes:

```lua
Logres.State = {
    initialized = false,
    revision = 0,

    context = "unknown", -- later world / instance
    combat = false,
    pvpFlagged = false,
    inInstance = false,
    instanceType = "none",

    lastEvent = "bootstrap",
}
```

The table is runtime source state, not SavedVariables.

## Inputs

Phase 0.3 refreshes from:
- `PLAYER_LOGIN`;
- `PLAYER_ENTERING_WORLD`;
- `ZONE_CHANGED_NEW_AREA`;
- `PLAYER_REGEN_DISABLED`;
- `PLAYER_REGEN_ENABLED`;
- `PLAYER_FLAGS_CHANGED`;
- `ADDON_RESTRICTION_STATE_CHANGED`.

Observed values come from:
- `InCombatLockdown()`;
- `IsInInstance()`;
- `UnitIsPVP("player")`.

## Combat transition rule

I-001 runtime evidence falsified the assumption that `PLAYER_REGEN_DISABLED` means every combat/restriction API has already settled inside that callback.

Therefore:
- no single combat event is treated as final truth;
- each authoritative transition signal triggers a fresh observation;
- later restriction-state events may update state again;
- consumers react to state revisions, not assumptions about one event's timing.

## Change publication

`RefreshState()` increments `revision` only when tracked state changes, then fires:

```text
STATE_CHANGED
```

through the internal callback bus.

Later modules subscribe to state rather than registering redundant global context logic.

## Orthogonal-state constraint

Do not model every combination as a monolithic mode such as:
- `WorldPvPCombat`;
- `InstanceCombat`;
- `WorldInteractionPvP`.

Prefer independent facts/modifiers and derive presentation from them.

## Deferred fields

Not part of the Phase 0.3 skeleton:
- immersion enabled;
- NPC interaction;
- mounted/travel;
- resting;
- camera situation;
- quest/navigation availability.

Add them only when their owning phase needs them and evidence defines their event/API behavior.
