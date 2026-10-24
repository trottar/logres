# P0331 — gameplay layers and keybind/health ordering

- Source baseline: verified P0330 main `1f48bbef79af2611f93063e253ca062a2a69fe18`.
- Scope: change only Logres-owned gameplay frame strata and HUD/feedback levels; migrate historical `check_action_feedback_contract.py` expectation; add `check_p0331_gameplay_layers_contract.py`; preserve native fallback and approved living/dead health logic.
- Gameplay surfaces: HUD, ActionButton clusters, ActionButton UIParent feedback/keybinds, Compass, Active Quest, XP, objective progress, StatusAuras, PlayerHelpfulAuras, native debuff container. Native-access dock and menu windows intentionally not changed.
- Version `0.0.225-dev`, 94 addon-loaded Lua entries, existing preference schema.
- Safety: no Blizzard owner/secure attributes, native transaction/action execution, secret-value processing, polling, camera or D-048 domain migration.
- Test plan: strict HEAD/branch/clean tracked state and per-file blob verification; prepared-candidate hygiene and 202 checker shadow suite before writing; 202 checker postwrite suite; git diff --check; manifest and transactional rollback. Complete WSL and WoW checks **UNVERIFIED** before applier execution.
- Runtime status: UNVERIFIED / ENVIRONMENTALLY DEFERRED until November 4; no WoW redeploy requested now. On access, validate WorldMapFrame + ordinary menu overlap, feedback/keybind mask ordering, low-HP view, action/pet clicks and aura tooltip without taint/Lua errors. P0330 death/ghost and P0321 gossip restoration remain runtime deferred.
- If a checker fails, stop and record it; never stage or push a failing candidate.
