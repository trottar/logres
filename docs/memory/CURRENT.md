---
memory_schema: 1
as_of: 2026-09-30
project: logres
---

# Current State

## Active Objective

**Phase 0 — Foundation.** Establish the first real Logres addon runtime and prove that its lifecycle/state foundation works on WoW Forever.

## Current Work Item

**0.3 — Minimal addon skeleton/load proof.**

P0005 prepares the first real `Logres/` addon:
- Forever TOC;
- shared addon namespace/event dispatcher;
- `LogresDB` initialization;
- central world/combat/instance/PvP state;
- development status command;
- WSL deployment helper;
- static addon-structure checker.

No product HUD feature is implemented in this checkpoint.

## Verified State

- P0001 memory bootstrap pushed at `353c5b0`.
- P0002 source audit/probe pushed at `48a7d28`.
- P0003 first runtime evidence pushed at `ad3a660`.
- P0004 I-001 closure pushed at `477df5b`.
- I-001 is complete with explicit phase-specific deferrals.
- Forever runtime: 1.60.1 build 70124 / interface 16001.
- Forever reports `WOW_PROJECT_ID == WOW_PROJECT_MAINLINE == 1`.
- secret-safe health/resource architecture is settled by D-008.
- compass inputs are world-only in the tested client; instances remove map position/facing.
- combat restriction state may settle across multiple events.
- the minimal skeleton source is prepared but **not yet runtime proven**.

## Next Action

Install P0005, run:

```text
python3 tools/check_memory_health.py
python3 tools/check_addon_structure.py
git diff --check
```

Review, commit, and push P0005.

Then deploy:

```text
./tools/deploy_logres.sh "<Forever Interface/AddOns directory>"
```

In game:
1. enable `Logres`;
2. `/reload`;
3. confirm one development load message and no Lua error;
4. run `/logres status`;
5. run `/reload` again and confirm `loadCount` increases;
6. enter/leave ordinary combat and inspect `/logres status`;
7. enter/leave an instance if convenient and inspect `/logres status`.

Preserve any failure before changing code.

## Success Criteria

Phase 0.3 succeeds when:
- `Logres/Logres.toc` loads on Forever interface 16001;
- addon namespace/bootstrap loads without Lua errors;
- `LogresDB` initializes safely;
- `loadCount` persists/increments through `/reload`;
- central state reports world/combat/instance/PvP inputs correctly for tested contexts;
- deployment from WSL is repeatable;
- static structure and memory checks pass;
- runtime load/state proof is recorded under `docs/memory/evidence/`;
- failures are preserved;
- memory/roadmap are synchronized.

## Do Not Reopen Without New Evidence

- **Project name:** Logres.
- **Development environment:** Windows 11 + WSL.
- **Git authority:** user performs commits/pushes.
- **Negative-result policy:** failures are durable learning.
- **Forever identity:** interface 16001 currently collides with MAINLINE project ID.
- **Health/resource architecture:** secret-safe native transforms/display only; see D-008.
- **No conventional player health bar.**
- **Enemy disclosure:** level/elite metadata remains intentionally hidden by default.
- **Action layout:** rectangular/square clusters.
- **Compass context:** world-only where data exists; suspend in instances.
- **PvP:** state modifier, not immersion-off.
- **Phase 0.3 scope:** lifecycle/state foundation only; no product HUD yet.

## Relevant References

- `docs/memory/architecture/SYSTEM.md`
- `docs/memory/architecture/STATE_ENGINE.md`
- `docs/memory/architecture/API_BOUNDARIES.md`
- `docs/memory/decisions/D-008_SECRET_SAFE_HEALTH_AND_RESOURCE_PATH.md`
- `docs/memory/evidence/I001_RUNTIME_PASS_02_2026-09-30.md`
- `docs/memory/roadmap/STATUS.md`
- `Logres/`
- `tools/deploy_logres.sh`
- `tools/check_addon_structure.py`
