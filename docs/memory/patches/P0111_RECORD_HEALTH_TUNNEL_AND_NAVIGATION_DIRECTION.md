# P0111 — Record Health-Tunnel and Navigation/Minimap Direction

Date: 2026-10-03
Result: **INSTALLED / PUSHED — DOCS-ONLY**
Commit: `bd0a9da3c7abc49ff527e8901bfd5c77846414a5`
Baseline: `51c6fbc33036468f4ec3ef2091ca6293a8c8ed97`
Runtime: `0.0.44-dev` unchanged

## Purpose

Synchronize durable repo memory with the accepted parallel visual/product work
completed after P0110, without changing Phase G runtime scope.

## D-036 — health tunnel

Record the approved player-health visual endpoint:
- continuous 100% -> 0% health progression;
- remaining health roughly corresponds to remaining clear/usable visual field;
- gentle easing at healthier ranges, increasingly direct collapse in critical
  ranges;
- near-death field becomes extremely narrow;
- charcoal/black + restrained cold burgundy, not generic red-screen damage;
- no hard circle, veins, blood splatter, gore, or conventional health meter;
- existing secret-safe native health transport remains mandatory.

## D-037 — navigation/minimap future endpoint

Record four semantic navigation roles:
1. manual waypoint;
2. quest destination;
3. local radius POI;
4. tracking.

Tracking is a separate fourth role using one generic Logres-styled repeated
tracker glyph regardless of category; it is not a literal stock yellow dot and
not a category-specific icon taxonomy.

Local POI and tracking source/position capability are explicitly **unproven** and
moved into a future capability investigation.

D-030 remains the current runtime boundary: the minimap stays stock until all
required information/control surfaces have deliberate proven replacements or
explicit product dispositions.

## Scope

Docs/memory only.

No Lua, addon metadata, runtime behavior, suppression, or WoW deployment changes.

Phase G remains active at G.5 camera-distance CVar ownership review.

## Validation

- `python3 tools/check_memory_health.py`
- `git diff --check`

## Deployment

No WoW redeploy required.
