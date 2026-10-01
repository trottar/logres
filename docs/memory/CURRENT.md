---
memory_schema: 1
as_of: 2026-09-30
project: logres
---

# Current State

## Active Objective

**Phase 0 — Foundation.** Establish Project Logres as a repository-native, memory-driven WoW Forever addon project before implementation begins.

## Current Work Item

**0.3 — Minimal addon skeleton/load proof.**

I-001 / Phase 0.2 is complete with explicit phase-specific deferrals.

The next implementation work creates the smallest real `Logres` addon that:
- loads on Forever interface 16001;
- establishes the addon namespace;
- establishes saved-variable policy;
- creates Core event/state foundations without product HUD;
- emits a minimal development-only load confirmation;
- can be deployed from WSL into `_classic_beta_/Interface/AddOns/Logres`;
- survives `/reload`.

## Verified State

- P0001 memory bootstrap pushed at `353c5b0`.
- P0002 source audit/probe pushed at `48a7d28`.
- P0003 first runtime evidence pushed at `ad3a660`.
- Forever runtime: 1.60.1 build 70124 / interface 16001.
- Forever reports `WOW_PROJECT_ID == WOW_PROJECT_MAINLINE == 1`.
- player and target health/power percentages are secret-capable and must use secret-safe display transport.
- custom Logres health curve -> secret status-bar value/alpha is runtime verified.
- player cast/channel APIs are runtime verified for self-confirmation.
- ordinary and elite target level/classification are readable even in tested combat/instance contexts, but remain intentionally hidden according to product policy.
- open-world map position/facing works.
- instance map position/facing is unavailable; world values restore after instance exit.
- combat lockdown exists and event ordering requires transition tolerance.
- diagnostic SavedVariables persisted across reload and instance transitions.
- I-001 is closed with explicit deferrals for phase-specific tests.

## Next Action

Prepare P0004, commit/push the I-001 closure records, then design and generate the Phase 0.3 minimal addon skeleton.

The skeleton must not yet implement the health vignette, target HUD, compass, action clusters, Quiet Mode, or camera behavior.

First proof should be load/lifecycle/state infrastructure only.

## Success Criteria

Phase 0.3 succeeds when:
- `Logres/Logres.toc` is valid for Forever;
- addon namespace/bootstrap loads without Lua errors;
- SavedVariables initialize safely;
- central state module can observe basic world/combat/instance/PvP inputs without presenting product UI;
- deployment from WSL is repeatable;
- `/reload` preserves expected saved state;
- load proof is recorded as runtime evidence;
- failures are preserved;
- memory and roadmap are synchronized.

## Do Not Reopen Without New Evidence

- **Project name:** Logres.
- **Development environment:** Windows 11 + WSL.
- **Git authority:** user performs commits/pushes.
- **Negative-result policy:** failures are durable learning.
- **Forever identity:** interface 16001 currently collides with MAINLINE project ID.
- **Health/resource architecture:** secret-safe native transforms/display only; see D-008.
- **No conventional player health bar.**
- **Enemy disclosure:** level/elite metadata remains intentionally hidden by default even though runtime proved it is available.
- **Action layout:** rectangular/square clusters.
- **Compass context:** world-only where map/facing data exists; suspend in instances.
- **PvP:** state modifier, not immersion-off.

## Relevant References

- `docs/memory/investigations/FOREVER_API_CAPABILITY_AUDIT.md`
- `docs/memory/evidence/I001_RUNTIME_PASS_01_2026-09-30.md`
- `docs/memory/evidence/I001_RUNTIME_PASS_02_2026-09-30.md`
- `docs/memory/architecture/API_BOUNDARIES.md`
- `docs/memory/decisions/D-008_SECRET_SAFE_HEALTH_AND_RESOURCE_PATH.md`
- `docs/memory/roadmap/STATUS.md`
- `docs/ROADMAP.md`
