# P0257 — shared preview/live reward model

- Baseline: pushed P0256 `23307aa`.
- Goal: preview-first source/model/view/controller pipeline for ALL Logres UI; quest rewards provide first implementation.
- Add pure quest reward model with `Preview` fixtures and `FromLive` adapter; reuse existing card renderer and shared Accept/Complete visual with non-mutating preview routing.
- New D-046 preview-first UI contract and checker; update roadmap/memory and add source verification.
- No native quest claim, addon protected state, stock fallback suppression, or gameplay API changes. Runtime pending; multiple-choice UI still Blizzard-owned; native claim flash OPEN.

## R1 / correction
R0 shadow-check failure (P0254 duplicated completion anchor) is retained in P0257 evidence. R1 factors shared visual geometry and updates the P0254 checker contract in the same transaction; no new action or native handling.

## R2 / checker-source parity correction

R1 FAILED in shadow before any tracked write: the new P0257 checker incorrectly required single-return `local model = ...` while the actual adapter correctly captures `local model, errorReason = ...`. R2 updates both expectations and makes the applier test the checker against generated source (positive + negative) ahead of the full repository suite. Production routing and native claim behavior are unchanged.
