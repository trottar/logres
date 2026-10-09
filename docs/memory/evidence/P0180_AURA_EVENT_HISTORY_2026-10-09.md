# P0180 — event-latched harmful-aura hypothesis and test gate (2026-10-09)

## Verified prerequisite

Remote GitHub main `8f5d94ff8e8c9e2876dd993765f8865ea54e244c` contains P0179 runtime acceptance. P0178 R1 `0.0.95-dev` loadCount 229 showed `/logres` restored and Run All complete; UI Ownership Check ON 17 PASS/18 STOCK, OFF 16 PASS/19 STOCK, zero FAIL in both. This scope does **not** prove Blizzard retained native frames visually.

P0177 read-only comparator saw an ordinary target HELPFUL candidate via general filter with priority filters empty, while live harmful observations were empty/secret-restricted. Session history counted repeated secret *skips*, not actual hidden auras. Direct checks after an effect expires do not preserve the source comparison. P0180 tests whether capturing existing aura invalidation events can disambiguate a fleeting ordinary harmful candidate, a truly empty result, and protected indexed queries, without unsafe reads.

## Intended test

Existing StatusAuras event listener calls independent reader only after the production Refresh, with ordinary unit-argument guards and Immersion ON/preview OFF gates. Retain maximum ordinary counts separately for general and priority filters; record empty/restricted events, per-target reaction derived only from ordinary `UnitCanAttack`/`UnitIsFriend`, and unexpected observer failures. Do not inspect `UNIT_AURA` delta payload, secret values, Blizzard presentation, or aura identity. No passive timer/polling.

## Runtime result

**PENDING**. No in-game source, reaction or harmful visibility PASS follows from static reasoning. A clean Run All with zero harmful rows remains environmental DEFERRED, not live harmful proof. If event-captured ordinary target harmful data appears, compare its actual Logres lane and Blizzard native visual before promoting the renderer. Preserve stock aura fallbacks regardless.

Original P0178 `0.0.94-dev` slash startup compile failure (`handleCommand` >60 upvalues) remains historical FAIL; P0178 R1 observed fix at `fd0dc88`, acceptance checkpoint `8f5d94f`. Post-loot ObjectiveTracker flash remains intermittent/unreproduced; primary secure special ownership remains incomplete.
