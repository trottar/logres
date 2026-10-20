# P0279 R2 — Portrait owner gate, diagnostic only

Date: 2026-10-20. Baseline: pushed P0279 R1 `e7c443043fb018167bc32206e11bb5ca3bd56703` verified on GitHub `main`.

## Scoped runtime evidence

Uploaded `LOGRES_DIAGNOSTICS_LATEST.lua` (Forever 1.60.1 / `0.0.178-dev`): with trainer closed `trainer.portrait` returns DEFERRED `native-root-unavailable`; on open native trainer `trainer.portrait` returns **DEFERRED `native-owner-unverified-or-protected`**. The new `trainer.title` and `trainer.detailIcon` candidate paths each return HIGHLIGHTED. Explicit `mapping hide` returned PASS (`highlight-off`). This does **not** verify native trainer close restoration or precise outline bounds. No Lua/taint failure is evidenced in this export, but no global error-free claim is made.

R1 fixed the invalid Frame-to-Texture parenting attempt. The remaining fallback combines several unobserved causes: GetParent unavailable / nil, native owner unordinary, IsProtected unavailable/true, IsShown unavailable/false, GetWidth/GetHeight unavailable or size outside the existing bounds. **These causes are not distinguishable from the export.** Do not call this a protection failure without proof.

## One targeted diagnostic

The M tab's **Trainer: Portrait** selection already calls the on-demand MappingInspector.Highlight method and saves the returned reason. R2 preserves the exact `eligible(owner)` gate and changes **only refusal reporting**: if GetParent returns no ordinary owner, or the existing owner gate fails, one strictly bounded reason-classification function samples the same guarded ordinary metadata methods and returns an explicit fixed reason code. There is no scanning of arbitrary Blizzard presentation trees, no protected/secret value formatting, no parent hierarchy traversal, no periodic polling and no native control changes. The verifier does not inspect values that failed the ordinary/secret test. The M tab still returns DEFERRED on every failed eligibility case; it never attempts to bypass the gate.

Only source-level evidence exists until runtime testing. This patch must NOT be treated as a portrait fix or a trainer reskin. No camera, transaction, search/sidebar, row recycling, title/icon semantics, or global overlap changes are included.

## Test / deferral

Static contract and guarded full 149-checker suite are to run in WSL. Runtime after deploy and `/reload`: while naturally at a trainer, select **M → Trainer: Portrait** once and export diagnostics. If it returns HIGHLIGHTED, visually inspect that it bounds the portrait and report it. If DEFERRED, the new fixed reason identifies the next narrow hypothesis. Do not rerun previously successful title/icon/list tests; no travel required to manufacture proof. Hide Highlight remains available to clear addon artwork only. Record results before any future corrective patch.
