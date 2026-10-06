# P0155 — Initial Delivery Baseline Count Failure — 2026-10-06

Status: **DELIVERY FAILURE — PRE-WRITE REFUSAL**
Baseline: `40dec1874a587156c88319a9caed940088e25db7`

The initial P0155 applier refused with:

`camera direction-switch counter initialization: expected 2 occurrence(s), found 1`

No tracked writes had occurred. The subsequent working-tree status contained only the already-untracked `LOGRES_DIAGNOSTICS_LATEST.lua`.

Cause: the artifact assumed the module initialization and per-transition initialization used one identical indentation-specific three-line block twice. Durable `WorldCombat.lua` instead contains one 8-space module block and one 4-space per-transition block.

P0155 R1 validates and patches those two blocks independently. This is a delivery-contract failure, not runtime evidence.
