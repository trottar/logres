# Screen Map V5 — approved full-screen authored layout

Date: 2026-11-09.
Source: uploaded `LOGRES_SCREEN_MAP_APPROVED.json`.
Pinned baseline for the author-time map: `d11b76ab786f3b08151c426e52502a3415fb4877`.

This supersedes the earlier 13-rectangle H.2 planning sheet for the current
coordinated screen-fit pass. Unlike `SCREEN_MAP_V4.json`, these coordinates are
**viewport percentages expressed as component centers** (`x`, `y`) plus
component extents (`w`, `h`). Runtime anchor translation remains component-
specific: e.g. top-centered widgets use the top edge of the box, the Active
Quest widget uses the box top-right, and the passive-status row uses the box
left-center.

Machine-readable authority: [`SCREEN_MAP_V5.json`](SCREEN_MAP_V5.json).

| ID | Name | Center X | Center Y | Width | Height |
| --- | --- | ---: | ---: | ---: | ---: |
| `compass` | Compass | 50.1 | 10.0 | 37.4 | 6.9 |
| `activeQuest` | Active Quest | 88.0 | 15.0 | 19.6 | 19.2 |
| `playerReaction` | Player Reaction | 50.75 | 91.3 | 22.5 | 6.0 |
| `playerHarmful` | Player Harmful | 50.75 | 83.9 | 22.5 | 5.8 |
| `targetFallback` | Target Fallback | 78.5 | 44.5 | 13.0 | 9.0 |
| `targetHarmful` | Target Harmful | 68.2 | 44.5 | 6.0 | 9.0 |
| `targetHelpful` | Target Helpful | 88.8 | 44.5 | 6.0 | 9.0 |
| `allies` | Allies | 25.0 | 45.65 | 10.0 | 25.9 |
| `petActions` | Pet Actions | 10.0 | 55.0 | 10.0 | 5.0 |
| `bar2` | Bar 2 | 5.0 | 75.0 | 10.0 | 38.0 |
| `bar1` | Bar 1 | 13.0 | 75.0 | 8.0 | 38.0 |
| `bar4` | Bar 4 | 10.0 | 95.0 | 10.0 | 8.0 |
| `bar3` | Bar 3 | 88.0 | 85.0 | 24.0 | 10.0 |
| `bar5` | Bar 5 | 88.0 | 95.0 | 24.0 | 8.0 |
| `passiveStatus` | Passive Status | 88.0 | 75.0 | 22.0 | 5.0 |
| `contextObjective` | Context Objective | 50.0 | 50.0 | 20.0 | 5.0 |
| `contextXP` | Context XP | 50.0 | 63.0 | 20.0 | 4.0 |
| `questDialogue` | Quest Dialogue | 50.0 | 43.0 | 30.0 | 30.0 |
| `reportBug` | Report Bug | 95.0 | 35.0 | 8.0 | 3.5 |

Notes:
- Bar 1/2/3/4/5 are the accepted authored five-bar arrangement.
- `reportBug` is part of the approved overlay map even though the separate
  native-access dock remains an independent fallback/control surface.
- This file is a design/layout authority only. It is not by itself gameplay,
  collision, secure-click, or Blizzard-suppression proof.
