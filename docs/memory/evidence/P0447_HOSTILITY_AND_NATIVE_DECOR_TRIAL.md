# P0447 — Hostile eligibility and native-decor trial

Date: 2026-11-11; verified P0446 pushed GitHub main `4ad16a694f54cce96db2b72a59f500445b077a4d`, deployed Forever `0.0.316-dev` per user screenshot. L-011 PARTIAL / P0446 client FAIL.

## Observed failure and scope

The user reports selecting an attackable hostile and seeing no improvement. The screenshot shows `World Enemy ON: ARMED / ANCHOR DEFERRED (not-hostile)` but does not prove that a hostile target was selected at the precise status moment. The source nevertheless rejects selected targets whenever `UnitReaction` is not 1–3, even if they are attackable and in combat. Neutral combat targets can meet that condition, so the new path demands independent ordinary `UnitCanAttack=true`, `UnitIsFriend=false`, player and target `UnitAffectingCombat=true`, and no `friendly` reaction; missing/secret/error evidence defers. Strict hostile remains eligible without fallback. No secondary promotion.

P0446's screen-space handoff cannot remove Blizzard's overlapping overhead health and name. A selected-only opt-in native-decor alpha trial now targets *only* four known, separately drawable native regions after checking ordinary, unprotected capabilities. Captures their original alpha as opaque restore-only tokens; does not compare or log native alpha. Preserves native click unit frame, selection highlight, cast, aura, raid icon, CVar and target fallback. The Logres world frame is independently parented to UIParent and mouse-disabled, with its health/name/auras fully opaque, transparent background, +/-25px aura spacing. If a native field is missing/forbidden/protected or any alpha operation refuses, do not render an overlapping world copy; restore what was changed and keep stock and screen fallback. End-of-combat restoration is event-driven, not polling.

## Evidence and uncertainty

- P0442: two successful attachments and detachments, zero recorded failures, but native+Logres duplicate. P0443 opaque mask black-box VISUAL FAIL. P0444 session 108 black box GONE, one attach zero failures; native duplicate remains. P0446 user reports no change/failed hostile test and screenshot `not-hostile`; do not reclassify as PASS.
- First-party UI structure and field separation were researched using published Forever nameplate source leads and the ForeverPlusPlus API field inventory (prior P0445): `HealthBarsContainer`, `name`, optional `LevelFrame`/`PlayerLevelDiffFrame`, separate `CastBarsContainer` and `AurasFrame`. This is not confirmation that those regions are safely mutable in user build 70888. ForeverCombatText v0.10.1 reports nameplate taint/protected-region regressions from native modification. This is a trial only, subject to real-client proof.
- Important negative path: protection/alpha refusal, inability to restore, user click/cast/aura failure or taint means do not advance native owner. Stale region restoration must stay visible in diagnostics and retry only on event, not with polling. No production threat/aggro 50% rendering.

## Exact runtime gate

Deploy P0447 to Forever, `/reload`, Report Bug > H > World Enemy ON outside combat. Attack or select a naturally hostile enemy and an engaged attackable neutral; World Enemy Status must report eligibility, native owner/transfer/restore counts and failure reason. Confirm one fully opaque Logres name/HP/aura with no black backing and no duplicate native health/name only if native-decor claim succeeds; confirm click selection, target cast and native auras remain usable. Change target, clear, remove plate, World Enemy OFF, reload and verify original Blizzard presentation returns. Inspect Report Bug screenshot, diagnostics and Lua/taint logs. Any error is FAIL; unvisited case is DEFERRED. The 50% secondary remains disabled. Real-client PASS is NOT asserted in this document.

## Release-check refusal retained

P0447 R0 full author-check: **309/310 STATIC PASS, refused** by the checker runtime-version policy because the new P0447 checker embedded a literal development-version pin. No in-game result or release acceptance followed that refusal. The checker now compares the addon TOC and bootstrap versions without freezing a historical version; this correction must pass a fresh full author-check before release.
