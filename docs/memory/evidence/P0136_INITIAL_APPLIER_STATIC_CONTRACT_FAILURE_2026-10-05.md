# P0136 Initial Applier Static-Contract Failure — 2026-10-05

Status: **CLASSIFIED — CHECKER FALSE NEGATIVE; RUNTIME DESIGN UNCHANGED**

Baseline:
`b69eb109ab9d65477414e66864fef484c244eabc`

Initial artifact:
`P0136_AURA_STATUS_READ_ONLY_PROBE.zip`

Initial artifact SHA-256:
`d674fdbc306d62ecfa20df3804415f388e08bd94b49c30a33f08421569c4e1ce`

## Observed failure

The user ran the transactional P0136 applier.

All checkers reached before the new P0136 checker passed. The new checker then
reported:

```text
Logres P0136 aura/status read-only probe contract
==============================================
ERROR: readAuraIndex must preflight and secret-check predicate before any aura payload query

FAILED: 1 error(s)
```

The applier reported:

```text
P0136: FAIL — rolled back patch-owned files
```

Post-failure tracked state was clean for patch-owned files; only untracked local
diagnostic/artifact residue remained.

## Classification

This was a **static checker defect**, not runtime-probe behavior.

The runtime source performs the intended order:

1. `pcall(C_Secrets.ShouldUnitAuraIndexBeSecret, ...)`;
2. secret-check the predicate result;
3. require ordinary `false`;
4. only then call `pcall(C_UnitAuras.GetAuraDataByIndex, ...)`;
5. secret-check the returned aura before nil/type inspection.

The initial checker used `str.find()` on the bare API names. Those names also
occur earlier in `readAuraIndex()` inside the `predicateAvailable` and
`queryAvailable` fields of the result-table initializer.

Therefore the checker accidentally recorded the earlier API-presence references
as the mutation-order landmarks. In particular, the first
`C_UnitAuras.GetAuraDataByIndex` occurrence appeared before the actual predicate
call, causing a false ordering failure.

## Correction

P0136 R1 changes only the static checker landmarks.

The checker now anchors on the actual pcall statements:

- `local predicateOK, predicateResult = pcall(`;
- `C_Secrets.ShouldUnitAuraIndexBeSecret,`;
- `local queryOK, aura = pcall(`;
- `C_UnitAuras.GetAuraDataByIndex,`;

and verifies the secret-check/branch order relative to those exact call sites.

No Lua runtime behavior, filter set, secret-handling boundary, polling policy,
Blizzard UI ownership, or runtime version changes from the initial P0136 design.

## Result

Initial attempt:
**FAILED / ROLLED BACK — STATIC CHECKER FALSE NEGATIVE.**

R1:
**CHECKER CORRECTION PREPARED; RUNTIME EVIDENCE STILL PENDING.**
