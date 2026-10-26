# P0343 R1 — L-022 unknown-percent Active Quest preview coverage

**Authority/baseline:** verified pushed P0342 R2 `be3be5e80cf65cf1bf6d261b84b573f1f1effca2`, 213/213 static PREWRITE/POSTWRITE PASS, WoW **UNVERIFIED**. L-022 has no identified offending renderer element or matching live screenshot.

## Source-level finding

`ActiveQuest:BuildPreviewSnapshot` normal/complete fixture rows have ordinary numeric progress, while `PercentForRow` can return `nil` in live conditions and `Render` then presents the existing 122-by-1 `visual.unknown` fallback. Neither existing preview exercises this. `Progress:StableObjectiveText` supports text-only objective rows. This identifies coverage, not the user's artifact.

## P0343 R0 failure — preserved negative evidence

The user verified R0 ZIP SHA-256 and ran the guarded P0343 applier on the clean P0342 baseline. **PREWRITE REFUSED 8/214** at `check_p0256_preview_hub_contract.py`, `check_p0271_native_placement_trial_contract.py`, `check_p0272_native_auto_handoff_contract.py`, `check_p0273_native_gossip_continuity_contract.py`, `check_p0274_native_service_accent_contract.py`, `check_p0276_r1_native_trainer_skin_contract.py`, `check_p0289_trainer_live_panel_contract.py` and `check_p0310_trainer_empty_catalogue_contract.py`. All shared cause: the R0 proposal registered a new P-tab action and broke fixed historic developer-panel/gallery action counts. The checker suite correctly protected the repository. **No tracked write; no WoW PASS.** R0 package CLOSED / REFUSED. This was an assistant patch-design validation failure and should have been caught against full repository contracts prior to delivery.

## R1 narrow correction

Do not register any action, add any slash command, or add a distinct preview mode. Keep `Logres/Core/Commands.lua` byte-identical to the exact pushed P0342 blob. Instead add **one missing-progress text-only objective** to the *existing* P — Active Quest Preview normal fixture. Retain all original normal fixture rows and the separate complete and live paths. The new row goes through the same production `Refresh -> Render` path with existing `visual.unknown` art and geometry. No quest source adapter mutation, Blizzard/native UI hiding, gameplay transactions, secret inspection, camera, state migration, timers, polling or extra UI actions. Version TOC/Bootstrap parity `0.0.235-dev`, #214 static checker; no Lua load-list change.

**Client gate (contingent November 4):** After mandatory P0321 native GossipFrame restoration, compare existing P — Active Quest Preview (`/logres activequestpreview normal`), P — Active Quest Complete, and P — Active Quest Live with the actual L-022 artifact. If the 122×1 fallback matches a screenshot, investigate a narrow art correction; otherwise preserve **OPEN / UNREPRODUCED**. P0330–P0338 still require natural-context testing. L-027 popup `/fstack`, L-028 aura route, L-019 root license remain OPEN. Do not request WoW commands while client unavailable.

**Acceptance:** exact P0342 baseline & blob checks, 214/214 PREWRITE shadow and POSTWRITE static contracts, no panel-registry edits, candidate hygiene, manifest. Static checks are not client visual PASS.
