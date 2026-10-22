# Current Handoff — P0298 trainer icon layers

Authority: `docs/memory/CURRENT.md`, `docs/memory/evidence/P0298_TRAINER_ICON_DRAW_LAYERS.md`, D-046/D-047.

Verified GitHub main P0297 `aea974a` pushed; user screenshot from `0.0.198-dev` confirms **RUNTIME FAIL**: previously partly visible native trainer spell icons become nearly black, including list and selected detail; stock Blizzard icons remain visible. P0296 previously showed intermittent yellow/gold icon blocks and one user-confirmed single-skill purchase; local selection/filter/wheel still work. P0297's dark backplate is not a proven icon source fix, and its source creates image and fills on the same ARTWORK layer without explicit ordering.

P0298 PREPARED, WSL and WoW UNVERIFIED: only live icon helper assigns BACKGROUND sublayer to dark backing, OVERLAY sublayer 1 to source spell art, and OVERLAY sublayer 2 to one-pixel border textures. Fixture branch and reagents are unchanged. No changes to source ID gates, native training, frame ownership, screen position, scrolling or transaction controller.

Next: user applies P0298 guarded ZIP against exact clean P0297 baseline and reports full PREWRITE/POSTWRITE and whitespace checks; commits/pushes; assistant verifies main. Deploy and `/reload`; at trainer H → Live Trainer ON (TEST); inspect list and detail art against native stock for several entries, filter and click locally, wheel/slider and OFF. No purchase required. If still dark, DO NOT repeat a cosmetic recoloring guess: preserve FAIL and collect targeted read-only source/icon evidence. Slider drag and `Visible services` remain OPEN.
