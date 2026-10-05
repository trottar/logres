# P0144 — P0143 Navigation-Source Runtime PASS with Deferrals

Date: 2026-10-05
Runtime commit: `b9b2f90b37ad9d10b4ce6d55ef932e113172d3b3`
Runtime: `0.0.69-dev`
Classification: **PASS FOR OBSERVED READ-ONLY SOURCE SCOPE; DESTINATION / AREA-POI PATHS ENVIRONMENTALLY DEFERRED**

## Purpose

Record the actual P0143 in-client result without converting environmental absence
into capability proof and without reopening P0142/D-043 source-blocked tracking
positions.

Source:
user-provided `LOGRES_DIAGNOSTICS_LATEST.lua` after P0143 deployment and validation.

## Runtime identity

The recorded status run reports:
- Logres `0.0.69-dev`;
- client `1.60.1` / build `70205`;
- interface `16001`;
- load count `159`.

## Navigation Source Probe result

The manual `navigationsourceprobe` run reports **PASS**.

Observed probe summary:
- captures: `6`;
- manual captures: `1`;
- current map ID: `1432`;
- player position available: `true`;
- map world size available: `true`;
- minimap view radius: approximately `133.33` yards;
- tracking selectors: `23/23` scanned;
- active tracking selectors: `4`;
- current-map AreaPOI rows: `0`;
- positioned AreaPOIs: `0`;
- super-tracking anything: `false`;
- super-tracked quest: `false`;
- user waypoint: `false`;
- current navigation waypoint: `false`;
- quest waypoint: `false/false`;
- secret skips: `0`;
- failures: `0`.

Ordinary geometry values recorded:
- player normalized position: approximately `0.35,0.50`;
- map world size: approximately `2758.33 x 1839.58` yards;
- minimap view radius: approximately `133.33` yards.

`C_Minimap.GetUiMapID()` returned no value in the captured state. The probe did not
treat that absence as a failure and no production path depends on it.

## Tracking selector evidence

All 23 selector rows were readable. Four independent selectors were active:
1. Flight Master;
2. Innkeeper;
3. Account Completed Quests;
4. Track Quest POIs.

This is runtime evidence that the current client exposes ordinary multi-select
tracking metadata/state.

It is **not** evidence for individual detected tracking-result positions. P0142 /
D-043 remains authoritative: no supported public per-result coordinate enumerator
was found, and service tracking categories do not imply service-instance
coordinates.

## Environmental deferrals

The tested current map returned no `C_AreaPoiInfo` rows.

The captured state also had:
- no active super-tracking path;
- no current `C_Navigation` waypoint;
- no super-tracked quest waypoint;
- no user waypoint.

Therefore:
- current-map AreaPOI usefulness remains DEFERRED;
- broader current-navigation output remains DEFERRED;
- ordinary quest waypoint output remains DEFERRED beyond earlier negative samples;
- the probe's destination-distance arithmetic branch was not exercised.

These are not failures.

## Integrated regression result

The immediately following `Run All` completed with PASS for every included check.
The runtime remained `0.0.69-dev`.

No Lua, secret, taint, protected-action, or diagnostic failure was recorded in the
P0143 validation scope.

## Capability consequence

P0143 advances only these facts:
- current-map/player normalized geometry is ordinary in the observed runtime;
- map world size is ordinary and available in yards;
- minimap view radius is ordinary and available in yards;
- tracking selector metadata/state is ordinary and multi-select.

P0143 does not authorize:
- AreaPOI production markers;
- quest/current-navigation production markers;
- individual tracking-result markers;
- town/service-instance markers;
- minimap suppression.

## Next

The next narrow justified production-capability slice is:
**P0145 — manual-waypoint comparable-distance / bounded-depth integration.**

The existing P0123 manual waypoint position/bearing path is already proven.
P0145 may combine that source with the now-proven current-map/player/world-size
inputs, but must fail open to the current fixed marker treatment when comparable
distance is unavailable.

In-client P0145 proof must place a normal manual user waypoint so the actual
distance branch is exercised before the depth treatment is accepted.
