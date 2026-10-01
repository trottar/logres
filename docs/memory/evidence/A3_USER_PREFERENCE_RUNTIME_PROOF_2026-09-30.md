# A.3 User Preference Runtime Proof — 2026-09-30

Status: VERIFIED  
Scope: Persisted user-controlled state contract  
Baseline commit: `6a01f8592797811c01e668d7486f374c1b1c03a6`

## Initial false start — deployment omission

The first attempt to run:

```text
/logres preferencecheck
/logres immersion
```

returned the generic command list.

This was not a P0012 runtime defect.

Cause:
- P0012 had been committed/pushed;
- the updated addon had not yet been redeployed to the WoW AddOns directory;
- WoW was therefore still executing the prior deployed build, which did not know the new commands.

After redeploying P0012 and reloading the UI, the commands behaved correctly.

Classification:

**WORKFLOW / DEPLOYMENT OMISSION — NOT PRODUCT FAILURE**

Durable lesson:
runtime instructions for every code patch must explicitly repeat the deploy command before in-game validation, even when the deploy procedure has not changed.

## Correct deployment result

After redeploy and `/reload`, the user reported that the requested A.3 validation looked correct with no issues observed.

The requested validation covered:
- `/logres statecheck`;
- `/logres preferencecheck`;
- `/logres immersion`;
- setting immersion off;
- reload and persistence check;
- restoring immersion on;
- reload and persistence check.

No Lua errors were reported in the corrected test scope.

## Preference contract

The successful `preferencecheck` exercises:
- preference snapshot isolation;
- no-op write stability;
- no callback for no-op set;
- actual-change notifications;
- restoration of the original persisted value.

Result:

**PASS**

## Database migration / default

P0012 advanced the SavedVariables schema from 1 to 2 and introduced:

```text
settings.immersionEnabled
```

The corrected runtime test showed no reported migration/load issue.

Result:

**PASS IN TESTED MIGRATION PATH**

## Persistence

The requested off/reload and on/reload sequence completed without reported issue after correct deployment.

This supports:
- `immersionEnabled=false` persists across reload;
- `immersionEnabled=true` persists after restoration;
- preference value persistence is separate from session-local preference revision.

Result:

**PASS**

## Separation from observed state

Static contract validation already prohibits `immersionEnabled` from `Core/State.lua`.

Runtime state validation continued to pass after adding the separate preference contract.

Result:

**PASS**

## Failures

No product/runtime failure remained after deploying the correct build.

The pre-redeploy command-list result is retained as a workflow negative result because it exposed a repeatable testing hazard.

## Conclusion

A.3 success criteria are satisfied.

**A.3 — User-Controlled State: COMPLETE.**
