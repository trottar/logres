# P0174 — interaction and native coexistence repair

Baseline: verified `f9c99685f72fa8aacd3cb40b69548a7450ad516f` / `0.0.89-dev`. Candidate `0.0.90-dev`. **RUNTIME UNTESTED**.

Combined Phase H.1 patch for user-reported limitations (not a completion claim):
1. Source-parity normal action-slot drag-to-move/swap and native action/pet tooltips for all Logres button clusters, respecting the normal Blizzard action-bar lock + modifier and combat exclusion. Pet slot edits remain stock-only.
2. Native action/aura tooltip discovery as hover depth; Logres player HELPFUL|PLAYER aura glyphs preserve their original source index (rather than their compacted slot index) and use Blizzard `SetUnitAura` for tooltip rendering. Secret-skipped/preview auras never synthesize an index.
3. Event-targeted re-fold on Objective Tracker lifecycle refreshes, since Logres's original `Fold` returned immediately once a snapshot existed and therefore could not undo later Blizzard re-show. Diagnostic re-fold counter tracks attempted mutations, not a verified reappearance. No polling or blanket hook.
4. Source-grounded native cast-bar access (`CAST` dock domain: player default, overlay player, target spell bar), reversible on-demand and immersion OFF. Normal mode folds the redundant bars; player/target cast *timing* is **not** owned by Logres's qualitative glyph, so CAST remains an explicit user-accessible fallback. No boss/focus/arena suppression. Event-specific re-fold on cast starts and channel starts; if the frame sources are missing or protected mutation fails, leave stock available and record failure.

**MainActionBar suppression remains blocked**: P0173 established a normal candidate but no combat-safe native secure editing/possess/override fallback. No invisible stock click regions or automatic key takeover are introduced by P0174. The user explicitly reported stock Main remains; do not close H.1. Follow up with focused Main secure fallback proof rather than unsafe unconditional Hide.

Static checks and shadow candidate execution are required in the one-time applier. In-game: confirm action move and swap across 1–72, lock/modified pick-up behavior, hover details, empty/preview aura hover, same-session quest event re-fold, CAST dock restoration during a real cast, immersion OFF/ON, and one direct Run All after checks. Any unavailable cast/combat/quest event is environmental DEFERRED, not PASS.
