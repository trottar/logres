# P0213 — Compass bright-background label legibility candidate

Date: 2026-10-15. Verified GitHub `main` baseline: `018ea0aefd93ffb266e6333e5301a3ce8e443e22` (P0212). Runtime candidate `0.0.122-dev`, **NOT YET VALIDATED IN WORLD OF WARCRAFT**.

## Direct evidence and narrow hypothesis

`docs/memory/evidence/P0202_H3_SCREENSHOT_VISUAL_EVIDENCE.md` records a real 1907x1192 ordinary-world screenshot with faint compass letters/ticks against pale sky. This justifies inspecting label legibility; it does not establish missing navigation data, incorrect bearing, need for repositioning, or a new marker source. D-039's sheet 12 calls for quiet, centered navigation hierarchy, and D-045 v4 fixed semantic envelopes remain binding.

Hypothesis: marginally brighter existing cardinal/intercardinal label colors plus native `FontString:SetShadowColor`/`SetShadowOffset` on existing compass direction labels improves their contrast against light scenery without thickening ticks, adding backdrop panels, moving UI, inspecting hidden/native state, or affecting secure controls. No texture asset changes. The existing 8 supported headings/ticks and edge fading remain intact. The observed faint **ticks** are outside this narrow label-only correction and remain a distinct candidate if visually necessary.

## Source changes and explicit exclusions

Theme adds a compass-only `labelContrast` table (cardinal, intercardinal, shadow colors, 1px/-1px offset); Compass consumes it when constructing its own eight label FontStrings. The source keeps original label fallback tokens and tick textures. No arithmetic or event changes in heading/waypoint, no new clock/OnUpdate, no protected/native frame inspection, no H.2 coordinate change, no action/pet/buff/status interaction change, no Blizzard suppression and no exact player health.

P0211 pet driver remains untouched and the user-tested visual duplicate/reload behavior is CLOSED in bounded scope. Pet secure clicks/autocast, PET STOCK, fresh Edit Mode exit and BugCatcher remain separately unverified. Historical negative experiments remain in repo evidence.

## Runtime gate and results (pending)

1. After deployment and `/reload`, developer panel **Phase E → Compass Check**; **Phase H → H.2 Map → Layout Check, Overlay ON/OFF**; **Phase 0 → Run All**.
2. Inspect direction glyphs over an ordinary bright background and a darker environment; confirm legibility, restrained appearance and correct heading movement. One uncropped screenshot preferred; no travel requirement.
3. Confirm stock pet remains suppressed in Immersion ON and returns OFF without new duplicate; no need for another deep pet-driver experiment. If naturally available, manual waypoint check; otherwise DEFERRED.
4. Zero new Lua, protected-action, secret-value or taint errors. Save diagnostics. A failed visual/technical result is FAIL and requires corrective patch, not a claim of H.3 completion.

Results: **UNTESTED — static checker or patch application alone is not visual PASS**.
