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

The source/documentation pass is complete enough to define the first runtime probe. The current work item is **I-001 runtime verification** using the temporary `LogresAPIAudit` diagnostic addon under `tools/probes/`.

The probe is diagnostic-only. It does not implement the Logres product UI.

## Verified State

- Repository bootstrap checkpoint is pushed on `main` at commit `353c5b02b71323f33e7db31ca87086d797162681`.
- Canonical development environment is Windows 11 + WSL; the user performs all commits and pushes.
- Current documentation marks the relevant APIs as present on WoW Forever 1.60.1.
- A maintained Forever-compatible DynamicCam change records a critical client-identification quirk: Forever reports Blizzard `WOW_PROJECT_MAINLINE`, so interface/build information must be used to distinguish it until Blizzard provides a dedicated project ID.
- The same DynamicCam work uses Forever interface version `16001` in its unified TOC.
- `UnitHealthPercent` and `UnitPowerPercent` are present on Forever and participate in the modern secret-value system.
- Secret-safe display mechanisms exist: curves/color curves plus widget secret aspects such as bar value, alpha, vertex color, and text.
- `UnitLevel` and `UnitClassification` are documented on Forever without secret-return predicates, making them plausible hidden inputs for Logres enemy styling.
- `UnitCastingInfo` and `UnitChannelInfo` are present but can return secret cast information under unit spell-cast restrictions.
- `InCombatLockdown` and secure action button restrictions apply on Forever; action cluster layout/attributes must not be designed around arbitrary in-combat reconfiguration.
- `C_Map.GetPlayerMapPosition` and `GetPlayerFacing` are documented as unavailable in instanced content. This supports the existing decision to suspend the compass in instances.
- `C_QuestLog.GetNextWaypoint`, `UnitIsPVP`, `IsInInstance`, restricted-action state APIs, chat-lockdown detection, and camera zoom/CVar APIs are documented as present on Forever.
- These are source/documentation findings, not yet runtime validation on the user's client.

## Next Action

Install the temporary `tools/probes/LogresAPIAudit` addon into the WoW Forever AddOns directory and run the first open-world runtime pass.

The first pass should establish:
1. actual build/interface version and `WOW_PROJECT_ID`;
2. player health/power secret behavior out of combat and in combat;
3. whether secret health/power can be passed through curves into `StatusBar:SetValue`, `SetAlpha`, and formatted text safely;
4. target level/classification visibility;
5. player/target casting secrecy;
6. map position/facing in the world;
7. PvP/instance/chat restriction state;
8. camera CVar visibility.

Preserve the resulting `LogresAPIAuditDB` saved-variable file as raw evidence. Do not begin Phase 0.3 until architecture-critical unknowns from this probe are resolved.

## Success Criteria

I-001 is complete when:
- client identification is runtime verified;
- health/power presentation has a runtime-proven secret-safe path suitable for Logres;
- target level/classification behavior is known in the intended world/combat contexts;
- self-cast confirmation feasibility is runtime verified;
- protected action/combat-lockdown constraints are sufficiently bounded for the action-cluster architecture;
- world vs instance navigation behavior is runtime verified;
- PvP flag/state detection is runtime verified;
- social/chat restrictions are bounded enough to define Quiet Mode scope;
- camera primitives needed for later integration are runtime verified or explicitly deferred;
- negative results and failed probe paths are preserved;
- `architecture/API_BOUNDARIES.md` is promoted from provisional/source-backed to runtime-backed where evidence exists.

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

Do not treat source documentation as runtime proof. If the probe contradicts documentation or a maintained addon, preserve both and let the runtime evidence control Logres behavior.

## Relevant References

- `docs/memory/investigations/FOREVER_API_CAPABILITY_AUDIT.md`
- `docs/memory/evidence/I001_SOURCE_AUDIT_2026-09-30.md`
- `docs/memory/architecture/API_BOUNDARIES.md`
- `tools/probes/LogresAPIAudit/README.md`
- `docs/memory/roadmap/STATUS.md`
- `docs/ROADMAP.md`
