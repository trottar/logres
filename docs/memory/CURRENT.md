---
memory_schema: 1
as_of: 2026-10-06
project: logres
---

# Current State

## Active Objective

**Preserve the accepted P0152 pet-action control/state-presentation result, then classify the newly observed world-entry camera transition timeout before advancing runtime work.**

P0152 functionality is accepted on `0.0.74-dev`. Exact pet-button ornament/contrast refinement is deferred to later whole-interface polish rather than reopened as a standalone functional task.

Formal Phase G / G.5 remains open. The latest integrated Run All exposed one Camera World/Combat transition timeout that must be treated as project evidence before further runtime advancement.

## Current Work Item

**P0153 — docs/evidence checkpoint: record P0152 R12 acceptance and open the one-off `PLAYER_ENTERING_WORLD` camera transition timeout as INTERMITTENT / UNREPRODUCED.**

Latest verified durable code checkpoint:
P0152 `00aef4a90e5999140dc9082e68e934cfc854cb05` (`0.0.74-dev`).

P0152 accepted result:
- the Logres pet cluster is present by default without manual panel ARM;
- the effective click-specific secure pet bindings resolve all ten pet slots;
- seven naturally occupied/readable slots were observed;
- persistent presentation reports exactly two active-state indicators and one autocast indicator;
- the user visually confirmed the active/autocast treatment works and confirmed pet button presses still execute;
- stock PetActionBar remains the completeness/fail-open fallback;
- no edit/reorder/binding replacement, PetActionBar suppression, PetFrame ownership, or unrelated class/special ownership is claimed.

The final integrated Run All did **not** pass globally: `cameraworldcombat` timed out during a world-entry transition toward requested zoom `5`. That failure is currently one observation and is therefore OPEN / INTERMITTENT / UNREPRODUCED, not a justified code-fix target yet.

## Verified State

P0152 R12 is runtime/control/state-presentation PASS for the bounded pet-action slice on Forever `1.60.1.70235` / `0.0.74-dev`:
- `pet=10`, `readable=7`;
- `activeIndicators=2`;
- `autocastIndicators=1`;
- default-on lifecycle dispatched successfully with no pending arm;
- slot 2 and slot 6 were active; slot 4 exposed enabled autocast;
- user-confirmed pet button execution remained functional after the R12 presentation correction.

The accepted P0152 result does not depend on a conventional bespoke pet strip. It remains a specialization of the shared Logres action-button language and retains Blizzard fallback.

The same final Run All recorded one unrelated camera failure:
- reason `PLAYER_ENTERING_WORLD`;
- requested/effective target `5`;
- start about `6.812`, current about `6.766`, final about `6.753`;
- elapsed about `3.254s`;
- `targetReached=false`, `failures=1`;
- error `camera transition timed out before target`.

P0152 did not modify camera runtime files, so there is no evidence yet that the pet work caused the timeout. Prior camera checks had passed. Preserve the event as an intermittent/unreproduced regression watch until targeted retest establishes recurrence or clears it.

## Next Action

After P0153 is durable, perform one targeted normal world-entry retest without changing camera code:
1. `/reload` in the normal world state;
2. developer panel -> Phase G -> **Camera World/Combat Check**;
3. developer panel -> Phase 0 -> **Run All** separately;
4. upload refreshed diagnostics.

If the camera timeout recurs, treat it as reproduced and investigate the narrow transition-driver cause before any patch. If both checks are clean, record the prior event as intermittent/unreproduced and continue without a speculative camera change.

No travel, polling, broad hooks, periodic reassertion, or contrived gameplay is required solely to manufacture proof.

## Success Criteria

The next checkpoint succeeds if:
- the camera result is classified from targeted runtime evidence rather than static speculation;
- a recurring timeout, if observed, is preserved with exact evidence and narrowed before code changes;
- a clean retest, if observed, records the prior timeout as intermittent/unreproduced rather than erasing it;
- P0152 remains accepted for pet execution/default-on/state presentation;
- pet visual refinement remains deferred to later whole-interface polish unless a functional defect appears;
- no unrelated capability or Blizzard surface is suppressed while the camera result is unresolved.

## Do Not Reopen Without New Evidence

- no conventional player health bar;
- P0152 pet execution/default-on/state-presentation is accepted; exact ornament/contrast refinement belongs to later whole-interface polish;
- PetActionBar suppression, pet edit/reorder, binding replacement, and PetFrame ownership remain separately gated;
- harmful/urgent player and populated target aura production remain deferred;
- positive world-target nameplate anchoring/attachment remains deferred;
- individual tracking-result positions remain source-blocked by P0142/D-043;
- stock minimap remains until replacement completeness is proven;
- party/CompactPartyFrame remain stock until secure interaction and required group/aura information are replaced safely;
- RuneFrame, TotemFrame, alternate-power, direct class-resource children, stance/form, and unsupported special-control surfaces remain Blizzard-owned until separately runtime/capability-proven;
- possess/override/vehicle/extra-action surfaces are not ordinary Bar 2–3 roles;
- Continue/Complete/reward/gossip quest ownership remains separately gated;
- P0119 Taxi landing retest remains pending/frozen;
- no max-distance CVar mutation, Taxi rotation, or Taxi UI fade is authorized.

## Relevant References

- `docs/memory/evidence/P0153_P0152_RUNTIME_ACCEPTANCE_CAMERA_TIMEOUT_2026-10-06.md`
- `docs/memory/investigations/CAMERA_WORLD_ENTRY_TRANSITION_TIMEOUT_2026-10-06.md`
- `docs/memory/decisions/D-044_CLASS_PET_SPECIAL_CONTROL_SOURCE_AND_FALLBACK_POLICY.md`
- `docs/memory/investigations/FUTURE_CLASS_PET_SPECIAL_CONTROL_CAPABILITY.md`
- `docs/memory/patches/P0152_SECURE_PET_ACTION_EXECUTION_PROBE.md`
- `docs/memory/patches/P0152_R12_EFFECTIVE_PET_BINDING_STATE_PRESENTATION.md`
- `docs/memory/patches/P0153_RECORD_P0152_PASS_CAMERA_TIMEOUT.md`
- `docs/memory/architecture/VISUAL_IMPLEMENTATION_STATUS.md`
- `docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md`
- `docs/memory/roadmap/STATUS.md`
- `docs/ROADMAP.md`
