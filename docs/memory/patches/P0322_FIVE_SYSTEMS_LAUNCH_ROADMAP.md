# P0322 — Five-domain product contract and alpha-to-1.0 roadmap

**Baseline:** pushed P0321 `9a180c878279d24e60cd819428fe6dad3a599fc8` on `main`. **Scope: docs and a static policy checker only; no Lua, TOC, assets, saved-variable schema, native UI or camera mutation.** The actual in-game P0321 single-window gossip remains UNVERIFIED / DEFERRED until Forever access.

## Accepted product decisions

D-048 records five independent player-selectable domains (NAV, ACT, NPC, STATUS, CAM) with Logres/Blizzard choices and internal capability-based native fallback. A global Immersion toggle may become an optional preset but cannot remain an implicit prerequisite. This does not claim today's `Preferences.lua` or `Settings/Panel.lua` implement five switches. Existing per-domain migration, effective-state, native restoration, 32-configuration policy fixture and runtime proof are future implementation work.

## Launch / issue planning

`docs/memory/roadmap/LAUNCH_READINESS.md` records pre–November 4 stabilization, repository-wide modularity inventory, isolated extraction, NPC merchant/flight-master preparation, November 4 P0321/regression validation and quality-driven alpha/1.0 release gates. `docs/memory/investigations/ISSUE_REGISTER.md` indexes observed failures, intermittents, deferred capability and feature gaps with raw evidence links. No unverified launch date, public release status or empty claims of merchant/flight completion.

## Previous artifact failures retained

P0321 R0/R1 failed 41-character SHA checks, R2 failed generated evidence terminal blank line, and R3 was subsequently committed; P0321 runtime is still not validated. P0322 must run exact commit/blobs and clean-tree guard, new-output nonexistence, candidate prewrite hygiene, full checker suite on shadow and working trees, manifest and git diff hygiene; transactional rollback before staging if checks fail. The new checker must not be counted as gameplay validation.

## Next checkpoint

P0323 **read-only full-repository modularity/ownership audit**, mapping every production file and `immersionEnabled` dependency to D-048 domains and shared infrastructure. No camera, secure-action, or native suppression change until supported Forever runtime test.

## R0 PREWRITE checker-version policy failure (2026-10-23)

The user applied the correctly checksummed original P0322 ZIP on exact clean pushed P0321 `9a180c8`. Baseline and PREWRITE diff hygiene PASS; the shadow 193-checker suite FAILED `tools/check_checker_version_policy.py` because P0322's **new** static checker embedded literal `0.0.222-dev`. The repository policy prohibits historical runtime-version literals inside feature checkers. **R0 APPLY FAIL; no tracked file writes occurred.** This is an assistant artifact-generation mistake, not a project runtime failure. R1 removes that literal from the new checker, dynamically compares TOC and Bootstrap version strings, retains the exact clean pinned HEAD and docs-only output allowlist, and records the failure. Full 193 PREWRITE/POSTWRITE checks and game runtime remain UNVERIFIED until performed in WSL/Forever.
