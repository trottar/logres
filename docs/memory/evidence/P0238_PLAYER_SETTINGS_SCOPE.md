# P0238 — First player-facing settings access

Date: 2026-10-17. Authoritative GitHub `main` P0237 R1 `bb1f772` verified.

## Scope and source finding

The Phase H approved visual inventory identifies settings/accessibility presentation as unfinished. `Core/Preferences.lua` presently publishes precisely two user choices: `immersionEnabled` and `activeQuestEnabled`; `Core/Database.lua` persists both. The developer panel and `/logres` commands already change these preferences, but there is no dedicated player-facing settings surface. The design baseline has **no final settings sheet**. Therefore the narrow first slice is a compact, deliberately plain panel for these two *existing* choices only, accessed via `/logres settings` or Phase D developer-panel **Settings UI**. It is not an arbitrary UI editor or a claim that accessibility configuration is complete.

The new panel delegates to `Logres:GetPreference` and `Logres:SetPreference` and subscribes to existing changes. It creates no new SavedVariables keys, no new protected mutation, no polling, no direct Blizzard suppression, and no source inspection. The existing Immersion controller owns its native restore/fail-open logic. No action grid reassignment, POI filter toggles, or unsupported camera/quest options are exposed.

## Acceptance gate — RUNTIME UNVERIFIED

After guarded apply and deploy, `/reload`; open `/logres panel` -> **D — Immersion Controller** -> **Settings UI** or `/logres settings`. Confirm both buttons match `/logres immersion status` and `/logres activequest` state. Toggle Active Quest OFF -> ON and Immersion OFF -> ON, verifying screen restoration and access to stock UI. Check panel open-close-open, show state after command changes, and Phase 0 **Preference Check**. Do not classify static source or a developer check alone as visual PASS; inspect any Lua/protected/taint errors. Save final choices as desired.

## Known limits / deferrals

The final settings art, accessibility options, POI category filters, action-source configuration and broad user customization remain OPEN. Combat transitions are not claimed proven by this UI. No new native interaction is replaced and the P0236 compass remains unchanged. P0237 R0 manifest EOF pre-write failure and its R1 repair remain historical evidence, not a runtime failure.
