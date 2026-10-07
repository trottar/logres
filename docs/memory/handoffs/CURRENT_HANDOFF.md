# Current Handoff

Authoritative state:
`../CURRENT.md`.

Latest verified durable checkpoint:
P0157 R2 `328f15431b8b3cc3f4d78d2edf4c40d987f78341`.

## Current sequence

The execution order is now explicit:

1. finish the existing bounded G.5 normal-Taxi landing retest;
2. enter Phase H with stock-surface ownership/suppression and coexistence first;
3. establish the authored whole-screen layout and proper UI positions;
4. then perform final polish, residual visuals, and settings/accessibility work.

This supersedes the older temporary sequencing statement that all approved visual translation must finish before Camera resumes.

## Current Camera state

P0156 `e1be731b` / `0.0.77-dev` passes observed normal world entry.

The only current Camera gate is the pre-existing P0119 Taxi landing proof:
- during one normal Taxi flight: Phase G -> Camera World/Combat Check;
- after landing/settle: Phase G -> Camera World/Combat Check again;
- destination City/World must converge near target `5`, not `0`;
- failures=0, secret=false, error=nil;
- Phase 0 -> Run All separately;
- upload diagnostics.

No broader Camera feature expansion is authorized by this sequence.

## Phase H entry rule

"Hiding the UI" is not blanket suppression.

The first Phase H integration pass must work surface by surface:
- suppress/hide only where Logres has a deliberate capability-proven replacement;
- preserve secure interaction, required information, restoration, and fail-open behavior;
- retain stock minimap, party/CompactParty, target aura/status, target-of-target, unsupported class/special controls, and other incomplete fallbacks until their replacement gates are satisfied.

Once coexistence/suppression is correct, integration owns the authored anchors and final default positions. Polish follows that stable composition rather than preceding it.

## Key references

- `../CURRENT.md`
- `../patches/P0158_SEQUENCE_CAMERA_INTEGRATION_POLISH.md`
- `../roadmap/PHASE_G_CINEMATIC_CAMERA.md`
- `../roadmap/PHASE_H_INTEGRATION_POLISH.md`
- `../architecture/WORLD_FIRST_LAYOUT.md`
- `../architecture/VISUAL_IMPLEMENTATION_STATUS.md`
- `../decisions/D-017_BLIZZARD_UI_SUPPRESSION_AND_RESTORATION.md`
