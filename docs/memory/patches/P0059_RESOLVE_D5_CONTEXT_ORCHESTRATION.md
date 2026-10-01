# P0059 — Resolve D.5 context orchestration

Date: 2026-10-01
Result: PREPARED — not durable until user commits/pushes

## Baseline

P0058 verified pushed:
`eba9998`

Runtime:
`0.0.25-dev`

## Result

D-028 accepted.

### Immersion ON

- Bar 2–3 replacement: ON in world + instance;
- Player replacement: ON in world + instance;
- Target replacement: ON in world + instance;
- Quiet Mode: ON in world, OFF in instance;
- Party suppression: always OFF.

Combat and PvP do not change replacement ownership.

### Action presentation

Precedence remains:

```text
combat > PvP > instance > world
```

### Instance subtype

Observed but not policy-bearing in the first pass.

### Other orthogonal sensors

Mounted/resting/taxi/interacting do not affect current Phase D suppression.

## Implementation consequence

Current controller behavior already matches D-028.

Next runtime patch should add integrated Context Policy Check diagnostics, not
new suppression policy.

## Code changes

None.

## Deployment

No redeploy required.
