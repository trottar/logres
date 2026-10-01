# D-021 — Action context and secure paging contract

Status: ACCEPTED
Date: 2026-10-01

## Decision

C.4 separates two concerns:

1. **contextual presentation emphasis**
2. **protected action-page execution**

Do not use protected Show/Hide mutation merely to achieve visual emphasis.

## Contextual emphasis

Use alpha changes for the first contextual visibility implementation.

Rules:
- Primary remains fully legible.
- Secondary fades outside combat.
- PvP flagging raises Secondary visibility before combat.
- Combat makes Secondary fully visible.
- Utility remains more peripheral but rises in combat.
- instance idle uses a conservative higher visibility than ordinary world idle.

No cluster is alpha-zero.

Reason:
alpha-zero protected buttons remain clickable and would create invisible
interaction zones.

## State model

Consume existing orthogonal state:
- combat;
- pvpFlagged;
- context.

Do not add an `actionMode = "pvpcombatinstance"` style combined state.

Presentation precedence may choose the strongest relevant policy, but state
storage remains orthogonal.

## Initial policy constants

First-pass values:

| State | Primary | Secondary | Utility |
| --- | ---: | ---: | ---: |
| world/default idle | 1.00 | 0.45 | 0.20 |
| PvP flagged idle | 1.00 | 0.75 | 0.40 |
| instance idle | 1.00 | 0.70 | 0.45 |
| combat | 1.00 | 1.00 | 0.75 |

These values are runtime-tunable.

They are not permanent product constants.

## Protected visibility

Ordinary Lua must not Show/Hide protected action clusters during combat.

If later requirements need actual contextual disappearance:
- configure a secure visibility/attribute driver out of combat;
- runtime-prove it independently;
- retain a safe interaction/restoration path.

C.4 initial implementation does not require true hiding.

## Primary secure paging

Primary should migrate from insecure combat-time concrete action-slot mutation
toward SecureActionButtonTemplate's built-in paging model.

Target:
- button IDs 1–12;
- secure `actionpage` attribute driver;
- normal page conditionals;
- source-resolved special page conditionals where practical.

The secure action itself must select the right page during combat without
waiting for `PLAYER_REGEN_ENABLED`.

## Presentation synchronization

Secure execution state and ordinary presentation state are distinct.

After secure page changes:
- icon;
- cooldown;
- count;
- usability;
- range;
- native action-button registration;

must follow the same active concrete slot.

Do not declare secure paging complete merely because clicking executes a
different action.

## Special-state gate

Full primary replacement is not proven until relevant special action states
are covered.

Potential states:
- class bonus/form bars;
- temporary shapeshift;
- vehicle;
- override/quest;
- possess.

Until proven:
stock Blizzard bars remain visible.

## Fail-open rule

If a special state is not covered:
- do not suppress the stock surface;
- do not remove the player's required action path.

D-017 and L-011 remain authoritative.

## D-020 compatibility

Context policy should attach to cluster roles.

Future layout profiles can alter geometry/action domains without redefining the
meaning of:
- Primary;
- Secondary;
- Utility;
- later additional roles.
