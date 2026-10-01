# System Architecture

## Goal

Logres behaves as one coherent interface system rather than a bundle of independent addons that each invent their own state and visibility rules.

## Runtime source layout — Phase A complete

```text
Logres/
  Logres.toc
  Core/
    Bootstrap.lua
    Database.lua
    Preferences.lua
    State.lua
    Modules.lua
    Commands.lua
    Lifecycle.lua
```

Phase B begins adding feature modules on top of these Core contracts.

## Bootstrap

Owns:
- addon namespace constants;
- shared Blizzard event frame;
- event registration/dispatch;
- internal callbacks;
- development logging.

## Database

Owns:
- `LogresDB`;
- schema/default initialization;
- migrations;
- persistent preferences/settings;
- non-sensitive lifecycle metadata.

Current schema:
`2`

Never persist secret combat values.

## Preferences

Owns durable user choice separately from observed game state.

Current preference:
- `immersionEnabled`.

Consumer contract:
- `GetPreferences`;
- `GetPreference`;
- `SetPreference`;
- `SubscribePreferences`.

## State

Owns observed runtime facts.

Canonical fields include:
- context;
- combat;
- PvP flag;
- instance state/type;
- mounted;
- resting;
- taxi;
- interaction/type;
- revision/transition metadata.

Consumers use snapshots/subscriptions, not the mutable authority.

## Modules

Owns lightweight feature lifecycle:
- registration order;
- one-time initialization;
- idempotent enable/disable;
- LIFO cleanup;
- owned state/preference subscriptions.

It is not a general addon framework.

## Commands

Development diagnostics and explicit test controls.

It is not product UI.

## Lifecycle

Coordinates:
- database readiness;
- state initialization ordering;
- module initialization;
- default module enabling.

## Separation rule

Core detects/persists/publishes facts and user choice.

Feature modules consume those contracts.

Phase B HUD, Phase C Actions, Phase D Immersion, Compass, Questing, Social, and Camera must not duplicate global state ownership.
