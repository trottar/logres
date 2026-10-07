# Current Handoff

Authoritative state:
`../CURRENT.md`.

Latest verified durable checkpoint:
P0162 R3 `4628f49e48ff67b8012fb51d4b80e5d8638c6c28` / `0.0.81-dev`.

## P0162 runtime acceptance

Observed bounded reactive-zoom gate:
- Camera Profile Check PASS;
- separate Run All PASS;
- reactive `active=true`, `hooked=true`, `easing=OutQuad`;
- final wheel diagnostics `wheel=36`, `quick=9`, `resets=2`, `native=4`, `corrections=15`;
- same-context manual City zoom persisted near `11.10` instead of snapping back to `5`;
- OFF/ON cycle recorded `release=1`, then `acquire=2`;
- user confirmed native Blizzard wheel zoom worked while Camera Profile was OFF;
- conflicts `0`, secret skips `0`, failures `0`;
- final Run All clean.

Classification:
**P0162 RUNTIME PASS. PHASE G COMPLETE FOR CLAIMED OBSERVED SCOPE.**

Environmental deferrals remain Hearth/Teleport, NPC Interaction, Fishing, Gathering, and unobserved AFK priority behavior. They are not failures and should not be manufactured solely for proof.

## P0163

P0163 is a docs-only Phase G closure checkpoint. It records P0162 runtime acceptance, closes G.6/Phase G for the claimed observed scope, preserves all environmental deferrals and delivery failures, and makes Phase H primary.

No WoW redeploy is required for P0163.

## Exact next work item

**P0164 — Phase H.1 stock-surface ownership/suppression audit.**

Audit the current in-client Blizzard/Logres coexistence surface-by-surface. Classify each candidate as suppressible now, keep stock, or deferred from existing capability/restoration evidence. Do not add new runtime suppression in the audit itself.

The audit must preserve stock minimap, Party/CompactPartyFrame, target aura/status, target-of-target, PetFrame/PetActionBar, unsupported class/resource/special surfaces, alternate power, RuneFrame, TotemFrame, and vehicle/override/possess fallbacks until their own replacement gates are satisfied.

## Key references

- `../CURRENT.md`
- `../evidence/P0163_P0162_RUNTIME_PASS_2026-10-07.md`
- `../patches/P0163_PHASE_G_CLOSURE.md`
- `../patches/P0162_REACTIVE_MOUSE_WHEEL_ZOOM.md`
- `../roadmap/PHASE_G_CINEMATIC_CAMERA.md`
- `../roadmap/PHASE_H_INTEGRATION_POLISH.md`
- `../architecture/CAMERA.md`
