# Screen Map V7 — final pet/party spacing refinement

Date: 2026-11-09. Source: direct user instruction after P0421 WoW review.
Pinned GitHub baseline: `ac373444999aabc8309b212e746f213de9fb6384` (P0421).

This **supersedes V6 for runtime placement** while retaining
[`SCREEN_MAP_V6.json`](SCREEN_MAP_V6.json) and earlier V5/V6 evidence as
historical sources. V7 records a single final refinement request: shift the
party/allies region and the pet-actions cluster **1% to the right** to create
slightly more spacing from the pet bar.

No other centers, sizes, action-bar roles, grids, scales, bindings, protected
behaviors, pet suppression logic, or Blizzard fallbacks change. The H.2 overlay
remains read-only and continues to project intrinsic frame geometry at the
approved anchors.

| Region | V7 center X% | V7 center Y% | Status |
| --- | ---: | ---: | --- |
| Allies (`allies`) | 24 | 50 | adjusted |
| Pet Actions (`petActions`) | 10 | 50 | adjusted |
| Compass (`compass`) | 50 | 5 | unchanged from V6 |
| Active Quest (`activeQuest`) | 88 | 10 | unchanged from V6 |
| Player Reaction (`playerReaction`) | 50 | 90 | unchanged from V6 |
| Player Harmful (`playerHarmful`) | 50 | 85 | unchanged from V6 |
| Target Fallback (`targetFallback`) | 80 | 50 | unchanged from V6 |
| Target Harmful (`targetHarmful`) | 70 | 50 | unchanged from V6 |
| Target Helpful (`targetHelpful`) | 90 | 50 | unchanged from V6 |
| Bar 2 (`bar2`) | 4 | 75.16 | unchanged from V6 |
| Bar 1 (`bar1`) | 13 | 75 | unchanged |
| Bar 4 (`bar4`) | 10 | 95 | unchanged |
| Bar 3 (`bar3`) | 89 | 85 | unchanged from V6 |
| Bar 5 (`bar5`) | 89 | 95 | unchanged from V6 |
| Passive Status (`passiveStatus`) | 89 | 78 | unchanged from V6 |
| Context Objective (`contextObjective`) | 50 | 50 | unchanged |
| Context XP (`contextXP`) | 50 | 55 | unchanged from V6 |
| Quest Dialogue (`questDialogue`) | 50 | 25 | unchanged from V6 |
| Report Bug (`reportBug`) | 95 | 35 | unchanged |

WoW Forever validation is still required after deployment, but the user's
latest screenshot judged the full layout effectively complete aside from this
small spacing change.
