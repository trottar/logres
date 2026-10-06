# Current Handoff

Authoritative state:
`../CURRENT.md`.

Latest verified durable checkpoint:
P0150 R3 correction `46e06295695587af07f6f3e1b4a6ac4ace4e4c15`.

Current pushed/tested runtime:
`0.0.73-dev` on client `1.60.1.70235` — P0150 read-only runtime PASS for the observed scope with environmental deferrals.

## Active work stream

**P0152 — bounded secure pet-action execution probe.**

P0150 R3 passes with 22/22 expected events, required APIs present, populated pet state (10 scanned / 7 occupied), one safely skipped secret Warlock power value, zero probe failures, ordinary false special-mode flags, and a separate clean Run All.

Stance/forms, active totems, DK runes, active special modes, and meaningful nonzero class-resource presentation remain environmental DEFERRED.

The client moved from build 70205 to 70235. Matching Forever source `a84e2b1b41d3d4137127c07e4da448aa3251d6f1` is the direct child of the P0149 source pin and changes only `version.txt`; audited `SecureTemplates.lua` and `PetActionBar.lua` are unchanged. D-044 therefore remains source-continuous.

Pet actions are the next justified slice because they were naturally populated and the source-proven secure `type="pet"` path remains unchanged.

P0152 must remain a capability probe:
- addon-owned `SecureActionButtonTemplate` test control(s);
- `type="pet"` plus ordinary slot attributes;
- protected setup out of combat only;
- stock PetActionBar retained;
- deliberate user-triggered execution proof;
- no autocast mutation, drag/reorder/edit, binding replacement, PetActionBar suppression, or PetFrame ownership.

P0148 waypoint depth remains accepted. Navigation/aura/world-target/party deferrals and Camera freeze remain unchanged.

## Runtime proof for P0152

When implemented:
1. deploy before `/reload`;
2. use the Phase-H pet secure-action probe surface;
3. deliberately click a known pet action through Logres;
4. preserve addon-owned/event evidence and user confirmation;
5. run **Run All** separately;
6. treat missing appropriate pet state as environmental DEFERRED;
7. treat any Lua/secret/taint/protected-action failure as real failure.

## Key references

- `../CURRENT.md`
- `../decisions/D-044_CLASS_PET_SPECIAL_CONTROL_SOURCE_AND_FALLBACK_POLICY.md`
- `../evidence/P0151_P0150_CLASS_PET_SPECIAL_RUNTIME_PASS_2026-10-05.md`
- `../evidence/P0150_INITIAL_RUNTIME_FAIL_2026-10-05.md`
- `../investigations/FUTURE_CLASS_PET_SPECIAL_CONTROL_CAPABILITY.md`
- `../patches/P0151_RECORD_P0150_RUNTIME_PASS.md`
- `../patches/P0150_CLASS_PET_SPECIAL_CONTROL_READ_ONLY_PROBE.md`
- `../architecture/VISUAL_IMPLEMENTATION_STATUS.md`
- `../roadmap/PHASE_H_INTEGRATION_POLISH.md`
