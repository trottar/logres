# D-045 — Phase H.2 approved screen-map v4 geometry

Status: **ACCEPTED — DESIGN ONLY; RUNTIME TRANSLATION PENDING**
Date: 2026-10-11

## Decision

Adopt the user-authored thirteen-rectangle v4 full-screen percent layout as the approved **default composition geometry target** for Phase H.2. Canonical literals are `docs/design/layout/SCREEN_MAP_V4.json`; coordinate convention, table, relationships, and limitations are in `docs/design/layout/SCREEN_MAP_V4.md`.

The user explicitly approved adjusting Main Bar Y from 60.3 to **60.4** to match Secondary. Target and aura boxes remain right-of-center with matched Y=40.0, matched H=9, symmetric horizontal gaps=0.8. Player Debuffs stay immediately above Player Resource at the bottom center; class/totem controls stay above the **left action groups**, not above bottom-center resources. Action clusters are 12% x 38% planning envelopes, not button aspect ratios.

## Precedence and boundaries

- This acceptance refines the *pixel/percent design intentions* of D-032 and `WORLD_FIRST_LAYOUT.md` for the default screen-space composition. It does **not** supersede D-032's world-first doctrine, sparse target policy, optional Active Quest, action-role semantics or future world-anchored target endpoint.
- This is a design map, not a user-facing drag-anything editor and not an in-game preview, collision PASS, WoW anchor spec, native fallback replacement authorization, or permission for combat-time protected mutation.
- Conventional player health/exact HP remain absent; player resource is a distinct percentage presentation. Class/totem/party/pet, supported extra bars and special-mode fallback maintain their independent source/secure/control gates.
- Translation to actual `Integration/Layout.lua` requires mapping current frame sizes/anchors, cross-surface collision assessment and a bounded runtime patch with in-client validation. Retain all deliberate Blizzard fallbacks until separately capability-proven.

## Design error preserved

Prior generated mockups and mapping attempts incorrectly placed Player Resource/Debuffs on the left and treated target awareness as the literal screen center, contradicting the user's drawing. These readings were corrected through interactive map iterations; the accepted JSON, not those mockups, governs the next placement pass.

## Next

Complete P0191 docs-only baseline publication. P0192 is the first candidate **runtime translation/audit** checkpoint after user push verification, not a claim that the accepted screen layout has already been implemented.
