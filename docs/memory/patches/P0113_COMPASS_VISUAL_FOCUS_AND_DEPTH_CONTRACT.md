# P0113 — Compass Visual Focus and Depth Contract

Date: 2026-10-03
Result: **INSTALLED / PUSHED — DOCS-ONLY**
Baseline: `bd0a9da3c7abc49ff527e8901bfd5c77846414a5`
Commit: `19c0d1ffcdc0cf2df59a2e648cfa9caab1c4d347`
Runtime: `0.0.44-dev` unchanged

## Purpose

Synchronize durable repo memory with the accepted detailed compass/navigation art
contract developed in the parallel Phase H+ visual workstream.

This checkpoint intentionally goes first while a separate uncommitted G.5 P0112
worktree exists. It therefore touches only clean Phase H / compass visual records
and new files, so it can be committed without staging or overwriting the other
workstream.

## D-038 — compass visual/focus system

Record the accepted working treatment for:
- weathered brass heading tape and fixed center gnomon;
- distinct manual-waypoint, quest, local-POI, and tracking glyph silhouettes;
- true horizontal bearing anchors with vertical collision lanes;
- lower-priority POI/tracking clustering instead of falsified bearing offsets;
- center-focused identity readout;
- physical/world proximity as the first focus selector when comparable distance is
  capability-proven;
- angular alignment as the fallback/secondary selector;
- continuous identity-name fade as angle deviates from center;
- restrained distance-dependent scale for manual/quest destinations;
- mostly stable POI scale and effectively fixed tracking scale;
- smooth edge recession with no fabricated off-screen arrows.

All source-dependent quest/POI/tracking identity, bearing, and distance behavior
remains capability-gated. D-030 continues to keep the Blizzard minimap stock.

## Parallel-worktree boundary

The following shared records are deliberately not modified by P0113 because the
in-flight G.5 P0112 worktree already owns changes there:
- `docs/memory/CURRENT.md`;
- `docs/memory/handoffs/CURRENT_HANDOFF.md`;
- `docs/memory/roadmap/STATUS.md`;
- `docs/ROADMAP.md`;
- `docs/memory/patches/PATCH_INDEX.md`;
- `docs/memory/patches/P0111_RECORD_HEALTH_TUNNEL_AND_NAVIGATION_DIRECTION.md`.

Their summary/index synchronization is deferred to the next converged checkpoint
after both parallel commits are durable. D-038 itself and the compass architecture
records are canonical for this visual decision immediately after P0113 is pushed.

## Scope

Docs/memory only.

No Lua, addon metadata, runtime behavior, minimap suppression, camera scope, or WoW
deployment changes.

The active runtime objective remains Phase G / G.5 in the shared current-state
records; P0113 does not redirect it.

## Validation

- P0113-owned baseline/blob and clean-path guards;
- P0113-owned text hygiene checks;
- `python3 tools/check_memory_health.py` attempted as a global diagnostic;
- `git diff --check -- <P0113-owned tracked files>`;
- final global `git diff --check` attempted as a parallel-worktree diagnostic.

## Deployment

No WoW redeploy required.
