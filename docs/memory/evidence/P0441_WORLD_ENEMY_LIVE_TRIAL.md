# P0441 — Real world enemy target trial (opt-in, no production attachment)

Date: 2026-11-10. P0440 verified main `bec4038ebcf9faf7fb8534091e5cfd6075126aef`.

## Evidence and rationale

- P0440 Forever session 102 incident 11161 (`0.0.311-dev`): 86 raw/33 accepted lifecycle events, 4 add/4 remove, 12 target + 17 secondary ordinary accessible nameplate anchor observations, 29 in combat and 0 OOC; hostile combat player-targeting observations 4; secret tokens/results and probe failures 0. These are *observations*, not distinct units or aggro detection.
- P0438/P0439 OOC trial #11003/#11082: no accessible OOC nameplate, no attachment. P0432 target anchor seen during combat without mutation. Preserve these negatives.
- ElvUI/oUF architecture establishes NAME_PLATE_UNIT_ADDED/REMOVED and addon-owned frame model; P0441 is independently implemented, does not copy ElvUI code (restricted license). oUF behavior alone is not Forever combat mutation proof.

## Implementation

An explicitly enabled, independent P0441 World Enemy trial builds the already approved Logres shared name/bar/cast/aura display on UIParent *outside combat*, at 100% size/opacity. It reads event-time nameplate tokens through P0440-style secret-first screening, confirms selected hostile target, attackability, non-forbidden and not-behind-camera nameplate, then attempts guarded SetPoint of **only an addon-owned, unprotected, mouse-disabled frame** relative to the ordinary anchor. There is no native frame/child mutation, reparenting, CVar forcing, polling, or stock suppression. Existing P0438 World Trial remains unchanged. Real target name and UnitHealthPercent flow directly into their native render consumers. StatusAuras existing ordinary cached harmful/helpful target rows use the fixture's +-25px lanes. Native and screen-space target information and interaction remain available at all times.

Panel: right-click Report Bug > H > World Enemy ON / OFF / Status. Left-click Report Bug stores `snapshot.worldEnemyLive`. ON may say ARMED / ANCHOR DEFERRED outside combat; it continues observing natural combat nameplate events. Trial disabled on next addon load; saved screen-space preference remains OFF. If a protected operation is refused, stop that attempt, report scalar reason/failure, leave native fallback. Any taint/protected action error is a real failure requiring correction.

The 50% secondary visual fixture remains approved but **not activated for live units**. Enemy targeting player is not equivalent to confirmed aggro; per-unit threat and its gain/loss remain DEFERRED under D-042/L-011. The trial is not proof of the permitted production attachment lifecycle.

## Forever validation (pending)

Deploy `_forever_`, `/reload`, use Report Bug > H > World Enemy ON outside combat, then natural selected-hostile combat (no nameplate settings changes). While combat anchor exists, check live Logres name + percent and buffs/debuffs at their spacing, switching targets and leaving combat, native clicks/target fallback and errors. After combat World Enemy Status, left-click Report Bug, World Enemy OFF, `/reload`, export `LOGRES_BUG_REPORT_LATEST.zip` plus diagnostics. PASS only on actual behavior, not a static check or mere accessible anchor read.

## Limitations / deferrals

No guaranteed OOC anchor, protected-frame permission or secondary threat mechanism; trial is opt-in and does not remove any existing surface. If safe positioning is refused, classify as capability deferral, not code PASS. If a runtime taint or protected error appears, record as failure and prepare a narrow correction.

## Author preflight negative result

P0441 R0 source preflight passed focused contracts and Lua syntax but **failed 14/305 legacy static checkers** after a CURRENT.md size-budget compaction omitted exact P0357/P0358/P0359 historical marker strings. This is a documentation/checker integration failure, not a Forever result. The corrected R1 restores those markers; the failed R0 is retained as negative evidence.
