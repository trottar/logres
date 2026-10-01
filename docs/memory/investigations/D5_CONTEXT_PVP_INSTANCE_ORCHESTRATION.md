# D.5 — Context / PvP / Instance Orchestration

Status: SOURCE / DESIGN RESOLVED
Opened: 2026-10-01
Resolved: 2026-10-01

## Result

D-028 is canonical.

The current runtime controller already matches the selected first-pass
suppression matrix:

- Bar 2–3 replacement follows immersion preference only;
- Player replacement follows immersion preference only;
- Target replacement follows immersion preference only;
- Quiet Mode follows immersion preference + world/instance context;
- Party remains unsupported/stock.

ActionContext independently provides presentation precedence:

```text
combat > PvP > instance > world
```

## Important transition property

Combat and PvP transitions should not churn protected replacement ownership.

World/instance transition should change only Quiet Mode among current Phase D
replacement domains.

## Implementation gap

The first D.5 runtime patch does not need new suppression behavior.

It needs integrated diagnostic proof.

Add a Context Policy Check that compares:
- State;
- ImmersionController desired state;
- ActionContext presentation policy;
- supported capability gates.

No secret/protected diagnostic readback.

## Next

Prepare the D.5 Context Policy Check runtime patch.
