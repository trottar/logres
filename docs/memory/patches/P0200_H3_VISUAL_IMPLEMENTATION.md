# P0200 — H.3 coordinated visual implementation candidate

Date: 2026-10-11. Verified GitHub baseline `main` `7064ea881585af69f37cec621dbd1ac1eb490641` (P0199 R1). **Runtime candidate; no in-game PASS claimed.** Proposed version `0.0.109-dev`.

## Exact visual work

- **Native harmful effects:** Retain native `CustomAuraContainerTemplate`, `AddAuraGroup("LogresHarmful", "HARMFUL", ...)`, `AuraButton:SetIcon`, and client-owned restricted texture transport. Replace the generic quickslot edge with the existing authored sheet-04 production aura frame. Use 25px/3px native icon/gap family, five-icon maximum; player presents one five-wide row and target uses a bounded two-column, three-row arrangement within its v4 target-debuff territory. The target's 53x81 nominal native root is narrower than its 6%x9% design box at reference 16:9/1920x1080; dynamic UI scaling and restricted child packing still need client validation. No extra icon reads, duration/stack inventions, or aura suppression. This **does not modify** the four-icon authored PlayerHelpfulAuras artwork (36px/7px) or the ordinary-read status lanes.
- **Percentage and name typography:** Raise text/border contrast in shared Theme percentage-bar tokens while retaining all track widths, frame heights, percentage routing and health tunnel. Calibrate sparse enemy name and ally/pet names to brighter parchment hues and stronger shadow without adding exact enemy level, classification, player health, group data or moving labels.
- **Interaction hierarchy:** Keep action button geometry, icon/secure hitboxes, flash, bindings, native special and PET/BUFFS/TARGET access unchanged. Increase only the hotkey plate border/text separation; give the existing six-button native dock a muted bronze bottom rule, quiet label differentiation and a passive hover tint. STOCK remains obvious. Native button positions, sizes and OnClick bodies do not change.

Every v4 rectangle, semantic bind/anchor, player-helpful art, target helpful lane, secure pet control, native fallback, restoration and combat behavior remains unchanged. No new assets. Existing `Logres/Media/Aura/aura_frame_passive.tga` is deliberately reused for the harmful family, with semantic tint rather than a source-driven aura query.

## Evidence/validation gate

1. Deploy; reload in ordinary world state and inspect **one uncropped 16:9 screenshot** at normal UI scale. In Phase H developer panel use **H.2 Map overlays OFF/ON**, **Layout Check**, **Status Aura Preview ON/OFF**, **Status Aura Check**, and **Native Access Check**. In Phase 0 run **Run All** and **UI Ownership Check**.
2. When naturally available, capture 2-5 simultaneous harmful effects on player and enemy separately (do not force travel or contrived gameplay). Confirm native icon frame is not clipped/occluded, target grid is actually 2-column, textures/duration/cooldown continue native rendering, cursor tooltips remain usable, and target buff+debuff lanes remain separated. Missing natural populations are **DEFERRED**, not PASS.
3. Check player resource/target/pet/party percent readability over a bright and dark backdrop; primary 12 / secondary 12 / utility 12 and pet density; native dock legibility and STOCK/MAP/QUESTS/XP/MENU/CAST click response; PET/BUFFS/TARGET fallback; Immersion OFF and ON restoration; no duplicate stock shell/click region.
4. Any Lua, taint, protected-action, secret-value, initialization, texture-loading or native-aura regression is **FAIL**. Save diagnostics/screenshots, preserve negative results in memory and prepare a corrective patch before advancement. The P0197 PetActionBar reappearance and ObjectiveTracker flash remain **OPEN / INTERMITTENT / UNREPRODUCED**; do not add polling.

## Static vs runtime claims

The guarded applier validates pinned Git blobs, unique anchors, the exact prepared shadow checkout, Python contract suite, Lua syntax where `luac` is available, and `git diff --check`, then writes atomically/transactionally to its owned files. That is **source/delivery validation**, not Warcraft behavior. The original P0196 R1 visual/hook and R2/R3 delivery failures are retained, as is P0199 R0 truncated-pin delivery failure.

## P0200 R0 shadow-checker delivery failure; R1 correction (2026-10-11)

**R0 delivery FAIL — no tracked writes.** User ran the original guarded applier on the verified `7064ea88` checkout. The full-shadow validation halted at `check_h2_unified_placement_contract.py`, which still asserted `local WIDTH, ICON, GAP, MAX = 98, 18, 2, 5` from the earlier H.2 layout checkpoint. That static assertion contradicted this deliberately coordinated H.3 harmful-aura resizing, although the actual H.2 location/semantic ownership policy is unchanged. The applier printed `P0200 APPLY FAIL: SHADOW CHECK FAILED ...` and exited before writes. The user's `git status --short` displayed untracked local files only, not tracked modifications. **No WoW runtime or visual test occurred.**

**R1 correction:** Update the P0195 H.2 static checker to require both the unchanged player/target harmful binding and the new bounded two-column target / five-column player grid setup. Keep all other approved-v4 anchor, action geometry, target layout, no-polling and restoration assertions. Pin the old checker blob with the exact verified Git SHA before changing it. The complete `check_*.py` suite runs on the assembled R1 shadow tree before any tracked writes. This is a *prewrite checker compatibility fix*, not evidence of successful WoW presentation. Preserve the R0 negative result permanently.
