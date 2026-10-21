# P0282 — Trainer landscape material and category legibility correction

Date: 2026-10-21. Verified pushed GitHub `main` `6b0501f0e33942dc52946afdef0a4f8f758b1e17` (P0281 R2).

## Observed in-game result / negative evidence

**P0281 R2 STRUCTURAL PASS / VISUAL FIDELITY FAIL.** The user supplied a client screenshot showing the unified 896x712 trainer landscape: trainer heading, left category sidebar, right seven-row catalogue, selected detail, reagent and Train. This is meaningful progress over P0280's disjoint preview, but the image shows two very dark flat rectangular fields behind the sidebar and list; category text is nearly unreadable; and the selected-skill region is an unnaturally bright brown slab. The approved design uses a continuous, warm dark-brown parchment substrate with subtle inset treatment, not flat black blocks.

The assistant's initial analysis blamed the panel transparency and recommended more opaque backing. The user explicitly rejected this: **the dark blocks are the problem**. That earlier analysis was **incorrect** and is withdrawn. Do not add a blanket opaque panel or increase black fills. This is a visual acceptance failure even though all earlier static checks and layout composition passed.

## Source-backed diagnosis

`TrainerLandscape.Render` creates two full-height child frames (`body`, `main`) with `p.pane = {0.055,0.038,0.022,0.83}`. These nearly black rectangles appear on top of the shared nine-slice panel; child-frame layering can also obscure lighter category labels rendered on their parent. The selected-detail frame is painted with the P0280 native trial's `selectionFill` (`{0.35,0.24,0.11,0.84}`), producing the bright solid rectangle. These are source findings consistent with the screenshot; exact client layering mechanics have not been instrumented, so the text-occlusion mechanism is a hypothesis pending the new visual test.

## P0282 narrow repair

P0282 keeps the accepted landscape geometry and content. The preview replaces the near-black full-size child panels with very low-alpha warm washes rendered directly on the *panel owner*, retaining the underlying Logres quest parchment asset and avoiding child-over-parent occlusion. It adds an understated sidebar divider. The existing `NPCTrainerComponents.Render` accepts explicit `styles` only when `model.fixture == true`; only the P0282 synthetic landscape supplies these lighter recipes. The live H call remains `{elements={}}` with its original styles, and no native style/geometry/texture/transaction changes. Reagent count is drawn on its icon owner to preserve legibility. Fixture actions remain inert.

No changes to `NativeTrainerSkin`, `TrainerMotif`, `PanelSurface`, Quest, Camera, native frame position, class-trainer transactions or stock fallback. Existing P0281 R0 malformed SHA and R1 checker mismatch failures remain in their P0281 evidence; this patch does not claim those tests passed or erase their history.

## Gate / deferrals

**P0282 PREPARED / WSL AND WOW UNVERIFIED.** The guarded applier must verify pushed baseline blobs, construct an exact shadow candidate and run every `tools/check_*.py` in PREWRITE and POSTWRITE, preserving transactional rollback and whitespace checks. Client visual acceptance requires **P → Trainer Skin Art Preview** screenshot showing readable categories, consistent warm parchment, no large black rectangles, subdued detail background and visible reagent quantity. `/reload`, toggling preview OFF and error-free UI are in scope. H/native trainer reflow, dynamic recycled rows, commerce actions, and source fidelity remain deferred until separate runtime evidence and D-046/D-047 capability gates. No forced NPC travel is required for this P-only work.
