# P0014 — A.4 module lifecycle contract

Date: 2026-09-30  
Result: PREPARED — runtime proof pending

## Intent

Create the smallest lifecycle contract required by future Logres feature modules.

## Runtime API

- `RegisterModule`
- `GetModule`
- `GetModuleStatus`
- `InitializeModule`
- `EnableModule`
- `DisableModule`
- `InitializeModules`
- `EnableDefaultModules`

Module helpers:
- `OwnCleanup`
- `SubscribeState`
- `SubscribePreferences`
- `IsInitialized`
- `IsEnabled`

## Startup

At PLAYER_LOGIN:
1. observed state has refreshed;
2. initialize every module in registration order;
3. enable auto-enabled modules in registration order.

## Idempotence

Initialize, enable, and disable return false when no transition is required.

## Cleanup

Owned cleanup:
- LIFO;
- released on disable;
- released on failed enable.

Enable/disable callback errors are re-raised after cleanup attempt.

## Combat

No global combat gate is introduced.

Protected mutation remains the owning module's responsibility.

## Development proof

Adds:
`/logres lifecyclecheck`

It verifies:
- one-time initialization;
- enable idempotence;
- disable idempotence;
- cleanup execution;
- preference subscription active while enabled;
- preference subscription removed while disabled;
- original immersion preference restored.

## Runtime-code deployment

P0014 changes `Logres/`.

Validation instructions must explicitly redeploy before `/reload`.

## Validation

```text
python3 tools/check_memory_health.py
python3 tools/check_addon_structure.py
python3 tools/check_state_contract.py
python3 tools/check_preference_contract.py
python3 tools/check_module_contract.py
git diff --check
```
