---
memory_schema: 1
as_of: 2026-10-07
project: logres
---

# Current State

## Active Objective

**Execute Phase H integration-first: safe Blizzard-surface ownership/suppression, then authored layout/positions, then final whole-screen polish.**

P0162 R3 is verified durable at `4628f49e48ff67b8012fb51d4b80e5d8638c6c28` on runtime `0.0.81-dev` and is runtime-accepted for the bounded reactive mouse-wheel gate.

Phase G is complete for the scope Logres currently claims. Naturally unavailable captured contexts remain explicit environmental deferrals rather than fabricated PASSes.

## Current Work Item

**P0164 — Phase H.1 stock-surface ownership/suppression audit.**

The first Phase H slice is an evidence audit, not a blanket hide pass. For each Blizzard surface visible in the current product composition, classify:
- the information/control functions Blizzard currently supplies;
- the Logres replacement, if any;
- runtime proof for that replacement;
- restoration/fail-open coverage;
- whether suppression is safe now, must remain stock, or is deferred.

Do not add new runtime suppression in the audit itself. The audit must identify the first narrow suppression/coexistence slice that is already fully replacement- and restoration-proven.

## Verified State

P0162 runtime acceptance on `0.0.81-dev`, loadCount `193`, client `1.60.1.70245`:
- base Camera Profile Check PASS;
- separate Run All PASS;
- reactive ownership active/hooked with `OutQuad`;
- after wheel exercise: `wheel=36`, `quick=9`, `resets=2`, `native=4`, `corrections=15`;
- same-context City manual zoom remained around `11.10` rather than snapping back to the City entry target `5`;
- OFF/ON cycle recorded reactive `release=1`, then `acquire=2` with hook restored;
- user confirmed ordinary Blizzard wheel zoom remained usable while Camera Profile was OFF;
- reactive hook conflicts `0`, secret skips `0`, failures `0`;
- final integrated Run All completed cleanly.

Classification:
**P0162 RUNTIME PASS. PHASE G COMPLETE FOR CLAIMED OBSERVED SCOPE.**

Phase G environmental deferrals preserved:
- Hearth/Teleport;
- NPC Interaction;
- Fishing;
- Gathering;
- AFK priority behavior not naturally observed.

DynamicCam UI fading is not a missing Camera-engine requirement; it remains Phase H presentation/suppression policy.

## Next Action

Begin P0164 by auditing the real current Blizzard/Logres coexistence surface-by-surface. Produce a durable ownership matrix and select the first safe suppression slice from already-proven capability/restoration evidence.

Keep stock fallbacks for every incomplete domain. In particular, do not remove the stock minimap, Party/CompactPartyFrame, target aura/status, target-of-target, PetFrame/PetActionBar, unsupported class/resource/special controls, alternate power, RuneFrame, TotemFrame, or vehicle/override/possess surfaces without their separate replacement gates.

## Success Criteria

P0164 succeeds when:
- every candidate Blizzard surface is classified as `SUPPRESSIBLE NOW`, `KEEP STOCK`, or `DEFERRED` with evidence;
- every `SUPPRESSIBLE NOW` entry names its complete Logres information/control replacement and restoration/fail-open path;
- existing intentional suppression is distinguished from new Phase H suppression work;
- no incomplete information/control surface is removed by inference;
- the audit identifies one narrow next runtime slice rather than a blanket UI mutation;
- durable memory and the Phase H roadmap remain synchronized.

## Do Not Reopen Without New Evidence

- P0162 reactive mouse-wheel zoom is accepted for the tested bounded scope;
- P0161 Taxi/settings/shoulder-offset behavior is accepted for observed scope;
- P0160 source-backed Taxi zoom convergence is accepted;
- no conventional player health bar;
- PvP is a modifier, not Immersion OFF;
- no arbitrary/global max-distance ownership beyond the captured City override;
- no periodic Camera context polling;
- no DynamicCam UI fade as Camera-engine behavior;
- stock minimap, Party/CompactPartyFrame, target aura/status, target-of-target, PetFrame/PetActionBar, unsupported class/special surfaces, and special-control fallbacks remain until separately replaced;
- player harmful/urgent and populated target aura production remain deferred;
- positive world-target nameplate attachment remains deferred;
- individual tracking-result positions remain source-blocked by D-043.

## Relevant References

- `docs/memory/evidence/P0163_P0162_RUNTIME_PASS_2026-10-07.md`
- `docs/memory/patches/P0163_PHASE_G_CLOSURE.md`
- `docs/memory/patches/P0162_REACTIVE_MOUSE_WHEEL_ZOOM.md`
- `docs/memory/investigations/G6_DYNAMICCAM_PROFILE_PARITY.md`
- `docs/memory/architecture/CAMERA.md`
- `docs/memory/roadmap/PHASE_G_CINEMATIC_CAMERA.md`
- `docs/memory/roadmap/PHASE_H_INTEGRATION_POLISH.md`
- `docs/memory/roadmap/STATUS.md`
- `docs/memory/patches/P0158_SEQUENCE_CAMERA_INTEGRATION_POLISH.md`
- `docs/ROADMAP.md`
