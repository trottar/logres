# P0166 R0 — delivery preflight self-mismatch

Date: 2026-10-07
Baseline: `0e83af06cd03ea18671ff52ef8772bf2a4b8818a`
Candidate runtime: `0.0.83-dev`
Classification: **DELIVERY / STATIC-CONTRACT FAIL — NO TRACKED WRITE**

## Observed result

The initial P0166 applier reached its shadow-tree checker suite and stopped at:

`check_layout_integration_contract.py failed (1)`

with:

`Logres/HUD/PetActionExecutionProbe.lua missing layout integration: Logres.Layout.Bind(self.cluster, "classPet", "CENTER", "CENTER")`

The subsequent `git status --short` showed only the expected untracked
`LOGRES_DIAGNOSTICS_LATEST.lua` and extracted `P0166_PAYLOAD/`; no tracked files
were modified. GitHub `main` remained at the exact P0165 R1 baseline.

## Cause

The generated PetAction candidate used the intended call in multi-line form:

```lua
Logres.Layout.Bind(
    self.cluster,
    "classPet",
    "CENTER",
    "CENTER"
)
```

The new layout checker instead searched for the same call as one exact single-line
fragment. This was a checker/source self-mismatch in the delivery artifact, not a
runtime or layout-policy failure.

## R1 correction

P0166 R1 makes the checker validate the call with a whitespace-tolerant regular
expression and retains the existing generated runtime candidate unchanged. The
full shadow checker suite still runs before any tracked write, so further candidate
self-mismatches remain fail-closed.
