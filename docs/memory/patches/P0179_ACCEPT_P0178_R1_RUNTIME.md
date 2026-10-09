# P0179 — accept P0178 R1 ownership-audit runtime result

Date: 2026-10-09. Type: **docs-only memory/evidence acceptance**. Baseline: verified GitHub `main` `fd0dc882f2a3bf81faab3bb23e5e47923145b438`. Runtime under review: `0.0.95-dev` / loadCount 229. No Lua, TOC, checker, or addon version changes.

## Goal

Replace pre-push candidate descriptions with exact post-push verification and the observed runtime result. Adopt the 35-surface expandable Blizzard ↔ Logres ownership registry and Phase 0 UI Ownership Check as a permanent check required for future UI ownership changes; retain specialized diagnostics and Run All. Preserve STOCK as deliberate policy without claiming native visibility, and preserve all environmental deferrals.

## Evidence and boundaries

Canonical observation: `docs/memory/evidence/P0179_ACCEPT_P0178_R1_RUNTIME_2026-10-09.md`. GitHub verified `fd0dc88`. Uploaded `LOGRES_DIAGNOSTICS_LATEST.lua` with P0178 R1 build `0.0.95-dev`, loadCount 229, `/logres status` and `uiownershipcheck` executing, ON 17 PASS/18 STOCK, OFF 16 PASS/19 STOCK, both with 0 FAIL and 0 DEFERRED, Run All completed in each condition, later ON pass, lifecycle/preference PASS. No detected Lua command error in these recorded runs. The first P0178 build `0.0.94-dev` failed at startup (`Commands.lua` over 60 upvalues), and R1 corrected namespace dispatch; this historical failure remains documented in P0178 R1 records.

## Scope and implementation

Documentation: rewrite `CURRENT.md` / `CURRENT_HANDOFF.md`; append concise active-milestone notes to `STATUS.md`, Phase H, ACTIVE, dated history and `docs/ROADMAP.md`; append a verified acceptance section to P0178 R1's existing patch/evidence without overwriting their earlier failure; add this P0179 patch/evidence and source-locked manifest. No source mutations. The one-time applier enforces expected main HEAD and Git blob hashes, prewrite shadow full `tools/check_*.py` suite, diff hygiene and transactional writes; no Git commits/pushes.

## Follow-up

Once P0179 is committed and verified, continue targeted naturally populated harmful-aura source investigation; do not claim a missing debuff is a renderer fault without source evidence. Loot-linked quest tracker flash remains OPEN/INTERMITTENT/UNREPRODUCED. Main/special actions, pet, party, minimap, full quest, stock aura completeness remain deliberately retained, capability-gated. No need to redeploy WoW for this documentation checkpoint.
