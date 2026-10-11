# P0191 — Save user-approved H.2 screen-map v4

Date: 2026-10-11. Baseline: verified remote `main` `c67527e095b193dd539865df9bc6363bd1c9edd5` (P0190). **DOCS / DESIGN / STATIC VALIDATION ONLY**. No Lua, TOC, UI anchor, protected action, stock suppression or runtime version change.

## Approved inputs

User supplied v4 positions/dimensions for 13 labeled rectangles in viewport percentages. A final explicit agreement changed Main Bar Y 60.3% to 60.4%, matching Secondary. The full exact export after this one change is `docs/design/layout/SCREEN_MAP_V4.json`. Human-readable authority: `docs/design/layout/SCREEN_MAP_V4.md`; decision: D-045.

Semantic constraints include symmetric target aura positioning (`enemy-debuff` 65.2/40, `enemy` 72/40, `enemy-buff` 85.8/40; matched 9% heights, equal 0.8% gaps), urgent debuffs directly above bottom-center resource, distinct left class/totem controls, left action controls, upper-left group/pet, top compass, upper-right one-focus Active Quest, peripheral player buffs/utility.

## Scope and evidence

This is **user-approved design evidence**, not a WoW execution, screenshot proof of actual production sizing, anchor/collision PASS, or in-game movable/resizable UI. The prior generated layouts that displaced resources/debuffs or centered target are negative design evidence and are superseded by v4. Runtime still uses P0166 integration-owned pixel anchors. No changes to secure interaction/fallback policy.

## Preflight / checks

The one-time applier requires the exact c67527e main checkout and intact patch-owned baseline blobs; validates candidate transforms, JSON schema/geometry, memory health and whitespace **before** writing; uses transactional rollback if a post-write check fails; generates `P0191_MANIFEST.txt`; runs `git diff --check`. New checker `tools/check_h2_screen_map_contract.py` validates the schema and approved structural relationships without hard-coding every rectangle's exact position.

## Next

After user applies, commits, pushes, and remote main verification: **P0192 Phase H.2 runtime geometry mapping/collision audit** with actual Logres widget size/density and Blizzard fallbacks. Do not claim H.2 geometry runtime-complete or begin H.3 styling solely from this design checkpoint. No WoW redeploy for P0191.
