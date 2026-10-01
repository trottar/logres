# P0012 — A.3 user preference contract

Date: 2026-09-30  
Result: PREPARED — runtime proof pending

## Intent

Add the first durable user-controlled state without conflating it with observed game state.

## Preference

```text
immersionEnabled: boolean
default: true
```

## API

- `GetPreferences()`
- `GetPreference(name)`
- `SetPreference(name, value, reason)`
- `SubscribePreferences(handler)`

## Database

Schema:
`1 -> 2`

Migration adds `settings.immersionEnabled=true` only when absent.

A newer unsupported schema is rejected instead of downgraded.

## Runtime semantics

Preference revision:
- session-local;
- starts zero;
- increments only on real changes;
- not persisted.

Preference value:
- persisted in `LogresDB`.

## Development validation

Adds:
- `/logres preferencecheck`
- `/logres immersion [on|off|toggle]`

`preferencecheck` verifies:
- snapshot isolation;
- no-op stability;
- exactly two callbacks for change+restore;
- original value restored.

## Persistence proof

Required after deploy:
- set off;
- reload;
- confirm off;
- set on;
- reload;
- confirm on.

## No HUD/settings UI

A.3 proves the contract only.

A settings interface belongs later.

## Validation

```text
python3 tools/check_memory_health.py
python3 tools/check_addon_structure.py
python3 tools/check_state_contract.py
python3 tools/check_preference_contract.py
git diff --check
```
