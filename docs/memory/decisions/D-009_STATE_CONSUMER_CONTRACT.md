# D-009 — State consumer contract

Status: ACCEPTED  
Date: 2026-09-30

## Decision

The authoritative mutable runtime state is private to `Core/State.lua`.

Consumers must not receive or mutate the authoritative table directly.

Supported consumer API:

```lua
local state = Logres:GetState()

local unsubscribe = Logres:SubscribeState(function(current, previous, changes, reason)
    -- react to a real state transition
end)
```

## Snapshot semantics

`Logres:GetState()` returns a fresh scalar snapshot.

Mutating that snapshot must not mutate authoritative Logres state.

Canonical snapshot fields for A.1:

```text
initialized
revision
context
combat
pvpFlagged
inInstance
instanceType
changedBy
```

`changedBy` is the event/reason that produced the most recent actual state transition. It is not updated for a no-op observation.

## Revision semantics

- revision starts at `0`;
- first successful state initialization publishes revision `1`;
- revision increases by exactly one only when one or more canonical observed fields change;
- a refresh that observes no canonical change returns `false`, emits no state notification, and does not advance revision.

## Subscription semantics

`Logres:SubscribeState(handler)`:
- requires a function;
- subscribes only to real state transitions;
- returns an unsubscribe function;
- does not replay current state automatically.

Consumers that need immediate state should:
1. subscribe;
2. call `Logres:GetState()`.

Because WoW addon Lua executes synchronously, this gives a simple consumer pattern without conflating a subscription replay with a real state transition.

## Callback payload

For each actual transition:

```text
handler(current, previous, changes, reason)
```

Where:
- `current` is a fresh post-transition snapshot;
- `previous` is a fresh pre-transition snapshot, or `nil` for first initialization;
- `changes` maps each changed canonical observed field to `{ old = ..., new = ... }`;
- `reason` is the event/manual reason that triggered the successful transition.

Each subscriber receives its own copies of snapshots/change records so one consumer cannot mutate another consumer's callback payload.

## Initialization transition

On first initialization:
- `previous == nil`;
- all canonical observed fields appear in `changes` with `old = nil`;
- revision becomes `1`.

## Rejected

- exposing `Logres.State` as the authoritative mutable table;
- consumers registering their own duplicate global context-event logic;
- revision increments for no-op observations;
- using `changedBy` as a generic "last event seen" field.

## Rationale

Later HUD/Immersion/Action/Camera modules need a stable boundary that prevents accidental mutation and does not couple them to Blizzard event ordering.

I-001 also proved that event occurrence and settled state are not always the same moment. Consumers therefore react to published state transitions, not assumptions about individual Blizzard events.
