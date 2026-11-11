# P0446 — World-attached target and screen-space fallback handoff

Date: 2026-11-11. Verified GitHub main P0445 `53d74f95d4665a8ac9f01e4ef2b437849c17c1f0`; P0444 source `0.0.315-dev`. L-011 PARTIAL; D-042 remains binding.

## New live observation

- Forever 1.60.1 (build 70888), session 108, incident #11645 at 10:51 EST: user confirms P0444 black matte **gone**. Report Bug shows 1 world target attachment, 1 combat attachment, 0 failures, presentation `transparent-owned-unit`, mouse-disabled frame with native-anchor-center layout. The screenshot shows overlapping native Blizzard/Logres overhead text and bars, plus a separate Logres screen-space Forest Spider target on the right. This is a visual overlap, not attachment failure.
- The screenshot/diagnostics do not verify click-to-target, casting, secondary aggro, all target switch/removal transitions or all fallback states. Those are not PASS. P0443 matte remains rejected.

## P0446 implementation and limitations

- When a Logres world frame has successfully attached and shown, only its screen-space name/health widgets are hidden; the frame stays shown so the independently owned target cast cue remains available. Target health/text continue to flow only to native addon-owned consumers. When world ownership detaches (target switch, removal, failed consumer, World Enemy OFF), `UpdateTarget()` refreshes the same canonical screen fallback using ordinary target existence, without deriving identity in Lua.
- The first draft attempted to hide the whole screen target parent, but that would hide its child cast cue. This was rejected in source review and narrowed to name/health widgets. Failed owned-frame hide also refreshes the fallback (native cast and click controls are never touched).
- The handoff counts and screen fallback visible flag are recorded from addon-owned state in World Enemy Status and Report Bug. No Blizzard UnitFrame, subregion, CVar, hit test, native cast/auras, protected value or nameplate pool is read or changed; the 100% fully opaque world target and transparent backing and +/-25 px owned aura positions stay unchanged.
- The two **overhead** visuals still overlap until a distinct reversible native-decorative owner transfer is established with exact Forever proof. Do not call screen fallback removal a complete nameplate replacement. Secondary half-size/opacity remains gated on independent aggro proof.

## Refused iterations retained

- Pre-release R0 author-check REFUSED at 307/309: P0381 and its P0408 import correctly require CURRENT P0446 to be the first checkpoint in every active roadmap. This was a release-document ordering failure, not runtime PASS/FAIL.
- Pre-release R1 author-check REFUSED at 308/309: historical P0443 checker still pinned P0444 as the first roadmap checkpoint. The P0446 candidate makes this one check dynamically verify the CURRENT checkpoint first, while additionally requiring retained P0444, P0443 and P0442 headings in historical order. The rejected matte, transparency, native/no-CVar, and restore checks remain intact.

## Runtime validation (pending)

Deploy P0446 to Forever, `/reload`, outside combat Report Bug > H > World Enemy ON. Select/fight a hostile with a visible nameplate and verify overhead world frame appears and the separate screen-space Logres name/HP disappears without hiding the target cast cue; world name/health/aura stay fully opaque, backing fully transparent. Confirm target switching, removal, OFF and World Enemy Status refresh the screen-space target when appropriate, including no-target hide. Verify native click targeting and cast/status cues, and no Lua/taint/protected errors. Left-click Report Bug and export diagnostics. Session-specific failures and results must be recorded before L-011 advancement.
