# P0217 — Approved dock, target and ally artwork evidence

Date 2026-10-16. Verified baseline P0216 `905c847` / `0.0.125-dev`. **Status: CODE/ART CANDIDATE — WoW UNVERIFIED**.

## Observed problem and user direction

User accepted P0216 (black backing absent, 268px resource presentation, ready/complete parchment distinction), but explicitly corrected the assertion that H.3 was nearly done: many unimplemented approved appearances remain. In the submitted screenshots, six native-access controls are rectangular black text tabs and PET STOCK/BUFFS/TARGET remain visually prominent generic red Blizzard-style buttons; target and pet health labels are comparatively bare. D-039 sheet 01 directs meaning-heavy bronze and parchment but restrained repeat controls; sheet 03 provides the approved common button silhouette; sheet 06 defines sparse enemy/pet/ally name and percent bars. The D-045 screen-map geometry and stock-native fallback policy are already proven and MUST NOT shift.

## Narrow source hypothesis

- `NativeAccess.OnInitialize` creates six addon-owned 24px text buttons with colored rectangular backgrounds and one-pixel rules. Reuse small horizontal controls derived from **shipped P0214 sheet-03 action_frame.tga**, rather than inventing an unrelated style. Preserve color/tint fallback if TGA is missing.
- `NativeSurfaceReplacement.OnInitialize` creates three 110x23 `UIPanelButtonTemplate` objects with inherited red Blizzard art. Switch only these addon-owned manual fallback **presentations** to ordinary 110x23 Button text/bronze-frame, preserving `button:SetText(...)`, their existing click callbacks and the native ownership/stock restoration policy. Native actual Blizzard controls are not changed.
- `HUD.OnInitialize` renders a sparse target name/normal bar and small `UnitName`/compact percent rows. Add short Theme-driven hairline accents and a pet-specific label tint using only fixed addon-owned unit tokens. Never read/combine/inspect secret `UnitName`, `UnitHealthPercent`, reaction or classification values for an ornament.

## Expected work / restrictions

Two RGBA production TGA assets `Media/Dock/dock_tab.tga` and `dock_fallback.tga` are nine-slice derivatives of the **existing approved P0214 production action frame**, with deliberately restrained center fill. They are indexed by Theme; original sheet PNGs and P0214 art remain unchanged. The candidate makes no placement or secure hitbox change; 6x dock 24px buttons and 3x fallback 110x23 dimensions remain identical. The enemy 198x54 and 190px name fit, compact 184x20 ally rows and bar widths remain identical. No new timers, polling, native Show/Hide, stock mutation, Lua processing of secret values, or API-dependent new role displays.

## Test gate

1. Full shadow static suite, checker-version and memory-health checks, `git diff --check` and manifest after guarded apply.
2. Mandatory deployment, `/reload`, developer panel Phase H Native Access Check / H.2 Map / Layout Check, Phase B HUD Check, Phase C Action Check and Phase 0 Run All.
3. In ordinary world, click STOCK, MAP, QUESTS, XP, MENU, CAST as appropriate and PET STOCK, BUFFS, TARGET; verify native control returns, labels remain readable (including OPEN suffix), button hover/press and stock failsafe. Immersion OFF and ON must still restore/hide correctly. Check enemy + pet labels and compact bars; group rows deferred if no group naturally available.
4. Any Lua/protected/taint error or click loss is FAIL; do not commit before corrective patch. Unobserved interaction is DEFERRED, not PASS.

## Negative history retained

P0215 R0 shadow checker caught missing CURRENT headings before tracked writes; no recurrence may be declared PASS without testing. Historical P0209 and P0206 pet activation failures are preserved although tested P0211 presentation recovery was accepted. P0200 native aura secret/secure scope remains unchanged. This record is only a candidate baseline, not full H.3 completion.
