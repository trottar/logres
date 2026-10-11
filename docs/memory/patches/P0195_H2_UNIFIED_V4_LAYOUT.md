# P0195 — One coordinated H.2 approved v4 runtime layout candidate

Baseline: verified main `f7a67bc` (P0194 R3, `0.0.103-dev`). Candidate addon `0.0.104-dev`. **Runtime placement / visual / hit-region proof OPEN**; no remote Git change performed by applier.

## Decision and scope

The user rejected widget-by-widget moves. P0194 R3 supplies in-game full-screen map and panel UI; screenshot and loadCount 245 capture 13/13 current Logres frames and show original positions. This patch translates all *eligible, addon-owned* D-045 regions in one central `Integration/Layout.lua` pass using guarded UIParent width/height and native lifecycle/scale events (no timer polling). The canonical 13 rectangles do not change. Geometry moves the anchor reference positions rather than stretching UI to fill planning envelopes. When viewport measurements are restricted, leave usable legacy coordinates in place; protected combat defers anchor updates. On translation error, restore the original anchor points; report placement status in Layout Check.

Main and Secondary become 2×6; Utility becomes 6×2. Bar 4 and Bar 5 remain available in separate non-overlapping side satellites rather than silently discarded. No action slot, secure page, binding or replacement ownership is changed. Player harmful separates from resource; enemy harmful/helpful become two-column status lanes in their own left/right spaces. Addon native restricted HARMFUL containers remain separate, use compact 18px icons in native layout, and never read native aura members. The target's addon-owned fallback width changes from 260 to 198 UI units to fit its authored center; its intended sparse information is unchanged. All established Blizzard fallback policy stays in force.

The top-right native-access dock (370×26 UI units) is moved to an authored *non-D-045 satellite* below the variable Quest envelope so the stock navigation/quest/XP/menu/cast controls remain accessible. Class/Pet still represents a probe, not full replacement; Group remains only ally hints, and Blizzard group and special UI stays stock. These safe satellite coordinates are first-pass source-based design decisions and must be verified in WoW. No claim that all 13 widget bounds equal their region envelopes, or that optional special modes are proven.

## Validation

1. Apply to an exact clean `f7a67bc` `main` baseline; applier verifies unchanged source, full static checker suite and `git diff --check`; no commits/pushes.
2. Deploy via `./tools/deploy_logres.sh "$ADDONS"`, then `/reload` out of combat.
3. Developer panel Phase H → **H.2 Map** → **Overlay ON**. Capture uncropped full-screen blue-plan / gold-actual map. Verify real action clusters are visually separated, target/addon aura groups flank the right-offset fallback, player debuffs above resource, helpful auras above Utility, quest no longer under native dock; no lost/unusable action controls.
4. **Overlay OFF**, **Layout Check**, Phase 0 **Run All**; export `LOGRES_DIAGNOSTICS_LATEST.lua`. If a Lua/secret/protected/taint error, hidden native click region or overlap appears, stop: preserve FAIL and fix before committing. Actual populated harmful aura and special combat/mode evidence may remain deferred.

Historical delivery failures are recorded in prior patches; this candidate must not be called H.2 PASS before in-game proof.
