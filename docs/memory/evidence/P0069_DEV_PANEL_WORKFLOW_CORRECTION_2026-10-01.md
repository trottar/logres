# P0069 Developer-Panel Workflow Correction — 2026-10-01

Status: CORRECTED BY P0070
Date: 2026-10-01

## Failure

P0069 correctly prepared the E.3 waypoint capability probe but the assistant's
runtime handoff told the user to operate it through `/lwpa` slash commands.

That violated the already-established Project Logres validation workflow:
when a corresponding developer-panel action exists or can be provided, runtime
validation should use the in-game developer panel.

The user identified this immediately.

## Cause

The probe was designed as a standalone diagnostic addon and the handoff treated
its slash interface as the primary workflow instead of integrating it with the
existing `Logres:RegisterDevPanelAction` command surface.

## Correction

P0070 adds:
- a `Waypoint Probe` developer-panel action;
- `/logres waypointprobe` only as the command backing that panel action;
- a probe export that routes diagnostic output into the existing panel result
  sink.

The separate `/lwpa` commands remain diagnostic fallback only and are not the
normal E.3 validation workflow.

## Rule reinforced

Prefer the established Logres developer panel whenever the requested runtime
validation can be represented as a panel action.

Do not make the user operate a parallel diagnostic workflow unnecessarily.
