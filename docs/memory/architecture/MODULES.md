# Module Architecture

Status: A.4 IMPLEMENTATION PREPARED

## Purpose

Modules provide a small lifecycle boundary for later Logres subsystems:
- HUD;
- Immersion;
- Actions;
- Compass;
- Questing;
- Camera;
- Social.

The lifecycle is infrastructure, not presentation policy.

## Registration

```lua
local module = Logres:RegisterModule("Example", {
    autoEnable = true,

    OnInitialize = function(self)
    end,

    OnEnable = function(self)
    end,

    OnDisable = function(self)
    end,
})
```

Registration order is authoritative startup order.

## Startup sequence

TOC load order:

```text
Bootstrap
Database
Preferences
State
Modules
Commands
Lifecycle
```

At `PLAYER_LOGIN`:
1. State's earlier registered handler refreshes observed state.
2. Lifecycle confirms database initialization.
3. `InitializeModules()` initializes every registered module in registration order.
4. `EnableDefaultModules()` enables `autoEnable ~= false` modules in registration order.

This gives future modules a stable database/state/preference boundary before their enable phase.

## Idempotence

```text
InitializeModule:
  first -> true
  later -> false

EnableModule:
  disabled -> true
  enabled -> false

DisableModule:
  enabled -> true
  disabled -> false
```

## Resource ownership

Modules own temporary resources through:

```lua
self:OwnCleanup(cleanup)
```

Cleanup executes LIFO.

Common subscriptions:

```lua
self:SubscribeState(handler)
self:SubscribePreferences(handler)
```

are automatically released on disable or failed enable.

## Error behavior

Lifecycle errors surface.

Enable/disable callbacks are protected only long enough to perform cleanup, then the error is re-raised.

The system does not convert module failures into silent logs.

## Combat behavior

The lifecycle layer itself is combat-agnostic.

Protected-frame rules belong to the owning module because:
- many modules have no protected mutations;
- global gating would conflate lifecycle state with Blizzard protection rules;
- Phase C will own secure-action specifics.

## Development probe

`DevLifecycleProbe`:
- autoEnable false;
- initialized during normal startup;
- enabled only by `/logres lifecyclecheck`.

The command verifies:
- one-time initialization;
- idempotent enable;
- idempotent disable;
- owned cleanup;
- preference subscription active only while enabled;
- cleanup list empty after disable;
- user's original immersion preference restored.

It requires no travel or combat.
