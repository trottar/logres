# P0215 — Approved sheet-02 and sheet-10 production asset fidelity

Date: 2026-10-16. P0214 remotely verified at `1ae5948` on main and user visually accepted the shared action artwork and observed button press feedback. The provided screenshot shows the shared 2x6 bar family visually consistent across action roles. Latest diagnostics `0.0.123-dev` loadCount 282 finished Run All with Action Check PASS, Layout Check PASS, 17 intended surface PASS / 18 deliberate STOCK / 0 FAIL. Those are observed-scope results, not proof of every combat/quest/hover state.

## Visual authority and candidate scope

Approved source: `docs/design/approved/02_resource_bar_primitive.png` (resource/normal and compact bars), `10_active_quest_component.png` (aged quest-focus parchment), and D-039/D-040. Both canonical PNGs remain unchanged. This is a derived media candidate, not pixel-perfect screenshot-to-texture extraction.

P0215 replaces five common media files: `Bar/percentage_fill.tga` and `Bar/percentage_diamond.tga` for resource, enemy target, pet/ally compact rows and quest objective progress; and `Quest/active_quest_panel.tga`, `active_quest_divider.tga`, `active_quest_glyph.tga` for the optional one-focus narrative panel. The neutral status fill preserves WoW native SetStatusBarColor tint; the diamond is transparent outside its bronze bezel; quest art omits all example text/progress. The parchment retains authored aged brass edge treatment, with programmatically derived neutral material in the field. Existing font and progress live data remain addon/client owned.

**No gameplay code, Theme geometry, UI positioning, native fallback, secure pet/action routing, aura membership, health tunnel, quest control, active quest toggle, preview-state semantics or visible percentage policy is modified.** The viewport v4 map and all runtime anchors remain intact. Visual fit will be tested using existing developer-panel previews and normal gameplay; no invented quest content is authorized.

## Runtime validation: pending

After deploying and `/reload`, use Phase 0 Run All, Phase H Layout Check/H.2 Map Overlay OFF/ON, and the developer-panel active quest normal/complete previews plus HUD resource/target preview if exposed. Inspect the character resource bar, one pet/ally or enemy percentage bar, and Active Quest parchment. Verify no textures fail to load, color families and `%` stay readable, quest text remains unobscured, border corners do not repeat at variable panel height, and interaction/click areas stay unchanged. Unavailable pet/target/quest natural states are DEFERRED, not PASS. Any visual clash, clipping, invisible value or Lua/taint/protected error is FAIL and requires a corrective patch. The attached offline preview is only a static candidate and does not demonstrate in-game rendering.

P0214 accepted observed button art remains untouched; future whole-screen action density/placement refinement may occur only when v4 geometry and real click coverage support it. Remaining approved domains (target typography, aura framing, compass lane/detail, dock, cast cues, NPC dialogue, context flashes and health tunnel) retain their previous implementation/fallback status and should be checked as a coordinated whole-screen composition, not redesigned without evidence.

## P0215 R0 PREWRITE DELIVERY FAILURE; R1 correction (2026-10-16)

The user verified R0 ZIP SHA `aa289e4096f5cd84536a0c357a21725730ea28d85e4c3f38da5906f3cf7ef8e2` and invoked `P0215_APPLY.py` on the P0214 worktree. The applier **FAILED before tracked writes** during shadow `check_memory_health.py`: mandatory CURRENT headings `## Success Criteria`, `## Do Not Reopen Without New Evidence`, and `## Relevant References` each occurred zero times. The generated CURRENT had `## Remaining H.3 Work` and `## References` in their place. The user's resulting `git status --short` contained only `?? P0214_PREVIEW.png` and `?? P0215_VISUAL_ASSET_PREVIEW.png`; no tracked changes were reported. No WoW test of P0215 occurred.

R1 changes **only the patch delivery script and proposed repository documentation**: restores all seven canonical CURRENT headings, includes this negative evidence in memory, and validates CURRENT headings before executing the whole shadow checker suite. R1 carries byte-identical five TGA payloads, source behavior, and 0.0.124-dev version bump as R0. No new protected API, geometry, or control mutation. R0 negative evidence remains OPEN as a delivery failure / CLOSED by R1 only once the applier successfully completes; WoW visual results remain pending.
