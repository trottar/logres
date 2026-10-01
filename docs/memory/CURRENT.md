---
memory_schema: 1
as_of: 2026-10-01
project: logres
---

# Current State

## Active Objective

**Phase B — Core HUD.**

## Current Work Item

**B.2 — Resource Presentation.**

B.1 is complete.

The production player health vignette is runtime proven on P0019:
- health-driven progression is visible;
- immersion off hides it;
- immersion on restores current injury presentation;
- healing makes it recede/disappear.

The rough rectangular edge bands are accepted as temporary visual-polish debt.

B.2 now owns the restrained player-resource percentage.

## Verified State

- Phase A complete.
- B.1 complete.
- P0018 first health-vignette visual was too weak.
- P0019 pushed at `5ae500d`.
- P0019 production health progression passed runtime observation.
- secret-safe health transport works in the real HUD module.
- immersion preference integration works in the real HUD module.
- current runtime version: `0.0.8-dev`.

## Next Action

Design B.2 before implementing it.

Use D-008 as a hard boundary.

Determine the exact Forever-safe text path for:

```text
UnitPowerPercent("player")
    -> formatted percentage
    -> FontString:SetText
```

Resolve:
1. the formatter/API that can consume secret percentage values;
2. relevant player power update events;
3. default power-type behavior across the tested character;
4. initial HUD anchor near center/character;
5. suppression rules, if any, without Lua branching on secret resource value.

Do not add a resource bar.

When B.2 runtime code is prepared, include the full deploy block before in-game validation.

## Success Criteria

B.2 succeeds when:
- a restrained resource percentage is production code;
- it uses a secret-safe formatting path;
- it updates as resource changes;
- immersion off/on hides/restores it;
- no conventional resource bar is introduced;
- no Lua arithmetic/comparison/stringification over secret resource percentage occurs;
- class/form limitations are explicitly recorded where the current environment cannot test them.

## Do Not Reopen Without New Evidence

- **Phase A:** complete.
- **B.1:** complete.
- **Health architecture:** production proven; rectangles are polish debt.
- **Resource path:** D-008.
- **No resource bar:** default remains percentage-oriented.
- **Actions:** Phase C.
- **Deployment:** full deploy block required for runtime-code tests.
- **Git authority:** user performs commits/pushes.

## Relevant References

- `docs/memory/evidence/B1_HEALTH_VIGNETTE_RUNTIME_PROOF_2026-10-01.md`
- `docs/memory/evidence/B1_HEALTH_VIGNETTE_RUNTIME_PASS01_2026-09-30.md`
- `docs/memory/investigations/B2_RESOURCE_PRESENTATION.md`
- `docs/memory/decisions/D-008_SECRET_SAFE_HEALTH_AND_RESOURCE_PATH.md`
- `docs/memory/architecture/HUD.md`
- `docs/memory/roadmap/PHASE_B_CORE_HUD.md`
