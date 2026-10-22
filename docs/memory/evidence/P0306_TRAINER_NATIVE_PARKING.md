# P0306 — guarded native trainer whole-frame parking

Date: 2026-10-22. Verified main P0305 `c6ee09168a92c63f285b843838c2d92a929934bf` (`0.0.206-dev`). **PREPARED / complete WSL static and WoW runtime UNVERIFIED** until user applies/tests.

## Observed runtime status

User supplied a WoW screenshot showing Logres trainer automatically appears with source-backed spell rows and lower details; native Blizzard trainer remains visible on the left. User: "Everything works as expected. I tried filter, search, etc. Both ui (blizz/logres) are there". Thus **P0305 automatic entry + catalogue/user-verified interaction PASS**, but duplicate Blizzard display still OPEN. Earlier P0304 auto first-entry FAIL and its P0305 event repair remain historically recorded. P0301 full Train All and P0302 hover were previously user-confirmed PASS, **while Blizzard remained on-screen**. Do not extend this to purchases when parked.

## Narrow source finding and safety rationale

Existing `NativeServicePlacementTrial.lua` (P0271+) has already demonstrated the architecture for bounded native `GetNumPoints`/`GetPoint` capture, opaque GetPoint restoration tokens, and off-combat `ClearAllPoints`/`SetPoint` on ordinary nonprotected native roots. This source finding is **not runtime proof** that moving the Forever ClassTrainerFrame fully offscreen keeps source APIs and purchase guards working. Current `TrainerPurchaseTrial.lua` explicitly requires `ClassTrainerFrame:IsShown()==true`. Hiding the root or using `SetAlpha(0)` would respectively revoke the current purchase gate or potentially leave invisible click regions. Instead P0306 moves the **entire** nonprotected root outside the screen while leaving it shown; this must be tested in WoW.

## Implementation contract

Add `NPCServiceNativeParking` after established session `.toc` load adjacency. Only `trainer / ClassTrainerFrame / interaction type 7` authorized. Parking occurs only after Logres renderer builds, owned input attaches, owner shows and rows refresh; no speculative native suppression before Logres is usable. Safely validate native IsProtected/IsShown, combat state and competing Logres placement/skin before capturing 1–8 native anchor tuples only as opaque tokens. Hook native root OnHide once to restore. Request positioning `TOPRIGHT` against UIParent `BOTTOMLEFT` at negative offsets so native children cannot remain clickable in viewport. On any failure, restore (or defer using regen), never silently hide Logres while stock still parked. `Trial.Disable` restores stock before dropping Logres focus/interaction. Purchases and Blizzard source snapshots remain unchanged. `GetAudit` exposes addon-owned parking outcome without probing secret Blizzard visual state.

## Expected client test and limits

Deploy `/reload`. Open class trainer normally without H activation: expected Logres visible, Blizzard panel no longer visible to user, native root remains shown for source. Search/filter, scrolling, hover, and selected detail work; no purchase required. Click Goodbye: **Blizzard should reappear** and Logres should dismiss, intentionally validating rollback first; this is not yet a fully native-closing Goodbye. Close Blizzard, open a new trainer visit, repeat; H OFF restores stock and H ON parks if safe. Combat or closing native context must not strand an invisible stock click region. Any Lua, secret/taint/protected frame errors are FAIL; environmental deferrals remain DEFERRED. If Blizzard unexpectedly reanchors on TRAINER_UPDATE, mark OPEN, do not add polling or broad re-hide hooks. Native transactions while parked remain UNVERIFIED until naturally tested.

## Next gate

After runtime park/restore proof, independently validate purchase eligibility with parked native root and refine Goodbye to close the native interaction rather than merely revealing stock. Do not declare trainer final or universal NPC replacement from this first presentation gate. Accepted trainer art remains unchanged. Future source-specific services: gossip -> merchants -> flight masters.
