# Screen Map V6 — user-authorized layout refinements

Date: 2026-11-09. Source: `LOGRES_SCREEN_MAP_REFINEMENTS_P0421.json`
(`logres-screen-map-adjustment/v2`). Pinned GitHub baseline:
`bd55e34e823abadd093930aa184fcd14e0f64ab0` (P0420).

This **supersedes V5 for runtime placement** while retaining
[`SCREEN_MAP_V5.json`](SCREEN_MAP_V5.json) and the P0418/P0419/P0420
measurement evidence unchanged as historical sources. V6 records 15 user
selected new component *centers*, retains the four unchanged V5 centers,
and keeps all original design envelope widths/heights for comparison only.

The uploaded editor's `from` coordinates reflect a visual estimate of the
center of each current frame, **not always the actual H.2 anchor**. Four
semantic anchors therefore use the requested `(to − from)` translation:
Compass uses `TOP`, Active Quest uses `TOPRIGHT`, Quest Dialogue uses `TOP`,
and Passive Status uses `LEFT`. The other centers may be used directly. The
original `from`/`to`/`delta` rows remain in the request and evidence.

| Region | V6 center X% | V6 center Y% | Status |
| --- | ---: | ---: | --- |
| Compass (`compass`) | 50 | 5 | adjusted |
| Active Quest (`activeQuest`) | 88 | 10 | adjusted |
| Player Reaction (`playerReaction`) | 50 | 90 | adjusted |
| Player Harmful (`playerHarmful`) | 50 | 85 | adjusted |
| Target Fallback (`targetFallback`) | 80 | 50 | adjusted |
| Target Harmful (`targetHarmful`) | 70 | 50 | adjusted |
| Target Helpful (`targetHelpful`) | 90 | 50 | adjusted |
| Allies (`allies`) | 23 | 50 | adjusted |
| Pet Actions (`petActions`) | 9 | 50 | adjusted |
| Bar 2 (`bar2`) | 4 | 75.16 | adjusted |
| Bar 1 (`bar1`) | 13 | 75 | unchanged |
| Bar 4 (`bar4`) | 10 | 95 | unchanged |
| Bar 3 (`bar3`) | 89 | 85 | adjusted |
| Bar 5 (`bar5`) | 89 | 95 | adjusted |
| Passive Status (`passiveStatus`) | 89 | 78 | adjusted |
| Context Objective (`contextObjective`) | 50 | 50 | unchanged |
| Context XP (`contextXP`) | 50 | 55 | adjusted |
| Quest Dialogue (`questDialogue`) | 50 | 25 | adjusted |
| Report Bug (`reportBug`) | 95 | 35 | unchanged |

Only addon-owned anchor translation changes in P0421; fixed source bar
roles, grids, scales, secure buttons, keybindings, normal pet fallback and
Blizzard UI ownership remain unchanged. The existing P0416 out-of-combat
bounds/overlap gate and legacy restoration still apply. V6 does not approve
resizing controls or a combat-time layout editor. WoW Forever validation is
still required after deployment, especially for the shifted Quest Dialogue,
Active Quest, and pet action clusters.
