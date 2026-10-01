# P0062 — Resolve D.6 Restoration Validation

Date: 2026-10-01
Result: PREPARED — not durable until user commits/pushes

## Baseline

P0061 verified pushed:
`01665d1`

Runtime:
`0.0.26-dev`

## Source result

No new suppression policy is required.

Existing source already provides:
- fail-open controller disable;
- exact restoration in each supported domain;
- protected combat deferral;
- independent post-combat convergence in action/Player/Target replacement
  modules;
- controller re-enable reconciliation from persisted preference + State.

## P0063 design

Add one integrated Restoration Check.

Out of combat:
1. verify current settled ownership;
2. flip immersion preference;
3. verify opposite settled ownership;
4. restore original preference;
5. verify convergence;
6. disable ImmersionController;
7. verify supported stock ownership is restored fail-open;
8. re-enable ImmersionController;
9. verify reconvergence;
10. verify the original preference is unchanged at exit.

In combat:
- do not execute the active cycle;
- validate current requested/applied/pending legality only.

## Diagnostic boundary

Use addon-owned recovery state.

Add explicit Player secure-interaction ownership state.

Do not inspect protected Blizzard presentation values solely to prove native
mutation.

Context Policy Check remains the D-028 context proof.

Reload persistence remains a real `/reload` validation step.

## Runtime target

P0063:
`0.0.27-dev`

## Code changes

None.

## Deployment

No WoW redeploy required.
