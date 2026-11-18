# P0479 — Compass presentation regression repair; L-031 / L-035

## Evidence and negative result (2026-11-17)

Verified GitHub `main` P0478 `71c12adcfa32bc7d781d129a1fb9be43345084ab`, tree `6b16f9edf8019b0999b755712f5ee9295058d2d3`. The uploaded `LOGRES_BUG_REPORT_LATEST.zip` (`BUG_REPORT.json` and exact screenshots) confirms source/capture/deployment `0.0.345-dev` parity, session160 incidents **#16561, #16563, #16565, #16567, #16569** at 23:45:22–23:45:46 EST. Screenshots show unsolicited approximate-distance tildes, "on map" and "floor unknown" phrases and a synthetic generic service-focus caption. Existing user instruction explicitly rejected tilde prefixes. User explicitly reports **P0478 VISUAL FAIL**: unacceptable presentation and no effective NPC accuracy repair.

In incident #16561 / #16563 focused service counters show 2/2 service glyphs and zero uncertain candidates. #16565 records one unverified close service. #16567 shows `focusedMarkerKind=service-map-only`, 3 unverified near services, fallback label shown, 0 verified center snaps. #16569 shows 3 unverified near services, 2 drawn service markers, 0 verified center snaps. These are state observations, not a claim that vertical floor or NPC location can be solved by 2D geometry. The previous P0476 false-floor 2yd claim and P0477 unverified near-service disappearance remain historical FAIL and are not overwritten.

## Correction

Remove P0478 `~` prefixes, "on map"/"floor unknown" phrases, arbitrary generic fallback caption, and extra unverified-marker alpha multiplier. Restore ordinary label style `NPC [role] - N yd` where the already sanctioned distance is available; when a provider NPC projects <4yd without live proximity proof, show only `NPC [role]` rather than asserting a true 3D yard measurement. Do not change quest/POI/waypoint focus label rules. A provider NPC retains its ordinary map bearing. Within <4 planar yards, retain the last ordinary world bearing keyed to the exact source NPC identity and current map, releasing when outside the window or when not observed on refresh. This avoids a rapid 180-degree map-angle flip but **does not infer a floor**, change the native interaction path, or pretend range to a visible NPC is proven. The existing verified-only <=3yd snap and <4yd hold remain unchanged.

Map-only diagnostics remain addon-owned; add `serviceNearBearingHeld`. Preserve L-002 native popup owner UNKNOWN. No new timer, native frame readback/suppression, protected mutation or secret-value inspection. Static checks and source-level Lua are not a WoW runtime PASS.

## Validation and limitation

P0479 candidate requires all repository contracts, source-level provider-label and near-bearing tests, guarded baseline/refusal/rollback audit, PREWRITE/POSTWRITE, ZIP byte parity and Git diff checks. Live check should verify typography/opacity first, then ordinary service marker continuity near the NPC and known multi-floor ambiguity; if no proof exists, it must not claim exact <4yd. L-035 remains OPEN until runtime evidence. If no candidate falls inside the compass focus cone, the focus caption may be blank; do not substitute an invented generic service/floor label. User preference is authoritative on presentation; future speculative styling must be approved rather than automatically introduced.

## Assistant candidate audit negative R0

Initial full suite **339/341 STATIC PASS**, with two refused historical checker contracts: `check_checker_version_policy.py` correctly prohibited P0479's new contract from hard-pinning `0.0.346-dev`, while P0338's older compass checker expected exactly three shared label helper references and rejected the new provider reuse. R1 removes the version pin and explicitly counts the additional provider invocation without weakening original preview/live label requirements. No code behavior changed in this test repair, and the R0 failure is preserved; full R1 audit and packaged installer still required.
