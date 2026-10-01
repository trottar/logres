---
memory_schema: 1
as_of: 2026-10-01
project: logres
---

# Current State

## Active Objective

**Phase B — Core HUD.**

## Current Work Item

**B.4 — Cast Confirmation.**

P0025 prepares both:
- player cast/channel cue;
- current-target cast/channel cue.

The implementation is event-driven and does not query target cast metadata.

## Verified State

- Phase A complete.
- B.1 health vignette complete.
- B.2 primary resource percentage complete.
- B.3 target presentation complete.
- P0024 corrected cast scope pushed at `8fb567f`.
- player self cast/channel was previously observed during I-001.
- Forever spellcast events/queries may be secret-restricted for target units.
- current environment has no convenient enemy caster.
- target-cast implementation is required; true-path runtime proof may defer by environment.
- P0025 static checks pass; runtime proof pending.

## Next Action

Install/review/commit/push P0025.

Because runtime code changes, deploy explicitly:

```bash
WOW_ROOT="/mnt/c/Program Files (x86)/World of Warcraft"
ADDONS="$WOW_ROOT/_classic_beta_/Interface/AddOns"

./tools/deploy_logres.sh "$ADDONS"
```

Then:

```text
/reload
/logres status
/logres statecheck
/logres preferencecheck
/logres lifecyclecheck
/logres hudcheck
```

Confirm version:
`0.0.11-dev`

B.4 runtime:
1. use an ordinary player cast with cast time;
2. confirm the amber player cue appears beside resource and disappears when cast ends;
3. use a player channel if readily available and confirm blue cue;
4. interrupt/fail a cast if practical and observe brief red snap;
5. immersion off/on during an active cast should hide/show with the HUD root;
6. if a current-target caster is naturally available, observe target orange/violet cue;
7. otherwise report target-caster true path as unavailable in the current environment.

Do not travel solely to locate an enemy caster.

## Success Criteria

B.4 succeeds when:
- player cast cue is runtime proven;
- player channel cue is proven if readily available or prior I-001 evidence remains sufficient for channel API viability;
- current-target cue implementation exists;
- target true path is either runtime proven or environmentally deferred;
- stop/interruption cleanup behaves;
- immersion root behavior is correct;
- no secret-value/Lua errors occur;
- no conventional cast bar is introduced.

## Do Not Reopen Without New Evidence

- **B.1:** complete.
- **B.2:** complete.
- **B.3:** complete.
- **Cast scope:** player + current target.
- **Cast metadata:** P0025 avoids target queries/payload inspection.
- **Target true-path:** may defer by environment only.
- **No cast bars:** fixed product rule.
- **Deployment:** full deploy block required.
- **Git authority:** user performs commits/pushes.

## Relevant References

- `docs/memory/decisions/D-014_CAST_PRESENTATION_CONTRACT.md`
- `docs/memory/investigations/B4_CAST_CONFIRMATION.md`
- `docs/memory/evidence/B4_CAST_SOURCE_RESOLUTION_2026-10-01.md`
- `docs/memory/evidence/I001_RUNTIME_PASS_02_2026-09-30.md`
- `docs/memory/architecture/HUD.md`
- `Logres/HUD/HUD.lua`
- `tools/check_hud_contract.py`
