# D-010 — User preference contract

Status: ACCEPTED  
Date: 2026-09-30

## Decision

Persisted user choices are a separate contract from observed game state.

Observed facts remain behind:
- `Logres:GetState()`;
- `Logres:SubscribeState()`.

Persisted user preferences use:
- `Logres:GetPreferences()`;
- `Logres:GetPreference(name)`;
- `Logres:SetPreference(name, value, reason)`;
- `Logres:SubscribePreferences(handler)`.

`immersionEnabled` is the first preference.

## Initial preference

```text
immersionEnabled: boolean
default: true
```

The default follows the product thesis: Logres' immersive presentation is on unless the user chooses otherwise.

## Separation rule

Do not add `immersionEnabled` to the observed state table.

It is not a Blizzard fact.

Future presentation policy may derive effective behavior from both:
- observed state;
- user preferences.

That derived policy belongs in a later layer.

## Preference snapshot

A.3 snapshot:

```lua
{
    revision = number,
    immersionEnabled = boolean,
}
```

The snapshot is a copy.

Consumer mutation cannot alter persisted authority.

## Revision semantics

Preference revision is session-local:
- starts at `0` each UI load;
- increments once for each actual preference change;
- does not increment for a no-op set;
- is not persisted.

The preference value itself is persisted.

The revision exists only to order runtime notifications inside the current session.

## Subscription semantics

Callback:

```text
handler(current, previous, changes, reason)
```

Each subscriber receives copies.

No callback occurs for a no-op set.

`SubscribePreferences()` returns an unsubscribe function.

## Validation

Preference names and value types are validated before mutation.

For A.3:

```text
immersionEnabled -> boolean
```

Unknown preferences or wrong value types are programming errors.

## Persistence / schema

Database schema moves from 1 to 2.

Schema 2 adds:

```text
settings.immersionEnabled = true
```

Migration is additive:
- existing debug setting is retained;
- existing metadata is retained;
- existing database gains the preference only when absent;
- new databases start at schema 2.

A database newer than the runtime-supported schema is rejected rather than silently downgraded.

## Rejected

- placing user preference inside observed `State`;
- deriving user intent from game context;
- resetting immersion preference on reload;
- using an untyped arbitrary settings write API;
- persisting runtime preference revision.
