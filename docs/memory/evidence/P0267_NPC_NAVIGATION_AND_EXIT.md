# P0267 — NPC header Back/Goodbye alignment and one-step authored exits

Date: 2026-10-19. Baseline: verified pushed `main` `2270e84375d70b5765a014bfc6134951f08d7f1d` (P0266).

## Direct client evidence

The user explicitly reports all other buttons worked as expected in `0.0.164-dev`; the provided screenshot shows the **Back** text drawn at the same lower-center x location as the narrative `1 / 2` indicator, with the next-page chevron nearby. **Goodbye** is at upper right, whereas **Back** remains lower-center, creating inconsistent navigation and actual spatial overlap. The user also reports **Farewell** is a separate goodbye-message node requiring another click on Goodbye. This is not a native transaction failure.

The diagnostic export has `loadCount=354` at `0.0.164-dev`. Quest Dialogue Check records `npcoptions` clicks=20 branches=20 backs=14 pageMoves=1 blocked=0 nativeActions=0; Goodbye clicks=10. It reports `active=false` / `lastResult=goodbye` after intentional exit. Quest Dialogue, Quest Offer Controls (`probeCallOK=false`) and Run All PASS for performed checks. These do not imply live gossip/quest claim/other NPC service action acceptance. No Lua/secret-value failures are shown in the supplied diagnostic export; the screenshot remains a real visual defect despite the nominal PASS lines.

## Narrow verified cause

`UI/OptionList.lua` sets `self.back` at x=0 on `NAV_TOP=423` within the 467-high panel. `UI/NarrativePages.lua` positions the `1 / N` indicator at lower center on the same panel; the resulting two controls collide. `Quest/Dialogue.lua` creates an upper-right Goodbye anchored at (-21,-12) on root, which does not itself occupy the bottom paginator rail. `Quest/OptionModel.lua` maps Farewell to `farewell`, an extra node with only `Safe Travels` copy and no action; `Quest/OptionSession.lua` treats it as an ordinary branch and does not exit. Locked scenario also has a `Leave the watch` -> `end` message node. No new Blizzard hook is needed.

## P0267 fix and proof gates

Re-anchor only Back to upper-left (21,-12), style it with matching 78x24, underline and hover treatment to the unchanged upper-right Goodbye (78x24, -21,-12). The narrative paginator (bottom center), option list pager/prev/next (bottom at -391/-423), all row geometry and rendering components remain in place. Back still appears during nonfinal long narrative pages, with controller-owned stack/page restoration unchanged. The header buttons occupy separated nonoverlapping horizontal regions on the 640px panel.

Use an explicit synthetic `action="goodbye"` in authored options for Farewell and Leave the watch. `OptionSession:Choose` validates ordinary index/availability *first*, then dispatches those exit actions to the existing `Dialogue:Goodbye()` and hence `OptionSession:Goodbye` / `Dialogue:HidePresentation` stock restoration. It must not expose native gossip selects, quest claims or service transactions. Remove redundant goodbye-message intermediate nodes. Existing P0266 runtime session logic and counters retained; farewell selections count as clicks, not branches.

A new static contract guards exact header positioning, mutual clearance, one-step exit routing, old paginator/pager placement, TOC load contracts and native/camera protection. Run all repository `tools/check_*.py` in a shadow tree, `git diff --check`, then all checks postwrite. Static PASS is not in-game PASS. Required client acceptance is no Back/indicator overlap on long narrative 1/2 and 2/2, one-click exit from Farewell and Leave the watch, Back returns the correct root/option page, Goodbye remains top right in all previews, nativeActions=0, and F/H/0 diagnostics. Do not run real gameplay Accept/Decline, quest 237, or travel.

## Status

P0266 is PUSHED and user-accepted for scoped interaction behavior but remains VISUAL FAIL for header collision and UX FAIL for redundant Farewell. P0267 is PREPARED / CLIENT UNVERIFIED. All known negative results remain recorded. No new camera/DynamicCam or stock transaction mutation.
