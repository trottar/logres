# P0159 Initial Shadow-Preflight Failure — 2026-10-06

Status: **DELIVERY FAILURE — PRE-WRITE SHADOW-CANDIDATE REFUSAL**

Baseline:
`27670624e8c001dc341ac92ad9c463f2f61088de`

## Observed result

The initial `P0159_DYNAMICCAM_PROFILE_CONTEXT_ZOOM_PARITY.zip` matched its
published SHA-256 and unpacked successfully.

Its applier then failed while validating the temporary shadow candidate, before
any tracked repository file was written.

The first failing checker was:

`tools/check_camera_city_contract.py`

with:

- `Camera/WorldCombat.lua missing G.4 City contract: if context == "city" then`
- `Camera/WorldCombat.lua missing G.4 City contract: return CITY_TARGET`

The user's resulting worktree showed only pre-existing/untracked diagnostics plus
the unpacked `P0159_PAYLOAD/` transport directory.

## Cause

The candidate renderer inserted the new local context helpers immediately before
`Controller:Reconcile()`.

It then replaced the complete `Controller:OnUpdate()` -> `Controller:Reconcile()`
range. That replacement deleted the just-inserted helper block from the shadow
candidate.

The City checker correctly detected the missing helper-owned City target path.

This was a patch-delivery sequencing defect, not a runtime Camera failure.

## R1 correction

P0159 R1:

1. renders `FinishTransition`, `OnUpdate`, and `Reconcile` first;
2. inserts the context helpers only after those replacements are complete;
3. places the helpers immediately before `FinishTransition`, which also preserves
   Lua local-scope visibility for `contextAllowsLimitedTarget()`;
4. strengthens the dedicated P0159 checker to assert helper ordering;
5. preserves the finite Fishing exit-hold OnUpdate when an active zoom transition
   finishes during that hold.

No tracked changes from the failed initial artifact are treated as installed.
