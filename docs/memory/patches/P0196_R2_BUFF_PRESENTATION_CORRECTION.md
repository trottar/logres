# P0196 R2 — restore authored Logres buff presentation

Baseline: verified GitHub `main` P0195 `9097f43`; expected local worktree: exact **unpushed P0196 R1**.
Runtime candidate: `0.0.106-dev`. This patch supersedes R1, not yet accepted or pushed.

## User-observed regression and cause

The user provided a screenshot showing two **tiny 18px generic aura icons** above the lower-right utility controls, replacing the previously accepted crafted Logres buff icons. R1 deliberately called `PlayerHelpfulAuras:SetNativeOverride(active)`, hiding the existing `HELPFUL|PLAYER` four-slot, 36px illustrated Logres renderer. The newly created `CustomAuraContainerTemplate` native player helpful group was active instead. This was an unauthorized visual redesign and a real **FAIL**, even though an isolated aura checker could report PASS.

The user's uploaded `LOGRES_DIAGNOSTICS_LATEST.lua` at loadCount 248 / `0.0.105-dev` confirms `helpfulauracheck ... reason=native-replacement ... root=false ... slots=4 visible=0 shown=false`, and also `native-surfaces: FAIL ... error=onshow-hook-unavailable:targetAuras`. Stock `PetFrame`, `PetActionBar`, and `BuffFrame` were folded; the contextual target Auras remained stock because its `HookScript("OnShow")` path was unavailable. **R1 is runtime FAIL and must not be pushed.**

## Corrective R2 scope

- Restore `PlayerHelpfulAuras.lua` to the **exact P0195 implementation**: retain original Logres textures, presentation geometry, four-slot source filter, tooltip/read safety, event behavior, preview and static contracts. No native 18px player buff substitution.
- Restore `StatusAuras.lua`, `NativeDebuffs.lua` and the P0195 placement checker to their previous code so neither target aura styling nor harmful icon footprint is altered by an unproven takeover.
- Keep the in-progress secure pet row targeting and auto-armed Logres pet action cluster from R1, along with source-gated folds and restoration.
- Only fold the stock `BuffFrame` if the existing authored `PlayerHelpfulAuras` module/root/slots are available **and** BUFFS stock-access control exists. The existing four icon slots do **not** prove full helpful aura coverage. BUFFS must reliably restore the full stock frame on demand; this remains a manual fallback, not completion of aura replacement.
- Drop native generic HELPFUL container creation/activation. Keep `TargetFrame` contextual Auras **stock and usable** until its OnShow support and complete target information can be restored with an evidence-backed method; R1's unhookable mutation is not retried.
- Move PET/BUFFS/TARGET buttons into a UIParent-owned row anchored below the original dock, rather than leaving interactive children outside the dock's small 26px rectangle. Visibility follows the addon-owned dock; actual in-game clicks remain to test.
- Damage Meter, Issue Reporter, and all H.2 v4 anchors unchanged.

## Runtime acceptance still required

R2 is **OPEN**, not PASS. After deploying out of combat, confirm the *old Logres framed player buff style* is restored in its bottom-right region, with no tiny replacement icons; verify click and tooltip behavior of PET, BUFFS, TARGET and pet controls; verify BUFFS opens stock full-aura UI, and Immersion OFF restores stock and ON re-folds only supported stock. A screenshot with player buffs and target harmful effects, native-surfaces diagnostics, Layout Check and Run All are necessary. If the original Logres buff art is not visible while an ordinary player-cast buff is active, stop. The unproven target aura suppression remains **OPEN / BLOCKED**, not silently marked complete. Protected, taint, secret and Lua errors require correction before push.
