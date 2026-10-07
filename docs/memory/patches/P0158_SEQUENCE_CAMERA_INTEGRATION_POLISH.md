# P0158 — Sequence Camera, Integration/Layout, Then Polish

Date: 2026-10-06
Baseline: `328f15431b8b3cc3f4d78d2edf4c40d987f78341`
Result: **PREPARED — DOCS / ROADMAP SEQUENCING CHECKPOINT**

## Purpose

Make active memory and both Phase G/H roadmaps consistent with the user's chosen
execution order.

## Sequence

1. **Finish the existing G.5 Taxi landing gate.**
   - one normal Taxi flight;
   - Phase G Camera World/Combat Check in flight and after landing;
   - separate Run All;
   - no broader Camera feature expansion.

2. **Phase H stock-surface suppression/coexistence.**
   - work surface by surface;
   - actually hide/suppress Blizzard presentation only where Logres already has a
     complete capability-proven replacement plus safe restoration/fail-open;
   - preserve all incomplete stock fallbacks.

3. **Phase H authored layout/positions.**
   - stable integration-owned anchors;
   - intended semantic screen regions;
   - proper default positions and realistic-density coexistence;
   - no unrestricted frame-editor product expansion.

4. **Phase H final polish/remaining visuals.**
   - whole-screen spacing/contrast/scale/opacity/ornament;
   - pet/action/health/Compass residual calibration;
   - settings/accessibility;
   - remaining visual or capability slices only when evidence supports them.

## Superseded sequencing

The earlier temporary instruction to finish the entire approved visual sequence
before returning to Camera is superseded.

The accepted visual baselines themselves are not superseded.

## Safety boundaries

P0158 does not authorize blanket Blizzard UI removal.

D-017 and all later surface-specific gates remain authoritative. In particular,
stock minimap, party/CompactParty, target aura/status, target-of-target, PetFrame,
unsupported class/special controls, alternate power, RuneFrame, TotemFrame, and
vehicle/override/possess fallbacks remain until deliberately and safely replaced.

## Runtime impact

Docs/roadmap only. No WoW runtime code changes. No redeploy required.
