---
memory_schema: 1
as_of: 2026-10-05
project: logres
---

# Current State

## Active Objective

**Advance the class/pet/special-control sequence only through runtime-proven capability slices while preserving Blizzard fallback surfaces.**

Formal Phase G / G.5 remains open and paused while the approved visual sequence is finished.

## Current Work Item

**P0152 — bounded secure pet-action execution probe.**

Latest verified durable checkpoint:
P0150 R3 correction `46e06295695587af07f6f3e1b4a6ac4ace4e4c15`.

Current tested runtime:
`0.0.73-dev` on client `1.60.1.70235` — P0150 read-only probe **PASS for the observed scope with environmental deferrals**.

P0150 accepted runtime evidence:
- all 22/22 expected event registrations succeeded and required APIs were present;
- pet action bar present, 10 slots scanned / 7 occupied, pet-domain failures `0`;
- ordinary active/autocast/usable state was captured without mutation;
- one Warlock primary-power value was secret and safely skipped; resource-domain failures `0`;
- stance/form count `0`, no active totems, and non-DK runes are environmental DEFERRED;
- possess/vehicle/override/temp-shapeshift/extra-action flags were ordinary `false`;
- total probe failures `0`;
- separate integrated **Run All** completed cleanly.

The accepted client build is now `70235`. Matching Forever source is
`Gethe/wow-ui-source@a84e2b1b41d3d4137127c07e4da448aa3251d6f1`.
It is the direct child of the P0149 `70205` source pin and changes only
`version.txt`; `SecureTemplates.lua` and `PetActionBar.lua` are byte-identical
across the two source commits. D-044's pet secure-action source finding therefore
remains applicable to the current client.

The strongest naturally populated domain is pet actions. P0152 is limited to
proving user-triggered secure pet-action execution through the source-established
`SecureActionButtonTemplate` / `type="pet"` path.

P0152 does **not** authorize PetActionBar suppression. Stock PetActionBar remains
visible/usable. Autocast mutation, drag/reorder/edit, key routing/bindings,
complete cooldown/range/usable/active feedback, combat-safe replacement setup,
exact restoration, and PetFrame ownership remain separate gates.

P0148 manual-waypoint depth remains the accepted production baseline. Navigation,
aura, world-target, party, and Camera deferrals remain unchanged.

## Verified State

Accepted production baselines include:
- P0120 shared percentage/resource bar;
- P0121 player cast cue, target cast/channel deferred;
- P0122 Context-message primitive;
- P0123 heading/manual-waypoint Compass bearing + visual baseline;
- P0124 organic player-health tunnel;
- P0126 one-focus Active Quest;
- P0130 bounded/paged quest-offer narrative;
- P0133 Accept-left / Decline-right offer controls for the proven offer state;
- P0137 passive player `HELPFUL|PLAYER` aura lane;
- P0148 manual-waypoint live-radius depth baseline.

World target:
- P0140 fallback/reaction runtime paths pass for the observed scope;
- positive accessible-nameplate anchoring, behind-camera behavior, and hidden addon-owned attachment remain environmentally deferred;
- production target placement remains screen-space.

Class / pet / special-control territory:
- P0149 / D-044 source/fallback policy remains authoritative;
- P0150 R3 is durable at `46e06295` and runtime PASS for the observed read-only scope on client build `70235`;
- pet action state is the only naturally populated control domain from that run and is the next secure-execution candidate;
- stance/forms, active totems, DK runes, active possess/vehicle/override/temp-shapeshift/extra-action modes, and meaningful nonzero class-resource presentation remain environmental DEFERRED;
- PetFrame, RuneFrame, TotemFrame, alternate-power, StanceBar, PossessActionBar, OverrideActionBar, ExtraActionBar, and unsupported vehicle/special controls remain Blizzard-owned;
- PetActionBar remains Blizzard-owned until casting plus autocast/edit/binding/feedback/setup/restoration completeness is deliberately proven.

Camera:
- P0119 remains durable at `c342bc176a9d5de80ec116d0c6b31fa595cd75b3`;
- normal-Taxi landing retest remains pending/frozen, not PASS.

## Next Action

Prepare P0152 as a **bounded secure pet-action execution probe**, not a production replacement.

Required scope:
1. use matching 70235 source continuity from P0151 / D-044;
2. create addon-owned secure test control(s) only through `SecureActionButtonTemplate` with `type="pet"` and ordinary pet-action slot attributes;
3. configure protected attributes only out of combat and fail open if setup cannot be completed safely;
4. retain the stock PetActionBar throughout the test;
5. prove at least one deliberate user-triggered pet action through the Logres secure surface without Lua, secret, taint, or protected-action failure;
6. record only addon-owned diagnostic state and source-owned follow-up events; do not infer success from static source alone;
7. do not toggle autocast, reorder/edit pet actions, replace bindings, suppress PetActionBar, or touch PetFrame.

A missing usable/appropriate pet action in a later test state is an environmental deferral, not permission to manufacture unsafe gameplay state.

## Success Criteria

P0152 succeeds only for secure pet-action **execution capability** when:
- secure pet-action buttons are configured out of combat with ordinary slot numbers;
- a deliberate user click reaches a real pet action through the secure path;
- observable addon-owned/event evidence plus user confirmation establishes that execution occurred;
- no Lua, secret-value, taint, forbidden/protected-action, or unintended mutation failure occurs;
- stock PetActionBar remains available and usable before, during, and after the probe;
- integrated regression checks remain clean.

P0152 does not by itself authorize PetActionBar suppression or full pet-control ownership.

## Do Not Reopen Without New Evidence

- no conventional player health bar;
- harmful/urgent player and populated target aura production remain deferred;
- target aura/status remains separately gated from world-target anchoring;
- positive world-target nameplate anchoring/attachment remains deferred;
- individual tracking-result positions are source-blocked by P0142/D-043;
- stock minimap remains until D-037/D-043 replacement completeness is proven;
- party/CompactPartyFrame remain stock until secure interaction and required group/aura information are safely replaced;
- PetFrame remains stock independent of pet-action work;
- RuneFrame, TotemFrame, alternate-power, direct class-resource children, and unsupported special-control surfaces remain Blizzard-owned until separately runtime/capability-proven;
- possess/override/vehicle/extra-action surfaces are not ordinary Bar 2–3 roles;
- Continue/Complete/reward/gossip quest ownership remains separately gated;
- P0119 Taxi landing retest remains pending/frozen;
- no max-distance CVar mutation, Taxi rotation, or Taxi UI fade is authorized.

## Relevant References

- `docs/memory/decisions/D-044_CLASS_PET_SPECIAL_CONTROL_SOURCE_AND_FALLBACK_POLICY.md`
- `docs/memory/evidence/P0151_P0150_CLASS_PET_SPECIAL_RUNTIME_PASS_2026-10-05.md`
- `docs/memory/evidence/P0150_INITIAL_RUNTIME_FAIL_2026-10-05.md`
- `docs/memory/investigations/FUTURE_CLASS_PET_SPECIAL_CONTROL_CAPABILITY.md`
- `docs/memory/patches/P0151_RECORD_P0150_RUNTIME_PASS.md`
- `docs/memory/patches/P0150_CLASS_PET_SPECIAL_CONTROL_READ_ONLY_PROBE.md`
- `docs/memory/decisions/D-026_SELECTIVE_UNIT_FRAME_SUPPRESSION.md`
- `docs/memory/architecture/VISUAL_IMPLEMENTATION_STATUS.md`
- `docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md`
- `docs/memory/roadmap/PHASE_G_CINEMATIC_CAMERA.md`
- `docs/ROADMAP.md`
