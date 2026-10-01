---
memory_schema: 1
as_of: 2026-09-30
project: logres
---

# Current State

## Active Objective

**Phase 0 — Foundation.** Establish Project Logres as a repository-native, memory-driven WoW Forever addon project before implementation depends on unverified API assumptions.

## Current Work Item

**0.2 — WoW Forever API capability audit.**

I-001 runtime pass 01 is complete. It established client identity, secret-value display transport for health/resource UI, ordinary target metadata, open-world navigation inputs, combat transition timing, SavedVariables persistence, and camera/chat read availability.

The next work item is **I-001 targeted runtime pass 02** for the remaining architecture-critical unknowns.

## Verified State

- P0001 memory bootstrap is pushed at `353c5b0`.
- P0002 source audit/runtime probe is pushed at `48a7d28`.
- Forever runtime: version 1.60.1, build 70124, interface 16001.
- Forever runtime reports `WOW_PROJECT_ID == WOW_PROJECT_MAINLINE == 1`.
- Forever Lua did not provide `table.pack`; the diagnostic probe now uses a compatibility helper.
- `UnitHealthPercent("player")` is secret even out of combat.
- `UnitPowerPercent("player")` is secret even out of combat.
- secret-safe percent formatting/text works.
- secret normalized health -> `StatusBar:SetValue` works.
- secret normalized health -> `Texture:SetAlpha` works.
- the health display transport continued to work in active combat-lockdown snapshots.
- ordinary target numeric level and `"normal"` classification were non-secret in tested open-world contexts.
- ordinary target health/power percentages were secret when a valid target existed.
- open-world player map position/facing are available and non-secret.
- `UnitIsPVP("player")` is callable and non-secret in the unflagged state.
- chat messaging-lockdown state is readable.
- camera zoom and relevant camera CVar reads work.
- diagnostic SavedVariables persisted across `/reload`.
- combat event timing is not fully synchronous: `PLAYER_REGEN_DISABLED` was observed before `InCombatLockdown()` settled to true.

## Next Action

Commit/push P0003, reinstall the updated probe, `/reload`, then run targeted runtime pass 02. The updated probe includes a guarded Logres inverse/threshold health-curve test.

Priority order:
1. prove a custom inverse/threshold secret curve suitable for the health vignette;
2. capture a valid target while combat lockdown is active;
3. capture a real player cast-time/channel event;
4. capture an elite/rare target if convenient;
5. enter an instance and verify map/facing behavior;
6. test PvP-flag transition only when convenient/safe;
7. exercise quest waypoint data on a tracked quest.

Do not test automatic chat replies or mutate camera CVars yet.

## Success Criteria

I-001 is complete when:
- client identification is runtime verified;
- health/power presentation has a runtime-proven secret-safe path suitable for Logres;
- target level/classification behavior is known in intended world/combat contexts;
- self-cast confirmation feasibility is runtime verified;
- protected action/combat-lockdown constraints are sufficiently bounded for action-cluster architecture;
- world vs instance navigation behavior is runtime verified;
- PvP state detection is sufficiently verified or explicitly deferred;
- quest waypoint feasibility is verified or explicitly bounded;
- social/chat restrictions are bounded enough to define Quiet Mode scope;
- camera primitives needed for later integration are runtime verified or explicitly deferred;
- negative results are preserved;
- API boundaries are promoted only to the strength of actual evidence.

## Do Not Reopen Without New Evidence

- **Project name:** Logres.
- **Development environment:** Windows 11 + WSL.
- **Git authority:** user performs commits/pushes.
- **Negative-result policy:** failures and rejected paths are preserved as learning.
- **Forever identity:** interface 16001 / build 70124 currently reports MAINLINE project ID.
- **Health/resource:** percentage values are secret; use secret-safe display transport, not Lua arithmetic.
- **No conventional player health bar:** intended health language is a screen-edge vignette.
- **Enemy disclosure:** no numeric enemy level and no explicit elite/difficulty warning by default.
- **Action layout:** rectangular/square clusters rather than a traditional long bar.
- **Compass context:** world immersion feature; instances suspend it.
- **PvP:** a state modifier rather than an immersion-off switch.

## Relevant References

- `docs/memory/investigations/FOREVER_API_CAPABILITY_AUDIT.md`
- `docs/memory/evidence/I001_RUNTIME_PASS_01_2026-09-30.md`
- `docs/memory/evidence/I001_SOURCE_AUDIT_2026-09-30.md`
- `docs/memory/architecture/API_BOUNDARIES.md`
- `docs/memory/LEARNINGS.md`
- `tools/probes/LogresAPIAudit/`
- `docs/memory/roadmap/STATUS.md`
