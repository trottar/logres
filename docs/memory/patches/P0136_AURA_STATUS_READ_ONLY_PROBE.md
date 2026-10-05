# P0136 — Read-Only Player/Target Aura-Status Runtime Probe

Date: 2026-10-05
Baseline: `b69eb109ab9d65477414e66864fef484c244eabc`
Runtime target: `0.0.66-dev`
Result: **RUNTIME PROBE PASS WITH ENVIRONMENTAL DEFERRALS — READY FOR SINGLE COMMIT**

## Purpose

Implement the narrow runtime proof required by P0135/D-041 without creating a
production aura/status surface or suppressing Blizzard UI.

## Runtime design

New module:
`Logres/HUD/AuraStatusProbe.lua`.

The probe:
- is event-driven only;
- watches `UNIT_AURA` for `player` and `target`;
- observes target changes and entering-world;
- discards `UNIT_AURA` payload arguments entirely;
- uses bounded indices `1..6`;
- preflights every index through
  `C_Secrets.ShouldUnitAuraIndexBeSecret`;
- never queries a secret/indeterminate index;
- secret-checks the returned aura value before nil/type inspection;
- secret-checks each selected field before inspection;
- stores only sanitized addon-owned diagnostic state;
- does not mutate/cancel auras;
- does not hide/reparent/suppress Blizzard UI;
- does not poll.

Representative source-defined filters cover:
- player helpful / harmful;
- player harmful crowd control;
- player raid-relevant harmful;
- player-origin helpful;
- target helpful / harmful;
- target player-applied harmful;
- target crowd control;
- target dispellable / important / big-defensive helpful state.

The probe intentionally does not inspect `UnitAuraUpdateInfo.addedAuras` or use
bulk aura APIs.

## Developer integration

Phase H adds:
- panel action `Aura Status Probe`;
- slash command `/logres aurastatusprobe`.

The contextual probe is intentionally excluded from `Run All`.

Static contract:
`tools/check_aura_status_probe_contract.py`.

## Runtime gate

Required in-client validation:
1. Phase H -> Aura Status Probe with ordinary player auras present;
2. repeat while targeting a unit, preferably after applying one player-origin
   harmful aura if naturally available;
3. confirm `failureCount=0`;
4. inspect emitted category/metadata lines;
5. Phase 0 -> Run All must remain PASS;
6. no Lua, secret-value, taint, or protected-action errors.

Environmental absence of target/status categories is DEFERRED, not FAIL.

Any predicate/query error or secret-value violation is a real failure and must be
recorded before correction.

No production aura/status ownership or stock suppression is authorized by P0136.

## Initial applier failure / R1

The initial P0136 applier reached the new aura/status checker after all preceding
checks passed, then failed because the checker used the first bare API-name
occurrences inside `readAuraIndex()` instead of the actual pcall sites.

The transactional applier rolled back patch-owned files.

Canonical evidence:
`../evidence/P0136_INITIAL_APPLIER_STATIC_CONTRACT_FAILURE_2026-10-05.md`.

P0136 R1 corrects only the checker landmarks. Runtime probe behavior is unchanged.

R1 classification:
**CHECKER CORRECTION ONLY — RUNTIME EVIDENCE PENDING.**

## Runtime result

Canonical evidence:
`../evidence/P0136_AURA_STATUS_RUNTIME_PASS_WITH_DEFERRALS_2026-10-05.md`.

Final tested runtime:
`0.0.66-dev`.

PASS:
- probe lifecycle/API/event integration;
- populated ordinary player `HELPFUL`;
- populated ordinary player `HELPFUL|PLAYER`;
- selected helpful metadata ordinary/non-secret;
- safe empty target scans;
- integrated `Run All`.

DEFERRED:
- populated player harmful categories;
- populated target categories;
- runtime secret-skip branch.

No runtime failure was reported.

Next production scope is restricted to player helpful status with Blizzard
completeness fallback preserved.
