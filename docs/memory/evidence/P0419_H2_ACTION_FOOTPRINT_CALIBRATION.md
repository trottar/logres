# P0419 — H.2 action footprint calibration (2026-11-09)

Pinned baseline: P0418 GitHub main `e4fcc318c859cad7e6e31ec6a282eef71ed667f5`.

User's P0418 Forever `0.0.295-dev` overlay screenshot: blue approved envelopes and gold measured Logres frames are closely aligned in **position**, but some differ materially in **size**. User confirms Blizzard PetFrame/PetActionBar still absent and Logres pet buttons functional. Treat as scoped PASS for the user-observed pet regression, not comprehensive secure driver/combat verification.

## Narrow cause

`Layout.lua` retained H.2 design-envelope widths and heights for action bar overlays even after P0416 rebuilt the secure action clusters as exact 3x4, 2x6, and 6x2 button grids. The authoring editor's `w`/`h` values are visual boxes and screen-pixel references, not proof of a matching logical UIParent frame size. P0418 only moved their centers. Overlay outlines therefore showed misleading width/height differences and made correct secure anchors look misaligned.

## Correction

P0419 changes only developer H.2 planning geometry: for the five approved action clusters, derive exact width/height from the existing action role/grid/theme constants (the same 42/5 fallback values as `ActionButton.CreateCluster`), place the blue rectangle around the **approved center**, and keep gold as measured addon-owned frame geometry. Apply the same method to the fixed 5x2 Logres pet action cluster. Other 13 approved design envelopes remain unchanged because their dynamic dimensions do not imply an error in anchor placement. The H.2 map audit and full-screen overlay use the same derived plan.

## Scope and validation

- No action role/source/slot/grid assignment, scale, keybind, alpha, placement, or protected frame ownership change.
- No pet suppression/stock fallback change.
- No native/secret Blizzard state inspection, timers, polling or combat mutations.
- The prior approved V5 authored map is retained verbatim, including its planning extents; P0419 is a diagnostic representation correction, not a layout reapproval.
- WoW Forever visual overlay acceptance is **UNVERIFIED** until the user observes blue/gold action rectangle alignment after deploy. User need not repeat pet driver diagnostics if it remains stable.
