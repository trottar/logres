# P0195 evidence — P0194 R3 in-game H.2 viewport map

Date: 2026-10-11. P0194 R3 is verified pushed to `main` at `f7a67bc349a848586746b20bad99129a55a7bc93` (`feat: integrate H2 screen map into developer panel`). User explicitly confirmed the panel additions worked and supplied full-screen screenshot plus `LOGRES_DIAGNOSTICS_LATEST.lua` (`0.0.103-dev`, loadCount 245).

Observed in screenshot: all thirteen blue approved D-045 rectangles and current gold addon-owned frame footprints appear, with old action clusters lower-center, the old resource above them and native-access dock overlapping the upper-right Quest planning territory. Gold outlines are Logres proxy geometry, NOT Blizzard protected-state inspection. Native-access dock, Bar4/5 and anonymous native HARMFUL containers are not part of the thirteen gold rows. Observed screenshot is for the OLD source layout, not evidence that the approved v4 regions have already been applied.

Latest diagnostic (`checkall`, same loadCount): `Logres layoutcheck: PASS (anchors=16 binds=23 failures=0 missing=0 mismatched=0 error=nil)`. H2 `measured=13/13 missing=0 deferred=0 reason=read-only-addon-geometry`; still `layout unchanged`. Run All completed with existing checks PASS in observed ordinary world scope; native HARMFUL reported `ready=true active=true` without reading its restricted members; normal Main CANDIDATE remains observed. This does **not** prove placement, collision-free action regions, secure click target movement or special-state correctness.

P0194 negative history retained: R0 player-only visual positioning rejected; running artifact root cause unconfirmed. R1 checker/source mismatch failed before write. R2 slash-only workflow rejected by user. R3 accepted as developer-panel UX only.

**Next:** one coordinated P0195 runtime placement; require fresh screenshot with overlays, Phase H Layout Check, Phase 0 Run All, native dock usability, Primary/Secondary/Utility and optional Bar4/5 click/shortcut checks. Any Lua, taint, protected-action or secret-value error is a FAIL, not PASS. Special vehicle/override/possess/form/petbattle remain environmentally deferred unless naturally observed.
