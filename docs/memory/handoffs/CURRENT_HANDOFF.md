# Current Handoff — P0258 Multi reward preview parity

Authority: `docs/memory/CURRENT.md`, `docs/memory/decisions/D-046_PREVIEW_FIRST_UI_PIPELINE.md`, `docs/memory/evidence/P0257_PREVIEW_LIVE_REWARD_MODEL.md`, and `docs/memory/evidence/P0258_MULTI_PREVIEW_ACTION_PARITY.md`.

GitHub `main` `94635d3` verifies P0257 pushed. User's latest Multiple reward preview screenshot shows one guaranteed item, three CHOICE cards, correct icons/amounts, but unnecessary Blizzard completion text and no in-panel Complete Quest action. The user says other previews look good, asks Multiple to match Single. P0258 changes ONLY the synthetic Multi fixture's footer and action to P0257's preview-complete; exact shared renderer, button and preview-only click gate remain. Live reward reading, native stock choice/claim, and protected/secret boundaries remain untouched. No test quest needs completion. Version `0.0.158-dev` after patch.

R0/R1 P0257 static preparation errors remain recorded; P0257 pushed, but true choice selection and actual claim remain unverified. The Blizzard-frame flash and unspecified gameplay bugs remain OPEN. D-046 requires previews for EVERY Logres element, not only quests.

Next: full transactional WSL static suite, user push and GitHub verification, WoW P — Previews Multiple/Single/Quest Dialogue inspection and inert preview-click test. Then NPC variant previews and further runtime bug triage.
