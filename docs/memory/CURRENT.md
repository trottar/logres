---
memory_schema: 1
as_of: 2026-10-01
project: logres
---

# Current State

## Active Objective

**Phase C — Action Interface.**

## Current Work Item

**C.2 — Primary Action Cluster.**

C.1 secure-action source review is complete.

D-018 defines the secure action contract for implementation.

## Verified State

- Phase 0 Foundation complete.
- Phase A Core State Engine complete.
- Phase B Core HUD complete.
- P0030 Phase B closure pushed at `74ccfc3`.
- current runtime version remains `0.0.13-dev`.
- secure protected execution path is `SecureActionButtonTemplate` + action attributes.
- ordinary protected-frame mutation is forbidden during combat lockdown.
- secure state/attribute drivers are available for genuinely required combat-time protected transitions.
- current Forever `C_ActionBar` presentation APIs are available.
- cooldown/count data are secret-capable.
- DurationObject -> Cooldown is the selected secret-safe cooldown path.
- current action display count -> FontString is the selected secret-safe count path.
- existing ACTIONBUTTON1–12 keys can be preserved with session override click bindings.
- override binding changes and action pickup are no-combat.
- stock Blizzard action bars remain visible through C.2.

## Next Action

Implement C.2.

First runtime patch should provide:
- 12 named secure primary action buttons;
- compact square/rectangular layout;
- action slot icon;
- cooldown sweep through DurationObject;
- direct count text;
- usability/range visual states;
- native action-button registration;
- existing primary keybind routing;
- deferred binding refresh if combat blocks mutation;
- developer-panel `Action Check` diagnostic.

Runtime proof:
1. cluster renders existing primary actions;
2. mouse click executes an action;
3. normal existing action key executes via Logres button;
4. cooldown/count/icon update;
5. usability/range presentation behaves if naturally observable;
6. actions work in combat;
7. entering combat does not cause protected-action errors;
8. binding/layout refresh requested in combat defers safely;
9. stock Blizzard bars remain available.

## Success Criteria

C.2 succeeds when:
- secure primary buttons execute correctly;
- mouse and keyboard paths both work;
- ordinary action presentation updates correctly;
- secret cooldown/count transport produces no Lua errors;
- combat lockdown causes no forbidden mutation;
- bindings are not permanently rewritten;
- module disable/restoration can clear temporary bindings;
- stock bars remain available until later replacement proof.

## Do Not Reopen Without New Evidence

- **Phase B:** complete.
- **C.1:** complete; D-018 is canonical.
- **Saved bindings:** do not rewrite automatically.
- **Cooldown/count:** secret-capable native-consumer paths only.
- **Drag/drop editing:** deferred beyond C.2.
- **Stock action bars:** do not suppress in C.2.
- **Git authority:** user performs commits/pushes.

## Relevant References

- `docs/memory/evidence/C1_SECURE_ACTION_SOURCE_REVIEW_2026-10-01.md`
- `docs/memory/decisions/D-018_SECURE_ACTION_INTERFACE_CONTRACT.md`
- `docs/memory/architecture/ACTION_CLUSTERS.md`
- `docs/memory/decisions/D-017_BLIZZARD_UI_SUPPRESSION_AND_RESTORATION.md`
- `docs/memory/investigations/C1_SECURE_ACTION_INTERFACE.md`
- `docs/memory/roadmap/PHASE_C_ACTION_INTERFACE.md`
