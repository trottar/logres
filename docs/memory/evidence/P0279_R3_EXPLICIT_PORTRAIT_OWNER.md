# P0279 R3 — explicit portrait overlay owner mapping

Date: 2026-10-20. Required GitHub main baseline pushed P0279 R2 `90198c5c26ca38e7a642e69e0ae5575c88ad38e4`.

## New observed runtime evidence

The user uploaded `LOGRES_DIAGNOSTICS_LATEST.lua` after testing P0279 R2 (`0.0.179-dev`). At initial selection before trainer availability `trainer.portrait` returned `DEFERRED (reason=native-root-unavailable)`, an environmental pre-open result. On two subsequent selections when available it returned `DEFERRED (reason=native-owner-outside-size-gate)`. The earlier P0279 R1 export showed `trainer.frame` HIGHLIGHTED and the native feasibility audit showed `ClassTrainerFrame` present, ordinary, nonprotected and shown (338x424 at that time), while the texture itself was 62x62. Actual portrait parent's dimensions or identity were NOT captured and must not be guessed. R2's fixed reasons distinguish the size gate without inspecting protected or secret geometry content. No Lua/taint error reported in the provided M results.

## Narrow correction / risk containment

The owner is used solely as a **parent for Logres's addon-owned, mouse-inert overlay**, not as the outline's bounding box. Relaxing arbitrary large parent eligibility could attach a stale overlay to a full-screen/UIParent-like Frame that outlives the trainer. Do **not** change the existing `eligible(owner)` or size, protection, visibility, ordinary or combat gates.

Instead add optional declarative `overlayOwnerPath` to the service-element index. For `trainer.portrait` alone set it to the runtime-verified `ClassTrainerFrame`. On a real `native-owner-outside-size-gate` result only, resolve the explicit owner through the existing guarded resolver, require independent `eligible(mappedOwner)` plus a non-Texture/FontString object kind, and then parent only Logres's overlay to that Frame, anchoring the outline to the original native portrait Texture. If the mapped root is absent, protected, hidden or outside bounds, DEFER with the original size-gate reason; fail open. No native setters, UI geometry, stock behavior, transactions, hooks, polling, or global overlapping-HUD policy changed. The explicit owner association is a candidate until checked visually in WoW.

## Validation

Static schema, contract and all repository checkers run by the guarded applier (PREWRITE/POSTWRITE) are PENDING WSL. In WoW, deploy and `/reload`; with a naturally open trainer select M -> Trainer: Portrait. Expected `HIGHLIGHTED (reason=highlight-visible-mapped-owner)` when all guards pass; check that outline bounds track the portrait and disappears on trainer close and Hide Highlight. Log exact result and screenshot; **no runtime PASS is claimed here**. Known title, detail icon and other 9 successful mappings need no retest. Preserve the R2 failure and global overlap as OPEN until separate refinements.
