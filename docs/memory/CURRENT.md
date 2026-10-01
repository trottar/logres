---
memory_schema: 1
as_of: 2026-09-30
project: logres
---

# Current State

## Active Objective

**Phase 0 — Foundation.** Establish Project Logres as a repository-native, memory-driven WoW Forever addon project before implementation depends on unverified API assumptions.

## Current Work Item

**0.1 — Memory bootstrap.**

Install, inspect, validate, commit, and push the initial `docs/memory/` architecture and memory-health checker. This bootstrap converts the design discussion into durable repository state and establishes explicit negative-result retention.

After this checkpoint is pushed and verified, the active work item becomes **0.2 — WoW Forever API capability audit**.

## Verified State

- Repository: `trottar/logres`.
- Default branch: `main`.
- Repository is public.
- Initial README commit exists on `main`.
- Canonical development environment is Windows 11 + WSL.
- Working repository is intended to live in the WSL Linux filesystem (`~/Projects/logres`).
- User retains authority for all commits and pushes.
- Project name: **Logres** / **Project Logres**.
- Product direction: immersive, world-first WoW Forever interface with intentionally limited numerical abstraction.
- The initial design decisions captured under `decisions/` are accepted project intent, but WoW API implementation details remain subject to Phase 0 verification.

## Next Action

Install this memory-bootstrap patch into the repository, run:

`python3 tools/check_memory_health.py`

then inspect:

`git status --short`

and:

`git diff --check`

If the checker passes and the diff matches the intended bootstrap only, the user commits and pushes the checkpoint. After the pushed state is verified, begin `0.2` by creating and executing the WoW Forever API capability audit.

## Success Criteria

The memory bootstrap is complete when:
- required active-memory files exist;
- `CURRENT.md` has exactly one authoritative objective and next action;
- initial accepted design decisions are canonical records rather than chat-only knowledge;
- negative-result retention is an explicit project rule;
- WSL and user-controlled Git boundaries are recorded;
- roadmap and current status agree;
- `tools/check_memory_health.py` passes;
- `git diff --check` passes;
- the user has committed and pushed the bootstrap.

## Do Not Reopen Without New Evidence

- **Project name:** Logres.
- **Development environment:** Windows 11 + WSL, repository in the Linux filesystem.
- **Git authority:** user performs commits/pushes.
- **Negative-result policy:** failures and rejected paths are preserved as learning.
- **No conventional player health bar:** the intended player-health language is a screen-edge vignette.
- **Enemy disclosure:** no numeric enemy level and no explicit elite/difficulty warning by default.
- **Action layout:** rectangular/square clusters rather than a traditional long bar.
- **Compass context:** part of immersion/world presentation and automatically absent in instances.
- **PvP:** a state modifier that increases useful presentation rather than simply disabling immersion.

API feasibility is not settled by these design decisions. If Forever restrictions force a change, create evidence and a superseding decision rather than silently rewriting intent.

## Relevant References

- `docs/ROADMAP.md`
- `docs/memory/DESIGN_PRINCIPLES.md`
- `docs/memory/MEMORY.md`
- `docs/memory/MAINTENANCE.md`
- `docs/memory/roadmap/STATUS.md`
- `docs/memory/investigations/ACTIVE.md`
- `docs/memory/handoffs/CURRENT_HANDOFF.md`
- `docs/memory/decisions/`
- `docs/memory/2026-09-30.md`
