## P0398 — Flight window scale and label layering (2026-11-08)

Verified P0397 main 8d9588a. The user screenshot shows the live Logres taxi panel enlarged beyond the viewport and dim sidebar text. P0398 uses UIParent scale for the supported taxi layout, verifies the effective scale, restores the original stock scale, and places labels above native backing. WoW retest pending. See docs/memory/evidence/P0398_FLIGHT_SCALE.md.

Version 0.0.282-dev. Exact clean P0397 baseline.
