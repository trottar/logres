# P0256 — Central visual-preview gallery

Baseline: verified pushed GitHub `main` `fc74e14565d1111fb97a78d1a34cc2c759f62ee7` (P0255).

Introduce the `P — Previews` developer-panel tab; move registered visual preview action buttons to P, supply gallery controls for already-supported HUD sample ON/OFF, and paginate groups of 18 so no action silently falls below the visible viewport. Keep the existing command routing, immutable button registry IDs, other tab actions, H.2 map, real quest controls and safe Blizzard fallbacks unchanged. Adjust `check_dev_panel_contract.py` to validate a separate preview tab instead of counting it as an 18-action roadmap phase; add a dedicated P0256 gallery/checker contract. Existing preview implementations are preserved, not expanded into fake previews. Universal coverage is a project-wide OPEN requirement with explicit matrix in `docs/memory/evidence/P0256_UNIVERSAL_PREVIEW_GALLERY.md`.

Expected runtime version in TOC + Bootstrap: `0.0.156-dev`. **STATIC CHECKS IN LOCAL APPLIER; WOW RUNTIME UNVERIFIED.** The earlier gameplay bugs remain OPEN / pending specific evidence, and quest 237 must not be claimed. No commit/push by the applier.
