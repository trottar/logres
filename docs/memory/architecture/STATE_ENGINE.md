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

## Authority boundary

The authoritative mutable state table is private to `Core/State.lua`.

Consumers use:

```lua
local state = Logres:GetState()
```

and optionally:

```lua
local unsubscribe = Logres:SubscribeState(function(current, previous, changes, reason)
    -- react to transition
end)
```

No consumer should access `Logres.State`.

See D-009 for the canonical consumer contract.

## A.1 canonical snapshot

```lua
{
    initialized = boolean,
    revision = number,

    context = "unknown" | "world" | "instance",
    combat = boolean,
    pvpFlagged = boolean,
    inInstance = boolean,
    instanceType = string,

    changedBy = string,
}
```

All values are scalar.

A snapshot is a copy. Consumer mutation cannot change authoritative state.

## Revision semantics

- starts at `0`;
- first initialization -> `1`;
- increments exactly once per actual canonical state transition;
- no-op observations do not increment revision;
- no-op observations do not emit state notifications.

`changedBy` changes only with a real transition.

## Transition notification

Subscriber signature:

```text
handler(current, previous, changes, reason)
```

- `current`: fresh post-transition snapshot;
- `previous`: fresh pre-transition snapshot or nil on initialization;
- `changes`: changed observed fields only;
- `reason`: event/manual trigger that produced the transition.

Each subscriber receives separate copies.

## Initialization

First successful observation is a transition:
- previous is nil;
- all canonical observed fields are listed as changing from nil;
- revision becomes 1.

Subscription itself is not a transition and does not replay state automatically.

## Current observed inputs

Phase A.1 still observes:
- `InCombatLockdown()`;
- `IsInInstance()`;
- `UnitIsPVP("player")`.

Refresh signals:
- `PLAYER_LOGIN`;
- `PLAYER_ENTERING_WORLD`;
- `ZONE_CHANGED_NEW_AREA`;
- `PLAYER_REGEN_DISABLED`;
- `PLAYER_REGEN_ENABLED`;
- `PLAYER_FLAGS_CHANGED`;
- `ADDON_RESTRICTION_STATE_CHANGED`.

## Combat transition rule

I-001 runtime evidence falsified the assumption that `PLAYER_REGEN_DISABLED` means every combat/restriction API has already settled inside that callback.

Therefore:
- no single combat event is final truth;
- each authoritative transition signal triggers a fresh observation;
- a refresh only publishes when observed canonical state actually differs;
- consumers do not depend on Blizzard event ordering.

## Orthogonal-state constraint

Do not model combinations as monolithic modes such as:
- `WorldPvPCombat`;
- `InstanceCombat`;
- `WorldInteractionPvP`.

Prefer independent facts/modifiers and derive presentation later.

## Development validation

`/logres statecheck` provides a travel-free contract check:
- consumer snapshot mutation cannot alter authoritative state;
- a no-op refresh does not advance revision;
- a no-op refresh does not notify subscribers.

This does not replace real transition testing when a sensor's behavior changes.

## Deferred fields

Not part of A.1:
- immersion enabled;
- NPC interaction;
- mounted/travel;
- resting;
- camera situation;
- quest/navigation availability.

Those belong to subsequent Phase A work.
