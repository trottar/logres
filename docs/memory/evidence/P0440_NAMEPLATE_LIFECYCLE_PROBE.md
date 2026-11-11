# P0440 — Event-time nameplate lifecycle and player-targeting probe

Date: 2026-11-10. Baseline: P0439 main `572c55826f86c2183b94497bb52cea5ee547474a`, verified tree `9b8f13883aa33b7929a104f24175c44cac4e7718`.

## Source and live evidence

- P0432 Forever: accessible current-target Blizzard nameplate in combat; hidden attachment deferred by combat lockdown. This was **not** attachment proof.
- P0439 Forever incidents 11003/11082: World Trial ON/Status/OFF reached through the right-click Report Bug panel; `no-accessible-nameplate`, zero successful OOC attachments and zero failures; screen-space fallback retained. Incident 11082 selected an attackable but **neutral** Young Wolf.
- ElvUI/oUF implementation research: `NAME_PLATE_UNIT_ADDED`, `NAME_PLATE_UNIT_REMOVED`, target-change unit-token callbacks. Architectural inspiration only; no ElvUI implementation copied (custom license). The bundled oUF MIT license does not change Logres ownership policy.

## P0440 hypothesis and implementation

A nameplate unit token delivered **at the event** may expose an accessible anchor in combat despite the target-only/OOC snapshot failing. Probe event-time unit identity only after `issecretvalue` screening, using `C_NamePlate.GetNamePlateForUnit(unit, false)` and guarded `IsForbidden`/behind-camera sources. Never retain unit strings, frames or GUIDs. A second read-only callback handles UNIT_TARGET/FLAGS/THREAT_LIST_UPDATE when registered on Forever. Counters/latches distinguish selected versus secondary ordinary accessible anchors and neutral/friendly/hostile reaction; the strict combat hostile targeting-player observation additionally requires attackability, unit combat and player lockdown. It is NOT an authorized aggro/threat detector; no 50% renderer uses it.

Expose *Nameplate Lifecycle* in Report Bug > H's view-local controls, preserving the historical 122 registered actions. Capture sanitized `snapshot.nameplateLifecycle` via left-click Report Bug. Original World Trial, current-target capture, native interaction, auras, preference default OFF, screen-space fallback, and all nameplate settings remain untouched.

## Safety and deferred proof

No native nameplate mutation, `SetPoint` in combat, CVar changes, broad enumeration, polling or production nameplate takeover. Safe event-time **reading** does not prove permitted **attachment**. Target-of-enemy is not reliable threat/aggro until separately validated in Forever. Actual combat/OOC nameplate event deliveries, secret values, secondary anchors and all live aggro gain/loss remain UNVERIFIED. A failure or zero count is environmental evidence, not a production PASS.

## Forever smallest validation

Deploy P0440 to `_forever_`, `/reload`, keep ordinary nameplate settings; fight two nearby enemies naturally with one targeted and one attacking the player; after combat, right-click Report Bug -> H -> Nameplate Lifecycle, then left-click Report Bug; `/reload` and `python3 tools/export_panel_diagnostics.py`. Send the exported ZIP and Lua; assess separate positive target/secondary anchor and combat player-targeting counters. If no secondary nameplate exists, preserve deferral; do not force nameplate visibility to manufacture it.
