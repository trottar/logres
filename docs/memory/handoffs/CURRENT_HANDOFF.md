# Current Handoff

Authoritative state:
`../CURRENT.md`.

Latest verified durable checkpoint:
P0148 `6f381a77f857cb9305cf6870fc2621e6aff826dc`.

Current pushed/tested runtime:
`0.0.72-dev`.

## Active work stream

**P0149 — class/pet/special-control source-capability audit; docs/source evidence only.**

P0148 is runtime + visual PASS for the manual-waypoint depth baseline. Live-radius
bands remain `0.5R / 1R / 4R / 8R`; the accepted production anchors are
`1.20 / 1.05 / 0.85 / 0.70`, with later amplitude refinement deferred to
whole-interface polish.

P0149 pins exact Forever source
`Gethe/wow-ui-source@e3ecc27b64d30fdc735a3f6579b866858f9f9df1`
(`1.60.1.70205`) and accepts D-044.

Key source policy:
- pet actions have source-proven secure `type="pet"` casting, but stock autocast,
  drag/reorder, bindings, and restoration remain separate completeness gates;
- stance/form state is readable but secure replacement ownership remains unproven;
- totem and class-power sources are secret-capable and require secret-first runtime proof;
- runes/combo points/shards/charges/holy power/essence remain discrete class mechanics;
- PetFrame is a separate secure unit-frame surface;
- possess/override/vehicle/extra-action remain Blizzard special-mode surfaces and
  are not ordinary Secondary/Utility routing.

No P0149 runtime code or stock suppression is authorized.

After P0149 is durable, P0150 is a bounded read-only runtime probe for naturally
available pet/stance/totem/class-resource/special-mode states. Environmental
absence remains DEFERRED.

Quest/current-navigation, AreaPOI/service, tracking-result, and minimap ownership
boundaries remain unchanged. Camera remains frozen; P0119 Taxi landing proof is
still pending.

## Key references

- `../CURRENT.md`
- `../evidence/P0149_P0148_WAYPOINT_DEPTH_RUNTIME_VISUAL_PASS_2026-10-05.md`
- `../evidence/P0149_CLASS_PET_SPECIAL_CONTROL_SOURCE_CAPABILITY_AUDIT_2026-10-05.md`
- `../decisions/D-044_CLASS_PET_SPECIAL_CONTROL_SOURCE_AND_FALLBACK_POLICY.md`
- `../investigations/FUTURE_CLASS_PET_SPECIAL_CONTROL_CAPABILITY.md`
- `../decisions/D-026_SELECTIVE_UNIT_FRAME_SUPPRESSION.md`
- `../patches/P0149_CLASS_PET_SPECIAL_CONTROL_SOURCE_CAPABILITY_AUDIT.md`
- `../architecture/VISUAL_IMPLEMENTATION_STATUS.md`
- `../roadmap/PHASE_H_INTEGRATION_POLISH.md`
