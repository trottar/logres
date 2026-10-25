# P0336 — L-032 true-bearing compass single-baseline collision policy

**Baseline:** P0335 pushed `ffdbbca3ccb4de7e8f504f57387845f3a2c0e318` (2026-10-25), manifest records 206 PREWRITE and POSTWRITE static checks. P0335 and P0330–P0334 gameplay changes remain **UNVERIFIED** until the Forever beta returns November 4.

## Source finding / hypothesis

The existing `Compass:RefreshAvailableQuestPOIs` paint routine assigns 0–2 staggered vertical collision lanes per category and extra family-specific Y offsets: quest above, tracked below, service slightly above and ordinary POI near tape center. Even isolated glyphs belonging to different categories do not share one baseline. These source facts are sufficient to explain the reported vertical fan/stack; exact client appearance remains unverified.

## Deliberate bounded fix

Keep all source-proven glyph *bearings* at `candidate.x = relative * PIXELS_PER_DEGREE`, and render every shown quest, local POI, possible service and tracking glyph at one `TAPE_Y` center. Reuse one small pure, ordinary-number helper `reserveMarkerBearing(x,width,occupied)` for the existing artwork preview and live source painter. Reserve occupied horizontal intervals across *all four* role pools and optionally the existing manual waypoint (whose origin and size are already known to Logres). Preserve major-quest then local-POI then service then tracking paint priority; source-pool order and nearest-first candidate sorting remain unchanged. If an additional glyph would collide, do not bend its bearing or stack vertically: hide that secondary glyph and report `poiCollisionHiddenCount` in addon-owned diagnostics. Continue traversing candidate rows so noncolliding candidates after an overlap remain eligible for free glyph slots; never claim hidden glyphs were nonexistent or ineligible. The Blizzard minimap and source information remain accessible through existing controls. This is a display-density tradeoff: only one symbol from multiple same-bearing candidates may be visible, and specific details of hidden entries are not shown on the tape.

P0336 intentionally does not claim to show every overlapping glyph simultaneously. Future user-accepted grouping/count badges or expanded focus list require separate preview-first work. Do not shift target bearings to satisfy visual density, invent nav state, inspect protected Blizzard presentation, or hide the minimap.

## Static coverage / historical contract migration

P0220/P0222 checkers pinned the old lane formula `TAPE_Y + lane * 9`; migrate those two assertions to require the new shared true-bearing baseline and interval reservation without weakening their existing native source/role and identity contracts. New checker P0336 tests identical/near/far bearings, unequal widths, cross-pool shared reservation, priority, scan past a hidden collision, and preview/live shared helper. It also preserves P0331 background strata, P0223 quest depth and all 94 loaded modules. No new external dependencies or P-tab controls.

## Acceptance / limitation

PRE/POST static checker suite is mandatory in WSL. The visual appearance and overlapping markers under real camera movement are **RUNTIME UNVERIFIED** until November 4. Use the existing `Compass Art ON`/OFF preview controls, compare all three role markers on one line, and observe a natural cluster. L-032 remains **P0336 SOURCE-PREPARED / VISUAL UNVERIFIED** until visual confirmation. L-030 future questgiver eligibility and L-031 distance remain separate OPEN issues. P0335 L-027 popup source remains unknown; P0321 native gossip restoration remains the first November 4 test.
