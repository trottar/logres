# P0152 R6B Runtime Execution / Range / Layout Failure — 2026-10-05

Status: PRESERVED — CORRECTED BY P0152 R7 CANDIDATE

## Observed runtime result

R6B reached WoW without the earlier Lua load-order or protected-action popup. The shared pet presentation now mapped the correct pet actions/icons in stock slot order.

Three failures remained:
1. left/right secure `type="click"` delegation to Blizzard `PetActionBar.actionButtons[slot]` was inert; hardware clicks produced no pet action/autocast change;
2. every populated pet icon rendered red because the pet adapter treated ordinary `inRange=false` as sufficient for range failure without first requiring `checksRange=true`;
3. the ten-wide pet row still intruded into the established central player-action region.

## Classification

**REAL RUNTIME ADAPTER FAILURE.**

The correct slot/icon mapping and reuse of `Logres.ActionButton` are accepted. Secure click delegation, ungated range tint, and the central ten-wide layout are rejected. Stock PetActionBar remained the functional fallback.

## R7 hypothesis / correction

Forever source still explicitly provides `SECURE_ACTIONS.pet`. R5's direct pet test also installed an insecure `PreClick` hook immediately before protected execution. R7 therefore retries the secure pet action with that pre-execution addon hook removed: baseline state is captured at ARM, left click is `type1="pet"` / `action1=slot`, and only PostClick records evidence afterward.

Autocast remains the only distinct pet-control behavior: right click is a secure macro `/petautocasttoggle <ordinary pet spell name>` configured out of combat only for autocast-capable slots.

Range tint now requires `checksRange=true`; otherwise the icon uses ordinary usability/normal tint. Layout moves to a five-by-two lower-left class/pet cluster anchored below the existing ally/pet condition stack per D-032.
