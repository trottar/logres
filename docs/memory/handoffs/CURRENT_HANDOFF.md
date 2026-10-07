# Current Handoff

Authoritative state:
`../CURRENT.md`.

Latest verified durable checkpoint:
P0158 `27670624e8c001dc341ac92ad9c463f2f61088de`.

## Camera direction

The canonical DynamicCam `RPG` profile is already captured. Do not request another export unless the user changed it.

The user explicitly chose to complete Camera parity before Phase H. P0158's high-level order remains:

1. Camera parity;
2. safe Blizzard suppression/coexistence;
3. authored UI positions/layout;
4. final polish and remaining visuals.

The previous interpretation that Camera meant only the pending Taxi landing proof is superseded.

## P0159 R1

The initial P0159 artifact refused during shadow preflight before tracked writes. Its renderer deleted the just-inserted context-helper block while replacing the OnUpdate-to-Reconcile range. R1 fixes that exact delivery defect and hardens the checker against recurrence.

P0159 R1 is one consolidated context/zoom parity layer for all nine enabled captured situations.

New source-backed predicates:
- Hearth/Teleport;
- AFK;
- Gathering;
- NPC Interaction;
- Fishing.

Existing:
- Taxi;
- World Combat;
- City;
- World.

No CVar mutation, rotation, shoulder mutation, or UI fade is added in P0159.

Fishing's upstream `delay=1` is an **exit hold**, implemented through the controller's existing finite OnUpdate activity rather than a timer/ticker.

## Runtime gate

After P0159 R1 deployment:

1. `/reload`;
2. Phase G -> **Camera Profile Check**;
3. Phase 0 -> **Run All**;
4. one normal Taxi flight;
5. Phase G -> **Camera Profile Check** during flight;
6. Phase G -> **Camera Profile Check** after landing/settle;
7. upload diagnostics.

Other profile contexts may be recorded when naturally encountered; do not manufacture every environment just to advance.

If clean, proceed to the second consolidated Camera parity layer: rotation, shoulder behavior, and camera-setting ownership/restoration. DynamicCam UI fades are reconciled with Phase H presentation/suppression policy.

## Key references

- `../CURRENT.md`
- `../evidence/G6_DYNAMICCAM_PROFILE_PARITY_AUDIT_2026-10-06.md`
- `../evidence/P0159_INITIAL_SHADOW_PREFLIGHT_FAIL_2026-10-06.md`
- `../investigations/G6_DYNAMICCAM_PROFILE_PARITY.md`
- `../patches/P0159_DYNAMICCAM_PROFILE_CONTEXT_ZOOM_PARITY.md`
- `../evidence/G1_DYNAMICCAM_RPG_PROFILE_2026-10-02.json`
- `../architecture/CAMERA.md`
- `../roadmap/PHASE_G_CINEMATIC_CAMERA.md`
