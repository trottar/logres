# P0211 — Native pet visibility on reload: observed failure and candidate

Date: 2026-10-14. P0210 verified pushed `4076d2502a02613a8767815d4911b0311e11e1bf`. User runtime: Forever build 70374, `0.0.120-dev`, diagnostic loadCount 278.

## Corrected observed result

P0210 incorrectly recorded Blizzard PetFrame and PetActionBar absent at initial Immersion-ON `/reload`. User explicitly corrects: **both Blizzard surfaces remain visible after reload — FAIL**. Immersion OFF then ON makes both disappear — **PASS in ordinary world view**. They stay hidden through observed combat — **user-confirmed combat visibility PASS, not full secure click/taint proof**. Entering Edit Mode displays the appropriate Blizzard stock pet surfaces — **user-confirmed stock display PASS**, but Edit Mode exit and interactions are not separately established.

The attached `LOGRES_DIAGNOSTICS_LATEST.lua` has saved `immersionEnabled=true`, loadCount 278. The latest `petbardriver check` reports requested=true armed=true nativeDriver=true activations=7 restores=6 failures=0 after an OFF/ON pair, not immediately after reload. No before-toggle driver check exists. Therefore **initial arming failure versus stock re-show after successful arming remains UNKNOWN**. Preserve original P0197 combat duplicate historical failure and P0206/P0209 negative experiments; do not infer their full closure from the new bounded visual result.

## Narrow hypothesis and candidate

During login, native pet availability and addon-owned secure action/pet-unit readiness can settle after the initial event-based reconcile. P0209 R8 already reconciles on PLAYER_ENTERING_WORLD, PET_BAR_UPDATE, PET_UI_UPDATE, UNIT_PET and PLAYER_REGEN_ENABLED, but has no edge notification when `PetActionExecutionProbe:Arm()` or `NativeSurfaceReplacement:PreparePetInteraction()` actually completes. Module order and event availability can differ at startup; a missed dependency edge may leave the stock secure drivers unarmed until an Immersion preference transition.

P0211 emits targeted readiness notifications only AFTER the Logres secure probe is armed or the addon-owned secure pet unit interaction is prepared; the trial receives them by direct `Reconcile`, reusing its existing fail-open readiness/combat/Edit Mode gates. It records first-world driver state/reason, first successful arm source and wakeup counts in `petbardriver check`. It does NOT poll, hook Blizzard show events, inspect stock visibility, forcibly Hide/Show, reparent or change the constant secure visibility driver. There is no runtime proof yet. If the first-world snapshot is armed but Blizzard frames still visible, the hypothesis is not confirmed and a DIFFERENT source/event race requires investigation; do not add periodic reassertion.

## Validation

Deploy exact `0.0.121-dev` candidate and `/reload` with pet present and saved Immersion ON. **Before toggling anything**, use Phase H Native Pet Bar Check or `/logres petbardriver check`. Visually record both stock surfaces. If visible despite armed=true, stop and preserve failure. If absent, exercise Immersion OFF/ON, natural combat, Edit Mode enter/exit, PET STOCK, Logres secure clicks and BugCatcher as practical. Only checks actually observed can be marked PASS; environmental blocks are DEFERRED. Run complete repository static checker suite and `git diff --check` before WoW testing. Do not commit or push on runtime failure.
