# P0298 — Live trainer icon layer isolation and P0297 regression

Date: 2026-10-22. Source baseline: verified GitHub main P0297 `aea974a71b1cbd59686983ad64e8d00daa0a1de3` (`0.0.198-dev`). **P0298 PREPARED / WSL AND WOW UNVERIFIED.**

## Observed negative result

User P0297 screenshot and statement: "All icons completely gone now". In live Logres trainer both list and detail icons are dark/near invisible while names, rank, descriptions, costs, source-backed requirements and Blizzard's stock spell icons remain visible. This is **P0297 RUNTIME ICON VISUAL FAIL**. It follows P0296's *different* icon fault: two tan/gold icon squares, but other images showed normally. P0296's single-skill purchase was user-confirmed (Blizzard UI/funds corroborated). No new purchase test is required and no new gameplay ownership is authorized.

## Narrow source finding and patch hypothesis

The P0297 `icon(owner,...,live)` helper creates dark backplate, numerical source-image texture and four gold border textures on the **same ARTWORK draw layer**. It never explicitly separates the icon from subsequently created rectangles. This ordering is source-visible; whether it is the only reason the client shows near-black icons is UNPROVEN. P0298 makes live texture compositing deterministic: BACKGROUND (-1) for the dark fill, OVERLAY (1) for source art, OVERLAY (2) for narrow one-pixel edges. The existing `img:SetTexture(path)` and retained references for `SetTexture(datum.icon)` and `SetTexture(view.selected.icon)` remain unchanged. The synthetic P preview's prior `ARTWORK` painter and icons for reagents are not modified.

## Safety and validation

P0298 changes only `TrainerLandscape.lua` artwork layering and synchronized version/memory/checker files. `NativeTrainerServiceProbe.lua`, `TrainerLiveTrial.lua`, `TrainerPurchaseTrial.lua`, native data IDs and any Blizzard frame remain byte-identical. No timer, polling, protected-state mutation, native filter/selection setter, purchase or hook. The guarded ZIP enforces exact commit plus blob hashes and clean tracked state; validated exact source anchors; full checker suites prewrite/postwrite with version-policy and memory checker; candidate whitespace gate; `git diff --check`; manifest and transactional rollback.

At normal trainer, after deploy and `/reload`, use `/logres panel` → H — Integration and Polish → Live Trainer ON (TEST). Check icons for several available/unavailable spells and selected detail against the unchanged Blizzard window. Change local filter, scroll and select; ensure normal details, stock usability and OFF/close recovery. No purchases. **PASS** requires visible artwork. If icons remain dark, document **FAIL**, keep the evidence and investigate actual bounded native icon source/rendering separately rather than another unproven color adjustment.

Outstanding: P0296's intermittent gold-box root cause still OPEN, slider drag/track UI still unverified, `Visible services` placeholder still inert; native Train All and general replacement not authorized.
