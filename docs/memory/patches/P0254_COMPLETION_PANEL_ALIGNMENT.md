# P0254 — Place the shared Complete Quest action within the narrative panel

Baseline: `main` `3c0a01762b669aca9140a92201890dd318057607` (P0253). This repair is an action-anchor and completion-pagination layout change only: move shared action inside the panel after guarded activation, restore original anchor on offers, and keep page controls out of the action area. Preserve native stock fallback, claim routing, event lifecycle, and quest 237. Static checker verifies the old below-panel and corrected inside-panel geometry without asserting runtime acceptance. Full checker suite runs transactionally in the user's repository before tracked writes; WoW runtime/visual acceptance UNVERIFIED. Evidence: `docs/memory/evidence/P0254_COMPLETION_PANEL_ALIGNMENT.md`.

## P0254 visual runtime acceptance (2026-10-18)

Verified GitHub main `2a7bc5d`, user-provided `0.0.154-dev` screenshot and explicit “Much better!”: the exact Complete Quest/Accept instance is now visibly **inside** the dark narrative panel. **VISUAL PASS (placement only)**. This does not validate claim execution or final-page disclosure. P0255 addresses newly reported early rewards/action and in-panel offer-button parity; the sub-second native-frame flash remains **OPEN** with no handler changes. Preserve earlier P0252/P0253 visual failures and quest 237 for testing.
