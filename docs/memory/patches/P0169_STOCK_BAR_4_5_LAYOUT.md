# P0169 — Source-backed stock Bars 4–5 and five-role layout

Date: 2026-10-08. Baseline main `b455e7cf32d03f51d15eb0a4e2b73e79b5c03bb5`. Candidate `0.0.86-dev`. Status: UNTESTED RUNTIME CANDIDATE.

## Intended behavior

- Preserve existing supported stock Bar 2 and Bar 3 replacement.
- Add Bar 4 `MultiBarRight` / native slot range `25–36` / bindings `MULTIACTIONBAR3BUTTON1–12`; new outer-left Logres secure 3×4 cluster.
- Add Bar 5 `MultiBarLeft` / native slot range `37–48` / bindings `MULTIACTIONBAR4BUTTON1–12`; new outer-right Logres secure 3×4 cluster.
- Create/register native ActionButton primitives and route temporary, non-persistent bindings through matching Logres buttons only while stock replacement is active. Reuse exact stock bar/button alpha/mouse snapshots and restoration; out-of-combat application only and combat deferral. Return to native stock bars on Immersion OFF, replacement OFF, module cleanup.
- Only display each new outer Logres cluster when its original stock bar is configured/shown. Never override `PROXY_SHOW_ACTIONBAR_*` settings.
- Relocate existing Primary, Secondary, Utility lower action roles from y=-260 to y=-350; supplemental Bar4/5 roles at x=-460/+460, y=-350; move class/pet anchor to (-460,-190). This is a screenshot-guided geometry candidate, not final art acceptance.
- Extend existing Phase C Action Check, Stock Replace Check and Phase H Layout Check without expanding the developer-panel button count.

## Explicitly not included

No native MainActionBar or override/possess/vehicle/bonus/pet secure suppression; no minimap, full tracker/log, persistent XP, micro-menu, PetFrame, target auras or compact party hide. No global hooks, polling, CVar mutation, protected introspection or saved binding changes. Native Bar6–8 also remain untouched. Native Bar4/5 availability/show preference is a runtime gate; mismatch must fail open, not be called PASS.

## Gate

1. Complete pre-write shadow suite and git diff --check; after write complete suite again.
2. Deploy and `/reload`; Phase C Action Check + Stock Replace Check, Phase H Layout Check, Phase 0 Run All.
3. Screenshot and test visible native source Bar4/5 -> stock invisible/no click region, matching Logres buttons available and correct hotkeys, stock Main/Pet/minimap/tracker/XP remain usable; action execution in normal play, no Lua/protected/taint/secret.
4. Immersion OFF restores stock alpha/mouse/bindings; ON reapplies. Test editing through native fallback; defer unavailable configured native source or special gameplay.
5. User commits/pushes only after runtime acceptance; assistant verifies main.

Source: `Gethe/wow-ui-source@15666a6e67938a1ab5caf041406464251db111ca` `Blizzard_ActionBar/Shared/MultiActionBars.{lua,xml}`. Preserve screenshot-negative evidence even on success.
