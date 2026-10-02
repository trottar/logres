# P0088 Delivery Failure — Stale Compass Runtime Freeze — 2026-10-02

Status: RESOLVED IN P0088 REPAIR
Date: 2026-10-02
Baseline: P0087 `4aecb22418d8980f2a121acce4d9eeafdf4a604b`

## Failure

The first P0088 apply reached temporary-tree validation and failed:

```text
Logres D-029 / E.4 compass contract
===================================
ERROR: E.4 runtime must identify as 0.0.30-dev

FAILED: 1 error(s)
P0088: command failed (1): python3 tools/check_compass_contract.py
```

## Cause

P0088 intentionally advances the production runtime from `0.0.33-dev` to
`0.0.34-dev`.

`tools/check_compass_contract.py` already verified that Bootstrap and TOC
versions matched, but then separately froze the current runtime at the
historical E.4 introduction version `0.0.30-dev`.

That historical-version assertion was obsolete. A feature contract checker must
validate the feature's current structural/safety contract and current
Bootstrap/TOC version synchronization, not pin the repository forever to the
version on which the feature was introduced.

This is the same checker-maintenance class previously recorded for P0083.

## Mutation boundary

The failure occurred in the temporary `git archive` validation tree.

Therefore:
- no P0088 tracked target file was written;
- no P0088 manifest was created;
- remote `main` remained P0087 at `4aecb22`;
- only untracked P0088 delivery files/payload remained locally.

## Correction

The P0088 repair:
- removes only the Compass checker's historical `0.0.30-dev` freeze;
- preserves its existing Bootstrap/TOC synchronization assertion;
- audits every `tools/check_*.py` for historical-runtime freeze patterns before
  running the normal checker suite;
- reconstructs the complete P0088 final tree from the verified P0087 baseline;
- validates the temporary tree completely before tracked-file mutation.

## Classification

**STATIC CONTRACT-CHECKER MAINTENANCE FAILURE.**

No WoW runtime result was produced by this failure.
