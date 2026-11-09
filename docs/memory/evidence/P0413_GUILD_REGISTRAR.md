# P0413 — Native-backed Guild Registrar presentation (L-042)

## Baseline and incident

Verified GitHub main P0412 `2032904425cfe355e9d13a4bc2059e3e657df85a` (2026-11-09). Captured Forever 0.0.289-dev incidents 8160 and 8168 from November 8: Aldwin Laughlin first displays Logres gossip option "How do I form a guild?", then native GuildRegistrarFrame exposes "Purchase a Guild Charter" and "Register a Guild Charter" with a stock parchment window. This is a guild-services presentation discontinuity, not a demonstrated missing two-quest menu. L-001 remains OPEN.

## Previous negative attempts

P0411 R0 JSON SHA-256 `ab6f6dab649939b9cc33693f7701933618acef746b8d57c1395c9defc8739fe8` refused `chat_change.py review` on a non-LF-terminated before fragment. The format-only P0411 R1 reached full checks but four of 280 refused: pinned runtime version in its checker, issue ledger capped at L-041, and two merchant preview assumptions after the attempted registrar addition. No P0411 gameplay code was installed. P0412 fixed the exact-fragment authoring path, sequential issue ledger policy, and narrow merchant preview checker bounds. P0413 is a fresh candidate on P0412, not a repaired P0411 payload.

## Native source and safety hypothesis

Blizzard classic_era `GuildRegistrarFrame.xml` exposes GuildRegistrarFrame, GuildRegistrarGreetingFrame, GuildRegistrarPurchaseFrame, GuildRegistrarButton1/2, GuildRegistrarFrameGoodbyeButton, GuildRegistrarFrameCancelButton, GuildRegistrarFramePurchaseButton, GuildRegistrarFrameEditBox, GuildRegistrarMoneyFrame, GuildRegistrarPurchaseText, GuildRegistrarCostLabel, GuildAvailableServicesText, and GuildRegistrarFrameBg. WoW Forever's exact runtime shape is **not verified**. The handler must validate each named owner, ordinary layout capability and nonprotected frames before changing anything. It uses existing `NPCServicePresentation` anchor/fade/resize restorations, the trainer-style `PanelSurface` and palette, and the original native buttons, scripts and input fields. Blizzard retains charter costs, purchase, registration, restrictions, confirmation, and close scripts. No new native transaction API, polling, timers, protected input reparenting or camera changes. A refused capture stays stock and records `registrar-*` reason; mutation rollback and combat deferred restoration are bounded.

## Preview and regression scope

D-046 uses the same guildPaint renderer for synthetic and live backing. The existing P merchant/service preview control cycles merchant -> guild registrar -> off, preserving the 40 registered preview actions, merchant's three preview handlers, 122 overall panel actions and 96 addon Lua entries. Synthetic preview never buys or registers a charter. P0413 changes only merchant/service Lua, panel diagnostic, preview command label, version metadata, and durable records.

## Required verification (not yet observed)

1. WSL `review` and full shadow `check` must pass before `apply --allow-runtime`. Exact staged content is verified before commit.
2. In WoW Forever Immersion ON open `/logres panel`, P, **Merchant / Registrar Preview**; first click merchant, second guild registrar, third close. Verify both retain the shared visual language.
3. Visit Aldwin Laughlin, select **How do I form a guild?**, confirm guild screen displays centered within Logres while **Purchase a Guild Charter** and **Register a Guild Charter** remain clickable. Open the purchase subpage without buying; check original cost, name edit and Cancel. The registrar may fail open if client shape differs; Report Bug incident then records the bounded reason.
4. Close, reopen, switch Immersion OFF, /reload, and ensure native controls, Blizzard restoration, and other merchant/quest interactions work. No Lua/taint/secret/protected errors. Capture Report Bug before exiting the registrar when it fails. Use `python3 tools/export_panel_diagnostics.py` after exit/reload.

**Disposition:** L-042 OPEN; P0413 candidate STATIC checks require WSL and real client validation. No claim of runtime PASS, transaction PASS, or resolved release gate.
