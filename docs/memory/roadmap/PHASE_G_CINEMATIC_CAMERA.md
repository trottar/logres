# Phase G — Cinematic Camera

Status: ACTIVE — G.1
Opened: 2026-10-02

## Product Objective

Translate the user's established contextual DynamicCam behavior into Logres so
camera behavior can eventually be owned by the addon rather than a separate
profile.

## Evidence Boundary

Canonical camera architecture:
`../architecture/CAMERA.md`.

The previously uploaded DynamicCam files are not durable repository evidence.

Exact camera values must not be reconstructed from:
- assistant memory;
- chat summaries;
- old uploads;
- generic DynamicCam defaults.

Before production camera implementation, obtain the user's **current** export or
profile and preserve the relevant settings durably.

## Known Context Categories

Existing product intent includes:
- world;
- combat;
- NPC interaction;
- gathering;
- fishing;
- taxi;
- hearth/teleport;
- instance;
- possibly AFK/rest/travel contexts when actually configured.

The fresh export determines which categories and exact values are real.

## G.1 — Current DynamicCam profile capture

**ACTIVE.**

Goal:
obtain and preserve the current profile before code design.

Required work:
1. obtain the current DynamicCam export/profile;
2. preserve the raw export or a faithful derived evidence record;
3. map every enabled situation/context;
4. record exact camera values, transitions, delays, shoulder offsets, zoom,
   pitch, and other relevant behavior actually present;
5. identify disabled/unused situations separately;
6. distinguish exported facts from proposed Logres policy;
7. identify any DynamicCam behavior that depends on APIs or mechanisms needing
   Forever capability proof.

No production camera code in G.1.

## G.1 Success Criteria

- current export/profile captured;
- exact relevant values preserved in repository evidence;
- all enabled situations mapped;
- ambiguous or unsupported settings identified;
- next narrow implementation/capability question selected.

## Later Phase G Work

After G.1 evidence:
- define Logres camera ownership/state contract;
- prove required camera APIs on Forever where needed;
- implement context slices narrowly;
- preserve fail-open behavior;
- validate transitions in-client.

Exact later slice numbering is selected from the captured profile rather than
invented before evidence exists.
