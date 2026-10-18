# P0253 — Share original Accept control for quest completion

Baseline: pushed `main` `34274dc0c2f35dbb8aaec360b505fadac8e8ddfd`.
Implementation: single physical action root and Accept button, label/center
switch only after P0251 guarded completion suppression, restore original
Accept/Decline presentation for offers. No additional visual assets, claim
logic, native frame mutation, polling or secret inspections.

Evidence: `docs/memory/evidence/P0253_ACCEPT_CONTROL_REUSE.md`.
The P0252 screenshot is a visual FAIL, not a static or reward-read failure.

One-time applier verifies exact baseline and tracked cleanliness, prepares all
source and memory changes, runs entire `tools/check_*.py` suite in a shadow
checkout, then applies and rechecks transactionally with rollback on failure.
In-game acceptance UNVERIFIED; retain reserved quest 237 and no claim clicks.

## P0253 R0 — exact checker-anchor prewrite refusal; R1 repair

User verified SHA-256 `eecf4321edcd761d367d2f2708ddab59d11b39709c16b3c5d50c025a6e9fbc4d` and ran the original P0253 applier against verified, clean P0252 main (`34274dc`). The applier passed exact baseline validation, but REFUSED **before any tracked write** while transforming `tools/check_p0251_completion_control_contract.py`: `anchor count 0; expected 1` for the old checker token containing `"complete", "Complete Quest"`. The applier required whitespace not present around the checker literals (including before the quoted token and after the comma). A second transform for the prior completion frame-level check also required non-existent trailing whitespace and would have refused next. `git status --short` showed only three pre-existing, unrelated untracked preview PNGs; there was no P0253 manifest. This is a patch-authoring failure, not an in-client runtime error or proof of visual behavior.

**R1 repair:** Correct both old checker anchor strings to match the pushed P0252 checker. No Lua code, quest claim routing, visual design, or protected/native restoration logic changes from P0253 R0. R1 keeps the full transactional shadow static-checker suite, followed by `git diff --check`, before presenting a durable checkpoint. WoW visual comparison and final claim execution remain UNVERIFIED; preserve quest 237.
