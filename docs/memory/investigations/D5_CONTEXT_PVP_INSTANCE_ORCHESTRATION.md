# D.5 — Context / PvP / Instance Orchestration

Status: P0060 IMPLEMENTATION PREPARED; RUNTIME PROOF NEXT
Opened: 2026-10-01
Source/design resolved: 2026-10-01

## Canonical policy

D-028 is canonical.

The runtime ownership matrix remains:
- Bar 2–3 replacement follows immersion preference;
- Player replacement follows immersion preference;
- Target replacement follows immersion preference;
- Quiet Mode = immersion + world context;
- Party remains unsupported/stock.

ActionContext presentation precedence:

```text
combat > PvP > instance > world
```

## P0060

Adds integrated Context Policy Check.

The diagnostic validates:
- State/context shape;
- ImmersionController desired/requested/applied ownership;
- legal combat-deferred protected transitions;
- ActionContext policy + alpha;
- Party/Primary capability gates.

The check does not read Blizzard protected presentation state.

## Runtime proof next

Required:
- world idle;
- Immersion ON/OFF;
- Run All.

Natural/safe:
- combat;
- PvP.

Environmental:
- instance transition if not naturally available.
