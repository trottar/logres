# D-028 — Context / PvP / Instance Orchestration Matrix

Status: ACCEPTED
Date: 2026-10-01

## Decision

Phase D context orchestration remains orthogonal.

There is no global "world/combat/PvP/instance mode" object.

Each presentation/suppression domain consumes only the state facts required by
its own policy.

## Immersion OFF

`immersionEnabled=false` is the hard restore preference.

Desired supported stock suppression:

```text
Bar 2–3 replacement = OFF
Quiet Mode = OFF
Player selective replacement = OFF
Target selective replacement = OFF
Party suppression = OFF
```

## Immersion ON

### Supported replacement ownership

```text
Bar 2–3 replacement = ON in world and instances
Player selective replacement = ON in world and instances
Target selective replacement = ON in world and instances
Party suppression = OFF / unsupported
```

Combat and PvP flagging do not change those desired values.

### Quiet Mode

```text
world = ON
instance = OFF
```

Combat and PvP flagging do not override the context decision.

All current instance subtypes use the same conservative Quiet Mode OFF policy.

### Action presentation

ActionContext retains:

```text
combat > PvP flagged > instance > world
```

Current alpha policies remain:

```text
world:    P 1.00 / S 0.45 / U 0.20
PvP:      P 1.00 / S 0.75 / U 0.40
instance: P 1.00 / S 0.70 / U 0.45
combat:   P 1.00 / S 1.00 / U 0.75
```

This is presentation emphasis only.

It does not change stock replacement ownership.

## Transition contract

### Combat enter/leave

Change:
- ActionContext presentation.

Do not change desired:
- Bar 2–3 replacement;
- Quiet Mode;
- Player replacement;
- Target replacement.

### PvP flag transition

Change:
- ActionContext presentation where combat does not already take precedence.

Do not change desired stock suppression.

### World / instance transition

Change:
- Quiet Mode only.

Keep Bar 2–3, Player, and Target replacement ownership stable.

### Immersion preference transition

This is the transition that changes all supported replacement ownership.

Protected domains may defer during combat.

Quiet Mode may transition immediately.

Temporary cross-domain asynchrony during combat is acceptable and safer than
forcing synchronized protected mutation.

## Capability failure

Fail open per domain.

One failed replacement does not imply:
- Immersion preference OFF;
- restoration of all other proven domains.

Preserve the stock surface for the failed domain and keep independent proven
domains operating.

## No first-pass instance subtype branching

`instanceType` remains observed and diagnosable, but D.5 does not branch policy
by subtype.

Add subtype policy only when a concrete product/runtime need exists.

## Unused orthogonal state

Mounted, resting, taxi, and interaction state do not affect current Phase D
stock suppression.

Later systems may consume them independently.

## Future systems

Compass, quest presentation, and camera should use the same orthogonal state
model in later phases.

Their future policies do not expand Phase D runtime ownership.
