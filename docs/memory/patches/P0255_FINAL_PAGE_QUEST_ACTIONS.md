# P0255 — Final-page rewards and in-panel quest offer actions

Verified source baseline: GitHub `main` `2a7bc5da483a5b55486fc8223dd170eec97f7cf5` (P0254).

P0254 visual placement was accepted by the user. P0255 makes a narrow presentation-only runtime adjustment: rewards and Complete Quest shown only on the last narrative page, and existing Accept/Decline buttons placed within the expanded quest-offer panel. Native claim and stock suppression semantics are not modified; the reported brief Blizzard window flash is explicitly OPEN, not marked fixed. Complete Quest on reserved quest 237 must not be clicked.

The transactional applier enforces exact baseline and clean tracked sources, validates unique transforms and hygiene, executes every `tools/check_*.py` script in a shadow checkout before writes and again postwrite, runs `git diff --check`, and writes `P0255_MANIFEST.txt`. It never commits or pushes.

Runtime status: **UNVERIFIED**, pending WoW page 1/page 2, offer action, restoration checks. Source-side acceptance of the earlier P0254 placement is visual only.
