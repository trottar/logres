# D.5 P0060 Context Policy Check Implementation — 2026-10-01

Status: IMPLEMENTATION PREPARED; RUNTIME PROOF NEXT
Date: 2026-10-01

## Runtime version

`0.0.26-dev`

## Goal

Add integrated runtime proof for D-028 without changing the selected
orchestration policy.

## Diagnostic

Adds:
- `/logres contextpolicycheck`;
- `Context Policy Check` developer-panel action;
- Context Policy Check to Run All.

The check compares only:
- Logres State snapshot;
- Logres preference snapshot;
- ImmersionController addon-owned debug state;
- ActionContext addon-owned debug state.

It does not inspect Blizzard PlayerFrame/TargetFrame presentation state.

## Validated state shape

The check validates:
- `context` is world or instance;
- `context` agrees with `inInstance`;
- combat/PvP/inInstance are boolean state facts;
- `instanceType` is reported but is not policy-bearing.

## Validated ownership

Expected with immersion preference:

```text
Bar 2–3 replacement = immersion
Player replacement = immersion
Target replacement = immersion
Quiet Mode = immersion AND world context
Party suppression = false
Primary routing ownership = false
```

Protected action/Player/Target applied state may be temporarily different from
desired only while pending in combat.

Quiet Mode must match context immediately because its current implementation is
not protected in the same way.

## Validated action presentation

Expected precedence:

```text
combat > PvP > instance > world
```

Expected alpha:

```text
world    1.00 / 0.45 / 0.20
PvP      1.00 / 0.75 / 0.40
instance 1.00 / 0.70 / 0.45
combat   1.00 / 1.00 / 0.75
```

These are ActionContext-owned non-secret values.

## Runtime proof plan

Immediately test:
- world idle;
- Immersion ON;
- Immersion OFF;
- Run All.

Where safe/natural:
- enter/leave combat;
- PvP flag transition.

Instance transition may remain environmental if no instance is naturally
available.

On an instance transition, expected supported-domain ownership is unchanged
except Quiet Mode:
- world -> instance: Quiet ON -> OFF;
- instance -> world: Quiet OFF -> ON.

No protected/secret UI state is added to the diagnostic.
