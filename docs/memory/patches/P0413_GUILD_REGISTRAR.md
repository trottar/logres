# P0413 — Guild Registrar native-backed Logres service

Baseline: verified P0412 main `2032904`. Reuse MerchantCatalogue.lua, trainer PanelSurface and native service anchor/fade/restore helpers. No loaded new Lua file, no new preview registration, no change in guild charter transaction ownership. The existing P Merchant Catalogue fixture becomes a three-step merchant/registrar/closed cycle. Source-gated GuildRegistrarFrame visible stage is adapted to the Logres shell, native purchase/register/edit/cost/cancel remain Blizzard. Record addon-owned status in Report Bug and leave stock usable on unsupported shape or combat.

L-042 remains OPEN pending Forever. See `docs/memory/evidence/P0413_GUILD_REGISTRAR.md`, including P0411 R0/R1 failures and required regression tests. Full static suite and guarded WSL apply gate precede any deployment. Never infer runtime PASS from static checks.
