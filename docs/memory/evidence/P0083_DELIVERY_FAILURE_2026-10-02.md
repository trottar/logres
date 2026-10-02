# P0083 Delivery Failure — Version-Frozen Static Checker — 2026-10-02

Status: RESOLVED BY P0083 REPAIR
Date: 2026-10-02

## Failure

The first P0083 apply reached the existing F.3 XP contract checker after
successfully applying the P0083 runtime/version changes.

Observed failure:

```text
Logres F.3 contextual XP pulse contract
=======================================
ERROR: F.3 runtime must identify as 0.0.31-dev
ERROR: F.3 TOC must identify as 0.0.31-dev

FAILED: 2 error(s)
P0083: command failed (1): python3 tools/check_xp_pulse_contract.py
```

## Cause

`tools/check_xp_pulse_contract.py` encoded the historical F.3 introduction
version (`0.0.31-dev`) as a permanent repository requirement.

P0083 intentionally advances the production runtime to `0.0.32-dev`.

The XP feature contract remains valid at later synchronized runtime versions, so
the checker was testing historical metadata rather than the XP feature
contract.

The newly introduced F.4 dialogue checker used the same version-freezing
pattern and would have caused the same failure at the next runtime bump.

## Classification

**STATIC CHECKER DELIVERY FAILURE — FALSE RUNTIME DEFECT.**

This does not invalidate:
- F.3 contextual XP;
- the F.3 visual PASS;
- the P0083 F.4 implementation;
- the intentional `0.0.32-dev` runtime bump.

## Repair

Both feature checkers now require:
- Bootstrap version can be read;
- TOC version can be read;
- Bootstrap and TOC versions match.

They no longer freeze the repository to the feature's introduction version.

The repair then reruns the complete P0083 checker set before creating the final
manifest.

## Runtime

No additional runtime behavior is introduced by the repair.

P0083 runtime target remains:
`0.0.32-dev`.
