# P0194 R3 — H.2 screen map inside existing developer panel

Date: 2026-10-11. Baseline: verified `main` `213c526` (P0193 R2, `0.0.102-dev`). Candidate runtime: `0.0.103-dev`. **PREPARED / WoW VALIDATION OPEN**, not pushed.

## User correction and design

P0194 R0 visual layout attempt did not put resource/debuff where planned in the supplied screenshot; its specific running Lua artifact/root cause was not proven. User rejected a series of single-element moves and requested a unified in-game map, followed by one coordinated positioning pass. P0194 R1 failed prewrite contract/source mismatch (checker demanded `viewport.width` while the Lua uses `viewportWidth`); R2 corrected that contract but offered only `/logres h2map on|off`. User correctly rejected the slash-only interaction and requested the map as a developer-panel view. The **Phase H developer panel has fifteen actions**, at the established 3×5 limit. Do not delete existing actions just to make space.

## R3 implementation

- Add a **H.2 Map** button to the Phase H heading of the *existing* Logres developer panel. No phase action is removed or remapped. The button opens a dedicated view in the panel; "Back to H" restores the standard Phase H action grid and diagnostics.
- The panel view draws all **13 approved v4 planning boxes** blue over a 16:9 viewport miniature, with secret-safe measured **13 named Logres proxy** bounds in gold, plus a 10% grid and a read-only measurement status. It does **not** move or resize any gameplay control.
- Controls: **Overlay ON**, **Overlay OFF**, **Refresh Map**, **Layout Check**. Layout Check uses the existing panel diagnostics/saved output; its complete text is readable on return to the normal diagnostics view. The full-screen map remains mouse-transparent and opt-in; closing the panel leaves the overlay active so a screenshot can be taken.
- Combat/restricted measurement: planned boxes remain available; actual boxes are withheld/deferred rather than inspecting secret-capable data. Layout.SetH2MapVisible(true) still rejects combat. No Blizzard presentation reads, action routing changes, native aura inspection, stock suppression, timer/polling, action-bar reflow or anchor reposition.
- Keep `/logres h2map on|off` as a compatible diagnostic shortcut, **not** the primary workflow.
- Candidate accepts exactly one of: clean P0193 working tree, uncommitted original P0194 R0 change set, or uncommitted P0194 R2 change set. Prewrite candidate is built from immutable HEAD, compared against strictly checked local variants, and all `tools/check_*.py` run on shadow source before tracked writes. Unknown dirty/staged files in the owned set cause refusal; unrelated untracked files remain untouched.

## Required runtime validation

After successful apply and deploy, `/reload`, open Logres developer panel, select **Phase H**, then **H.2 Map**. Confirm all 13 blue regions, actual gold outlines or explicitly deferred actual state, and test **Overlay ON**, **Overlay OFF**, **Refresh Map**, **Layout Check**, **Back to H**. Capture an **uncropped screenshot with Overlay ON and panel closed**, then return to Phase H Layout Check and **Phase 0 Run All**. Check no Lua/taint/protected/secret errors and all existing 15 Phase H actions are still available. Export `LOGRES_DIAGNOSTICS_LATEST.lua`. Runtime PASS and actual geometry placement are not claimed in this document.

## Next

After a verified push and runtime map/screenshot acceptance, implement **one coordinated percent-based whole-screen layout/reflow** using D-045. Treat target aura physical widths, native harmful containers, dynamic Quest/native dock, Bar 4–5, pet/class, party and special modes as capability-gated fail-open constraints. Do not call the design rectangles exact UI widget dimensions or mark H.2 visually accepted from static results.
