# P0219 — Compass sheet-12 gaps: approved glyphs and capability policy

Baseline: Verified P0218 `157e09cbdd8b21f3284e4ad3896f31a9f0cf647e`; runtime proposal `0.0.128-dev`. Status P0218 loadCount 288 and developer-panel art preview evidence do not imply a live POI/quest/tracking marker capability.

## Corrected gap assessment

Earlier assistant replies incorrectly advanced quest work and called compass nearly complete. Current `Navigation/Compass.lua` implements only heading + manual waypoint; P0213 changed label colors/shadows, no additional capability. Sheet 12 requires two major destination roles, on-tape local POI, below-tape tracking, separate silhouettes, center-focus identity, text fade, depth scaling and collision. Actual production has five texture assets and lacks quest pennon, POI roundel, tracking pip. Preserve accepted role and focus policy D-037/D-038/D-039.

## Source evidence

P0142 pinned Forever source and P0143 runtime evidence verified player/map geometry and tracking-selection metadata; there was no positive positioned quest destination/current map AreaPOI in observed scope; no API to enumerate individual tracking detections. `Logres/Navigation/NavigationSourceProbe.lua` already reads surviving candidate APIs; use its Phase H panel action for fresh results. Do not branch on secret-capable values, borrow Blizzard protected UI fields, manufacture position/identity/distance, or hide stock minimap. A visual renderer is not source authorization.

## P0219 narrow implementation

Three new Theme-owned RGBA TGA glyphs are directly traced from the accepted sheet-12 silhouette/material roles: quest pennon, octagonal bronze/bone local-POI seal, tiny muted-amber tracking pip. A gated developer-panel art preview uses *static explicitly preview-only local offsets* respecting the major-above/POI-on/tracking-below tape lane doctrine. The existing manually sourced waypoint and heading pipeline is unchanged; preview never routes generated positions into live navigation. No real quest, POI, or tracking role is displayed by this patch. Preview is automatically hidden when policy becomes ineligible and after preview OFF.

## Validation and next step

ZIP/Python/static candidate checks run by guarded applier, then user `/reload` and developer panel Compass Art ON/OFF, Compass Check, Phase H Navigation Source Probe, Layout, Phase 0 Run All. Compare visible test glyphs with approved sheet and check no lingering preview. Missing natural positioned sources remain **DEFERRED**; subsequent source-to-marker integration is a separate capability checkpoint requiring new positive ordinary source runtime evidence. No WoW runtime result is claimed here.

## Failure history

P0218 R0 rejected before writing tracked files for missing CURRENT_HANDOFF reference; R1 fixed and was pushed. Earlier premature treatment of compass as complete is a planning failure and corrected here. Historical navigation negative results P0142-P0149 remain authoritative until new evidence supersedes them.
