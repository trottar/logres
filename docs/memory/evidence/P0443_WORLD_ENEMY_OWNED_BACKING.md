# P0443 — Owned name/health backing after P0442 Forever overlap

## Authority / issue

Verified P0442 `main` `32da2ec7547a77e07b6284d97366bb3f83412a48`, tree
`5d3b18f377df02db971a37dc048114eb76ca21a7`; D-042; L-011 PARTIAL.

## Forever observation (not inference)

WoW Forever `0.0.313-dev` session 106, Report Bug incidents
#11479, #11481, #11483, #11485 (2026-11-11), screenshots and
LOGRES_DIAGNOSTICS_LATEST.lua:

- First capture: attached `true`, attachments=1, combat attaches=1,
  detaches=0, failures=0, `owned-target-attached`.
- Second capture: visible `false`, attachments=1, detaches=1, failures=0,
  last reason `not-hostile`, removal result `unknown-attached-unit`.
- Third: attached `true`, attachments=2, combat attaches=2, detaches=1,
  failures=0, `owned-target-attached`.
- Fourth: visible `false`, attachments=2, detaches=2, failures=0,
  last reason `nameplate-removed`.
- Screenshots: native yellow nameplate/border/level and red Logres name/HP
  appear at the same location and overlap (VISUAL FAIL). No evidence that
  native cast indicators, protected clicks, all target switches, or unit
  aura states are safely replaced. A distinct unrelated green line is
  unowned/UNREPRODUCED and not changed by this patch.

## P0443 implementation hypothesis

The addon-owned frame follows the verified accessible event-time anchor.
Its original 198x54 fixture has no opaque background, so CENTER co-location
leaves native name/health/level visible through it. Build a narrowly bounded,
fully opaque 208x44 BACKGROUND texture directly on the addon-owned frame
**outside combat only**. The backing spans the name/HP region without moving
the health bar, cast cue, or any +/-25px aura lane. The existing noninteractive
frame remains mouse-disabled. No native frame, child, click region, CVar,
nameplate enumeration, or secret value is queried or mutated. Texture build
errors refuse the trial; OFF, detach, target change, and frame Hide remove
only this owned presentation and expose intact native controls. Screen-space
Logres target remains visible throughout.

The 208x44 geometry is a **testable visual hypothesis**, not a proved native
pixel measurement. It may obscure native cast/status or fail to cover all
native visuals. Test naturally with a red hostile in combat and do not claim
production suppression before native interaction/cast coverage is established.

## Pending Forever acceptance

Right-click Report Bug > H > World Enemy ON while OOC; engage a red hostile.
Verify exactly one readable name/HP presentation, live % updates, safe native
cast/status cues and clicks, 100% target size, native-on-OFF restoration and
no stale display after nameplate removal/target switch. World Enemy Status
shows `owned backing ready=true`; left-click Report Bug for screenshots and
addon-owned diagnostic fields. Secondary 50% remains disabled until confirmed
threat ownership. Any taint/Lua/protected failure is FAIL, not static PASS.
