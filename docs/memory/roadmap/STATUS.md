# Roadmap Status

As of 2026-09-30.

## Active

**Phase 0 — Foundation**

Active work item: **0.2 WoW Forever API capability audit**

State: **SOURCE PASS COMPLETE; RUNTIME PROBE NEXT**

## Phase status

| Phase | State |
| --- | --- |
| 0 — Foundation | ACTIVE |
| A — Core State Engine | BLOCKED on Phase 0 |
| B — Core HUD | BLOCKED on Phase 0/A |
| C — Action Interface | BLOCKED on Phase 0/A |
| D — Immersion Controller | BLOCKED on Phase A |
| E — Compass and Navigation | BLOCKED on Phase 0/A/D |
| F — Quest Experience | BLOCKED on Phase 0/A/D |
| G — Cinematic Camera | BLOCKED on Phase 0/A; requires current DynamicCam profile |
| H — Integration and Polish | BLOCKED on prior phases |

## Foundation sequence

| Item | State |
| --- | --- |
| 0.1 Repository + durable memory | COMPLETE; pushed at `353c5b0` |
| 0.2 Forever API capability audit | ACTIVE; source pass complete, runtime probe next |
| 0.3 Minimal addon skeleton/load proof | BLOCKED on 0.2 |

## I-001 source-pass headline findings

- Forever cannot currently be identified reliably by `WOW_PROJECT_ID`; maintained addon source observes MAINLINE.
- Interface 1.60.1 / TOC 16001 is the current Forever line used by maintained addons.
- Modern secret-value restrictions are present.
- Health/power percentage APIs and secret-safe visual/text pathways exist.
- Level/classification APIs remain available as plausible hidden metadata.
- Casting is secret-restricted for non-player units.
- Combat lockdown constrains action-button reconfiguration.
- Map position/facing are unavailable in instances.
- Quest waypoint, PvP flag, instance state, chat restriction, and camera APIs are present.

All remain source/documentation evidence until runtime probe promotion.

## Established design decisions

- D-001 Project identity/world-first philosophy
- D-002 Player health presentation
- D-003 Enemy information disclosure
- D-004 Action cluster geometry
- D-005 Immersion/instance behavior
- D-006 PvP as a state modifier
- D-007 User owns Git checkpoints

See `../../ROADMAP.md` for the full phase roadmap.
