# System Architecture

## Goal

Logres should behave as one coherent interface system rather than a bundle of addons that independently show/hide frames.

## Intended top-level modules

```text
Logres/
  Core/
  HUD/
  Actions/
  Immersion/
  Camera/
  Config/
  Media/
```

This is an intended architecture only. Actual addon files are created after the Phase 0 API audit.

## Central state ownership

A central state engine owns contextual truth such as:
- immersion enabled;
- context: world / instance / interaction / travel;
- combat;
- PvP flagged;
- mounted;
- resting;
- later context modifiers.

Modules subscribe/respond to state. They should not independently invent global modes.

See `STATE_ENGINE.md`.
