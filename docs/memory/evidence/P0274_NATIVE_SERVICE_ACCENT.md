# P0274 — Additive merchant/trainer native-service accent

Date: 2026-10-19. Baseline: pushed `591ed52eeb65e50386dd7bec9516b1f389e980aa`. Authority: D-047 (Blizzard retains transactions, filters, repairs, selling and travel); D-046 (preview/renderer exists but live gossip data/actions are not yet proven).

## Previously accepted runtime evidence

P0273 `0.0.171-dev` player screenshots show native GossipFrame and ClassTrainerFrame centered at the same screen position; selecting Train me works with stock native interaction. Saved diagnostics record native placement starts=3 restores=3, gossip starts=2 restores=2, autoDeferred=0, pending=false, failures=0, nativeTransactions=0 and a completed Run All with no reported FAIL. Presentation with dev panel CLOSED remains aesthetically unverified because right-side panel overlapped native frames. No gameplay transaction was executed by Logres. Original P0272 generated manifest and WSL full static gate remain unavailable; P0273 reconstructed records but did not retroactively prove them.

## Narrow P0274 hypothesis and deliberately constrained scope

A small **addon-owned**, mouse-disabled gold rule/seal can visually connect merchant/trainer Blizzard stock windows to the Logres HUD while preserving every stock control. It is attached only when the shared protected-gated P0271-73 positioning controller successfully starts an opt-in merchant/trainer placement. It is hidden before native anchor restoration, including when restore must defer in combat; errors decorating never prevent native access. Native frame textures/text, scripts, child hierarchy, input, prices, purchases, filters, repairs, selling and callback actions are not changed. P0274 **does not style GossipFrame**: use accepted native position/stock fallback until the separate guarded live gossip adapter to the existing Logres quest/NPC renderer is proven.

Appearance: one understated 105x2 gold line and 6x6 seal on a mouse-disabled UIParent child near the upper inside edge of each native merchant/trainer window. It is not a replacement transaction layout and is absent when placement is OFF. Source-owned state is separately audited (`accentShows`, `accentHides`, `accentFailures`) rather than inferring Blizzard presentation state. No timers/polling, camera edits or bank/auction/flight mutations.

## Validation and scope boundary

Static: full 141 checker suite in shadow PREWRITE and postwrite plus diff --check via guarded applier; this does not establish WoW success. In-game H `Native Auto Position (TEST)` ON, open a naturally nearby merchant/trainer, close the developer panel to inspect ornament and all stock controls; close/reopen, OFF restore and verify accent disappears. Native gossip should center as before with original Blizzard visuals; do not require transit. H `Native NPC Services Check`, 0 `Run All`, save diagnostics. **WoW acceptance is PENDING** until user screenshots and diagnostics. On cosmetic creation failure, the result must be DEFERRED while stock UI remains usable; a taint/protected-action error, invisible click region or failed native restoration is FAIL requiring correction. Do not claim an untested transaction. After scoped acceptance: investigate live ordinary gossip source/actions for D-046 adapter; keep stock fallback on ambiguity/secret/protected cases.
