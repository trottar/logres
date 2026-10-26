# P0346 — architecture health baseline and regression gap audit

**Source baseline:** verified pushed GitHub `main` P0345 `626b22038d09e738bd3fa90684e3a95e36905d45`, manifest reports 216/216 PREWRITE shadow and POSTWRITE STATIC. Source version `0.0.236-dev`. **WoW runtime remains UNVERIFIED**, and the contingent November 4 safety gate starts with P0321 native GossipFrame restoration.

## Inventory observed from the exact pushed source

- There are exactly **94 Lua files under Logres, all 94 loaded by `Logres/Logres.toc`**; no orphaned Lua files or absent TOC source was found in the repository tree. This does not assert every module enables or renders successfully in-game.
- `Logres/Core/Commands.lua` contains approximately **241,585 UTF-8 bytes / 6,581 lines**, and the source includes **120 registered developer-panel actions across 0/A-H/P**, including **38 P previews**. Previous P0343 R0 failed 8 historical static contracts when a 39th P preview was added; no tracked write occurred. Do not add a new P action casually.
- `Logres/Quest/Dialogue.lua` (~75 KB), `Logres/Camera/WorldCombat.lua` (~62 KB), `Logres/Navigation/Compass.lua` (~58 KB) and `Logres/Navigation/NavigationSourceProbe.lua` (~58 KB) are additional large, specialized source units. Their size is not a measured runtime-performance fault.
- Existing P0323 classifies the loaded module inventory; P0324 already tests the **32** possible D-048 domain selections using an inert Python policy fixture. Runtime five-selector preferences and safe domain-local stock/Logres lifecycle are **not implemented**. That gap should not be confused with untested five-domain code.
- L-022, L-027 and L-028 remain OPEN/UNVERIFIED. L-019 licensing remains BLOCKED; no public release is approved. Native UI/secure/secret boundaries and Blizzard fallback stay unchanged.

## Narrow improvement

Add `tools/architecture_health_audit.py`, a **read-only, deterministic** source inventory with human and JSON output. It detects missing/duplicate/orphaned TOC Lua files, Bootstrap/TOC version mismatch, duplicate developer-panel IDs, missing P-tab registrations, loss of existing panel actions and lists constant `GetModule` names not observed among registered module names for further inspection. It reports (not fails on) large source files, cross-domain dispatcher coupling and absent live D-048 domain preference keys. Unknown module references and size are review warnings, **not** an excuse for a speculative runtime rewrite.

P0346 adds static checker #217 with negative fixtures for missing/orphan Lua and action/version drift. The checker verifies that all previous 216 contracts remain invocable as the normal guarded full suite, and that CURRENT/HANDOFF and roadmap records retain the known failures and gates.

## Non-goals and limitations

No addon Lua/TOC/Bootstrap, commands, camera, native frame, addon preference, SavedVariable, developer-panel action or quest/aura functionality changes. This is not a runtime performance optimization, WoW visual fix or proof of safe code extraction. Do **not** split `Commands.lua` until dependency/historical-checker migration is reviewed and tested as a separate scoped change. Do not manufacture client proof, inspect secret Blizzard values or remove stock controls.

**Validation:** exact clean pushed P0345 SHA and listed blob guards; candidate PREWRITE shadow and POSTWRITE suite each require **217/217 STATIC PASS**, pre-write whitespace hygiene, rollback, manifest and user-owned push. No WoW deployment for this docs/tools checkpoint.
