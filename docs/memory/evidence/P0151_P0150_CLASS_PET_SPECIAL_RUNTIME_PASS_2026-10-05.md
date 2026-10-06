# P0151 — P0150 Class / Pet / Special Runtime Result

Date: 2026-10-05
Runtime: `0.0.73-dev`
Verified implementation commit: `46e06295695587af07f6f3e1b4a6ac4ace4e4c15`
Client: `1.60.1.70235`
Classification: **RUNTIME PASS FOR OBSERVED READ-ONLY SCOPE WITH ENVIRONMENTAL DEFERRALS**

## Context

P0150 added the bounded, non-mutating `ClassPetSpecialProbe` after the P0149 / D-044 source audit.

The initial `0.0.73-dev` run reached all required APIs/events but failed on a diagnostic assumption: six pet rows returned numeric `GetPetActionInfo(...).isToken` values while the probe required boolean. R3 corrected only that diagnostic interpretation and preserved ordinary `false` special-mode values in the summary.

The R1 and R2 delivery artifacts both refused before tracked writes and are preserved as artifact-validation history in the P0150 patch record.

## Accepted runtime evidence

The corrected P0150 R3 run reported:

- `PASS`;
- `events=22/22`;
- `api=secret:true`;
- `required:true`;
- `missing:nil`;
- `failures=0`;
- pet action bar present;
- 10 pet slots scanned / 7 occupied;
- 2 active pet actions;
- 1 autocast-allowed and 1 autocast-enabled pet action;
- all 10 pet slots reported usable in the observed state;
- pet-domain failures `0`;
- stance/form count `0` -> environmental DEFERRED;
- 8 totem slots scanned / 0 active -> environmental DEFERRED;
- player class `WARLOCK`;
- selected discrete resource `SoulShards` with observed `0/0` values;
- one primary-power value safely secret-skipped;
- resource-domain failures `0`;
- DK runes not applicable -> environmental DEFERRED;
- possess/vehicle/override/temp-shapeshift/extra-action flags all ordinary `false`;
- total secret skips `1`;
- total failures `0`.

A separate integrated `Run All` completed cleanly on the same `0.0.73-dev` load after the manual probe.

No Lua, taint, protected-action, mutation, or Blizzard-presentation failure was observed in the tested scope.

## Environmental deferrals

This run does **not** prove populated behavior for:

- stance/forms;
- active totems or totem dismissal;
- Death Knight runes;
- active possess/vehicle/override/temp-shapeshift/extra-action modes;
- a meaningful nonzero class-resource presentation range.

Those branches remain DEFERRED. They are not failures and should not be manufactured solely to advance sequencing.

## Source continuity to client build 70235

P0149 / D-044 originally pinned Forever source commit
`e3ecc27b64d30fdc735a3f6579b866858f9f9df1` (`1.60.1.70205`).

The runtime client used for the accepted P0150 R3 result is `1.60.1.70235`.
Matching Forever source is:

`Gethe/wow-ui-source@a84e2b1b41d3d4137127c07e4da448aa3251d6f1`.

That commit is the direct child of the audited 70205 commit and changes only `version.txt` from `1.60.1.70205` to `1.60.1.70235`.

The audited source files central to the next pet-control slice are byte-identical across those two commits:

- `Blizzard_FrameXML/SecureTemplates.lua`: blob `66f203e31a819f383ea3c6920be8d4f6556848eb` at both commits;
- `Blizzard_ActionBar/Shared/PetActionBar.lua`: blob `1857b3a84a94668ae86743d17f6f501d0cfe3161` at both commits.

Therefore D-044's pet secure-action source finding remains source-continuous for the current 70235 client.

## Result / next justified slice

P0150 is accepted for the observed read-only scope.

The strongest naturally populated domain is pet actions. Runtime now proves the ordinary bounded pet read path on the current client, while D-044 plus matching 70235 source establishes the secure `type="pet"` execution path as the narrowest control candidate.

Next: **P0152 bounded secure pet-action execution probe**.

P0152 must retain the Blizzard PetActionBar and must not claim full replacement completeness. It may prove user-triggered secure pet-action execution only. Autocast mutation, drag/reorder/edit, key routing/bindings, full feedback completeness, suppression, and exact restoration remain separate gates.
