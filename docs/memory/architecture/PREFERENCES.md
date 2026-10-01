# Preference Architecture

Status: A.3 IMPLEMENTATION PREPARED

## Purpose

Preferences represent durable user intent.

They are not observed game state.

## Boundary

Observed facts:
- `GetState()`;
- `SubscribeState()`.

User choices:
- `GetPreferences()`;
- `GetPreference(name)`;
- `SetPreference(name, value, reason)`;
- `SubscribePreferences(handler)`.

Presentation modules will later combine both inputs.

## Current preference schema

```text
immersionEnabled: boolean = true
```

## Database schema

Current SavedVariables schema:

```text
2
```

Schema 1 -> 2 migration adds `settings.immersionEnabled=true` only when the value is missing.

## Runtime notification

Preference change callbacks mirror the useful shape of state transitions:

```text
handler(current, previous, changes, reason)
```

No-op sets do not publish.

Preference revision is session-local and not persisted.

## Development commands

```text
/logres immersion
/logres immersion on
/logres immersion off
/logres immersion toggle
/logres preferencecheck
```

`preferencecheck` restores the original preference before returning.

## Persistence proof

A.3 runtime proof should explicitly cross reload boundaries:

1. verify schema 2/default;
2. set immersion off;
3. reload;
4. verify off persisted;
5. set immersion on;
6. reload;
7. verify on persisted.

This test is travel-free.
