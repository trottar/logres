# Current Handoff — P0282 trainer parchment visual-fidelity repair

Authority: `docs/memory/CURRENT.md`, D-046/D-047 and `docs/memory/evidence/P0282_TRAINER_PARCHMENT_VISUAL_FAILURE.md`.

Remote `main` verified at P0281 R2 `6b0501f`. New WoW screenshot provides **STRUCTURAL PASS / VISUAL FIDELITY FAIL**: P preview now has correct landscape sections, but two near-black rectangular fields appear over the parchment; category labels are difficult to read; selected detail is a solid bright-brown slab. The user corrected a faulty assistant opacity diagnosis: these dark blocks are the problem, NOT missing overall opacity. Preserve the earlier P0280 visual failure, P0281 R0/R1 PREWRITE failures and successful P0281 runtime composition evidence.

P0282 PREPARED refines only P presentation. Preserve the 896x712 geometry, theme panel asset, menu/list contents, inert fixtures, no native APIs. Render warm low-alpha washes directly on root instead of full-size black child frame surfaces that could obscure parent fontstrings. Fixture-only control recipes keep shared component painter but do not change H native styling. Place reagent count on icon overlay. No Quest/Camera/H behavior changes.

Next: guarded full static suite PREWRITE/POSTWRITE in WSL, manifest and diff checks. User stages/pushes then remote verify. Deploy, `/reload`, developer panel P — Previews → Trainer Skin Art Preview. Compare sidebar contrast, list material, detail surface and reagent label with accepted image; toggle OFF. Screen evidence decides acceptance. Native Blizzard trainer landscape reflow remains DEFERRED pending a separate capability-gated safe fallback investigation.
