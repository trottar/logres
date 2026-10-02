# P0079 — Restoration Failure Diagnostic

Date: 2026-10-02
Result: PREPARED — TARGETED RUNTIME DIAGNOSTIC PENDING

## Baseline

P0078 verified pushed:
`8b38fe64d381bb4ab87b245073cc288ae4f092b7`

## Trigger

P0078 Run All:
- Restoration Check failed at `opposite preference state did not settle`;
- cleanup had no error;
- final state reconverged (`finalOK=true`).

The persisted line did not identify the failing replacement subdomain.

## Change

Extend the existing Restoration Check's failure output to record:
- module readiness;
- desired-policy match;
- recovery requested/applied match;
- ownership coherence;
- error state;
- action snapshot/routing;
- Quiet snapshot;
- Player interaction/presentation ownership;
- Target watch/interaction/presentation ownership and override count.

## Non-change

No:
- retry;
- timer;
- polling;
- periodic reassertion;
- Blizzard hook;
- suppression-policy change.

## Runtime

Production runtime remains:
`0.0.30-dev`.

This is runtime diagnostic code; WoW redeploy is required.

## Validation

Developer panel:
1. Restoration Check once;
2. Run All once;
3. `/reload`;
4. export diagnostics.

If no recurrence occurs, preserve the P0078 failure as intermittent rather than
inventing a fix.
