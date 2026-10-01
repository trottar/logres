# D-011 — Module lifecycle contract

Status: ACCEPTED  
Date: 2026-09-30

## Decision

Logres uses a small internal module lifecycle rather than a general addon framework.

A module is registered once:

```lua
local module = Logres:RegisterModule("Name", {
    autoEnable = true,

    OnInitialize = function(self)
    end,

    OnEnable = function(self)
    end,

    OnDisable = function(self)
    end,
})
```

All lifecycle methods are optional.

## Registration

Module names:
- are non-empty strings;
- are unique;
- preserve registration order.

Duplicate registration is a programming error and surfaces immediately.

`autoEnable` defaults to `true`.

Development/test modules may set it false.

## Initialization

At `PLAYER_LOGIN`:
1. database already exists;
2. observed state has received its earlier registered `PLAYER_LOGIN` refresh;
3. all registered modules initialize in registration order;
4. only after all initialization completes are default-enabled modules enabled in registration order.

A module initializes at most once per UI load.

Calling `InitializeModule(name)` again is a no-op returning false.

## Enable

Enable is idempotent:
- already enabled -> false;
- otherwise initialize if needed;
- execute `OnEnable`;
- mark enabled only after success.

A module may own cleanup while enabling.

If `OnEnable` errors:
- owned cleanup is attempted;
- module remains disabled;
- the original error is re-raised;
- a cleanup error is also surfaced if one occurred.

## Disable

Disable is idempotent:
- already disabled -> false;
- otherwise `OnDisable` runs;
- module is marked disabled;
- owned cleanup runs in reverse registration order.

If `OnDisable` errors:
- cleanup is still attempted;
- the error is re-raised after cleanup.

## Cleanup ownership

While enabling/enabled:

```lua
self:OwnCleanup(function()
end)
```

records cleanup work.

Owned cleanups:
- run LIFO;
- are cleared after disable or failed enable.

Convenience helpers:

```lua
self:SubscribeState(handler)
self:SubscribePreferences(handler)
```

subscribe through the existing contracts and automatically own the returned unsubscribe function.

## Combat

The generic lifecycle does not infer whether a module's work is protected.

Enable/disable is not globally blocked in combat.

A future module that mutates protected frames must obey its own combat-lockdown rules or defer its protected mutation.

Do not add global combat gating to the lifecycle manager.

## Error policy

Development errors are not silently swallowed.

`pcall` is used only where necessary to guarantee cleanup before re-raising the error.

## Rejected

- AceAddon-like feature expansion;
- automatic dependency graph resolution;
- persistent per-module enabled state;
- global combat gating;
- silently ignoring duplicate registration;
- cleanup lists that survive disable;
- modules directly owning state/preference subscriptions without cleanup.
