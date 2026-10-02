---
memory_schema: 1
as_of: 2026-10-01
project: logres
---

# Current State

## Active Objective

**Phase E — Compass and Navigation.**

## Current Work Item

**E.3 — Waypoint-bearing capability/proof.**

E.1 and E.2 are complete.

P0070 is verified pushed at `f99afa9b`.

P0071 prepares developer-panel diagnostic auto-capture.

Production runtime target:
`0.0.29-dev`.

## Verified State

- Phase 0 complete.
- Phase A complete.
- Phase B complete.
- Phase C complete.
- Phase D complete.
- D.1–D.6 complete.
- P0065 pushed at `46271f97`; Phase D closed and Phase E opened.
- P0066 pushed at `586d188d`; D-029 accepted.
- P0067 pushed at `931f068e`; E.2 runtime passed.
- P0068 pushed at `740ebe15`; E.2 closed / E.3 opened.
- P0069 pushed at `9e637d5a`; waypoint capability probe added.
- P0070 pushed at `f99afa9b`; Waypoint Probe integrated into developer panel.
- User runtime evidence proves developer-panel waypoint snapshots are being
  captured.
- Observed registered/firing navigation events include:
  - `USER_WAYPOINT_UPDATED`;
  - `SUPER_TRACKING_CHANGED`.
- Existing P0069 structured SavedVariables capture remains authoritative.
- P0071 adds generic developer-panel run persistence so every panel action also
  auto-saves human-readable result lines to `LogresDiagnosticsDB`.
- WoW writes SavedVariables on `/reload`/logout; arbitrary addon filesystem
  writes are not available.
- `tools/export_panel_diagnostics.py` copies the newest Forever `Logres.lua` to
  stable repo-local `LOGRES_DIAGNOSTICS_LATEST.lua`.
- Production waypoint presentation remains unimplemented.
- Minimap remains stock.

## Next Action

Apply/push P0071, deploy, then run the E.3 matrix exclusively through the
developer-panel `Waypoint Probe` action.

After the final probe click:
1. `/reload`;
2. run `python3 tools/export_panel_diagnostics.py`;
3. provide `LOGRES_DIAGNOSTICS_LATEST.lua`.

No manual copying from WoW text.

## Success Criteria

E.3 succeeds when:
- at least one destination source has runtime-proven retrieval;
- player/destination coordinates share a proven compatible domain;
- bearing orientation is runtime-proven;
- update behavior is backed by observed Forever events;
- unsupported cases omit presentation;
- Blizzard navigation remains fail-open fallback.

## Do Not Reopen Without New Evidence

- **Phase D / D.1–D.6:** complete.
- **E.1:** complete.
- **E.2:** complete.
- **Developer panel:** canonical runtime validation surface.
- **Production waypoint marker:** not authorized before E.3 proof.
- **Minimap suppression:** deferred/capability-gated.
- **Git authority:** user performs commits/pushes.

## Relevant References

- `docs/memory/decisions/D-029_COMPASS_NAVIGATION_CAPABILITY_CONTRACT.md`
- `docs/memory/investigations/E3_WAYPOINT_BEARING_CAPABILITY_PROOF.md`
- `docs/memory/evidence/E3_P0069_WAYPOINT_SOURCE_PROBE_DESIGN_2026-10-01.md`
- `docs/memory/evidence/P0071_PANEL_DIAGNOSTIC_AUTODUMP_2026-10-01.md`
