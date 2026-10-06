# P0152 R12 — Effective Pet-Binding State Presentation

Date: 2026-10-06
Status: **PREPARED — RUNTIME/VISUAL RETEST REQUIRED**

R11 panel evidence proved the overlay tracks all 46 shared buttons and the pet cluster
is default-on, but the first ten pet buttons expose no raw generic `type` / `action`
attribute. The presentation therefore never classified them as pet buttons even
though secure clicks work.

R12 leaves `PetActionExecutionProbe.lua`, execution routing, stock PetActionBar, and
the proven default-on arm path unchanged. `PetActionPresentation.lua` now resolves
the effective unmodified Left/Right click `type` and `action` using
`SecureButton_GetModifiedAttribute`, matching pinned Forever source. Every returned
value is secret-checked and type-checked before comparison or use.

For real-scale legibility, active command state keeps the amber border/pip and gains
a subtle additive amber icon wash. Enabled autocast keeps the orange outer border/pip
and gains a short orange lower rail. Unreadable state hides the added treatment
fail-open. Refresh remains event/attribute/click driven with no polling or timers.

The Phase H **Pet State Diagnostic** remains available and now reports raw
`type1/action1/type2/action2` plus the resolved binding button.

Validation after deploy/reload is panel-only: the pet cluster should already be
visible; Pet State Diagnostic should report `pet=10` and `readable=10`; the active
Defensive/Passive treatment must move with the selected mode; naturally enabled
Torment autocast must show the orange treatment; existing clicks and stock fallback
must remain usable; Pet Action Check and Run All must remain clean.

P0152 remains open until that runtime/visual gate passes.
