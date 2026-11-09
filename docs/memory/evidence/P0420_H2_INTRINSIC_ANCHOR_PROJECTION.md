# P0420 — H.2 semantic-anchor projection after observed P0419 mismatch

Baseline: GitHub `main` P0419 `c1e23fc264e413aaf00522e65c265454be1d1d01`, verified 2026-11-09.
Client evidence: user-uploaded 1536×960 H.2 overlay screenshot after P0419 and report
"They are still pretty far off for some elements." The left-side five action bars
and pet action button outlines are now closely aligned, confirming P0419's narrow
visual aim. Other blue rectangles differ greatly in width/height from gold.

## Narrow finding

The live compass's TOP center, active-quest TOPRIGHT, quest dialogue TOP center,
party frame CENTER, player resource CENTER, and helpful-aura LEFT placements
largely match the intended approved anchors in the screenshot. Their blue
rectangles still use arbitrary whole-screen authoring widths/heights. For
example, the quest dialogue's actual gold rectangle is wider than its blue
plan, but the TOP center is aligned. Shrinking the live dialogue to fit the
original editor envelope would also require retesting text/reward interactions;
no evidence presently warrants that gameplay redesign.

## P0420 change

- Preserve approved `SCREEN_MAP_V5.json` verbatim, and preserve every runtime
  anchor, role, action slot, keybind, secure driver and fail-open behavior.
- For the 13 non-action regions in the 19-region H.2 overlay, derive the blue
  footprint from the current addon-owned frame's **intrinsic size**, positioned
  at its approved runtime anchor with the binding's actual alignment (`TOP`,
  `TOPRIGHT`, `LEFT`, or `CENTER`). P0419's six action grid computations remain
  unchanged.
- Read only the same allowlisted Logres-owned frame geometry as P0192, through
  the existing `readAddonRect` secret-first guard. Do not query during combat.
  If unavailable, retain the historical design envelope and label `[design]`;
  never make gameplay changes to force a visually matching outline.
- The blue/gold comparison is now explicitly **expected position vs actual
  frame**, not **design envelope vs actual frame**. Existing design-envelope
  sizes remain in the approved map and appear separately as `design-size-delta`
  in the read-only H.2 developer diagnostic.
- Record `position-offset=(dx,dy)` in UIParent logical units separately from
  `design-size-delta=(dw,dh)` for each measured owned frame. This distinguishes
  genuine anchor drift from intrinsic size differences and provides an exact
  next action when a nonzero offset is reproduced.

## Acceptance boundary

Static contracts and isolated guarded source check are author-side only.
In WoW Forever: `/reload`, `/logres h2map on`, inspect blue/gold outlines at
stable UI scale, run `/logres layoutcheck` for explicit position deltas, turn
overlay off. Any nonzero drift should be investigated by its binding and actual
frame geometry rather than offset blindly. Natural combat and secure state
remain separate acceptance checks; no new pet failure is claimed here.
