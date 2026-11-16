# P0457 — Selected world-nameplate owner continuity (2026-11-15)

## Evidence and scope

Verified GitHub P0456 `267bb947a272fdee71636ae5fd21bad36d979a91`,
tree `394d43b54615b8f72f2d34dae572cd99c8c15074`. Latest Forever
0.0.325-dev incident #12792 (session 122) has 0 secondary Logres
attachments, selected 4 attaches/3 detaches, 7 target changes and 2
nameplate removals, no native restoration failures, selected Logres bar
visible in the captured screenshot. Earlier session 121 #12710/#12712
shows selected owner 2/2 and 3/2, respectively. Counters are cumulative
and are not proof that any of these transitions visually flickered.
P0454 and P0455 secondary visual FAIL; P0456 secondary suspension PASS
scoped. L-011 PARTIAL, L-028 OPEN. Full World Enemy OFF, native cast,
input, auras, and taint remain unverified in latest capture.

## Source defect and narrow P0457 remedy

P0456 HUD:RefreshLiveWorldEnemy acquires the current target anchor then
unconditionally frame:Hide/ClearAllPoints/SetPoint, calls
ClaimNativeEnemyDecor (restoring the previous alpha claim), frame:Show
and screen-aura handoff for every successful update. This is unnecessary
when an already-owned selected display is still eligible and neither
nameplate nor target identity changed. It can cause native presentation
ownership churn; does not alone prove visible flicker.

P0457 adds an early steady-state path after the existing current-target
hostility, ordinary anchor, forbidden/behind-camera eligibility checks:
if the selected addon-owned frame is visible with a native claim and the
event is not a new selected NAME_PLATE_UNIT_ADDED token, update only
addon-owned name/HP consumers. Same ordinary event token is also steady.
No native anchor/frame equality or source-secret inspection is used;
opaque original-alpha tokens remain untouched. A different or previously
unknown selected added token causes a genuinely structural transition:
restore old claim first, then reattach. Refused restore aborts new claim.
Target-changed and removal handlers still hide conservatively, and loss
of eligibility, OFF/immersion OFF, and combat unknown remain fail-open.
Preserve the 100% selected presentation, native auras/cast/click owner,
screen fallback and 50% secondary suspension. No polling, timers, CVar
changes, secure attachment inspection or blanket stock suppression.

## Runtime validation not yet performed

For P0457 run World Enemy ON out of combat, then natural selected enemy
combat with several updates. Status and Report Bug should show steady
updates increasing without corresponding extra native claims/handoffs;
legitimate target changes and nameplate removals still restore native.
Test OFF, native cast/click/aura and Lua/taint before accepting. Mark
failure, interruption or unreproduced cases explicitly. Never credit a
STATIC PASS as a client PASS; do not restart secondary takeover.
