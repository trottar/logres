# P0218 — Sheet 04 compact aura visual states

Baseline: GitHub main P0217 `b841afa39ca15edfad12ac8f675efcb80acd0df6` verified. User says P0217 works as expected; latest uploaded LogresDiagnostics `0.0.126-dev`, loadCount 287, shows ordinary out-of-combat Run All complete and ownership 17 PASS, 18 deliberately STOCK, 0 FAIL. Native debuffs ready/active, but harmful real populated states absent or restricted; tooltip and multi-effect live visual proof remain DEFERRED. User previously rejected treating partial approved art work as overall H.3 completion.

## Narrow observation and hypothesis

`StatusAuras.lua` already renders Blizzard-native icons in a 25px approved passive border and colors urgent/harmful/helpful icons via ordinary `kind`. It currently uses a bare unplated stack-count FontString and an `!` glyph/tinted frame as its only urgent markers. Sheet 04 calls for icon-dominant small metadata plate and restrained urgency. Without changing source, add the **existing approved aura count plate** behind actual 2+ stack text, and a 2px short warm top rail for already selected `kind="urgent"`; use Theme dimensions/colors/paths. No new texture invention and no native member visibility reads.

## Candidate / result

P0218 `0.0.127-dev` is **PREPARED CANDIDATE — WoW UNVERIFIED**. The applier pins exact P0217 blobs, builds a full shadow candidate and tests all tools/check_*.py before tracked writes. Checks are not game proof. On unsupported hidden harmful aura the Blizzard native path remains unaffected; any live multi-aura appearance unobserved is DEFERRED, not PASS.

## Acceptance

`/reload`; developer panel Phase D Status Aura Preview ON then OFF and Status Aura Check; Phase H Native Access Check/Layout Check; Phase 0 Run All. Visually inspect ordinary and urgent icon edge, at least one preview count>1 with its count plate, tooltip source safety, and that preview returns to live. No contrived combat/gameplay necessary. New Lua/taint/protected error = FAIL, stop.

## Safeguards

No changes to `NativeDebuffs.lua`, `PlayerHelpfulAuras.lua`, `AuraSourceEngine.lua`, `StatusAuras` source filters, `GameTooltip` hooks, restricted-unit checks, pet driver, stock fallback or screen-map. P0209 and P0215 R0 negative records retained. Full member coverage remains unverified.

## R0 pre-write failure / R1 repair (2026-10-16)

- **FAIL — R0 PREWRITE / no tracked writes:** The user's `P0218_APPLY.py` stopped at `SHADOW CHECK FAILED check_memory_health.py` because the candidate `CURRENT_HANDOFF.md` did not point to `CURRENT.md`. `git status --short` displayed only pre-existing untracked preview PNGs; no P0218 manifest was created. This is a delivery/checker-compliance defect, not a WoW or aura-runtime failure.
- **R1 candidate:** Add the authoritative `docs/memory/CURRENT.md` pointer to the compact handoff and check its presence as part of the pre-write candidate validation. All aura presentation source transformations and the runtime version remain identical to R0. Full static suite must pass on the actual WSL worktree before deployment; no WoW PASS is claimed.
