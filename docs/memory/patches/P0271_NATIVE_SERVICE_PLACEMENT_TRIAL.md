# P0271 — Native service placement trial and flight frame alias

**Date:** 2026-10-19. **Base:** verified pushed main `b33fdf6` (P0270). **Status:** PREPARED; user WSL static suite and WoW runtime unverified.

- Adds `Quest/NativeServicePlacementTrial.lua` as a **manual and reversible** whole-frame placement trial, MerchantFrame/ClassTrainerFrame only; one H action toggles Center (TEST) / Restore. Never starts on load and never hides native input. Full anchors captured as opaque restoration tokens; native OnHide automatic restoration and event-only deferred combat repair; refusal on unknown/protected/secret/unsupported state.
- Extends P0270's metadata-only frame audit to include `TaxiFrame` **candidate**, not a proven flight identity; retains `FlightMapFrame` and all other candidates.
- Leaves Blizzard merchant/trainer/flight/repair/selling, bank, auction controls and transactions untouched; never replaces NPC service implementation. Camera/DynamicCam, normal quests, quest 237, and stock recovery unchanged.
- Adds checker `tools/check_p0271_native_placement_trial_contract.py`, and synchronizes historical P0256/P0261/P0269/P0270 contracts to 105 total H+P actions, 34 P actions, 18 H actions. Full static checker suite runs in guarded prewrite shadow and after writes.
- Source and client evidence including P0270 supplementary Ironforge flight=6, bank=67, auction=21 results in `docs/memory/evidence/P0271_NATIVE_SERVICE_PLACEMENT_TRIAL.md`. P0270 0.0.168 diagnostics were read-only; **no P0271 runtime outcome is claimed**.

Acceptance requires a real WoW merchant center, restoration (manual and on hide), normal native controls, no Lua/secret/protected errors, and a trainer case only if naturally available. Do not broaden native frame mutations until this evidence is recorded.
