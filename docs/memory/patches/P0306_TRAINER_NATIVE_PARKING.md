# P0306 — service-neutral native whole-root parking, trainer-only authorization

Baseline: verified GitHub P0305 `c6ee09168a92c63f285b843838c2d92a929934bf` (2026-10-22). Candidate version `0.0.207-dev`. **PREPARED / WSL and WoW runtime UNVERIFIED.** P0305 default trainer opening + search/filter user PASS; duplicate Blizzard trainer visible. Earlier P0304 auto-open FAIL preserved. No trainer purchases were retested while stock was hidden.

Add reusable `UI/NPCServiceNativeParking.lua` with strict trainer-only approval, bounded opaque native anchor tokens, whole-root offscreen positioning, pre-dismissal restoration and regen-deferred recovery. `Quest/TrainerLiveTrial.lua` invokes Park only after showing and populating the approved Logres UI; calls Restore BEFORE it hides the owned UI; includes parking audit. Keep source probe, single/bulk trainer API, synthetic P and camera unchanged; retain Blizzard fully shown and accessible to those APIs. If unsupported, fail-open visible stock instead of trying alpha-only or protected hiding. Historical `.toc` adjacencies preserved.

See `docs/memory/evidence/P0306_TRAINER_NATIVE_PARKING.md`. Next: WSL all-checker candidate/actual PASS then WoW presentation + Goodbye stock recovery proof. Do not claim full production completion until native interaction closure and while-parked transaction capability are verified.
