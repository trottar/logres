# P0271 — Native service centered-placement trial and flight alias investigation

Date: 2026-10-19. Baseline: remote main P0270 `b33fdf6275be93d6551d19430680d40a79fffb5f`, verified by read-only GitHub inspection. Scope remains D-047.

## Client evidence from P0270 (not new P0271 runtime proof)

- User's `0.0.168-dev` diagnostics: idle frame audit five candidates present, three absent, `nativeMutations=0`, `styling=none`, `placement=none`. Gossip, MerchantFrame, BankFrame, PetStableFrame and TabardFrame present unprotected, with GetPoint and SetPoint methods; ClassTrainerFrame appeared during trainer interaction and was unprotected. The audit is read-only and does not grant mutation permission.
- User voluntarily tested Flight Master (normalized interaction type=6), bank (type=67), and auction (type=21) in Ironforge. BankFrame and AuctionHouseFrame were observed present/unprotected with methods; FlightMapFrame remained not-loaded during flight interaction. This is **OPEN** candidate-identity evidence, not proof flight UI is unavailable. On this client older `TaxiFrame` may be a candidate; it has **not** been observed yet.
- The most recent P0270 Run All reported no FAIL lines. P0270 test evidence does not establish native frame relocation safety, stock UI reliability during relocation, or native transaction success.

## P0271 hypothesis and strict runtime boundaries

A manually requested whole-frame centering trial for **only actual open MerchantFrame (interaction type=5) and ClassTrainerFrame (type=7)** may preserve Blizzard child controls while allowing Logres-led spatial coherence. These interaction types are source-side normalized context hints, not stand-alone native identity proof. Therefore the trial also gates on named global present, guarded `IsShown()` true, `IsProtected()` false, confirmed non-combat, read/write/hook method presence and a bounded complete `GetNumPoints()` snapshot. Absent or restricted observation means no mutation. No automatic application or reassertion is implemented.

Full native anchor tuples are collected **only** for restoration after the explicit TEST action. The tuple members are opaque and never inspected, compared, stringified, counted, persisted or used to decide any branch. The ordinary anchor count itself is checked safely. Whole-frame center is only one trial candidate; visual suitability is not asserted. An exact native OnHide callback is registered only when a trial is requested and automatically restores anchors on closure; a pending restoration may retry on `PLAYER_REGEN_ENABLED`, never a timer/poll. Manual repeat of H `Native Service Center / Restore (TEST)` restores the saved anchors. On any gate failure, stock remains unmodified. No textures or child controls are hidden, detached or overwritten; Blizzard owns purchase quantities, repairs, filters, sale and training. Any Lua/protection error or failure to restore is a **real failure**, not PASS, and must be recorded and fixed before broadening the approach.

Add `TaxiFrame` as a **ninth** read-only audit candidate, alongside unaltered `FlightMapFrame`, to resolve the flight identity gap on a later naturally available flight NPC without requiring travel now. The legacy audit stays zero-mutation and does not silently treat either candidate as authorized for placement. Bank and auction remain native and unmodified; no bank/auction styling or positioning is added. Accepted Logres/DynamicCam camera modules, handlers and timing remain byte-identical.

## Validation scope and negative-evidence discipline

P0271 includes updated P0256/P0261/P0269/P0270 checker dependencies for the **105 total, 34 preview, 18 H** action registry, and a new P0271 contract. Generated candidate must pass entire 138+ checker suite prewrite and postwrite, with git diff hygiene, before handoff commit. Tests on local code cannot substitute for WoW runtime. The prospective R0 client tests are a natural merchant and trainer if available; start with no-NPC negative check, run H audit for TaxiFrame where applicable, then merchant center/restore and trainer center/restore, check native controls, close/restoration, Run All and diagnostics. Missing NPC => DEFERRED, not PASS. Any failure => OPEN and corrective patch, no automatic enablement.

## Historical negative evidence retained

P0270 R0 failed 1/137 shadow suite because adding an H action invalidated an older total-count contract. P0270 R1 fixed its three historical dependencies and later reached `b33fdf6` on main; user collected new flight/bank/auction client evidence. Do not repeat single-checker registry drift. P0268 custom mock vendor/trainer/flight catalogue path was a D-047 architecture deviation, rejected by user and retired by P0269. No custom service UI is recreated here.
