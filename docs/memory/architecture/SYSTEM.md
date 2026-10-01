# System Architecture

## Goal

Logres behaves as one coherent interface system rather than a bundle of independent addons that each invent their own state and visibility rules.

## Runtime source layout — Phase 0.3

```text
Logres/
  Logres.toc
  Core/
    Bootstrap.lua
    Database.lua
    State.lua
    Commands.lua
    Lifecycle.lua
```

This is the first real addon runtime.

### Bootstrap

Owns:
- addon namespace constants;
- one shared Blizzard event frame;
- event registration/dispatch;
- internal callback registration/dispatch;
- development logging.

Modules do not create competing global event systems unless a future subsystem has a concrete reason.

### Database

Owns:
- `LogresDB`;
- schema/default initialization;
- development debug setting;
- non-sensitive lifecycle metadata such as load count/build/interface.

It does not persist secret combat values, character names, targets, or session telemetry.

### State

Owns the central observed runtime facts required by later presentation systems.

Phase 0.3 fields:
- context (`world` or `instance`);
- combat lockdown state;
- PvP flag;
- instance boolean/type;
- state revision and last triggering event.

Later phases may add orthogonal fields such as interaction, mounted/travel, resting, and immersion enablement.

### Commands

Provides development-only text commands. It is not product UI.

Current command:
`/logres status`

### Lifecycle

Initializes SavedVariables and emits a single development load confirmation.

## Separation rule

Core detects and publishes state.

HUD, Actions, Immersion, Compass, Questing, Social, and Camera modules will consume that state later. They must not duplicate global state ownership.
