---
memory_schema: 1
as_of: 2026-10-06
project: logres
---

# Current State

## Active Objective

**Complete the captured DynamicCam `RPG` camera behavior in consolidated parity layers, then enter Phase H integration/layout and final polish.**

The canonical DynamicCam profile is already stored in repository evidence. Do not request another export unless the user's profile has changed.

P0158 is verified durable at `27670624e8c001dc341ac92ad9c463f2f61088de`; its high-level order remains authoritative: Camera first, then safe stock-surface suppression/coexistence, authored positioning, then polish.

## Current Work Item

**P0159 R1 — captured-profile context + zoom parity.**

P0159 R1 consolidates the remaining source-backed context/zoom behavior rather than opening one investigation per situation:

- Taxi: existing conditional-out target `50`, entry `5s`;
- Hearth/Teleport: conditional-out target `20`, configured `5s` with ordinary/non-secret cast-duration override when available;
- AFK: priority situation with no zoom mutation;
- Gathering: conditional-in target `5`, entry `3s`;
- NPC Interaction: conditional-in target `5`, entry `2.5s`;
- World Combat: conditional-out target `15`, `2.5s`;
- Fishing: conditional-out target `50`, entry `2s`, source-defined `1s` exit hold;
- City: conditional-in target `5`, `2.5s`;
- World: conditional-in target `5`, `2.5s`.

The pinned DynamicCam source priority model is preserved. AFK and Gathering both have priority `120`; upstream selection uses `pairs()` plus strict `>`, so it exposes no stable tie-break. Logres chooses deterministic AFK-before-Gathering for the otherwise exceptional simultaneous case.

The initial P0159 delivery refused in shadow preflight before tracked writes because its renderer inserted the new context helpers and then deleted them while replacing the OnUpdate-to-Reconcile block. R1 corrects that renderer ordering and records the failure durably.

P0159 R1 does not mutate camera CVars, rotate the camera, change shoulder offset, or hide UI. Those are the second consolidated parity layer / Phase H presentation boundary, not reasons to fragment context/zoom work into more tiny patches.

## Verified State

The exact captured `RPG` profile remains canonical at:
`docs/memory/evidence/G1_DYNAMICCAM_RPG_PROFILE_2026-10-02.json`.

Current production ownership before P0159 is World, World Combat, City, and Taxi zoom. P0156 passes observed normal world entry on `0.0.77-dev`.

The normal-Taxi landing proof remains open and must still be captured in runtime evidence. P0159 retains that behavior while broadening the same controller to the other enabled profile situations.

Pinned DynamicCam source at `ae586a9c973c3f868c10440358d4a6e8c2fab5ff` resolves the remaining predicates and priority order. No new profile export or speculative polling is required.

Camera is **not considered complete after P0159**. The next consolidated Camera layer is rotation / shoulder / camera-setting ownership and restoration. DynamicCam-style UI fades are presentation policy and will be reconciled with the Phase H suppression/coexistence pass instead of copied as an unsafe side effect.

## Next Action

Apply and deploy P0159 R1, then validate through the developer panel:

1. `/reload`.
2. Phase G -> **Camera Profile Check**.
3. Phase 0 -> **Run All** separately.
4. Take one normal Taxi flight.
5. During the flight: Phase G -> **Camera Profile Check**.
6. After landing and settling: Phase G -> **Camera Profile Check** again.
7. Upload refreshed `LOGRES_DIAGNOSTICS_LATEST.lua`.

Naturally encountered Teleport, AFK, Gathering, NPC Interaction, and Fishing contexts should also be retained as runtime evidence when they occur. Do not require contrived travel/crafting solely to force every context in this checkpoint.

If the base/Taxi path is clean, record P0159 and proceed directly to the consolidated rotation/shoulder/camera-setting parity layer rather than returning to tiny per-situation investigations.

## Success Criteria

P0159 succeeds when:
- the controller represents all nine enabled captured-profile situations with the pinned source priority model;
- Teleport/Gathering/Fishing source reads are secret-safe and never inspect secret values;
- AFK is a real priority context without inventing a zoom mutation;
- Fishing's source-defined one-second exit delay is implemented without a polling ticker or timer;
- high-out targets retain requested DynamicCam values while respecting the observed engine distance ceiling without `SetCVar`;
- existing World/Combat/City/Taxi behavior and DynamicCam coexistence remain fail-open;
- developer diagnostics expose profile predicate health, secret skips, read failures, and the fishing hold;
- full static checker suite and `git diff --check` pass;
- runtime validation reports no Lua, taint, protected-action, secret-value, or camera ownership failure in the tested scope.

## Do Not Reopen Without New Evidence

- no conventional player health bar;
- no camera max-distance CVar mutation in P0159;
- no rotation, shoulder-offset mutation, reactive-zoom ownership, or DynamicCam UI fade in P0159;
- no periodic camera/context polling;
- P0152 pet execution/state presentation remains accepted; PetActionBar suppression remains separately gated;
- stock minimap, party/CompactPartyFrame, target aura/status, target-of-target, and unsupported class/special surfaces remain available until their replacement gates are satisfied;
- player harmful/urgent and populated target aura production remain deferred;
- positive world-target nameplate attachment remains deferred;
- individual tracking-result positions remain source-blocked by D-043;
- possess/override/vehicle/extra-action surfaces remain separate domains.

## Relevant References

- `docs/memory/evidence/G6_DYNAMICCAM_PROFILE_PARITY_AUDIT_2026-10-06.md`
- `docs/memory/evidence/P0159_INITIAL_SHADOW_PREFLIGHT_FAIL_2026-10-06.md`
- `docs/memory/investigations/G6_DYNAMICCAM_PROFILE_PARITY.md`
- `docs/memory/patches/P0159_DYNAMICCAM_PROFILE_CONTEXT_ZOOM_PARITY.md`
- `docs/memory/evidence/G1_DYNAMICCAM_RPG_PROFILE_2026-10-02.json`
- `docs/memory/evidence/G1_DYNAMICCAM_PROFILE_CAPTURE_2026-10-02.md`
- `docs/memory/architecture/CAMERA.md`
- `docs/memory/roadmap/PHASE_G_CINEMATIC_CAMERA.md`
- `docs/memory/patches/P0158_SEQUENCE_CAMERA_INTEGRATION_POLISH.md`
- `docs/memory/roadmap/STATUS.md`
- `docs/ROADMAP.md`
